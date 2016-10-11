From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: remove hwhandler when it's
	alua
Date: Tue, 11 Oct 2016 08:02:04 +0200
Message-ID: <CABr-GnfHUoWn_q4LfvhDeF6w_vPcMg8VRjEN98quZ6+oes1Ryw@mail.gmail.com>
References: <20161006185021.3625-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0891010069344378953=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161006185021.3625-1-xose.vazquez@gmail.com>
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

--===============0891010069344378953==
Content-Type: multipart/alternative; boundary=001a114b14c4a5f3ef053e909d54

--001a114b14c4a5f3ef053e909d54
Content-Type: text/plain; charset=UTF-8

I'm not comfortable with this patch that induces a less predictable
behaviour.
We have that retain hardware handler switch that users can activate to
achieve the purpose.

Hannes, Ben, would you support that patch ?

Best Regards,
Christophe

On Thu, Oct 6, 2016 at 8:50 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Autodetected.
>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 367aa0a..1fc2f24 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -46,7 +46,6 @@ static struct hwentry default_hw[] = {
>                 .product       = "VV",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
> -               .hwhandler     = "1 alua",
>                 .prio_name     = PRIO_ALUA,
>                 .no_path_retry = 18,
>         },
> @@ -124,7 +123,6 @@ static struct hwentry default_hw[] = {
>                 /* SAN Virtualization Services Platform */
>                 .vendor        = "HP",
>                 .product       = "HSVX700",
> -               .hwhandler     = "1 alua",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .no_path_retry = 12,
> @@ -504,7 +502,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^IPR",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> -               .hwhandler     = "1 alua",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .prio_name     = PRIO_ALUA,
> @@ -546,7 +543,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "AIX",
>                 .product       = "NVDISK",
> -               .hwhandler     = "1 alua",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .no_path_retry = (300 / DEFAULT_CHECKINT),
> @@ -654,7 +650,6 @@ static struct hwentry default_hw[] = {
>                 /* M-Series */
>                 .vendor        = "NEC",
>                 .product       = "DISK ARRAY",
> -               .hwhandler     = "1 alua",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .prio_name     = PRIO_ALUA,
> @@ -780,7 +775,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "(Intel|INTEL)",
>                 .product       = "Multi-Flex",
> -               .hwhandler     = "1 alua",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> @@ -792,7 +786,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "(LIO-ORG|SUSE)",
>                 .product       = "RBD",
> -               .hwhandler     = "1 alua",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .no_path_retry = 12,
> --
> 2.10.1
>
>

--001a114b14c4a5f3ef053e909d54
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+SSYjMzk7bSBub3QgY29tZm9ydGFibGUgd2l0aCB0aGlzIHBhdGNoIHRo
YXQgaW5kdWNlcyBhIGxlc3MgcHJlZGljdGFibGUgYmVoYXZpb3VyLjxkaXY+V2UgaGF2ZSB0aGF0
IHJldGFpbiBoYXJkd2FyZSBoYW5kbGVyIHN3aXRjaCB0aGF0IHVzZXJzIGNhbiBhY3RpdmF0ZSB0
byBhY2hpZXZlIHRoZSBwdXJwb3NlLjwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+SGFubmVzLCBC
ZW4sIHdvdWxkIHlvdSBzdXBwb3J0IHRoYXQgcGF0Y2ggPzwvZGl2PjxkaXY+PGJyPjwvZGl2Pjxk
aXY+QmVzdCBSZWdhcmRzLDwvZGl2PjxkaXY+Q2hyaXN0b3BoZTwvZGl2PjwvZGl2PjxkaXYgY2xh
c3M9ImdtYWlsX2V4dHJhIj48YnI+PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIFRodSwgT2N0
IDYsIDIwMTYgYXQgODo1MCBQTSwgWG9zZSBWYXpxdWV6IFBlcmV6IDxzcGFuIGRpcj0ibHRyIj4m
bHQ7PGEgaHJlZj0ibWFpbHRvOnhvc2UudmF6cXVlekBnbWFpbC5jb20iIHRhcmdldD0iX2JsYW5r
Ij54b3NlLnZhenF1ZXpAZ21haWwuY29tPC9hPiZndDs8L3NwYW4+IHdyb3RlOjxicj48YmxvY2tx
dW90ZSBjbGFzcz0iZ21haWxfcXVvdGUiIHN0eWxlPSJtYXJnaW46MCAwIDAgLjhleDtib3JkZXIt
bGVmdDoxcHggI2NjYyBzb2xpZDtwYWRkaW5nLWxlZnQ6MWV4Ij5BdXRvZGV0ZWN0ZWQuPGJyPg0K
PGJyPg0KQ2M6IEhhbm5lcyBSZWluZWNrZSAmbHQ7PGEgaHJlZj0ibWFpbHRvOmhhcmVAc3VzZS5k
ZSI+aGFyZUBzdXNlLmRlPC9hPiZndDs8YnI+DQpDYzogQ2hyaXN0b3BoZSBWYXJvcXVpICZsdDs8
YSBocmVmPSJtYWlsdG86Y2hyaXN0b3BoZS52YXJvcXVpQG9wZW5zdmMuY29tIj5jaHJpc3RvcGhl
LnZhcm9xdWlAb3BlbnN2Yy48d2JyPmNvbTwvYT4mZ3Q7PGJyPg0KQ2M6IGRldmljZS1tYXBwZXIg
ZGV2ZWxvcG1lbnQgJmx0OzxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1k
ZXZlbEByZWRoYXQuY29tPC9hPiZndDs8YnI+DQpTaWduZWQtb2ZmLWJ5OiBYb3NlIFZhenF1ZXog
UGVyZXogJmx0OzxhIGhyZWY9Im1haWx0bzp4b3NlLnZhenF1ZXpAZ21haWwuY29tIj54b3NlLnZh
enF1ZXpAZ21haWwuY29tPC9hPiZndDs8YnI+DQotLS08YnI+DQrCoGxpYm11bHRpcGF0aC9od3Rh
YmxlLmMgfCA3IC0tLS0tLS08YnI+DQrCoDEgZmlsZSBjaGFuZ2VkLCA3IGRlbGV0aW9ucygtKTxi
cj4NCjxicj4NCmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvaHd0YWJsZS5jIGIvbGlibXVsdGlw
YXRoL2h3dGFibGUuYzxicj4NCmluZGV4IDM2N2FhMGEuLjFmYzJmMjQgMTAwNjQ0PGJyPg0KLS0t
IGEvbGlibXVsdGlwYXRoL2h3dGFibGUuYzxicj4NCisrKyBiL2xpYm11bHRpcGF0aC9od3RhYmxl
LmM8YnI+DQpAQCAtNDYsNyArNDYsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9o
d1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9
ICZxdW90O1ZWJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKg
IMKgIMKgID0gR1JPVVBfQllfUFJJTyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdm
YWlsYmFja8KgIMKgID0gLUZBSUxCQUNLX0lNTUVESUFURSw8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEgYWx1YSZxdW90Oyw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19uYW1lwqAgwqAgwqA9IFBSSU9fQUxVQSw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IDE4LDxicj4NCsKgIMKgIMKg
IMKgIH0sPGJyPg0KQEAgLTEyNCw3ICsxMjMsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVm
YXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC8qIFNBTiBWaXJ0dWFs
aXphdGlvbiBTZXJ2aWNlcyBQbGF0Zm9ybSAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0hQJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O0hTVlg3MDAmcXVvdDssPGJyPg0K
LcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxlcsKgIMKgIMKgPSAmcXVvdDsxIGFsdWEm
cXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBH
Uk9VUF9CWV9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAg
wqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5u
b19wYXRoX3JldHJ5ID0gMTIsPGJyPg0KQEAgLTUwNCw3ICs1MDIsNiBAQCBzdGF0aWMgc3RydWN0
IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52
ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDteSVBSJnF1b3Q7LDxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9RVUVVRSw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEg
YWx1YSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDC
oCA9IEdST1VQX0JZX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJh
Y2vCoCDCoCA9IC1GQUlMQkFDS19JTU1FRElBVEUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnByaW9fbmFtZcKgIMKgIMKgPSBQUklPX0FMVUEsPGJyPg0KQEAgLTU0Niw3ICs1NDMsNiBA
QCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKg
IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVv
dDtBSVgmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDC
oCDCoD0gJnF1b3Q7TlZESVNLJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5o
d2hhbmRsZXLCoCDCoCDCoD0gJnF1b3Q7MSBhbHVhJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gR1JPVVBfQllfUFJJTyw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAucGdmYWlsYmFja8KgIMKgID0gLUZBSUxCQUNLX0lNTUVESUFURSw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9ICgzMDAgLyBERUZB
VUxUX0NIRUNLSU5UKSw8YnI+DQpAQCAtNjU0LDcgKzY1MCw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdl
bnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLyogTS1T
ZXJpZXMgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAg
PSAmcXVvdDtORUMmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TC
oCDCoCDCoCDCoD0gJnF1b3Q7RElTSyBBUlJBWSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEgYWx1YSZxdW90Oyw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQX0JZX1BSSU8sPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFpbGJhY2vCoCDCoCA9IC1GQUlMQkFDS19J
TU1FRElBVEUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByaW9fbmFtZcKgIMKgIMKg
PSBQUklPX0FMVUEsPGJyPg0KQEAgLTc4MCw3ICs3NzUsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50
cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDsoSW50ZWx8SU5URUwpJnF1b3Q7
LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90
O011bHRpLUZsZXgmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmh3aGFuZGxl
csKgIMKgIMKgPSAmcXVvdDsxIGFsdWEmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnBncG9saWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9QUklPLDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wZ2ZhaWxiYWNrwqAgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9RVUVV
RSw8YnI+DQpAQCAtNzkyLDcgKzc4Niw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0
X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90OyhMSU8tT1JHfFNVU0UpJnF1b3Q7LDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O1JCRCZxdW90
Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90
OzEgYWx1YSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDC
oCDCoCA9IEdST1VQX0JZX1BSSU8sPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFp
bGJhY2vCoCDCoCA9IC1GQUlMQkFDS19JTU1FRElBVEUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLm5vX3BhdGhfcmV0cnkgPSAxMiw8YnI+DQo8c3BhbiBjbGFzcz0iSE9FblpiIj48Zm9u
dCBjb2xvcj0iIzg4ODg4OCI+LS08YnI+DQoyLjEwLjE8YnI+DQo8YnI+DQo8L2ZvbnQ+PC9zcGFu
PjwvYmxvY2txdW90ZT48L2Rpdj48YnI+PC9kaXY+DQo=
--001a114b14c4a5f3ef053e909d54--


--===============0891010069344378953==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0891010069344378953==--
