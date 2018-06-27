function matches = matchDescriptors(...
    query_descriptors, database_descriptors, lambda)


[dists,matches] = pdist2(database_descriptors', query_descriptors', 'euclidean', 'Smallest', 1);

sorted_dists = sort(dists);
sorted_dists = sorted_dists(sorted_dists~=0);
min_non_zero_dist = sorted_dists(1);

matches(dists >= lambda * min_non_zero_dist) = 0;

% remove double matches
unique_matches = zeros(size(matches));
[~,unique_match_idxs,~] = unique(matches, 'stable');
unique_matches(unique_match_idxs) = matches(unique_match_idxs);

matches = unique_matches;

end

