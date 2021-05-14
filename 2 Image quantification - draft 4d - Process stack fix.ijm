setBatchMode(true);
close("*");
if(isOpen("Results")){
	selectWindow("Results");
	run("Close");
}

//Load thresholds
threshold_file = File.openDialog("Select the threshold file:"); 
open(threshold_file);
Table.rename("Sample thresholds.csv", "Results");
dir_array = newArray(nResults);
file_array = newArray(nResults);
lower_array = newArray(nResults);
upper_array = newArray(nResults);

for(a=0; a<nResults; a++){
	dir_array[a] = getResultString("Directory", a);
	file_array[a] = getResultString("File", a);
	lower_array[a] = getResult("Lower", a);
	upper_array[a] = getResult("Upper", a);
}
selectWindow("Results");
run("Close");

out_dir = getDirectory("Please select the OUTPUT directory.");
out_list = getFileList(out_dir);

for(a=0; a<dir_array.length; a++){
	//Check if the file already has been processed
	process_file = true;
	ref_name = replace(file_array[a], "\\.[A-Za-z0-9]+$", ".txt");
	for(b=0; b<out_list.length; b++){
		if(matches(out_list[b], "Result stack - " + ref_name)){
			process_file = false;
			break;
		}
	}

	//Process the file if it has not yet been processed
	if(process_file){
		close("*");
		if(isOpen("Results")){
			selectWindow("Results");
			run("Close");
		}
		run("Bio-Formats Importer", "open=[" + dir_array[a] + file_array[a] + "] autoscale color_mode=Default concatenate_series open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		rename(file_array[a]);
		i = getTitle();
		trackNuclei(lower_array[a], upper_array[a]);
		measurePI();
		measureBacteria();
		title = replace(i, "\\.[A-Za-z0-9]+$", ""); //replace file extension
		selectWindow("Result_stack");
		saveAs("tiff", out_dir + "Result stack - " + title);
		selectWindow("Watershed_Stack");
		saveAs("tiff", out_dir + "Watershed stack - " + title);
		close("*");
		if(isOpen("Results")){
			selectWindow("Results");
			run("Close");
		}
	}
}

setBatchMode("exit and display");
exit();

function trackNuclei(lower, upper){
	selectWindow(i);
	run("Duplicate...", "title=test duplicate");
	
	r_array = newArray(0, 231, 25, 27, 112, 89, 53, 77, 155, 153, 91, 19, 25, 135, 187, 40, 52, 39, 147, 72, 92, 23, 5, 202, 52, 50, 108, 66, 238, 46, 136, 8, 162, 126, 75, 60, 135, 167, 136, 244, 161, 204, 158, 112, 192, 2, 98, 207, 233, 121, 191, 18, 210, 151, 252, 155, 139, 42, 188, 170, 127, 151, 38, 16, 227, 120, 137, 2, 72, 71, 214, 130, 194, 96, 102, 33, 92, 47, 211, 226, 237, 132, 244, 45, 82, 73, 239, 198, 118, 191, 170, 238, 177, 246, 66, 5, 44, 3, 18, 40, 226, 94, 130, 216, 68, 89, 150, 40, 96, 155, 95, 5, 132, 88, 124, 241, 143, 15, 1, 220, 46, 220, 216, 155, 190, 4, 98, 33, 142, 153, 185, 61, 153, 160, 164, 102, 75, 8, 26, 231, 160, 245, 119, 69, 95, 137, 232, 249, 89, 220, 54, 3, 43, 134, 172, 31, 106, 234, 132, 1, 29, 65, 12, 107, 52, 196, 95, 165, 4, 101, 124, 240, 203, 50, 142, 231, 5, 23, 43, 198, 41, 80, 66, 232, 86, 151, 126, 51, 122, 111, 162, 192, 148, 210, 5, 251, 40, 176, 32, 2, 22, 91, 180, 31, 218, 9, 10, 178, 27, 115, 54, 199, 163, 10, 180, 222, 102, 198, 202, 220, 96, 145, 237, 127, 172, 51, 64, 47, 84, 37, 196, 147, 244, 206, 244, 43, 170, 186, 162, 157, 125, 230, 212, 140, 186, 127, 12, 48, 0, 92, 168, 73, 228, 121, 248, 255);
	g_array = newArray(0, 217, 131, 18, 66, 198, 59, 170, 108, 8, 167, 207, 248, 138, 215, 204, 95, 249, 102, 66, 1, 138, 71, 33, 209, 80, 72, 87, 129, 24, 200, 98, 16, 160, 47, 1, 224, 49, 126, 41, 235, 205, 84, 249, 222, 125, 5, 58, 90, 137, 73, 98, 109, 167, 91, 106, 68, 23, 10, 241, 51, 35, 77, 112, 243, 235, 53, 41, 21, 134, 106, 60, 231, 107, 124, 96, 131, 62, 213, 220, 78, 96, 44, 106, 128, 96, 129, 164, 59, 86, 45, 87, 237, 192, 171, 93, 223, 206, 158, 42, 255, 175, 142, 177, 48, 67, 221, 123, 125, 182, 135, 31, 163, 211, 220, 28, 81, 113, 235, 236, 30, 104, 238, 227, 18, 134, 193, 15, 122, 151, 6, 132, 0, 128, 88, 20, 130, 87, 127, 55, 13, 76, 15, 124, 251, 160, 177, 179, 14, 7, 189, 49, 210, 77, 63, 132, 17, 84, 214, 63, 206, 252, 184, 168, 109, 129, 89, 70, 66, 151, 151, 100, 27, 123, 35, 210, 112, 183, 135, 97, 19, 7, 159, 221, 46, 253, 42, 229, 101, 187, 10, 33, 152, 138, 236, 208, 117, 230, 98, 200, 139, 200, 255, 19, 219, 183, 181, 3, 43, 143, 130, 75, 21, 228, 121, 208, 51, 82, 41, 233, 56, 220, 190, 176, 136, 108, 88, 118, 228, 206, 11, 170, 236, 232, 204, 241, 241, 69, 71, 28, 143, 207, 52, 188, 183, 80, 4, 222, 162, 30, 213, 228, 119, 142, 10, 255);
	b_array = newArray(0, 43, 203, 219, 253, 158, 5, 190, 72, 11, 23, 233, 220, 246, 53, 10, 90, 49, 215, 182, 74, 50, 27, 107, 39, 48, 192, 134, 247, 89, 14, 3, 67, 65, 30, 136, 78, 129, 178, 138, 186, 204, 5, 160, 18, 103, 255, 162, 42, 128, 213, 204, 49, 80, 181, 130, 60, 185, 31, 203, 184, 89, 108, 190, 109, 157, 231, 62, 128, 96, 150, 153, 160, 54, 24, 143, 90, 216, 128, 120, 87, 244, 15, 213, 235, 142, 140, 33, 98, 164, 202, 38, 84, 63, 229, 163, 28, 239, 210, 131, 79, 83, 168, 79, 89, 170, 26, 168, 149, 217, 31, 20, 11, 141, 121, 139, 21, 58, 194, 75, 110, 234, 16, 126, 24, 41, 62, 88, 232, 38, 243, 83, 195, 58, 84, 106, 151, 32, 146, 24, 140, 217, 176, 186, 174, 170, 250, 1, 48, 141, 99, 213, 127, 46, 97, 12, 143, 237, 153, 185, 72, 170, 23, 222, 216, 23, 92, 232, 54, 64, 72, 128, 182, 38, 192, 138, 115, 162, 231, 2, 143, 117, 167, 196, 4, 182, 220, 52, 252, 34, 2, 233, 132, 135, 230, 36, 199, 228, 222, 43, 119, 7, 148, 59, 10, 35, 158, 237, 17, 116, 110, 129, 172, 233, 172, 47, 114, 26, 115, 212, 177, 157, 74, 183, 102, 132, 151, 18, 242, 242, 12, 138, 21, 159, 165, 213, 230, 147, 174, 206, 116, 9, 242, 233, 202, 205, 116, 169, 80, 53, 161, 239, 211, 73, 96, 255);
	
	
	//Create mask of nuclei to be tracked
	Stack.getDimensions(width, height, channels, slices, frames);
	run("Split Channels");
	selectWindow("C1-test");
	run("Duplicate...", "title=[DAPI stack] duplicate");
	selectWindow("DAPI stack");
	run("Grays");
	setThreshold(lower, upper);
	run("Convert to Mask", "method=Default background=Dark");
	run("Fill Holes", "stack");
		
	//Track nuclei - only retain tracks that persist for all frames
	selectWindow("DAPI stack");
	run("Duplicate...", "title=[DAPI points]  duplicate");
	selectWindow("DAPI points");
	run("Properties...", "channels=1 slices=1 frames=17 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1.0000000 frame=[3598.85 sec]");
	run("Ultimate Points", "stack");
	setMinAndMax(3, 3); ////////////////////////////////////////////////////////////////////////////////////////////////////
	run("Apply LUT", "stack");

	//Remove any hidden reuslts tables
	updateResults();
	selectWindow("Results");
	run("Close");
	selectWindow("DAPI points");
	run("MTrack2 ", "minimum=1 maximum=1 maximum_=100 minimum_=" + frames); /////////////////////////////////////////////////////////////////

	//Create a marker ID map from tracks
	newImage("Markers", "8-bit black", width, height, frames);
	selectWindow("Results");
	track_string = getResultString("Frame", 0);
	track_string = replace(track_string, "Tracks 1 to ", "");
	n_tracks = parseInt(track_string);
	showStatus("Creating markers from tracks.");
	x_array = newArray(frames*n_tracks);
	y_array = newArray(frames*n_tracks);
	selectWindow("Results");
	index = 0;
	selectWindow("Results");
	for(b=1; b<=frames; b++){
		showProgress(b, frames);
		for(a=1; a<=n_tracks; a++){
			x_array[index] = round(getResult("X" + a, b));
			y_array[index] = round(getResult("Y" + a, b));
			index++;
		}
	}

	selectWindow("Results");
	run("Close");
	index = 0;
	selectWindow("Markers");
	for(b=1; b<=frames; b++){
		Stack.setSlice(b);
		showProgress(b, frames);
		for(a=1; a<=n_tracks; a++){
			setPixel(x_array[index]-1, y_array[index]-1, a);
			index++;
		}
	}
	close("DAPI points");
	
	//Run marker watershed to track nuclei
	selectWindow("DAPI stack");
	run("Duplicate...", "title=Mask duplicate");
	run("Duplicate...", "title=EDM duplicate");
	selectWindow("EDM");
	run("Distance Map", "stack");
	run("Invert", "stack");
	run("Grays");
	run("Gaussian Blur...", "sigma=2 stack");//////////////////////////////////////////////////////////////////////////////////////
	showStatus("Running watershed...");
	
	for(a=1; a<=frames; a++){
		selectWindow("Markers");
		setSlice(a);
		run("Duplicate...", "title=1");
		selectWindow("Mask");
		setSlice(a);
		run("Duplicate...", "title=2");
		selectWindow("EDM");
		setSlice(a);
		run("Duplicate...", "title=3");
		run("Marker-controlled Watershed", "input=3 marker=1 mask=2 calculate use");
		showProgress(a, frames);
		for(b=1; b<=3; b++) close(b);
		if(isOpen("Watershed_Stack")){
			run("Concatenate...", "  title=Watershed_Stack image1=Watershed_Stack image2=3-watershed image3=[-- None --]");
		}
		else{
			selectWindow("3-watershed");
			rename("Watershed_Stack");
		}
	}
	close("EDM");
	close("Mask");
	close("Markers");
	for(a=1; a<=4; a++) close("C" + a + "-test");
	close("DAPI stack");
	selectWindow("Watershed_Stack");
	setLut(r_array, g_array, b_array);
}

function measurePI(){
	selectWindow(i);
	r_array = newArray(0, 231, 25, 27, 112, 89, 53, 77, 155, 153, 91, 19, 25, 135, 187, 40, 52, 39, 147, 72, 92, 23, 5, 202, 52, 50, 108, 66, 238, 46, 136, 8, 162, 126, 75, 60, 135, 167, 136, 244, 161, 204, 158, 112, 192, 2, 98, 207, 233, 121, 191, 18, 210, 151, 252, 155, 139, 42, 188, 170, 127, 151, 38, 16, 227, 120, 137, 2, 72, 71, 214, 130, 194, 96, 102, 33, 92, 47, 211, 226, 237, 132, 244, 45, 82, 73, 239, 198, 118, 191, 170, 238, 177, 246, 66, 5, 44, 3, 18, 40, 226, 94, 130, 216, 68, 89, 150, 40, 96, 155, 95, 5, 132, 88, 124, 241, 143, 15, 1, 220, 46, 220, 216, 155, 190, 4, 98, 33, 142, 153, 185, 61, 153, 160, 164, 102, 75, 8, 26, 231, 160, 245, 119, 69, 95, 137, 232, 249, 89, 220, 54, 3, 43, 134, 172, 31, 106, 234, 132, 1, 29, 65, 12, 107, 52, 196, 95, 165, 4, 101, 124, 240, 203, 50, 142, 231, 5, 23, 43, 198, 41, 80, 66, 232, 86, 151, 126, 51, 122, 111, 162, 192, 148, 210, 5, 251, 40, 176, 32, 2, 22, 91, 180, 31, 218, 9, 10, 178, 27, 115, 54, 199, 163, 10, 180, 222, 102, 198, 202, 220, 96, 145, 237, 127, 172, 51, 64, 47, 84, 37, 196, 147, 244, 206, 244, 43, 170, 186, 162, 157, 125, 230, 212, 140, 186, 127, 12, 48, 0, 92, 168, 73, 228, 121, 248, 255);
	g_array = newArray(0, 217, 131, 18, 66, 198, 59, 170, 108, 8, 167, 207, 248, 138, 215, 204, 95, 249, 102, 66, 1, 138, 71, 33, 209, 80, 72, 87, 129, 24, 200, 98, 16, 160, 47, 1, 224, 49, 126, 41, 235, 205, 84, 249, 222, 125, 5, 58, 90, 137, 73, 98, 109, 167, 91, 106, 68, 23, 10, 241, 51, 35, 77, 112, 243, 235, 53, 41, 21, 134, 106, 60, 231, 107, 124, 96, 131, 62, 213, 220, 78, 96, 44, 106, 128, 96, 129, 164, 59, 86, 45, 87, 237, 192, 171, 93, 223, 206, 158, 42, 255, 175, 142, 177, 48, 67, 221, 123, 125, 182, 135, 31, 163, 211, 220, 28, 81, 113, 235, 236, 30, 104, 238, 227, 18, 134, 193, 15, 122, 151, 6, 132, 0, 128, 88, 20, 130, 87, 127, 55, 13, 76, 15, 124, 251, 160, 177, 179, 14, 7, 189, 49, 210, 77, 63, 132, 17, 84, 214, 63, 206, 252, 184, 168, 109, 129, 89, 70, 66, 151, 151, 100, 27, 123, 35, 210, 112, 183, 135, 97, 19, 7, 159, 221, 46, 253, 42, 229, 101, 187, 10, 33, 152, 138, 236, 208, 117, 230, 98, 200, 139, 200, 255, 19, 219, 183, 181, 3, 43, 143, 130, 75, 21, 228, 121, 208, 51, 82, 41, 233, 56, 220, 190, 176, 136, 108, 88, 118, 228, 206, 11, 170, 236, 232, 204, 241, 241, 69, 71, 28, 143, 207, 52, 188, 183, 80, 4, 222, 162, 30, 213, 228, 119, 142, 10, 255);
	b_array = newArray(0, 43, 203, 219, 253, 158, 5, 190, 72, 11, 23, 233, 220, 246, 53, 10, 90, 49, 215, 182, 74, 50, 27, 107, 39, 48, 192, 134, 247, 89, 14, 3, 67, 65, 30, 136, 78, 129, 178, 138, 186, 204, 5, 160, 18, 103, 255, 162, 42, 128, 213, 204, 49, 80, 181, 130, 60, 185, 31, 203, 184, 89, 108, 190, 109, 157, 231, 62, 128, 96, 150, 153, 160, 54, 24, 143, 90, 216, 128, 120, 87, 244, 15, 213, 235, 142, 140, 33, 98, 164, 202, 38, 84, 63, 229, 163, 28, 239, 210, 131, 79, 83, 168, 79, 89, 170, 26, 168, 149, 217, 31, 20, 11, 141, 121, 139, 21, 58, 194, 75, 110, 234, 16, 126, 24, 41, 62, 88, 232, 38, 243, 83, 195, 58, 84, 106, 151, 32, 146, 24, 140, 217, 176, 186, 174, 170, 250, 1, 48, 141, 99, 213, 127, 46, 97, 12, 143, 237, 153, 185, 72, 170, 23, 222, 216, 23, 92, 232, 54, 64, 72, 128, 182, 38, 192, 138, 115, 162, 231, 2, 143, 117, 167, 196, 4, 182, 220, 52, 252, 34, 2, 233, 132, 135, 230, 36, 199, 228, 222, 43, 119, 7, 148, 59, 10, 35, 158, 237, 17, 116, 110, 129, 172, 233, 172, 47, 114, 26, 115, 212, 177, 157, 74, 183, 102, 132, 151, 18, 242, 242, 12, 138, 21, 159, 165, 213, 230, 147, 174, 206, 116, 9, 242, 233, 202, 205, 116, 169, 80, 53, 161, 239, 211, 73, 96, 255);
	frames = 0;
	n_tracks = 0;
	selectWindow("Watershed_Stack");
	getStatistics(dummy, dummy, dummy, n_tracks);
	for(a=0; a<10; a++){ //For some reason code fails to measure frames and tracks at this point every other run
		selectWindow(i);
		Stack.getDimensions(width, height, channels, slices, frames);
		selectWindow("Watershed_Stack");
		getStatistics(dummy, dummy, dummy, n_tracks);
		if(frames > 0 && n_tracks > 0) break;
	}

	newImage("Result_stack", "32-bit black", frames, n_tracks, 4);
	
	//Create Voronoi mask where each area is marked with track ID
	selectWindow("Watershed_Stack");
	run("Duplicate...", "title=EDM duplicate");
	selectWindow("EDM");
	setMinAndMax(0, 1);
	run("Apply LUT", "stack");
	run("8-bit");
	run("Duplicate...", "title=Voronoi duplicate");
	selectWindow("Voronoi");
	run("Invert", "stack");
	run("Voronoi", "stack");
	setMinAndMax(0, 1);
	run("Apply LUT", "stack");
	selectWindow("EDM");
	run("Distance Map", "stack");
	
	for(a=1; a<=frames; a++){
		selectWindow("Watershed_Stack");
		setSlice(a);
		run("Duplicate...", "title=Marker");
		selectWindow("Voronoi");
		setSlice(a);
		run("Duplicate...", "title=Input");
		run("Marker-controlled Watershed", "input=Input marker=Marker mask=None calculate");
		close("Marker");
		close("Input");
		if(isOpen("Voronoi_Stack")) run("Concatenate...", "  title=Voronoi_Stack image1=Voronoi_Stack image2=Input-watershed image3=[-- None --]");
		else{
			selectWindow("Input-watershed");
			rename("Voronoi_Stack");
		}
	}
	close("Voronoi");
	selectWindow("Voronoi_Stack");
	setLut(r_array, g_array, b_array);
	
	//Limit voronoi to max distance from nucleus
	selectWindow("EDM");
	setThreshold(0,50);////////////////////////////////////////////////////////////////////////
	setOption("BlackBackground", false);
	run("Convert to Mask", "method=Default background=Light black");
	imageCalculator("AND create stack", "Voronoi_Stack","EDM");
	selectWindow("Result of Voronoi_Stack");
	close("EDM");
	
	//Make an edge stack for measureing the PI:DAPI ratio
	//Edge stack eleminates out of focus nulcei and mRNA form the analysis
	selectWindow(i);
	run("Duplicate...", "title=edge_stack duplicate");
	selectWindow("edge_stack");
	run("Find Edges", "stack");
	
	//Measure PI to DAPI ratio for each nucleus
	selectWindow("Result_stack");
	setSlice(1);
	setMetadata("Label", "PI:DAPI Ratio");
	selectWindow("Watershed_Stack");
	run("Grays");
	setMinAndMax(0, 255);
	run("8-bit");
	
	for(a=1; a<=frames; a++){
		selectWindow("Watershed_Stack");
		setSlice(a);
		selectWindow("edge_stack");
		Stack.setFrame(a);
		showProgress(a, frames);
		for(b=1; b<=n_tracks; b++){
			selectWindow("Watershed_Stack");
			setThreshold(b,b);
			run("Create Selection");
			selectWindow("edge_stack");
			run("Restore Selection");
			Stack.setChannel(1);
			getStatistics(dummy, DAPI);
			Stack.setChannel(3);
			getStatistics(dummy, pi);
			ratio = pi/DAPI;
			selectWindow("Result_stack");
			setPixel(a-1, b-1, ratio);
		}
	}
	
	//Measure bacteria content in each nucleus
	selectWindow("Result of Voronoi_Stack");
	run("Grays");
	setMinAndMax(0, 255);
	run("8-bit");
}

function measureBacteria(){
	selectWindow(i);
	Stack.getDimensions(width, height, channels, slices, frames);
	run("Duplicate...", "title=bacteria duplicate channels=2");
	selectWindow("Watershed_Stack");
	Stack.getStatistics(dummy, dummy, dummy, n_tracks, dummy);
	
	//Set remove background and set background to NaN
	selectWindow("bacteria");
	run("Duplicate...", "title=blur duplicate");
	selectWindow("blur");
	run("Gaussian Blur...", "sigma=10 stack");/////////////////////////////////////////////////////////////////////////////////
	imageCalculator("Subtract create stack", "bacteria","blur");
	close("blur");
	selectWindow("Result of bacteria");
	setOption("BlackBackground", false);
	setAutoThreshold("Triangle dark stack");
	run("Convert to Mask", "method=Triangle background=Dark");
	run("Analyze Particles...", "size=20-Infinity pixel show=Masks clear stack");///////////////////////////////////////////////////////////////////////
	close("Result of bacteria");
	imageCalculator("Divide create 32-bit stack", "Mask of Result of bacteria","Mask of Result of bacteria");
	close("Mask of Result of bacteria");
	imageCalculator("Multiply create 32-bit stack", "bacteria","Result of Mask of Result of bacteria");
	close("Result of Mask of Result of bacteria");
	
	//Add metadata to results stack slices
	selectWindow("Result_stack");
	setSlice(2);
	setMetadata("Label", "Bacteria Area");
	setSlice(3);
	setMetadata("Label", "Bacteria Mean");
	setSlice(4);
	setMetadata("Label", "Bacteria Max");
	
	for(a=1; a<=frames; a++){
		selectWindow("Result of Voronoi_Stack");
		setSlice(a);
		selectWindow("Result of bacteria");
		setSlice(a);
		showProgress(a, frames);
		for(b=1; b<=n_tracks; b++){
			selectWindow("Result of Voronoi_Stack");
			setThreshold(b,b);
			run("Create Selection");
			selectWindow("Result of bacteria");
			run("Restore Selection");
			getStatistics(area, mean, min, max, std);
			selectWindow("Result_stack");
			setSlice(2);
			setPixel(a-1, b-1, area);
			setSlice(3);
			setPixel(a-1, b-1, mean);
			setSlice(4);
			setPixel(a-1, b-1, max);
			
		}
	}
}



