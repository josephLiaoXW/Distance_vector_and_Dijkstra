% HW for Computer Networks in NTHU
%
% The test data "network_A.mat" was provided by the TA
% It is an adjacent matrix with non-negative cost edge 
% A simple emulation for two kinds of interior gateway protocols:
%               1. distance-vector routing protocols
%               2. link-state routing protocols (skip process reliable flooding)
% caution: There are probably some problems under some special cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('network_A.mat');
d1=A;
%% Distance Vector
%set the disconnected node as a large number (101)
d1(d1==0) = 101;
%but the self-distance is the smallest cost (0)
d1(1:101:end) = 0;
for LSP_node =1:100
    tar_seq = find(d1(LSP_node,:)<101 & d1(LSP_node,:)>0);
    for i=tar_seq
        update_inf_map = d1(i,:) > (d1(LSP_node,:)+d1(LSP_node,i));
        d1(i,update_inf_map) = d1(LSP_node,update_inf_map)+d1(LSP_node,i);
    end
end
%% Dijkstra method
d=A;
%set the disconnected node as a large number (101)
d(d==0) = 101;
for i=1:100
    topology_view = d(i,:); %% the initial topology viewed from node i
    for j=1:100
        if j==i
            continue;
        end
        count = zeros(1,100);
        count(i)=1;    % initial count table for recording the shortest node has caclulate
        min_cost=min(topology_view(count==0));
        min_node = find(topology_view==min_cost & ~count);  %% find the short distance and node which have not been calculated
        count(min_node(1)) = 1;
        topology_view(~count)= min(topology_view(~count) ,d(min_node(1),~count)+min_cost);  %% update the topology view
        while min_node(1)~=j && min(topology_view(count==0)) <101   %% calculate until count to the target node j
            min_cost=min(topology_view(count==0));
            min_node = find(topology_view==min_cost & ~count);
            count(min_node(1)) = 1;
            topology_view(~count)= min(topology_view(~count) ,d(min_node(1),~count)+min_cost);
        end
        d(i,j) = topology_view(j);
    end
end
%the self-distance is the smallest cost (0)
d(1:101:end) = 0; 