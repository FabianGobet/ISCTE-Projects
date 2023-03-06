/**
 * Represents RGB colors.
 * RGB values are stored in a 3-position array, with values in the interval [0, 255].
 * rgb[0] - Red
 * rgb[1] - Green
 * rgb[2] - Blue
 */
class Color {

	private final int[] rgb; // @color

	/**
	 * Creates an RGB color. Provided values have to 
	 * be in the interval [0, 255]
	 */
	Color(int r, int g, int b) {
		if(!valid(r) || !valid(g) || !valid(b))
			throw new IllegalArgumentException("invalid RGB values: " + r + ", " + g + ", " + b);
		
		this.rgb = new int[] {r, g, b};
	}

	/**
	 * Red value [0, 255]
	 */
	int getR() {
		return rgb[0];
	}

	/**
	 * Green value [0, 255]
	 */
	int getG() {
		return rgb[1];
	}

	/**
	 * Blue value [0, 255]
	 */
	int getB() {
		return rgb[2];
	}
	


	/**
	 * Obtains the luminance in the interval [0, 255].
	 */
	int getLuminance() {
		return (int) Math.round(rgb[0]*.21 + rgb[1]*.71 + rgb[2]*.08);
	}

	static boolean valid(int value) {
		return value >= 0 && value <= 255;
	}
	
	static final Color RED = new Color(255,0,0);
	static final Color WHITE = new Color(255,255,255);
	static final Color BLACK = new Color(0,0,0);
	static final Color GREEN = new Color(0,255,0);
	static final Color BLUE = new Color(0,0,255);
	
	static final Color DARKRED = new Color(180,0,4);
	static final Color LIGHTRED = new Color(252,34,47);
	static final Color DARKPURPLE = new Color(52,0,52);
	static final Color LIGHTPURPLE = new Color(172,29,174);
	static final Color DARKGREEN = new Color(6,54,0);
	static final Color LIGHTGREEN = new Color(52,179,46);
	static final Color DARKBLUE = new Color(23,184,182);
	static final Color LIGHTBLUE = new Color(58,255,255);
	
	
	
	Color inverse(){
		return new Color(255-this.getR(), 255-this.getG(), 255-this.getB());
	}
	
	Color brighter(int value){
		Color cor = new Color(rgb[0],rgb[1],rgb[2]);
		for(int i=0; i<3; i++)
			if(rgb[i]+value < 0 || rgb[i]+value > 255)
				rgb[i] = (value > 0) ? 255 : 0;
			else
				cor.rgb[i] += value;
		return cor;
	}
	
	
	boolean isEqual(Color cor){
		boolean istrue = true;
		for(int i=0; i<3; i++)
			if(rgb[i] != cor.rgb[i])
				istrue = false;
		return istrue;
	}

}