function [Sim,srednee,sigma,SSS,STD] = score_gmm_trials(models, testFiles, trials, ubmFilename, M_llr,S_llr)
% computes the log-likelihood ratio of observations given the UBM and
% speaker-specific (MAP adapted) models. 
%
% Inputs:
%   - models      : a cell array containing the speaker specific GMMs 
%   - testFiles   : a cell array containing feature matrices or file names
%   - trials      : a two-dimensional array with model-test verification
%                   indices (e.g., (1,10) means model 1 against test 10)
%   - ubmFilename : file name of the UBM or a structure containing 
%					the UBM hyperparameters that is,
%					(ubm.mu: means, ubm.sigma: covariances, ubm.w: weights)
%
% Outputs:
%   - llr		  : log-likelihood ratios for all trials (one score per trial)
%
%
% Omid Sadjadi <s.omid.sadjadi@gmail.com>
% Microsoft Research, Conversational Systems Research Center

if ~iscell(models)
    error('Oops! models should be a cell array of structures!');
end

if ischar(ubmFilename)
	tmp = load(ubmFilename);
	ubm = tmp.gmm;
elseif isstruct(ubmFilename)
	ubm = ubmFilename;
else
	error('oh dear! ubmFilename should be either a string or a structure!');
end

% if iscellstr(testFiles)
%     tlen = length(testFiles);
%     tests = cell(tlen, 1);
%     for ix = 1 : tlen
%         tests{ix} = htkread(testFiles{ix});
%     end
% else
  if iscell(testFiles)
    tests = testFiles;
  else
    error('Oops! testFiles should be a cell array!');
  end

% ntrials = size(trials, 1);
ntrials = prod(trials);
% llr = cell(ntrials, 1);
%  dispers = zeros(ntrials, 1);
srednee = zeros(ntrials, 1);
% tr=1;
gmm_all=models{1};
fea_all=tests;
ubm_mu=ubm.mu;
ubm_sigma=ubm.sigma;
ubm_w=ubm.w(:);

  parfor tr = 1 : ntrials
% for tr = 1 : ntrials,

    gmm = gmm_all;
    
    fea = fea_all{tr};
    
    if ~isempty(fea)
    ubm_llk = compute_llk(fea, ubm_mu, ubm_sigma, ubm_w);
    gmm_llk = compute_llk(fea, gmm.mu, gmm.sigma, gmm.w(:));
    srednee(tr) = mean(gmm_llk - ubm_llk);
    sig(tr) = std(gmm_llk - ubm_llk);
    STD=std(gmm_llk - ubm_llk);
    sigma(tr) = mean(((gmm_llk - ubm_llk)-(M_llr))./S_llr);
    % figure();
     %   plot((gmm_llk - ubm_llk));
       % figure();
        %histogram((gmm_llk - ubm_llk),10)
       if srednee(tr)>0
       
         dy = gmm_llk - ubm_llk;
         nC=size(dy,2);
         Id1 = find(dy>0);  
         Idx = numel(Id1);
         Sim(tr) = 100*Idx/nC;
         
       else
         Sim(tr) = 0;
%        dispers(tr)=0;
       end
    else
        srednee(tr)=0;
        sigma(tr)=0;
        Sim(tr) =0;
%       dispers(tr)=0;
%       llr{tr} = gmm_llk - ubm_llk;
    end
  end
  SSS=mean(srednee);
  STD=mean(sig);

function llk = compute_llk(data, mu, sigma, w)
% compute the posterior probability of mixtures for each frame
post = lgmmprob(data, mu, sigma, w);
llk  = logsumexp(post, 1);

function logprob = lgmmprob(data, mu, sigma, w)
% compute the log probability of observations given the GMM
ndim = size(data, 1);
C = sum(mu.*mu./sigma) + sum(log(sigma));
D = (1./sigma)' * (data .* data) - 2 * (mu./sigma)' * data  + ndim * log(2 * pi);
logprob = -0.5 * (bsxfun(@plus, C',  D));
logprob = bsxfun(@plus, logprob, log(w));

function y = logsumexp(x, dim)
% compute log(sum(exp(x),dim)) while avoiding numerical underflow
xmax = max(x, [], dim);
y    = xmax + log(sum(exp(bsxfun(@minus, x, xmax)), dim));
ind  = find(~isfinite(xmax));
if ~isempty(ind)
    y(ind) = xmax(ind);
end
