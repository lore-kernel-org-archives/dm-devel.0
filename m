From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: replace hidden tabs by
	spaces in .vendor
Date: Wed, 21 Jun 2017 12:29:45 +0200
Message-ID: <CABr-GncwH6eB0uihXhKC3eoZEnP9fcDMeJrWfLHm7UaKm6FfgQ@mail.gmail.com>
References: <20170520132952.2732-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8397536850845685739=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170520132952.2732-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8397536850845685739==
Content-Type: multipart/alternative; boundary="94eb2c04fa14d473bc055275d860"

--94eb2c04fa14d473bc055275d860
Content-Type: text/plain; charset="UTF-8"

Merged,
Thanks.

On Sat, May 20, 2017 at 3:29 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 54309ef..59a6055 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -827,7 +827,7 @@ static struct hwentry default_hw[] = {
>          * Intel
>          */
>         {
> -               .vendor        = "(Intel|INTEL)",
> +               .vendor        = "(Intel|INTEL)",
>                 .product       = "Multi-Flex",
>                 .bl_product    = "VTrak V-LUN",
>                 .hwhandler     = "1 alua",
> @@ -840,7 +840,7 @@ static struct hwentry default_hw[] = {
>          * Linux-IO Target
>          */
>         {
> -               .vendor        = "(LIO-ORG|SUSE)",
> +               .vendor        = "(LIO-ORG|SUSE)",
>                 .product       = "RBD",
>                 .hwhandler     = "1 alua",
>                 .pgpolicy      = GROUP_BY_PRIO,
> @@ -852,7 +852,7 @@ static struct hwentry default_hw[] = {
>          * DataCore
>          */
>         {
> -               .vendor        = "DataCore",
> +               .vendor        = "DataCore",
>                 .product       = "SANmelody",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -861,7 +861,7 @@ static struct hwentry default_hw[] = {
>         },
>         {
>                 /* SANsymphony */
> -               .vendor        = "DataCore",
> +               .vendor        = "DataCore",
>                 .product       = "Virtual Disk",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> @@ -1053,7 +1053,7 @@ static struct hwentry default_hw[] = {
>          * Generic NVMe devices
>          */
>         {
> -               .vendor        = "NVME",
> +               .vendor        = "NVME",
>                 .product       = ".*",
>                 .uid_attribute = "ID_WWN",
>                 .checker_name  = DIRECTIO,
> --
> 2.13.0
>
>

--94eb2c04fa14d473bc055275d860
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+TWVyZ2VkLDxkaXY+VGhhbmtzLjwvZGl2PjwvZGl2PjxkaXYgY2xhc3M9
ImdtYWlsX2V4dHJhIj48YnI+PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIFNhdCwgTWF5IDIw
LCAyMDE3IGF0IDM6MjkgUE0sIFhvc2UgVmF6cXVleiBQZXJleiA8c3BhbiBkaXI9Imx0ciI+Jmx0
OzxhIGhyZWY9Im1haWx0bzp4b3NlLnZhenF1ZXpAZ21haWwuY29tIiB0YXJnZXQ9Il9ibGFuayI+
eG9zZS52YXpxdWV6QGdtYWlsLmNvbTwvYT4mZ3Q7PC9zcGFuPiB3cm90ZTo8YnI+PGJsb2NrcXVv
dGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxl
ZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI+Q2M6IENocmlzdG9waGUgVmFyb3F1
aSAmbHQ7PGEgaHJlZj0ibWFpbHRvOmNocmlzdG9waGUudmFyb3F1aUBvcGVuc3ZjLmNvbSI+Y2hy
aXN0b3BoZS52YXJvcXVpQG9wZW5zdmMuPHdicj5jb208L2E+Jmd0Ozxicj4NCkNjOiBkZXZpY2Ut
bWFwcGVyIGRldmVsb3BtZW50ICZsdDs8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNv
bSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT4mZ3Q7PGJyPg0KU2lnbmVkLW9mZi1ieTogWG9zZSBW
YXpxdWV6IFBlcmV6ICZsdDs8YSBocmVmPSJtYWlsdG86eG9zZS52YXpxdWV6QGdtYWlsLmNvbSI+
eG9zZS52YXpxdWV6QGdtYWlsLmNvbTwvYT4mZ3Q7PGJyPg0KLS0tPGJyPg0KwqBsaWJtdWx0aXBh
dGgvaHd0YWJsZS5jIHwgMTAgKysrKystLS0tLTxicj4NCsKgMSBmaWxlIGNoYW5nZWQsIDUgaW5z
ZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSk8YnI+DQo8YnI+DQpkaWZmIC0tZ2l0IGEvbGlibXVs
dGlwYXRoL2h3dGFibGUuYyBiL2xpYm11bHRpcGF0aC9od3RhYmxlLmM8YnI+DQppbmRleCA1NDMw
OWVmLi41OWE2MDU1IDEwMDY0NDxicj4NCi0tLSBhL2xpYm11bHRpcGF0aC9od3RhYmxlLmM8YnI+
DQorKysgYi9saWJtdWx0aXBhdGgvaHd0YWJsZS5jPGJyPg0KQEAgLTgyNyw3ICs4MjcsNyBAQCBz
dGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKg
KiBJbnRlbDxicj4NCsKgIMKgIMKgIMKgIMKgKi88YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7KEludGVsfElO
VEVMKSZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAudmVuZG9ywqAgwqAgwqAg
wqAgPSAmcXVvdDsoSW50ZWx8SU5URUwpJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O011bHRpLUZsZXgmcXVvdDssPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLmJsX3Byb2R1Y3TCoCDCoCA9ICZxdW90O1ZUcmFrIFYtTFVO
JnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5od2hhbmRsZXLCoCDCoCDCoD0g
JnF1b3Q7MSBhbHVhJnF1b3Q7LDxicj4NCkBAIC04NDAsNyArODQwLDcgQEAgc3RhdGljIHN0cnVj
dCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCogTGludXgtSU8g
VGFyZ2V0PGJyPg0KwqAgwqAgwqAgwqAgwqAqLzxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQotwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDsoTElPLU9SR3xT
VVNFKSZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAudmVuZG9ywqAgwqAgwqAg
wqAgPSAmcXVvdDsoTElPLU9SR3xTVVNFKSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtSQkQmcXVvdDssPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLmh3aGFuZGxlcsKgIMKgIMKgPSAmcXVvdDsxIGFsdWEmcXVvdDssPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9Q
UklPLDxicj4NCkBAIC04NTIsNyArODUyLDcgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1
bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCogRGF0YUNvcmU8YnI+DQrCoCDCoCDCoCDC
oCDCoCovPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC52
ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0RhdGFDb3JlJnF1b3Q7LDxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0RhdGFDb3JlJnF1b3Q7LDxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O1NB
Tm1lbG9keSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDC
oCDCoCA9IEdST1VQX0JZX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFp
bGJhY2vCoCDCoCA9IC1GQUlMQkFDS19JTU1FRElBVEUsPGJyPg0KQEAgLTg2MSw3ICs4NjEsNyBA
QCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKg
IH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC8qIFNB
TnN5bXBob255ICovPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnZlbmRvcsKgIMKgIMKg
IMKgID0gJnF1b3Q7RGF0YUNvcmUmcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
LnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7RGF0YUNvcmUmcXVvdDssPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7VmlydHVhbCBEaXNrJnF1
b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gR1JP
VVBfQllfUFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKg
ID0gLUZBSUxCQUNLX0lNTUVESUFURSw8YnI+DQpAQCAtMTA1Myw3ICsxMDUzLDcgQEAgc3RhdGlj
IHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCogR2Vu
ZXJpYyBOVk1lIGRldmljZXM8YnI+DQrCoCDCoCDCoCDCoCDCoCovPGJyPg0KwqAgwqAgwqAgwqAg
ezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90
O05WTUUmcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnZlbmRvcsKgIMKgIMKg
IMKgID0gJnF1b3Q7TlZNRSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJv
ZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDsuKiZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAudWlkX2F0dHJpYnV0ZSA9ICZxdW90O0lEX1dXTiZxdW90Oyw8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAuY2hlY2tlcl9uYW1lwqAgPSBESVJFQ1RJTyw8YnI+DQo8c3BhbiBjbGFz
cz0iSE9FblpiIj48Zm9udCBjb2xvcj0iIzg4ODg4OCI+LS08YnI+DQoyLjEzLjA8YnI+DQo8YnI+
DQo8L2ZvbnQ+PC9zcGFuPjwvYmxvY2txdW90ZT48L2Rpdj48YnI+PC9kaXY+DQo=
--94eb2c04fa14d473bc055275d860--


--===============8397536850845685739==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8397536850845685739==--
