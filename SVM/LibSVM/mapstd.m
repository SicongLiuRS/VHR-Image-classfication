function [out1,out2] = mapstd(in1,in2,in3,in4)
%MAPSTD Map matrix row means and deviations to standard values.
%  
%  Syntax
%
%	[y,ps] = mapstd(ymean,ystd)
%	[y,ps] = mapstd(x,fp)
%	y = mapstd('apply',x,ps)
%	x = mapstd('reverse',y,ps)
%	dx_dy = mapstd('dx',x,y,ps)
%	dx_dy = mapstd('dx',x,[],ps)
%     name = mapstd('name');
%     fp = mapstd('pdefaults');
%     names = mapstd('pnames');
%     mapstd('pcheck',fp);
%
%  Description
%  
%   MAPSTD processes matrices by tranforming the mean and standard
%   deviation of each row to YMEAN and YSTD.
%  
%	MAPSTD(X,YMEAN,YSTD) takes X and optional parameters,
%	X - NxQ matrix or a 1xTS row cell array of NxQ matrices.
%     YMEAN - Mean value for each row of Y. (Default is 0)
%     YSTD - Standard deviation for each row of Y. (Default is 1)
%	and returns,
%     Y - Each MxQ matrix (where M == N) (optional).
%     PS - Process settings, to allow consistent processing of values.
%
%   MAPSTD(X,FP) takes parameters as struct: FP.ymean, FP.ystd.
%   MAPSTD('apply',X,PS) returns Y, given X and settings PS.
%   MAPSTD('reverse',Y,PS) returns X, given Y and settings PS.
%   MAPSTD('dx',X,Y,PS) returns MxNxQ derivative of Y w/respect to X.
%   MAPSTD('dx',X,[],PS)  returns the derivative, less efficiently.
%   MAPSTD('name') returns the name of this process method.
%   MAPSTD('pdefaults') returns default process parameter structure.
%   MAPSTD('pdesc') returns the process parameter descriptions.
%   MAPSTD('pcheck',fp) throws an error if any parameter is illegal.
%    
%	Examples
%
%   Here is how to format a matrix so that the minimum and maximum
%   values of each row are mapped to default mean and std of 0 and 1.
%	
%     x1 = [1 2 4; 1 1 1; 3 2 2; 0 0 0]
%     [y1,ps] = mapstd(x1)
%
%   Next, we apply the same processing settings to new values.
%
%     x2 = [5 2 3; 1 1 1; 6 7 3; 0 0 0]
%     y2 = mapstd('apply',x2,ps)
%
%   Here we reverse the processing of y1 to get x1 again.
%
%     x1_again = mapstd('reverse',y1,ps)
%
%  Algorithm
%
%     It is assumed that X has only finite real values, and that
%     the elements of each row are not all equal.
%
%     y = (x-xmean)*(ystd/xstd) + ymean;
%
%  See also MAPMINMAX, FIXUNKNOWNS, PROCESSPCA, REMOVECONSTANTROWS

% Copyright 1992-2007 The MathWorks, Inc.
% $Revision: 1.1.6.9.4.1 $

% Process function boiler plate script
%boiler_process
if (nargin < 1), error('NNET:Arguments','Not enough arguments.'); end %#ok<FINS>

if isstr(in1) %#ok<DISSTR>
  switch lower(in1)
    case 'name',
      if nargin > 1, error('NNET:Arguments','Too many input arguments for ''name'' action'), end %#ok<FINS>
      if (nargout > 1), error('NNET:Arguments','Too many output arguments for ''name'' action'), end %#ok<FINS>
      out1 = name;
    case 'pdefaults'
      if nargin > 2, error('NNET:Arguments','Too many input arguments for ''pdefaults'' action'), end %#ok<*FINS>
      if nargin < 2, in2 = {}; end
      if (nargout > 1), error('NNET:Arguments','Too many output arguments for ''pdefaults'' action'), end
      out1 = param_defaults(in2);
    case 'pnames'
      if nargin > 1, error('NNET:Arguments','Too many input arguments for ''pnames'' action'), end
      if (nargout > 1), error('NNET:Arguments','Too many output arguments for ''pnames'' action'), end
      out1 = param_names;
    case 'pcheck'
      if (nargin < 2), error('NNET:Arguments','Not enough input arguments for ''pcheck'' action'), end
      if nargin > 2, error('NNET:Arguments','Too many input arguments for ''pcheck'' action'), end
      if (nargout > 1), error('NNET:Arguments','Too many output arguments for ''pcheck'' action'), end
      if ~isa(in2,'struct'), error('NNET:Arguments','Parameters are not a struct.'); end
      names1 = fieldnames(param_defaults({}));
      names2 = fieldnames(in2);
      if length(names1) ~= length(names2), error('NNET:Arguments','Incorrect number of parameters.'); end
      names1 = sort(names1);
      names2 = sort(names2);
      for i=1:length(names1)
        if ~strcmp(names1{i},names2{i}), error('NNET:Arguments',['Parameter field name is not correct:' names2{i}]); end
      end
      out1 = param_check(in2);
      if (nargout == 0) && ~isempty(out1)
        error('NNET:Arguments',out1);
      end
    case 'apply'
      if (nargin < 3), error('NNET:Arguments','Not enough input arguments for ''apply'' action.'); end
      if (nargin > 3), error('NNET:Arguments','Too many input arguments for ''apply'' action'), end
      if (nargout > 1), error('NNET:Arguments','Too many output arguments for ''apply'' action'), end
      c = iscell(in2);
      if c
        if (size(in2,1) ~= 1)
          error('NNET:Arguments','Cell array X must have only one row')
        end
        cols = size(in2,2);
        colSizes = zeros(1,cols);
        for i=1:cols
          colSizes(i) = size(in2{1,i},2);
        end
        in2 = cell2mat(in2);
      elseif ~isa(in2,'double')
        error('NNET:Arguments','X must be a matrix or a row cell array')
      end
      out1 = apply_process(in2,in3);
      if c
        out1 = mat2cell(out1,size(out1,1),colSizes);
      end
    case 'reverse'
      if (nargin < 3), error('NNET:Arguments','Not enough input arguments for ''reverse'' action.'); end
      if (nargin > 3), error('NNET:Arguments','Too many input arguments for ''reverse'' action'), end
      if (nargout > 1), error('NNET:Arguments','Too many output arguments for ''reverse'' action'), end
      c = iscell(in2);
      if c
        if (size(in2,1) ~= 1)
          error('NNET:Arguments','Cell array X must have only one row')
        end
        cols = size(in2,2);
        colSizes = zeros(1,cols);
        for i=1:cols,colSizes(i) = size(in2{1,i},2); end
        in2 = cell2mat(in2);
      elseif ~(isnumeric(in2) || islogical(in2))
        error('NNET:Arguments','Y must be a matrix or a row cell array')
      end
      out1 = reverse_process(in2,in3);
      if c
        out1 = mat2cell(out1,size(out1,1),colSizes);
      end
      out2 = in3;
    case 'dx'
      if (nargin < 4), error('NNET:Arguments','Not enough input arguments for ''dx'' action.'); end
      if (nargout > 1), error('NNET:Arguments','Too many output arguments for ''dx'' action'), end
      if isempty(in3)
        in3 = apply_process(in2,in4);
      end
      out1 = derivative(in2,in3,in4);
    case 'dx_dy'
      if (nargin < 4), error('NNET:Arguments','Not enough input arguments for ''dx'' action.'); end
      if (nargout > 1), error('NNET:Arguments','Too many output arguments for ''dx'' action'), end
      if isempty(in3)
        in3 = apply_process(in2,in4);
      end
      out1 = reverse_derivative(in2,in3,in4);
    case 'simulink_params'
      out1 = simulink_params(in2);
    case 'simulink_reverse_params'
      out1 = simulink_reverse_params(in2);
    otherwise
      error('NNET:Arguments',['First argument is an unrecognized action string: ' in1]);
  end
  return
end

if (nargin < 2)
  in2 = param_defaults({});
elseif isa(in2,'struct')
  if (nargin > 2),error('NNET:Arguments','Too many input arguments when second argument is parameter structure FP'), end
else
  numFields = length(fieldnames(param_defaults({})));
  if (nargin > 1 + numFields), error('NNET:Arguments','Too many input argument'), end
  values = {in2};
  if (nargin > 2), values{2} = in3; end
  if (nargin > 3) values = [values varargin]; end
  in2 = param_defaults(values);
end
err = param_check(in2);
if ~isempty(err)
  error('NNET:Arguments',err)
end
c = iscell(in1);
if c
  if (size(in1,1) ~= 1)
    error('NNET:Arguments','Cell array X must have only one row')
  end
  cols = size(in1,2);
  colSizes = zeros(1,cols);
  for i=1:cols,colSizes(i) = size(in1{1,i},2); end
  in1 = cell2mat(in1);
elseif ~isa(in1,'double')
  error('NNET:Arguments','X must be a matrix or a row cell array')
end
[out1,out2] = new_process(in1,in2); y =[]; % MATLAB BUG if [out1,y] =...
if c
  out1 = mat2cell(out1,size(out1,1),colSizes);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Name
function n = name
n = 'Map Mean and Standard Deviation';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter Defaults
function fp = param_defaults(values)

if length(values)>=1, fp.ymean = values{1}; else fp.ymean = 0; end
if length(values)>=2, fp.ystd = values{2}; else fp.ystd = 1; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter Names
function names = param_names()
names = {'Mean value for each row of Y.', 'Maximum value for each row of Y.'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter Check
function err = param_check(fp)

mn = fp.ymean;
std = fp.ystd;
if ~isa(mn,'double') || any(size(mn)~=[1 1]) || ~isreal(mn) || ~isfinite(mn)
  err = 'ymean must be a real scalar value.';
elseif ~isa(std,'double') || any(size(std)~=[1 1]) || ~isreal(std) || ~isfinite(std) || (std <= 0)
  err = 'ystd must be a postive real scalar value.';
else
  err = '';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% New Process
function [y,ps] = new_process(x,fp)

% Replace NaN with finite values in same row
rows = size(x,1);
for i=1:rows
  finiteInd = find(full(~isnan(x(i,:))),1);
  if isempty(finiteInd)
    xfinite = 0;
  else
    xfinite = x(finiteInd);
  end
  nanInd = isnan(x(i,:));
  x(i,nanInd) = xfinite;
end

ps.name = 'mapstd';
ps.xrows = size(x,1);
ps.yrows = ps.xrows;
ps.xmean = mean(x,2);
ps.xstd = std(x,0,2);
ps.ymean = fp.ymean;
ps.ystd = fp.ystd;

if any(ps.xstd == 0)
  warning('NNET:Processing','Use REMOVECONSTANTROWS to remove rows with constant values.');
end

y = apply_process(x,ps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Apply Process
function y = apply_process(x,ps)

copyQ = ones(1,size(x,2));
std = ps.xstd;
std(std == 0) = 1; % Avoid division by zero
y = (ps.ystd * (x - ps.xmean(:,copyQ))) ./ std(:,copyQ) + ps.ymean;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Reverse Process
function x = reverse_process(y,ps)

copyQ = ones(1,size(y,2));
x = (ps.xstd(:,copyQ) .* (y - ps.ymean)) / ps.ystd + ps.xmean(:,copyQ);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Derivative of Y w/respect to X
function dy_dx = derivative(x,y,ps);

Q = size(x,2);
d = diag(ps.ystd ./ ps.xstd);
dy_dx = d(:,:,ones(1,Q));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Derivative of Y w/respect to X
function dx_dy = reverse_derivative(x,y,ps);

Q = size(x,2);
d = diag(ps.xstd ./ ps.ystd);
dx_dy = d(:,:,ones(1,Q));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p = simulink_params(ps)

p = ...
  { ...
  'xmean',mat2str(ps.xmean);
  'xstd',mat2str(ps.xstd);
  'ymean',mat2str(ps.ymean);
  'ystd',mat2str(ps.ystd);
  };

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p = simulink_reverse_params(ps)

p = ...
  { ...
  'xmean',mat2str(ps.xmean);
  'xstd',mat2str(ps.xstd);
  'ymean',mat2str(ps.ymean);
  'ystd',mat2str(ps.ystd);
  };
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
