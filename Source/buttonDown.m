function buttonDown(src,slider,eventdata)
    set(gcf, 'UserData', struct('buttonPressed', true));    
        currentSlice=round(get(slider,'Value'));
        % Save the current slice number to the variable
        savedSliceNumber = currentSlice;
        disp(['Current Slice Number Saved here: ', num2str(savedSliceNumber)]);
        if src.String == 'First'
        assignin('base', 'FirstSliceIndex', savedSliceNumber);
        else
        assignin('base', 'LastSliceIndex', savedSliceNumber);
        end
        set(src, 'String', 'Last ');

end