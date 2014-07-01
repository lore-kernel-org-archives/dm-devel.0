From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 02/12] Return the correct size buffer in
	set_value()
Date: Tue, 1 Jul 2014 20:47:36 +0200
Message-ID: <CABr-GneYGTVazbxYZTQSZ==fUeJTiXYQYqk=MraetTFuTVeG6g@mail.gmail.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-3-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3146610262231723801=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-3-git-send-email-bmarzins@redhat.com>
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

--===============3146610262231723801==
Content-Type: multipart/alternative; boundary=001a11c1f61e9ec1d704fd26357c

--001a11c1f61e9ec1d704fd26357c
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.


On Mon, Jun 30, 2014 at 7:13 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> When multipath was mallocing the buffer in set_value, it was using
> sizeof(char *), instead of sizeof(char), so it was allocating a buffer
> big enough for an array of pointers instead of characters.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/parser.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/libmultipath/parser.c b/libmultipath/parser.c
> index 526c45b..0d4c870 100644
> --- a/libmultipath/parser.c
> +++ b/libmultipath/parser.c
> @@ -408,11 +408,11 @@ set_value(vector strvec)
>                         len += strlen(str);
>                         if (!alloc)
>                                 alloc =
> -                                   (char *) MALLOC(sizeof (char *) *
> +                                   (char *) MALLOC(sizeof (char) *
>                                                     (len + 1));
>                         else {
>                                 alloc =
> -                                   REALLOC(alloc, sizeof (char *) * (len
> + 1));
> +                                   REALLOC(alloc, sizeof (char) * (len +
> 1));
>                                 tmp = VECTOR_SLOT(strvec, i-1);
>                                 if (alloc && *str != '"' && *tmp != '"')
>                                         strncat(alloc, " ", 1);
> @@ -422,7 +422,7 @@ set_value(vector strvec)
>                                 strncat(alloc, str, strlen(str));
>                 }
>         } else {
> -               alloc = MALLOC(sizeof (char *) * (size + 1));
> +               alloc = MALLOC(sizeof (char) * (size + 1));
>                 if (alloc)
>                         memcpy(alloc, str, size);
>         }
> --
> 1.8.3.1
>
>

--001a11c1f61e9ec1d704fd26357c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdj5BcHBsaWVkLjxicj48L2Rpdj5UaGFua3MuPGJyPjwvZGl2Pjxk
aXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48YnI+PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj5P
biBNb24sIEp1biAzMCwgMjAxNCBhdCA3OjEzIEFNLCBCZW5qYW1pbiBNYXJ6aW5za2kgPHNwYW4g
ZGlyPSJsdHIiPiZsdDs8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVkaGF0LmNvbSIgdGFyZ2V0
PSJfYmxhbmsiPmJtYXJ6aW5zQHJlZGhhdC5jb208L2E+Jmd0Ozwvc3Bhbj4gd3JvdGU6PGJyPg0K
PGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7
Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI+V2hlbiBtdWx0aXBh
dGggd2FzIG1hbGxvY2luZyB0aGUgYnVmZmVyIGluIHNldF92YWx1ZSwgaXQgd2FzIHVzaW5nPGJy
Pg0Kc2l6ZW9mKGNoYXIgKiksIGluc3RlYWQgb2Ygc2l6ZW9mKGNoYXIpLCBzbyBpdCB3YXMgYWxs
b2NhdGluZyBhIGJ1ZmZlcjxicj4NCmJpZyBlbm91Z2ggZm9yIGFuIGFycmF5IG9mIHBvaW50ZXJz
IGluc3RlYWQgb2YgY2hhcmFjdGVycy48YnI+DQo8YnI+DQpTaWduZWQtb2ZmLWJ5OiBCZW5qYW1p
biBNYXJ6aW5za2kgJmx0OzxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFy
emluc0ByZWRoYXQuY29tPC9hPiZndDs8YnI+DQotLS08YnI+DQrCoGxpYm11bHRpcGF0aC9wYXJz
ZXIuYyB8IDYgKysrLS0tPGJyPg0KwqAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKTxicj4NCjxicj4NCmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvcGFyc2Vy
LmMgYi9saWJtdWx0aXBhdGgvcGFyc2VyLmM8YnI+DQppbmRleCA1MjZjNDViLi4wZDRjODcwIDEw
MDY0NDxicj4NCi0tLSBhL2xpYm11bHRpcGF0aC9wYXJzZXIuYzxicj4NCisrKyBiL2xpYm11bHRp
cGF0aC9wYXJzZXIuYzxicj4NCkBAIC00MDgsMTEgKzQwOCwxMSBAQCBzZXRfdmFsdWUodmVjdG9y
IHN0cnZlYyk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBsZW4gKz0g
c3RybGVuKHN0cik7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYg
KCFhbGxvYyk8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBhbGxvYyA9PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAoY2hhciAqKSBNQUxMT0Moc2l6ZW9mIChjaGFyICopICo8YnI+DQorIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIChjaGFyICop
IE1BTExPQyhzaXplb2YgKGNoYXIpICo8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAobGVuICsg
MSkpOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGVsc2Ugezxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGFsbG9jID08
YnI+DQotIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IFJFQUxMT0MoYWxsb2MsIHNpemVvZiAoY2hhciAqKSAqIChsZW4gKyAxKSk7PGJyPg0KKyDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBSRUFMTE9DKGFs
bG9jLCBzaXplb2YgKGNoYXIpICogKGxlbiArIDEpKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB0bXAgPSBWRUNUT1JfU0xPVChzdHJ2ZWMsIGkt
MSk7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
aWYgKGFsbG9jICZhbXA7JmFtcDsgKnN0ciAhPSAmIzM5OyZxdW90OyYjMzk7ICZhbXA7JmFtcDsg
KnRtcCAhPSAmIzM5OyZxdW90OyYjMzk7KTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN0cm5jYXQoYWxsb2MsICZxdW90OyAm
cXVvdDssIDEpOzxicj4NCkBAIC00MjIsNyArNDIyLDcgQEAgc2V0X3ZhbHVlKHZlY3RvciBzdHJ2
ZWMpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
c3RybmNhdChhbGxvYywgc3RyLCBzdHJsZW4oc3RyKSk7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgfTxicj4NCsKgIMKgIMKgIMKgIH0gZWxzZSB7PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBhbGxvYyA9IE1BTExPQyhzaXplb2YgKGNoYXIgKikgKiAoc2l6ZSArIDEpKTs8YnI+DQor
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGFsbG9jID0gTUFMTE9DKHNpemVvZiAoY2hhcikgKiAoc2l6
ZSArIDEpKTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoYWxsb2MpPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgbWVtY3B5KGFsbG9jLCBzdHIsIHNpemUp
Ozxicj4NCsKgIMKgIMKgIMKgIH08YnI+DQo8c3BhbiBjbGFzcz0iSE9FblpiIj48Zm9udCBjb2xv
cj0iIzg4ODg4OCI+LS08YnI+DQoxLjguMy4xPGJyPg0KPGJyPg0KPC9mb250Pjwvc3Bhbj48L2Js
b2NrcXVvdGU+PC9kaXY+PGJyPjwvZGl2Pg0K
--001a11c1f61e9ec1d704fd26357c--


--===============3146610262231723801==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3146610262231723801==--
