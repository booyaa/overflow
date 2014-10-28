##xslt

###concatenation
convert LongDate (YYYYMMDD) to DD-MM-YYYY

```<xsl:value-of select="concat(substring(LongDate,6,2),'-',substring(LongDate,4,2),'-',substring(LongDate,1,4))"/>```

###if else v1
```
<xsl:choose>
	<xsl:when test="starts-with(ShopperId,'FOO')">
		<xsl:value-of select="ShopperId"/>
	</xsl:when>
	<xsl:otherwise>BAR</xsl:otherwise>
</xsl:choose>
```

###substring
```<xsl:value-of select="substring(MobileNumber,1,5)"/>```

###value-of
```<xsl:value-of select="/root/Book/Chapter1"/>```


