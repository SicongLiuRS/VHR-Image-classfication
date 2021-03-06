function [out1,out2] = removeconstantrows(in1,in2,in3,in4)
%REMOVECONSTANTROWS Remove matrix rows with constant values.
%	
%	Syntax
%
%	[y,ps] = removeconstantrows(min_range)
%	[y,ps] = removeconstantrows(x,fp)
%	y = removeconstantrows('apply',x,ps)
%	x = removeconstantrows('reverse',y,ps)
%	dx_dy = removeconstantrows('dx',x,y,ps)
%	dx_dy = removeconstantrows('dx',x,[],ps)
%     name = removeconstantrows('name');
%     fp = removeconstantrows('pdefaults');
%     names = removeconstantrows('pnames');
%     removeconstantrows('pcheck',fp);
%
%	Description
%	
%	REMOVECONSTANTROWS processes matrices by removing rows with constant values.
%	
%	REMOVECONSTANTROWS(X,min_range) takes X and an optional parameter,
%	X - Single NxQ matrix or a 1xTS row cell array of NxQ matrices.
%     max_range - max range of values for row to be removed. (Default is 0)
%	and returns,
%     Y - Each MxQ matrix with N-M rows deleted (optional).
%     PS - Process settings, to allow consistent processing of values.
%
%   REMOVECONSTANTROWS(X,FP) takes parameters as struct: FP.max_range.
%   REMOVECONSTANTROWS('apply',X,PS) returns Y, given X and settings PS.
%   REMOVECONSTANTROWS('reverse',Y,PS) returns X, given Y and settings PS.
%   REMOVECONSTANTROWS('dx',X,Y,PS) returns MxNxQ derivative of Y w/respect to X.
%   REMOVECONSTANTROWS('dx',X,[],PS)  returns the derivative, less efficiently.
%   REMOVECONSTANTROWS('name') returns the name of this process method.
%   REMOVECONSTANTROWS('pdefaults') returns default process parameter structure.
%   REMOVECONSTANTROWS('pdesc') returns the process parameter descriptions.
%   REMOVECONSTANTROWS('pcheck',fp) throws an error if any parameter is illegal.
%
%	Examples
%
%   Here is how to format a matrix so that the rows with
%   constant values are removed.
%	
%     x1 = [1 2 4; 1 1 1; 3 2 2; 0 0 0]
%     [y1,ps] = removeconstantrows(x1)
%
%   Next, we apply the same processing settings to new values.
%
%     x2 = [5 2 3; 1 1 1; 6 7 3; 0 0 0]
%     y2 = removeconstantrows('apply',x2,ps)
%
%   Here we reverse the processing of y1 to get x1 again.
%
%     x1_again = removeconstantrows('reverse',y1,ps)
%
%  See also MAPMINMAX, FIXUNKNOWNS, MAPSTD, PROCESSPCA

% Copyright 1992-2007 The MathWorks, Inc.

% Mark Hudson Beale, 4-16-2002, Created

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
n = 'Remove Constants';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter Defaults
function fp = param_defaults(values)

if length(values)>=1, fp.max_range = values{1}; else fp.max_range = 0; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter Names
function names = param_names()

names = {'Maximum range of row values, for the row to be removed.'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter Check
function err = param_check(fp)

mr = fp.max_range;
if ~isa(mr,'double') || any(size(mr)~=[1 1]) || (mr < 0) || ~isreal(mr) || ~isfinite(mr)
  err = 'max_range must be 0 or greater.';
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

ps.name = 'removeconstantrows';
ps.max_range = fp.max_range;
ps.keep = 1:size(x,1);
maxx = max(x,[],2);
minx = min(x,[],2);
ps.remove = find((maxx-minx) <= ps.max_range)';
ps.keep(ps.remove) = [];
ps.value = x(ps.remove,1);
ps.xrows = size(x,1);
ps.yrows = ps.xrows - length(ps.remove);
ps.recreate = zeros(1,ps.xrows);
ps.recreate(ps.keep) = 1:length(ps.keep);
ps.recreate(ps.remove) = -(1:length(ps.remove));
ps.constants = mean(x(ps.remove,:),2);

y = apply_process(x,ps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Apply Process
function y = apply_process(x,ps)

y = x(ps.keep,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Reverse Process
function x = reverse_process(y,ps)

q = size(y,2);
x = zeros(ps.xrows,q);
x(ps.remove,:) = ps.value(:,ones(1,q));
x(ps.keep,:) = y;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Derivative of Y w/respect to X
function dy_dx = derivative(x,y,ps);

Q = size(x,2);
d = zeros(ps.yrows,ps.xrows);
for i=1:length(ps.keep)
  d(i,ps.keep(i)) = 1;
end
dy_dx = d(:,:,ones(1,Q));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Derivative of Y w/respect to X
function dx_dy = reverse_derivative(x,y,ps);

Q = size(x,2);
d = zeros(ps.yrows,ps.xrows);
for i=1:length(ps.keep)
  d(i,ps.keep(i)) = 1;
end
d = d';
dx_dy = d(:,:,ones(1,Q));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p = simulink_params(ps)

p = ...
  { ...
  'inputSize',mat2str(ps.xrows);
  'keep',mat2str(ps.keep);
  };

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p = simulink_reverse_params(ps)

p = ...
  { ...
  'inputSize',mat2str(ps.xrows);
  'constants',mat2str(ps.constants);
  'rearrange',mat2str(ps.recreate);
  };

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
