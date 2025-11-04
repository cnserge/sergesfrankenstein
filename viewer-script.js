(function () {
  if (window.__fr_init__) return;
  window.__fr_init__ = true;

  // Get folio from URL parameter
  const urlParams = new URLSearchParams(window.location.search);
  const folio = urlParams.get('folio') || '21r';
  
  // Folio mapping to Mirador page index
  const folioMap = {
    '21r': 44, '21v': 45,
    '22r': 46, '22v': 47,
    '23r': 48, '23v': 49,
    '24r': 50, '24v': 51,
    '25r': 52, '25v': 53
  };
  
  // Page number mapping
  const pageMap = {
    '21r': 75, '21v': 76,
    '22r': 77, '22v': 78,
    '23r': 79, '23v': 80,
    '24r': 81, '24v': 82,
    '25r': 83, '25v': 84
  };

  document.addEventListener('DOMContentLoaded', () => {
    const pageIdx = folioMap[folio];
    const pageNum = pageMap[folio];
    
    // Update UI
    document.getElementById('folio').textContent = folio;
    document.getElementById('page').textContent = pageNum;
    
    // Update navigation buttons
    const folios = ['21r', '21v', '22r', '22v', '23r', '23v', '24r', '24v', '25r', '25v'];
    const idx = folios.indexOf(folio);
    
    const prevBtn = document.getElementById('prev-btn');
    const nextBtn = document.getElementById('next-btn');
    
    if (idx > 0) {
      prevBtn.href = `viewer.html?folio=${folios[idx - 1]}`;
      prevBtn.style.pointerEvents = 'auto';
      prevBtn.style.opacity = '1';
    } else {
      // Loop to last page
      prevBtn.href = `viewer.html?folio=${folios[folios.length - 1]}`;
    }
    
    if (idx < folios.length - 1) {
      nextBtn.href = `viewer.html?folio=${folios[idx + 1]}`;
      nextBtn.style.pointerEvents = 'auto';
      nextBtn.style.opacity = '1';
    } else {
      // Loop to first page
      nextBtn.href = `viewer.html?folio=${folios[0]}`;
    }

    // ---- Mirador IIIF ----
    Mirador.viewer({
      id: 'my-mirador',
      manifests: {
        'https://iiif.bodleian.ox.ac.uk/iiif/manifest/53fd0f29-d482-46e1-aa9d-37829b49987d.json': {
          provider: 'Bodleian Library, University of Oxford'
        }
      },
      window: {
        allowClose: false,
        allowWindowSideBar: false,
        allowTopMenuButton: false,
        allowMaximize: false,
        hideWindowTitle: true,
        defaultSideBarPanel: 'info',
        panels: { 
          info: false, 
          attribution: false, 
          canvas: false,
          annotations: false, 
          search: false, 
          layers: false,
          navigation: false
        }
      },
      workspaceControlPanel: { enabled: false },
      windows: [{
        loadedManifest: 'https://iiif.bodleian.ox.ac.uk/iiif/manifest/53fd0f29-d482-46e1-aa9d-37829b49987d.json',
        canvasIndex: pageIdx,
        thumbnailNavigationPosition: 'off',
        view: 'single'
      }],
      // Only show pages 44-53 (21r-25v)
      requestedCanvasIndices: {
        'https://iiif.bodleian.ox.ac.uk/iiif/manifest/53fd0f29-d482-46e1-aa9d-37829b49987d.json': [44, 45, 46, 47, 48, 49, 50, 51, 52, 53]
      }
    });

    // ---- helpers ----
    function loadText() {
      return Promise.all([
        fetch(`${folio}.xml`).then(r => r.text()),
        fetch('Frankenstein_text.xsl').then(r => r.text()),
        fetch('Frankenstein_meta.xsl').then(r => r.text())
      ]).then(([xmlStr, xslStr, metaStr]) => {
        const parser = new DOMParser();
        const xmlDoc = parser.parseFromString(xmlStr, 'text/xml');
        const xslDoc = parser.parseFromString(xslStr, 'text/xml');
        const metaDoc = parser.parseFromString(metaStr, 'text/xml');
        
        // Process metadata
        const metaProc = new XSLTProcessor();
        metaProc.importStylesheet(metaDoc);
        const metaFrag = metaProc.transformToFragment(xmlDoc, document);
        document.getElementById('stats').innerHTML = '';
        document.getElementById('stats').appendChild(metaFrag);
        
        // Process main text
        const proc = new XSLTProcessor();
        proc.importStylesheet(xslDoc);
        const frag = proc.transformToFragment(xmlDoc, document);
        const target = document.getElementById('text');
        target.innerHTML = '';
        target.appendChild(frag);
      });
    }

    loadText().then(() => {
      // Text and metadata already loaded via XSLT
      console.log(`${folio} loaded successfully`);
    });
  });

  // ---- Hand selection ----
  window.selectHand = function(e) {
    const val = e.target.value;
    const mwsEls = document.querySelectorAll('.MWS');
    const pbsEls = document.querySelectorAll('.PBS');
    
    mwsEls.forEach(el => {
      if (val === 'Mary') {
        el.classList.add('hand-highlight');
        el.classList.remove('hand-dim');
      } else if (val === 'Percy') {
        el.classList.add('hand-dim');
        el.classList.remove('hand-highlight');
      } else {
        el.classList.remove('hand-highlight', 'hand-dim');
      }
    });
    
    pbsEls.forEach(el => {
      if (val === 'Percy') {
        el.classList.add('hand-highlight');
        el.classList.remove('hand-dim');
      } else if (val === 'Mary') {
        el.classList.add('hand-dim');
        el.classList.remove('hand-highlight');
      } else {
        el.classList.remove('hand-highlight', 'hand-dim');
      }
    });
  };

  // ---- Toggle deletions ----
  window.toggleDeletions = function() {
    const dels = document.querySelectorAll('del');
    dels.forEach(del => {
      del.style.display = del.style.display === 'none' ? 'inline' : 'none';
    });
  };

  // ---- Reading view ----
  window.readingView = function() {
    const target = document.getElementById('text');
    const dels = target.querySelectorAll('del');
    const adds = target.querySelectorAll('add');
    
    dels.forEach(del => del.style.display = 'none');
    adds.forEach(add => {
      add.style.textDecoration = 'none';
      add.style.color = 'inherit';
    });
  };
})();
