From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: move up TEMPLATE in hwtable
Date: Thu, 3 Aug 2017 08:38:02 +0200
Message-ID: <CABr-GncPDYjMNKG_XSPqfR7zPe4_hGVUyDa+GttJtRO4XiXqvA@mail.gmail.com>
References: <20170623211351.31830-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0218441540998860450=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170623211351.31830-1-xose.vazquez@gmail.com>
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

--===============0218441540998860450==
Content-Type: multipart/alternative; boundary="001a113d5f8a4ca9650555d39fc8"

--001a113d5f8a4ca9650555d39fc8
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Fri, Jun 23, 2017 at 11:13 PM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> and the 'MD Series' comment to the right place.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 98 +++++++++++++++++++++++++-----
> --------------------
>  1 file changed, 50 insertions(+), 48 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 390d143..a77da7e 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -26,6 +26,55 @@
>   * Moreover, if a device needs a special treatment by the SCSI
>   * subsystem it should be included in drivers/scsi/scsi_devinfo.c
>   */
> +
> +#if 0
> +       /*
> +        * Copy this TEMPLATE to add new hardware.
> +        *
> +        * Keep only mandatory(.vendor and .product) and modified
> attributes.
> +        * Attributes with default values must be removed.
> +        * .vendor, .product, .revision and .bl_product are POSIX Extended
> regex.
> +        *
> +        * COMPANY_NAME
> +        *
> +        * Maintainer : XXX
> +        * Mail : XXX
> +        */
> +       {
> +               /* If product-ID is different from marketing name add a
> comment */
> +               .vendor        = "VENDOR",
> +               .product       = "PRODUCT",
> +               .revision      = "REVISION",
> +               .bl_product    = "BL_PRODUCT",
> +               .pgpolicy      = FAILOVER,
> +               .uid_attribute = "ID_SERIAL",
> +               .selector      = "service-time 0",
> +               .checker_name  = TUR,
> +               .alias_prefix  = "mpath",
> +               .features      = "0",
> +               .hwhandler     = "0",
> +               .prio_name     = PRIO_CONST,
> +               .prio_args     = "",
> +               .pgfailback    = -FAILBACK_MANUAL,
> +               .rr_weight     = RR_WEIGHT_NONE,
> +               .no_path_retry = NO_PATH_RETRY_UNDEF,
> +               .minio         = 1000,
> +               .minio_rq      = 1,
> +               .flush_on_last_del = FLUSH_DISABLED,
> +               .user_friendly_names = USER_FRIENDLY_NAMES_OFF,
> +               .fast_io_fail  = 5,
> +               .dev_loss      = 600,
> +               .retain_hwhandler = RETAIN_HWHANDLER_ON,
> +               .detect_prio   = DETECT_PRIO_ON,
> +               .detect_checker = DETECT_CHECKER_ON,
> +               .deferred_remove = DEFERRED_REMOVE_OFF,
> +               .delay_watch_checks = DELAY_CHECKS_OFF,
> +               .delay_wait_checks = DELAY_CHECKS_OFF,
> +               .skip_kpartx   = SKIP_KPARTX_OFF,
> +               .max_sectors_kb = MAX_SECTORS_KB_UNDEF,
> +       },
> +#endif
> +
>  static struct hwentry default_hw[] = {
>         /*
>          * Apple
> @@ -224,8 +273,8 @@ static struct hwentry default_hw[] = {
>                 .pgpolicy      = MULTIBUS,
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>         },
> -               /* MD Series */
>         {
> +               /* MD Series */
>                 .vendor        = "DELL",
>                 .product       = "^MD3",
>                 .bl_product    = "Universal Xport",
> @@ -1059,53 +1108,6 @@ static struct hwentry default_hw[] = {
>                 .checker_name  = DIRECTIO,
>                 .retain_hwhandler = RETAIN_HWHANDLER_OFF,
>         },
> -#if 0
> -       /*
> -        * Copy this TEMPLATE to add new hardware.
> -        *
> -        * Keep only mandatory(.vendor and .product) and modified
> attributes.
> -        * Attributes with default values must be removed.
> -        * .vendor, .product, .revision and .bl_product are POSIX Extended
> regex.
> -        *
> -        * COMPANY_NAME
> -        *
> -        * Maintainer : XXX
> -        * Mail : XXX
> -        */
> -       {
> -               /* If product-ID is different from marketing name add a
> comment */
> -               .vendor        = "VENDOR",
> -               .product       = "PRODUCT",
> -               .revision      = "REVISION",
> -               .bl_product    = "BL_PRODUCT",
> -               .pgpolicy      = FAILOVER,
> -               .uid_attribute = "ID_SERIAL",
> -               .selector      = "service-time 0",
> -               .checker_name  = TUR,
> -               .alias_prefix  = "mpath",
> -               .features      = "0",
> -               .hwhandler     = "0",
> -               .prio_name     = PRIO_CONST,
> -               .prio_args     = "",
> -               .pgfailback    = -FAILBACK_MANUAL,
> -               .rr_weight     = RR_WEIGHT_NONE,
> -               .no_path_retry = NO_PATH_RETRY_UNDEF,
> -               .minio         = 1000,
> -               .minio_rq      = 1,
> -               .flush_on_last_del = FLUSH_DISABLED,
> -               .user_friendly_names = USER_FRIENDLY_NAMES_OFF,
> -               .fast_io_fail  = 5,
> -               .dev_loss      = 600,
> -               .retain_hwhandler = RETAIN_HWHANDLER_ON,
> -               .detect_prio   = DETECT_PRIO_ON,
> -               .detect_checker = DETECT_CHECKER_ON,
> -               .deferred_remove = DEFERRED_REMOVE_OFF,
> -               .delay_watch_checks = DELAY_CHECKS_OFF,
> -               .delay_wait_checks = DELAY_CHECKS_OFF,
> -               .skip_kpartx = SKIP_KPARTX_OFF,
> -               .max_sectors_kb = MAX_SECTORS_KB_UNDEF,
> -       },
> -#endif
>         /*
>          * EOL
>          */
> --
> 2.13.1
>

--001a113d5f8a4ca9650555d39fc8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+TWVyZ2VkLjxkaXY+VGhhbmtzLjwvZGl2PjwvZGl2PjxkaXYgY2xhc3M9
ImdtYWlsX2V4dHJhIj48YnI+PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIEZyaSwgSnVuIDIz
LCAyMDE3IGF0IDExOjEzIFBNLCBYb3NlIFZhenF1ZXogUGVyZXogPHNwYW4gZGlyPSJsdHIiPiZs
dDs8YSBocmVmPSJtYWlsdG86eG9zZS52YXpxdWV6QGdtYWlsLmNvbSIgdGFyZ2V0PSJfYmxhbmsi
Pnhvc2UudmF6cXVlekBnbWFpbC5jb208L2E+Jmd0Ozwvc3Bhbj4gd3JvdGU6PGJyPjxibG9ja3F1
b3RlIGNsYXNzPSJnbWFpbF9xdW90ZSIgc3R5bGU9Im1hcmdpbjowIDAgMCAuOGV4O2JvcmRlci1s
ZWZ0OjFweCAjY2NjIHNvbGlkO3BhZGRpbmctbGVmdDoxZXgiPmFuZCB0aGUgJiMzOTtNRCBTZXJp
ZXMmIzM5OyBjb21tZW50IHRvIHRoZSByaWdodCBwbGFjZS48YnI+DQo8YnI+DQpDYzogQ2hyaXN0
b3BoZSBWYXJvcXVpICZsdDs8YSBocmVmPSJtYWlsdG86Y2hyaXN0b3BoZS52YXJvcXVpQG9wZW5z
dmMuY29tIj5jaHJpc3RvcGhlLnZhcm9xdWlAb3BlbnN2Yy48d2JyPmNvbTwvYT4mZ3Q7PGJyPg0K
Q2M6IGRldmljZS1tYXBwZXIgZGV2ZWxvcG1lbnQgJmx0OzxhIGhyZWY9Im1haWx0bzpkbS1kZXZl
bEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPiZndDs8YnI+DQpTaWduZWQtb2Zm
LWJ5OiBYb3NlIFZhenF1ZXogUGVyZXogJmx0OzxhIGhyZWY9Im1haWx0bzp4b3NlLnZhenF1ZXpA
Z21haWwuY29tIj54b3NlLnZhenF1ZXpAZ21haWwuY29tPC9hPiZndDs8YnI+DQotLS08YnI+DQrC
oGxpYm11bHRpcGF0aC9od3RhYmxlLmMgfCA5OCArKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS08d2JyPi0tLS0tLS0tLS0tLS0tLS0tLS0tPGJyPg0KwqAxIGZpbGUgY2hhbmdlZCwgNTAgaW5z
ZXJ0aW9ucygrKSwgNDggZGVsZXRpb25zKC0pPGJyPg0KPGJyPg0KZGlmZiAtLWdpdCBhL2xpYm11
bHRpcGF0aC9od3RhYmxlLmMgYi9saWJtdWx0aXBhdGgvaHd0YWJsZS5jPGJyPg0KaW5kZXggMzkw
ZDE0My4uYTc3ZGE3ZSAxMDA2NDQ8YnI+DQotLS0gYS9saWJtdWx0aXBhdGgvaHd0YWJsZS5jPGJy
Pg0KKysrIGIvbGlibXVsdGlwYXRoL2h3dGFibGUuYzxicj4NCkBAIC0yNiw2ICsyNiw1NSBAQDxi
cj4NCsKgICogTW9yZW92ZXIsIGlmIGEgZGV2aWNlIG5lZWRzIGEgc3BlY2lhbCB0cmVhdG1lbnQg
YnkgdGhlIFNDU0k8YnI+DQrCoCAqIHN1YnN5c3RlbSBpdCBzaG91bGQgYmUgaW5jbHVkZWQgaW4g
ZHJpdmVycy9zY3NpL3Njc2lfZGV2aW5mby5jPGJyPg0KwqAgKi88YnI+DQorPGJyPg0KKyNpZiAw
PGJyPg0KK8KgIMKgIMKgIMKgLyo8YnI+DQorwqAgwqAgwqAgwqAgKiBDb3B5IHRoaXMgVEVNUExB
VEUgdG8gYWRkIG5ldyBoYXJkd2FyZS48YnI+DQorwqAgwqAgwqAgwqAgKjxicj4NCivCoCDCoCDC
oCDCoCAqIEtlZXAgb25seSBtYW5kYXRvcnkoLnZlbmRvciBhbmQgLnByb2R1Y3QpIGFuZCBtb2Rp
ZmllZCBhdHRyaWJ1dGVzLjxicj4NCivCoCDCoCDCoCDCoCAqIEF0dHJpYnV0ZXMgd2l0aCBkZWZh
dWx0IHZhbHVlcyBtdXN0IGJlIHJlbW92ZWQuPGJyPg0KK8KgIMKgIMKgIMKgICogLnZlbmRvciwg
LnByb2R1Y3QsIC5yZXZpc2lvbiBhbmQgLmJsX3Byb2R1Y3QgYXJlIFBPU0lYIEV4dGVuZGVkIHJl
Z2V4Ljxicj4NCivCoCDCoCDCoCDCoCAqPGJyPg0KK8KgIMKgIMKgIMKgICogQ09NUEFOWV9OQU1F
PGJyPg0KK8KgIMKgIMKgIMKgICo8YnI+DQorwqAgwqAgwqAgwqAgKiBNYWludGFpbmVyIDogWFhY
PGJyPg0KK8KgIMKgIMKgIMKgICogTWFpbCA6IFhYWDxicj4NCivCoCDCoCDCoCDCoCAqLzxicj4N
CivCoCDCoCDCoCDCoHs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBJZiBwcm9kdWN0
LUlEIGlzIGRpZmZlcmVudCBmcm9tIG1hcmtldGluZyBuYW1lIGFkZCBhIGNvbW1lbnQgKi88YnI+
DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtWRU5E
T1ImcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByb2R1Y3TCoCDCoCDCoCDC
oD0gJnF1b3Q7UFJPRFVDVCZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucmV2
aXNpb27CoCDCoCDCoCA9ICZxdW90O1JFVklTSU9OJnF1b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC5ibF9wcm9kdWN0wqAgwqAgPSAmcXVvdDtCTF9QUk9EVUNUJnF1b3Q7LDxicj4N
CivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ3BvbGljecKgIMKgIMKgID0gRkFJTE9WRVIsPGJy
Pg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnVpZF9hdHRyaWJ1dGUgPSAmcXVvdDtJRF9TRVJJ
QUwmcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnNlbGVjdG9ywqAgwqAgwqAg
PSAmcXVvdDtzZXJ2aWNlLXRpbWUgMCZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAuY2hlY2tlcl9uYW1lwqAgPSBUVVIsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmFs
aWFzX3ByZWZpeMKgID0gJnF1b3Q7bXBhdGgmcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgLmZlYXR1cmVzwqAgwqAgwqAgPSAmcXVvdDswJnF1b3Q7LDxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoC5od2hhbmRsZXLCoCDCoCDCoD0gJnF1b3Q7MCZxdW90Oyw8YnI+DQorwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IFBSSU9fQ09OU1QsPGJyPg0K
K8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByaW9fYXJnc8KgIMKgIMKgPSAmcXVvdDsmcXVvdDss
PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBnZmFpbGJhY2vCoCDCoCA9IC1GQUlMQkFD
S19NQU5VQUwsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnJyX3dlaWdodMKgIMKgIMKg
PSBSUl9XRUlHSFRfTk9ORSw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAubm9fcGF0aF9y
ZXRyeSA9IE5PX1BBVEhfUkVUUllfVU5ERUYsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
Lm1pbmlvwqAgwqAgwqAgwqAgwqA9IDEwMDAsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
Lm1pbmlvX3JxwqAgwqAgwqAgPSAxLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mbHVz
aF9vbl9sYXN0X2RlbCA9IEZMVVNIX0RJU0FCTEVELDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC51c2VyX2ZyaWVuZGx5X25hbWVzID0gVVNFUl9GUklFTkRMWV9OQU1FU19PRkYsPGJyPg0K
K8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmZhc3RfaW9fZmFpbMKgID0gNSw8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAuZGV2X2xvc3PCoCDCoCDCoCA9IDYwMCw8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAucmV0YWluX2h3aGFuZGxlciA9IFJFVEFJTl9IV0hBTkRMRVJfT04sPGJy
Pg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmRldGVjdF9wcmlvwqAgwqA9IERFVEVDVF9QUklP
X09OLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5kZXRlY3RfY2hlY2tlciA9IERFVEVD
VF9DSEVDS0VSX09OLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5kZWZlcnJlZF9yZW1v
dmUgPSBERUZFUlJFRF9SRU1PVkVfT0ZGLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5k
ZWxheV93YXRjaF9jaGVja3MgPSBERUxBWV9DSEVDS1NfT0ZGLDxicj4NCivCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoC5kZWxheV93YWl0X2NoZWNrcyA9IERFTEFZX0NIRUNLU19PRkYsPGJyPg0KK8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgLnNraXBfa3BhcnR4wqAgwqA9IFNLSVBfS1BBUlRYX09GRiw8
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAubWF4X3NlY3RvcnNfa2IgPSBNQVhfU0VDVE9S
U19LQl9VTkRFRiw8YnI+DQorwqAgwqAgwqAgwqB9LDxicj4NCisjZW5kaWY8YnI+DQorPGJyPg0K
wqBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKg
IC8qPGJyPg0KwqAgwqAgwqAgwqAgwqAqIEFwcGxlPGJyPg0KQEAgLTIyNCw4ICsyNzMsOCBAQCBz
dGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1FVRVVFLDxicj4NCsKg
IMKgIMKgIMKgIH0sPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLyogTUQgU2VyaWVzICov
PGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC8qIE1EIFNl
cmllcyAqLzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9
ICZxdW90O0RFTEwmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TC
oCDCoCDCoCDCoD0gJnF1b3Q7Xk1EMyZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAuYmxfcHJvZHVjdMKgIMKgID0gJnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1b3Q7LDxicj4NCkBA
IC0xMDU5LDUzICsxMTA4LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9
IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAuY2hlY2tlcl9uYW1lwqAgPSBESVJFQ1RJ
Tyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucmV0YWluX2h3aGFuZGxlciA9IFJFVEFJ
Tl9IV0hBTkRMRVJfT0ZGLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KLSNpZiAwPGJyPg0KLcKg
IMKgIMKgIMKgLyo8YnI+DQotwqAgwqAgwqAgwqAgKiBDb3B5IHRoaXMgVEVNUExBVEUgdG8gYWRk
IG5ldyBoYXJkd2FyZS48YnI+DQotwqAgwqAgwqAgwqAgKjxicj4NCi3CoCDCoCDCoCDCoCAqIEtl
ZXAgb25seSBtYW5kYXRvcnkoLnZlbmRvciBhbmQgLnByb2R1Y3QpIGFuZCBtb2RpZmllZCBhdHRy
aWJ1dGVzLjxicj4NCi3CoCDCoCDCoCDCoCAqIEF0dHJpYnV0ZXMgd2l0aCBkZWZhdWx0IHZhbHVl
cyBtdXN0IGJlIHJlbW92ZWQuPGJyPg0KLcKgIMKgIMKgIMKgICogLnZlbmRvciwgLnByb2R1Y3Qs
IC5yZXZpc2lvbiBhbmQgLmJsX3Byb2R1Y3QgYXJlIFBPU0lYIEV4dGVuZGVkIHJlZ2V4Ljxicj4N
Ci3CoCDCoCDCoCDCoCAqPGJyPg0KLcKgIMKgIMKgIMKgICogQ09NUEFOWV9OQU1FPGJyPg0KLcKg
IMKgIMKgIMKgICo8YnI+DQotwqAgwqAgwqAgwqAgKiBNYWludGFpbmVyIDogWFhYPGJyPg0KLcKg
IMKgIMKgIMKgICogTWFpbCA6IFhYWDxicj4NCi3CoCDCoCDCoCDCoCAqLzxicj4NCi3CoCDCoCDC
oCDCoHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAvKiBJZiBwcm9kdWN0LUlEIGlzIGRp
ZmZlcmVudCBmcm9tIG1hcmtldGluZyBuYW1lIGFkZCBhIGNvbW1lbnQgKi88YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtWRU5ET1ImcXVvdDss
PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7
UFJPRFVDVCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucmV2aXNpb27CoCDC
oCDCoCA9ICZxdW90O1JFVklTSU9OJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oC5ibF9wcm9kdWN0wqAgwqAgPSAmcXVvdDtCTF9QUk9EVUNUJnF1b3Q7LDxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoC5wZ3BvbGljecKgIMKgIMKgID0gRkFJTE9WRVIsPGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLnVpZF9hdHRyaWJ1dGUgPSAmcXVvdDtJRF9TRVJJQUwmcXVvdDss
PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnNlbGVjdG9ywqAgwqAgwqAgPSAmcXVvdDtz
ZXJ2aWNlLXRpbWUgMCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuY2hlY2tl
cl9uYW1lwqAgPSBUVVIsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmFsaWFzX3ByZWZp
eMKgID0gJnF1b3Q7bXBhdGgmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmZl
YXR1cmVzwqAgwqAgwqAgPSAmcXVvdDswJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC5od2hhbmRsZXLCoCDCoCDCoD0gJnF1b3Q7MCZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IFBSSU9fQ09OU1QsPGJyPg0KLcKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgLnByaW9fYXJnc8KgIMKgIMKgPSAmcXVvdDsmcXVvdDssPGJyPg0KLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBnZmFpbGJhY2vCoCDCoCA9IC1GQUlMQkFDS19NQU5VQUws
PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnJyX3dlaWdodMKgIMKgIMKgPSBSUl9XRUlH
SFRfTk9ORSw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAubm9fcGF0aF9yZXRyeSA9IE5P
X1BBVEhfUkVUUllfVU5ERUYsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLm1pbmlvwqAg
wqAgwqAgwqAgwqA9IDEwMDAsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLm1pbmlvX3Jx
wqAgwqAgwqAgPSAxLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5mbHVzaF9vbl9sYXN0
X2RlbCA9IEZMVVNIX0RJU0FCTEVELDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC51c2Vy
X2ZyaWVuZGx5X25hbWVzID0gVVNFUl9GUklFTkRMWV9OQU1FU19PRkYsPGJyPg0KLcKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgLmZhc3RfaW9fZmFpbMKgID0gNSw8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAuZGV2X2xvc3PCoCDCoCDCoCA9IDYwMCw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAucmV0YWluX2h3aGFuZGxlciA9IFJFVEFJTl9IV0hBTkRMRVJfT04sPGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLmRldGVjdF9wcmlvwqAgwqA9IERFVEVDVF9QUklPX09OLDxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5kZXRlY3RfY2hlY2tlciA9IERFVEVDVF9DSEVDS0VS
X09OLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5kZWZlcnJlZF9yZW1vdmUgPSBERUZF
UlJFRF9SRU1PVkVfT0ZGLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5kZWxheV93YXRj
aF9jaGVja3MgPSBERUxBWV9DSEVDS1NfT0ZGLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oC5kZWxheV93YWl0X2NoZWNrcyA9IERFTEFZX0NIRUNLU19PRkYsPGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgLnNraXBfa3BhcnR4ID0gU0tJUF9LUEFSVFhfT0ZGLDxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoC5tYXhfc2VjdG9yc19rYiA9IE1BWF9TRUNUT1JTX0tCX1VOREVGLDxi
cj4NCi3CoCDCoCDCoCDCoH0sPGJyPg0KLSNlbmRpZjxicj4NCsKgIMKgIMKgIMKgIC8qPGJyPg0K
wqAgwqAgwqAgwqAgwqAqIEVPTDxicj4NCsKgIMKgIMKgIMKgIMKgKi88YnI+DQo8c3BhbiBjbGFz
cz0iSE9FblpiIj48Zm9udCBjb2xvcj0iIzg4ODg4OCI+LS08YnI+DQoyLjEzLjE8YnI+DQo8L2Zv
bnQ+PC9zcGFuPjwvYmxvY2txdW90ZT48L2Rpdj48YnI+PC9kaXY+DQo=
--001a113d5f8a4ca9650555d39fc8--


--===============0218441540998860450==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0218441540998860450==--
