From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 04/12] change conf->dry_run to conf->cmd
Date: Tue, 1 Jul 2014 20:56:36 +0200
Message-ID: <CABr-Gndpa5D3Z=S9erF3qP-U=09hgwfxzZqB+r668y3hj9S7yA@mail.gmail.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-5-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0080497911299265548=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-5-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0080497911299265548==
Content-Type: multipart/alternative; boundary=089e0153821cc0bb1a04fd26550e

--089e0153821cc0bb1a04fd26550e
Content-Type: text/plain; charset=UTF-8

Applied.
Nice readability improvement indeed.
Thanks.


On Mon, Jun 30, 2014 at 7:13 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> conf->dry_run is getting used for many different things besides running
> multipath in dry_run mode, and the name and values were getting
> increasingly confusing.  This patch switches the variable from
> conf->dry_run to conf->cmd, and folds in conf->list.  It also changes
> the value to a enum.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.h    | 13 +++++++++++--
>  libmultipath/configure.c |  2 +-
>  libmultipath/discovery.c |  6 ++++--
>  multipath/main.c         | 49
> ++++++++++++++++++++++++------------------------
>  4 files changed, 41 insertions(+), 29 deletions(-)
>
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 445525b..eb23820 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -22,6 +22,16 @@ enum devtypes {
>         DEV_DEVMAP
>  };
>
> +enum mpath_cmds {
> +       CMD_CREATE,
> +       CMD_DRY_RUN,
> +       CMD_LIST_SHORT,
> +       CMD_LIST_LONG,
> +       CMD_VALID_PATH,
> +       CMD_REMOVE_WWID,
> +       CMD_RESET_WWIDS,
> +};
> +
>  struct hwentry {
>         char * vendor;
>         char * product;
> @@ -78,8 +88,7 @@ struct mpentry {
>
>  struct config {
>         int verbosity;
> -       int dry_run;
> -       int list;
> +       enum mpath_cmds cmd;
>         int pgpolicy_flag;
>         int pgpolicy;
>         enum devtypes dev_type;
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 6ad7a80..107517b 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -577,7 +577,7 @@ domap (struct multipath * mpp, char * params)
>         /*
>          * last chance to quit before touching the devmaps
>          */
> -       if (conf->dry_run && mpp->action != ACT_NOTHING) {
> +       if (conf->cmd == CMD_DRY_RUN && mpp->action != ACT_NOTHING) {
>                 print_multipath_topology(mpp, conf->verbosity);
>                 return DOMAP_DRY;
>         }
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 786e1de..b62a59c 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -56,7 +56,8 @@ store_pathinfo (vector pathvec, vector hwtable, struct
> udev_device *udevice,
>         }
>         pp->udev = udev_device_ref(udevice);
>         err = pathinfo(pp, hwtable,
> -                      (conf->dry_run == 3)? flag : (flag | DI_BLACKLIST));
> +                      (conf->cmd == CMD_REMOVE_WWID)? flag :
> +                                                      (flag |
> DI_BLACKLIST));
>         if (err)
>                 goto out;
>
> @@ -1127,7 +1128,8 @@ get_uid (struct path * pp)
>
>                 value = udev_device_get_property_value(pp->udev,
>                                                        pp->uid_attribute);
> -               if ((!value || strlen(value) == 0) && conf->dry_run == 2)
> +               if ((!value || strlen(value) == 0) &&
> +                   conf->cmd == CMD_VALID_PATH)
>                         value = getenv(pp->uid_attribute);
>                 if (value && strlen(value)) {
>                         size_t len = WWID_SIZE;
> diff --git a/multipath/main.c b/multipath/main.c
> index 64c8fc5..54b2a74 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -207,18 +207,19 @@ get_dm_mpvec (vector curmp, vector pathvec, char *
> refwwid)
>                  * If not in "fast list mode", we need to fetch information
>                  * about them
>                  */
> -               if (conf->list != 1)
> +               if (conf->cmd != CMD_LIST_SHORT)
>                         update_paths(mpp);
>
> -               if (conf->list > 1)
> +               if (conf->cmd == CMD_LIST_LONG)
>                         mpp->bestpg = select_path_group(mpp);
>
>                 disassemble_status(status, mpp);
>
> -               if (conf->list)
> +               if (conf->cmd == CMD_LIST_SHORT ||
> +                   conf->cmd == CMD_LIST_LONG)
>                         print_multipath_topology(mpp, conf->verbosity);
>
> -               if (!conf->dry_run)
> +               if (conf->cmd == CMD_CREATE)
>                         reinstate_paths(mpp);
>         }
>         return 0;
> @@ -260,10 +261,11 @@ configure (void)
>         /*
>          * if we have a blacklisted device parameter, exit early
>          */
> -       if (dev && conf->dev_type == DEV_DEVNODE && conf->dry_run != 3 &&
> +       if (dev && conf->dev_type == DEV_DEVNODE &&
> +           conf->cmd != CMD_REMOVE_WWID &&
>             (filter_devnode(conf->blist_devnode,
>                             conf->elist_devnode, dev) > 0)) {
> -               if (conf->dry_run == 2)
> +               if (conf->cmd == CMD_VALID_PATH)
>                         printf("%s is not a valid multipath device path\n",
>                                conf->dev);
>                 goto out;
> @@ -276,13 +278,13 @@ configure (void)
>                 int failed = get_refwwid(conf->dev, conf->dev_type,
> pathvec,
>                                          &refwwid);
>                 if (!refwwid) {
> -                       if (failed == 2 && conf->dry_run == 2)
> +                       if (failed == 2 && conf->cmd == CMD_VALID_PATH)
>                                 printf("%s is not a valid multipath device
> path\n", conf->dev);
>                         else
>                                 condlog(3, "scope is nul");
>                         goto out;
>                 }
> -               if (conf->dry_run == 3) {
> +               if (conf->cmd == CMD_REMOVE_WWID) {
>                         r = remove_wwid(refwwid);
>                         if (r == 0)
>                                 printf("wwid '%s' removed\n", refwwid);
> @@ -294,7 +296,7 @@ configure (void)
>                         goto out;
>                 }
>                 condlog(3, "scope limited to %s", refwwid);
> -               if (conf->dry_run == 2) {
> +               if (conf->cmd == CMD_VALID_PATH) {
>                         if (check_wwids_file(refwwid, 0) == 0){
>                                 printf("%s is a valid multipath device
> path\n", conf->dev);
>                                 r = 0;
> @@ -311,10 +313,10 @@ configure (void)
>         if (conf->dev)
>                 di_flag = DI_WWID;
>
> -       if (conf->list > 1)
> +       if (conf->cmd == CMD_LIST_LONG)
>                 /* extended path info '-ll' */
>                 di_flag |= DI_SYSFS | DI_CHECKER;
> -       else if (conf->list)
> +       else if (conf->cmd == CMD_LIST_SHORT)
>                 /* minimum path info '-l' */
>                 di_flag |= DI_SYSFS;
>         else
> @@ -334,7 +336,7 @@ configure (void)
>
>         filter_pathvec(pathvec, refwwid);
>
> -       if (conf->list) {
> +       if (conf->cmd != CMD_CREATE && conf->cmd != CMD_DRY_RUN) {
>                 r = 0;
>                 goto out;
>         }
> @@ -456,11 +458,11 @@ main (int argc, char *argv[])
>                         conf->allow_queueing = 1;
>                         break;
>                 case 'c':
> -                       conf->dry_run = 2;
> +                       conf->cmd = CMD_VALID_PATH;
>                         break;
>                 case 'd':
> -                       if (!conf->dry_run)
> -                               conf->dry_run = 1;
> +                       if (conf->cmd == CMD_CREATE)
> +                               conf->cmd = CMD_DRY_RUN;
>                         break;
>                 case 'f':
>                         conf->remove = FLUSH_ONE;
> @@ -469,11 +471,10 @@ main (int argc, char *argv[])
>                         conf->remove = FLUSH_ALL;
>                         break;
>                 case 'l':
> -                       conf->list = 1;
> -                       conf->dry_run = 1;
> -
>                         if (optarg && !strncmp(optarg, "l", 1))
> -                               conf->list++;
> +                               conf->cmd = CMD_LIST_LONG;
> +                       else
> +                               conf->cmd = CMD_LIST_SHORT;
>
>                         break;
>                 case 'M':
> @@ -499,10 +500,10 @@ main (int argc, char *argv[])
>                         usage(argv[0]);
>                         exit(0);
>                 case 'w':
> -                       conf->dry_run = 3;
> +                       conf->cmd = CMD_REMOVE_WWID;
>                         break;
>                 case 'W':
> -                       conf->dry_run = 4;
> +                       conf->cmd = CMD_RESET_WWIDS;
>                         break;
>                 case ':':
>                         fprintf(stderr, "Missing option argument\n");
> @@ -558,16 +559,16 @@ main (int argc, char *argv[])
>         }
>         dm_init();
>
> -       if (conf->dry_run == 2 &&
> +       if (conf->cmd == CMD_VALID_PATH &&
>             (!conf->dev || conf->dev_type == DEV_DEVMAP)) {
>                 condlog(0, "the -c option requires a path to check");
>                 goto out;
>         }
> -       if (conf->dry_run == 3 && !conf->dev) {
> +       if (conf->cmd == CMD_REMOVE_WWID && !conf->dev) {
>                 condlog(0, "the -w option requires a device");
>                 goto out;
>         }
> -       if (conf->dry_run == 4) {
> +       if (conf->cmd == CMD_RESET_WWIDS) {
>                 struct multipath * mpp;
>                 int i;
>                 vector curmp;
> --
> 1.8.3.1
>
>

--089e0153821cc0bb1a04fd26550e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdj48ZGl2PkFwcGxpZWQuPGJyPjwvZGl2Pk5pY2UgcmVhZGFiaWxp
dHkgaW1wcm92ZW1lbnQgaW5kZWVkLjxicj48L2Rpdj5UaGFua3MuPGJyPjwvZGl2PjxkaXYgY2xh
c3M9ImdtYWlsX2V4dHJhIj48YnI+PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj5PbiBNb24s
IEp1biAzMCwgMjAxNCBhdCA3OjEzIEFNLCBCZW5qYW1pbiBNYXJ6aW5za2kgPHNwYW4gZGlyPSJs
dHIiPiZsdDs8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSIgdGFyZ2V0PSJfYmxh
bmsiPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+Jmd0Ozwvc3Bhbj4gd3JvdGU6PGJyPg0KPGJsb2Nr
cXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVy
LWxlZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI+Y29uZi0mZ3Q7ZHJ5X3J1biBp
cyBnZXR0aW5nIHVzZWQgZm9yIG1hbnkgZGlmZmVyZW50IHRoaW5ncyBiZXNpZGVzIHJ1bm5pbmc8
YnI+DQptdWx0aXBhdGggaW4gZHJ5X3J1biBtb2RlLCBhbmQgdGhlIG5hbWUgYW5kIHZhbHVlcyB3
ZXJlIGdldHRpbmc8YnI+DQppbmNyZWFzaW5nbHkgY29uZnVzaW5nLiDCoFRoaXMgcGF0Y2ggc3dp
dGNoZXMgdGhlIHZhcmlhYmxlIGZyb208YnI+DQpjb25mLSZndDtkcnlfcnVuIHRvIGNvbmYtJmd0
O2NtZCwgYW5kIGZvbGRzIGluIGNvbmYtJmd0O2xpc3QuIMKgSXQgYWxzbyBjaGFuZ2VzPGJyPg0K
dGhlIHZhbHVlIHRvIGEgZW51bS48YnI+DQo8YnI+DQpTaWduZWQtb2ZmLWJ5OiBCZW5qYW1pbiBN
YXJ6aW5za2kgJmx0OzxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemlu
c0ByZWRoYXQuY29tPC9hPiZndDs8YnI+DQotLS08YnI+DQrCoGxpYm11bHRpcGF0aC9jb25maWcu
aCDCoCDCoHwgMTMgKysrKysrKysrKystLTxicj4NCsKgbGlibXVsdGlwYXRoL2NvbmZpZ3VyZS5j
IHwgwqAyICstPGJyPg0KwqBsaWJtdWx0aXBhdGgvZGlzY292ZXJ5LmMgfCDCoDYgKysrKy0tPGJy
Pg0KwqBtdWx0aXBhdGgvbWFpbi5jIMKgIMKgIMKgIMKgIHwgNDkgKysrKysrKysrKysrKysrKysr
KysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tPGJyPg0KwqA0IGZpbGVzIGNoYW5nZWQsIDQx
IGluc2VydGlvbnMoKyksIDI5IGRlbGV0aW9ucygtKTxicj4NCjxicj4NCmRpZmYgLS1naXQgYS9s
aWJtdWx0aXBhdGgvY29uZmlnLmggYi9saWJtdWx0aXBhdGgvY29uZmlnLmg8YnI+DQppbmRleCA0
NDU1MjViLi5lYjIzODIwIDEwMDY0NDxicj4NCi0tLSBhL2xpYm11bHRpcGF0aC9jb25maWcuaDxi
cj4NCisrKyBiL2xpYm11bHRpcGF0aC9jb25maWcuaDxicj4NCkBAIC0yMiw2ICsyMiwxNiBAQCBl
bnVtIGRldnR5cGVzIHs8YnI+DQrCoCDCoCDCoCDCoCBERVZfREVWTUFQPGJyPg0KwqB9Ozxicj4N
Cjxicj4NCitlbnVtIG1wYXRoX2NtZHMgezxicj4NCisgwqAgwqAgwqAgQ01EX0NSRUFURSw8YnI+
DQorIMKgIMKgIMKgIENNRF9EUllfUlVOLDxicj4NCisgwqAgwqAgwqAgQ01EX0xJU1RfU0hPUlQs
PGJyPg0KKyDCoCDCoCDCoCBDTURfTElTVF9MT05HLDxicj4NCisgwqAgwqAgwqAgQ01EX1ZBTElE
X1BBVEgsPGJyPg0KKyDCoCDCoCDCoCBDTURfUkVNT1ZFX1dXSUQsPGJyPg0KKyDCoCDCoCDCoCBD
TURfUkVTRVRfV1dJRFMsPGJyPg0KK307PGJyPg0KKzxicj4NCsKgc3RydWN0IGh3ZW50cnkgezxi
cj4NCsKgIMKgIMKgIMKgIGNoYXIgKiB2ZW5kb3I7PGJyPg0KwqAgwqAgwqAgwqAgY2hhciAqIHBy
b2R1Y3Q7PGJyPg0KQEAgLTc4LDggKzg4LDcgQEAgc3RydWN0IG1wZW50cnkgezxicj4NCjxicj4N
CsKgc3RydWN0IGNvbmZpZyB7PGJyPg0KwqAgwqAgwqAgwqAgaW50IHZlcmJvc2l0eTs8YnI+DQot
IMKgIMKgIMKgIGludCBkcnlfcnVuOzxicj4NCi0gwqAgwqAgwqAgaW50IGxpc3Q7PGJyPg0KKyDC
oCDCoCDCoCBlbnVtIG1wYXRoX2NtZHMgY21kOzxicj4NCsKgIMKgIMKgIMKgIGludCBwZ3BvbGlj
eV9mbGFnOzxicj4NCsKgIMKgIMKgIMKgIGludCBwZ3BvbGljeTs8YnI+DQrCoCDCoCDCoCDCoCBl
bnVtIGRldnR5cGVzIGRldl90eXBlOzxicj4NCmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvY29u
ZmlndXJlLmMgYi9saWJtdWx0aXBhdGgvY29uZmlndXJlLmM8YnI+DQppbmRleCA2YWQ3YTgwLi4x
MDc1MTdiIDEwMDY0NDxicj4NCi0tLSBhL2xpYm11bHRpcGF0aC9jb25maWd1cmUuYzxicj4NCisr
KyBiL2xpYm11bHRpcGF0aC9jb25maWd1cmUuYzxicj4NCkBAIC01NzcsNyArNTc3LDcgQEAgZG9t
YXAgKHN0cnVjdCBtdWx0aXBhdGggKiBtcHAsIGNoYXIgKiBwYXJhbXMpPGJyPg0KwqAgwqAgwqAg
wqAgLyo8YnI+DQrCoCDCoCDCoCDCoCDCoCogbGFzdCBjaGFuY2UgdG8gcXVpdCBiZWZvcmUgdG91
Y2hpbmcgdGhlIGRldm1hcHM8YnI+DQrCoCDCoCDCoCDCoCDCoCovPGJyPg0KLSDCoCDCoCDCoCBp
ZiAoY29uZi0mZ3Q7ZHJ5X3J1biAmYW1wOyZhbXA7IG1wcC0mZ3Q7YWN0aW9uICE9IEFDVF9OT1RI
SU5HKSB7PGJyPg0KKyDCoCDCoCDCoCBpZiAoY29uZi0mZ3Q7Y21kID09IENNRF9EUllfUlVOICZh
bXA7JmFtcDsgbXBwLSZndDthY3Rpb24gIT0gQUNUX05PVEhJTkcpIHs8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBwcmludF9tdWx0aXBhdGhfdG9wb2xvZ3kobXBwLCBjb25mLSZndDt2ZXJi
b3NpdHkpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJldHVybiBET01BUF9EUlk7PGJy
Pg0KwqAgwqAgwqAgwqAgfTxicj4NCmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvZGlzY292ZXJ5
LmMgYi9saWJtdWx0aXBhdGgvZGlzY292ZXJ5LmM8YnI+DQppbmRleCA3ODZlMWRlLi5iNjJhNTlj
IDEwMDY0NDxicj4NCi0tLSBhL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYzxicj4NCisrKyBiL2xp
Ym11bHRpcGF0aC9kaXNjb3ZlcnkuYzxicj4NCkBAIC01Niw3ICs1Niw4IEBAIHN0b3JlX3BhdGhp
bmZvICh2ZWN0b3IgcGF0aHZlYywgdmVjdG9yIGh3dGFibGUsIHN0cnVjdCB1ZGV2X2RldmljZSAq
dWRldmljZSw8YnI+DQrCoCDCoCDCoCDCoCB9PGJyPg0KwqAgwqAgwqAgwqAgcHAtJmd0O3VkZXYg
PSB1ZGV2X2RldmljZV9yZWYodWRldmljZSk7PGJyPg0KwqAgwqAgwqAgwqAgZXJyID0gcGF0aGlu
Zm8ocHAsIGh3dGFibGUsPGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoChj
b25mLSZndDtkcnlfcnVuID09IDMpPyBmbGFnIDogKGZsYWcgfCBESV9CTEFDS0xJU1QpKTs8YnI+
DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgKGNvbmYtJmd0O2NtZCA9PSBDTURf
UkVNT1ZFX1dXSUQpPyBmbGFnIDo8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgKGZsYWcg
fCBESV9CTEFDS0xJU1QpKTs8YnI+DQrCoCDCoCDCoCDCoCBpZiAoZXJyKTxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIGdvdG8gb3V0Ozxicj4NCjxicj4NCkBAIC0xMTI3LDcgKzExMjgsOCBA
QCBnZXRfdWlkIChzdHJ1Y3QgcGF0aCAqIHBwKTxicj4NCjxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIHZhbHVlID0gdWRldl9kZXZpY2VfZ2V0X3Byb3BlcnR5X3ZhbHVlKHBwLSZndDt1ZGV2
LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcHAtJmd0O3VpZF9hdHRyaWJ1dGUpOzxi
cj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKCghdmFsdWUgfHwgc3RybGVuKHZhbHVlKSA9
PSAwKSAmYW1wOyZhbXA7IGNvbmYtJmd0O2RyeV9ydW4gPT0gMik8YnI+DQorIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIGlmICgoIXZhbHVlIHx8IHN0cmxlbih2YWx1ZSkgPT0gMCkgJmFtcDsmYW1wOzxi
cj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY29uZi0mZ3Q7Y21kID09IENNRF9WQUxJ
RF9QQVRIKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHZhbHVlID0g
Z2V0ZW52KHBwLSZndDt1aWRfYXR0cmlidXRlKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBpZiAodmFsdWUgJmFtcDsmYW1wOyBzdHJsZW4odmFsdWUpKSB7PGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgc2l6ZV90IGxlbiA9IFdXSURfU0laRTs8YnI+DQpkaWZm
IC0tZ2l0IGEvbXVsdGlwYXRoL21haW4uYyBiL211bHRpcGF0aC9tYWluLmM8YnI+DQppbmRleCA2
NGM4ZmM1Li41NGIyYTc0IDEwMDY0NDxicj4NCi0tLSBhL211bHRpcGF0aC9tYWluLmM8YnI+DQor
KysgYi9tdWx0aXBhdGgvbWFpbi5jPGJyPg0KQEAgLTIwNywxOCArMjA3LDE5IEBAIGdldF9kbV9t
cHZlYyAodmVjdG9yIGN1cm1wLCB2ZWN0b3IgcGF0aHZlYywgY2hhciAqIHJlZnd3aWQpPGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAqIElmIG5vdCBpbiAmcXVvdDtmYXN0IGxpc3QgbW9k
ZSZxdW90Oywgd2UgbmVlZCB0byBmZXRjaCBpbmZvcm1hdGlvbjxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgKiBhYm91dCB0aGVtPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAq
Lzxicj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKGNvbmYtJmd0O2xpc3QgIT0gMSk8YnI+
DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmIChjb25mLSZndDtjbWQgIT0gQ01EX0xJU1RfU0hP
UlQpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgdXBkYXRlX3BhdGhz
KG1wcCk7PGJyPg0KPGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoY29uZi0mZ3Q7bGlz
dCAmZ3Q7IDEpPGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoY29uZi0mZ3Q7Y21kID09
IENNRF9MSVNUX0xPTkcpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
bXBwLSZndDtiZXN0cGcgPSBzZWxlY3RfcGF0aF9ncm91cChtcHApOzxicj4NCjxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIGRpc2Fzc2VtYmxlX3N0YXR1cyhzdGF0dXMsIG1wcCk7PGJyPg0K
PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoY29uZi0mZ3Q7bGlzdCk8YnI+DQorIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIGlmIChjb25mLSZndDtjbWQgPT0gQ01EX0xJU1RfU0hPUlQgfHw8
YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmYtJmd0O2NtZCA9PSBDTURfTElT
VF9MT05HKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHByaW50X211
bHRpcGF0aF90b3BvbG9neShtcHAsIGNvbmYtJmd0O3ZlcmJvc2l0eSk7PGJyPg0KPGJyPg0KLSDC
oCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoIWNvbmYtJmd0O2RyeV9ydW4pPGJyPg0KKyDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBpZiAoY29uZi0mZ3Q7Y21kID09IENNRF9DUkVBVEUpPGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmVpbnN0YXRlX3BhdGhzKG1wcCk7PGJyPg0K
wqAgwqAgwqAgwqAgfTxicj4NCsKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCkBAIC0yNjAsMTAg
KzI2MSwxMSBAQCBjb25maWd1cmUgKHZvaWQpPGJyPg0KwqAgwqAgwqAgwqAgLyo8YnI+DQrCoCDC
oCDCoCDCoCDCoCogaWYgd2UgaGF2ZSBhIGJsYWNrbGlzdGVkIGRldmljZSBwYXJhbWV0ZXIsIGV4
aXQgZWFybHk8YnI+DQrCoCDCoCDCoCDCoCDCoCovPGJyPg0KLSDCoCDCoCDCoCBpZiAoZGV2ICZh
bXA7JmFtcDsgY29uZi0mZ3Q7ZGV2X3R5cGUgPT0gREVWX0RFVk5PREUgJmFtcDsmYW1wOyBjb25m
LSZndDtkcnlfcnVuICE9IDMgJmFtcDsmYW1wOzxicj4NCisgwqAgwqAgwqAgaWYgKGRldiAmYW1w
OyZhbXA7IGNvbmYtJmd0O2Rldl90eXBlID09IERFVl9ERVZOT0RFICZhbXA7JmFtcDs8YnI+DQor
IMKgIMKgIMKgIMKgIMKgIGNvbmYtJmd0O2NtZCAhPSBDTURfUkVNT1ZFX1dXSUQgJmFtcDsmYW1w
Ozxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIChmaWx0ZXJfZGV2bm9kZShjb25mLSZndDtibGlzdF9k
ZXZub2RlLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNv
bmYtJmd0O2VsaXN0X2Rldm5vZGUsIGRldikgJmd0OyAwKSkgezxicj4NCi0gwqAgwqAgwqAgwqAg
wqAgwqAgwqAgaWYgKGNvbmYtJmd0O2RyeV9ydW4gPT0gMik8YnI+DQorIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIGlmIChjb25mLSZndDtjbWQgPT0gQ01EX1ZBTElEX1BBVEgpPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcHJpbnRmKCZxdW90OyVzIGlzIG5vdCBhIHZhbGlk
IG11bHRpcGF0aCBkZXZpY2UgcGF0aFxuJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZi0mZ3Q7ZGV2KTs8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBnb3RvIG91dDs8YnI+DQpAQCAtMjc2LDEzICsyNzgsMTMgQEAgY29uZmln
dXJlICh2b2lkKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGludCBmYWlsZWQgPSBnZXRf
cmVmd3dpZChjb25mLSZndDtkZXYsIGNvbmYtJmd0O2Rldl90eXBlLCBwYXRodmVjLDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgJmFtcDtyZWZ3d2lkKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoIXJlZnd3
aWQpIHs8YnI+DQotIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmIChmYWlsZWQg
PT0gMiAmYW1wOyZhbXA7IGNvbmYtJmd0O2RyeV9ydW4gPT0gMik8YnI+DQorIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmIChmYWlsZWQgPT0gMiAmYW1wOyZhbXA7IGNvbmYtJmd0
O2NtZCA9PSBDTURfVkFMSURfUEFUSCk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCBwcmludGYoJnF1b3Q7JXMgaXMgbm90IGEgdmFsaWQgbXVsdGlw
YXRoIGRldmljZSBwYXRoXG4mcXVvdDssIGNvbmYtJmd0O2Rldik7PGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZWxzZTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmRsb2coMywgJnF1b3Q7c2NvcGUgaXMgbnVsJnF1
b3Q7KTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIG91dDs8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB9PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBpZiAoY29uZi0mZ3Q7ZHJ5X3J1biA9PSAzKSB7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBpZiAoY29uZi0mZ3Q7Y21kID09IENNRF9SRU1PVkVfV1dJRCkgezxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHIgPSByZW1vdmVfd3dpZChyZWZ3d2lkKTs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAociA9PSAwKTxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHByaW50ZigmcXVvdDt3
d2lkICYjMzk7JXMmIzM5OyByZW1vdmVkXG4mcXVvdDssIHJlZnd3aWQpOzxicj4NCkBAIC0yOTQs
NyArMjk2LDcgQEAgY29uZmlndXJlICh2b2lkKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIGdvdG8gb3V0Ozxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIH08YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjb25kbG9nKDMsICZxdW90O3Njb3BlIGxpbWl0ZWQg
dG8gJXMmcXVvdDssIHJlZnd3aWQpOzxicj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKGNv
bmYtJmd0O2RyeV9ydW4gPT0gMikgezxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKGNv
bmYtJmd0O2NtZCA9PSBDTURfVkFMSURfUEFUSCkgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIGlmIChjaGVja193d2lkc19maWxlKHJlZnd3aWQsIDApID09IDApezxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHByaW50
ZigmcXVvdDslcyBpcyBhIHZhbGlkIG11bHRpcGF0aCBkZXZpY2UgcGF0aFxuJnF1b3Q7LCBjb25m
LSZndDtkZXYpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIHIgPSAwOzxicj4NCkBAIC0zMTEsMTAgKzMxMywxMCBAQCBjb25maWd1cmUgKHZvaWQp
PGJyPg0KwqAgwqAgwqAgwqAgaWYgKGNvbmYtJmd0O2Rldik8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBkaV9mbGFnID0gRElfV1dJRDs8YnI+DQo8YnI+DQotIMKgIMKgIMKgIGlmIChjb25m
LSZndDtsaXN0ICZndDsgMSk8YnI+DQorIMKgIMKgIMKgIGlmIChjb25mLSZndDtjbWQgPT0gQ01E
X0xJU1RfTE9ORyk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBleHRlbmRlZCBwYXRo
IGluZm8gJiMzOTstbGwmIzM5OyAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGRpX2Zs
YWcgfD0gRElfU1lTRlMgfCBESV9DSEVDS0VSOzxicj4NCi0gwqAgwqAgwqAgZWxzZSBpZiAoY29u
Zi0mZ3Q7bGlzdCk8YnI+DQorIMKgIMKgIMKgIGVsc2UgaWYgKGNvbmYtJmd0O2NtZCA9PSBDTURf
TElTVF9TSE9SVCk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBtaW5pbXVtIHBhdGgg
aW5mbyAmIzM5Oy1sJiMzOTsgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBkaV9mbGFn
IHw9IERJX1NZU0ZTOzxicj4NCsKgIMKgIMKgIMKgIGVsc2U8YnI+DQpAQCAtMzM0LDcgKzMzNiw3
IEBAIGNvbmZpZ3VyZSAodm9pZCk8YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCBmaWx0ZXJfcGF0aHZl
YyhwYXRodmVjLCByZWZ3d2lkKTs8YnI+DQo8YnI+DQotIMKgIMKgIMKgIGlmIChjb25mLSZndDts
aXN0KSB7PGJyPg0KKyDCoCDCoCDCoCBpZiAoY29uZi0mZ3Q7Y21kICE9IENNRF9DUkVBVEUgJmFt
cDsmYW1wOyBjb25mLSZndDtjbWQgIT0gQ01EX0RSWV9SVU4pIHs8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCByID0gMDs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIG91dDs8
YnI+DQrCoCDCoCDCoCDCoCB9PGJyPg0KQEAgLTQ1NiwxMSArNDU4LDExIEBAIG1haW4gKGludCBh
cmdjLCBjaGFyICphcmd2W10pPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgY29uZi0mZ3Q7YWxsb3dfcXVldWVpbmcgPSAxOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIGJyZWFrOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNhc2Ug
JiMzOTtjJiMzOTs6PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjb25m
LSZndDtkcnlfcnVuID0gMjs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IGNvbmYtJmd0O2NtZCA9IENNRF9WQUxJRF9QQVRIOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIGJyZWFrOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNhc2Ug
JiMzOTtkJiMzOTs6PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAo
IWNvbmYtJmd0O2RyeV9ydW4pPGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBjb25mLSZndDtkcnlfcnVuID0gMTs8YnI+DQorIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIGlmIChjb25mLSZndDtjbWQgPT0gQ01EX0NSRUFURSk8YnI+DQor
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmYtJmd0O2Nt
ZCA9IENNRF9EUllfUlVOOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IGJyZWFrOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNhc2UgJiMzOTtmJiMzOTs6PGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY29uZi0mZ3Q7cmVtb3ZlID0g
RkxVU0hfT05FOzxicj4NCkBAIC00NjksMTEgKzQ3MSwxMCBAQCBtYWluIChpbnQgYXJnYywgY2hh
ciAqYXJndltdKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmYt
Jmd0O3JlbW92ZSA9IEZMVVNIX0FMTDs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBicmVhazs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjYXNlICYjMzk7bCYj
Mzk7Ojxicj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY29uZi0mZ3Q7bGlz
dCA9IDE7PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjb25mLSZndDtk
cnlfcnVuID0gMTs8YnI+DQotPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgaWYgKG9wdGFyZyAmYW1wOyZhbXA7ICFzdHJuY21wKG9wdGFyZywgJnF1b3Q7bCZxdW90Oywg
MSkpPGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBj
b25mLSZndDtsaXN0Kys7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCBjb25mLSZndDtjbWQgPSBDTURfTElTVF9MT05HOzxicj4NCisgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZWxzZTxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY29uZi0mZ3Q7Y21kID0gQ01EX0xJU1RfU0hPUlQ7PGJy
Pg0KPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYnJlYWs7PGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY2FzZSAmIzM5O00mIzM5Ozo8YnI+DQpAQCAtNDk5LDEw
ICs1MDAsMTAgQEAgbWFpbiAoaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSk8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB1c2FnZShhcmd2WzBdKTs8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBleGl0KDApOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIGNhc2UgJiMzOTt3JiMzOTs6PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBjb25mLSZndDtkcnlfcnVuID0gMzs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIGNvbmYtJmd0O2NtZCA9IENNRF9SRU1PVkVfV1dJRDs8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBicmVhazs8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBjYXNlICYjMzk7VyYjMzk7Ojxicj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgY29uZi0mZ3Q7ZHJ5X3J1biA9IDQ7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBjb25mLSZndDtjbWQgPSBDTURfUkVTRVRfV1dJRFM7PGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYnJlYWs7PGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgY2FzZSAmIzM5OzomIzM5Ozo8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCBmcHJpbnRmKHN0ZGVyciwgJnF1b3Q7TWlzc2luZyBvcHRpb24gYXJndW1lbnRc
biZxdW90Oyk7PGJyPg0KQEAgLTU1OCwxNiArNTU5LDE2IEBAIG1haW4gKGludCBhcmdjLCBjaGFy
ICphcmd2W10pPGJyPg0KwqAgwqAgwqAgwqAgfTxicj4NCsKgIMKgIMKgIMKgIGRtX2luaXQoKTs8
YnI+DQo8YnI+DQotIMKgIMKgIMKgIGlmIChjb25mLSZndDtkcnlfcnVuID09IDIgJmFtcDsmYW1w
Ozxicj4NCisgwqAgwqAgwqAgaWYgKGNvbmYtJmd0O2NtZCA9PSBDTURfVkFMSURfUEFUSCAmYW1w
OyZhbXA7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgKCFjb25mLSZndDtkZXYgfHwgY29uZi0mZ3Q7
ZGV2X3R5cGUgPT0gREVWX0RFVk1BUCkpIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBj
b25kbG9nKDAsICZxdW90O3RoZSAtYyBvcHRpb24gcmVxdWlyZXMgYSBwYXRoIHRvIGNoZWNrJnF1
b3Q7KTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIG91dDs8YnI+DQrCoCDCoCDC
oCDCoCB9PGJyPg0KLSDCoCDCoCDCoCBpZiAoY29uZi0mZ3Q7ZHJ5X3J1biA9PSAzICZhbXA7JmFt
cDsgIWNvbmYtJmd0O2Rldikgezxicj4NCisgwqAgwqAgwqAgaWYgKGNvbmYtJmd0O2NtZCA9PSBD
TURfUkVNT1ZFX1dXSUQgJmFtcDsmYW1wOyAhY29uZi0mZ3Q7ZGV2KSB7PGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgY29uZGxvZygwLCAmcXVvdDt0aGUgLXcgb3B0aW9uIHJlcXVpcmVzIGEg
ZGV2aWNlJnF1b3Q7KTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIG91dDs8YnI+
DQrCoCDCoCDCoCDCoCB9PGJyPg0KLSDCoCDCoCDCoCBpZiAoY29uZi0mZ3Q7ZHJ5X3J1biA9PSA0
KSB7PGJyPg0KKyDCoCDCoCDCoCBpZiAoY29uZi0mZ3Q7Y21kID09IENNRF9SRVNFVF9XV0lEUykg
ezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN0cnVjdCBtdWx0aXBhdGggKiBtcHA7PGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaW50IGk7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgdmVjdG9yIGN1cm1wOzxicj4NCjxzcGFuIGNsYXNzPSJIT0VuWmIiPjxmb250IGNvbG9y
PSIjODg4ODg4Ij4tLTxicj4NCjEuOC4zLjE8YnI+DQo8YnI+DQo8L2ZvbnQ+PC9zcGFuPjwvYmxv
Y2txdW90ZT48L2Rpdj48YnI+PC9kaXY+DQo=
--089e0153821cc0bb1a04fd26550e--


--===============0080497911299265548==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0080497911299265548==--
