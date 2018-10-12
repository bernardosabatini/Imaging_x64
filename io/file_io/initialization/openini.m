function out=openini(fileName)
	out=1;

	[fid, message]=fopen(fileName);
	if fid<0
		disp(['openini: Error opening ' fileName ': ' message]);
		out=1;
		return
	end
	[fileName,~, ~] = fopen(fid);
	fclose(fid);
	
	disp(['*** Loading INI file = ' fileName]);
	initGUIs(fileName);
	
	[path,name,~] = fileparts(fileName);
	
	global state;
	state.iniName=name;
	state.iniPath=path;
	
