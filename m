From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add template to add new
	hardware
Date: Fri, 22 Jul 2016 11:50:10 +0200
Message-ID: <CABr-GncFHdyry2A=HMnNMTb5P-BEz+stfVs9yVhPE27gsDKWWg@mail.gmail.com>
References: <1468334507-7531-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0598474241002114435=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468334507-7531-1-git-send-email-xose.vazquez@gmail.com>
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

--===============0598474241002114435==
Content-Type: multipart/alternative; boundary=001a114102e44ad9c40538365c09

--001a114102e44ad9c40538365c09
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Tue, Jul 12, 2016 at 4:41 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 5b896ee..a1fc3e8 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -16,6 +16,8 @@
>   * family. Please mail the currently enlisted maintainer and
>   * the upstream package maintainer.
>   *
> + * Please, use the TEMPLATE below to add new hardware.
> + *
>   * WARNING:
>   *
>   * Devices with a proprietary handler must also be included in
> @@ -756,6 +758,46 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = 30,
>                 .minio         = 128,
>         },
> +#if 0
> +       /*
> +        * Copy this TEMPLATE to add new hardware.
> +        *
> +        * Keep only mandatory and modified attributes.
> +        * Standard attributes must be removed.
> +        *
> +        * COMPANY_NAME
> +        *
> +        * Maintainer : XXX
> +        * Mail : XXX
> +        */
> +       {
> +               .vendor        = "VENDOR", (Mandatory)
> +               .product       = "PRODUCT", (Mandatory)
> +               .revision      = "REVISION",
> +               .bl_product    = "BL_PRODUCT",
> +               .pgpolicy      = GROUP_BY_PRIO,
> +               .uid_attribute = "ID_SERIAL",
> +               .selector      = "service-time 0",
> +               .checker_name  = TUR,
> +               .features      = "0",
> +               .hwhandler     = "0",
> +               .prio_name     = "const",
> +               .prio_args     = "",
> +               .pgfailback    = -FAILBACK_IMMEDIATE,
> +               .rr_weight     = RR_WEIGHT_NONE,
> +               .no_path_retry = NO_PATH_RETRY_UNDEF,
> +               .minio         = 1000,
> +               .minio_rq      = 1,
> +               .flush_on_last_del = FLUSH_DISABLED,
> +               .fast_io_fail  = 5,
> +               .dev_loss      = 600,
> +               .retain_hwhandler = RETAIN_HWHANDLER_ON,
> +               .detect_prio   = DETECT_PRIO_ON,
> +               .deferred_remove = DEFERRED_REMOVE_OFF,
> +               .delay_watch_checks = DELAY_CHECKS_OFF,
> +               .delay_wait_checks = DELAY_CHECKS_OFF,
> +       },
> +#endif
>         /*
>          * EOL
>          */
> --
> 2.7.4
>
>

--001a114102e44ad9c40538365c09
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+TWVyZ2VkLjxkaXY+VGhhbmtzLjwvZGl2PjwvZGl2PjxkaXYgY2xhc3M9
ImdtYWlsX2V4dHJhIj48YnI+PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIFR1ZSwgSnVsIDEy
LCAyMDE2IGF0IDQ6NDEgUE0sIFhvc2UgVmF6cXVleiBQZXJleiA8c3BhbiBkaXI9Imx0ciI+Jmx0
OzxhIGhyZWY9Im1haWx0bzp4b3NlLnZhenF1ZXpAZ21haWwuY29tIiB0YXJnZXQ9Il9ibGFuayI+
eG9zZS52YXpxdWV6QGdtYWlsLmNvbTwvYT4mZ3Q7PC9zcGFuPiB3cm90ZTo8YnI+PGJsb2NrcXVv
dGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxl
ZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI+Q2M6IENocmlzdG9waGUgVmFyb3F1
aSAmbHQ7PGEgaHJlZj0ibWFpbHRvOmNocmlzdG9waGUudmFyb3F1aUBvcGVuc3ZjLmNvbSI+Y2hy
aXN0b3BoZS52YXJvcXVpQG9wZW5zdmMuY29tPC9hPiZndDs8YnI+DQpDYzogZGV2aWNlLW1hcHBl
ciBkZXZlbG9wbWVudCAmbHQ7PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRt
LWRldmVsQHJlZGhhdC5jb208L2E+Jmd0Ozxicj4NClNpZ25lZC1vZmYtYnk6IFhvc2UgVmF6cXVl
eiBQZXJleiAmbHQ7PGEgaHJlZj0ibWFpbHRvOnhvc2UudmF6cXVlekBnbWFpbC5jb20iPnhvc2Uu
dmF6cXVlekBnbWFpbC5jb208L2E+Jmd0Ozxicj4NCi0tLTxicj4NCsKgbGlibXVsdGlwYXRoL2h3
dGFibGUuYyB8IDQyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKzxi
cj4NCsKgMSBmaWxlIGNoYW5nZWQsIDQyIGluc2VydGlvbnMoKyk8YnI+DQo8YnI+DQpkaWZmIC0t
Z2l0IGEvbGlibXVsdGlwYXRoL2h3dGFibGUuYyBiL2xpYm11bHRpcGF0aC9od3RhYmxlLmM8YnI+
DQppbmRleCA1Yjg5NmVlLi5hMWZjM2U4IDEwMDY0NDxicj4NCi0tLSBhL2xpYm11bHRpcGF0aC9o
d3RhYmxlLmM8YnI+DQorKysgYi9saWJtdWx0aXBhdGgvaHd0YWJsZS5jPGJyPg0KQEAgLTE2LDYg
KzE2LDggQEA8YnI+DQrCoCAqIGZhbWlseS4gUGxlYXNlIG1haWwgdGhlIGN1cnJlbnRseSBlbmxp
c3RlZCBtYWludGFpbmVyIGFuZDxicj4NCsKgICogdGhlIHVwc3RyZWFtIHBhY2thZ2UgbWFpbnRh
aW5lci48YnI+DQrCoCAqPGJyPg0KKyAqIFBsZWFzZSwgdXNlIHRoZSBURU1QTEFURSBiZWxvdyB0
byBhZGQgbmV3IGhhcmR3YXJlLjxicj4NCisgKjxicj4NCsKgICogV0FSTklORzo8YnI+DQrCoCAq
PGJyPg0KwqAgKiBEZXZpY2VzIHdpdGggYSBwcm9wcmlldGFyeSBoYW5kbGVyIG11c3QgYWxzbyBi
ZSBpbmNsdWRlZCBpbjxicj4NCkBAIC03NTYsNiArNzU4LDQ2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdl
bnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBnZmFp
bGJhY2vCoCDCoCA9IDMwLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5taW5pb8KgIMKg
IMKgIMKgIMKgPSAxMjgsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQorI2lmIDA8YnI+DQorwqAg
wqAgwqAgwqAvKjxicj4NCivCoCDCoCDCoCDCoCAqIENvcHkgdGhpcyBURU1QTEFURSB0byBhZGQg
bmV3IGhhcmR3YXJlLjxicj4NCivCoCDCoCDCoCDCoCAqPGJyPg0KK8KgIMKgIMKgIMKgICogS2Vl
cCBvbmx5IG1hbmRhdG9yeSBhbmQgbW9kaWZpZWQgYXR0cmlidXRlcy48YnI+DQorwqAgwqAgwqAg
wqAgKiBTdGFuZGFyZCBhdHRyaWJ1dGVzIG11c3QgYmUgcmVtb3ZlZC48YnI+DQorwqAgwqAgwqAg
wqAgKjxicj4NCivCoCDCoCDCoCDCoCAqIENPTVBBTllfTkFNRTxicj4NCivCoCDCoCDCoCDCoCAq
PGJyPg0KK8KgIMKgIMKgIMKgICogTWFpbnRhaW5lciA6IFhYWDxicj4NCivCoCDCoCDCoCDCoCAq
IE1haWwgOiBYWFg8YnI+DQorwqAgwqAgwqAgwqAgKi88YnI+DQorwqAgwqAgwqAgwqB7PGJyPg0K
K8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7VkVORE9S
JnF1b3Q7LCAoTWFuZGF0b3J5KTxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcm9kdWN0
wqAgwqAgwqAgwqA9ICZxdW90O1BST0RVQ1QmcXVvdDssIChNYW5kYXRvcnkpPGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLnJldmlzaW9uwqAgwqAgwqAgPSAmcXVvdDtSRVZJU0lPTiZxdW90
Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuYmxfcHJvZHVjdMKgIMKgID0gJnF1b3Q7
QkxfUFJPRFVDVCZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdwb2xpY3nC
oCDCoCDCoCA9IEdST1VQX0JZX1BSSU8sPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnVp
ZF9hdHRyaWJ1dGUgPSAmcXVvdDtJRF9TRVJJQUwmcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLnNlbGVjdG9ywqAgwqAgwqAgPSAmcXVvdDtzZXJ2aWNlLXRpbWUgMCZxdW90Oyw8
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuY2hlY2tlcl9uYW1lwqAgPSBUVVIsPGJyPg0K
K8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmZlYXR1cmVzwqAgwqAgwqAgPSAmcXVvdDswJnF1b3Q7
LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5od2hhbmRsZXLCoCDCoCDCoD0gJnF1b3Q7
MCZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9
ICZxdW90O2NvbnN0JnF1b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wcmlvX2Fy
Z3PCoCDCoCDCoD0gJnF1b3Q7JnF1b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5w
Z2ZhaWxiYWNrwqAgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCivCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC5ycl93ZWlnaHTCoCDCoCDCoD0gUlJfV0VJR0hUX05PTkUsPGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1VOREVGLDxi
cj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5taW5pb8KgIMKgIMKgIMKgIMKgPSAxMDAwLDxi
cj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5taW5pb19yccKgIMKgIMKgID0gMSw8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmx1c2hfb25fbGFzdF9kZWwgPSBGTFVTSF9ESVNBQkxF
RCw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmFzdF9pb19mYWlswqAgPSA1LDxicj4N
CivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5kZXZfbG9zc8KgIMKgIMKgID0gNjAwLDxicj4NCivC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5yZXRhaW5faHdoYW5kbGVyID0gUkVUQUlOX0hXSEFORExF
Ul9PTiw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZGV0ZWN0X3ByaW/CoCDCoD0gREVU
RUNUX1BSSU9fT04sPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmRlZmVycmVkX3JlbW92
ZSA9IERFRkVSUkVEX1JFTU9WRV9PRkYsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmRl
bGF5X3dhdGNoX2NoZWNrcyA9IERFTEFZX0NIRUNLU19PRkYsPGJyPg0KK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLmRlbGF5X3dhaXRfY2hlY2tzID0gREVMQVlfQ0hFQ0tTX09GRiw8YnI+DQorwqAg
wqAgwqAgwqB9LDxicj4NCisjZW5kaWY8YnI+DQrCoCDCoCDCoCDCoCAvKjxicj4NCsKgIMKgIMKg
IMKgIMKgKiBFT0w8YnI+DQrCoCDCoCDCoCDCoCDCoCovPGJyPg0KPHNwYW4gY2xhc3M9IkhPRW5a
YiI+PGZvbnQgY29sb3I9IiM4ODg4ODgiPi0tPGJyPg0KMi43LjQ8YnI+DQo8YnI+DQo8L2ZvbnQ+
PC9zcGFuPjwvYmxvY2txdW90ZT48L2Rpdj48YnI+PC9kaXY+DQo=
--001a114102e44ad9c40538365c09--


--===============0598474241002114435==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0598474241002114435==--
