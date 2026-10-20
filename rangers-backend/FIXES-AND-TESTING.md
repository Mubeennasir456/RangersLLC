# Rangers CMS — repair build

This update improves the admin styling, upload folder diagnostics, CMS migration repeatability, and admin exhibition editing. It does NOT constitute a full live-tested CMS.

## Install
1. Back up the old project folder and MySQL database.
2. Extract `rangers-backend` into `C:\xampp\htdocs\rangers-backend`.
3. Start Apache and MySQL; import `database/schema.sql` only on a NEW database, OR import `database/cms_migration.sql` on an EXISTING installation. Never import schema.sql over an existing populated database.
4. Verify `config/database.php` credentials.
5. Open `http://localhost/rangers-backend/admin/` and log in. Use `admin/setup.php` only if no admin account exists.
6. Open browser DevTools > Network to see failed API requests. For 404 errors enable Apache mod_rewrite and AllowOverride All. For 500 errors inspect PHP and Apache logs.

## Test in order
1. Add category, refresh and confirm it persists.
2. Add product assigned to category, refresh and confirm.
3. Edit product, refresh and confirm.
4. Upload a JPEG/PNG/WebP smaller than 5 MB and set as main. Confirm the file exists in storage/uploads and appears in the product editor.
5. Add product to Digital Booklet and confirm the booklet saves.
6. Delete test product; delete empty test category.
7. Test Page CMS image override and page refresh.

## Known limits
- Image upload endpoint accepts only JPG, PNG, WebP up to 5 MB. Video/PDF upload is NOT implemented.
- The public frontend uses static content in places; not every CMS record is dynamically bound to the site.
- Full CRUD for all page sections, drag/drop animations and catalog PDF editing are NOT implemented.
- No live MySQL/XAMPP integration test was possible in this environment.
