From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath:fix memory leak in path group
	policies
Date: Sun, 31 Jul 2016 11:00:28 +0200
Message-ID: <CABr-GndXJ65BE8yruukAiUxXTcD0SzumZsHE=7d-BMWSTN-MwA@mail.gmail.com>
References: <1469527743-7548-1-git-send-email-zhang.kai16@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5308174055187102074=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469527743-7548-1-git-send-email-zhang.kai16@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: zhang.kai16@zte.com.cn
Cc: device-mapper development <dm-devel@redhat.com>, tang.junhui@zte.com.cn, christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

--===============5308174055187102074==
Content-Type: multipart/alternative; boundary=001a114b107c1e6fea0538eab76d

--001a114b107c1e6fea0538eab76d
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Tue, Jul 26, 2016 at 12:09 PM, <zhang.kai16@zte.com.cn> wrote:

> From: "zhang.kai" <zhang.kai16@zte.com.cn>
>
> In the path group functions, memory leak would happen if the exceptional
> situation were met.
>
> Signed-off-by: zhang.kai <zhang.kai16@zte.com.cn>
> ---
>  libmultipath/pgpolicies.c | 79
> +++++++++++++++++++++++++++++------------------
>  1 file changed, 49 insertions(+), 30 deletions(-)
>
> diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
> index f440441..3064aab 100644
> --- a/libmultipath/pgpolicies.c
> +++ b/libmultipath/pgpolicies.c
> @@ -123,11 +123,11 @@ group_by_node_name (struct multipath * mp) {
>                         goto out1;
>
>                 if (store_pathgroup(mp->pg, pgp))
> -                       goto out1;
> +                       goto out2;
>
>                 /* feed the first path */
>                 if (store_path(pgp->paths, pp))
> -                       goto out1;
> +                       goto out2;
>
>                 bitmap[i] = 1;
>
> @@ -141,7 +141,7 @@ group_by_node_name (struct multipath * mp) {
>                         if (!strncmp(pp->tgt_node_name, pp2->tgt_node_name,
>                                         NODE_NAME_SIZE)) {
>                                 if (store_path(pgp->paths, pp2))
> -                                       goto out1;
> +                                       goto out2;
>
>                                 bitmap[j] = 1;
>                         }
> @@ -152,6 +152,8 @@ group_by_node_name (struct multipath * mp) {
>         free_pathvec(mp->paths, KEEP_PATHS);
>         mp->paths = NULL;
>         return 0;
> +out2:
> +       free_pathgroup(pgp, KEEP_PATHS);
>  out1:
>         FREE(bitmap);
>  out:
> @@ -197,11 +199,11 @@ group_by_serial (struct multipath * mp) {
>                         goto out1;
>
>                 if (store_pathgroup(mp->pg, pgp))
> -                       goto out1;
> +                       goto out2;
>
>                 /* feed the first path */
>                 if (store_path(pgp->paths, pp))
> -                       goto out1;
> +                       goto out2;
>
>                 bitmap[i] = 1;
>
> @@ -214,7 +216,7 @@ group_by_serial (struct multipath * mp) {
>
>                         if (0 == strcmp(pp->serial, pp2->serial)) {
>                                 if (store_path(pgp->paths, pp2))
> -                                       goto out1;
> +                                       goto out2;
>
>                                 bitmap[j] = 1;
>                         }
> @@ -225,6 +227,8 @@ group_by_serial (struct multipath * mp) {
>         free_pathvec(mp->paths, KEEP_PATHS);
>         mp->paths = NULL;
>         return 0;
> +out2:
> +       free_pathgroup(pgp, KEEP_PATHS);
>  out1:
>         FREE(bitmap);
>  out:
> @@ -254,15 +258,17 @@ one_path_per_group (struct multipath * mp)
>                         goto out;
>
>                 if (store_pathgroup(mp->pg, pgp))
> -                       goto out;
> +                       goto out1;
>
>                 if (store_path(pgp->paths, pp))
> -                       goto out;
> +                       goto out1;
>         }
>         sort_pathgroups(mp);
>         free_pathvec(mp->paths, KEEP_PATHS);
>         mp->paths = NULL;
>         return 0;
> +out1:
> +       free_pathgroup(pgp, KEEP_PATHS);
>  out:
>         free_pgvec(mp->pg, KEEP_PATHS);
>         mp->pg = NULL;
> @@ -290,14 +296,17 @@ one_group (struct multipath * mp) /* aka multibus */
>                         goto out;
>
>                 vector_free(pgp->paths);
> -               pgp->paths = mp->paths;
> -               mp->paths = NULL;
>
>                 if (store_pathgroup(mp->pg, pgp))
> -                       goto out;
> +                       goto out1;
> +
> +               pgp->paths = mp->paths;
> +               mp->paths = NULL;
>         }
>
>         return 0;
> +out1:
> +       free_pathgroup(pgp, KEEP_PATHS);
>  out:
>         free_pgvec(mp->pg, KEEP_PATHS);
>         mp->pg = NULL;
> @@ -311,6 +320,7 @@ group_by_prio (struct multipath * mp)
>         unsigned int prio;
>         struct path * pp;
>         struct pathgroup * pgp;
> +       vector pathvec = NULL;
>
>         if (!mp->pg)
>                 mp->pg = vector_alloc();
> @@ -318,8 +328,18 @@ group_by_prio (struct multipath * mp)
>         if (!mp->pg)
>                 return 1;
>
> -       while (VECTOR_SIZE(mp->paths) > 0) {
> -               pp = VECTOR_SLOT(mp->paths, 0);
> +       pathvec = vector_alloc();
> +       if (!pathvec)
> +               goto out;
> +
> +       vector_foreach_slot(mp->paths, pp, i) {
> +               if (!vector_alloc_slot(pathvec))
> +                       goto out1;
> +               vector_set_slot(pathvec, pp);
> +       }
> +
> +       while (VECTOR_SIZE(pathvec) > 0) {
> +               pp = VECTOR_SLOT(pathvec, 0);
>                 prio = pp->priority;
>
>                 /*
> @@ -339,46 +359,45 @@ group_by_prio (struct multipath * mp)
>                 pgp = alloc_pathgroup();
>
>                 if (!pgp)
> -                       goto out;
> +                       goto out1;
>
> -               if (store_path(pgp->paths, VECTOR_SLOT(mp->paths, 0))) {
> -                       free_pathgroup(pgp, KEEP_PATHS);
> -                       goto out;
> -               }
> +               if (store_path(pgp->paths, VECTOR_SLOT(pathvec, 0)))
> +                       goto out2;
>
> -               vector_del_slot(mp->paths, 0);
> +               vector_del_slot(pathvec, 0);
>
>                 /*
>                  * Store the new path group into the vector.
>                  */
>                 if (i < VECTOR_SIZE(mp->pg)) {
> -                       if (!vector_insert_slot(mp->pg, i, pgp)) {
> -                               free_pathgroup(pgp, KEEP_PATHS);
> -                               goto out;
> -                       }
> +                       if (!vector_insert_slot(mp->pg, i, pgp))
> +                               goto out2;
>                 } else {
> -                       if (store_pathgroup(mp->pg, pgp)) {
> -                               free_pathgroup(pgp, KEEP_PATHS);
> -                               goto out;
> -                       }
> +                       if (store_pathgroup(mp->pg, pgp))
> +                               goto out2;
>                 }
>
>                 /*
>                  * add the other paths with the same prio
>                  */
> -               vector_foreach_slot(mp->paths, pp, i) {
> +               vector_foreach_slot(pathvec, pp, i) {
>                         if (pp->priority == prio) {
>                                 if (store_path(pgp->paths, pp))
> -                                       goto out;
> +                                       goto out2;
>
> -                               vector_del_slot(mp->paths, i);
> +                               vector_del_slot(pathvec, i);
>                                 i--;
>                         }
>                 }
>         }
> +       free_pathvec(pathvec, KEEP_PATHS);
>         free_pathvec(mp->paths, KEEP_PATHS);
>         mp->paths = NULL;
>         return 0;
> +out2:
> +       free_pathgroup(pgp, KEEP_PATHS);
> +out1:
> +       free_pathvec(pathvec, KEEP_PATHS);
>  out:
>         free_pgvec(mp->pg, KEEP_PATHS);
>         mp->pg = NULL;
> --
> 2.8.1.windows.1
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a114b107c1e6fea0538eab76d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+TWVyZ2VkLjxkaXY+VGhhbmtzLjwvZGl2PjwvZGl2PjxkaXYgY2xhc3M9
ImdtYWlsX2V4dHJhIj48YnI+PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIFR1ZSwgSnVsIDI2
LCAyMDE2IGF0IDEyOjA5IFBNLCAgPHNwYW4gZGlyPSJsdHIiPiZsdDs8YSBocmVmPSJtYWlsdG86
emhhbmcua2FpMTZAenRlLmNvbS5jbiIgdGFyZ2V0PSJfYmxhbmsiPnpoYW5nLmthaTE2QHp0ZS5j
b20uY248L2E+Jmd0Ozwvc3Bhbj4gd3JvdGU6PGJyPjxibG9ja3F1b3RlIGNsYXNzPSJnbWFpbF9x
dW90ZSIgc3R5bGU9Im1hcmdpbjowIDAgMCAuOGV4O2JvcmRlci1sZWZ0OjFweCAjY2NjIHNvbGlk
O3BhZGRpbmctbGVmdDoxZXgiPkZyb206ICZxdW90O3poYW5nLmthaSZxdW90OyAmbHQ7PGEgaHJl
Zj0ibWFpbHRvOnpoYW5nLmthaTE2QHp0ZS5jb20uY24iPnpoYW5nLmthaTE2QHp0ZS5jb20uY248
L2E+Jmd0Ozxicj4NCjxicj4NCkluIHRoZSBwYXRoIGdyb3VwIGZ1bmN0aW9ucywgbWVtb3J5IGxl
YWsgd291bGQgaGFwcGVuIGlmIHRoZSBleGNlcHRpb25hbCBzaXR1YXRpb24gd2VyZSBtZXQuPGJy
Pg0KPGJyPg0KU2lnbmVkLW9mZi1ieTogemhhbmcua2FpICZsdDs8YSBocmVmPSJtYWlsdG86emhh
bmcua2FpMTZAenRlLmNvbS5jbiI+emhhbmcua2FpMTZAenRlLmNvbS5jbjwvYT4mZ3Q7PGJyPg0K
LS0tPGJyPg0KwqBsaWJtdWx0aXBhdGgvcGdwb2xpY2llcy5jIHwgNzkgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS08YnI+DQrCoDEgZmlsZSBjaGFuZ2VkLCA0
OSBpbnNlcnRpb25zKCspLCAzMCBkZWxldGlvbnMoLSk8YnI+DQo8YnI+DQpkaWZmIC0tZ2l0IGEv
bGlibXVsdGlwYXRoL3BncG9saWNpZXMuYyBiL2xpYm11bHRpcGF0aC9wZ3BvbGljaWVzLmM8YnI+
DQppbmRleCBmNDQwNDQxLi4zMDY0YWFiIDEwMDY0NDxicj4NCi0tLSBhL2xpYm11bHRpcGF0aC9w
Z3BvbGljaWVzLmM8YnI+DQorKysgYi9saWJtdWx0aXBhdGgvcGdwb2xpY2llcy5jPGJyPg0KQEAg
LTEyMywxMSArMTIzLDExIEBAIGdyb3VwX2J5X25vZGVfbmFtZSAoc3RydWN0IG11bHRpcGF0aCAq
IG1wKSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZ290byBvdXQx
Ozxicj4NCjxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmIChzdG9yZV9wYXRoZ3JvdXAo
bXAtJmd0O3BnLCBwZ3ApKTxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oGdvdG8gb3V0MTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBnb3Rv
IG91dDI7PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLyogZmVlZCB0aGUgZmly
c3QgcGF0aCAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmIChzdG9yZV9wYXRoKHBn
cC0mZ3Q7cGF0aHMsIHBwKSk8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqBnb3RvIG91dDE7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZ290
byBvdXQyOzxicj4NCjxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJpdG1hcFtpXSA9IDE7
PGJyPg0KPGJyPg0KQEAgLTE0MSw3ICsxNDEsNyBAQCBncm91cF9ieV9ub2RlX25hbWUgKHN0cnVj
dCBtdWx0aXBhdGggKiBtcCkgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIGlmICghc3RybmNtcChwcC0mZ3Q7dGd0X25vZGVfbmFtZSwgcHAyLSZndDt0Z3Rfbm9kZV9u
YW1lLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIE5PREVfTkFNRV9TSVpFKSkgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmIChzdG9yZV9wYXRoKHBncC0mZ3Q7cGF0aHMs
IHBwMikpPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgZ290byBvdXQxOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGdvdG8gb3V0Mjs8YnI+DQo8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBiaXRtYXBbal0g
PSAxOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIH08YnI+DQpAQCAt
MTUyLDYgKzE1Miw4IEBAIGdyb3VwX2J5X25vZGVfbmFtZSAoc3RydWN0IG11bHRpcGF0aCAqIG1w
KSB7PGJyPg0KwqAgwqAgwqAgwqAgZnJlZV9wYXRodmVjKG1wLSZndDtwYXRocywgS0VFUF9QQVRI
Uyk7PGJyPg0KwqAgwqAgwqAgwqAgbXAtJmd0O3BhdGhzID0gTlVMTDs8YnI+DQrCoCDCoCDCoCDC
oCByZXR1cm4gMDs8YnI+DQorb3V0Mjo8YnI+DQorwqAgwqAgwqAgwqBmcmVlX3BhdGhncm91cChw
Z3AsIEtFRVBfUEFUSFMpOzxicj4NCsKgb3V0MTo8YnI+DQrCoCDCoCDCoCDCoCBGUkVFKGJpdG1h
cCk7PGJyPg0KwqBvdXQ6PGJyPg0KQEAgLTE5NywxMSArMTk5LDExIEBAIGdyb3VwX2J5X3Nlcmlh
bCAoc3RydWN0IG11bHRpcGF0aCAqIG1wKSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgZ290byBvdXQxOzxicj4NCjxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IGlmIChzdG9yZV9wYXRoZ3JvdXAobXAtJmd0O3BnLCBwZ3ApKTxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoGdvdG8gb3V0MTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqBnb3RvIG91dDI7PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLyogZmVlZCB0aGUgZmlyc3QgcGF0aCAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIGlmIChzdG9yZV9wYXRoKHBncC0mZ3Q7cGF0aHMsIHBwKSk8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBnb3RvIG91dDE7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgZ290byBvdXQyOzxicj4NCjxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIGJpdG1hcFtpXSA9IDE7PGJyPg0KPGJyPg0KQEAgLTIxNCw3ICsyMTYsNyBAQCBncm91
cF9ieV9zZXJpYWwgKHN0cnVjdCBtdWx0aXBhdGggKiBtcCkgezxicj4NCjxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmICgwID09IHN0cmNtcChwcC0mZ3Q7c2VyaWFs
LCBwcDItJmd0O3NlcmlhbCkpIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCBpZiAoc3RvcmVfcGF0aChwZ3AtJmd0O3BhdGhzLCBwcDIpKTxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoGdvdG8gb3V0MTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBnb3RvIG91dDI7PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYml0bWFwW2pdID0gMTs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB9PGJyPg0KQEAgLTIyNSw2ICsyMjcs
OCBAQCBncm91cF9ieV9zZXJpYWwgKHN0cnVjdCBtdWx0aXBhdGggKiBtcCkgezxicj4NCsKgIMKg
IMKgIMKgIGZyZWVfcGF0aHZlYyhtcC0mZ3Q7cGF0aHMsIEtFRVBfUEFUSFMpOzxicj4NCsKgIMKg
IMKgIMKgIG1wLSZndDtwYXRocyA9IE5VTEw7PGJyPg0KwqAgwqAgwqAgwqAgcmV0dXJuIDA7PGJy
Pg0KK291dDI6PGJyPg0KK8KgIMKgIMKgIMKgZnJlZV9wYXRoZ3JvdXAocGdwLCBLRUVQX1BBVEhT
KTs8YnI+DQrCoG91dDE6PGJyPg0KwqAgwqAgwqAgwqAgRlJFRShiaXRtYXApOzxicj4NCsKgb3V0
Ojxicj4NCkBAIC0yNTQsMTUgKzI1OCwxNyBAQCBvbmVfcGF0aF9wZXJfZ3JvdXAgKHN0cnVjdCBt
dWx0aXBhdGggKiBtcCk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBn
b3RvIG91dDs8YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoc3RvcmVfcGF0
aGdyb3VwKG1wLSZndDtwZywgcGdwKSk8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBnb3RvIG91dDs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqBnb3RvIG91dDE7PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKHN0b3Jl
X3BhdGgocGdwLSZndDtwYXRocywgcHApKTxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoGdvdG8gb3V0Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoGdvdG8gb3V0MTs8YnI+DQrCoCDCoCDCoCDCoCB9PGJyPg0KwqAgwqAgwqAgwqAgc29ydF9w
YXRoZ3JvdXBzKG1wKTs8YnI+DQrCoCDCoCDCoCDCoCBmcmVlX3BhdGh2ZWMobXAtJmd0O3BhdGhz
LCBLRUVQX1BBVEhTKTs8YnI+DQrCoCDCoCDCoCDCoCBtcC0mZ3Q7cGF0aHMgPSBOVUxMOzxicj4N
CsKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCitvdXQxOjxicj4NCivCoCDCoCDCoCDCoGZyZWVf
cGF0aGdyb3VwKHBncCwgS0VFUF9QQVRIUyk7PGJyPg0KwqBvdXQ6PGJyPg0KwqAgwqAgwqAgwqAg
ZnJlZV9wZ3ZlYyhtcC0mZ3Q7cGcsIEtFRVBfUEFUSFMpOzxicj4NCsKgIMKgIMKgIMKgIG1wLSZn
dDtwZyA9IE5VTEw7PGJyPg0KQEAgLTI5MCwxNCArMjk2LDE3IEBAIG9uZV9ncm91cCAoc3RydWN0
IG11bHRpcGF0aCAqIG1wKSAvKiBha2EgbXVsdGlidXMgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIG91dDs8YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCB2ZWN0b3JfZnJlZShwZ3AtJmd0O3BhdGhzKTs8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBwZ3AtJmd0O3BhdGhzID0gbXAtJmd0O3BhdGhzOzxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoG1wLSZndDtwYXRocyA9IE5VTEw7PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgaWYgKHN0b3JlX3BhdGhncm91cChtcC0mZ3Q7cGcsIHBncCkpPGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZ290byBvdXQ7PGJyPg0KK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZ290byBvdXQxOzxicj4NCis8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBwZ3AtJmd0O3BhdGhzID0gbXAtJmd0O3BhdGhzOzxicj4NCivCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoG1wLSZndDtwYXRocyA9IE5VTEw7PGJyPg0KwqAgwqAgwqAgwqAgfTxi
cj4NCjxicj4NCsKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCitvdXQxOjxicj4NCivCoCDCoCDC
oCDCoGZyZWVfcGF0aGdyb3VwKHBncCwgS0VFUF9QQVRIUyk7PGJyPg0KwqBvdXQ6PGJyPg0KwqAg
wqAgwqAgwqAgZnJlZV9wZ3ZlYyhtcC0mZ3Q7cGcsIEtFRVBfUEFUSFMpOzxicj4NCsKgIMKgIMKg
IMKgIG1wLSZndDtwZyA9IE5VTEw7PGJyPg0KQEAgLTMxMSw2ICszMjAsNyBAQCBncm91cF9ieV9w
cmlvIChzdHJ1Y3QgbXVsdGlwYXRoICogbXApPGJyPg0KwqAgwqAgwqAgwqAgdW5zaWduZWQgaW50
IHByaW87PGJyPg0KwqAgwqAgwqAgwqAgc3RydWN0IHBhdGggKiBwcDs8YnI+DQrCoCDCoCDCoCDC
oCBzdHJ1Y3QgcGF0aGdyb3VwICogcGdwOzxicj4NCivCoCDCoCDCoCDCoHZlY3RvciBwYXRodmVj
ID0gTlVMTDs8YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCBpZiAoIW1wLSZndDtwZyk8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCBtcC0mZ3Q7cGcgPSB2ZWN0b3JfYWxsb2MoKTs8YnI+DQpAQCAt
MzE4LDggKzMyOCwxOCBAQCBncm91cF9ieV9wcmlvIChzdHJ1Y3QgbXVsdGlwYXRoICogbXApPGJy
Pg0KwqAgwqAgwqAgwqAgaWYgKCFtcC0mZ3Q7cGcpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgcmV0dXJuIDE7PGJyPg0KPGJyPg0KLcKgIMKgIMKgIMKgd2hpbGUgKFZFQ1RPUl9TSVpFKG1w
LSZndDtwYXRocykgJmd0OyAwKSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcHAgPSBW
RUNUT1JfU0xPVChtcC0mZ3Q7cGF0aHMsIDApOzxicj4NCivCoCDCoCDCoCDCoHBhdGh2ZWMgPSB2
ZWN0b3JfYWxsb2MoKTs8YnI+DQorwqAgwqAgwqAgwqBpZiAoIXBhdGh2ZWMpPGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgZ290byBvdXQ7PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoHZlY3Rv
cl9mb3JlYWNoX3Nsb3QobXAtJmd0O3BhdGhzLCBwcCwgaSkgezxicj4NCivCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoGlmICghdmVjdG9yX2FsbG9jX3Nsb3QocGF0aHZlYykpPGJyPg0KK8KgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZ290byBvdXQxOzxicj4NCivCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoHZlY3Rvcl9zZXRfc2xvdChwYXRodmVjLCBwcCk7PGJyPg0KK8KgIMKgIMKgIMKg
fTxicj4NCis8YnI+DQorwqAgwqAgwqAgwqB3aGlsZSAoVkVDVE9SX1NJWkUocGF0aHZlYykgJmd0
OyAwKSB7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcHAgPSBWRUNUT1JfU0xPVChwYXRo
dmVjLCAwKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBwcmlvID0gcHAtJmd0O3ByaW9y
aXR5Ozxicj4NCjxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC8qPGJyPg0KQEAgLTMzOSw0
NiArMzU5LDQ1IEBAIGdyb3VwX2J5X3ByaW8gKHN0cnVjdCBtdWx0aXBhdGggKiBtcCk8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBwZ3AgPSBhbGxvY19wYXRoZ3JvdXAoKTs8YnI+DQo8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoIXBncCk8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBnb3RvIG91dDs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBnb3RvIG91dDE7PGJyPg0KPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgaWYgKHN0b3JlX3BhdGgocGdwLSZndDtwYXRocywgVkVDVE9SX1NMT1QobXAtJmd0O3BhdGhz
LCAwKSkpIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBmcmVlX3Bh
dGhncm91cChwZ3AsIEtFRVBfUEFUSFMpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoGdvdG8gb3V0Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoH08YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAoc3RvcmVfcGF0aChwZ3AtJmd0O3BhdGhzLCBWRUNU
T1JfU0xPVChwYXRodmVjLCAwKSkpPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgZ290byBvdXQyOzxicj4NCjxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHZlY3Rv
cl9kZWxfc2xvdChtcC0mZ3Q7cGF0aHMsIDApOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oHZlY3Rvcl9kZWxfc2xvdChwYXRodmVjLCAwKTs8YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAvKjxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgKiBTdG9yZSB0aGUgbmV3
IHBhdGggZ3JvdXAgaW50byB0aGUgdmVjdG9yLjxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoaSAmbHQ7IFZFQ1RPUl9TSVpF
KG1wLSZndDtwZykpIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBp
ZiAoIXZlY3Rvcl9pbnNlcnRfc2xvdChtcC0mZ3Q7cGcsIGksIHBncCkpIHs8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBmcmVlX3BhdGhncm91cChw
Z3AsIEtFRVBfUEFUSFMpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoGdvdG8gb3V0Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoH08YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAoIXZl
Y3Rvcl9pbnNlcnRfc2xvdChtcC0mZ3Q7cGcsIGksIHBncCkpPGJyPg0KK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZ290byBvdXQyOzxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIH0gZWxzZSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgaWYgKHN0b3JlX3BhdGhncm91cChtcC0mZ3Q7cGcsIHBncCkpIHs8YnI+DQotwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBmcmVlX3BhdGhncm91
cChwZ3AsIEtFRVBfUEFUSFMpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoGdvdG8gb3V0Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoH08YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAo
c3RvcmVfcGF0aGdyb3VwKG1wLSZndDtwZywgcGdwKSk8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBnb3RvIG91dDI7PGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgfTxicj4NCjxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC8qPGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAqIGFkZCB0aGUgb3RoZXIgcGF0aHMgd2l0aCB0aGUg
c2FtZSBwcmlvPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAqLzxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoHZlY3Rvcl9mb3JlYWNoX3Nsb3QobXAtJmd0O3BhdGhzLCBwcCwgaSkg
ezxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHZlY3Rvcl9mb3JlYWNoX3Nsb3QocGF0aHZl
YywgcHAsIGkpIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAo
cHAtJmd0O3ByaW9yaXR5ID09IHByaW8pIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoc3RvcmVfcGF0aChwZ3AtJmd0O3BhdGhzLCBwcCkp
PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgZ290byBvdXQ7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZ290byBvdXQyOzxicj4NCjxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHZlY3Rvcl9kZWxfc2xvdCht
cC0mZ3Q7cGF0aHMsIGkpOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoHZlY3Rvcl9kZWxfc2xvdChwYXRodmVjLCBpKTs8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpLS07PGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IH08YnI+DQrCoCDCoCDCoCDCoCB9PGJyPg0KK8KgIMKgIMKgIMKgZnJlZV9wYXRodmVjKHBhdGh2
ZWMsIEtFRVBfUEFUSFMpOzxicj4NCsKgIMKgIMKgIMKgIGZyZWVfcGF0aHZlYyhtcC0mZ3Q7cGF0
aHMsIEtFRVBfUEFUSFMpOzxicj4NCsKgIMKgIMKgIMKgIG1wLSZndDtwYXRocyA9IE5VTEw7PGJy
Pg0KwqAgwqAgwqAgwqAgcmV0dXJuIDA7PGJyPg0KK291dDI6PGJyPg0KK8KgIMKgIMKgIMKgZnJl
ZV9wYXRoZ3JvdXAocGdwLCBLRUVQX1BBVEhTKTs8YnI+DQorb3V0MTo8YnI+DQorwqAgwqAgwqAg
wqBmcmVlX3BhdGh2ZWMocGF0aHZlYywgS0VFUF9QQVRIUyk7PGJyPg0KwqBvdXQ6PGJyPg0KwqAg
wqAgwqAgwqAgZnJlZV9wZ3ZlYyhtcC0mZ3Q7cGcsIEtFRVBfUEFUSFMpOzxicj4NCsKgIMKgIMKg
IMKgIG1wLSZndDtwZyA9IE5VTEw7PGJyPg0KPHNwYW4gY2xhc3M9IkhPRW5aYiI+PGZvbnQgY29s
b3I9IiM4ODg4ODgiPi0tPGJyPg0KMi44LjEud2luZG93cy4xPGJyPg0KPGJyPg0KLS08YnI+DQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3Q8YnI+DQo8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0
LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+DQo8YSBocmVmPSJodHRwczovL3d3dy5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFy
Z2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbDwvYT48YnI+DQo8L2ZvbnQ+PC9zcGFuPjwvYmxvY2txdW90ZT48L2Rpdj48YnI+PC9kaXY+
DQo=
--001a114b107c1e6fea0538eab76d--


--===============5308174055187102074==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5308174055187102074==--
