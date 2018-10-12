function turnOffAllChildren(h)
	c=allchild(h); % c=get(h, 'Children'); 
	
	set(c, 'enable', 'off');
