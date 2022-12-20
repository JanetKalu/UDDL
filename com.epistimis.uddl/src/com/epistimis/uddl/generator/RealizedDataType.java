package com.epistimis.uddl.generator;

import com.epistimis.uddl.uddl.PlatformDataType;

/**
 * This handles the realizations of all PlatformDataTypes. Most of them only
 * requiring tracking their type. Some (Array,Sequence, Fixed, Struct) may need
 * additional classes to handle the additional info
 *
 * @author stevehickman
 *
 */
public class RealizedDataType extends RealizedComposableElement {

	public enum DataType {
		SEQUENCE("PlatformSequence"), BOOLEAN("PlatformBoolean"), CHAR("PlatformChar"), FIXED("PlatformFixed"),
		FLOAT("PlatformFloat"), DOUBLE("PlatformDouble"), LONG_DOUBLE("PlatformLongDouble"), LONG("PlatformLong"),
		SHORT("PlatformShort"), USHORT("PlatformUShort"), ULONG("PlatformULong"), ULLONG("PlatformULongLong"),
		LLONG("PlatformLongLong"), OCTET("PlatformOctet"), ENUMERATION("PlatformEnumeration"), STRING("PlatformString"),
		BOUNDED_STRING("PlatformBoundedString"), CHAR_ARRAY("PlatformCharArray"), ARRAY("PlatformArray"),
		PRIMITIVE("PlatformPrimitive"), NUMBER("PlatformNumber"),INTEGER("PlatformInteger"), UNSIGNED_INTEGER("PlatformUnsignedInteger"),
		STRING_TYPE("PLatformStringType"), REAL("PlatformReal"),
		STRUCT("PlatformStruct");

		private final String simpleClass;

		private DataType(String simpleClass) {
			this.simpleClass = simpleClass;
		}

		public String clzName() {
			return simpleClass;
		}

		public static boolean isa(PlatformDataType a, PlatformDataType b) {
			Class<? extends PlatformDataType> bClz = b.getClass();
			return bClz.isInstance(a);
		}

		public static boolean isa(DataType a, DataType b) {
			Class<?> aClz,bClz;
			try {
				bClz = Class.forName(b.simpleClass);
				aClz = Class.forName(a.simpleClass);
				aClz.asSubclass(bClz);
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (ClassCastException e ) {
				return false;
			}
			return true;
		}

	}

	private DataType type;

	public RealizedDataType(PlatformDataType pdt) {
		super(pdt);
		String clzName = pdt.getClass().getSimpleName();
		// Strip off 'Platform' and 'Impl'
		String enumVal = clzName.substring(8,clzName.lastIndexOf("Impl")).toUpperCase();
		this.setType(Enum.valueOf(RealizedDataType.DataType.class,enumVal));

	}

	public DataType getType() {
		return type;
	}

	public void setType(DataType type) {
		this.type = type;
	}

}
