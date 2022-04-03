(function ($global) { "use strict";
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) {
		return undefined;
	}
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(len == null) {
		len = s.length;
	} else if(len < 0) {
		if(pos == 0) {
			len = s.length + len;
		} else {
			return "";
		}
	}
	return s.substr(pos,len);
};
HxOverrides.now = function() {
	return Date.now();
};
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	if(!(c > 8 && c < 14)) {
		return c == 32;
	} else {
		return true;
	}
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) ++r;
	if(r > 0) {
		return HxOverrides.substr(s,r,l - r);
	} else {
		return s;
	}
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) ++r;
	if(r > 0) {
		return HxOverrides.substr(s,0,l - r);
	} else {
		return s;
	}
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
var haxe_IMap = function() { };
haxe_IMap.__name__ = true;
haxe_IMap.__isInterface__ = true;
var haxe_Exception = function(message,previous,native) {
	Error.call(this,message);
	this.message = message;
	this.__previousException = previous;
	this.__nativeException = native != null ? native : this;
};
haxe_Exception.__name__ = true;
haxe_Exception.caught = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value;
	} else if(((value) instanceof Error)) {
		return new haxe_Exception(value.message,null,value);
	} else {
		return new haxe_ValueException(value,null,value);
	}
};
haxe_Exception.thrown = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value.get_native();
	} else if(((value) instanceof Error)) {
		return value;
	} else {
		var e = new haxe_ValueException(value);
		return e;
	}
};
haxe_Exception.__super__ = Error;
haxe_Exception.prototype = $extend(Error.prototype,{
	unwrap: function() {
		return this.__nativeException;
	}
	,get_native: function() {
		return this.__nativeException;
	}
	,__class__: haxe_Exception
});
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
};
haxe_ValueException.__name__ = true;
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
	unwrap: function() {
		return this.value;
	}
	,__class__: haxe_ValueException
});
var haxe_ds__$HashMap_HashMapData = function() {
	this.keys = new haxe_ds_IntMap();
	this.values = new haxe_ds_IntMap();
};
haxe_ds__$HashMap_HashMapData.__name__ = true;
haxe_ds__$HashMap_HashMapData.prototype = {
	__class__: haxe_ds__$HashMap_HashMapData
};
var haxe_ds_IntMap = function() {
	this.h = { };
};
haxe_ds_IntMap.__name__ = true;
haxe_ds_IntMap.__interfaces__ = [haxe_IMap];
haxe_ds_IntMap.prototype = {
	remove: function(key) {
		if(!this.h.hasOwnProperty(key)) {
			return false;
		}
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) if(this.h.hasOwnProperty(key)) a.push(+key);
		return new haxe_iterators_ArrayIterator(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,toString: function() {
		var s_b = "";
		s_b += "{";
		var it = this.keys();
		var i = it;
		while(i.hasNext()) {
			var i1 = i.next();
			s_b += i1 == null ? "null" : "" + i1;
			s_b += " => ";
			s_b += Std.string(Std.string(this.h[i1]));
			if(it.hasNext()) {
				s_b += ", ";
			}
		}
		s_b += "}";
		return s_b;
	}
	,__class__: haxe_ds_IntMap
};
var haxe_ds_List = function() {
	this.length = 0;
};
haxe_ds_List.__name__ = true;
haxe_ds_List.prototype = {
	add: function(item) {
		var x = new haxe_ds__$List_ListNode(item,null);
		if(this.h == null) {
			this.h = x;
		} else {
			this.q.next = x;
		}
		this.q = x;
		this.length++;
	}
	,first: function() {
		if(this.h == null) {
			return null;
		} else {
			return this.h.item;
		}
	}
	,last: function() {
		if(this.q == null) {
			return null;
		} else {
			return this.q.item;
		}
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,toString: function() {
		var s_b = "";
		var first = true;
		var l = this.h;
		s_b += "{";
		while(l != null) {
			if(first) {
				first = false;
			} else {
				s_b += ", ";
			}
			s_b += Std.string(Std.string(l.item));
			l = l.next;
		}
		s_b += "}";
		return s_b;
	}
	,join: function(sep) {
		var s_b = "";
		var first = true;
		var l = this.h;
		while(l != null) {
			if(first) {
				first = false;
			} else {
				s_b += sep == null ? "null" : "" + sep;
			}
			s_b += Std.string(l.item);
			l = l.next;
		}
		return s_b;
	}
	,__class__: haxe_ds_List
};
var haxe_ds__$List_ListNode = function(item,next) {
	this.item = item;
	this.next = next;
};
haxe_ds__$List_ListNode.__name__ = true;
haxe_ds__$List_ListNode.prototype = {
	__class__: haxe_ds__$List_ListNode
};
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	__class__: haxe_ds_StringMap
};
var haxe_ds_Vector = {};
haxe_ds_Vector.blit = function(src,srcPos,dest,destPos,len) {
	if(src == dest) {
		if(srcPos < destPos) {
			var i = srcPos + len;
			var j = destPos + len;
			var _g = 0;
			var _g1 = len;
			while(_g < _g1) {
				var k = _g++;
				--i;
				--j;
				src[j] = src[i];
			}
		} else if(srcPos > destPos) {
			var i = srcPos;
			var j = destPos;
			var _g = 0;
			var _g1 = len;
			while(_g < _g1) {
				var k = _g++;
				src[j] = src[i];
				++i;
				++j;
			}
		}
	} else {
		var _g = 0;
		var _g1 = len;
		while(_g < _g1) {
			var i = _g++;
			dest[destPos + i] = src[srcPos + i];
		}
	}
};
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.__name__ = true;
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
	,__class__: haxe_iterators_ArrayIterator
};
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if(o == null) {
		return null;
	} else if(((o) instanceof Array)) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g = 0;
			var _g1 = o.length;
			while(_g < _g1) {
				var i = _g++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( _g ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) {
			str += ", \n";
		}
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) {
		return false;
	}
	if(cc == cl) {
		return true;
	}
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g = 0;
		var _g1 = intf.length;
		while(_g < _g1) {
			var i = _g++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) {
				return true;
			}
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) {
		return false;
	}
	switch(cl) {
	case Array:
		return ((o) instanceof Array);
	case Bool:
		return typeof(o) == "boolean";
	case Dynamic:
		return o != null;
	case Float:
		return typeof(o) == "number";
	case Int:
		if(typeof(o) == "number") {
			return ((o | 0) === o);
		} else {
			return false;
		}
		break;
	case String:
		return typeof(o) == "string";
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(js_Boot.__downcastCheck(o,cl)) {
					return true;
				}
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(((o) instanceof cl)) {
					return true;
				}
			}
		} else {
			return false;
		}
		if(cl == Class ? o.__name__ != null : false) {
			return true;
		}
		if(cl == Enum ? o.__ename__ != null : false) {
			return true;
		}
		return false;
	}
};
js_Boot.__downcastCheck = function(o,cl) {
	if(!((o) instanceof cl)) {
		if(cl.__isInterface__) {
			return js_Boot.__interfLoop(js_Boot.getClass(o),cl);
		} else {
			return false;
		}
	} else {
		return true;
	}
};
js_Boot.__cast = function(o,t) {
	if(o == null || js_Boot.__instanceof(o,t)) {
		return o;
	} else {
		throw haxe_Exception.thrown("Cannot cast " + Std.string(o) + " to " + Std.string(t));
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var kot_Clade = function() {
	this.mDistStretch = 12000;
	this.mLineTextDist = 3;
	this.mBorder = 20;
	this.mLineWidth = 1;
	this.mTextSize = 14;
	this.mTextDist = 5;
	this.mCladeDist = 5;
	this.mColor = "black";
	this.mDist = 0;
	this.mChilds = new haxe_ds_List();
	this.mInfo = new haxe_ds_List();
	this.mConnectedInfo = new haxe_ds_StringMap();
};
kot_Clade.__name__ = true;
kot_Clade.prototype = {
	colorfy: function(color) {
		if(this.mColor != "black") {
			return;
		}
		this.mColor = color;
		var _g_head = this.mChilds.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var child = val;
			child.colorfy(color);
		}
	}
	,calcSize: function(useCache) {
		if(useCache && this.mLastSizeCalc != null) {
			return this.mLastSizeCalc;
		}
		var w = 0;
		var h = 0;
		if(this.mChilds.length == 0) {
			var maxInfoLen = 0;
			var _g_head = this.mInfo.h;
			while(_g_head != null) {
				var val = _g_head.item;
				_g_head = _g_head.next;
				var info = val;
				if(maxInfoLen <= info.length) {
					maxInfoLen = info.length;
				}
			}
			w = this.mDist * this.mDistStretch + this.mLineTextDist + maxInfoLen * this.mTextSize;
			if(this.mInfo.length == 0) {
				h = this.mCladeDist << 1;
			} else {
				h = this.mInfo.length * this.mTextSize + (this.mInfo.length - 1) * this.mTextDist + (this.mCladeDist << 1);
			}
		} else {
			var _g_head = this.mChilds.h;
			while(_g_head != null) {
				var val = _g_head.item;
				_g_head = _g_head.next;
				var child = val;
				var childInfo = child.calcSize(useCache);
				if(!(w > childInfo.w)) {
					w = childInfo.w;
				}
				h += childInfo.h;
			}
			w += this.mDist * this.mDistStretch;
			h += this.mInfo.length * this.mTextSize + (this.mInfo.length - 1) * this.mTextDist + (this.mCladeDist << 2);
		}
		this.mLastSizeCalc = { w : w, h : h};
		return this.mLastSizeCalc;
	}
	,getSVG: function() {
		var result = [];
		var w = 0;
		var h = 0;
		if(this.mChilds.length == 0) {
			var maxInfoLen = 0;
			var _g_head = this.mInfo.h;
			while(_g_head != null) {
				var val = _g_head.item;
				_g_head = _g_head.next;
				var info = val;
				if(maxInfoLen <= info.length) {
					maxInfoLen = info.length;
				}
			}
			w = this.mDist * this.mDistStretch + this.mLineTextDist + maxInfoLen * this.mTextSize;
			if(this.mInfo.length == 0) {
				h = this.mCladeDist << 1;
			} else {
				h = this.mInfo.length * this.mTextSize + (this.mInfo.length - 1) * this.mTextDist + (this.mCladeDist << 1);
			}
		} else {
			var _g_head = this.mChilds.h;
			while(_g_head != null) {
				var val = _g_head.item;
				_g_head = _g_head.next;
				var child = val;
				var w1 = 0;
				var h1 = 0;
				if(child.mChilds.length == 0) {
					var maxInfoLen = 0;
					var _g_head1 = child.mInfo.h;
					while(_g_head1 != null) {
						var val1 = _g_head1.item;
						_g_head1 = _g_head1.next;
						var info = val1;
						if(maxInfoLen <= info.length) {
							maxInfoLen = info.length;
						}
					}
					w1 = child.mDist * child.mDistStretch + child.mLineTextDist + maxInfoLen * child.mTextSize;
					if(child.mInfo.length == 0) {
						h1 = child.mCladeDist << 1;
					} else {
						h1 = child.mInfo.length * child.mTextSize + (child.mInfo.length - 1) * child.mTextDist + (child.mCladeDist << 1);
					}
				} else {
					var _g_head2 = child.mChilds.h;
					while(_g_head2 != null) {
						var val2 = _g_head2.item;
						_g_head2 = _g_head2.next;
						var child1 = val2;
						var childInfo = child1.calcSize(false);
						if(!(w1 > childInfo.w)) {
							w1 = childInfo.w;
						}
						h1 += childInfo.h;
					}
					w1 += child.mDist * child.mDistStretch;
					h1 += child.mInfo.length * child.mTextSize + (child.mInfo.length - 1) * child.mTextDist + (child.mCladeDist << 2);
				}
				child.mLastSizeCalc = { w : w1, h : h1};
				var childInfo1 = child.mLastSizeCalc;
				if(!(w > childInfo1.w)) {
					w = childInfo1.w;
				}
				h += childInfo1.h;
			}
			w += this.mDist * this.mDistStretch;
			h += this.mInfo.length * this.mTextSize + (this.mInfo.length - 1) * this.mTextDist + (this.mCladeDist << 2);
		}
		this.mLastSizeCalc = { w : w, h : h};
		var dim = this.mLastSizeCalc;
		result.push("<svg id='resultTree' version='1.1' baseProfile='full' width='" + (2 * this.mBorder + 200 + dim.w) + "' height='" + (2 * this.mBorder + dim.h) + "' xmlns='http://www.w3.org/2000/svg'>");
		result.push("<g style='stroke:" + this.mColor + ";stroke-width:" + this.mLineWidth + "' font-family='Courier New' font-size='" + this.mTextSize + "'>");
		this.paint(result,this.mBorder,this.mBorder,this.mColor);
		result.push("</g>");
		result.push("</svg>");
		return result.join("");
	}
	,paint: function(result,x,y,color) {
		var resX = 0;
		var resY = 0;
		var finalY = 0;
		result.push("<g id='" + this.mInfo.first() + "' style='stroke:" + this.mColor + "'>");
		if(this.mChilds.length == 0) {
			var dim;
			if(this.mLastSizeCalc != null) {
				dim = this.mLastSizeCalc;
			} else {
				var w = 0;
				var h = 0;
				if(this.mChilds.length == 0) {
					var maxInfoLen = 0;
					var _g_head = this.mInfo.h;
					while(_g_head != null) {
						var val = _g_head.item;
						_g_head = _g_head.next;
						var info = val;
						if(maxInfoLen <= info.length) {
							maxInfoLen = info.length;
						}
					}
					w = this.mDist * this.mDistStretch + this.mLineTextDist + maxInfoLen * this.mTextSize;
					if(this.mInfo.length == 0) {
						h = this.mCladeDist << 1;
					} else {
						h = this.mInfo.length * this.mTextSize + (this.mInfo.length - 1) * this.mTextDist + (this.mCladeDist << 1);
					}
				} else {
					var _g_head = this.mChilds.h;
					while(_g_head != null) {
						var val = _g_head.item;
						_g_head = _g_head.next;
						var child = val;
						var childInfo;
						if(child.mLastSizeCalc != null) {
							childInfo = child.mLastSizeCalc;
						} else {
							var w1 = 0;
							var h1 = 0;
							if(child.mChilds.length == 0) {
								var maxInfoLen = 0;
								var _g_head1 = child.mInfo.h;
								while(_g_head1 != null) {
									var val1 = _g_head1.item;
									_g_head1 = _g_head1.next;
									var info = val1;
									if(maxInfoLen <= info.length) {
										maxInfoLen = info.length;
									}
								}
								w1 = child.mDist * child.mDistStretch + child.mLineTextDist + maxInfoLen * child.mTextSize;
								if(child.mInfo.length == 0) {
									h1 = child.mCladeDist << 1;
								} else {
									h1 = child.mInfo.length * child.mTextSize + (child.mInfo.length - 1) * child.mTextDist + (child.mCladeDist << 1);
								}
							} else {
								var _g_head2 = child.mChilds.h;
								while(_g_head2 != null) {
									var val2 = _g_head2.item;
									_g_head2 = _g_head2.next;
									var child1 = val2;
									var childInfo1 = child1.calcSize(true);
									if(!(w1 > childInfo1.w)) {
										w1 = childInfo1.w;
									}
									h1 += childInfo1.h;
								}
								w1 += child.mDist * child.mDistStretch;
								h1 += child.mInfo.length * child.mTextSize + (child.mInfo.length - 1) * child.mTextDist + (child.mCladeDist << 2);
							}
							child.mLastSizeCalc = { w : w1, h : h1};
							childInfo = child.mLastSizeCalc;
						}
						if(!(w > childInfo.w)) {
							w = childInfo.w;
						}
						h += childInfo.h;
					}
					w += this.mDist * this.mDistStretch;
					h += this.mInfo.length * this.mTextSize + (this.mInfo.length - 1) * this.mTextDist + (this.mCladeDist << 2);
				}
				this.mLastSizeCalc = { w : w, h : h};
				dim = this.mLastSizeCalc;
			}
			finalY = dim.h + y;
			var mx = x;
			var my = y + dim.h / 2;
			result.push("<line x1='" + mx + "' y1='" + my + "' x2='" + (mx + this.mDist * this.mDistStretch) + "' y2='" + my + "' title='" + this.mDist + "'/>");
			resX = mx;
			resY = my;
			mx = x + this.mDist * this.mDistStretch + this.mLineTextDist;
			my = y + this.mCladeDist + this.mTextSize / 2 + 2.5;
			var _g_head = this.mInfo.h;
			while(_g_head != null) {
				var val = _g_head.item;
				_g_head = _g_head.next;
				var info = val;
				result.push("<text x='" + mx + "' y='" + my + "'>" + info + "</text>");
				my += this.mTextSize + this.mTextDist;
			}
		} else {
			var dim;
			if(this.mLastSizeCalc != null) {
				dim = this.mLastSizeCalc;
			} else {
				var w = 0;
				var h = 0;
				if(this.mChilds.length == 0) {
					var maxInfoLen = 0;
					var _g_head = this.mInfo.h;
					while(_g_head != null) {
						var val = _g_head.item;
						_g_head = _g_head.next;
						var info = val;
						if(maxInfoLen <= info.length) {
							maxInfoLen = info.length;
						}
					}
					w = this.mDist * this.mDistStretch + this.mLineTextDist + maxInfoLen * this.mTextSize;
					if(this.mInfo.length == 0) {
						h = this.mCladeDist << 1;
					} else {
						h = this.mInfo.length * this.mTextSize + (this.mInfo.length - 1) * this.mTextDist + (this.mCladeDist << 1);
					}
				} else {
					var _g_head = this.mChilds.h;
					while(_g_head != null) {
						var val = _g_head.item;
						_g_head = _g_head.next;
						var child = val;
						var childInfo;
						if(child.mLastSizeCalc != null) {
							childInfo = child.mLastSizeCalc;
						} else {
							var w1 = 0;
							var h1 = 0;
							if(child.mChilds.length == 0) {
								var maxInfoLen = 0;
								var _g_head1 = child.mInfo.h;
								while(_g_head1 != null) {
									var val1 = _g_head1.item;
									_g_head1 = _g_head1.next;
									var info = val1;
									if(maxInfoLen <= info.length) {
										maxInfoLen = info.length;
									}
								}
								w1 = child.mDist * child.mDistStretch + child.mLineTextDist + maxInfoLen * child.mTextSize;
								if(child.mInfo.length == 0) {
									h1 = child.mCladeDist << 1;
								} else {
									h1 = child.mInfo.length * child.mTextSize + (child.mInfo.length - 1) * child.mTextDist + (child.mCladeDist << 1);
								}
							} else {
								var _g_head2 = child.mChilds.h;
								while(_g_head2 != null) {
									var val2 = _g_head2.item;
									_g_head2 = _g_head2.next;
									var child1 = val2;
									var childInfo1 = child1.calcSize(true);
									if(!(w1 > childInfo1.w)) {
										w1 = childInfo1.w;
									}
									h1 += childInfo1.h;
								}
								w1 += child.mDist * child.mDistStretch;
								h1 += child.mInfo.length * child.mTextSize + (child.mInfo.length - 1) * child.mTextDist + (child.mCladeDist << 2);
							}
							child.mLastSizeCalc = { w : w1, h : h1};
							childInfo = child.mLastSizeCalc;
						}
						if(!(w > childInfo.w)) {
							w = childInfo.w;
						}
						h += childInfo.h;
					}
					w += this.mDist * this.mDistStretch;
					h += this.mInfo.length * this.mTextSize + (this.mInfo.length - 1) * this.mTextDist + (this.mCladeDist << 2);
				}
				this.mLastSizeCalc = { w : w, h : h};
				dim = this.mLastSizeCalc;
			}
			finalY = dim.h + y;
			var mx = x;
			var my = y + dim.h / 2;
			result.push("<line x1='" + mx + "' y1='" + my + "' x2='" + (mx + this.mDist * this.mDistStretch) + "' y2='" + my + "' title='" + this.mDist + "'/>");
			resX = mx;
			resY = my;
			var h = this.mCladeDist;
			var lowestY = -1;
			var highestY = -1;
			var txtY = -1;
			var _g_head = this.mChilds.h;
			while(_g_head != null) {
				var val = _g_head.item;
				_g_head = _g_head.next;
				var child = val;
				var childDim;
				if(child.mLastSizeCalc != null) {
					childDim = child.mLastSizeCalc;
				} else {
					var w = 0;
					var h1 = 0;
					if(child.mChilds.length == 0) {
						var maxInfoLen = 0;
						var _g_head1 = child.mInfo.h;
						while(_g_head1 != null) {
							var val1 = _g_head1.item;
							_g_head1 = _g_head1.next;
							var info = val1;
							if(maxInfoLen <= info.length) {
								maxInfoLen = info.length;
							}
						}
						w = child.mDist * child.mDistStretch + child.mLineTextDist + maxInfoLen * child.mTextSize;
						if(child.mInfo.length == 0) {
							h1 = child.mCladeDist << 1;
						} else {
							h1 = child.mInfo.length * child.mTextSize + (child.mInfo.length - 1) * child.mTextDist + (child.mCladeDist << 1);
						}
					} else {
						var _g_head2 = child.mChilds.h;
						while(_g_head2 != null) {
							var val2 = _g_head2.item;
							_g_head2 = _g_head2.next;
							var child1 = val2;
							var childInfo;
							if(child1.mLastSizeCalc != null) {
								childInfo = child1.mLastSizeCalc;
							} else {
								var w1 = 0;
								var h2 = 0;
								if(child1.mChilds.length == 0) {
									var maxInfoLen1 = 0;
									var _g_head3 = child1.mInfo.h;
									while(_g_head3 != null) {
										var val3 = _g_head3.item;
										_g_head3 = _g_head3.next;
										var info1 = val3;
										if(maxInfoLen1 <= info1.length) {
											maxInfoLen1 = info1.length;
										}
									}
									w1 = child1.mDist * child1.mDistStretch + child1.mLineTextDist + maxInfoLen1 * child1.mTextSize;
									if(child1.mInfo.length == 0) {
										h2 = child1.mCladeDist << 1;
									} else {
										h2 = child1.mInfo.length * child1.mTextSize + (child1.mInfo.length - 1) * child1.mTextDist + (child1.mCladeDist << 1);
									}
								} else {
									var _g_head4 = child1.mChilds.h;
									while(_g_head4 != null) {
										var val4 = _g_head4.item;
										_g_head4 = _g_head4.next;
										var child2 = val4;
										var childInfo1 = child2.calcSize(true);
										if(!(w1 > childInfo1.w)) {
											w1 = childInfo1.w;
										}
										h2 += childInfo1.h;
									}
									w1 += child1.mDist * child1.mDistStretch;
									h2 += child1.mInfo.length * child1.mTextSize + (child1.mInfo.length - 1) * child1.mTextDist + (child1.mCladeDist << 2);
								}
								child1.mLastSizeCalc = { w : w1, h : h2};
								childInfo = child1.mLastSizeCalc;
							}
							if(!(w > childInfo.w)) {
								w = childInfo.w;
							}
							h1 += childInfo.h;
						}
						w += child.mDist * child.mDistStretch;
						h1 += child.mInfo.length * child.mTextSize + (child.mInfo.length - 1) * child.mTextDist + (child.mCladeDist << 2);
					}
					child.mLastSizeCalc = { w : w, h : h1};
					childDim = child.mLastSizeCalc;
				}
				var midPoint = child.paint(result,x + this.mDist * this.mDistStretch,y + h,this.mColor);
				if(txtY == -1) {
					txtY = midPoint.finalY;
				}
				if(!(lowestY != -1 && lowestY < midPoint.y)) {
					lowestY = midPoint.y;
				}
				if(!(highestY > midPoint.y)) {
					highestY = midPoint.y;
				}
				h += childDim.h + this.mInfo.length * this.mTextSize + (this.mInfo.length - 1) * this.mTextDist;
			}
			mx += this.mDist * this.mDistStretch;
			result.push("<line x1='" + mx + "' y1='" + lowestY + "' x2='" + mx + "' y2='" + highestY + "' title='" + this.mDist + "'/>");
			mx += this.mLineTextDist;
			my = txtY + this.mCladeDist + this.mTextSize / 2 + 2.5;
			var _g1_head = this.mInfo.h;
			while(_g1_head != null) {
				var val = _g1_head.item;
				_g1_head = _g1_head.next;
				var info = val;
				result.push("<text x='" + mx + "' y='" + my + "'>" + info + "</text>");
				my += this.mTextSize + this.mTextDist;
			}
		}
		result.push("</g>");
		return { x : resX, y : resY, finalY : finalY};
	}
	,__class__: kot_Clade
};
var kot_CladeColorer = function() { };
kot_CladeColorer.__name__ = true;
kot_CladeColorer.same = function(l1,l2) {
	if(l1.length != l2.length) {
		return false;
	}
	var _g_head = l1.h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var x = val;
		var found = false;
		var _g_head1 = l2.h;
		while(_g_head1 != null) {
			var val1 = _g_head1.item;
			_g_head1 = _g_head1.next;
			var y = val1;
			if(x == y) {
				found = true;
				break;
			}
		}
		if(!found) {
			return false;
		}
	}
	return true;
};
kot_CladeColorer.findClade = function(c,l) {
	if(kot_CladeColorer.same(c.mConnectedInfo.h["seqNames"],l)) {
		return c;
	}
	var _g_head = c.mChilds.h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var child = val;
		var ccc = kot_CladeColorer.findClade(child,l);
		if(ccc != null) {
			return ccc;
		}
	}
	return null;
};
kot_CladeColorer.colorClades = function(c,l) {
	var i = 0;
	var _g_head = l.h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var ll = val;
		console.log("kot/CladeColorer.hx:90:","=== " + Std.string(ll));
		var cc = kot_CladeColorer.findClade(c,ll);
		if(cc != null) {
			console.log("kot/CladeColorer.hx:93:",cc);
			var ii = i++ % kot_CladeColorer.colors.length;
			var color = kot_CladeColorer.colors[ii];
			cc.colorfy(color);
		}
	}
};
var kot_Matrix = function(w,h) {
	if(w < 1) {
		throw haxe_Exception.thrown("Width must be bigger then 0!");
	}
	if(h < 1) {
		throw haxe_Exception.thrown("Height must be bigger then 0!");
	}
	this.mWidth = w;
	this.mHeight = h;
	var this1 = new Array(w * h);
	this.mValues = this1;
};
kot_Matrix.__name__ = true;
kot_Matrix.prototype = {
	__class__: kot_Matrix
};
var kot_DistanceMatrix = function(names) {
	if(names == null || names.length == 0) {
		throw haxe_Exception.thrown("Names must not be empty!");
	}
	kot_Matrix.call(this,names.length,names.length);
	this.mNames = names;
	var this1 = new haxe_ds__$HashMap_HashMapData();
	this.mNamePosLookup = this1;
	var pos = 0;
	var _g = 0;
	while(_g < names.length) {
		var name = names[_g];
		++_g;
		var this1 = this.mNamePosLookup;
		var _this = this1.keys;
		var key = name.hashCode();
		_this.h[key] = name;
		var _this1 = this1.values;
		var key1 = name.hashCode();
		_this1.h[key1] = pos++;
	}
};
kot_DistanceMatrix.__name__ = true;
kot_DistanceMatrix.__super__ = kot_Matrix;
kot_DistanceMatrix.prototype = $extend(kot_Matrix.prototype,{
	__class__: kot_DistanceMatrix
});
var kot_DistanceMatrixReader = function() {
};
kot_DistanceMatrixReader.__name__ = true;
kot_DistanceMatrixReader.prototype = {
	readMatrix: function(fileContent) {
		var lines = fileContent.split("\n");
		var names = new haxe_ds_List();
		var _g = 0;
		while(_g < lines.length) {
			var line = lines[_g];
			++_g;
			line = StringTools.trim(line);
			if(line == "" || line.charAt(0) == "#") {
				continue;
			}
			var name = line.split("\t")[0];
			names.add(name);
		}
		var this1 = new Array(names.length);
		var seqs = this1;
		var lookup_h = Object.create(null);
		var i = 0;
		var _g1_head = names.h;
		while(_g1_head != null) {
			var val = _g1_head.item;
			_g1_head = _g1_head.next;
			var name = val;
			var n = new haxe_ds_List();
			n.add(name);
			var s = new kot_Sequence(n,"");
			seqs[i++] = s;
			lookup_h[name] = s;
		}
		var d = new kot_DistanceMatrix(seqs);
		var _g = 0;
		while(_g < lines.length) {
			var line = lines[_g];
			++_g;
			line = StringTools.trim(line);
			if(line == "" || line.charAt(0) == "#") {
				continue;
			}
			var name = line.split("\t")[0];
			var s1 = lookup_h[name];
			var pos = -2;
			var _g1 = 0;
			var _g2 = line.split("\t");
			while(_g1 < _g2.length) {
				var e = _g2[_g1];
				++_g1;
				++pos;
				if(pos == -1) {
					continue;
				}
				var s2 = seqs[pos];
				var val = parseFloat(e);
				if(s1 == s2) {
					if(val != 0) {
						throw haxe_Exception.thrown("Distance of identical objects must be 0!");
					}
				}
				var pos1 = d.mNamePosLookup.values.h[s1.mHashCode];
				if(pos1 == null) {
					throw haxe_Exception.thrown(Std.string(s1) + " not in map!");
				}
				var pos2 = d.mNamePosLookup.values.h[s2.mHashCode];
				if(pos2 == null) {
					throw haxe_Exception.thrown(Std.string(s2) + " not in map!");
				}
				if(pos1 > pos2) {
					var swap = pos1;
					pos1 = pos2;
					pos2 = swap;
				}
				d.mValues[pos1 + pos2 * d.mWidth] = val;
			}
		}
		return d;
	}
	,__class__: kot_DistanceMatrixReader
};
var kot_IAlignmentReader = function() { };
kot_IAlignmentReader.__name__ = true;
kot_IAlignmentReader.__isInterface__ = true;
var kot_FastaAlignmentReader = function() {
};
kot_FastaAlignmentReader.__name__ = true;
kot_FastaAlignmentReader.__interfaces__ = [kot_IAlignmentReader];
kot_FastaAlignmentReader.prototype = {
	readSequences: function(fileContent,globalDeletion) {
		var sequences = [];
		var lines = fileContent.split("\n");
		var name = null;
		var seq = null;
		var seqAlreadySeen_h = Object.create(null);
		var badPositions_h = { };
		var _g = 0;
		while(_g < lines.length) {
			var line = lines[_g];
			++_g;
			line = StringTools.trim(line);
			if(line == "" || line.charAt(0) == ";" || line.charAt(0) == "#") {
				continue;
			}
			if(line.charAt(0) == ">") {
				if(name != null) {
					if(Object.prototype.hasOwnProperty.call(seqAlreadySeen_h,seq)) {
						var s = seqAlreadySeen_h[seq];
						s.mNames.add(name);
					} else {
						var l = new haxe_ds_List();
						l.add(name);
						var s1 = new kot_Sequence(l,seq);
						seqAlreadySeen_h[seq] = s1;
						sequences.push(s1);
					}
				}
				name = StringTools.trim(HxOverrides.substr(line,1,null));
				seq = "";
			} else {
				seq = seq.toUpperCase() + line;
			}
		}
		if(name != null) {
			if(Object.prototype.hasOwnProperty.call(seqAlreadySeen_h,seq)) {
				var s = seqAlreadySeen_h[seq];
				s.mNames.add(name);
			} else {
				var l = new haxe_ds_List();
				l.add(name);
				var s = new kot_Sequence(l,seq);
				seqAlreadySeen_h[seq] = s;
				sequences.push(s);
			}
		}
		if(globalDeletion) {
			var posToDelete = new haxe_ds_IntMap();
			var _g = 0;
			while(_g < sequences.length) {
				var sequence = sequences[_g];
				++_g;
				sequence.getBadPositions(posToDelete);
			}
			var count = 0;
			var seqs_h = Object.create(null);
			var _g = 0;
			while(_g < sequences.length) {
				var sequence = sequences[_g];
				++_g;
				var s = sequence.removePositions(posToDelete);
				if(Object.prototype.hasOwnProperty.call(seqs_h,s)) {
					var names = seqs_h[s];
					var _g2_head = sequence.mNames.h;
					while(_g2_head != null) {
						var val = _g2_head.item;
						_g2_head = _g2_head.next;
						var name = val;
						names.add(name);
					}
					seqs_h[s] = names;
				} else {
					seqs_h[s] = sequence.mNames;
					++count;
				}
			}
			var this1 = new Array(count);
			var result = this1;
			var i = 0;
			var h = seqs_h;
			var _g3_h = h;
			var _g3_keys = Object.keys(h);
			var _g3_length = _g3_keys.length;
			var _g3_current = 0;
			while(_g3_current < _g3_length) {
				var sequence = _g3_keys[_g3_current++];
				var s = sequence;
				var names = seqs_h[sequence];
				result[i++] = new kot_Sequence(names,s);
			}
			return result;
		}
		var this1 = new Array(sequences.length);
		var result = this1;
		var i = 0;
		var _g = 0;
		while(_g < sequences.length) {
			var sequence = sequences[_g];
			++_g;
			result[i++] = sequence;
		}
		return result;
	}
	,__class__: kot_FastaAlignmentReader
};
var kot_FourTimesRule = function() { };
kot_FourTimesRule.__name__ = true;
kot_FourTimesRule.getBestSubClades = function(subCladeA,subCladeB,c) {
	var l = new haxe_ds_List();
	l.add(subCladeA.first());
	l.add(subCladeB.first());
	return l;
};
kot_FourTimesRule.mergeSpecies = function(cladeA,cladeB,spA,spB,l) {
	var _g_head = cladeA.h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var lA = val;
		if(lA == spA) {
			continue;
		}
		l.add(lA);
	}
	var _g1_head = cladeB.h;
	while(_g1_head != null) {
		var val = _g1_head.item;
		_g1_head = _g1_head.next;
		var lB = val;
		if(lB == spB) {
			continue;
		}
		l.add(lB);
	}
	var u = new haxe_ds_List();
	var _g2_head = spA.h;
	while(_g2_head != null) {
		var val = _g2_head.item;
		_g2_head = _g2_head.next;
		var n1 = val;
		u.add(n1);
	}
	var _g3_head = spB.h;
	while(_g3_head != null) {
		var val = _g3_head.item;
		_g3_head = _g3_head.next;
		var n2 = val;
		u.add(n2);
	}
	l.add(u);
};
kot_FourTimesRule.seqsInClade = function(c) {
	var l = new haxe_ds_List();
	var seq = c.mConnectedInfo.h["sequence"];
	if(seq != null) {
		l.add(seq);
	}
	var _g_head = c.mChilds.h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var subClade = val;
		var subL = kot_FourTimesRule.seqsInClade(subClade);
		var _g_head1 = subL.h;
		while(_g_head1 != null) {
			var val1 = _g_head1.item;
			_g_head1 = _g_head1.next;
			var s = val1;
			l.add(s);
		}
	}
	c.mConnectedInfo.h["seqNames"] = l;
	return l;
};
kot_FourTimesRule.floatToStringPrecision = function(n,prec) {
	n = Math.round(n * Math.pow(10,prec));
	var str = "" + n;
	var len = str.length;
	if(len <= prec) {
		while(len < prec) {
			str = "0" + str;
			++len;
		}
		return "0." + str;
	} else {
		return HxOverrides.substr(str,0,str.length - prec) + "." + HxOverrides.substr(str,str.length - prec,null);
	}
};
kot_FourTimesRule.speciesInClade = function(c,decisionRatio,transitivity) {
	var l = new haxe_ds_List();
	if(c.mChilds.length == 0) {
		l.add(c.mConnectedInfo.h["seqNames"]);
		return l;
	}
	var terminalSeqList = new haxe_ds_List();
	var s = new haxe_ds_List();
	var _g_head = c.mChilds.h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var child = val;
		var sub = kot_FourTimesRule.speciesInClade(child,decisionRatio,transitivity);
		s.add(sub);
		var childSeqs = child.mConnectedInfo.h["seqNames"];
		var _g_head1 = childSeqs.h;
		while(_g_head1 != null) {
			var val1 = _g_head1.item;
			_g_head1 = _g_head1.next;
			var seq = val1;
			terminalSeqList.add(seq);
		}
	}
	c.mConnectedInfo.h["seqNames"] = terminalSeqList;
	if(s.length != 2) {
		throw haxe_Exception.thrown("WTF?");
	}
	var sA = s.first();
	var sB = s.last();
	var nSpecies = sA.length + sB.length;
	console.log("kot/FourTimesRule.hx:208:","=== " + Std.string(sA) + " " + Std.string(sB) + " ===");
	if(!transitivity) {
		var bestClades = kot_FourTimesRule.getBestSubClades(sA,sB,c);
		var seqsA = bestClades.first();
		var seqsB = bestClades.last();
		console.log("kot/FourTimesRule.hx:66:",Std.string(seqsA) + " " + Std.string(seqsA));
		var comparisons = 0;
		var diff = 0;
		var _g_head = seqsA.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var seq1 = val;
			var _g_head1 = seqsB.h;
			while(_g_head1 != null) {
				var val1 = _g_head1.item;
				_g_head1 = _g_head1.next;
				var seq2 = val1;
				var _g = 0;
				var _g1 = seq1.mNames.length;
				while(_g < _g1) {
					var i = _g++;
					var _g2 = 0;
					var _g3 = seq2.mNames.length;
					while(_g2 < _g3) {
						var j = _g2++;
						++comparisons;
						var result = 0;
						if(kot_FourTimesRule.distanceMatrix != null) {
							var _this = kot_FourTimesRule.distanceMatrix;
							var ret = 0;
							if(seq1 != seq2) {
								var pos1 = _this.mNamePosLookup.values.h[seq1.mHashCode];
								if(pos1 == null) {
									throw haxe_Exception.thrown(Std.string(seq1) + " not in map!");
								}
								var pos2 = _this.mNamePosLookup.values.h[seq2.mHashCode];
								if(pos2 == null) {
									throw haxe_Exception.thrown(Std.string(seq2) + " not in map!");
								}
								if(pos1 > pos2) {
									var swap = pos1;
									pos1 = pos2;
									pos2 = swap;
								}
								ret = _this.mValues[pos1 + pos2 * _this.mWidth];
							}
							result = ret;
						} else {
							if((seq2.mSeq == null ? 0 : seq2.mSeq.length) != (seq1.mSeq == null ? 0 : seq1.mSeq.length)) {
								throw haxe_Exception.thrown("Cannot compare sequences of different length!");
							}
							var score = 0;
							var count = 0;
							var _g4 = 0;
							var _g5 = seq1.mSeq == null ? 0 : seq1.mSeq.length;
							while(_g4 < _g5) {
								var i1 = _g4++;
								var c1 = seq1.mSeq.charAt(i1);
								var c2 = seq2.mSeq.charAt(i1);
								if(!(c1 == "A" || c1 == "T" || c1 == "G" || c1 == "C") || !(c2 == "A" || c2 == "T" || c2 == "G" || c2 == "C")) {
									continue;
								}
								if(c1 != c2) {
									++score;
								}
								++count;
							}
							var res = count == 0 ? 1.0 : score / count;
							result = res;
						}
						diff += result;
					}
				}
			}
		}
		var result = 0;
		if(diff != 0) {
			result = -0.75 * Math.log(1 - 4 * diff / (3.0 * comparisons));
		}
		var k = result;
		var seqs = bestClades.first();
		var n = 0;
		var _g_head = seqs.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var seq = val;
			n += seq.mNames.length;
		}
		var count = 0;
		var diff = 0;
		var c1 = 0;
		var _g_head = seqs.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var seq1 = val;
			var _g = 0;
			var _g1 = seq1.mNames.length;
			while(_g < _g1) {
				var i = _g++;
				var d = 0;
				var _g_head1 = seqs.h;
				while(_g_head1 != null) {
					var val1 = _g_head1.item;
					_g_head1 = _g_head1.next;
					var seq2 = val1;
					var _g2 = 0;
					var _g3 = seq2.mNames.length;
					while(_g2 < _g3) {
						var j = _g2++;
						if(c1 == d) {
							++d;
							continue;
						}
						++count;
						var result = 0;
						if(kot_FourTimesRule.distanceMatrix != null) {
							var _this = kot_FourTimesRule.distanceMatrix;
							var ret = 0;
							if(seq1 != seq2) {
								var pos1 = _this.mNamePosLookup.values.h[seq1.mHashCode];
								if(pos1 == null) {
									throw haxe_Exception.thrown(Std.string(seq1) + " not in map!");
								}
								var pos2 = _this.mNamePosLookup.values.h[seq2.mHashCode];
								if(pos2 == null) {
									throw haxe_Exception.thrown(Std.string(seq2) + " not in map!");
								}
								if(pos1 > pos2) {
									var swap = pos1;
									pos1 = pos2;
									pos2 = swap;
								}
								ret = _this.mValues[pos1 + pos2 * _this.mWidth];
							}
							result = ret;
						} else {
							if((seq2.mSeq == null ? 0 : seq2.mSeq.length) != (seq1.mSeq == null ? 0 : seq1.mSeq.length)) {
								throw haxe_Exception.thrown("Cannot compare sequences of different length!");
							}
							var score = 0;
							var count1 = 0;
							var _g4 = 0;
							var _g5 = seq1.mSeq == null ? 0 : seq1.mSeq.length;
							while(_g4 < _g5) {
								var i1 = _g4++;
								var c11 = seq1.mSeq.charAt(i1);
								var c2 = seq2.mSeq.charAt(i1);
								if(!(c11 == "A" || c11 == "T" || c11 == "G" || c11 == "C") || !(c2 == "A" || c2 == "T" || c2 == "G" || c2 == "C")) {
									continue;
								}
								if(c11 != c2) {
									++score;
								}
								++count1;
							}
							var res = count1 == 0 ? 1.0 : score / count1;
							result = res;
						}
						diff += result;
						++d;
					}
				}
				++c1;
			}
		}
		var pairwiseDistance = count == 0 ? 0 : diff / count;
		var pi = 0;
		if(n == 1) {
			n = 2;
		}
		if(pairwiseDistance == 0) {
			var _this = seqs.first();
			var seqLen = _this.mSeq == null ? 0 : _this.mSeq.length;
			pairwiseDistance = 1 / seqLen;
			pi = 2 / (seqLen * n * (n - 1));
		} else {
			pi = pairwiseDistance;
		}
		var theta1 = pi / (1 - 4 * pi / 3);
		var seqs = bestClades.last();
		var n = 0;
		var _g_head = seqs.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var seq = val;
			n += seq.mNames.length;
		}
		var count = 0;
		var diff = 0;
		var c1 = 0;
		var _g_head = seqs.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var seq1 = val;
			var _g = 0;
			var _g1 = seq1.mNames.length;
			while(_g < _g1) {
				var i = _g++;
				var d = 0;
				var _g_head1 = seqs.h;
				while(_g_head1 != null) {
					var val1 = _g_head1.item;
					_g_head1 = _g_head1.next;
					var seq2 = val1;
					var _g2 = 0;
					var _g3 = seq2.mNames.length;
					while(_g2 < _g3) {
						var j = _g2++;
						if(c1 == d) {
							++d;
							continue;
						}
						++count;
						var result = 0;
						if(kot_FourTimesRule.distanceMatrix != null) {
							var _this = kot_FourTimesRule.distanceMatrix;
							var ret = 0;
							if(seq1 != seq2) {
								var pos1 = _this.mNamePosLookup.values.h[seq1.mHashCode];
								if(pos1 == null) {
									throw haxe_Exception.thrown(Std.string(seq1) + " not in map!");
								}
								var pos2 = _this.mNamePosLookup.values.h[seq2.mHashCode];
								if(pos2 == null) {
									throw haxe_Exception.thrown(Std.string(seq2) + " not in map!");
								}
								if(pos1 > pos2) {
									var swap = pos1;
									pos1 = pos2;
									pos2 = swap;
								}
								ret = _this.mValues[pos1 + pos2 * _this.mWidth];
							}
							result = ret;
						} else {
							if((seq2.mSeq == null ? 0 : seq2.mSeq.length) != (seq1.mSeq == null ? 0 : seq1.mSeq.length)) {
								throw haxe_Exception.thrown("Cannot compare sequences of different length!");
							}
							var score = 0;
							var count1 = 0;
							var _g4 = 0;
							var _g5 = seq1.mSeq == null ? 0 : seq1.mSeq.length;
							while(_g4 < _g5) {
								var i1 = _g4++;
								var c11 = seq1.mSeq.charAt(i1);
								var c2 = seq2.mSeq.charAt(i1);
								if(!(c11 == "A" || c11 == "T" || c11 == "G" || c11 == "C") || !(c2 == "A" || c2 == "T" || c2 == "G" || c2 == "C")) {
									continue;
								}
								if(c11 != c2) {
									++score;
								}
								++count1;
							}
							var res = count1 == 0 ? 1.0 : score / count1;
							result = res;
						}
						diff += result;
						++d;
					}
				}
				++c1;
			}
		}
		var pairwiseDistance = count == 0 ? 0 : diff / count;
		var pi = 0;
		if(n == 1) {
			n = 2;
		}
		if(pairwiseDistance == 0) {
			var _this = seqs.first();
			var seqLen = _this.mSeq == null ? 0 : _this.mSeq.length;
			pairwiseDistance = 1 / seqLen;
			pi = 2 / (seqLen * n * (n - 1));
		} else {
			pi = pairwiseDistance;
		}
		var theta2 = pi / (1 - 4 * pi / 3);
		var info = "K=" + kot_FourTimesRule.floatToStringPrecision(k,5);
		c.mInfo.add(info);
		var info = "Theta1=" + kot_FourTimesRule.floatToStringPrecision(theta1,5) + ", Theta2=" + kot_FourTimesRule.floatToStringPrecision(theta2,5);
		c.mInfo.add(info);
		var theta = theta1 > theta2 ? theta1 : theta2;
		if(theta != -1) {
			var ratio = k / theta;
			var info = kot_FourTimesRule.floatToStringPrecision(k,5) + "/" + kot_FourTimesRule.floatToStringPrecision(theta,5) + "=" + kot_FourTimesRule.floatToStringPrecision(ratio,5);
			c.mInfo.add(info);
			if(ratio >= decisionRatio) {
				var _g1_head = sA.h;
				while(_g1_head != null) {
					var val = _g1_head.item;
					_g1_head = _g1_head.next;
					var n1 = val;
					l.add(n1);
				}
				var _g2_head = sB.h;
				while(_g2_head != null) {
					var val = _g2_head.item;
					_g2_head = _g2_head.next;
					var n2 = val;
					l.add(n2);
				}
			} else {
				kot_FourTimesRule.mergeSpecies(sA,sB,bestClades.first(),bestClades.last(),l);
			}
		} else {
			kot_FourTimesRule.mergeSpecies(sA,sB,bestClades.first(),bestClades.last(),l);
		}
	} else if(transitivity) {
		var goOn = false;
		var bestClades = kot_FourTimesRule.getBestSubClades(sA,sB,c);
		var seqsA = bestClades.first();
		var seqsB = bestClades.last();
		console.log("kot/FourTimesRule.hx:66:",Std.string(seqsA) + " " + Std.string(seqsA));
		var comparisons = 0;
		var diff = 0;
		var _g_head = seqsA.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var seq1 = val;
			var _g_head1 = seqsB.h;
			while(_g_head1 != null) {
				var val1 = _g_head1.item;
				_g_head1 = _g_head1.next;
				var seq2 = val1;
				var _g = 0;
				var _g1 = seq1.mNames.length;
				while(_g < _g1) {
					var i = _g++;
					var _g2 = 0;
					var _g3 = seq2.mNames.length;
					while(_g2 < _g3) {
						var j = _g2++;
						++comparisons;
						var result = 0;
						if(kot_FourTimesRule.distanceMatrix != null) {
							var _this = kot_FourTimesRule.distanceMatrix;
							var ret = 0;
							if(seq1 != seq2) {
								var pos1 = _this.mNamePosLookup.values.h[seq1.mHashCode];
								if(pos1 == null) {
									throw haxe_Exception.thrown(Std.string(seq1) + " not in map!");
								}
								var pos2 = _this.mNamePosLookup.values.h[seq2.mHashCode];
								if(pos2 == null) {
									throw haxe_Exception.thrown(Std.string(seq2) + " not in map!");
								}
								if(pos1 > pos2) {
									var swap = pos1;
									pos1 = pos2;
									pos2 = swap;
								}
								ret = _this.mValues[pos1 + pos2 * _this.mWidth];
							}
							result = ret;
						} else {
							if((seq2.mSeq == null ? 0 : seq2.mSeq.length) != (seq1.mSeq == null ? 0 : seq1.mSeq.length)) {
								throw haxe_Exception.thrown("Cannot compare sequences of different length!");
							}
							var score = 0;
							var count = 0;
							var _g4 = 0;
							var _g5 = seq1.mSeq == null ? 0 : seq1.mSeq.length;
							while(_g4 < _g5) {
								var i1 = _g4++;
								var c1 = seq1.mSeq.charAt(i1);
								var c2 = seq2.mSeq.charAt(i1);
								if(!(c1 == "A" || c1 == "T" || c1 == "G" || c1 == "C") || !(c2 == "A" || c2 == "T" || c2 == "G" || c2 == "C")) {
									continue;
								}
								if(c1 != c2) {
									++score;
								}
								++count;
							}
							var res = count == 0 ? 1.0 : score / count;
							result = res;
						}
						diff += result;
					}
				}
			}
		}
		var result = 0;
		if(diff != 0) {
			result = -0.75 * Math.log(1 - 4 * diff / (3.0 * comparisons));
		}
		var k = result;
		var seqs = bestClades.first();
		var n = 0;
		var _g_head = seqs.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var seq = val;
			n += seq.mNames.length;
		}
		var count = 0;
		var diff = 0;
		var c1 = 0;
		var _g_head = seqs.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var seq1 = val;
			var _g = 0;
			var _g1 = seq1.mNames.length;
			while(_g < _g1) {
				var i = _g++;
				var d = 0;
				var _g_head1 = seqs.h;
				while(_g_head1 != null) {
					var val1 = _g_head1.item;
					_g_head1 = _g_head1.next;
					var seq2 = val1;
					var _g2 = 0;
					var _g3 = seq2.mNames.length;
					while(_g2 < _g3) {
						var j = _g2++;
						if(c1 == d) {
							++d;
							continue;
						}
						++count;
						var result = 0;
						if(kot_FourTimesRule.distanceMatrix != null) {
							var _this = kot_FourTimesRule.distanceMatrix;
							var ret = 0;
							if(seq1 != seq2) {
								var pos1 = _this.mNamePosLookup.values.h[seq1.mHashCode];
								if(pos1 == null) {
									throw haxe_Exception.thrown(Std.string(seq1) + " not in map!");
								}
								var pos2 = _this.mNamePosLookup.values.h[seq2.mHashCode];
								if(pos2 == null) {
									throw haxe_Exception.thrown(Std.string(seq2) + " not in map!");
								}
								if(pos1 > pos2) {
									var swap = pos1;
									pos1 = pos2;
									pos2 = swap;
								}
								ret = _this.mValues[pos1 + pos2 * _this.mWidth];
							}
							result = ret;
						} else {
							if((seq2.mSeq == null ? 0 : seq2.mSeq.length) != (seq1.mSeq == null ? 0 : seq1.mSeq.length)) {
								throw haxe_Exception.thrown("Cannot compare sequences of different length!");
							}
							var score = 0;
							var count1 = 0;
							var _g4 = 0;
							var _g5 = seq1.mSeq == null ? 0 : seq1.mSeq.length;
							while(_g4 < _g5) {
								var i1 = _g4++;
								var c11 = seq1.mSeq.charAt(i1);
								var c2 = seq2.mSeq.charAt(i1);
								if(!(c11 == "A" || c11 == "T" || c11 == "G" || c11 == "C") || !(c2 == "A" || c2 == "T" || c2 == "G" || c2 == "C")) {
									continue;
								}
								if(c11 != c2) {
									++score;
								}
								++count1;
							}
							var res = count1 == 0 ? 1.0 : score / count1;
							result = res;
						}
						diff += result;
						++d;
					}
				}
				++c1;
			}
		}
		var pairwiseDistance = count == 0 ? 0 : diff / count;
		var pi = 0;
		if(n == 1) {
			n = 2;
		}
		if(pairwiseDistance == 0) {
			var _this = seqs.first();
			var seqLen = _this.mSeq == null ? 0 : _this.mSeq.length;
			pairwiseDistance = 1 / seqLen;
			pi = 2 / (seqLen * n * (n - 1));
		} else {
			pi = pairwiseDistance;
		}
		var theta1 = pi / (1 - 4 * pi / 3);
		var seqs = bestClades.last();
		var n = 0;
		var _g_head = seqs.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var seq = val;
			n += seq.mNames.length;
		}
		var count = 0;
		var diff = 0;
		var c1 = 0;
		var _g_head = seqs.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var seq1 = val;
			var _g = 0;
			var _g1 = seq1.mNames.length;
			while(_g < _g1) {
				var i = _g++;
				var d = 0;
				var _g_head1 = seqs.h;
				while(_g_head1 != null) {
					var val1 = _g_head1.item;
					_g_head1 = _g_head1.next;
					var seq2 = val1;
					var _g2 = 0;
					var _g3 = seq2.mNames.length;
					while(_g2 < _g3) {
						var j = _g2++;
						if(c1 == d) {
							++d;
							continue;
						}
						++count;
						var result = 0;
						if(kot_FourTimesRule.distanceMatrix != null) {
							var _this = kot_FourTimesRule.distanceMatrix;
							var ret = 0;
							if(seq1 != seq2) {
								var pos1 = _this.mNamePosLookup.values.h[seq1.mHashCode];
								if(pos1 == null) {
									throw haxe_Exception.thrown(Std.string(seq1) + " not in map!");
								}
								var pos2 = _this.mNamePosLookup.values.h[seq2.mHashCode];
								if(pos2 == null) {
									throw haxe_Exception.thrown(Std.string(seq2) + " not in map!");
								}
								if(pos1 > pos2) {
									var swap = pos1;
									pos1 = pos2;
									pos2 = swap;
								}
								ret = _this.mValues[pos1 + pos2 * _this.mWidth];
							}
							result = ret;
						} else {
							if((seq2.mSeq == null ? 0 : seq2.mSeq.length) != (seq1.mSeq == null ? 0 : seq1.mSeq.length)) {
								throw haxe_Exception.thrown("Cannot compare sequences of different length!");
							}
							var score = 0;
							var count1 = 0;
							var _g4 = 0;
							var _g5 = seq1.mSeq == null ? 0 : seq1.mSeq.length;
							while(_g4 < _g5) {
								var i1 = _g4++;
								var c11 = seq1.mSeq.charAt(i1);
								var c2 = seq2.mSeq.charAt(i1);
								if(!(c11 == "A" || c11 == "T" || c11 == "G" || c11 == "C") || !(c2 == "A" || c2 == "T" || c2 == "G" || c2 == "C")) {
									continue;
								}
								if(c11 != c2) {
									++score;
								}
								++count1;
							}
							var res = count1 == 0 ? 1.0 : score / count1;
							result = res;
						}
						diff += result;
						++d;
					}
				}
				++c1;
			}
		}
		var pairwiseDistance = count == 0 ? 0 : diff / count;
		var pi = 0;
		if(n == 1) {
			n = 2;
		}
		if(pairwiseDistance == 0) {
			var _this = seqs.first();
			var seqLen = _this.mSeq == null ? 0 : _this.mSeq.length;
			pairwiseDistance = 1 / seqLen;
			pi = 2 / (seqLen * n * (n - 1));
		} else {
			pi = pairwiseDistance;
		}
		var theta2 = pi / (1 - 4 * pi / 3);
		var info = kot_FourTimesRule.floatToStringPrecision(theta1,5) + "(" + bestClades.first().length + ") " + kot_FourTimesRule.floatToStringPrecision(theta2,5) + "(" + bestClades.last().length + ")";
		c.mInfo.add(info);
		var theta = theta1 > theta2 ? theta1 : theta2;
		if(theta != -1) {
			var ratio = k / theta;
			var info = kot_FourTimesRule.floatToStringPrecision(k,5) + "/" + kot_FourTimesRule.floatToStringPrecision(theta,5) + "=" + kot_FourTimesRule.floatToStringPrecision(ratio,5);
			c.mInfo.add(info);
			if(ratio < decisionRatio) {
				goOn = true;
			}
		}
		var _g1_head = sA.h;
		while(_g1_head != null) {
			var val = _g1_head.item;
			_g1_head = _g1_head.next;
			var n1 = val;
			l.add(n1);
		}
		var _g2_head = sB.h;
		while(_g2_head != null) {
			var val = _g2_head.item;
			_g2_head = _g2_head.next;
			var n2 = val;
			l.add(n2);
		}
		while(goOn) {
			var toCombine = new haxe_ds_IntMap();
			var _g = 0;
			var _g1 = l.length;
			while(_g < _g1) {
				var i = _g++;
				var lxxx = new haxe_ds_List();
				lxxx.add(i + 1);
				toCombine.h[i + 1] = lxxx;
			}
			goOn = false;
			var i1 = 0;
			var _g5_head = l.h;
			while(_g5_head != null) {
				var val = _g5_head.item;
				_g5_head = _g5_head.next;
				var s1 = val;
				++i1;
				var j = 0;
				var _g5_head1 = l.h;
				while(_g5_head1 != null) {
					var val1 = _g5_head1.item;
					_g5_head1 = _g5_head1.next;
					var s2 = val1;
					++j;
					if(i1 >= j) {
						continue;
					}
					console.log("kot/FourTimesRule.hx:66:",Std.string(s1) + " " + Std.string(s1));
					var comparisons = 0;
					var diff = 0;
					var _g_head = s1.h;
					while(_g_head != null) {
						var val2 = _g_head.item;
						_g_head = _g_head.next;
						var seq1 = val2;
						var _g_head1 = s2.h;
						while(_g_head1 != null) {
							var val3 = _g_head1.item;
							_g_head1 = _g_head1.next;
							var seq2 = val3;
							var _g2 = 0;
							var _g3 = seq1.mNames.length;
							while(_g2 < _g3) {
								var i2 = _g2++;
								var _g4 = 0;
								var _g5 = seq2.mNames.length;
								while(_g4 < _g5) {
									var j1 = _g4++;
									++comparisons;
									var result = 0;
									if(kot_FourTimesRule.distanceMatrix != null) {
										var _this = kot_FourTimesRule.distanceMatrix;
										var ret = 0;
										if(seq1 != seq2) {
											var pos1 = _this.mNamePosLookup.values.h[seq1.mHashCode];
											if(pos1 == null) {
												throw haxe_Exception.thrown(Std.string(seq1) + " not in map!");
											}
											var pos2 = _this.mNamePosLookup.values.h[seq2.mHashCode];
											if(pos2 == null) {
												throw haxe_Exception.thrown(Std.string(seq2) + " not in map!");
											}
											if(pos1 > pos2) {
												var swap = pos1;
												pos1 = pos2;
												pos2 = swap;
											}
											ret = _this.mValues[pos1 + pos2 * _this.mWidth];
										}
										result = ret;
									} else {
										if((seq2.mSeq == null ? 0 : seq2.mSeq.length) != (seq1.mSeq == null ? 0 : seq1.mSeq.length)) {
											throw haxe_Exception.thrown("Cannot compare sequences of different length!");
										}
										var score = 0;
										var count = 0;
										var _g6 = 0;
										var _g7 = seq1.mSeq == null ? 0 : seq1.mSeq.length;
										while(_g6 < _g7) {
											var i3 = _g6++;
											var c1 = seq1.mSeq.charAt(i3);
											var c2 = seq2.mSeq.charAt(i3);
											if(!(c1 == "A" || c1 == "T" || c1 == "G" || c1 == "C") || !(c2 == "A" || c2 == "T" || c2 == "G" || c2 == "C")) {
												continue;
											}
											if(c1 != c2) {
												++score;
											}
											++count;
										}
										var res = count == 0 ? 1.0 : score / count;
										result = res;
									}
									diff += result;
								}
							}
						}
					}
					var result1 = 0;
					if(diff != 0) {
						result1 = -0.75 * Math.log(1 - 4 * diff / (3.0 * comparisons));
					}
					var k = result1;
					var n = 0;
					var _g_head2 = s1.h;
					while(_g_head2 != null) {
						var val4 = _g_head2.item;
						_g_head2 = _g_head2.next;
						var seq = val4;
						n += seq.mNames.length;
					}
					var count1 = 0;
					var diff1 = 0;
					var c3 = 0;
					var _g_head3 = s1.h;
					while(_g_head3 != null) {
						var val5 = _g_head3.item;
						_g_head3 = _g_head3.next;
						var seq11 = val5;
						var _g8 = 0;
						var _g9 = seq11.mNames.length;
						while(_g8 < _g9) {
							var i4 = _g8++;
							var d = 0;
							var _g_head4 = s1.h;
							while(_g_head4 != null) {
								var val6 = _g_head4.item;
								_g_head4 = _g_head4.next;
								var seq21 = val6;
								var _g10 = 0;
								var _g11 = seq21.mNames.length;
								while(_g10 < _g11) {
									var j2 = _g10++;
									if(c3 == d) {
										++d;
										continue;
									}
									++count1;
									var result2 = 0;
									if(kot_FourTimesRule.distanceMatrix != null) {
										var _this1 = kot_FourTimesRule.distanceMatrix;
										var ret1 = 0;
										if(seq11 != seq21) {
											var pos11 = _this1.mNamePosLookup.values.h[seq11.mHashCode];
											if(pos11 == null) {
												throw haxe_Exception.thrown(Std.string(seq11) + " not in map!");
											}
											var pos21 = _this1.mNamePosLookup.values.h[seq21.mHashCode];
											if(pos21 == null) {
												throw haxe_Exception.thrown(Std.string(seq21) + " not in map!");
											}
											if(pos11 > pos21) {
												var swap1 = pos11;
												pos11 = pos21;
												pos21 = swap1;
											}
											ret1 = _this1.mValues[pos11 + pos21 * _this1.mWidth];
										}
										result2 = ret1;
									} else {
										if((seq21.mSeq == null ? 0 : seq21.mSeq.length) != (seq11.mSeq == null ? 0 : seq11.mSeq.length)) {
											throw haxe_Exception.thrown("Cannot compare sequences of different length!");
										}
										var score1 = 0;
										var count2 = 0;
										var _g12 = 0;
										var _g13 = seq11.mSeq == null ? 0 : seq11.mSeq.length;
										while(_g12 < _g13) {
											var i5 = _g12++;
											var c11 = seq11.mSeq.charAt(i5);
											var c21 = seq21.mSeq.charAt(i5);
											if(!(c11 == "A" || c11 == "T" || c11 == "G" || c11 == "C") || !(c21 == "A" || c21 == "T" || c21 == "G" || c21 == "C")) {
												continue;
											}
											if(c11 != c21) {
												++score1;
											}
											++count2;
										}
										var res1 = count2 == 0 ? 1.0 : score1 / count2;
										result2 = res1;
									}
									diff1 += result2;
									++d;
								}
							}
							++c3;
						}
					}
					var pairwiseDistance = count1 == 0 ? 0 : diff1 / count1;
					var pi = 0;
					if(n == 1) {
						n = 2;
					}
					if(pairwiseDistance == 0) {
						var _this2 = s1.first();
						var seqLen = _this2.mSeq == null ? 0 : _this2.mSeq.length;
						pairwiseDistance = 1 / seqLen;
						pi = 2 / (seqLen * n * (n - 1));
					} else {
						pi = pairwiseDistance;
					}
					var theta1 = pi / (1 - 4 * pi / 3);
					var n1 = 0;
					var _g_head5 = s2.h;
					while(_g_head5 != null) {
						var val7 = _g_head5.item;
						_g_head5 = _g_head5.next;
						var seq3 = val7;
						n1 += seq3.mNames.length;
					}
					var count3 = 0;
					var diff2 = 0;
					var c4 = 0;
					var _g_head6 = s2.h;
					while(_g_head6 != null) {
						var val8 = _g_head6.item;
						_g_head6 = _g_head6.next;
						var seq12 = val8;
						var _g14 = 0;
						var _g15 = seq12.mNames.length;
						while(_g14 < _g15) {
							var i6 = _g14++;
							var d1 = 0;
							var _g_head7 = s2.h;
							while(_g_head7 != null) {
								var val9 = _g_head7.item;
								_g_head7 = _g_head7.next;
								var seq22 = val9;
								var _g16 = 0;
								var _g17 = seq22.mNames.length;
								while(_g16 < _g17) {
									var j3 = _g16++;
									if(c4 == d1) {
										++d1;
										continue;
									}
									++count3;
									var result3 = 0;
									if(kot_FourTimesRule.distanceMatrix != null) {
										var _this3 = kot_FourTimesRule.distanceMatrix;
										var ret2 = 0;
										if(seq12 != seq22) {
											var pos12 = _this3.mNamePosLookup.values.h[seq12.mHashCode];
											if(pos12 == null) {
												throw haxe_Exception.thrown(Std.string(seq12) + " not in map!");
											}
											var pos22 = _this3.mNamePosLookup.values.h[seq22.mHashCode];
											if(pos22 == null) {
												throw haxe_Exception.thrown(Std.string(seq22) + " not in map!");
											}
											if(pos12 > pos22) {
												var swap2 = pos12;
												pos12 = pos22;
												pos22 = swap2;
											}
											ret2 = _this3.mValues[pos12 + pos22 * _this3.mWidth];
										}
										result3 = ret2;
									} else {
										if((seq22.mSeq == null ? 0 : seq22.mSeq.length) != (seq12.mSeq == null ? 0 : seq12.mSeq.length)) {
											throw haxe_Exception.thrown("Cannot compare sequences of different length!");
										}
										var score2 = 0;
										var count4 = 0;
										var _g18 = 0;
										var _g19 = seq12.mSeq == null ? 0 : seq12.mSeq.length;
										while(_g18 < _g19) {
											var i7 = _g18++;
											var c12 = seq12.mSeq.charAt(i7);
											var c22 = seq22.mSeq.charAt(i7);
											if(!(c12 == "A" || c12 == "T" || c12 == "G" || c12 == "C") || !(c22 == "A" || c22 == "T" || c22 == "G" || c22 == "C")) {
												continue;
											}
											if(c12 != c22) {
												++score2;
											}
											++count4;
										}
										var res2 = count4 == 0 ? 1.0 : score2 / count4;
										result3 = res2;
									}
									diff2 += result3;
									++d1;
								}
							}
							++c4;
						}
					}
					var pairwiseDistance1 = count3 == 0 ? 0 : diff2 / count3;
					var pi1 = 0;
					if(n1 == 1) {
						n1 = 2;
					}
					if(pairwiseDistance1 == 0) {
						var _this4 = s2.first();
						var seqLen1 = _this4.mSeq == null ? 0 : _this4.mSeq.length;
						pairwiseDistance1 = 1 / seqLen1;
						pi1 = 2 / (seqLen1 * n1 * (n1 - 1));
					} else {
						pi1 = pairwiseDistance1;
					}
					var theta2 = pi1 / (1 - 4 * pi1 / 3);
					c.mInfo.add(Std.string(s1) + " " + Std.string(s2));
					var info = kot_FourTimesRule.floatToStringPrecision(theta1,5) + "(" + s1.length + ") " + kot_FourTimesRule.floatToStringPrecision(theta2,5) + "(" + s2.length + ")";
					c.mInfo.add(info);
					var theta = theta1 > theta2 ? theta1 : theta2;
					if(theta != -1) {
						var ratio = k / theta;
						var info1 = kot_FourTimesRule.floatToStringPrecision(k,5) + "/" + kot_FourTimesRule.floatToStringPrecision(theta,5) + "=" + kot_FourTimesRule.floatToStringPrecision(ratio,5);
						c.mInfo.add(info1);
						if(ratio < decisionRatio) {
							goOn = true;
							var combined = new haxe_ds_List();
							combined.add(i1);
							combined.add(j);
							if(toCombine.h.hasOwnProperty(i1)) {
								var xI = toCombine.h[i1];
								var _g5_head2 = xI.h;
								while(_g5_head2 != null) {
									var val10 = _g5_head2.item;
									_g5_head2 = _g5_head2.next;
									var s = val10;
									combined.add(s);
								}
								toCombine.remove(i1);
							}
							if(toCombine.h.hasOwnProperty(j)) {
								var xJ = toCombine.h[j];
								var _g5_head3 = xJ.h;
								while(_g5_head3 != null) {
									var val11 = _g5_head3.item;
									_g5_head3 = _g5_head3.next;
									var s3 = val11;
									combined.add(s3);
								}
								toCombine.remove(j);
							}
							var minVal = i1 > j ? j : i1;
							toCombine.h[minVal] = combined;
						}
					}
				}
			}
			console.log("kot/FourTimesRule.hx:315:","toCombine: " + Std.string(toCombine));
			var newL = new haxe_ds_List();
			var xL = toCombine.iterator();
			while(xL.hasNext()) {
				var xL1 = xL.next();
				var alreadyDone_h = { };
				var sL = new haxe_ds_List();
				if(xL1.isEmpty()) {
					throw haxe_Exception.thrown("sL is Empty " + Std.string(toCombine));
				}
				var _g6_head = xL1.h;
				while(_g6_head != null) {
					var val12 = _g6_head.item;
					_g6_head = _g6_head.next;
					var x = val12;
					if(alreadyDone_h.hasOwnProperty(x)) {
						continue;
					}
					var idx = 0;
					var _g6_head1 = l.h;
					while(_g6_head1 != null) {
						var val13 = _g6_head1.item;
						_g6_head1 = _g6_head1.next;
						var s11 = val13;
						++idx;
						if(idx == x) {
							var _g6_head2 = s11.h;
							while(_g6_head2 != null) {
								var val14 = _g6_head2.item;
								_g6_head2 = _g6_head2.next;
								var ele = val14;
								sL.add(ele);
							}
							break;
						}
					}
					if(sL.isEmpty()) {
						throw haxe_Exception.thrown("Index " + x + " not found!");
					}
					alreadyDone_h[x] = true;
				}
				newL.add(sL);
			}
			l = newL;
		}
	} else {
		var _g1_head = sA.h;
		while(_g1_head != null) {
			var val = _g1_head.item;
			_g1_head = _g1_head.next;
			var n1 = val;
			l.add(n1);
		}
		var _g2_head = sB.h;
		while(_g2_head != null) {
			var val = _g2_head.item;
			_g2_head = _g2_head.next;
			var n2 = val;
			l.add(n2);
		}
	}
	console.log("kot/FourTimesRule.hx:356:","output: " + Std.string(l) + " " + l.length);
	return l;
};
kot_FourTimesRule.initColors = function(c,l) {
	var _this = c.mConnectedInfo;
	var value = l.first();
	_this.h["psppl"] = value;
};
kot_FourTimesRule.doRule = function(c,decisionRatio,transitivity) {
	kot_FourTimesRule.seqsInClade(c);
	var result = kot_FourTimesRule.speciesInClade(c,decisionRatio,transitivity);
	kot_FourTimesRule.initColors(c,result);
	return result;
};
var kot_Graph = function(nodeInfo) {
	var this1 = new haxe_ds__$HashMap_HashMapData();
	this.mNodes = this1;
	if(nodeInfo != null) {
		var _g = 0;
		while(_g < nodeInfo.length) {
			var node = nodeInfo[_g];
			++_g;
			var gn = new kot_GraphNode(node);
			var this1 = this.mNodes;
			var _this = this1.keys;
			var key = node.hashCode();
			_this.h[key] = node;
			var _this1 = this1.values;
			var key1 = node.hashCode();
			_this1.h[key1] = gn;
		}
	}
};
kot_Graph.__name__ = true;
kot_Graph.prototype = {
	getLeafs: function() {
		var result = new haxe_ds_List();
		var node = this.mNodes.values.iterator();
		while(node.hasNext()) {
			var node1 = node.next();
			var ele = node1.mEleObject;
			if(node1.mConnectedEdges.length >= 2) {
				continue;
			}
			result.add(ele);
		}
		return result;
	}
	,__class__: kot_Graph
};
var kot_GraphNode = function(ele) {
	this.mEleObject = ele;
	this.mConnectedEdges = new haxe_ds_List();
};
kot_GraphNode.__name__ = true;
kot_GraphNode.prototype = {
	addEdge: function(other,e) {
		var _g_head = this.mConnectedEdges.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var edge = val;
			if(edge.node == other) {
				edge.e = e;
				return;
			}
		}
		this.mConnectedEdges.add({ node : other, e : e});
	}
	,getEdge: function(other) {
		var _g_head = this.mConnectedEdges.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var edge = val;
			if(edge.node == other) {
				return edge.e;
			}
		}
		return null;
	}
	,getEdges: function() {
		var result = new haxe_ds_List();
		var _g_head = this.mConnectedEdges.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var edge = val;
			result.add({ v : edge.node.mEleObject, e : edge.e});
		}
		return result;
	}
	,__class__: kot_GraphNode
};
var kot_KoT = function() { };
kot_KoT.__name__ = true;
kot_KoT.onMessage = function(e) {
	var result = new haxe_ds_StringMap();
	try {
		var fileContent = js_Boot.__cast(e.data.txt , String);
		var decisionRatio = js_Boot.__cast(e.data.decisionRatio , Float);
		var globalDeletion = js_Boot.__cast(e.data.globalDeletion , Bool);
		var transitivity = js_Boot.__cast(e.data.transitivity , Bool);
		var g = null;
		if(fileContent.charAt(0) == ">" || fileContent.charAt(0) == ";") {
			var reader = new kot_FastaAlignmentReader();
			var seqs = reader.readSequences(fileContent,globalDeletion);
			g = kot_NeighborJoining.run(seqs);
		} else {
			var reader = new kot_DistanceMatrixReader();
			var d = reader.readMatrix(fileContent);
			g = kot_NeighborJoining.runOnMatrix(d);
			kot_FourTimesRule.distanceMatrix = d;
		}
		var c = kot_MidPointRooter.root(g);
		var s = kot_FourTimesRule.doRule(c,decisionRatio,transitivity);
		var resL = kot_KoT.formatSpeciesList(s);
		kot_CladeColorer.colorClades(c,s);
		var svg = c.getSVG();
		result.h["svg"] = svg;
		result.h["putativeSpecies"] = resL;
	} catch( _g ) {
		var e = haxe_Exception.caught(_g).unwrap();
		console.log("kot/KoT.hx:81:",e);
		result.h["svg"] = "The following error occurred: " + Std.string(e);
		result.h["putativeSpecies"] = "";
	}
	kot_KoT.workerScope.postMessage(result);
};
kot_KoT.formatSpeciesList = function(s) {
	var result = new haxe_ds_List();
	var i = 1;
	var _g_head = s.h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var subList = val;
		var _g_head1 = subList.h;
		while(_g_head1 != null) {
			var val1 = _g_head1.item;
			_g_head1 = _g_head1.next;
			var e = val1;
			if(e.mOutputted) {
				continue;
			}
			var _g_head2 = e.mNames.h;
			while(_g_head2 != null) {
				var val2 = _g_head2.item;
				_g_head2 = _g_head2.next;
				var name = val2;
				result.add(name + "\t" + i);
			}
			e.mOutputted = true;
		}
		++i;
	}
	return result.join("\n");
};
kot_KoT.main = function() {
	kot_KoT.workerScope = self;
	kot_KoT.workerScope.onmessage = kot_KoT.onMessage;
};
var kot_MidPointRooter = function() { };
kot_MidPointRooter.__name__ = true;
kot_MidPointRooter.getLongestPath = function(g,current,commingFrom) {
	var bestLength = 0;
	var path = null;
	var v1 = g.mNodes.values.h[current.mHashCode];
	if(v1 == null) {
		throw haxe_Exception.thrown(Std.string(current) + " not in graph!");
	}
	var _g_head = v1.getEdges().h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var connection = val;
		if(connection.v == commingFrom) {
			continue;
		}
		var alternative = kot_MidPointRooter.getLongestPath(g,connection.v,current);
		var l = alternative.l + connection.e;
		if(l > bestLength) {
			bestLength = l;
			path = alternative.path;
		}
	}
	if(path == null) {
		path = new haxe_ds_List();
	}
	path.add(current);
	return { path : path, l : bestLength};
};
kot_MidPointRooter.findLongestDistance = function(g) {
	var result = null;
	var _g_head = g.getLeafs().h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var seq = val;
		var alternativeResult = kot_MidPointRooter.getLongestPath(g,seq,null);
		if(result == null || result.l < alternativeResult.l) {
			result = alternativeResult;
		}
	}
	return result;
};
kot_MidPointRooter.findMidPoint = function(g) {
	var result = kot_MidPointRooter.findLongestDistance(g);
	console.log("kot/MidPointRooter.hx:61:","Longest path: " + Std.string(result.path) + " with length " + result.l);
	var midLen = result.l / 2;
	var sum = 0;
	var conLen = 0;
	var oldS = null;
	var newS = null;
	var _g_head = result.path.h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var s = val;
		oldS = newS;
		newS = s;
		if(oldS == null) {
			continue;
		}
		var v1 = g.mNodes.values.h[newS.mHashCode];
		var v2 = g.mNodes.values.h[oldS.mHashCode];
		conLen = v1.getEdge(v2);
		sum += conLen;
		if(sum > midLen) {
			break;
		}
	}
	return { n1 : oldS, n2 : newS, a : conLen - (sum - midLen), b : sum - midLen};
};
kot_MidPointRooter.root = function(g) {
	var midPoint = kot_MidPointRooter.findMidPoint(g);
	console.log("kot/MidPointRooter.hx:87:","midPoint: " + Std.string(midPoint));
	var rootClade = new kot_Clade();
	kot_MidPointRooter.genSubClade(g,midPoint.n1,midPoint.n2,rootClade,midPoint.a,0);
	kot_MidPointRooter.genSubClade(g,midPoint.n2,midPoint.n1,rootClade,midPoint.b,0);
	return rootClade;
};
kot_MidPointRooter.genSubClade = function(g,process,commingFrom,parentClade,dist,lvl) {
	var v1 = g.mNodes.values.h[process.mHashCode];
	if(v1 == null) {
		throw haxe_Exception.thrown(Std.string(process) + " not in graph!");
	}
	var connections = v1.getEdges();
	var clade = new kot_Clade();
	var seq = process.mSeq;
	if(seq != null) {
		clade.mConnectedInfo.h["sequence"] = process;
	}
	var result = null;
	if(process.mNames == null || process.mNames.length == 0) {
		result = "noName";
	} else if(process.mNames.length == 1) {
		result = process.mNames.first();
	} else {
		result = process.mNames.join(",");
	}
	if(result != "noName") {
		var result = null;
		if(process.mNames == null || process.mNames.length == 0) {
			result = "noName";
		} else if(process.mNames.length == 1) {
			result = process.mNames.first();
		} else {
			result = process.mNames.join(",");
		}
		clade.mInfo.add(result);
	}
	clade.mParent = parentClade;
	if(dist != null) {
		clade.mDist = dist;
	}
	parentClade.mChilds.add(clade);
	var v1 = g.mNodes.values.h[process.mHashCode];
	if(v1 == null) {
		throw haxe_Exception.thrown(Std.string(process) + " not in graph!");
	}
	var _g_head = v1.getEdges().h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var connection = val;
		if(connection.v == commingFrom) {
			continue;
		}
		kot_MidPointRooter.genSubClade(g,connection.v,process,clade,connection.e,lvl + 1);
	}
};
var kot_NeighborJoining = function() { };
kot_NeighborJoining.__name__ = true;
kot_NeighborJoining.run = function(seqs) {
	var this1 = new Array(seqs.length);
	var r = this1;
	haxe_ds_Vector.blit(seqs,0,r,0,seqs.length);
	var endPoints = r;
	var nrIndividuals = seqs.length;
	var d = new kot_DistanceMatrix(endPoints);
	var _g = 0;
	while(_g < endPoints.length) {
		var ind1 = endPoints[_g];
		++_g;
		var _g1 = 0;
		while(_g1 < endPoints.length) {
			var ind2 = endPoints[_g1];
			++_g1;
			if(ind1 == ind2) {
				break;
			}
			if((ind2.mSeq == null ? 0 : ind2.mSeq.length) != (ind1.mSeq == null ? 0 : ind1.mSeq.length)) {
				throw haxe_Exception.thrown("Cannot compare sequences of different length!");
			}
			var score = 0;
			var count = 0;
			var _g2 = 0;
			var _g3 = ind1.mSeq == null ? 0 : ind1.mSeq.length;
			while(_g2 < _g3) {
				var i = _g2++;
				var c1 = ind1.mSeq.charAt(i);
				var c2 = ind2.mSeq.charAt(i);
				if(!(c1 == "A" || c1 == "T" || c1 == "G" || c1 == "C") || !(c2 == "A" || c2 == "T" || c2 == "G" || c2 == "C")) {
					continue;
				}
				if(c1 != c2) {
					++score;
				}
				++count;
			}
			var diff = count == 0 ? 1.0 : score / count;
			if(ind1 == ind2) {
				if(diff != 0) {
					throw haxe_Exception.thrown("Distance of identical objects must be 0!");
				}
			}
			var pos1 = d.mNamePosLookup.values.h[ind1.mHashCode];
			if(pos1 == null) {
				throw haxe_Exception.thrown(Std.string(ind1) + " not in map!");
			}
			var pos2 = d.mNamePosLookup.values.h[ind2.mHashCode];
			if(pos2 == null) {
				throw haxe_Exception.thrown(Std.string(ind2) + " not in map!");
			}
			if(pos1 > pos2) {
				var swap = pos1;
				pos1 = pos2;
				pos2 = swap;
			}
			d.mValues[pos1 + pos2 * d.mWidth] = diff;
		}
	}
	return kot_NeighborJoining.runOnMatrix(d);
};
kot_NeighborJoining.runOnMatrix = function(d) {
	var endPoints = d.mNames;
	var result = new kot_Graph(endPoints);
	var innerNumber = 0;
	while(endPoints.length > 2) {
		var r_keys_h = { };
		var r_values_h = { };
		var _g = 0;
		while(_g < endPoints.length) {
			var seq = endPoints[_g];
			++_g;
			var sum = 0;
			var _g1 = 0;
			while(_g1 < endPoints.length) {
				var otherSeq = endPoints[_g1];
				++_g1;
				var ret = 0;
				if(seq != otherSeq) {
					var pos1 = d.mNamePosLookup.values.h[seq.mHashCode];
					if(pos1 == null) {
						throw haxe_Exception.thrown(Std.string(seq) + " not in map!");
					}
					var pos2 = d.mNamePosLookup.values.h[otherSeq.mHashCode];
					if(pos2 == null) {
						throw haxe_Exception.thrown(Std.string(otherSeq) + " not in map!");
					}
					if(pos1 > pos2) {
						var swap = pos1;
						pos1 = pos2;
						pos2 = swap;
					}
					ret = d.mValues[pos1 + pos2 * d.mWidth];
				}
				sum += ret;
			}
			r_keys_h[seq.mHashCode] = seq;
			r_values_h[seq.mHashCode] = sum / (endPoints.length - 2);
		}
		var m = new kot_DistanceMatrix(endPoints);
		var _g2 = 0;
		while(_g2 < endPoints.length) {
			var seq1 = endPoints[_g2];
			++_g2;
			var r_i = r_values_h[seq1.mHashCode];
			var _g3 = 0;
			while(_g3 < endPoints.length) {
				var seq2 = endPoints[_g3];
				++_g3;
				if(seq1 == seq2) {
					break;
				}
				var r_j = r_values_h[seq2.mHashCode];
				var ret1 = 0;
				if(seq1 != seq2) {
					var pos11 = d.mNamePosLookup.values.h[seq1.mHashCode];
					if(pos11 == null) {
						throw haxe_Exception.thrown(Std.string(seq1) + " not in map!");
					}
					var pos21 = d.mNamePosLookup.values.h[seq2.mHashCode];
					if(pos21 == null) {
						throw haxe_Exception.thrown(Std.string(seq2) + " not in map!");
					}
					if(pos11 > pos21) {
						var swap1 = pos11;
						pos11 = pos21;
						pos21 = swap1;
					}
					ret1 = d.mValues[pos11 + pos21 * d.mWidth];
				}
				var val = ret1 - (r_i + r_j);
				if(seq1 == seq2) {
					if(val != 0) {
						throw haxe_Exception.thrown("Distance of identical objects must be 0!");
					}
				}
				var pos12 = m.mNamePosLookup.values.h[seq1.mHashCode];
				if(pos12 == null) {
					throw haxe_Exception.thrown(Std.string(seq1) + " not in map!");
				}
				var pos22 = m.mNamePosLookup.values.h[seq2.mHashCode];
				if(pos22 == null) {
					throw haxe_Exception.thrown(Std.string(seq2) + " not in map!");
				}
				if(pos12 > pos22) {
					var swap2 = pos12;
					pos12 = pos22;
					pos22 = swap2;
				}
				m.mValues[pos12 + pos22 * m.mWidth] = val;
			}
		}
		var lowestSeq1 = endPoints[0];
		var lowestSeq2 = endPoints[1];
		var ret2 = 0;
		if(lowestSeq1 != lowestSeq2) {
			var pos13 = m.mNamePosLookup.values.h[lowestSeq1.mHashCode];
			if(pos13 == null) {
				throw haxe_Exception.thrown(Std.string(lowestSeq1) + " not in map!");
			}
			var pos23 = m.mNamePosLookup.values.h[lowestSeq2.mHashCode];
			if(pos23 == null) {
				throw haxe_Exception.thrown(Std.string(lowestSeq2) + " not in map!");
			}
			if(pos13 > pos23) {
				var swap3 = pos13;
				pos13 = pos23;
				pos23 = swap3;
			}
			ret2 = m.mValues[pos13 + pos23 * m.mWidth];
		}
		var lowestVal = ret2;
		var _g4 = 0;
		while(_g4 < endPoints.length) {
			var seq11 = endPoints[_g4];
			++_g4;
			var _g5 = 0;
			while(_g5 < endPoints.length) {
				var seq21 = endPoints[_g5];
				++_g5;
				if(seq11 == seq21) {
					break;
				}
				var ret3 = 0;
				if(seq11 != seq21) {
					var pos14 = m.mNamePosLookup.values.h[seq11.mHashCode];
					if(pos14 == null) {
						throw haxe_Exception.thrown(Std.string(seq11) + " not in map!");
					}
					var pos24 = m.mNamePosLookup.values.h[seq21.mHashCode];
					if(pos24 == null) {
						throw haxe_Exception.thrown(Std.string(seq21) + " not in map!");
					}
					if(pos14 > pos24) {
						var swap4 = pos14;
						pos14 = pos24;
						pos24 = swap4;
					}
					ret3 = m.mValues[pos14 + pos24 * m.mWidth];
				}
				var currentVal = ret3;
				if(currentVal < lowestVal) {
					lowestSeq1 = seq11;
					lowestSeq2 = seq21;
					var ret4 = 0;
					if(lowestSeq1 != lowestSeq2) {
						var pos15 = m.mNamePosLookup.values.h[lowestSeq1.mHashCode];
						if(pos15 == null) {
							throw haxe_Exception.thrown(Std.string(lowestSeq1) + " not in map!");
						}
						var pos25 = m.mNamePosLookup.values.h[lowestSeq2.mHashCode];
						if(pos25 == null) {
							throw haxe_Exception.thrown(Std.string(lowestSeq2) + " not in map!");
						}
						if(pos15 > pos25) {
							var swap5 = pos15;
							pos15 = pos25;
							pos25 = swap5;
						}
						ret4 = m.mValues[pos15 + pos25 * m.mWidth];
					}
					lowestVal = ret4;
				}
			}
		}
		var l = new haxe_ds_List();
		var inner = new kot_Sequence(l,null);
		var ret5 = 0;
		if(lowestSeq1 != lowestSeq2) {
			var pos16 = d.mNamePosLookup.values.h[lowestSeq1.mHashCode];
			if(pos16 == null) {
				throw haxe_Exception.thrown(Std.string(lowestSeq1) + " not in map!");
			}
			var pos26 = d.mNamePosLookup.values.h[lowestSeq2.mHashCode];
			if(pos26 == null) {
				throw haxe_Exception.thrown(Std.string(lowestSeq2) + " not in map!");
			}
			if(pos16 > pos26) {
				var swap6 = pos16;
				pos16 = pos26;
				pos26 = swap6;
			}
			ret5 = d.mValues[pos16 + pos26 * d.mWidth];
		}
		var dist = ret5;
		var v_iu = (dist + r_values_h[lowestSeq1.mHashCode] - r_values_h[lowestSeq2.mHashCode]) / 2;
		var v_ju = dist - v_iu;
		if(v_iu < 0 && v_ju < 0) {
			var x_tmp = v_iu;
			v_iu = -v_ju;
			v_ju = -x_tmp;
		} else {
			if(v_iu < 0) {
				v_ju -= v_iu;
				v_iu = 0;
			}
			if(v_ju < 0) {
				v_iu -= v_ju;
				v_ju = 0;
			}
		}
		var gn = new kot_GraphNode(inner);
		var this1 = result.mNodes;
		this1.keys.h[inner.mHashCode] = inner;
		this1.values.h[inner.mHashCode] = gn;
		var v1 = result.mNodes.values.h[lowestSeq1.mHashCode];
		if(v1 == null) {
			throw haxe_Exception.thrown(Std.string(lowestSeq1) + " not in graph!");
		}
		var v2 = result.mNodes.values.h[inner.mHashCode];
		if(v2 == null) {
			throw haxe_Exception.thrown(Std.string(inner) + " not in graph!");
		}
		v1.addEdge(v2,v_iu);
		v2.addEdge(v1,v_iu);
		var v11 = result.mNodes.values.h[lowestSeq2.mHashCode];
		if(v11 == null) {
			throw haxe_Exception.thrown(Std.string(lowestSeq2) + " not in graph!");
		}
		var v21 = result.mNodes.values.h[inner.mHashCode];
		if(v21 == null) {
			throw haxe_Exception.thrown(Std.string(inner) + " not in graph!");
		}
		v11.addEdge(v21,v_ju);
		v21.addEdge(v11,v_ju);
		var this2 = new Array(endPoints.length - 1);
		var endPoints_new = this2;
		var idx = 0;
		var _g6 = 0;
		while(_g6 < endPoints.length) {
			var seq3 = endPoints[_g6];
			++_g6;
			if(seq3 == lowestSeq1 || seq3 == lowestSeq2) {
				continue;
			}
			endPoints_new[idx++] = seq3;
		}
		endPoints_new[idx] = inner;
		var d_new = new kot_DistanceMatrix(endPoints_new);
		var _g7 = 0;
		while(_g7 < endPoints_new.length) {
			var seq12 = endPoints_new[_g7];
			++_g7;
			var _g8 = 0;
			while(_g8 < endPoints_new.length) {
				var seq22 = endPoints_new[_g8];
				++_g8;
				if(seq12 == seq22) {
					break;
				}
				if(seq12 == inner || seq22 == inner) {
					var k = seq12 == inner ? seq22 : seq12;
					var ret6 = 0;
					if(lowestSeq1 != k) {
						var pos17 = d.mNamePosLookup.values.h[lowestSeq1.mHashCode];
						if(pos17 == null) {
							throw haxe_Exception.thrown(Std.string(lowestSeq1) + " not in map!");
						}
						var pos27 = d.mNamePosLookup.values.h[k.mHashCode];
						if(pos27 == null) {
							throw haxe_Exception.thrown(Std.string(k) + " not in map!");
						}
						if(pos17 > pos27) {
							var swap7 = pos17;
							pos17 = pos27;
							pos27 = swap7;
						}
						ret6 = d.mValues[pos17 + pos27 * d.mWidth];
					}
					var ret7 = 0;
					if(lowestSeq2 != k) {
						var pos18 = d.mNamePosLookup.values.h[lowestSeq2.mHashCode];
						if(pos18 == null) {
							throw haxe_Exception.thrown(Std.string(lowestSeq2) + " not in map!");
						}
						var pos28 = d.mNamePosLookup.values.h[k.mHashCode];
						if(pos28 == null) {
							throw haxe_Exception.thrown(Std.string(k) + " not in map!");
						}
						if(pos18 > pos28) {
							var swap8 = pos18;
							pos18 = pos28;
							pos28 = swap8;
						}
						ret7 = d.mValues[pos18 + pos28 * d.mWidth];
					}
					var ret8 = 0;
					if(lowestSeq1 != lowestSeq2) {
						var pos19 = d.mNamePosLookup.values.h[lowestSeq1.mHashCode];
						if(pos19 == null) {
							throw haxe_Exception.thrown(Std.string(lowestSeq1) + " not in map!");
						}
						var pos29 = d.mNamePosLookup.values.h[lowestSeq2.mHashCode];
						if(pos29 == null) {
							throw haxe_Exception.thrown(Std.string(lowestSeq2) + " not in map!");
						}
						if(pos19 > pos29) {
							var swap9 = pos19;
							pos19 = pos29;
							pos29 = swap9;
						}
						ret8 = d.mValues[pos19 + pos29 * d.mWidth];
					}
					var dist1 = (ret6 + ret7 - ret8) / 2;
					if(seq12 == seq22) {
						if(dist1 != 0) {
							throw haxe_Exception.thrown("Distance of identical objects must be 0!");
						}
					}
					var pos110 = d_new.mNamePosLookup.values.h[seq12.mHashCode];
					if(pos110 == null) {
						throw haxe_Exception.thrown(Std.string(seq12) + " not in map!");
					}
					var pos210 = d_new.mNamePosLookup.values.h[seq22.mHashCode];
					if(pos210 == null) {
						throw haxe_Exception.thrown(Std.string(seq22) + " not in map!");
					}
					if(pos110 > pos210) {
						var swap10 = pos110;
						pos110 = pos210;
						pos210 = swap10;
					}
					d_new.mValues[pos110 + pos210 * d_new.mWidth] = dist1;
				} else {
					var ret9 = 0;
					if(seq12 != seq22) {
						var pos111 = d.mNamePosLookup.values.h[seq12.mHashCode];
						if(pos111 == null) {
							throw haxe_Exception.thrown(Std.string(seq12) + " not in map!");
						}
						var pos211 = d.mNamePosLookup.values.h[seq22.mHashCode];
						if(pos211 == null) {
							throw haxe_Exception.thrown(Std.string(seq22) + " not in map!");
						}
						if(pos111 > pos211) {
							var swap11 = pos111;
							pos111 = pos211;
							pos211 = swap11;
						}
						ret9 = d.mValues[pos111 + pos211 * d.mWidth];
					}
					var dist2 = ret9;
					if(seq12 == seq22) {
						if(dist2 != 0) {
							throw haxe_Exception.thrown("Distance of identical objects must be 0!");
						}
					}
					var pos112 = d_new.mNamePosLookup.values.h[seq12.mHashCode];
					if(pos112 == null) {
						throw haxe_Exception.thrown(Std.string(seq12) + " not in map!");
					}
					var pos212 = d_new.mNamePosLookup.values.h[seq22.mHashCode];
					if(pos212 == null) {
						throw haxe_Exception.thrown(Std.string(seq22) + " not in map!");
					}
					if(pos112 > pos212) {
						var swap12 = pos112;
						pos112 = pos212;
						pos212 = swap12;
					}
					d_new.mValues[pos112 + pos212 * d_new.mWidth] = dist2;
				}
			}
		}
		endPoints = endPoints_new;
		d = d_new;
	}
	var x1 = endPoints[0];
	var x2 = endPoints[1];
	var ret = 0;
	if(x1 != x2) {
		var pos1 = d.mNamePosLookup.values.h[x1.mHashCode];
		if(pos1 == null) {
			throw haxe_Exception.thrown(Std.string(x1) + " not in map!");
		}
		var pos2 = d.mNamePosLookup.values.h[x2.mHashCode];
		if(pos2 == null) {
			throw haxe_Exception.thrown(Std.string(x2) + " not in map!");
		}
		if(pos1 > pos2) {
			var swap = pos1;
			pos1 = pos2;
			pos2 = swap;
		}
		ret = d.mValues[pos1 + pos2 * d.mWidth];
	}
	var dist = ret;
	var x = endPoints[0];
	var y = endPoints[1];
	var v1 = result.mNodes.values.h[x.mHashCode];
	if(v1 == null) {
		throw haxe_Exception.thrown(Std.string(x) + " not in graph!");
	}
	var v2 = result.mNodes.values.h[y.mHashCode];
	if(v2 == null) {
		throw haxe_Exception.thrown(Std.string(y) + " not in graph!");
	}
	v1.addEdge(v2,dist);
	v2.addEdge(v1,dist);
	return result;
};
var kot_Sequence = function(names,seq) {
	this.mOutputted = false;
	this.mNames = names;
	this.mSeq = seq == null ? seq : seq.toUpperCase();
	this.mHashCode = kot_Sequence.nextHashCode;
	kot_Sequence.nextHashCode++;
};
kot_Sequence.__name__ = true;
kot_Sequence.prototype = {
	getNodeName: function() {
		var result = null;
		if(this.mNames == null || this.mNames.length == 0) {
			result = "noName";
		} else if(this.mNames.length == 1) {
			result = this.mNames.first();
		} else {
			result = this.mNames.join(",");
		}
		return result;
	}
	,toString: function() {
		var result = null;
		if(this.mNames == null || this.mNames.length == 0) {
			result = "noName";
		} else if(this.mNames.length == 1) {
			result = this.mNames.first();
		} else {
			result = this.mNames.join(",");
		}
		return result;
	}
	,hashCode: function() {
		return this.mHashCode;
	}
	,getBadPositions: function(result) {
		var _g = 0;
		var _g1 = this.mSeq.length;
		while(_g < _g1) {
			var i = _g++;
			var c = this.mSeq.charAt(i);
			if(c != "A" && c != "T" && c != "G" && c != "C" && c != "-") {
				result.h[i] = true;
			}
		}
	}
	,removePositions: function(im) {
		var newS = new haxe_ds_List();
		var _g = 0;
		var _g1 = this.mSeq.length;
		while(_g < _g1) {
			var i = _g++;
			var c = this.mSeq.charAt(i);
			if(im.h[i]) {
				continue;
			}
			newS.add(c);
		}
		return newS.join("");
	}
	,__class__: kot_Sequence
};
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { };
var Dynamic = { };
var Float = Number;
var Bool = Boolean;
var Class = { };
var Enum = { };
js_Boot.__toStr = ({ }).toString;
kot_CladeColorer.colors = ["#FF0000","#00FF00","#0000FF","#CC0000","#00CC00","#0000CC","#CC6600","#99CC00","#006699","#CC9900","#00CC99","#CC00CC","#CC6699","#009933","#0033CC","#6600FF","#3333FF"];
kot_Sequence.nextHashCode = 0;
kot_KoT.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
