classdef (Abstract) nodeLayer
properties (Access = public)
numNodes;
weights;
end
methods(Abstract)
    function apply(inputLayer)
        
    end
end
end