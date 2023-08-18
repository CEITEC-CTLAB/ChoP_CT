function saveNumber(slider,eventdata)
   
        currentSlice=round(get(slider,'Value'));
        % Save the current slice number to the variable
        savedSliceNumber = currentSlice;
        disp(['Current Slice Number Saved: ', num2str(savedSliceNumber)]);
       
    
end