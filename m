From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] mpathpersistent: segment faulty occured in
	mpath_persistent_reserve_in()
Date: Sun, 20 Nov 2016 10:13:09 +0100
Message-ID: <CABr-GndKGBHXvOcdy7H7iAHVVhuAokJ==P8te0ZqA=W3pK8Bxg@mail.gmail.com>
References: <1478500516-9792-1-git-send-email-tang.wenji@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5587338032914152683=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1478500516-9792-1-git-send-email-tang.wenji@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.wenji@zte.com.cn
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5587338032914152683==
Content-Type: multipart/alternative; boundary=94eb2c0ec214b026d80541b7f24b

--94eb2c0ec214b026d80541b7f24b
Content-Type: text/plain; charset=UTF-8

Applied,
thanks.

On Mon, Nov 7, 2016 at 7:35 AM, <tang.wenji@zte.com.cn> wrote:

> From: "tang.wenji" <tang.wenji@zte.com.cn>
>
> Segment faulty occured when executing "mpathpersist -i -k
>     /dev/mapper/mpath1" command.The reason is that an uninitialized global
>     variable conf is used in mpath_persistent_reserve_in(). The same
>     problem also exists in mpath_persistent_reserve_out().
>
> Signed-off-by: tang.wenji <tang.wenji@zte.com.cn>
> ---
>  libmpathpersist/mpath_persist.c | 22 +++++++++++++++++++---
>  libmpathpersist/mpathpr.h       |  4 ----
>  2 files changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_
> persist.c
> index faea2b7..982c795 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -35,7 +35,6 @@
>  #define __STDC_FORMAT_MACROS 1
>
>  struct udev *udev;
> -struct config *conf;
>
>  struct config *
>  mpath_lib_init (struct udev *udev)
> @@ -79,6 +78,7 @@ updatepaths (struct multipath * mpp)
>         int i, j;
>         struct pathgroup * pgp;
>         struct path * pp;
> +       struct config *conf;
>
>         if (!mpp->pg)
>                 return 0;
> @@ -98,16 +98,24 @@ updatepaths (struct multipath * mpp)
>                                         continue;
>                                 }
>                                 pp->mpp = mpp;
> +                               conf = get_multipath_config();
>                                 pathinfo(pp, conf, DI_ALL);
> +                               put_multipath_config(conf);
>                                 continue;
>                         }
>                         pp->mpp = mpp;
>                         if (pp->state == PATH_UNCHECKED ||
> -                                       pp->state == PATH_WILD)
> +                                       pp->state == PATH_WILD) {
> +                               conf = get_multipath_config();
>                                 pathinfo(pp, conf, DI_CHECKER);
> +                               put_multipath_config(conf);
> +                       }
>
> -                       if (pp->priority == PRIO_UNDEF)
> +                       if (pp->priority == PRIO_UNDEF) {
> +                               conf = get_multipath_config();
>                                 pathinfo(pp, conf, DI_PRIO);
> +                               put_multipath_config(conf);
> +                       }
>                 }
>         }
>         return 0;
> @@ -160,8 +168,11 @@ int mpath_persistent_reserve_in (int fd, int
> rq_servact,
>         int map_present;
>         int major, minor;
>         int ret;
> +       struct config *conf;
>
> +       conf = get_multipath_config();
>         conf->verbosity = verbose;
> +       put_multipath_config(conf);
>
>         if (fstat( fd, &info) != 0){
>                 condlog(0, "stat error %d", fd);
> @@ -253,8 +264,11 @@ int mpath_persistent_reserve_out ( int fd, int
> rq_servact, int rq_scope,
>         int j;
>         unsigned char *keyp;
>         uint64_t prkey;
> +       struct config *conf;
>
> +       conf = get_multipath_config();
>         conf->verbosity = verbose;
> +       put_multipath_config(conf);
>
>         if (fstat( fd, &info) != 0){
>                 condlog(0, "stat error fd=%d", fd);
> @@ -321,7 +335,9 @@ int mpath_persistent_reserve_out ( int fd, int
> rq_servact, int rq_scope,
>                 goto out1;
>         }
>
> +       conf = get_multipath_config();
>         select_reservation_key(conf, mpp);
> +       put_multipath_config(conf);
>
>         switch(rq_servact)
>         {
> diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
> index 056c547..e6c2ded 100644
> --- a/libmpathpersist/mpathpr.h
> +++ b/libmpathpersist/mpathpr.h
> @@ -25,10 +25,6 @@ struct threadinfo {
>         struct prout_param param;
>  };
>
> -
> -extern struct config *conf;
> -
> -
>  int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp *
> resp, int noisy);
>  int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
>                 unsigned int rq_type, struct prout_param_descriptor
> *paramp, int noisy);
> --
> 2.8.1.windows.1
>
>
>

--94eb2c0ec214b026d80541b7f24b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+QXBwbGllZCw8ZGl2PnRoYW5rcy48L2Rpdj48L2Rpdj48ZGl2IGNsYXNz
PSJnbWFpbF9leHRyYSI+PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj5PbiBNb24sIE5vdiA3
LCAyMDE2IGF0IDc6MzUgQU0sICA8c3BhbiBkaXI9Imx0ciI+Jmx0OzxhIGhyZWY9Im1haWx0bzp0
YW5nLndlbmppQHp0ZS5jb20uY24iIHRhcmdldD0iX2JsYW5rIj50YW5nLndlbmppQHp0ZS5jb20u
Y248L2E+Jmd0Ozwvc3Bhbj4gd3JvdGU6PGJyPjxibG9ja3F1b3RlIGNsYXNzPSJnbWFpbF9xdW90
ZSIgc3R5bGU9Im1hcmdpbjowIDAgMCAuOGV4O2JvcmRlci1sZWZ0OjFweCAjY2NjIHNvbGlkO3Bh
ZGRpbmctbGVmdDoxZXgiPkZyb206ICZxdW90O3Rhbmcud2VuamkmcXVvdDsgJmx0OzxhIGhyZWY9
Im1haWx0bzp0YW5nLndlbmppQHp0ZS5jb20uY24iPnRhbmcud2VuamlAenRlLmNvbS5jbjwvYT4m
Z3Q7PGJyPg0KPGJyPg0KU2VnbWVudCBmYXVsdHkgb2NjdXJlZCB3aGVuIGV4ZWN1dGluZyAmcXVv
dDttcGF0aHBlcnNpc3QgLWkgLWs8YnI+DQrCoCDCoCAvZGV2L21hcHBlci9tcGF0aDEmcXVvdDsg
Y29tbWFuZC5UaGUgcmVhc29uIGlzIHRoYXQgYW4gdW5pbml0aWFsaXplZCBnbG9iYWw8YnI+DQrC
oCDCoCB2YXJpYWJsZSBjb25mIGlzIHVzZWQgaW4gbXBhdGhfcGVyc2lzdGVudF9yZXNlcnZlX2lu
KCkuIFRoZSBzYW1lPGJyPg0KwqAgwqAgcHJvYmxlbSBhbHNvIGV4aXN0cyBpbiBtcGF0aF9wZXJz
aXN0ZW50X3Jlc2VydmVfb3V0KCk8d2JyPi48YnI+DQo8YnI+DQpTaWduZWQtb2ZmLWJ5OiB0YW5n
LndlbmppICZsdDs8YSBocmVmPSJtYWlsdG86dGFuZy53ZW5qaUB6dGUuY29tLmNuIj50YW5nLndl
bmppQHp0ZS5jb20uY248L2E+Jmd0Ozxicj4NCi0tLTxicj4NCsKgbGlibXBhdGhwZXJzaXN0L21w
YXRoX3BlcnNpc3QuPHdicj5jIHwgMjIgKysrKysrKysrKysrKysrKysrKy0tLTxicj4NCsKgbGli
bXBhdGhwZXJzaXN0L21wYXRocHIuaMKgIMKgIMKgIMKgfMKgIDQgLS0tLTxicj4NCsKgMiBmaWxl
cyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKTxicj4NCjxicj4NCmRp
ZmYgLS1naXQgYS9saWJtcGF0aHBlcnNpc3QvbXBhdGhfPHdicj5wZXJzaXN0LmMgYi9saWJtcGF0
aHBlcnNpc3QvbXBhdGhfPHdicj5wZXJzaXN0LmM8YnI+DQppbmRleCBmYWVhMmI3Li45ODJjNzk1
IDEwMDY0NDxicj4NCi0tLSBhL2xpYm1wYXRocGVyc2lzdC9tcGF0aF88d2JyPnBlcnNpc3QuYzxi
cj4NCisrKyBiL2xpYm1wYXRocGVyc2lzdC9tcGF0aF88d2JyPnBlcnNpc3QuYzxicj4NCkBAIC0z
NSw3ICszNSw2IEBAPGJyPg0KwqAjZGVmaW5lIF9fU1REQ19GT1JNQVRfTUFDUk9TIDE8YnI+DQo8
YnI+DQrCoHN0cnVjdCB1ZGV2ICp1ZGV2Ozxicj4NCi1zdHJ1Y3QgY29uZmlnICpjb25mOzxicj4N
Cjxicj4NCsKgc3RydWN0IGNvbmZpZyAqPGJyPg0KwqBtcGF0aF9saWJfaW5pdCAoc3RydWN0IHVk
ZXYgKnVkZXYpPGJyPg0KQEAgLTc5LDYgKzc4LDcgQEAgdXBkYXRlcGF0aHMgKHN0cnVjdCBtdWx0
aXBhdGggKiBtcHApPGJyPg0KwqAgwqAgwqAgwqAgaW50IGksIGo7PGJyPg0KwqAgwqAgwqAgwqAg
c3RydWN0IHBhdGhncm91cCAqIHBncDs8YnI+DQrCoCDCoCDCoCDCoCBzdHJ1Y3QgcGF0aCAqIHBw
Ozxicj4NCivCoCDCoCDCoCDCoHN0cnVjdCBjb25maWcgKmNvbmY7PGJyPg0KPGJyPg0KwqAgwqAg
wqAgwqAgaWYgKCFtcHAtJmd0O3BnKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJldHVy
biAwOzxicj4NCkBAIC05OCwxNiArOTgsMjQgQEAgdXBkYXRlcGF0aHMgKHN0cnVjdCBtdWx0aXBh
dGggKiBtcHApPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgY29udGludWU7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIHBwLSZndDttcHAgPSBtcHA7PGJyPg0KK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZiA9IGdldF9tdWx0aXBhdGhf
Y29uZmlnKCk7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgcGF0aGluZm8ocHAsIGNvbmYsIERJX0FMTCk7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcHV0X211bHRpcGF0aF9jb25maWcoY29uZik7
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY29u
dGludWU7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfTxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHBwLSZndDttcHAgPSBtcHA7PGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKHBwLSZndDtzdGF0ZSA9PSBQ
QVRIX1VOQ0hFQ0tFRCB8fDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBwLSZndDtzdGF0ZSA9PSBQQVRIX1dJTEQpPGJyPg0K
K8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgcHAtJmd0O3N0YXRlID09IFBBVEhfV0lMRCkgezxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbmYgPSBnZXRfbXVsdGlwYXRoX2NvbmZpZygp
Ozxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHBh
dGhpbmZvKHBwLCBjb25mLCBESV9DSEVDS0VSKTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBwdXRfbXVsdGlwYXRoX2NvbmZpZyhjb25mKTs8YnI+
DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB9PGJyPg0KPGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKHBwLSZndDtwcmlvcml0eSA9PSBQUklP
X1VOREVGKTxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmIChwcC0m
Z3Q7cHJpb3JpdHkgPT0gUFJJT19VTkRFRikgezxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbmYgPSBnZXRfbXVsdGlwYXRoX2NvbmZpZygpOzxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHBhdGhp
bmZvKHBwLCBjb25mLCBESV9QUklPKTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBwdXRfbXVsdGlwYXRoX2NvbmZpZyhjb25mKTs8YnI+DQorwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB9PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgfTxicj4NCsKgIMKgIMKgIMKgIH08YnI+DQrCoCDCoCDCoCDCoCByZXR1cm4gMDs8YnI+
DQpAQCAtMTYwLDggKzE2OCwxMSBAQCBpbnQgbXBhdGhfcGVyc2lzdGVudF9yZXNlcnZlX2luIChp
bnQgZmQsIGludCBycV9zZXJ2YWN0LDxicj4NCsKgIMKgIMKgIMKgIGludCBtYXBfcHJlc2VudDs8
YnI+DQrCoCDCoCDCoCDCoCBpbnQgbWFqb3IsIG1pbm9yOzxicj4NCsKgIMKgIMKgIMKgIGludCBy
ZXQ7PGJyPg0KK8KgIMKgIMKgIMKgc3RydWN0IGNvbmZpZyAqY29uZjs8YnI+DQo8YnI+DQorwqAg
wqAgwqAgwqBjb25mID0gZ2V0X211bHRpcGF0aF9jb25maWcoKTs8YnI+DQrCoCDCoCDCoCDCoCBj
b25mLSZndDt2ZXJib3NpdHkgPSB2ZXJib3NlOzxicj4NCivCoCDCoCDCoCDCoHB1dF9tdWx0aXBh
dGhfY29uZmlnKGNvbmYpOzxicj4NCjxicj4NCsKgIMKgIMKgIMKgIGlmIChmc3RhdCggZmQsICZh
bXA7aW5mbykgIT0gMCl7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY29uZGxvZygwLCAm
cXVvdDtzdGF0IGVycm9yICVkJnF1b3Q7LCBmZCk7PGJyPg0KQEAgLTI1Myw4ICsyNjQsMTEgQEAg
aW50IG1wYXRoX3BlcnNpc3RlbnRfcmVzZXJ2ZV9vdXQgKCBpbnQgZmQsIGludCBycV9zZXJ2YWN0
LCBpbnQgcnFfc2NvcGUsPGJyPg0KwqAgwqAgwqAgwqAgaW50IGo7PGJyPg0KwqAgwqAgwqAgwqAg
dW5zaWduZWQgY2hhciAqa2V5cDs8YnI+DQrCoCDCoCDCoCDCoCB1aW50NjRfdCBwcmtleTs8YnI+
DQorwqAgwqAgwqAgwqBzdHJ1Y3QgY29uZmlnICpjb25mOzxicj4NCjxicj4NCivCoCDCoCDCoCDC
oGNvbmYgPSBnZXRfbXVsdGlwYXRoX2NvbmZpZygpOzxicj4NCsKgIMKgIMKgIMKgIGNvbmYtJmd0
O3ZlcmJvc2l0eSA9IHZlcmJvc2U7PGJyPg0KK8KgIMKgIMKgIMKgcHV0X211bHRpcGF0aF9jb25m
aWcoY29uZik7PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgaWYgKGZzdGF0KCBmZCwgJmFtcDtpbmZv
KSAhPSAwKXs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjb25kbG9nKDAsICZxdW90O3N0
YXQgZXJyb3IgZmQ9JWQmcXVvdDssIGZkKTs8YnI+DQpAQCAtMzIxLDcgKzMzNSw5IEBAIGludCBt
cGF0aF9wZXJzaXN0ZW50X3Jlc2VydmVfb3V0ICggaW50IGZkLCBpbnQgcnFfc2VydmFjdCwgaW50
IHJxX3Njb3BlLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGdvdG8gb3V0MTs8YnI+DQrC
oCDCoCDCoCDCoCB9PGJyPg0KPGJyPg0KK8KgIMKgIMKgIMKgY29uZiA9IGdldF9tdWx0aXBhdGhf
Y29uZmlnKCk7PGJyPg0KwqAgwqAgwqAgwqAgc2VsZWN0X3Jlc2VydmF0aW9uX2tleShjb25mLCBt
cHApOzxicj4NCivCoCDCoCDCoCDCoHB1dF9tdWx0aXBhdGhfY29uZmlnKGNvbmYpOzxicj4NCjxi
cj4NCsKgIMKgIMKgIMKgIHN3aXRjaChycV9zZXJ2YWN0KTxicj4NCsKgIMKgIMKgIMKgIHs8YnI+
DQpkaWZmIC0tZ2l0IGEvbGlibXBhdGhwZXJzaXN0L21wYXRocHIuaCBiL2xpYm1wYXRocGVyc2lz
dC9tcGF0aHByLmg8YnI+DQppbmRleCAwNTZjNTQ3Li5lNmMyZGVkIDEwMDY0NDxicj4NCi0tLSBh
L2xpYm1wYXRocGVyc2lzdC9tcGF0aHByLmg8YnI+DQorKysgYi9saWJtcGF0aHBlcnNpc3QvbXBh
dGhwci5oPGJyPg0KQEAgLTI1LDEwICsyNSw2IEBAIHN0cnVjdCB0aHJlYWRpbmZvIHs8YnI+DQrC
oCDCoCDCoCDCoCBzdHJ1Y3QgcHJvdXRfcGFyYW0gcGFyYW07PGJyPg0KwqB9Ozxicj4NCjxicj4N
Ci08YnI+DQotZXh0ZXJuIHN0cnVjdCBjb25maWcgKmNvbmY7PGJyPg0KLTxicj4NCi08YnI+DQrC
oGludCBwcmluX2RvX3Njc2lfaW9jdGwoY2hhciAqIGRldiwgaW50IHJxX3NlcnZhY3QsIHN0cnVj
dCBwcmluX3Jlc3AgKiByZXNwLCBpbnQgbm9pc3kpOzxicj4NCsKgaW50IHByb3V0X2RvX3Njc2lf
aW9jdGwoIGNoYXIgKiBkZXYsIGludCBycV9zZXJ2YWN0LCBpbnQgcnFfc2NvcGUsPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgdW5zaWduZWQgaW50IHJxX3R5cGUsIHN0cnVjdCBwcm91dF9w
YXJhbV9kZXNjcmlwdG9yICpwYXJhbXAsIGludCBub2lzeSk7PGJyPg0KPHNwYW4gY2xhc3M9IkhP
RW5aYiI+PGZvbnQgY29sb3I9IiM4ODg4ODgiPi0tPGJyPg0KMi44LjEud2luZG93cy4xPGJyPg0K
PGJyPg0KPGJyPg0KPC9mb250Pjwvc3Bhbj48L2Jsb2NrcXVvdGU+PC9kaXY+PGJyPjwvZGl2Pg0K
--94eb2c0ec214b026d80541b7f24b--


--===============5587338032914152683==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5587338032914152683==--
