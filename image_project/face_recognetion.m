% Prompt the user for input
number = input('Enter a number (1: image path, 2: real time detection): ');

if number == 1
    imagePath = input('Enter the image path: ','s');
    % Load the input image and convert to grayscale
inputImage = imread(imagePath); % 'input/faces.jpg'
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
folderPath = 'faces\';

% Display the detected faces on the input image
numFaces = size(boxes, 1);
if numFaces > 0
    labels = cell(numFaces, 1);
    for i = 1:numFaces
        labels{i} = sprintf('Face %d', i);
        % Extract the current face
        face = imcrop(inputImage, boxes(i, :));
        % Save the face to the specified folder
        imwrite(face, sprintf('%sface%d.png', folderPath, i));
        % Display the segmented face
        figure;
        imshow(face);
        title(sprintf('Segmented Face %d', i));
    end
    % Display the input image with face detections
    Faces = insertObjectAnnotation(inputImage, 'rectangle', boxes, labels, 'LineWidth', 3, 'Color', 'r');
    figure;
    imshow(Faces);
    title(sprintf('Detected %d Faces', numFaces));
else
    disp('No faces detected.');
end
elseif number == 2
    % Create video input object for webcam
videoInput = videoinput('winvideo', 1, 'RGB24_640x480');

% Set video input properties
videoInput.FramesPerTrigger = 10;
videoInput.TriggerRepeat = Inf;

% Create cascade object detector
faceDetector = vision.CascadeObjectDetector();

% Start video acquisition
start(videoInput);

% Create a figure window for displaying the video
figure;

% Process video frames
while true
    % Check if video input object is running
    
    % Acquire a frame from the camera
    frame = getdata(videoInput, 1);
    % Detect faces in the frame
    bbox = step(faceDetector, frame);
    % get number of faces
    numFaces = size(bbox, 1);
    % set name for each face
    labels = cell(numFaces, 1);
    for i = 1:numFaces
        labels{i} = sprintf('Face %d', i);
    end
    % Draw bounding boxes around detected faces
    Faces = insertObjectAnnotation(frame, 'rectangle', bbox, labels, 'LineWidth', 3, 'Color', 'r');
    % Display the frame in the figure window
    imshow(Faces);

    % Check if the 'Esc' key is pressed to break the loop
    key = get(gcf, 'CurrentKey');
    if strcmp(key, 'escape')
        break;
    end
end

% Stop video acquisition
stop(videoInput);

% Release the video input object
delete(videoInput);
clear videoInput;

end
