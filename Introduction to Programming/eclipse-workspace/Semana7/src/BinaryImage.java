/**
 * Represents binary images.
 * Image data is represented as a matrix:
 * - the number of lines corresponds to the image height (data.length)
 * - the length of the lines corresponds to the image width (data[*].length)
 * - false values are mapped to black
 * - true values are mapped to white
 */
class BinaryImage {
	
	private boolean[][] data; // @binaryimage

	/**
	 * Creates a black binary image with the given dimension in pixels.
	 */
	BinaryImage(int width, int height) {
		data = new boolean[height][width];
	}

	/**
	 * Image width in pixels.
	 */
	int getWidth() {
		return data[0].length;
	}

	/**
	 * Image height in pixels.
	 */
	int getHeight() {
		return data.length;
	}

	/**
	 * Is pixel at (x, y) black?
	 */
	boolean isBlack(int x, int y) {
		validatePosition(x, y);
		return !data[y][x];
	}

	/**
	 * Sets the pixel at (x, y) to white.
	 */
	void setWhite(int x, int y) {
		validatePosition(x, y);
		data[y][x] = true;
	}

	/**
	 * Sets the pixel at (x, y) to black.
	 */
	void setBlack(int x, int y) {
		validatePosition(x, y);
		data[y][x] = false;
	}

	/**
	 * Is (x, y) a valid pixel position in this image?
	 */
	boolean validPosition(int x, int y) {
		return 
				x >= 0 && x < getWidth() &&
				y >= 0 && y < getHeight();
	}

	/**
	 * Validates if the given (x, y) is a valid pixel position,
	 * throwing an exception in case if it is not.
	 */
	void validatePosition(int x, int y) {
		if(!validPosition(x, y))
			throw new IllegalArgumentException(
					"invalid point " + x + ", " + y + 
					": matrix dimension is " + getWidth() + " x " + getHeight());
	}
}