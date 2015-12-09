package layout.item;

import layout.item.LayoutItem.LayoutMask;
import layout.Resizable;

/**
 * Each Size value represents size along only one axis. You will have to use
 * two Size values if you want to fully specify an object's size. It is
 * strongly recommended that you apply size before position.
 */
class Size implements LayoutItem {
	/**
	 * Set the target's width ignoring everything except the overall
	 * Scale. If you specify width, this will behave as if the target
	 * started at that width.
	 */
	public static inline function simpleWidth(?width:Float):Size {
		if(width != null) {
			return new SimpleSize(true, width);
		} else {
			return new Size(true);
		}
	}
	/**
	 * Set the target's height ignoring everything except the overall
	 * Scale. If you specify height, this will behave as if the target
	 * started at that height.
	 */
	public static inline function simpleHeight(?height:Float):Size {
		if(height != null) {
			return new SimpleSize(false, height);
		} else {
			return new Size(false);
		}
	}
	
	/**
	 * Scale the target relative to the base's width. For instance,
	 * relativeWidth(0.95) plus Align.HORIZONTAL_CENTER will leave a
	 * small margin on both sides.
	 */
	public static inline function relativeWidth(percent:Float):Size {
		return new RelativeSize(true, percent);
	}
	/**
	 * Scale the target relative to the base's height. For instance,
	 * relativeHeight(0.5) will make the target half as tall as the base.
	 */
	public static inline function relativeHeight(percent:Float):Size {
		return new RelativeSize(false, percent);
	}
	
	/**
	 * Sets the target's width to the area's width, minus the given amount.
	 */
	public static inline function widthMinus(amount:Float):Size {
		return new MarginSize(true, amount);
	}
	/**
	 * Sets the target's height to the area's height, minus the given
	 * amount.
	 */
	public static inline function heightMinus(amount:Float):Size {
		return new MarginSize(false, amount);
	}
	
	/**
	 * Maintains the original aspect ratio by adjusting one dimension
	 * to match the other.
	 * @param	adjustWidth If true, the width will be adjusted based on
	 * the height. If false, the height will be adjusted based on the
	 * width.
	 */
	public static inline function maintainAspectRatio(adjustWidth:Bool):Size {
		return new AspectRatio(adjustWidth);
	}
	
	private var horizontal:Bool;
	public var mask:Int;
	
	public function new(horizontal:Bool) {
		this.horizontal = horizontal;
		mask = horizontal ? LayoutMask.AFFECTS_WIDTH : LayoutMask.AFFECTS_HEIGHT;
	}
	
	public function apply(target:Resizable, area:Resizable, scale:Scale):Void {
		if(horizontal) {
			var width:Float = getSize(target.baseWidth, area.width, scale.x);
			if(width != target.width) {
				target.width = width;
			}
		} else {
			var height:Float = getSize(target.baseHeight, area.height, scale.y);
			if(height != target.height) {
				target.height = height;
			}
		}
	}
	
	private function getSize(targetSize:Float, areaSize:Float, scale:Float):Float {
		return targetSize * scale;
	}
}

private class SimpleSize extends Size {
	private var size:Float;
	
	public function new(horizontal:Bool, size:Float) {
		super(horizontal);
		this.size = size;
	}
	
	private override function getSize(targetSize:Float, areaSize:Float, scale:Float):Float {
		return size * scale;
	}
}

private class RelativeSize extends Size {
	private var percent:Float;
	
	public function new(horizontal:Bool, percent:Float) {
		super(horizontal);
		this.percent = percent;
	}
	
	private override function getSize(targetSize:Float, areaSize:Float, scale:Float):Float {
		return areaSize * percent;
	}
}

/**
 * Warning: this name may be a little misleading; the class only allows
 * for one margin of the given size. If you want a margin on both sides,
 * multiply by 2.
 */
private class MarginSize extends Size {
	/**
	 * This is only a margin on one side. Normally you'd subtract
	 * (2 * margin) to add a margin on both sides, but that's not what's
	 * going on here.
	 */
	private var margin:Float;
	
	public function new(horizontal:Bool, margin:Float) {
		super(horizontal);
		this.margin = margin;
	}
	
	private override function getSize(targetSize:Float, areaSize:Float, scale:Float):Float {
		return areaSize - margin * scale;
	}
}

/**
 * Like MarginSize, but it ignores scale.
 * 
 * Warning: this name may be a little misleading; the class only allows
 * for one margin of the given size. If you want a margin on both sides,
 * multiply by 2.
 */
private class ExactMarginSize extends Size {
	/**
	 * This is only a margin on one side. Normally you'd subtract
	 * (2 * margin) to add a margin on both sides, but that's not what's
	 * going on here.
	 */
	private var margin:Float;
	
	public function new(horizontal:Bool, margin:Float) {
		super(horizontal);
		this.margin = margin;
	}
	
	private override function getSize(targetSize:Float, areaSize:Float, scale:Float):Float {
		return areaSize - margin;
	}
}

private class AspectRatio extends Size {
	public function new(horizontal:Bool) {
		super(horizontal);
	}
	
	public override function apply(target:Resizable, area:Resizable, scale:Scale):Void {
		if(horizontal) {
			target.scaleX = target.scaleY;
		} else {
			target.scaleY = target.scaleX;
		}
	}
}
