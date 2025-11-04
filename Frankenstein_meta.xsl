<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei"
    version="1.0">

  <xsl:template match="tei:TEI">
    <div class="metadata-container">
      <!-- Left column: Manuscript info -->
      <div class="metadata-info">
        <h4>Manuscript Information</h4>
        <p>
          <xsl:value-of select="//tei:sourceDesc/tei:p"/>
        </p>
        <p class="license-text">
          <small>Original text by Mary Shelley (1816). Public domain, under a CC-BY-NC 4.0 licence.</small>
        </p>
      </div>

      <!-- Right column: Detailed statistics -->
      <div class="metadata-stats">
        <h4>Editing Statistics</h4>
        
        <!-- Overall modifications -->
        <div class="stat-section">
          <h5>Overall Changes</h5>
          <ul class="stat-list">
            <li><span class="stat-label">Total modifications:</span> <span class="stat-value"><xsl:value-of select="count(//tei:del | //tei:add)"/></span></li>
            <li><span class="stat-label">Additions:</span> <span class="stat-value"><xsl:value-of select="count(//tei:add)"/></span></li>
            <li><span class="stat-label">Deletions:</span> <span class="stat-value"><xsl:value-of select="count(//tei:del)"/></span></li>
          </ul>
        </div>

        <!-- Mary Shelley stats -->
        <div class="stat-section mws-section">
          <h5>Mary Wollstonecraft Shelley</h5>
          <ul class="stat-list">
            <li><span class="stat-label">Total edits:</span> <span class="stat-value"><xsl:value-of select="count(//tei:add[@hand='#MWS'] | //tei:del[@hand='#MWS'])"/></span></li>
            <li><span class="stat-label">Additions:</span> <span class="stat-value"><xsl:value-of select="count(//tei:add[@hand='#MWS'])"/></span></li>
            <li><span class="stat-label">Deletions:</span> <span class="stat-value"><xsl:value-of select="count(//tei:del[@hand='#MWS'])"/></span></li>
          </ul>
        </div>

        <!-- Percy Shelley stats -->
        <div class="stat-section pbs-section">
          <h5>Percy Bysshe Shelley</h5>
          <ul class="stat-list">
            <li><span class="stat-label">Total edits:</span> <span class="stat-value"><xsl:value-of select="count(//tei:add[@hand='#PBS'] | //tei:del[@hand='#PBS'])"/></span></li>
            <li><span class="stat-label">Additions:</span> <span class="stat-value"><xsl:value-of select="count(//tei:add[@hand='#PBS'])"/></span></li>
            <li><span class="stat-label">Deletions:</span> <span class="stat-value"><xsl:value-of select="count(//tei:del[@hand='#PBS'])"/></span></li>
          </ul>
        </div>

        <!-- Text statistics -->
        <div class="stat-section">
          <h5>Text Statistics</h5>
          <ul class="stat-list">
            <li><span class="stat-label">Approximate words:</span> <span class="stat-value"><xsl:value-of select="round(string-length(normalize-space(//tei:body)) div 5)"/></span></li>
            <li><span class="stat-label">Characters:</span> <span class="stat-value"><xsl:value-of select="string-length(normalize-space(//tei:body))"/></span></li>
            <li><span class="stat-label">Paragraphs:</span> <span class="stat-value"><xsl:value-of select="count(//tei:p)"/></span></li>
          </ul>
        </div>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
