# Rangers Safety Systems — PHP/MySQL Backend

## Status and scope
Working starter implementation with MySQL schema, session login, CRUD products/categories, uploads, public API, booklet, company, exhibition, settings and admin interface. **Not independently tested on a live XAMPP installation or the existing frontend.** Some requirements need further work before production: full media gallery ordering, exhibition product/image editor, category images, admin profile, richer booklet preview, persistent production storage, automated tests, and frontend integration. Do not treat this as production-certified.

## Install (XAMPP)
1. Install XAMPP with PHP 8.2+ and MySQL 8+ (MariaDB compatibility may need verification). Start Apache and MySQL.
2. Copy `rangers-backend` to `C:\xampp\htdocs\rangers-backend`.
3. Open phpMyAdmin and import `database/schema.sql` (creates the database).
4. Configure `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` environment variables if defaults do not work. Never commit real credentials.
5. In a terminal: `cd C:\xampp\htdocs\rangers-backend` and `php tools/create_admin.php admin@example.com "Site Admin"`. Use a long password.
6. Open `http://localhost/rangers-backend/admin/` and sign in.
7. Add categories before products. To remove Safety Gear & PPE from public pages, deactivate that category if it exists.
8. Upload product images in the product editor; check your web server permits 5 MB POST uploads (`upload_max_filesize`, `post_max_size`).

## Endpoints
Public: `GET api/products`, `GET api/products/{id}`, `GET api/categories`, `GET api/booklet`, `GET api/exhibitions`, `GET api/company`, `GET api/settings/public`, `GET api/social-links`.
Protected: `POST api/admin/login`, `POST api/admin/logout`, `GET api/admin/session`, `GET api/admin/dashboard`, `GET/POST/PUT/DELETE api/admin/products[/{id}]`, category equivalents, `GET api/admin/catalogue/report`, `POST api/admin/catalogue/import`, `GET api/admin/media`, `POST api/admin/upload`, `DELETE api/admin/product-images/{id}`, `PUT api/admin/set-main-image`, `PUT api/admin/booklet`, `PUT api/admin/exhibition`, `PUT api/admin/company`, `GET/PUT api/admin/settings`.

## PDF catalogue import
Admin → Products → **Import PDF catalogue** previews the prepared records, then imports them in one transaction. The structured source data, reconciliation report, and original supplied PDF are kept under `storage/catalogues/`; direct HTTP access to that directory is denied. The current attachment named `all 10 page.pdf` is one wide PDF page. Twenty SKUs were identified: 15 footwear entries and 5 protective-clothing entries.

The current products table has no SKU column, so SKUs, subcategories, source filename/page, standards, sizes, and matched image paths are stored in the existing `specifications` JSON/text field. Matching product images are extracted from the PDF's original embedded photographs by SKU (19 unique photo files for 20 SKUs; the FR coverall and uniform entries share the family image shown in the PDF). For web display, the extracted photographs are enlarged using high-quality interpolation to a 2048-pixel (2K) long edge; the importer prefers matching `-2k.png` assets when present. Upscaling cannot add photographic detail absent from the supplied PDF's small embedded photos; genuinely sharper source detail requires original camera/product photographs or a higher-resolution catalogue. Admins can replace a product image in the product editor. Existing products are never overwritten: repeat imports skip matching SKUs. Imported products are always `inactive` and must be reviewed and activated in Products before the public `GET api/products` endpoint will return them. Fifteen footwear entries still need confirmed display titles because the PDF prints only their SKUs; the two FR entries need confirmation of the shared image's coverall/uniform variant.

## Integrating your existing frontend
`site/index.html` loads products and categories from the local API; keep it as HTML because its JavaScript fetches the backend without PHP rendering. Only active products in active categories appear publicly. Product photos remain optional and can be uploaded from Admin → Products → Edit → Product gallery. If frontend is on another origin, deploy behind the same origin/reverse proxy; do not enable wildcard CORS for session-protected admin APIs. Confirm routes and paths after deployment.

## Important assets
The official `Rangers_Full_logo_EN_AR_Horizontal.eps` was not supplied. Convert the authorized EPS to PNG/WebP/SVG offline and upload it through your deployment workflow, then set `logo_path` in admin settings. Official WhatsApp and social URLs were not supplied; configure verified URLs. Do not invent these values.

## Security / deployment
Set HTTPS and secure cookies in production; move sensitive config outside document root or deny direct access; set strict file permissions and deploy uploads to persistent storage. Add a reverse proxy or server-side rate limiting, backup and restore testing, and security review. Ensure Apache mod_rewrite and AllowOverride are enabled. Public read API does not require cookies.


## CMS edition — supplied frontend integrated
The supplied RAR contained one `index.html` and local assets; these are now in `site/`. Run at `http://localhost/rangers-backend/site/` and edit in Admin → **Page CMS**. Click an image (or other element) in the preview to select it, upload a JPG/PNG/WebP image, then save the change. Uploads are stored in `storage/uploads/` and the selected element override is stored in `cms_elements`. Header/footer changes apply globally. Product images are managed in Products; category tile images (used on the landing page) are managed in Categories. Admin → **Admin Profile** changes name/email/password (current password required; no 2FA).

**Existing installation:** import `database/cms_migration.sql` after the original `schema.sql`. Fresh installs import `schema.sql` only. **Limitations:** This is a CMS extension, not a complete Shopify/WordPress-equivalent page builder. It cannot automatically edit arbitrary JavaScript animation logic or restructure templates. Dynamic frontend API mapping to the existing product schema still needs verification. Product/gallery and booklet behavior must be tested against a live MySQL/XAMPP installation. PDFs and videos require a separate hardened uploader; the existing image uploader only accepts JPG/PNG/WebP. Do not deploy to production without security/integration testing.
