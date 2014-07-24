From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 10/12] Improve multipath.conf syntax checking
Date: Thu, 24 Jul 2014 10:47:52 +0200
Message-ID: <CABr-Gnc=W7QooS-cLiQnau4JRu1TigT1TWCGM-3Fbm26kdySDA@mail.gmail.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-11-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0710441810390291796=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-11-git-send-email-bmarzins@redhat.com>
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

--===============0710441810390291796==
Content-Type: multipart/alternative; boundary=089e0149d2c027bc3004feec83a1

--089e0149d2c027bc3004feec83a1
Content-Type: text/plain; charset=UTF-8

Applied,
Thanks.


On Mon, Jun 30, 2014 at 7:14 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> multipath's parser for multipath.conf is neither very verbose or forgiving
> about errors.  This patch improves both.  multipath will now warn about
> obviously missing quotes and curly braces, but will still do the right
> thing.
> It will also give more verbose error messages including a line number when
> it can't parse a line.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/parser.c | 152
> +++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 125 insertions(+), 27 deletions(-)
>
> diff --git a/libmultipath/parser.c b/libmultipath/parser.c
> index 0d4c870..accff62 100644
> --- a/libmultipath/parser.c
> +++ b/libmultipath/parser.c
> @@ -395,36 +395,57 @@ set_value(vector strvec)
>         char *alloc = NULL;
>         char *tmp;
>
> -       if (!str)
> +       if (!str) {
> +               condlog(0, "option '%s' missing value",
> +                       (char *)VECTOR_SLOT(strvec, 0));
>                 return NULL;
> -
> +       }
>         size = strlen(str);
> -       if (size == 0)
> +       if (size == 0) {
> +               condlog(0, "option '%s' has empty value",
> +                       (char *)VECTOR_SLOT(strvec, 0));
>                 return NULL;
> -
> -       if (*str == '"') {
> -               for (i = 2; i < VECTOR_SIZE(strvec); i++) {
> -                       str = VECTOR_SLOT(strvec, i);
> -                       len += strlen(str);
> -                       if (!alloc)
> -                               alloc =
> -                                   (char *) MALLOC(sizeof (char) *
> -                                                   (len + 1));
> -                       else {
> -                               alloc =
> -                                   REALLOC(alloc, sizeof (char) * (len +
> 1));
> -                               tmp = VECTOR_SLOT(strvec, i-1);
> -                               if (alloc && *str != '"' && *tmp != '"')
> -                                       strncat(alloc, " ", 1);
> -                       }
> -
> -                       if (alloc && i != VECTOR_SIZE(strvec)-1)
> -                               strncat(alloc, str, strlen(str));
> -               }
> -       } else {
> +       }
> +       if (*str != '"') {
>                 alloc = MALLOC(sizeof (char) * (size + 1));
>                 if (alloc)
>                         memcpy(alloc, str, size);
> +               else
> +                       condlog(0, "can't allocate memeory for option
> '%s'",
> +                               (char *)VECTOR_SLOT(strvec, 0));
> +               return alloc;
> +       }
> +       /* Even empty quotes counts as a value (An empty string) */
> +       alloc = (char *) MALLOC(sizeof (char));
> +       if (!alloc) {
> +               condlog(0, "can't allocate memeory for option '%s'",
> +                       (char *)VECTOR_SLOT(strvec, 0));
> +               return NULL;
> +       }
> +       for (i = 2; i < VECTOR_SIZE(strvec); i++) {
> +               str = VECTOR_SLOT(strvec, i);
> +               if (!str) {
> +                       free(alloc);
> +                       condlog(0, "parse error for option '%s'",
> +                               (char *)VECTOR_SLOT(strvec, 0));
> +                       return NULL;
> +               }
> +               if (*str == '"')
> +                       break;
> +               tmp = alloc;
> +               /* The first +1 is for the NULL byte. The rest are for the
> +                * spaces between words */
> +               len += strlen(str) + 1;
> +               alloc = REALLOC(alloc, sizeof (char) * len);
> +               if (!alloc) {
> +                       FREE(tmp);
> +                       condlog(0, "can't allocate memeory for option
> '%s'",
> +                               (char *)VECTOR_SLOT(strvec, 0));
> +                       return NULL;
> +               }
> +               if (*alloc != '\0')
> +                       strncat(alloc, " ", 1);
> +               strncat(alloc, str, strlen(str));
>         }
>         return alloc;
>  }
> @@ -465,6 +486,74 @@ void free_uniques(vector uniques)
>  }
>
>  int
> +is_sublevel_keyword(char *str)
> +{
> +       return (strcmp(str, "defaults") == 0 || strcmp(str, "blacklist")
> == 0 ||
> +               strcmp(str, "blacklist_exceptions") == 0 ||
> +               strcmp(str, "devices") == 0 || strcmp(str, "devices") == 0
> ||
> +               strcmp(str, "device") == 0 || strcmp(str, "multipaths") ==
> 0 ||
> +               strcmp(str, "multipath") == 0);
> +}
> +
> +int
> +validate_config_strvec(vector strvec)
> +{
> +       char *str;
> +       int i;
> +
> +       str = VECTOR_SLOT(strvec, 0);
> +       if (str == NULL) {
> +               condlog(0, "can't parse option on line %d of config file",
> +                       line_nr);
> +       return -1;
> +       }
> +       if (*str == '}') {
> +               if (VECTOR_SIZE(strvec) > 1)
> +                       condlog(0, "ignoring extra data starting with '%s'
> on line %d of config file", (char *)VECTOR_SLOT(strvec, 1), line_nr);
> +               return 0;
> +       }
> +       if (*str == '{') {
> +               condlog(0, "invalid keyword '%s' on line %d of config
> file", str, line_nr);
> +               return -1;
> +       }
> +       if (is_sublevel_keyword(str)) {
> +               str = VECTOR_SLOT(strvec, 1);
> +               if (str == NULL)
> +                       condlog(0, "missing '{' on line %d of config
> file", line_nr);
> +               else if (*str != '{')
> +                       condlog(0, "expecting '{' on line %d of config
> file. found '%s'", line_nr, str);
> +               else if (VECTOR_SIZE(strvec) > 2)
> +                       condlog(0, "ignoring extra data starting with '%s'
> on line %d of config file", (char *)VECTOR_SLOT(strvec, 2), line_nr);
> +               return 0;
> +       }
> +       str = VECTOR_SLOT(strvec, 1);
> +       if (str == NULL) {
> +               condlog(0, "missing value for option '%s' on line %d of
> config file", (char *)VECTOR_SLOT(strvec, 0), line_nr);
> +               return -1;
> +       }
> +       if (*str != '"') {
> +               if (VECTOR_SIZE(strvec) > 2)
> +                       condlog(0, "ignoring extra data starting with '%s'
> on line %d of config file", (char *)VECTOR_SLOT(strvec, 2), line_nr);
> +               return 0;
> +       }
> +       for (i = 2; i < VECTOR_SIZE(strvec); i++) {
> +               str = VECTOR_SLOT(strvec, i);
> +               if (str == NULL) {
> +                       condlog(0, "can't parse value on line %d of config
> file", line_nr);
> +                       return -1;
> +               }
> +               if (*str == '"') {
> +                       if (VECTOR_SIZE(strvec) > i + 1)
> +                               condlog(0, "ignoring extra data starting
> with '%s' on line %d of config file", (char *)VECTOR_SLOT(strvec, (i + 1)),
> line_nr);
> +                       return 0;
> +               }
> +       }
> +       condlog(0, "missing closing quotes on line %d of config file",
> +               line_nr);
> +       return 0;
> +}
> +
> +int
>  process_stream(vector keywords)
>  {
>         int i;
> @@ -494,11 +583,20 @@ process_stream(vector keywords)
>                 if (!strvec)
>                         continue;
>
> +               if (validate_config_strvec(strvec) != 0) {
> +                       free_strvec(strvec);
> +                       continue;
> +               }
> +
>                 str = VECTOR_SLOT(strvec, 0);
>
> -               if (!strcmp(str, EOB) && kw_level > 0) {
> -                       free_strvec(strvec);
> -                       break;
> +               if (!strcmp(str, EOB)) {
> +                       if (kw_level > 0) {
> +                               free_strvec(strvec);
> +                               break;
> +                       }
> +                       condlog(0, "unmatched '%s' at line %d of config
> file",
> +                               EOB, line_nr);
>                 }
>
>                 for (i = 0; i < VECTOR_SIZE(keywords); i++) {
> --
> 1.8.3.1
>
>

--089e0149d2c027bc3004feec83a1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+QXBwbGllZCw8ZGl2PlRoYW5rcy48L2Rpdj48L2Rpdj48ZGl2IGNsYXNz
PSJnbWFpbF9leHRyYSI+PGJyPjxicj48ZGl2IGNsYXNzPSJnbWFpbF9xdW90ZSI+T24gTW9uLCBK
dW4gMzAsIDIwMTQgYXQgNzoxNCBBTSwgQmVuamFtaW4gTWFyemluc2tpIDxzcGFuIGRpcj0ibHRy
Ij4mbHQ7PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iIHRhcmdldD0iX2JsYW5r
Ij5ibWFyemluc0ByZWRoYXQuY29tPC9hPiZndDs8L3NwYW4+IHdyb3RlOjxicj4NCjxibG9ja3F1
b3RlIGNsYXNzPSJnbWFpbF9xdW90ZSIgc3R5bGU9Im1hcmdpbjowIDAgMCAuOGV4O2JvcmRlci1s
ZWZ0OjFweCAjY2NjIHNvbGlkO3BhZGRpbmctbGVmdDoxZXgiPm11bHRpcGF0aCYjMzk7cyBwYXJz
ZXIgZm9yIG11bHRpcGF0aC5jb25mIGlzIG5laXRoZXIgdmVyeSB2ZXJib3NlIG9yIGZvcmdpdmlu
Zzxicj4NCmFib3V0IGVycm9ycy4gwqBUaGlzIHBhdGNoIGltcHJvdmVzIGJvdGguIMKgbXVsdGlw
YXRoIHdpbGwgbm93IHdhcm4gYWJvdXQ8YnI+DQpvYnZpb3VzbHkgbWlzc2luZyBxdW90ZXMgYW5k
IGN1cmx5IGJyYWNlcywgYnV0IHdpbGwgc3RpbGwgZG8gdGhlIHJpZ2h0IHRoaW5nLjxicj4NCkl0
IHdpbGwgYWxzbyBnaXZlIG1vcmUgdmVyYm9zZSBlcnJvciBtZXNzYWdlcyBpbmNsdWRpbmcgYSBs
aW5lIG51bWJlciB3aGVuPGJyPg0KaXQgY2FuJiMzOTt0IHBhcnNlIGEgbGluZS48YnI+DQo8YnI+
DQpTaWduZWQtb2ZmLWJ5OiBCZW5qYW1pbiBNYXJ6aW5za2kgJmx0OzxhIGhyZWY9Im1haWx0bzpi
bWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPiZndDs8YnI+DQotLS08
YnI+DQrCoGxpYm11bHRpcGF0aC9wYXJzZXIuYyB8IDE1MiArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLTxicj4NCsKgMSBmaWxlIGNoYW5nZWQsIDEyNSBp
bnNlcnRpb25zKCspLCAyNyBkZWxldGlvbnMoLSk8YnI+DQo8YnI+DQpkaWZmIC0tZ2l0IGEvbGli
bXVsdGlwYXRoL3BhcnNlci5jIGIvbGlibXVsdGlwYXRoL3BhcnNlci5jPGJyPg0KaW5kZXggMGQ0
Yzg3MC4uYWNjZmY2MiAxMDA2NDQ8YnI+DQotLS0gYS9saWJtdWx0aXBhdGgvcGFyc2VyLmM8YnI+
DQorKysgYi9saWJtdWx0aXBhdGgvcGFyc2VyLmM8YnI+DQpAQCAtMzk1LDM2ICszOTUsNTcgQEAg
c2V0X3ZhbHVlKHZlY3RvciBzdHJ2ZWMpPGJyPg0KwqAgwqAgwqAgwqAgY2hhciAqYWxsb2MgPSBO
VUxMOzxicj4NCsKgIMKgIMKgIMKgIGNoYXIgKnRtcDs8YnI+DQo8YnI+DQotIMKgIMKgIMKgIGlm
ICghc3RyKTxicj4NCisgwqAgwqAgwqAgaWYgKCFzdHIpIHs8YnI+DQorIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIGNvbmRsb2coMCwgJnF1b3Q7b3B0aW9uICYjMzk7JXMmIzM5OyBtaXNzaW5nIHZhbHVl
JnF1b3Q7LDxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgKGNoYXIgKilW
RUNUT1JfU0xPVChzdHJ2ZWMsIDApKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZXR1
cm4gTlVMTDs8YnI+DQotPGJyPg0KKyDCoCDCoCDCoCB9PGJyPg0KwqAgwqAgwqAgwqAgc2l6ZSA9
IHN0cmxlbihzdHIpOzxicj4NCi0gwqAgwqAgwqAgaWYgKHNpemUgPT0gMCk8YnI+DQorIMKgIMKg
IMKgIGlmIChzaXplID09IDApIHs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmRsb2co
MCwgJnF1b3Q7b3B0aW9uICYjMzk7JXMmIzM5OyBoYXMgZW1wdHkgdmFsdWUmcXVvdDssPGJyPg0K
KyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAoY2hhciAqKVZFQ1RPUl9TTE9UKHN0
cnZlYywgMCkpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJldHVybiBOVUxMOzxicj4N
Ci08YnI+DQotIMKgIMKgIMKgIGlmICgqc3RyID09ICYjMzk7JnF1b3Q7JiMzOTspIHs8YnI+DQot
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGZvciAoaSA9IDI7IGkgJmx0OyBWRUNUT1JfU0laRShzdHJ2
ZWMpOyBpKyspIHs8YnI+DQotIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN0ciA9
IFZFQ1RPUl9TTE9UKHN0cnZlYywgaSk7PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBsZW4gKz0gc3RybGVuKHN0cik7PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCBpZiAoIWFsbG9jKTxicj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgYWxsb2MgPTxicj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgKGNoYXIgKikgTUFMTE9DKHNpemVvZiAoY2hhcikg
Kjxicj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgKGxlbiArIDEpKTs8YnI+DQotIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGVsc2Ugezxicj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYWxsb2MgPTxicj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgUkVBTExPQyhhbGxvYywgc2l6ZW9mIChj
aGFyKSAqIChsZW4gKyAxKSk7PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCB0bXAgPSBWRUNUT1JfU0xPVChzdHJ2ZWMsIGktMSk7PGJyPg0KLSDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoYWxsb2MgJmFtcDsm
YW1wOyAqc3RyICE9ICYjMzk7JnF1b3Q7JiMzOTsgJmFtcDsmYW1wOyAqdG1wICE9ICYjMzk7JnF1
b3Q7JiMzOTspPGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCBzdHJuY2F0KGFsbG9jLCAmcXVvdDsgJnF1b3Q7LCAxKTs8YnI+DQot
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIH08YnI+DQotPGJyPg0KLSDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoYWxsb2MgJmFtcDsmYW1wOyBpICE9IFZFQ1RP
Ul9TSVpFKHN0cnZlYyktMSk8YnI+DQotIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIHN0cm5jYXQoYWxsb2MsIHN0ciwgc3RybGVuKHN0cikpOzxicj4NCi0gwqAg
wqAgwqAgwqAgwqAgwqAgwqAgfTxicj4NCi0gwqAgwqAgwqAgfSBlbHNlIHs8YnI+DQorIMKgIMKg
IMKgIH08YnI+DQorIMKgIMKgIMKgIGlmICgqc3RyICE9ICYjMzk7JnF1b3Q7JiMzOTspIHs8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBhbGxvYyA9IE1BTExPQyhzaXplb2YgKGNoYXIpICog
KHNpemUgKyAxKSk7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKGFsbG9jKTxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIG1lbWNweShhbGxvYywgc3RyLCBz
aXplKTs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGVsc2U8YnI+DQorIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmRsb2coMCwgJnF1b3Q7Y2FuJiMzOTt0IGFsbG9jYXRl
IG1lbWVvcnkgZm9yIG9wdGlvbiAmIzM5OyVzJiMzOTsmcXVvdDssPGJyPg0KKyDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAoY2hhciAqKVZFQ1RPUl9TTE9UKHN0
cnZlYywgMCkpOzxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmV0dXJuIGFsbG9jOzxicj4N
CisgwqAgwqAgwqAgfTxicj4NCisgwqAgwqAgwqAgLyogRXZlbiBlbXB0eSBxdW90ZXMgY291bnRz
IGFzIGEgdmFsdWUgKEFuIGVtcHR5IHN0cmluZykgKi88YnI+DQorIMKgIMKgIMKgIGFsbG9jID0g
KGNoYXIgKikgTUFMTE9DKHNpemVvZiAoY2hhcikpOzxicj4NCisgwqAgwqAgwqAgaWYgKCFhbGxv
Yykgezxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY29uZGxvZygwLCAmcXVvdDtjYW4mIzM5
O3QgYWxsb2NhdGUgbWVtZW9yeSBmb3Igb3B0aW9uICYjMzk7JXMmIzM5OyZxdW90Oyw8YnI+DQor
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIChjaGFyICopVkVDVE9SX1NMT1Qoc3Ry
dmVjLCAwKSk7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZXR1cm4gTlVMTDs8YnI+DQor
IMKgIMKgIMKgIH08YnI+DQorIMKgIMKgIMKgIGZvciAoaSA9IDI7IGkgJmx0OyBWRUNUT1JfU0la
RShzdHJ2ZWMpOyBpKyspIHs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN0ciA9IFZFQ1RP
Ul9TTE9UKHN0cnZlYywgaSk7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoIXN0cikg
ezxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZnJlZShhbGxvYyk7PGJy
Pg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjb25kbG9nKDAsICZxdW90O3Bh
cnNlIGVycm9yIGZvciBvcHRpb24gJiMzOTslcyYjMzk7JnF1b3Q7LDxicj4NCisgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgKGNoYXIgKilWRUNUT1JfU0xPVChz
dHJ2ZWMsIDApKTs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJldHVy
biBOVUxMOzxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfTxicj4NCisgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgaWYgKCpzdHIgPT0gJiMzOTsmcXVvdDsmIzM5Oyk8YnI+DQorIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJyZWFrOzxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
dG1wID0gYWxsb2M7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBUaGUgZmlyc3QgKzEg
aXMgZm9yIHRoZSBOVUxMIGJ5dGUuIFRoZSByZXN0IGFyZSBmb3IgdGhlPGJyPg0KKyDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCogc3BhY2VzIGJldHdlZW4gd29yZHMgKi88YnI+DQorIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIGxlbiArPSBzdHJsZW4oc3RyKSArIDE7PGJyPg0KKyDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBhbGxvYyA9IFJFQUxMT0MoYWxsb2MsIHNpemVvZiAoY2hhcikgKiBsZW4pOzxicj4N
CisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKCFhbGxvYykgezxicj4NCisgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgRlJFRSh0bXApOzxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgY29uZGxvZygwLCAmcXVvdDtjYW4mIzM5O3QgYWxsb2NhdGUgbWVtZW9y
eSBmb3Igb3B0aW9uICYjMzk7JXMmIzM5OyZxdW90Oyw8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIChjaGFyICopVkVDVE9SX1NMT1Qoc3RydmVjLCAw
KSk7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZXR1cm4gTlVMTDs8
YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIH08YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IGlmICgqYWxsb2MgIT0gJiMzOTtcMCYjMzk7KTxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgc3RybmNhdChhbGxvYywgJnF1b3Q7ICZxdW90OywgMSk7PGJyPg0KKyDCoCDC
oCDCoCDCoCDCoCDCoCDCoCBzdHJuY2F0KGFsbG9jLCBzdHIsIHN0cmxlbihzdHIpKTs8YnI+DQrC
oCDCoCDCoCDCoCB9PGJyPg0KwqAgwqAgwqAgwqAgcmV0dXJuIGFsbG9jOzxicj4NCsKgfTxicj4N
CkBAIC00NjUsNiArNDg2LDc0IEBAIHZvaWQgZnJlZV91bmlxdWVzKHZlY3RvciB1bmlxdWVzKTxi
cj4NCsKgfTxicj4NCjxicj4NCsKgaW50PGJyPg0KK2lzX3N1YmxldmVsX2tleXdvcmQoY2hhciAq
c3RyKTxicj4NCit7PGJyPg0KKyDCoCDCoCDCoCByZXR1cm4gKHN0cmNtcChzdHIsICZxdW90O2Rl
ZmF1bHRzJnF1b3Q7KSA9PSAwIHx8IHN0cmNtcChzdHIsICZxdW90O2JsYWNrbGlzdCZxdW90Oykg
PT0gMCB8fDxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgc3RyY21wKHN0ciwgJnF1b3Q7Ymxh
Y2tsaXN0X2V4Y2VwdGlvbnMmcXVvdDspID09IDAgfHw8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIHN0cmNtcChzdHIsICZxdW90O2RldmljZXMmcXVvdDspID09IDAgfHwgc3RyY21wKHN0ciwg
JnF1b3Q7ZGV2aWNlcyZxdW90OykgPT0gMCB8fDxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
c3RyY21wKHN0ciwgJnF1b3Q7ZGV2aWNlJnF1b3Q7KSA9PSAwIHx8IHN0cmNtcChzdHIsICZxdW90
O211bHRpcGF0aHMmcXVvdDspID09IDAgfHw8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN0
cmNtcChzdHIsICZxdW90O211bHRpcGF0aCZxdW90OykgPT0gMCk7PGJyPg0KK308YnI+DQorPGJy
Pg0KK2ludDxicj4NCit2YWxpZGF0ZV9jb25maWdfc3RydmVjKHZlY3RvciBzdHJ2ZWMpPGJyPg0K
K3s8YnI+DQorIMKgIMKgIMKgIGNoYXIgKnN0cjs8YnI+DQorIMKgIMKgIMKgIGludCBpOzxicj4N
Cis8YnI+DQorIMKgIMKgIMKgIHN0ciA9IFZFQ1RPUl9TTE9UKHN0cnZlYywgMCk7PGJyPg0KKyDC
oCDCoCDCoCBpZiAoc3RyID09IE5VTEwpIHs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNv
bmRsb2coMCwgJnF1b3Q7Y2FuJiMzOTt0IHBhcnNlIG9wdGlvbiBvbiBsaW5lICVkIG9mIGNvbmZp
ZyBmaWxlJnF1b3Q7LDxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgbGlu
ZV9ucik7PGJyPg0KKyDCoCDCoCDCoCByZXR1cm4gLTE7PGJyPg0KKyDCoCDCoCDCoCB9PGJyPg0K
KyDCoCDCoCDCoCBpZiAoKnN0ciA9PSAmIzM5O30mIzM5Oykgezxicj4NCisgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgaWYgKFZFQ1RPUl9TSVpFKHN0cnZlYykgJmd0OyAxKTxicj4NCisgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY29uZGxvZygwLCAmcXVvdDtpZ25vcmluZyBleHRyYSBk
YXRhIHN0YXJ0aW5nIHdpdGggJiMzOTslcyYjMzk7IG9uIGxpbmUgJWQgb2YgY29uZmlnIGZpbGUm
cXVvdDssIChjaGFyICopVkVDVE9SX1NMT1Qoc3RydmVjLCAxKSwgbGluZV9ucik7PGJyPg0KKyDC
oCDCoCDCoCDCoCDCoCDCoCDCoCByZXR1cm4gMDs8YnI+DQorIMKgIMKgIMKgIH08YnI+DQorIMKg
IMKgIMKgIGlmICgqc3RyID09ICYjMzk7eyYjMzk7KSB7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBjb25kbG9nKDAsICZxdW90O2ludmFsaWQga2V5d29yZCAmIzM5OyVzJiMzOTsgb24gbGlu
ZSAlZCBvZiBjb25maWcgZmlsZSZxdW90Oywgc3RyLCBsaW5lX25yKTs8YnI+DQorIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIHJldHVybiAtMTs8YnI+DQorIMKgIMKgIMKgIH08YnI+DQorIMKgIMKgIMKg
IGlmIChpc19zdWJsZXZlbF9rZXl3b3JkKHN0cikpIHs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIHN0ciA9IFZFQ1RPUl9TTE9UKHN0cnZlYywgMSk7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBpZiAoc3RyID09IE5VTEwpPGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBjb25kbG9nKDAsICZxdW90O21pc3NpbmcgJiMzOTt7JiMzOTsgb24gbGluZSAlZCBvZiBj
b25maWcgZmlsZSZxdW90OywgbGluZV9ucik7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCBl
bHNlIGlmICgqc3RyICE9ICYjMzk7eyYjMzk7KTxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgY29uZGxvZygwLCAmcXVvdDtleHBlY3RpbmcgJiMzOTt7JiMzOTsgb24gbGlu
ZSAlZCBvZiBjb25maWcgZmlsZS4gZm91bmQgJiMzOTslcyYjMzk7JnF1b3Q7LCBsaW5lX25yLCBz
dHIpOzxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZWxzZSBpZiAoVkVDVE9SX1NJWkUoc3Ry
dmVjKSAmZ3Q7IDIpPGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjb25k
bG9nKDAsICZxdW90O2lnbm9yaW5nIGV4dHJhIGRhdGEgc3RhcnRpbmcgd2l0aCAmIzM5OyVzJiMz
OTsgb24gbGluZSAlZCBvZiBjb25maWcgZmlsZSZxdW90OywgKGNoYXIgKilWRUNUT1JfU0xPVChz
dHJ2ZWMsIDIpLCBsaW5lX25yKTs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJldHVybiAw
Ozxicj4NCisgwqAgwqAgwqAgfTxicj4NCisgwqAgwqAgwqAgc3RyID0gVkVDVE9SX1NMT1Qoc3Ry
dmVjLCAxKTs8YnI+DQorIMKgIMKgIMKgIGlmIChzdHIgPT0gTlVMTCkgezxicj4NCisgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgY29uZGxvZygwLCAmcXVvdDttaXNzaW5nIHZhbHVlIGZvciBvcHRpb24g
JiMzOTslcyYjMzk7IG9uIGxpbmUgJWQgb2YgY29uZmlnIGZpbGUmcXVvdDssIChjaGFyICopVkVD
VE9SX1NMT1Qoc3RydmVjLCAwKSwgbGluZV9ucik7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDC
oCByZXR1cm4gLTE7PGJyPg0KKyDCoCDCoCDCoCB9PGJyPg0KKyDCoCDCoCDCoCBpZiAoKnN0ciAh
PSAmIzM5OyZxdW90OyYjMzk7KSB7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoVkVD
VE9SX1NJWkUoc3RydmVjKSAmZ3Q7IDIpPGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBjb25kbG9nKDAsICZxdW90O2lnbm9yaW5nIGV4dHJhIGRhdGEgc3RhcnRpbmcgd2l0
aCAmIzM5OyVzJiMzOTsgb24gbGluZSAlZCBvZiBjb25maWcgZmlsZSZxdW90OywgKGNoYXIgKilW
RUNUT1JfU0xPVChzdHJ2ZWMsIDIpLCBsaW5lX25yKTs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIHJldHVybiAwOzxicj4NCisgwqAgwqAgwqAgfTxicj4NCisgwqAgwqAgwqAgZm9yIChpID0g
MjsgaSAmbHQ7IFZFQ1RPUl9TSVpFKHN0cnZlYyk7IGkrKykgezxicj4NCisgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgc3RyID0gVkVDVE9SX1NMT1Qoc3RydmVjLCBpKTs8YnI+DQorIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIGlmIChzdHIgPT0gTlVMTCkgezxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgY29uZGxvZygwLCAmcXVvdDtjYW4mIzM5O3QgcGFyc2UgdmFsdWUgb24gbGlu
ZSAlZCBvZiBjb25maWcgZmlsZSZxdW90OywgbGluZV9ucik7PGJyPg0KKyDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCByZXR1cm4gLTE7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDC
oCB9PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoKnN0ciA9PSAmIzM5OyZxdW90OyYj
Mzk7KSB7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoVkVDVE9S
X1NJWkUoc3RydmVjKSAmZ3Q7IGkgKyAxKTxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgY29uZGxvZygwLCAmcXVvdDtpZ25vcmluZyBleHRyYSBkYXRh
IHN0YXJ0aW5nIHdpdGggJiMzOTslcyYjMzk7IG9uIGxpbmUgJWQgb2YgY29uZmlnIGZpbGUmcXVv
dDssIChjaGFyICopVkVDVE9SX1NMT1Qoc3RydmVjLCAoaSArIDEpKSwgbGluZV9ucik7PGJyPg0K
KyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZXR1cm4gMDs8YnI+DQorIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIH08YnI+DQorIMKgIMKgIMKgIH08YnI+DQorIMKgIMKgIMKgIGNvbmRs
b2coMCwgJnF1b3Q7bWlzc2luZyBjbG9zaW5nIHF1b3RlcyBvbiBsaW5lICVkIG9mIGNvbmZpZyBm
aWxlJnF1b3Q7LDxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgbGluZV9ucik7PGJyPg0KKyDC
oCDCoCDCoCByZXR1cm4gMDs8YnI+DQorfTxicj4NCis8YnI+DQoraW50PGJyPg0KwqBwcm9jZXNz
X3N0cmVhbSh2ZWN0b3Iga2V5d29yZHMpPGJyPg0KwqB7PGJyPg0KwqAgwqAgwqAgwqAgaW50IGk7
PGJyPg0KQEAgLTQ5NCwxMSArNTgzLDIwIEBAIHByb2Nlc3Nfc3RyZWFtKHZlY3RvciBrZXl3b3Jk
cyk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoIXN0cnZlYyk8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjb250aW51ZTs8YnI+DQo8YnI+DQorIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIGlmICh2YWxpZGF0ZV9jb25maWdfc3RydmVjKHN0cnZlYykgIT0gMCkg
ezxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZnJlZV9zdHJ2ZWMoc3Ry
dmVjKTs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbnRpbnVlOzxi
cj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfTxicj4NCis8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBzdHIgPSBWRUNUT1JfU0xPVChzdHJ2ZWMsIDApOzxicj4NCjxicj4NCi0gwqAgwqAg
wqAgwqAgwqAgwqAgwqAgaWYgKCFzdHJjbXAoc3RyLCBFT0IpICZhbXA7JmFtcDsga3dfbGV2ZWwg
Jmd0OyAwKSB7PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBmcmVlX3N0
cnZlYyhzdHJ2ZWMpOzxicj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYnJl
YWs7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoIXN0cmNtcChzdHIsIEVPQikpIHs8
YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmIChrd19sZXZlbCAmZ3Q7
IDApIHs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IGZyZWVfc3RydmVjKHN0cnZlYyk7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCBicmVhazs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIH08YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmRsb2co
MCwgJnF1b3Q7dW5tYXRjaGVkICYjMzk7JXMmIzM5OyBhdCBsaW5lICVkIG9mIGNvbmZpZyBmaWxl
JnF1b3Q7LDxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgRU9CLCBsaW5lX25yKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB9PGJyPg0KPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZm9yIChpID0gMDsgaSAmbHQ7IFZFQ1RPUl9TSVpF
KGtleXdvcmRzKTsgaSsrKSB7PGJyPg0KPHNwYW4gY2xhc3M9IkhPRW5aYiI+PGZvbnQgY29sb3I9
IiM4ODg4ODgiPi0tPGJyPg0KMS44LjMuMTxicj4NCjxicj4NCjwvZm9udD48L3NwYW4+PC9ibG9j
a3F1b3RlPjwvZGl2Pjxicj48L2Rpdj4NCg==
--089e0149d2c027bc3004feec83a1--


--===============0710441810390291796==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0710441810390291796==--
