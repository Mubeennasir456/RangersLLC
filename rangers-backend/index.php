<?php header('Content-Type: text/html; charset=utf-8'); ?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Rangers Safety Systems</title>
  <link href="./assets/css/admin.css?v=20261020" rel="stylesheet">
  <style>
    html{min-height:100%;background:#f3f6fa}
    body.portal-body{min-height:100vh;margin:0;padding:24px;display:grid;place-items:center;background:radial-gradient(ellipse at top,#eaf1f4 0,#f3f6fa 55%,#e8eef2 100%);font:16px "DM Sans",Arial,sans-serif;color:#142335}
    .portal-shell{box-sizing:border-box;width:min(100%,760px);padding:clamp(22px,5vw,48px);border:1px solid #dce5ec;border-top:5px solid #e6b85c;border-radius:22px;background:#fff;box-shadow:0 22px 60px #0d25301a;text-align:center}
    .portal-heading{max-width:520px;margin:0 auto}
    .portal-logo{display:block;width:min(100%,400px);height:auto;max-height:110px;object-fit:contain;margin:0 auto 24px}
    .portal-eyebrow{margin:0 0 8px;color:#136b87;font-size:.72rem;font-weight:800;letter-spacing:.16em}
    .portal-heading h1{margin:0;color:#142335;font-size:clamp(1.55rem,5vw,2rem);font-weight:800;letter-spacing:-.04em}
    .portal-description{margin:10px auto 24px;color:#637487;line-height:1.6}
    .portal-choices{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px;margin-top:30px;text-align:left}
    .portal-choice{display:grid;min-width:0;grid-template-columns:44px minmax(0,1fr) 22px;align-items:center;gap:12px;padding:19px 16px;border:1px solid #dce5ec;border-radius:14px;color:#142335;background:#fff;text-decoration:none;transition:transform .18s ease,border-color .18s ease,box-shadow .18s ease}
    .portal-choice:hover{transform:translateY(-3px);border-color:#8caeba;box-shadow:0 12px 26px #0d253012;color:#142335}
    .portal-choice-admin{background:#f5f9fa}
    .portal-choice-icon{display:grid;width:42px;height:42px;place-items:center;border-radius:12px;color:#fff;background:#12647e;font-size:1.35rem}
    .portal-choice-admin .portal-choice-icon{color:#102334;background:#f1d28d}
    .portal-choice-copy{display:grid;gap:5px}
    .portal-choice-copy strong{font-size:.96rem}
    .portal-choice-copy small{color:#637487;font-size:.8rem;line-height:1.45}
    .portal-choice-arrow{color:#136b87;font-size:1.2rem}
    .portal-setup{display:inline-block;margin-top:22px;color:#136b87;font-size:.9rem;font-weight:700;text-decoration:none}
    .portal-setup:hover{color:#0b465b;text-decoration:underline}
    .welcome-overlay{position:fixed;z-index:3000;inset:0;display:grid;place-items:center;padding:20px;background:rgba(7,24,39,.68);backdrop-filter:blur(5px);opacity:0;transition:opacity .22s ease}
    .welcome-overlay[hidden]{display:none}
    .welcome-overlay.is-visible{opacity:1}
    .welcome-card{position:relative;width:min(100%,430px);padding:34px 28px 28px;border:1px solid #dce5ec;border-top:5px solid #e6b85c;border-radius:20px;background:#fff;text-align:center;box-shadow:0 28px 80px #0004;opacity:0;transform:translateY(20px) scale(.96);transition:opacity .3s ease,transform .3s cubic-bezier(.2,.72,.25,1)}
    .welcome-overlay.is-visible .welcome-card{opacity:1;transform:translateY(0) scale(1)}
    .welcome-logo{display:block;width:min(100%,320px);max-height:80px;object-fit:contain;margin:0 auto 24px}
    .welcome-card h2{margin:0;color:#142335;font-size:1.65rem;font-weight:800}
    .welcome-message{margin:10px 0 22px;color:#637487;line-height:1.6}
    .welcome-close{position:absolute;top:10px;right:12px;width:36px;height:36px;border:0;border-radius:50%;color:#637487;background:#f1f5f7;font-size:1.5rem;line-height:1;cursor:pointer}
    .welcome-continue{min-width:180px;padding:12px 16px;border:1px solid #12647e;border-radius:9px;color:#fff;background:#12647e;font-weight:700;cursor:pointer}
    @media(max-width:600px){body.portal-body{padding:14px}.portal-shell{padding:24px 18px;border-radius:16px}.portal-choices{grid-template-columns:1fr;gap:11px;margin-top:22px}.portal-choice{padding:15px 13px}.portal-setup{font-size:.82rem}}
    @media(max-width:480px){.welcome-card{padding:30px 20px 22px;border-radius:16px}.welcome-logo{max-width:260px}}
    @media(prefers-reduced-motion:reduce){*,*::before,*::after{scroll-behavior:auto!important;animation-duration:.01ms!important;animation-iteration-count:1!important;transition-duration:.01ms!important}}
  </style>
</head>
<body class="portal-body">
  <main class="portal-shell">
    <section class="portal-heading">
      <img class="portal-logo" src="site/assets/rangers-logo.png" alt="Rangers Safety Systems">
      <p class="portal-eyebrow">RANGERS SAFETY SYSTEMS LLC</p>
      <h1>Welcome to Rangers</h1>
      <p class="portal-description">Choose where you would like to go.</p>
    </section>
    <section class="portal-choices" aria-label="Choose a destination">
      <a class="portal-choice portal-choice-website" href="site/index.html">
        <span class="portal-choice-icon" aria-hidden="true">↗</span>
        <span class="portal-choice-copy"><strong>Visit the website</strong><small>Explore our products and safety solutions.</small></span>
        <span class="portal-choice-arrow" aria-hidden="true">→</span>
      </a>
      <a class="portal-choice portal-choice-admin" href="admin/">
        <span class="portal-choice-icon" aria-hidden="true">⚙</span>
        <span class="portal-choice-copy"><strong>Admin panel</strong><small>Manage products, images, and website content.</small></span>
        <span class="portal-choice-arrow" aria-hidden="true">→</span>
      </a>
    </section>
    <a class="portal-setup" href="admin/setup.php">First time here? Create your admin account</a>
  </main>
  <div class="welcome-overlay" id="welcomePopup" role="dialog" aria-modal="true" aria-labelledby="welcomeTitle" hidden>
    <section class="welcome-card">
      <button class="welcome-close" type="button" aria-label="Close welcome message">&times;</button>
      <img src="site/assets/rangers-logo.png" alt="" class="welcome-logo">
      <p class="portal-eyebrow">RANGERS SAFETY SYSTEMS LLC</p>
      <h2 id="welcomeTitle">Welcome</h2>
      <p class="welcome-message">Choose a destination to continue.</p>
      <button class="btn btn-primary welcome-continue" type="button">Continue</button>
    </section>
  </div>
  <script>
    (function () {
      const popup = document.getElementById('welcomePopup');
      const close = popup.querySelector('.welcome-close');
      const dismiss = function () {
        popup.classList.remove('is-visible');
        window.setTimeout(function () { popup.hidden = true; }, 220);
      };
      document.querySelectorAll('.portal-choice').forEach(function (link) {
        link.addEventListener('click', function (event) {
          if (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey || event.button !== 0) return;
          event.preventDefault();
          const isAdmin = link.classList.contains('portal-choice-admin');
          popup.querySelector('#welcomeTitle').textContent = isAdmin ? 'Welcome to the admin panel' : 'Welcome to Rangers';
          popup.querySelector('.welcome-message').textContent = isAdmin
            ? 'Your website management workspace is ready.'
            : 'Discover Rangers safety footwear and workwear.';
          popup.querySelector('.welcome-continue').onclick = function () { window.location.href = link.href; };
          popup.hidden = false;
          requestAnimationFrame(function () { popup.classList.add('is-visible'); close.focus(); });
        });
      });
      close.addEventListener('click', dismiss);
      popup.addEventListener('click', function (event) { if (event.target === popup) dismiss(); });
      document.addEventListener('keydown', function (event) { if (event.key === 'Escape' && !popup.hidden) dismiss(); });
    }());
  </script>
</body>
</html>
