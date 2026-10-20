<?php require dirname(__DIR__).'/config/bootstrap.php'; ?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Rangers Safety Systems — Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="../assets/css/admin.css?v=202610201411" rel="stylesheet">
  <style>
    html,body{min-height:100%;margin:0}
    body{font-family:"DM Sans",Arial,sans-serif;background:#f3f6fa;color:#142335}
    .admin-header{box-sizing:border-box;width:100%;height:78px;padding:0 32px;background:linear-gradient(105deg,#091e30,#17475a);display:flex;align-items:center;justify-content:space-between;box-shadow:0 8px 24px #0d253019}
    .admin-brand{display:flex;min-width:0;align-items:center;gap:16px;color:#fff;text-decoration:none}
    .admin-brand img{display:block;width:154px;height:auto;max-height:48px;object-fit:contain;padding:4px;border-radius:6px;background:#fff}
    .admin-brand span{display:flex;flex-direction:column;line-height:1.35}
    .admin-brand strong{font-size:1rem;letter-spacing:.01em}
    .admin-brand small{color:#b8cad4;font-size:.78rem}
    .admin-main{box-sizing:border-box;width:100%;max-width:1800px;margin:0 auto;padding:30px}
    .admin-layout{--bs-gutter-x:24px;align-items:stretch}
    .admin-sidebar{align-self:flex-start;position:sticky;top:24px;min-height:calc(100vh - 140px);padding:22px 16px!important;border-radius:18px;background:linear-gradient(160deg,#0e283a,#12374a);box-shadow:0 16px 35px #0b253019}
    .sidebar-label{padding:0 12px 14px;color:#8ea8b7;font-size:.68rem;font-weight:800;letter-spacing:.15em}
    .admin-sidebar .nav-link{display:block;color:#c3d6e1;padding:12px 14px;border-radius:10px;margin-bottom:4px;font-weight:600;text-decoration:none;cursor:pointer}
    .admin-sidebar .nav-link:hover{color:#fff;background:#21475b}
    .admin-sidebar .nav-link.active{color:#102334;background:#e6b85c;font-weight:800}
    .admin-workspace{min-width:0}
    #heading{margin:6px 0 24px;font-size:1.9rem;font-weight:800;letter-spacing:-.035em}
    .card{border:1px solid #dce5ec;border-radius:16px;background:#fff;box-shadow:0 7px 24px #0d25300b}
    .card h5{color:#637487;font-size:.95rem;font-weight:700}
    .btn{border-radius:9px;font-weight:700}
    .btn-primary{border-color:#12647e;background:#12647e}
    .btn-primary:hover{border-color:#0b465b;background:#0b465b}
    .form-control,.form-select{border:1px solid #cfdce6;border-radius:9px;padding:10px 12px}
    .form-control:focus,.form-select:focus{border-color:#247b96;box-shadow:0 0 0 3px #247b9626}
    .table-responsive{overflow-x:auto;padding:15px;border:1px solid #dce5ec;border-radius:16px;background:#fff}
    .table{vertical-align:middle}
    .table thead th{border:0;background:#f0f5f8;color:#53687b}
    .login-card{width:min(100%,460px);margin:7vh auto 0;padding:34px;border-top:5px solid #e6b85c}
    .login-mark{padding:16px;border:1px solid #dce5ec;border-radius:12px;background:#f4f7f8;text-align:center}
    .login-mark img{display:block;width:min(100%,340px);height:auto;margin:0 auto}
    .login-card h1{margin:20px 0 6px;font-size:1.65rem;font-weight:800}
    .login-intro{margin-bottom:20px;color:#637487}
    .login-card a{color:#12647e;font-weight:600;text-decoration:none}
    .login-card a:hover{text-decoration:underline}
    #alert{position:sticky;top:10px;z-index:999}
    @media(max-width:991px){.admin-sidebar{position:static;min-height:0}.admin-workspace{width:100%}}
    @media(max-width:767px){.admin-header{height:auto;min-height:68px;padding:10px 16px;gap:10px}.admin-brand{gap:10px}.admin-brand img{width:110px;max-height:42px}.admin-brand strong{font-size:.82rem}.admin-brand small{font-size:.68rem}.admin-header #logout{flex-shrink:0}.admin-main{padding:16px}.admin-sidebar{margin-bottom:20px;padding:14px!important}.admin-sidebar .nav{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:4px}.admin-sidebar .nav-link{padding:10px 8px;text-align:center;font-size:.84rem}#heading{margin:4px 0 18px;font-size:1.5rem}.login-card{margin-top:24px;padding:22px}.table-responsive{padding:8px}.table{font-size:.86rem}.table th,.table td{padding:9px!important}}
    @media(max-width:420px){.admin-brand img{width:84px}.admin-brand strong{font-size:.74rem}.admin-brand small{font-size:.62rem}.admin-main{padding:12px}.login-card{padding:18px}.login-card h1{font-size:1.4rem}}
  </style>
</head>
<body>
  <header class="admin-header">
    <a class="admin-brand" href="#">
      <img src="../site/assets/rangers-logo.png" alt="Rangers Safety Systems">
      <span><strong>Rangers Safety Systems</strong><small>Website administration</small></span>
    </a>
    <button id="logout" class="btn btn-outline-light btn-sm" hidden>Log out</button>
  </header>
  <main class="container-fluid admin-main">
    <div id="alert" role="alert"></div>
    <section id="login" class="card login-card">
      <div class="login-mark"><img src="../site/assets/rangers-logo.png" alt="Rangers Safety Systems"></div>
      <h1>Admin login</h1>
      <p class="login-intro">Sign in to manage your website content and images.</p>
      <form id="loginForm">
        <label>Email<input class="form-control mb-3" name="email" type="email" autocomplete="username" required></label>
        <label>Password<input class="form-control mb-3" name="password" type="password" autocomplete="current-password" required></label>
        <button class="btn btn-primary w-100">Sign in</button>
      </form>
      <p class="mt-3 mb-0"><a href="setup.php">First time? Create an admin account</a></p>
      <p class="mt-2"><a href="../site/index.html">← Back to website</a></p>
    </section>
    <section id="app" hidden>
      <div class="row admin-layout">
        <aside class="col-md-3 col-lg-2 admin-sidebar">
          <div class="sidebar-label">WORKSPACE</div>
          <nav class="nav flex-column" id="nav"></nav>
        </aside>
        <div class="col-md-9 col-lg-10 admin-workspace">
          <h1 id="heading"></h1>
          <div id="content"></div>
        </div>
      </div>
    </section>
  </main>
  <div class="welcome-overlay" id="adminWelcomePopup" role="dialog" aria-modal="true" aria-labelledby="adminWelcomeTitle" hidden>
    <section class="welcome-card">
      <button class="welcome-close" type="button" aria-label="Close welcome message">&times;</button>
      <img src="../site/assets/rangers-logo.png" alt="" class="welcome-logo">
      <p class="portal-eyebrow">RANGERS SAFETY SYSTEMS LLC</p>
      <h2 id="adminWelcomeTitle">Welcome to the admin panel</h2>
      <p class="welcome-message">Your website management workspace is ready.</p>
      <button class="btn btn-primary welcome-continue" type="button">Continue</button>
    </section>
  </div>
  <script src="../assets/js/admin.js?v=202610201431"></script>
</body>
</html>
