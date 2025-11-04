<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei"
  version="1.0">

  <!-- hide header -->
  <xsl:template match="tei:teiHeader"/>

  <!-- BODY layout: left margin + right transcription -->
  <xsl:template match="tei:body">
    <div class="row">
      <!-- Left margin notes (independent positioned items) -->
      <div class="col-3">
        <div class="marginLeft">
          <xsl:for-each select="//tei:add[@place='marginleft']">
            <div class="marginItem {substring(@hand,2)}">
              <xsl:attribute name="data-pos">
                <xsl:choose>
                  <xsl:when test=". = 'avoid'">avoid</xsl:when>
                  <xsl:when test=". = 'have'">have</xsl:when>
                  <xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="data-hand">
                <xsl:value-of select="substring(@hand,2)"/>
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test="parent::tei:del">
                  <del class="{substring(@hand,2)}" data-hand="{substring(@hand,2)}">
                    <xsl:apply-templates/>
                  </del>
                </xsl:when>
                <xsl:otherwise>
                  <span class="{substring(@hand,2)}" data-hand="{substring(@hand,2)}">
                    <xsl:apply-templates/>
                  </span>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </xsl:for-each>
        </div>
      </div>

      <!-- Right main transcription -->
      <div class="col-9">
        <div class="transcription">
          <xsl:apply-templates select="//tei:div"/>
        </div>
      </div>
    </div>
  </xsl:template>

  <!-- Div -->
  <xsl:template match="tei:div">
    <div><xsl:apply-templates/></div>
  </xsl:template>

  <!-- Chapter heading -->
  <xsl:template match="tei:head">
    <h2 class="chapter-head"><xsl:apply-templates/></h2>
  </xsl:template>

  <!-- Paragraph -->
  <xsl:template match="tei:p">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <!-- Line breaks -->
  <xsl:template match="tei:lb"><br/></xsl:template>

  <!-- Additions: supralinear -->
  <xsl:template match="tei:add[@place='supralinear']">
    <span class="supraAdd {substring(@hand,2)}" data-hand="{substring(@hand,2)}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!-- Additions: above -->
  <xsl:template match="tei:add[@place='above']">
    <span class="aboveAdd {substring(@hand,2)}" data-hand="{substring(@hand,2)}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!-- Additions: marginleft inside main flow (hidden; we show them in gutter) -->
  <xsl:template match="tei:add[@place='marginleft']">
    <span class="marginAdd {substring(@hand,2)}" data-hand="{substring(@hand,2)}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!-- Generic additions (if any other place appears) -->
  <xsl:template match="tei:add[not(@place='supralinear') and not(@place='marginleft') and not(@place='above')]">
    <span class="{substring(@hand,2)}" data-hand="{substring(@hand,2)}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!-- Deletions -->
  <xsl:template match="tei:del">
    <xsl:choose>
      <xsl:when test="@rend='supralinear'">
        <del class="supraAdd {substring(@hand,2)}" data-hand="{substring(@hand,2)}">
          <xsl:apply-templates/>
        </del>
      </xsl:when>
      <xsl:otherwise>
        <del class="{substring(@hand,2)}" data-hand="{substring(@hand,2)}">
          <xsl:apply-templates/>
        </del>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Inline styles -->
  <xsl:template match="tei:hi[@rend='sup']">
    <sup><xsl:apply-templates/></sup>
  </xsl:template>

  <xsl:template match="tei:hi[@rend='u']">
    <span class="u"><xsl:apply-templates/></span>
  </xsl:template>

  <!-- Page number -->
  <xsl:template match="tei:metamark[@function='pagenumber']">
    <span class="pagenumber"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:hi[@rend='circled']">
    <span class="circled"><xsl:apply-templates/></span>
  </xsl:template>

</xsl:stylesheet>
