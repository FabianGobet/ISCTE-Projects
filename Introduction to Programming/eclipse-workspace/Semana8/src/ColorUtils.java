class ColorUtils {
	
	static final int MAX = 255;
	
	static boolean contains(Color[] colors, Color c){
		for(int i=0; i<colors.length; i++)
			if(c.isEqual(colors[i]))
					return true;
		return false;	
	}

}