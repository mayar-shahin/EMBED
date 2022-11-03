function [Y,Th]  = Switcher(Y,Th,switch_yes,old_ind,flip_yes,flip_ind)
new_ind = [1:size(Y,1)];
if flip_yes ==1
    Y(flip_ind,:)= - Y(flip_ind,:);
    Th(:,flip_ind)= - Th(:,flip_ind);
end


if switch_yes ==1
    Y(new_ind,:)=Y(old_ind,:);
    Th(:,new_ind)=Th(:,old_ind);
end 

end

