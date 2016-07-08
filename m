From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: restore paths after reconfigure
Date: Fri, 8 Jul 2016 09:21:33 +0200
Message-ID: <CABr-Gnc35pRJur6GAoGA6T5FmN7FNugizpYq9Ewgs4_H-tMg6g@mail.gmail.com>
References: <1467409569-16088-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3058440047636883375=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467409569-16088-1-git-send-email-bmarzins@redhat.com>
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

--===============3058440047636883375==
Content-Type: multipart/alternative; boundary=001a1140126006eac205371aa79c

--001a1140126006eac205371aa79c
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Fri, Jul 1, 2016 at 11:46 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> multipathd has code to finish gathering the information of paths that
> were not active at the time they were discovered. When the checker loop
> goes to check a path, and notices that it wasn't fully initialized, it
> is supposed to complete the initialization.  However the code is broken.
> This means that if you reconfigure multipathd while paths are down, they
> will no longer be usable. This patch makes sure that check_path will
> actually rerun pathinfo to finish setting up the path, so that after the
> path comes back up, it will be usable again.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c |  5 +++--
>  multipathd/main.c        | 20 ++++++++++++++++----
>  2 files changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index d5215f9..eb2e926 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1713,8 +1713,9 @@ pathinfo (struct path *pp, struct config *conf, int
> mask)
>                         get_prio(pp);
>                 }
>         }
> -
> -       pp->initialized = INIT_OK;
> +
> +       if ((mask & DI_ALL) == DI_ALL)
> +               pp->initialized = INIT_OK;
>         return PATHINFO_OK;
>
>  blank:
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9682b3e..6e3ae69 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1439,7 +1439,8 @@ int update_path_groups(struct multipath *mpp, struct
> vectors *vecs, int refresh)
>  }
>
>  /*
> - * Returns '1' if the path has been checked, '0' otherwise
> + * Returns '1' if the path has been checked, '-1' if it was blacklisted
> + * and '0' otherwise
>   */
>  int
>  check_path (struct vectors * vecs, struct path * pp, int ticks)
> @@ -1452,6 +1453,7 @@ check_path (struct vectors * vecs, struct path * pp,
> int ticks)
>         int oldchkrstate = pp->chkrstate;
>         int retrigger_tries, checkint;
>         struct config *conf;
> +       int ret;
>
>         if ((pp->initialized == INIT_OK ||
>              pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp)
> @@ -1511,10 +1513,14 @@ check_path (struct vectors * vecs, struct path *
> pp, int ticks)
>                     (newstate == PATH_UP || newstate == PATH_GHOST)) {
>                         condlog(2, "%s: add missing path", pp->dev);
>                         conf = get_multipath_config();
> -                       if (pathinfo(pp, conf, DI_ALL) == 0) {
> +                       ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
> +                       if (ret == PATHINFO_OK) {
>                                 ev_add_path(pp, vecs);
>                                 pp->tick = 1;
> -                       }
> +                       } else if (ret == PATHINFO_SKIPPED) {
> +                               put_multipath_config(conf);
> +                               return -1;
> +                       }
>                         put_multipath_config(conf);
>                 }
>                 return 0;
> @@ -1779,7 +1785,13 @@ checkerloop (void *ap)
>                         lock(vecs->lock);
>                         pthread_testcancel();
>                         vector_foreach_slot (vecs->pathvec, pp, i) {
> -                               num_paths += check_path(vecs, pp, ticks);
> +                               rc = check_path(vecs, pp, ticks);
> +                               if (rc < 0) {
> +                                       vector_del_slot(vecs->pathvec, i);
> +                                       free_path(pp);
> +                                       i--;
> +                               } else;
> +                                       num_paths += rc;
>                         }
>                         lock_cleanup_pop(vecs->lock);
>                 }
> --
> 1.8.3.1
>
>

--001a1140126006eac205371aa79c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+TWVyZ2VkLjxkaXY+VGhhbmtzLjwvZGl2PjwvZGl2PjxkaXYgY2xhc3M9
ImdtYWlsX2V4dHJhIj48YnI+PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIEZyaSwgSnVsIDEs
IDIwMTYgYXQgMTE6NDYgUE0sIEJlbmphbWluIE1hcnppbnNraSA8c3BhbiBkaXI9Imx0ciI+Jmx0
OzxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIiB0YXJnZXQ9Il9ibGFuayI+Ym1h
cnppbnNAcmVkaGF0LmNvbTwvYT4mZ3Q7PC9zcGFuPiB3cm90ZTo8YnI+PGJsb2NrcXVvdGUgY2xh
c3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxlZnQ6MXB4
ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI+bXVsdGlwYXRoZCBoYXMgY29kZSB0byBmaW5p
c2ggZ2F0aGVyaW5nIHRoZSBpbmZvcm1hdGlvbiBvZiBwYXRocyB0aGF0PGJyPg0Kd2VyZSBub3Qg
YWN0aXZlIGF0IHRoZSB0aW1lIHRoZXkgd2VyZSBkaXNjb3ZlcmVkLiBXaGVuIHRoZSBjaGVja2Vy
IGxvb3A8YnI+DQpnb2VzIHRvIGNoZWNrIGEgcGF0aCwgYW5kIG5vdGljZXMgdGhhdCBpdCB3YXNu
JiMzOTt0IGZ1bGx5IGluaXRpYWxpemVkLCBpdDxicj4NCmlzIHN1cHBvc2VkIHRvIGNvbXBsZXRl
IHRoZSBpbml0aWFsaXphdGlvbi7CoCBIb3dldmVyIHRoZSBjb2RlIGlzIGJyb2tlbi48YnI+DQpU
aGlzIG1lYW5zIHRoYXQgaWYgeW91IHJlY29uZmlndXJlIG11bHRpcGF0aGQgd2hpbGUgcGF0aHMg
YXJlIGRvd24sIHRoZXk8YnI+DQp3aWxsIG5vIGxvbmdlciBiZSB1c2FibGUuIFRoaXMgcGF0Y2gg
bWFrZXMgc3VyZSB0aGF0IGNoZWNrX3BhdGggd2lsbDxicj4NCmFjdHVhbGx5IHJlcnVuIHBhdGhp
bmZvIHRvIGZpbmlzaCBzZXR0aW5nIHVwIHRoZSBwYXRoLCBzbyB0aGF0IGFmdGVyIHRoZTxicj4N
CnBhdGggY29tZXMgYmFjayB1cCwgaXQgd2lsbCBiZSB1c2FibGUgYWdhaW4uPGJyPg0KPGJyPg0K
U2lnbmVkLW9mZi1ieTogQmVuamFtaW4gTWFyemluc2tpICZsdDs8YSBocmVmPSJtYWlsdG86Ym1h
cnppbnNAcmVkaGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT4mZ3Q7PGJyPg0KLS0tPGJy
Pg0KwqBsaWJtdWx0aXBhdGgvZGlzY292ZXJ5LmMgfMKgIDUgKysrLS08YnI+DQrCoG11bHRpcGF0
aGQvbWFpbi5jwqAgwqAgwqAgwqAgfCAyMCArKysrKysrKysrKysrKysrLS0tLTxicj4NCsKgMiBm
aWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKTxicj4NCjxicj4N
CmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvZGlzY292ZXJ5LmMgYi9saWJtdWx0aXBhdGgvZGlz
Y292ZXJ5LmM8YnI+DQppbmRleCBkNTIxNWY5Li5lYjJlOTI2IDEwMDY0NDxicj4NCi0tLSBhL2xp
Ym11bHRpcGF0aC9kaXNjb3ZlcnkuYzxicj4NCisrKyBiL2xpYm11bHRpcGF0aC9kaXNjb3Zlcnku
Yzxicj4NCkBAIC0xNzEzLDggKzE3MTMsOSBAQCBwYXRoaW5mbyAoc3RydWN0IHBhdGggKnBwLCBz
dHJ1Y3QgY29uZmlnICpjb25mLCBpbnQgbWFzayk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBnZXRfcHJpbyhwcCk7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
fTxicj4NCsKgIMKgIMKgIMKgIH08YnI+DQotPGJyPg0KLcKgIMKgIMKgIMKgcHAtJmd0O2luaXRp
YWxpemVkID0gSU5JVF9PSzs8YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgaWYgKChtYXNrICZhbXA7
IERJX0FMTCkgPT0gRElfQUxMKTxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBwLSZndDtp
bml0aWFsaXplZCA9IElOSVRfT0s7PGJyPg0KwqAgwqAgwqAgwqAgcmV0dXJuIFBBVEhJTkZPX09L
Ozxicj4NCjxicj4NCsKgYmxhbms6PGJyPg0KZGlmZiAtLWdpdCBhL211bHRpcGF0aGQvbWFpbi5j
IGIvbXVsdGlwYXRoZC9tYWluLmM8YnI+DQppbmRleCA5NjgyYjNlLi42ZTNhZTY5IDEwMDY0NDxi
cj4NCi0tLSBhL211bHRpcGF0aGQvbWFpbi5jPGJyPg0KKysrIGIvbXVsdGlwYXRoZC9tYWluLmM8
YnI+DQpAQCAtMTQzOSw3ICsxNDM5LDggQEAgaW50IHVwZGF0ZV9wYXRoX2dyb3VwcyhzdHJ1Y3Qg
bXVsdGlwYXRoICptcHAsIHN0cnVjdCB2ZWN0b3JzICp2ZWNzLCBpbnQgcmVmcmVzaCk8YnI+DQrC
oH08YnI+DQo8YnI+DQrCoC8qPGJyPg0KLSAqIFJldHVybnMgJiMzOTsxJiMzOTsgaWYgdGhlIHBh
dGggaGFzIGJlZW4gY2hlY2tlZCwgJiMzOTswJiMzOTsgb3RoZXJ3aXNlPGJyPg0KKyAqIFJldHVy
bnMgJiMzOTsxJiMzOTsgaWYgdGhlIHBhdGggaGFzIGJlZW4gY2hlY2tlZCwgJiMzOTstMSYjMzk7
IGlmIGl0IHdhcyBibGFja2xpc3RlZDxicj4NCisgKiBhbmQgJiMzOTswJiMzOTsgb3RoZXJ3aXNl
PGJyPg0KwqAgKi88YnI+DQrCoGludDxicj4NCsKgY2hlY2tfcGF0aCAoc3RydWN0IHZlY3RvcnMg
KiB2ZWNzLCBzdHJ1Y3QgcGF0aCAqIHBwLCBpbnQgdGlja3MpPGJyPg0KQEAgLTE0NTIsNiArMTQ1
Myw3IEBAIGNoZWNrX3BhdGggKHN0cnVjdCB2ZWN0b3JzICogdmVjcywgc3RydWN0IHBhdGggKiBw
cCwgaW50IHRpY2tzKTxicj4NCsKgIMKgIMKgIMKgIGludCBvbGRjaGtyc3RhdGUgPSBwcC0mZ3Q7
Y2hrcnN0YXRlOzxicj4NCsKgIMKgIMKgIMKgIGludCByZXRyaWdnZXJfdHJpZXMsIGNoZWNraW50
Ozxicj4NCsKgIMKgIMKgIMKgIHN0cnVjdCBjb25maWcgKmNvbmY7PGJyPg0KK8KgIMKgIMKgIMKg
aW50IHJldDs8YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCBpZiAoKHBwLSZndDtpbml0aWFsaXplZCA9
PSBJTklUX09LIHx8PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqBwcC0mZ3Q7aW5pdGlhbGl6ZWQg
PT0gSU5JVF9SRVFVRVNURURfVURFVikgJmFtcDsmYW1wOyAhcHAtJmd0O21wcCk8YnI+DQpAQCAt
MTUxMSwxMCArMTUxMywxNCBAQCBjaGVja19wYXRoIChzdHJ1Y3QgdmVjdG9ycyAqIHZlY3MsIHN0
cnVjdCBwYXRoICogcHAsIGludCB0aWNrcyk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAobmV3c3RhdGUgPT0gUEFUSF9VUCB8fCBuZXdzdGF0ZSA9PSBQQVRIX0dIT1NUKSkgezxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmRsb2coMiwgJnF1b3Q7
JXM6IGFkZCBtaXNzaW5nIHBhdGgmcXVvdDssIHBwLSZndDtkZXYpOzxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmYgPSBnZXRfbXVsdGlwYXRoX2NvbmZpZygpOzxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmIChwYXRoaW5mbyhwcCwg
Y29uZiwgRElfQUxMKSA9PSAwKSB7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgcmV0ID0gcGF0aGluZm8ocHAsIGNvbmYsIERJX0FMTCB8IERJX0JMQUNLTElTVCk7PGJy
Pg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKHJldCA9PSBQQVRISU5G
T19PSykgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIGV2X2FkZF9wYXRoKHBwLCB2ZWNzKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBwcC0mZ3Q7dGljayA9IDE7PGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfTxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoH0gZWxzZSBpZiAocmV0ID09IFBBVEhJTkZPX1NLSVBQRUQpIHs8YnI+DQorwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBwdXRfbXVsdGlwYXRo
X2NvbmZpZyhjb25mKTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqByZXR1cm4gLTE7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgfTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHB1dF9tdWx0
aXBhdGhfY29uZmlnKGNvbmYpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIH08YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZXR1cm4gMDs8YnI+DQpAQCAtMTc3OSw3ICsxNzg1LDEz
IEBAIGNoZWNrZXJsb29wICh2b2lkICphcCk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCBsb2NrKHZlY3MtJmd0O2xvY2spOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIHB0aHJlYWRfdGVzdGNhbmNlbCgpOzxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIHZlY3Rvcl9mb3JlYWNoX3Nsb3QgKHZlY3MtJmd0O3BhdGh2
ZWMsIHBwLCBpKSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgbnVtX3BhdGhzICs9IGNoZWNrX3BhdGgodmVjcywgcHAsIHRpY2tzKTs8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByYyA9IGNoZWNr
X3BhdGgodmVjcywgcHAsIHRpY2tzKTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAocmMgJmx0OyAwKSB7PGJyPg0KK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgdmVjdG9yX2RlbF9z
bG90KHZlY3MtJmd0O3BhdGh2ZWMsIGkpOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGZyZWVfcGF0aChwcCk7PGJyPg0KK8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
aS0tOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oH0gZWxzZTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqBudW1fcGF0aHMgKz0gcmM7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgfTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIGxvY2tfY2xlYW51cF9wb3AodmVjcy0mZ3Q7bG9jayk7PGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgfTxicj4NCjxzcGFuIGNsYXNzPSJIT0VuWmIiPjxmb250IGNvbG9yPSIjODg4ODg4
Ij4tLTxicj4NCjEuOC4zLjE8YnI+DQo8YnI+DQo8L2ZvbnQ+PC9zcGFuPjwvYmxvY2txdW90ZT48
L2Rpdj48YnI+PC9kaXY+DQo=
--001a1140126006eac205371aa79c--


--===============3058440047636883375==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3058440047636883375==--
