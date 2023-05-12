% Load the input image and convert to grayscale
inputImage = imread('C:\Users\DELL\Downloads\faces.png');
inputImage = rgb2gray(inputImage);

% Enhance the image using adaptive histogram equalization
inputImage = adapthisteq(inputImage);

% Apply median filtering to remove noise
inputImage = medfilt2(inputImage);

% Resize the input image to a maximum width of 500 pixels
maxWidth = 500;
[height, width, ~] = size(inputImage);
if width > maxWidth
    scaleFactor = maxWidth / width;
    inputImage = imresize(inputImage, scaleFactor);
end

% Create a face detector object and detect faces in the input image
faceDetector = vision.CascadeObjectDetector;
boxes = step(faceDetector, inputImage);

% Specify the folder path to save the segmented faces
folderPath = 'C:\Users\DELL\image_project\faces\';

% Display the detected faces on the input image
numFaces = size(boxes, 1);
if numFaces > 0
    labels = cell(numFaces, 1);
    for i = 1:numFaces
        labels{i} = sprintf('Face %d', i);
        % Extract the current face
        face = imcrop(inputImage, bboxes(i, :));
        % Save the face to the specified folder
        imwrite(face, sprintf('%sface%d.png', folderPath, i));
        % Display the segmented face
        figure;
        imshow(face);
        title(sprintf('Segmented Face %d', i));
    end
    % Display the input image with face detections
    Faces = insertObjectAnnotation(inputImage, 'rectangle', bboxes, labels, 'LineWidth', 3, 'Color', 'r');
    figure;
    imshow(Faces);
    title(sprintf('Detected %d Faces', numFaces));
else
    disp('No faces detected.');
end
