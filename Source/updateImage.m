% Function to update the displayed image
function updateImage(source, ~)
    currentImageIndex = round(source.Value);
    set(hImg, 'CData', imageQueue{currentImageIndex});
end
