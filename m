From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 4/4] multipath-tools: change default
 path_grouping_policy from failover to multibus
Date: Mon, 3 Oct 2016 13:10:20 +0200
Message-ID: <CABr-Gnc5hApDt2tDdz6=Ph2P+-teyQtFcQhYyJM91PQ5bh2NGA@mail.gmail.com>
References: <1471543096-11441-1-git-send-email-xose.vazquez@gmail.com>
	<1471543096-11441-4-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6327225869831125782=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471543096-11441-4-git-send-email-xose.vazquez@gmail.com>
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

--===============6327225869831125782==
Content-Type: multipart/alternative; boundary=001a11471dee6926b0053df3fd15

--001a11471dee6926b0053df3fd15
Content-Type: text/plain; charset=UTF-8

Dropped.

"failover" is the conservative default. The one we expect applies to
hardware not even known to the hwtable.

Best regards,
Christophe Varoqui
OpenSVC

On Thu, Aug 18, 2016 at 7:58 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Default value is: failover
>       1                 .pgpolicy      = FAILOVER,
>       2                 .pgpolicy      = GROUP_BY_SERIAL,
>      25                 .pgpolicy      = MULTIBUS,
>      47                 .pgpolicy      = GROUP_BY_PRIO,
> failover is only used by 1 device: IBM/3303 NVDISK
>
> I hope it's reasonable. If someone disagrees, drop it.
>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/defaults.h    |  2 +-
>  libmultipath/hwtable.c     | 28 ++--------------------------
>  multipath/multipath.conf.5 |  2 +-
>  3 files changed, 4 insertions(+), 28 deletions(-)
>
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index a7c74fe..c1e8e74 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -11,7 +11,7 @@
>  #define DEFAULT_HWHANDLER      "0"
>  #define DEFAULT_MINIO          1000
>  #define DEFAULT_MINIO_RQ       1
> -#define DEFAULT_PGPOLICY       FAILOVER
> +#define DEFAULT_PGPOLICY       MULTIBUS
>  #define DEFAULT_FAILBACK       FAILBACK_UNDEF
>  #define DEFAULT_RR_WEIGHT      RR_WEIGHT_NONE
>  #define DEFAULT_NO_PATH_RETRY  NO_PATH_RETRY_UNDEF
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index c4037d5..eedb360 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -36,7 +36,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "APPLE",
>                 .product       = "Xserve RAID",
> -               .pgpolicy      = MULTIBUS,
>         },
>         /*
>          * HPE
> @@ -64,7 +63,6 @@ static struct hwentry default_hw[] = {
>                 /* VIRTUAL ARRAY 7400 */
>                 .vendor        = "HP",
>                 .product       = "A6189A",
> -               .pgpolicy      = MULTIBUS,
>                 .no_path_retry = 12,
>         },
>         {
> @@ -99,7 +97,6 @@ static struct hwentry default_hw[] = {
>                 /* MSA2000 family with old firmware */
>                 .vendor        = "HP",
>                 .product       = "(MSA2[02]12fc|MSA2012i)",
> -               .pgpolicy      = MULTIBUS,
>                 .no_path_retry = 18,
>         },
>         {
> @@ -134,7 +131,6 @@ static struct hwentry default_hw[] = {
>                 /* Smart Array */
>                 .vendor        = "HP",
>                 .product       = "LOGICAL VOLUME",
> -               .pgpolicy      = MULTIBUS,
>                 .no_path_retry = 12,
>         },
>         {
> @@ -152,7 +148,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "DDN",
>                 .product       = "SAN DataDirector",
> -               .pgpolicy      = MULTIBUS,
>         },
>         /*
>          * EMC
> @@ -161,7 +156,6 @@ static struct hwentry default_hw[] = {
>                 /* Symmetrix / DMX / VMAX */
>                 .vendor        = "EMC",
>                 .product       = "SYMMETRIX",
> -               .pgpolicy      = MULTIBUS,
>                 .no_path_retry = 6,
>         },
>         {
> @@ -181,13 +175,11 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "EMC",
>                 .product       = "Invista",
>                 .bl_product    = "LUNZ",
> -               .pgpolicy      = MULTIBUS,
>                 .no_path_retry = 5,
>         },
>         {
>                 .vendor        = "XtremIO",
>                 .product       = "XtremApp",
> -               .pgpolicy      = MULTIBUS,
>         },
>         /*
>          * DELL
> @@ -201,7 +193,6 @@ static struct hwentry default_hw[] = {
>                  */
>                 .vendor        = "COMPELNT",
>                 .product       = "Compellent Vol",
> -               .pgpolicy      = MULTIBUS,
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>         },
>         {
> @@ -260,7 +251,6 @@ static struct hwentry default_hw[] = {
>                 /* FibreCAT S80 */
>                 .vendor        = "(EUROLOGC|EuroLogc)",
>                 .product       = "FC2502",
> -               .pgpolicy      = MULTIBUS,
>         },
>         /*
>          * Hitachi
> @@ -272,7 +262,6 @@ static struct hwentry default_hw[] = {
>                 /* USP-V, HUS VM, VSP, VSP G1000 and VSP GX00 families */
>                 .vendor        = "(HITACHI|HP)",
>                 .product       = "^OPEN-",
> -               .pgpolicy      = MULTIBUS,
>         },
>         {
>                 /* AMS 2000 and HUS 100 families */
> @@ -292,7 +281,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "IBM",
>                 .product       = "ProFibre 4000R",
> -               .pgpolicy      = MULTIBUS,
>         },
>         {
>                 /* DS4300 / FAStT600 */
> @@ -428,14 +416,12 @@ static struct hwentry default_hw[] = {
>                 /* DS4200 / FAStT200 */
>                 .vendor        = "IBM",
>                 .product       = "^3542",
> -               .pgpolicy      = MULTIBUS,
>         },
>         {
>                 /* Enterprise Storage Server / Shark family */
>                 .vendor        = "IBM",
>                 .product       = "^2105",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> -               .pgpolicy      = MULTIBUS,
>         },
>         {
>                 /* DS6000 */
> @@ -451,7 +437,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^2107900",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> -               .pgpolicy      = MULTIBUS,
>         },
>         {
>                 /* Storwize family / SAN Volume Controller / Flex System
> V7000 */
> @@ -468,7 +453,6 @@ static struct hwentry default_hw[] = {
>                 .bl_product    = "S/390",
>                 .uid_attribute = "ID_UID",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> -               .pgpolicy      = MULTIBUS,
>         },
>         {
>                 .vendor        = "IBM",
> @@ -476,7 +460,6 @@ static struct hwentry default_hw[] = {
>                 .bl_product    = "S/390",
>                 .uid_attribute = "ID_UID",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> -               .pgpolicy      = MULTIBUS,
>         },
>         {
>                 /* Power RAID */
> @@ -502,7 +485,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "2810XIV",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> -               .pgpolicy      = MULTIBUS,
>         },
>                 /*
>                  * IBM Power Virtual SCSI Devices
> @@ -513,7 +495,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "AIX",
>                 .product       = "VDASD",
> -               .pgpolicy      = MULTIBUS,
>                 .no_path_retry = (300 / DEFAULT_CHECKINT),
>         },
>         {
> @@ -521,6 +502,7 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "3303[ ]+NVDISK",
>                 .no_path_retry = (300 / DEFAULT_CHECKINT),
> +               .pgpolicy      = FAILOVER,
>         },
>         {
>                 .vendor        = "AIX",
> @@ -587,7 +569,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "SGI",
>                 .product       = "TP9100",
> -               .pgpolicy      = MULTIBUS,
>         },
>         {
>                 .vendor        = "SGI",
> @@ -677,7 +658,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "SUN",
>                 .product       = "(StorEdge 3510|T4)",
> -               .pgpolicy      = MULTIBUS,
>         },
>         {
>                 .vendor        = "SUN",
> @@ -739,7 +719,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "PIVOT3",
>                 .product       = "RAIGE VOLUME",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> -               .pgpolicy      = MULTIBUS,
>         },
>         /*
>          * Intel
> @@ -790,7 +769,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "PURE",
>                 .product       = "FlashArray",
> -               .pgpolicy      = MULTIBUS,
>                 .fast_io_fail  = 10,
>                 .dev_loss      = 60,
>         },
> @@ -801,7 +779,6 @@ static struct hwentry default_hw[] = {
>                 /* OceanStor V3 */
>                 .vendor        = "(HUAWEI|HUASY)",
>                 .product       = "XSG1",
> -               .pgpolicy      = MULTIBUS,
>         },
>         /*
>          * Red Hat
> @@ -822,7 +799,6 @@ static struct hwentry default_hw[] = {
>         {
>                 .vendor        = "KOVE",
>                 .product       = "XPD",
> -               .pgpolicy      = MULTIBUS,
>         },
>  #if 0
>         /*
> @@ -844,7 +820,7 @@ static struct hwentry default_hw[] = {
>                 .product       = "PRODUCT",
>                 .revision      = "REVISION",
>                 .bl_product    = "BL_PRODUCT",
> -               .pgpolicy      = FAILOVER,
> +               .pgpolicy      = MULTIBUS,
>                 .uid_attribute = "ID_SERIAL",
>                 .selector      = "service-time 0",
>                 .checker_name  = TUR,
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 466ad94..8c0b47a 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -204,7 +204,7 @@ per-multipath option in the configuration file.
>  One priority group per target node name. Target node names are fetched
>  in \fI/sys/class/fc_transport/target*/node_name\fR.
>  .TP
> -Default value is: \fBfailover\fR
> +Default value is: \fBmultibus\fR
>  .RE
>  .
>  .
> --
> 2.7.4
>
>

--001a11471dee6926b0053df3fd15
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+RHJvcHBlZC48ZGl2Pjxicj48L2Rpdj48ZGl2PiZxdW90O2ZhaWxvdmVy
JnF1b3Q7IGlzIHRoZSBjb25zZXJ2YXRpdmUgZGVmYXVsdC4gVGhlIG9uZSB3ZSBleHBlY3QgYXBw
bGllcyB0byBoYXJkd2FyZSBub3QgZXZlbiBrbm93biB0byB0aGUgaHd0YWJsZS48L2Rpdj48ZGl2
Pjxicj48L2Rpdj48ZGl2PkJlc3QgcmVnYXJkcyw8L2Rpdj48ZGl2PkNocmlzdG9waGUgVmFyb3F1
aTwvZGl2PjxkaXY+T3BlblNWQzwvZGl2PjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48
YnI+PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIFRodSwgQXVnIDE4LCAyMDE2IGF0IDc6NTgg
UE0sIFhvc2UgVmF6cXVleiBQZXJleiA8c3BhbiBkaXI9Imx0ciI+Jmx0OzxhIGhyZWY9Im1haWx0
bzp4b3NlLnZhenF1ZXpAZ21haWwuY29tIiB0YXJnZXQ9Il9ibGFuayI+eG9zZS52YXpxdWV6QGdt
YWlsLmNvbTwvYT4mZ3Q7PC9zcGFuPiB3cm90ZTo8YnI+PGJsb2NrcXVvdGUgY2xhc3M9ImdtYWls
X3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29s
aWQ7cGFkZGluZy1sZWZ0OjFleCI+RGVmYXVsdCB2YWx1ZSBpczogZmFpbG92ZXI8YnI+DQrCoCDC
oCDCoCAxwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdwb2xpY3nCoCDCoCDCoCA9IEZBSUxP
VkVSLDxicj4NCsKgIMKgIMKgIDLCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ3BvbGljecKg
IMKgIMKgID0gR1JPVVBfQllfU0VSSUFMLDxicj4NCsKgIMKgIMKgMjXCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJyPg0KwqAgwqAgwqA0N8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBncG9saWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9QUklP
LDxicj4NCmZhaWxvdmVyIGlzIG9ubHkgdXNlZCBieSAxIGRldmljZTogSUJNLzMzMDMgTlZESVNL
PGJyPg0KPGJyPg0KSSBob3BlIGl0JiMzOTtzIHJlYXNvbmFibGUuIElmIHNvbWVvbmUgZGlzYWdy
ZWVzLCBkcm9wIGl0Ljxicj4NCjxicj4NCkNjOiBIYW5uZXMgUmVpbmVja2UgJmx0OzxhIGhyZWY9
Im1haWx0bzpoYXJlQHN1c2UuZGUiPmhhcmVAc3VzZS5kZTwvYT4mZ3Q7PGJyPg0KQ2M6IEJlbmph
bWluIE1hcnppbnNraSAmbHQ7PGEgaHJlZj0ibWFpbHRvOmJtYXJ6aW5zQHJlZGhhdC5jb20iPmJt
YXJ6aW5zQHJlZGhhdC5jb208L2E+Jmd0Ozxicj4NCkNjOiBDaHJpc3RvcGhlIFZhcm9xdWkgJmx0
OzxhIGhyZWY9Im1haWx0bzpjaHJpc3RvcGhlLnZhcm9xdWlAb3BlbnN2Yy5jb20iPmNocmlzdG9w
aGUudmFyb3F1aUBvcGVuc3ZjLjx3YnI+Y29tPC9hPiZndDs8YnI+DQpDYzogZGV2aWNlLW1hcHBl
ciBkZXZlbG9wbWVudCAmbHQ7PGEgaHJlZj0ibWFpbHRvOmRtLWRldmVsQHJlZGhhdC5jb20iPmRt
LWRldmVsQHJlZGhhdC5jb208L2E+Jmd0Ozxicj4NClNpZ25lZC1vZmYtYnk6IFhvc2UgVmF6cXVl
eiBQZXJleiAmbHQ7PGEgaHJlZj0ibWFpbHRvOnhvc2UudmF6cXVlekBnbWFpbC5jb20iPnhvc2Uu
dmF6cXVlekBnbWFpbC5jb208L2E+Jmd0Ozxicj4NCi0tLTxicj4NCsKgbGlibXVsdGlwYXRoL2Rl
ZmF1bHRzLmjCoCDCoCB8wqAgMiArLTxicj4NCsKgbGlibXVsdGlwYXRoL2h3dGFibGUuY8KgIMKg
IMKgfCAyOCArKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tPGJyPg0KwqBtdWx0aXBhdGgvbXVs
dGlwYXRoLmNvbmYuNSB8wqAgMiArLTxicj4NCsKgMyBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlv
bnMoKyksIDI4IGRlbGV0aW9ucygtKTxicj4NCjxicj4NCmRpZmYgLS1naXQgYS9saWJtdWx0aXBh
dGgvZGVmYXVsdHMuaCBiL2xpYm11bHRpcGF0aC9kZWZhdWx0cy5oPGJyPg0KaW5kZXggYTdjNzRm
ZS4uYzFlOGU3NCAxMDA2NDQ8YnI+DQotLS0gYS9saWJtdWx0aXBhdGgvZGVmYXVsdHMuaDxicj4N
CisrKyBiL2xpYm11bHRpcGF0aC9kZWZhdWx0cy5oPGJyPg0KQEAgLTExLDcgKzExLDcgQEA8YnI+
DQrCoCNkZWZpbmUgREVGQVVMVF9IV0hBTkRMRVLCoCDCoCDCoCAmcXVvdDswJnF1b3Q7PGJyPg0K
wqAjZGVmaW5lIERFRkFVTFRfTUlOSU/CoCDCoCDCoCDCoCDCoCAxMDAwPGJyPg0KwqAjZGVmaW5l
IERFRkFVTFRfTUlOSU9fUlHCoCDCoCDCoCDCoDE8YnI+DQotI2RlZmluZSBERUZBVUxUX1BHUE9M
SUNZwqAgwqAgwqAgwqBGQUlMT1ZFUjxicj4NCisjZGVmaW5lIERFRkFVTFRfUEdQT0xJQ1nCoCDC
oCDCoCDCoE1VTFRJQlVTPGJyPg0KwqAjZGVmaW5lIERFRkFVTFRfRkFJTEJBQ0vCoCDCoCDCoCDC
oEZBSUxCQUNLX1VOREVGPGJyPg0KwqAjZGVmaW5lIERFRkFVTFRfUlJfV0VJR0hUwqAgwqAgwqAg
UlJfV0VJR0hUX05PTkU8YnI+DQrCoCNkZWZpbmUgREVGQVVMVF9OT19QQVRIX1JFVFJZwqAgTk9f
UEFUSF9SRVRSWV9VTkRFRjxicj4NCmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvaHd0YWJsZS5j
IGIvbGlibXVsdGlwYXRoL2h3dGFibGUuYzxicj4NCmluZGV4IGM0MDM3ZDUuLmVlZGIzNjAgMTAw
NjQ0PGJyPg0KLS0tIGEvbGlibXVsdGlwYXRoL2h3dGFibGUuYzxicj4NCisrKyBiL2xpYm11bHRp
cGF0aC9od3RhYmxlLmM8YnI+DQpAQCAtMzYsNyArMzYsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50
cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtBUFBMRSZxdW90Oyw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtYc2VydmUg
UkFJRCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdwb2xpY3nCoCDCoCDC
oCA9IE1VTFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgLyo8YnI+
DQrCoCDCoCDCoCDCoCDCoCogSFBFPGJyPg0KQEAgLTY0LDcgKzYzLDYgQEAgc3RhdGljIHN0cnVj
dCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAv
KiBWSVJUVUFMIEFSUkFZIDc0MDAgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVu
ZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtIUCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtBNjE4OUEmcXVvdDssPGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IDEyLDxicj4NCsKgIMKgIMKgIMKg
IH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCkBAIC05OSw3ICs5Nyw2IEBAIHN0YXRpYyBzdHJ1
Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LyogTVNBMjAwMCBmYW1pbHkgd2l0aCBvbGQgZmlybXdhcmUgKi88YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtIUCZxdW90Oyw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDsoTVNBMlswMl0x
MmZjfE1TQTIwMTJpKSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdwb2xp
Y3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19w
YXRoX3JldHJ5ID0gMTgsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJy
Pg0KQEAgLTEzNCw3ICsxMzEsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1td
ID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC8qIFNtYXJ0IEFycmF5ICovPGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7SFAmcXVv
dDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1
b3Q7TE9HSUNBTCBWT0xVTUUmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBn
cG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAu
bm9fcGF0aF9yZXRyeSA9IDEyLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAg
ezxicj4NCkBAIC0xNTIsNyArMTQ4LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRf
aHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7REROJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O1NBTiBEYXRhRGlyZWN0b3ImcXVv
dDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxU
SUJVUyw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIC8qPGJyPg0KwqAgwqAg
wqAgwqAgwqAqIEVNQzxicj4NCkBAIC0xNjEsNyArMTU2LDYgQEAgc3RhdGljIHN0cnVjdCBod2Vu
dHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBTeW1t
ZXRyaXggLyBETVggLyBWTUFYICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRv
csKgIMKgIMKgIMKgID0gJnF1b3Q7RU1DJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O1NZTU1FVFJJWCZxdW90Oyw8YnI+DQotwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gNiw8YnI+DQrCoCDCoCDCoCDC
oCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQpAQCAtMTgxLDEzICsxNzUsMTEgQEAgc3RhdGlj
IHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtFTUMmcXVvdDssPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7SW52aXN0YSZxdW90Oyw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuYmxfcHJvZHVjdMKgIMKgID0gJnF1b3Q7TFVO
WiZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdwb2xpY3nCoCDCoCDCoCA9
IE1VTFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0g
NSw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtYdHJlbUlPJnF1b3Q7LDxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O1h0
cmVtQXBwJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ3BvbGljecKgIMKg
IMKgID0gTVVMVElCVVMsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCAvKjxi
cj4NCsKgIMKgIMKgIMKgIMKgKiBERUxMPGJyPg0KQEAgLTIwMSw3ICsxOTMsNiBAQCBzdGF0aWMg
c3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgKi88YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAg
PSAmcXVvdDtDT01QRUxOVCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJv
ZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtDb21wZWxsZW50IFZvbCZxdW90Oyw8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9RVUVVRSw8
YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQpAQCAtMjYwLDcgKzI1
MSw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgLyogRmlicmVDQVQgUzgwICovPGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7KEVVUk9MT0dDfEV1cm9Mb2djKSZx
dW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAm
cXVvdDtGQzI1MDImcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBncG9saWN5
wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKg
IC8qPGJyPg0KwqAgwqAgwqAgwqAgwqAqIEhpdGFjaGk8YnI+DQpAQCAtMjcyLDcgKzI2Miw2IEBA
IHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLyogVVNQLVYsIEhVUyBWTSwgVlNQLCBWU1AgRzEwMDAgYW5kIFZTUCBHWDAw
IGZhbWlsaWVzICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKg
IMKgID0gJnF1b3Q7KEhJVEFDSEl8SFApJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O15PUEVOLSZxdW90Oyw8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCsKgIMKg
IMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC8qIEFNUyAyMDAwIGFuZCBIVVMgMTAwIGZhbWlsaWVzICovPGJyPg0KQEAgLTI5Miw3ICsyODEs
NiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKg
IMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAm
cXVvdDtJQk0mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDC
oCDCoCDCoD0gJnF1b3Q7UHJvRmlicmUgNDAwMFImcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQrCoCDCoCDCoCDCoCB9
LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBEUzQz
MDAgLyBGQVN0VDYwMCAqLzxicj4NCkBAIC00MjgsMTQgKzQxNiwxMiBAQCBzdGF0aWMgc3RydWN0
IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC8q
IERTNDIwMCAvIEZBU3RUMjAwICovPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRv
csKgIMKgIMKgIMKgID0gJnF1b3Q7SUJNJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O14zNTQyJnF1b3Q7LDxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJyPg0KwqAgwqAg
wqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LyogRW50ZXJwcmlzZSBTdG9yYWdlIFNlcnZlciAvIFNoYXJrIGZhbWlseSAqLzxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDte
MjEwNSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9
IE5PX1BBVEhfUkVUUllfUVVFVUUsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBncG9s
aWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKg
IMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBEUzYwMDAgKi88YnI+DQpAQCAt
NDUxLDcgKzQzNyw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7SUJN
JnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9
ICZxdW90O14yMTA3OTAwJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19w
YXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9RVUVVRSw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJy
Pg0KwqAgwqAgwqAgwqAgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC8qIFN0b3J3aXpl
IGZhbWlseSAvIFNBTiBWb2x1bWUgQ29udHJvbGxlciAvIEZsZXggU3lzdGVtIFY3MDAwICovPGJy
Pg0KQEAgLTQ2OCw3ICs0NTMsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1td
ID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ibF9wcm9kdWN0wqAgwqAgPSAmcXVv
dDtTLzM5MCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudWlkX2F0dHJpYnV0
ZSA9ICZxdW90O0lEX1VJRCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9f
cGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfUVVFVUUsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQrCoCDCoCDCoCDCoCB9LDxi
cj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAg
wqAgwqAgwqAgPSAmcXVvdDtJQk0mcXVvdDssPGJyPg0KQEAgLTQ3Niw3ICs0NjAsNiBAQCBzdGF0
aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5ibF9wcm9kdWN0wqAgwqAgPSAmcXVvdDtTLzM5MCZxdW90Oyw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAudWlkX2F0dHJpYnV0ZSA9ICZxdW90O0lEX1VJRCZxdW90Oyw8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllf
UVVFVUUsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBncG9saWN5wqAgwqAgwqAgPSBN
VUxUSUJVUyw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBQb3dlciBSQUlEICovPGJyPg0KQEAgLTUwMiw3ICs0ODUs
NiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDsyODEw
WElWJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0g
Tk9fUEFUSF9SRVRSWV9RVUVVRSw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdwb2xp
Y3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLyo8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCogSUJNIFBv
d2VyIFZpcnR1YWwgU0NTSSBEZXZpY2VzPGJyPg0KQEAgLTUxMyw3ICs0OTUsNiBAQCBzdGF0aWMg
c3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtBSVgmcXVv
dDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1
b3Q7VkRBU0QmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBncG9saWN5wqAg
wqAgwqAgPSBNVUxUSUJVUyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9y
ZXRyeSA9ICgzMDAgLyBERUZBVUxUX0NIRUNLSU5UKSw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4N
CsKgIMKgIMKgIMKgIHs8YnI+DQpAQCAtNTIxLDYgKzUwMiw3IEBAIHN0YXRpYyBzdHJ1Y3QgaHdl
bnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRv
csKgIMKgIMKgIMKgID0gJnF1b3Q7SUJNJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90OzMzMDNbIF0rTlZESVNLJnF1b3Q7LDxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gKDMwMCAvIERFRkFVTFRf
Q0hFQ0tJTlQpLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ3BvbGljecKgIMKgIMKg
ID0gRkFJTE9WRVIsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7QUlYJnF1
b3Q7LDxicj4NCkBAIC01ODcsNyArNTY5LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1
bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7U0dJJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O1RQOTEwMCZxdW90Oyw8YnI+
DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxi
cj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O1NHSSZxdW90Oyw8YnI+DQpAQCAt
Njc3LDcgKzY1OCw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJy
Pg0KwqAgwqAgwqAgwqAgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDC
oCDCoCDCoCA9ICZxdW90O1NVTiZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAu
cHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDsoU3RvckVkZ2UgMzUxMHxUNCkmcXVvdDssPGJyPg0K
LcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+
DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtTVU4mcXVvdDssPGJyPg0KQEAgLTcz
OSw3ICs3MTksNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O1BJVk9U
MyZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKg
PSAmcXVvdDtSQUlHRSBWT0xVTUUmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
Lm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1FVRVVFLDxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJyPg0KwqAgwqAgwqAgwqAg
fSw8YnI+DQrCoCDCoCDCoCDCoCAvKjxicj4NCsKgIMKgIMKgIMKgIMKgKiBJbnRlbDxicj4NCkBA
IC03OTAsNyArNzY5LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8
YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKg
IMKgIMKgIMKgID0gJnF1b3Q7UFVSRSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtGbGFzaEFycmF5JnF1b3Q7LDxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLmZhc3RfaW9fZmFpbMKgID0gMTAsPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLmRldl9sb3NzwqAgwqAgwqAgPSA2MCw8YnI+DQrCoCDCoCDCoCDCoCB9
LDxicj4NCkBAIC04MDEsNyArNzc5LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRf
aHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBPY2VhblN0b3IgVjMgKi88
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDso
SFVBV0VJfEhVQVNZKSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVj
dMKgIMKgIMKgIMKgPSAmcXVvdDtYU0cxJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+
DQrCoCDCoCDCoCDCoCAvKjxicj4NCsKgIMKgIMKgIMKgIMKgKiBSZWQgSGF0PGJyPg0KQEAgLTgy
Miw3ICs3OTksNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4N
CsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAg
wqAgwqAgPSAmcXVvdDtLT1ZFJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5w
cm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O1hQRCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCsKgIMKgIMKgIMKgIH0s
PGJyPg0KwqAjaWYgMDxicj4NCsKgIMKgIMKgIMKgIC8qPGJyPg0KQEAgLTg0NCw3ICs4MjAsNyBA
QCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O1BST0RVQ1QmcXVvdDssPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnJldmlzaW9uwqAgwqAgwqAgPSAmcXVvdDtSRVZJ
U0lPTiZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuYmxfcHJvZHVjdMKgIMKg
ID0gJnF1b3Q7QkxfUFJPRFVDVCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAu
cGdwb2xpY3nCoCDCoCDCoCA9IEZBSUxPVkVSLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnVpZF9hdHRyaWJ1dGUgPSAmcXVvdDtJRF9TRVJJQUwmcXVvdDssPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLnNlbGVjdG9ywqAgwqAgwqAgPSAmcXVvdDtzZXJ2aWNlLXRpbWUgMCZx
dW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuY2hlY2tlcl9uYW1lwqAgPSBUVVIs
PGJyPg0KZGlmZiAtLWdpdCBhL211bHRpcGF0aC9tdWx0aXBhdGguY29uZi41IGIvbXVsdGlwYXRo
L211bHRpcGF0aC5jb25mLjU8YnI+DQppbmRleCA0NjZhZDk0Li44YzBiNDdhIDEwMDY0NDxicj4N
Ci0tLSBhL211bHRpcGF0aC9tdWx0aXBhdGguY29uZi41PGJyPg0KKysrIGIvbXVsdGlwYXRoL211
bHRpcGF0aC5jb25mLjU8YnI+DQpAQCAtMjA0LDcgKzIwNCw3IEBAIHBlci1tdWx0aXBhdGggb3B0
aW9uIGluIHRoZSBjb25maWd1cmF0aW9uIGZpbGUuPGJyPg0KwqBPbmUgcHJpb3JpdHkgZ3JvdXAg
cGVyIHRhcmdldCBub2RlIG5hbWUuIFRhcmdldCBub2RlIG5hbWVzIGFyZSBmZXRjaGVkPGJyPg0K
wqBpbiBcZkkvc3lzL2NsYXNzL2ZjX3RyYW5zcG9ydC88d2JyPnRhcmdldCovbm9kZV9uYW1lXGZS
Ljxicj4NCsKgLlRQPGJyPg0KLURlZmF1bHQgdmFsdWUgaXM6IFxmQmZhaWxvdmVyXGZSPGJyPg0K
K0RlZmF1bHQgdmFsdWUgaXM6IFxmQm11bHRpYnVzXGZSPGJyPg0KwqAuUkU8YnI+DQrCoC48YnI+
DQrCoC48YnI+DQo8c3BhbiBjbGFzcz0iSE9FblpiIj48Zm9udCBjb2xvcj0iIzg4ODg4OCI+LS08
YnI+DQoyLjcuNDxicj4NCjxicj4NCjwvZm9udD48L3NwYW4+PC9ibG9ja3F1b3RlPjwvZGl2Pjxi
cj48L2Rpdj4NCg==
--001a11471dee6926b0053df3fd15--


--===============6327225869831125782==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6327225869831125782==--
