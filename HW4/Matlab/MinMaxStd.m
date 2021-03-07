function [DataStd] = MinMaxStd(data)
    data = data - min(data, [], "all"); 
    DataStd = data./max(data, [], "all"); 
end

