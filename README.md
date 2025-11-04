# Check the website

https://cnserge.github.io/sergesfrankenstein/


# Reflection Report

Working on this digital edition taught me how the technical and editorial parts of scholarly editing works together. I started from the TEI-XML encoding of Mary Shelley's Frankenstein pages (folios 21r-25v) and gradually understood how every tag and attribute affects the structure and the way it is displayed. Even though I used AI assistance for the initial setup and debugging, I organized, tested, and modified everything myself in VS Code, making clear decisions about the edition's architecture and presentation.

One of my main decisions was to merge all individual HTML pages into one dynamic viewer.html, controlled by JavaScript URL parameters such as `viewer.html?folio=21r`. This reduced redundant code significantly and made the edition much easier to maintain—any styling or functionality change now applies to all pages automatically. I also experimented extensively with Mirador IIIF integration and XSLT templates until I could properly display the folio images alongside color-coded transcriptions that distinguish Mary Shelley's edits from Percy Shelley's.

The hardest part was learning the logic of XSLT and XPath, understanding how to select and transform specific TEI elements (`<del>`, `<add>`, `<hi>`) without breaking the document structure or losing scholarly information. I had to standardize inconsistent XML encoding across multiple files, ensuring that deletion markers used `type="crossedOut"` rather than mixed attribute formats. Through trial and error, I learned to debug XML namespaces, link CSS for proper styling, and create interactive JavaScript functions to filter out the content by author or toggling deleted text visibility.

The project also involved creating two specialized XSLT stylesheets: one for rendering the manuscript text with proper HTML semantics, and another for extracting metadata statistics that display dynamically at the bottom of each page. I configured Mirador to show only the relevant manuscript pages (canvas indices 44-53) rather than the entire Bodleian Library collection.

Overall, this project helped me see how XML, XSLT, CSS, and JavaScript connect into one integrated digital humanities system. It was the first time I felt I built something that meaningfully combines programming skills with literary editing principles, creating both a functional web application and a scholarly resource. I now understand both the technical possibilities of digital editions and the precision required in scholarly markup—every `<del hand="#MWS">` tag represents an interpretive decision about Mary Shelley's creative process that affects how users experience the text.

The edition successfully demonstrates the collaborative nature of Frankenstein's composition while providing multiple reading modes for different scholarly needs, from diplomatic transcription to clean reading text. This balance between technical implementation and editorial scholarship is what makes digital humanities work both challenging and rewarding.
- Maps TEI elements to semantic HTML with CSS classes
- Implements hand attribution coloring:
  - Mary Shelley: `.MWS` (crimson)
  - Percy Shelley: `.PBS` (navy)
- Handles structural elements: `<p>`, `<del>`, `<add>`, `<hi rend="sup/u">`
- Supports filtering and toggle functionality via JavaScript

#### Frankenstein_meta.xsl
- Extracts comprehensive manuscript statistics using XPath:
  - Total modifications: `count(//tei:del | //tei:add)`
  - Mary/Percy-specific counts: `count(//tei:add[@hand='#MWS'] | //tei:del[@hand='#MWS'])`
  - Text metrics: word count (char-length ÷ 5), character count, paragraph count
- Generates professional HTML dashboard with semantic grouping
- Integrates directly into page display via XSLTProcessor

### 1.3 Dynamic Architecture Refactoring
**Previous State:** 10 individual HTML files (21r.html-25v.html) + separate script.js = maintenance nightmare

**New State:** Single `viewer.html` + `viewer-script.js`
- URL parameter-based page selection: `viewer.html?folio=21r`
- Dynamic XML/XSLT loading based on folio
- Navigation loop: 25v → 21r (circular, no dead ends)
- **Benefit:** 80% reduction in redundant code, centralized logic, easier updates

**Implementation Details:**
```javascript
// URL parameter parsing
const folio = new URLSearchParams(window.location.search).get('folio') || '21r';

// Parallel file loading
Promise.all([
  fetch(`${folio}.xml`).then(r => r.text()),
  fetch('Frankenstein_text.xsl').then(r => r.text()),
  fetch('Frankenstein_meta.xsl').then(r => r.text())
])
```

### 1.4 CSS Styling & Visual Design
**Design Philosophy:** Scholarly presentation with elegant typography and hand-based color coding

**Key Features:**
- **Manuscript Header:** Brown gradient background (color: #8b4513), serif fonts, vintage aesthetic
- **Hand Color Coding:** 
  - Mary Shelley edits: Crimson (#dc143c)
  - Percy Shelley edits: Navy (#000080)
  - Visual distinction without overwhelming the text
- **Metadata Dashboard:**
  - Grid layout: 1fr 2fr columns
  - Color-coded stat sections (crimson/navy borders matching authors)
  - Badge-style stat values with monospace font
  - Responsive design (adjusts on mobile)
- **Spacing & Hierarchy:** Strategic use of white space, 3rem top margin for metadata separation

**CSS Challenges Overcome:**
- Initial spacing between Mirador and text: Solved via Bootstrap gutter override and inline styles
- Metadata positioning: Initially inline with header, moved to page bottom per user request
- Color contrast: Tested crimson/navy on white background for accessibility

### 1.5 Interactive JavaScript Functions
Implemented 4 core functionalities:

1. **selectHand(event)**: Filter text by author
   - `value="both"`: Show all edits
   - `value="Mary"`: Highlight Mary's edits, dim Percy's
   - `value="Percy"`: Highlight Percy's edits, dim Mary's
   - Uses `.hand-highlight` and `.hand-dim` classes

2. **toggleDeletions()**: Show/hide deleted text
   - Toggles visibility of `.MWS` and `.PBS` elements when in deletion context
   - Useful for reading view clarity

3. **readingView()**: Clean text without apparatus
   - Hides hand attribution classes
   - Shows normalized text flow
   - For continuous reading experience

4. **Navigation Loop:** Previous/Next buttons with wrapping
   - 25v next → 21r (circular)
   - 21r prev → 25v (circular)
   - No broken links

### 1.6 Mirador IIIF Integration
**Challenge:** Mirador was showing entire Bodleian Library collection (300+ pages)

**Solution:** Customized Mirador configuration
- Restricted to canvases 44-53 (exactly folios 21r-25v)
- Disabled unnecessary UI elements: sidebars, thumbnails, search, layers
- Single-page view mode
- Result: Clean, focused manuscript viewer

**Configuration:**
```javascript
requestedCanvasIndices: {
  'https://iiif.bodleian.ox.ac.uk/iiif/manifest/...': [44, 45, 46, 47, 48, 49, 50, 51, 52, 53]
}
```

### 1.7 Homepage Enhancement
**index.html** now includes:
- Author biography (Mary Shelley, Percy Shelley)
- Navigation links to all 10 pages via `viewer.html?folio=XXr`
- External links:
  - Bodleian Library digital collection
  - Shelley-Godwin Archive (SGA)
  - BDMP Manual (TEI encoding reference)
  - Creative Commons CC-BY-NC license
- Metadata display directly on homepage
- Professional styling consistent with viewer pages

---

## 2. Functionalities & Design Choices

### 2.1 Separated Statistics Display
**Decision:** Place metadata at page **bottom** instead of top
- **Rationale:** Allows users to focus on manuscript image + transcription first, then explore statistics
- **Visual Separation:** 3rem top margin creates clear boundary
- **Accessibility:** Users on mobile see content before scrolling to metadata

### 2.2 Hand Attribution System
**Design Choice:** Color coding + class-based filtering
- **Why Color?** Humans process color faster than text labels
- **Why Classes?** Allows jQuery/JavaScript to easily toggle visibility
- **Why Two Authors?** Scholarly significance—Mary/Percy edits reveal collaborative process

### 2.3 Mirador Restrictions
**Decision:** Limit to pages 44-53 only
- **Rationale:** Project scope is 21r-25v, showing other manuscripts distracts from scholarly work
- **Implementation:** `requestedCanvasIndices` limits canvas availability without breaking manifest integrity
- **Benefit:** Cleaner UX, faster loading, only 10 pages instead of 300+

### 2.4 Single-File Architecture
**Decision:** Consolidate 10 HTML files → 1 dynamic viewer
- **Trade-off:** Slightly more complex JavaScript vs. massive code duplication reduction
- **Winner:** Maintainability wins. One change updates all pages instantly.
- **URL State Preservation:** Folio parameter survives page refreshes and bookmarks
---

## 3. Difficulties Encountered & Solutions

### 3.1 TEI XML Inconsistency (DIFFICULT)
**Problem:** 22v-25v files had 15+ variations in encoding patterns
- Different deletion markers: `rend="crossedOut"` vs `type="crossedOut"`
- Inconsistent hand attributes (missing or malformed)
- Irregular element nesting

**Why Difficult:** Required archaeological analysis of original BDMP manual + close reading of 21r.xml as reference standard

**Solution Approach:**
1. Established 21r.xml as gold standard
2. Created pattern map for each variation
3. Applied systematic replacements with contextual precision
4. Verified each change didn't introduce new errors

**Learning:** Consistency in structured data requires automated tooling; manual review is error-prone at scale.

### 3.2 Mirador Configuration (MODERATE)
**Problem:** Default Mirador displayed entire collection; took trial-error to find correct API parameter

**Why Difficult:** Mirador documentation sparse; `requestedCanvasIndices` not immediately obvious

**Solution:** Researched Mirador GitHub issues, tested incrementally with different panel toggles

**Learning:** IIIF is powerful but requires patience with API documentation.

### 3.3 CSS Spacing Issues (MODERATE)
**Problem:** Large white gap between Mirador (col-5) and transcription (col-7)
- Initial attempts: percentage tweaking (40/60 → 35/65 → 30/70)
- Root cause: Bootstrap gutter-x applied 15px padding both sides

**Why Difficult:** CSS inheritance + Bootstrap grid system interactions not immediately transparent

**Solution:** 
- Discovered `--bs-gutter-x: 0` override
- Applied inline `padding: 0` to col divs
- Accepted remaining small gap as design feature (breathing room)

**Learning:** CSS grid systems require understanding of their internal variable system, not just class names.

### 3.4 File Consolidation (EASY-MODERATE)
**Problem:** How to migrate 10 HTML files + script.js → 1 dynamic viewer without breaking functionality?

**Why Potentially Difficult:** Risk of losing folio-specific logic

**Solution:** 
- Identified common structure in all 10 files
- Created generic `viewer.html` template
- Moved folio-specific logic to URL parameters + JavaScript map
- Tested circular navigation

**Outcome:** Went smoothly; reduced code by ~1500 lines

---

## 4. What Was Easy

**XSLT Learning:** TEI → HTML transformation is elegant once you understand the pattern

**JavaScript Functions:** Once architecture was clear (URL params → folio → XML load), adding selectHand/toggleDeletions/readingView was straightforward

**CSS Styling:** Bootstrap grid + custom classes made visual design quick; color choices intuitive

**Mirador Setup:** Once initial manifest loaded, customization was configuration-based, not code-based

**Metadata Extraction:** XPath queries (`count()`, `@hand` filtering) are powerful for extracting statistics

---

## 5. What Was Difficult

**TEI XML Standardization:** Manual pattern matching across 10 files required surgical precision; one typo breaks validation

**Bootstrap/CSS Interactions:** Grid gutter behavior non-obvious; required consulting Bootstrap documentation

**Mirador Panel Configuration:** API parameter names unintuitive; required iterative testing

**Testing:** Ensuring all 10 pages load correctly with proper Mirador canvas indices required systematic verification

---

## 6. Project Outcomes & Impact

### 6.1 Deliverables
- **10 TEI XML files** (21r-25v): BDMP manual-compliant, editorial annotations
- **2 XSLT stylesheets**: Text rendering + statistical extraction
- **1 dynamic viewer** (viewer.html): Single source of truth for all pages
- **Interactive features**: Hand filtering, deletion toggle, reading view
- **Professional styling**: Manuscript aesthetic, color-coded apparatus
- **Mirador integration**: IIIF-compliant image viewer (Bodleian Library)
- **Homepage**: Author info, navigation, external resources
- **Metadata dashboard**: Comprehensive statistics per page

### 6.2 Technical Skills Demonstrated
- TEI XML encoding & validation
- XSLT 1.0 transformations & XPath queries
- JavaScript ES6 (fetch API, Promise, DOMParser, XSLTProcessor)
- CSS Grid & Bootstrap 4 customization
- IIIF manifest configuration
- Web architecture (URL parameters, state preservation)
- Iterative problem-solving & debugging

### 6.3 Scholarly Value
This edition demonstrates:
- **Collaborative authorship analysis**: Visual distinction between Mary and Percy's revisions
- **Manuscript materiality**: IIIF image access + diplomatic transcription
- **Digital humanities best practices**: TEI standardization, IIIF compliance, open web standards
- **Accessibility**: Multiple reading modes (with/without apparatus, hand-filtered)

---

## 7. Reflection & Future Work

### What Went Well
The project successfully bridged **scholarly rigor** (TEI encoding, BDMP compliance) with **modern web UX** (dynamic loading, filtering, interactive visualization). The architecture is scalable—adding more manuscript pages would only require new XML files; the viewer remains unchanged.

### Challenges Overcome
Systematic approach to data standardization (21r → template) and iterative refinement (initial spacing issues → final solution) demonstrate realistic software development workflow: specifications change, requirements evolve, solutions require adaptation.

### Future Enhancements
1. **XSLT Expansion:** Add templates for `<lb/>` line breaks, `<metamark>` page numbers, overwritten text rendering
2. **Full-Text Search:** Index XML content for keyword search across all pages
3. **Annotation Layer:** Allow user comments on specific passages
4. **Comparative View:** Side-by-side Mary/Percy edits visualization
5. **Export Options:** Generate clean reading text, TEI XML download, PDF export
6. **Responsive Mobile:** Optimize for tablet/phone viewing
7. **Authentication:** If hosting publicly, add academic institutional login

### Conclusion
This project reinforced that digital humanities work requires balancing **technical precision** (XML validation, XSLT correctness) with **user experience** (intuitive UI, accessible design). The iteration between these concerns—fixing XML errors while also improving CSS styling—mirrors real-world software development. The final product is both a scholarly resource and a functional web application.

---

**Project Completed:** October 19, 2025  
**Files Modified:** 10 XML files, 2 XSLT stylesheets, 3 core application files (HTML, CSS, JS)  
**Total Code Reductions:** ~1500 lines (via file consolidation)  
**Deployment Ready:** Yes (requires web server for XSLT processing)
