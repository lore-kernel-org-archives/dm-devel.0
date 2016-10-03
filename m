From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 3/4] multipath-tools: change default failback
 from manual to undefined
Date: Mon, 3 Oct 2016 13:29:27 +0200
Message-ID: <CABr-Gnf0TqViwJ2a83GFqbbAWH351v+sKTbus4qeEZs3KTNyFg@mail.gmail.com>
References: <1471543096-11441-1-git-send-email-xose.vazquez@gmail.com>
	<1471543096-11441-3-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2924284723910108029=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471543096-11441-3-git-send-email-xose.vazquez@gmail.com>
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

--===============2924284723910108029==
Content-Type: multipart/alternative; boundary=001a11408126c384a0053df44177

--001a11408126c384a0053df44177
Content-Type: text/plain; charset=UTF-8

Wouldn't it be nicer to keep manual as the default and remove all
FAILBACK_UNDEF from the hwtable ?

In the current code base, FAILBACK_UNDEF causes need_switch_pathgroup() to
refresh each path prio and mpp->bestpg, and return to the caller it should
switch pathgroup. But the caller (check_path()) won't switch anyway.

As I read it FAILBACK_UNDEF never fails back automatically, like
FAILBACK_MANUAL, but causes unecessary work.

Hannes, Ben, do you confirm I read correctly ? Would you ack to removal of
FAILBACK_UNDEF from the hwtable ?

Regards,
Christophe Varoqui
OpenSVC

On Thu, Aug 18, 2016 at 7:58 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Default value is: manual
>      30                 .pgfailback    = FAILBACK_UNDEF,
>      45                 .pgfailback    = -FAILBACK_IMMEDIATE,
> manual is not used by any device.
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
>  libmultipath/hwtable.c     | 32 +-------------------------------
>  multipath/multipath.conf.5 |  8 +++++++-
>  3 files changed, 9 insertions(+), 33 deletions(-)
>
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index 9bf27d6..a7c74fe 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -12,7 +12,7 @@
>  #define DEFAULT_MINIO          1000
>  #define DEFAULT_MINIO_RQ       1
>  #define DEFAULT_PGPOLICY       FAILOVER
> -#define DEFAULT_FAILBACK       -FAILBACK_MANUAL
> +#define DEFAULT_FAILBACK       FAILBACK_UNDEF
>  #define DEFAULT_RR_WEIGHT      RR_WEIGHT_NONE
>  #define DEFAULT_NO_PATH_RETRY  NO_PATH_RETRY_UNDEF
>  #define DEFAULT_VERBOSITY      2
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 72b5e1d..c4037d5 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -37,7 +37,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "APPLE",
>                 .product       = "Xserve RAID",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         /*
>          * HPE
> @@ -58,7 +57,6 @@ static struct hwentry default_hw[] = {
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>                 .hwhandler     = "1 hp_sw",
>                 .pgpolicy      = GROUP_BY_PRIO,
> -               .pgfailback    = FAILBACK_UNDEF,
>                 .checker_name  = HP_SW,
>                 .prio_name     = PRIO_HP_SW,
>         },
> @@ -67,7 +65,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "HP",
>                 .product       = "A6189A",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>                 .no_path_retry = 12,
>         },
>         {
> @@ -76,7 +73,6 @@ static struct hwentry default_hw[] = {
>                 .product       = "(MSA|HSV)1[01]0",
>                 .hwhandler     = "1 hp_sw",
>                 .pgpolicy      = GROUP_BY_PRIO,
> -               .pgfailback    = FAILBACK_UNDEF,
>                 .no_path_retry = 12,
>                 .checker_name  = HP_SW,
>                 .prio_name     = PRIO_HP_SW,
> @@ -104,7 +100,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "HP",
>                 .product       = "(MSA2[02]12fc|MSA2012i)",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>                 .no_path_retry = 18,
>         },
>         {
> @@ -140,7 +135,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "HP",
>                 .product       = "LOGICAL VOLUME",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>                 .no_path_retry = 12,
>         },
>         {
> @@ -159,7 +153,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "DDN",
>                 .product       = "SAN DataDirector",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         /*
>          * EMC
> @@ -169,7 +162,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "EMC",
>                 .product       = "SYMMETRIX",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>                 .no_path_retry = 6,
>         },
>         {
> @@ -190,14 +182,12 @@ static struct hwentry default_hw[] = {
>                 .product       = "Invista",
>                 .bl_product    = "LUNZ",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>                 .no_path_retry = 5,
>         },
>         {
>                 .vendor        = "XtremIO",
>                 .product       = "XtremApp",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         /*
>          * DELL
> @@ -212,7 +202,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "COMPELNT",
>                 .product       = "Compellent Vol",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>         },
>         {
> @@ -258,7 +247,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "FSC",
>                 .product       = "CentricStor",
>                 .pgpolicy      = GROUP_BY_SERIAL,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
>                 .vendor        = "FUJITSU",
> @@ -273,7 +261,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "(EUROLOGC|EuroLogc)",
>                 .product       = "FC2502",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         /*
>          * Hitachi
> @@ -286,7 +273,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "(HITACHI|HP)",
>                 .product       = "^OPEN-",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
>                 /* AMS 2000 and HUS 100 families */
> @@ -307,7 +293,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "ProFibre 4000R",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
>                 /* DS4300 / FAStT600 */
> @@ -444,7 +429,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "IBM",
>                 .product       = "^3542",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
>                 /* Enterprise Storage Server / Shark family */
> @@ -452,7 +436,6 @@ static struct hwentry default_hw[] = {
>                 .product       = "^2105",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
>                 /* DS6000 */
> @@ -469,7 +452,6 @@ static struct hwentry default_hw[] = {
>                 .product       = "^2107900",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
>                 /* Storwize family / SAN Volume Controller / Flex System
> V7000 */
> @@ -487,7 +469,6 @@ static struct hwentry default_hw[] = {
>                 .uid_attribute = "ID_UID",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
>                 .vendor        = "IBM",
> @@ -496,7 +477,6 @@ static struct hwentry default_hw[] = {
>                 .uid_attribute = "ID_UID",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
>                 /* Power RAID */
> @@ -523,7 +503,6 @@ static struct hwentry default_hw[] = {
>                 .product       = "2810XIV",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>                 /*
>                  * IBM Power Virtual SCSI Devices
> @@ -535,14 +514,12 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "AIX",
>                 .product       = "VDASD",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>                 .no_path_retry = (300 / DEFAULT_CHECKINT),
>         },
>         {
>                 /* 3303 NVDISK */
>                 .vendor        = "IBM",
>                 .product       = "3303[ ]+NVDISK",
> -               .pgfailback    = FAILBACK_UNDEF,
>                 .no_path_retry = (300 / DEFAULT_CHECKINT),
>         },
>         {
> @@ -602,7 +579,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "NEXENTA",
>                 .product       = "COMSTAR",
>                 .pgpolicy      = GROUP_BY_SERIAL,
> -               .pgfailback    = FAILBACK_UNDEF,
>                 .no_path_retry = 30,
>         },
>         /*
> @@ -612,7 +588,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "SGI",
>                 .product       = "TP9100",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
>                 .vendor        = "SGI",
> @@ -703,7 +678,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "SUN",
>                 .product       = "(StorEdge 3510|T4)",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
>                 .vendor        = "SUN",
> @@ -766,7 +740,6 @@ static struct hwentry default_hw[] = {
>                 .product       = "RAIGE VOLUME",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         /*
>          * Intel
> @@ -818,7 +791,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "PURE",
>                 .product       = "FlashArray",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>                 .fast_io_fail  = 10,
>                 .dev_loss      = 60,
>         },
> @@ -830,7 +802,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "(HUAWEI|HUASY)",
>                 .product       = "XSG1",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>         /*
>          * Red Hat
> @@ -852,7 +823,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "KOVE",
>                 .product       = "XPD",
>                 .pgpolicy      = MULTIBUS,
> -               .pgfailback    = FAILBACK_UNDEF,
>         },
>  #if 0
>         /*
> @@ -882,7 +852,7 @@ static struct hwentry default_hw[] = {
>                 .hwhandler     = "0",
>                 .prio_name     = "const",
>                 .prio_args     = "",
> -               .pgfailback    = -FAILBACK_MANUAL,
> +               .pgfailback    = FAILBACK_UNDEF,
>                 .rr_weight     = RR_WEIGHT_NONE,
>                 .no_path_retry = NO_PATH_RETRY_UNDEF,
>                 .minio         = 1000,
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 40df315..466ad94 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -422,6 +422,8 @@ Default value is: \fBmpath\fR
>  .TP
>  .B failback
>  Tell multipathd how to manage path group failback.
> +To select \fIimmediate\fR or a \fIvalue\fR, it's mandatory that the device
> +has support for a working prioritizer and a 'preferred path'.
>  .RS
>  .TP 12
>  .I immediate
> @@ -440,7 +442,11 @@ another node requested the failover.
>  .I values > 0
>  Deferred failback (time to defer in seconds).
>  .TP
> -Default value is: \fBmanual\fR
> +.\" XXX
> +.I <unset>
> +??? Undefined.
> +.TP
> +Default value is: \fB<unset>\fR
>  .RE
>  .
>  .
> --
> 2.7.4
>
>

--001a11408126c384a0053df44177
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+V291bGRuJiMzOTt0IGl0IGJlIG5pY2VyIHRvIGtlZXAgbWFudWFsIGFz
IHRoZSBkZWZhdWx0IGFuZCByZW1vdmUgYWxsIEZBSUxCQUNLX1VOREVGIGZyb20gdGhlIGh3dGFi
bGUgPzxkaXY+PGJyPjwvZGl2PjxkaXY+SW4gdGhlIGN1cnJlbnQgY29kZSBiYXNlLCBGQUlMQkFD
S19VTkRFRiBjYXVzZXPCoG5lZWRfc3dpdGNoX3BhdGhncm91cCgpIHRvIHJlZnJlc2ggZWFjaCBw
YXRoIHByaW8gYW5kIG1wcC0mZ3Q7YmVzdHBnLCBhbmQgcmV0dXJuIHRvIHRoZSBjYWxsZXIgaXQg
c2hvdWxkIHN3aXRjaCBwYXRoZ3JvdXAuIEJ1dCB0aGUgY2FsbGVyIChjaGVja19wYXRoKCkpIHdv
biYjMzk7dCBzd2l0Y2ggYW55d2F5LjwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+QXMgSSByZWFk
IGl0IEZBSUxCQUNLX1VOREVGIG5ldmVywqBmYWlscyBiYWNrIGF1dG9tYXRpY2FsbHksIGxpa2Ug
RkFJTEJBQ0tfTUFOVUFMLCBidXQgY2F1c2VzIHVuZWNlc3Nhcnkgd29yay48L2Rpdj48ZGl2Pjxi
cj48L2Rpdj48ZGl2Pkhhbm5lcywgQmVuLCBkbyB5b3UgY29uZmlybSBJIHJlYWQgY29ycmVjdGx5
ID8gV291bGQgeW91IGFjayB0byByZW1vdmFsIG9mIEZBSUxCQUNLX1VOREVGIGZyb20gdGhlIGh3
dGFibGUgPzwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+UmVnYXJkcyw8L2Rpdj48ZGl2PkNocmlz
dG9waGUgVmFyb3F1aTwvZGl2PjxkaXY+T3BlblNWQzwvZGl2PjwvZGl2PjxkaXYgY2xhc3M9Imdt
YWlsX2V4dHJhIj48YnI+PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIFRodSwgQXVnIDE4LCAy
MDE2IGF0IDc6NTggUE0sIFhvc2UgVmF6cXVleiBQZXJleiA8c3BhbiBkaXI9Imx0ciI+Jmx0Ozxh
IGhyZWY9Im1haWx0bzp4b3NlLnZhenF1ZXpAZ21haWwuY29tIiB0YXJnZXQ9Il9ibGFuayI+eG9z
ZS52YXpxdWV6QGdtYWlsLmNvbTwvYT4mZ3Q7PC9zcGFuPiB3cm90ZTo8YnI+PGJsb2NrcXVvdGUg
Y2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxlZnQ6
MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI+RGVmYXVsdCB2YWx1ZSBpczogbWFudWFs
PGJyPg0KwqAgwqAgwqAzMMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBnZmFpbGJhY2vCoCDC
oCA9IEZBSUxCQUNLX1VOREVGLDxicj4NCsKgIMKgIMKgNDXCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC5wZ2ZhaWxiYWNrwqAgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLDxicj4NCm1hbnVhbCBp
cyBub3QgdXNlZCBieSBhbnkgZGV2aWNlLjxicj4NCjxicj4NCkkgaG9wZSBpdCYjMzk7cyByZWFz
b25hYmxlLiBJZiBzb21lb25lIGRpc2FncmVlcywgZHJvcCBpdC48YnI+DQo8YnI+DQpDYzogSGFu
bmVzIFJlaW5lY2tlICZsdDs8YSBocmVmPSJtYWlsdG86aGFyZUBzdXNlLmRlIj5oYXJlQHN1c2Uu
ZGU8L2E+Jmd0Ozxicj4NCkNjOiBCZW5qYW1pbiBNYXJ6aW5za2kgJmx0OzxhIGhyZWY9Im1haWx0
bzpibWFyemluc0ByZWRoYXQuY29tIj5ibWFyemluc0ByZWRoYXQuY29tPC9hPiZndDs8YnI+DQpD
YzogQ2hyaXN0b3BoZSBWYXJvcXVpICZsdDs8YSBocmVmPSJtYWlsdG86Y2hyaXN0b3BoZS52YXJv
cXVpQG9wZW5zdmMuY29tIj5jaHJpc3RvcGhlLnZhcm9xdWlAb3BlbnN2Yy48d2JyPmNvbTwvYT4m
Z3Q7PGJyPg0KQ2M6IGRldmljZS1tYXBwZXIgZGV2ZWxvcG1lbnQgJmx0OzxhIGhyZWY9Im1haWx0
bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZlbEByZWRoYXQuY29tPC9hPiZndDs8YnI+DQpT
aWduZWQtb2ZmLWJ5OiBYb3NlIFZhenF1ZXogUGVyZXogJmx0OzxhIGhyZWY9Im1haWx0bzp4b3Nl
LnZhenF1ZXpAZ21haWwuY29tIj54b3NlLnZhenF1ZXpAZ21haWwuY29tPC9hPiZndDs8YnI+DQot
LS08YnI+DQrCoGxpYm11bHRpcGF0aC9kZWZhdWx0cy5owqAgwqAgfMKgIDIgKy08YnI+DQrCoGxp
Ym11bHRpcGF0aC9od3RhYmxlLmPCoCDCoCDCoHwgMzIgKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tPHdicj4tLTxicj4NCsKgbXVsdGlwYXRoL211bHRpcGF0aC5jb25mLjUgfMKgIDggKysr
KysrKy08YnI+DQrCoDMgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAzMyBkZWxldGlv
bnMoLSk8YnI+DQo8YnI+DQpkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL2RlZmF1bHRzLmggYi9s
aWJtdWx0aXBhdGgvZGVmYXVsdHMuaDxicj4NCmluZGV4IDliZjI3ZDYuLmE3Yzc0ZmUgMTAwNjQ0
PGJyPg0KLS0tIGEvbGlibXVsdGlwYXRoL2RlZmF1bHRzLmg8YnI+DQorKysgYi9saWJtdWx0aXBh
dGgvZGVmYXVsdHMuaDxicj4NCkBAIC0xMiw3ICsxMiw3IEBAPGJyPg0KwqAjZGVmaW5lIERFRkFV
TFRfTUlOSU/CoCDCoCDCoCDCoCDCoCAxMDAwPGJyPg0KwqAjZGVmaW5lIERFRkFVTFRfTUlOSU9f
UlHCoCDCoCDCoCDCoDE8YnI+DQrCoCNkZWZpbmUgREVGQVVMVF9QR1BPTElDWcKgIMKgIMKgIMKg
RkFJTE9WRVI8YnI+DQotI2RlZmluZSBERUZBVUxUX0ZBSUxCQUNLwqAgwqAgwqAgwqAtRkFJTEJB
Q0tfTUFOVUFMPGJyPg0KKyNkZWZpbmUgREVGQVVMVF9GQUlMQkFDS8KgIMKgIMKgIMKgRkFJTEJB
Q0tfVU5ERUY8YnI+DQrCoCNkZWZpbmUgREVGQVVMVF9SUl9XRUlHSFTCoCDCoCDCoCBSUl9XRUlH
SFRfTk9ORTxicj4NCsKgI2RlZmluZSBERUZBVUxUX05PX1BBVEhfUkVUUlnCoCBOT19QQVRIX1JF
VFJZX1VOREVGPGJyPg0KwqAjZGVmaW5lIERFRkFVTFRfVkVSQk9TSVRZwqAgwqAgwqAgMjxicj4N
CmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvaHd0YWJsZS5jIGIvbGlibXVsdGlwYXRoL2h3dGFi
bGUuYzxicj4NCmluZGV4IDcyYjVlMWQuLmM0MDM3ZDUgMTAwNjQ0PGJyPg0KLS0tIGEvbGlibXVs
dGlwYXRoL2h3dGFibGUuYzxicj4NCisrKyBiL2xpYm11bHRpcGF0aC9od3RhYmxlLmM8YnI+DQpA
QCAtMzcsNyArMzcsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0FQ
UExFJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAg
wqA9ICZxdW90O1hzZXJ2ZSBSQUlEJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgLnBnZmFpbGJhY2vCoCDCoCA9IEZBSUxCQUNLX1VOREVGLDxicj4NCsKgIMKgIMKgIMKgIH0s
PGJyPg0KwqAgwqAgwqAgwqAgLyo8YnI+DQrCoCDCoCDCoCDCoCDCoCogSFBFPGJyPg0KQEAgLTU4
LDcgKzU3LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfUVVF
VUUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLmh3aGFuZGxlcsKgIMKgIMKgPSAmcXVv
dDsxIGhwX3N3JnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKg
IMKgIMKgID0gR1JPVVBfQllfUFJJTyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdm
YWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLmNoZWNrZXJfbmFtZcKgID0gSFBfU1csPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
LnByaW9fbmFtZcKgIMKgIMKgPSBQUklPX0hQX1NXLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0K
QEAgLTY3LDcgKzY1LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8
YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtI
UCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKg
PSAmcXVvdDtBNjE4OUEmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9s
aWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdm
YWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLm5vX3BhdGhfcmV0cnkgPSAxMiw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKg
IMKgIHs8YnI+DQpAQCAtNzYsNyArNzMsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVs
dF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAg
wqA9ICZxdW90OyhNU0F8SFNWKTFbMDFdMCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEgaHBfc3cmcXVvdDssPGJyPg0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9QUklPLDxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRF
Riw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IDEyLDxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5jaGVja2VyX25hbWXCoCA9IEhQX1NXLDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19IUF9TVyw8YnI+
DQpAQCAtMTA0LDcgKzEwMCw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10g
PSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1
b3Q7SFAmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDC
oCDCoD0gJnF1b3Q7KE1TQTJbMDJdMTJmY3xNU0EyMDEyaSkmcXVvdDssPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLm5vX3BhdGhfcmV0cnkgPSAxOCw8YnI+DQrCoCDCoCDC
oCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQpAQCAtMTQwLDcgKzEzNSw2IEBAIHN0YXRp
YyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7SFAmcXVvdDssPGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7TE9HSUNBTCBWT0xVTUUm
cXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBN
VUxUSUJVUyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdmYWlsYmFja8KgIMKgID0g
RkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLm5vX3BhdGhfcmV0
cnkgPSAxMiw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQpAQCAt
MTU5LDcgKzE1Myw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7RERO
JnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9
ICZxdW90O1NBTiBEYXRhRGlyZWN0b3ImcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAg
fSw8YnI+DQrCoCDCoCDCoCDCoCAvKjxicj4NCsKgIMKgIMKgIMKgIMKgKiBFTUM8YnI+DQpAQCAt
MTY5LDcgKzE2Miw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7PGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7RU1D
JnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9
ICZxdW90O1NZTU1FVFJJWCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdw
b2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5w
Z2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAubm9fcGF0aF9yZXRyeSA9IDYsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDC
oCDCoCB7PGJyPg0KQEAgLTE5MCwxNCArMTgyLDEyIEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBk
ZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDC
oCDCoCDCoD0gJnF1b3Q7SW52aXN0YSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAuYmxfcHJvZHVjdMKgIMKgID0gJnF1b3Q7TFVOWiZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCi3CoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IDUsPGJyPg0KwqAgwqAgwqAgwqAg
fSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRv
csKgIMKgIMKgIMKgID0gJnF1b3Q7WHRyZW1JTyZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtYdHJlbUFwcCZxdW90Oyw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRF
Riw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIC8qPGJyPg0KwqAgwqAgwqAg
wqAgwqAqIERFTEw8YnI+DQpAQCAtMjEyLDcgKzIwMiw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRy
eSBkZWZhdWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKg
IMKgIMKgIMKgID0gJnF1b3Q7Q09NUEVMTlQmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7Q29tcGVsbGVudCBWb2wmcXVvdDssPGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tf
VU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLm5vX3BhdGhfcmV0cnkgPSBOT19Q
QVRIX1JFVFJZX1FVRVVFLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxi
cj4NCkBAIC0yNTgsNyArMjQ3LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdb
XSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAm
cXVvdDtGU0MmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDC
oCDCoCDCoD0gJnF1b3Q7Q2VudHJpY1N0b3ImcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBHUk9VUF9CWV9TRVJJQUwsPGJyPg0KLcKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgLnBnZmFpbGJhY2vCoCDCoCA9IEZBSUxCQUNLX1VOREVGLDxicj4NCsKg
IMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0ZVSklUU1UmcXVvdDssPGJyPg0KQEAgLTI3
Myw3ICsyNjEsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90OyhFVVJP
TE9HQ3xFdXJvTG9nYykmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1
Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7RkMyNTAyJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLnBnZmFpbGJhY2vCoCDCoCA9IEZBSUxCQUNLX1VOREVGLDxicj4NCsKgIMKgIMKg
IMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgLyo8YnI+DQrCoCDCoCDCoCDCoCDCoCogSGl0YWNoaTxi
cj4NCkBAIC0yODYsNyArMjczLDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdb
XSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAgwqAgPSAm
cXVvdDsoSElUQUNISXxIUCkmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBy
b2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7Xk9QRU4tJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgLnBnZmFpbGJhY2vCoCDCoCA9IEZBSUxCQUNLX1VOREVGLDxicj4NCsKgIMKg
IMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC8qIEFNUyAyMDAwIGFuZCBIVVMgMTAwIGZhbWlsaWVzICovPGJyPg0KQEAgLTMwNyw3ICsyOTMs
NiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtQcm9G
aWJyZSA0MDAwUiZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nC
oCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ2ZhaWxi
YWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKg
IMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBEUzQzMDAgLyBGQVN0VDYw
MCAqLzxicj4NCkBAIC00NDQsNyArNDI5LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1
bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudmVuZG9ywqAgwqAgwqAg
wqAgPSAmcXVvdDtJQk0mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1
Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7XjM1NDImcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAg
wqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLyog
RW50ZXJwcmlzZSBTdG9yYWdlIFNlcnZlciAvIFNoYXJrIGZhbWlseSAqLzxicj4NCkBAIC00NTIs
NyArNDM2LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDteMjEwNSZx
dW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IE5PX1BB
VEhfUkVUUllfUVVFVUUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAg
wqAgwqAgPSBNVUxUSUJVUyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdmYWlsYmFj
a8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDC
oCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLyogRFM2MDAwICovPGJyPg0KQEAg
LTQ2OSw3ICs0NTIsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxi
cj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O14y
MTA3OTAwJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5
ID0gTk9fUEFUSF9SRVRSWV9RVUVVRSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdw
b2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5w
Z2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4N
CsKgIMKgIMKgIMKgIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiBTdG9yd2l6ZSBm
YW1pbHkgLyBTQU4gVm9sdW1lIENvbnRyb2xsZXIgLyBGbGV4IFN5c3RlbSBWNzAwMCAqLzxicj4N
CkBAIC00ODcsNyArNDY5LDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9
IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAudWlkX2F0dHJpYnV0ZSA9ICZxdW90O0lE
X1VJRCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9
IE5PX1BBVEhfUkVUUllfUVVFVUUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9s
aWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdm
YWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrC
oCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKg
IMKgID0gJnF1b3Q7SUJNJnF1b3Q7LDxicj4NCkBAIC00OTYsNyArNDc3LDYgQEAgc3RhdGljIHN0
cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCAudWlkX2F0dHJpYnV0ZSA9ICZxdW90O0lEX1VJRCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9IE5PX1BBVEhfUkVUUllfUVVFVUUsPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYs
PGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLyogUG93ZXIgUkFJRCAqLzxicj4NCkBAIC01MjMsNyArNTAzLDYgQEAgc3Rh
dGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDsyODEwWElWJnF1b3Q7LDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9RVUVV
RSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJ
QlVTLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlM
QkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC8qPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAqIElCTSBQb3dlciBWaXJ0dWFs
IFNDU0kgRGV2aWNlczxicj4NCkBAIC01MzUsMTQgKzUxNCwxMiBAQCBzdGF0aWMgc3RydWN0IGh3
ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5k
b3LCoCDCoCDCoCDCoCA9ICZxdW90O0FJWCZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtWREFTRCZxdW90Oyw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAubm9fcGF0aF9yZXRyeSA9ICgzMDAgLyBERUZBVUxU
X0NIRUNLSU5UKSw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIHs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAvKiAzMzAzIE5WRElTSyAqLzxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDszMzAzWyBd
K05WRElTSyZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdmYWlsYmFja8Kg
IMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLm5vX3Bh
dGhfcmV0cnkgPSAoMzAwIC8gREVGQVVMVF9DSEVDS0lOVCksPGJyPg0KwqAgwqAgwqAgwqAgfSw8
YnI+DQrCoCDCoCDCoCDCoCB7PGJyPg0KQEAgLTYwMiw3ICs1NzksNiBAQCBzdGF0aWMgc3RydWN0
IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52
ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O05FWEVOVEEmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7Q09NU1RBUiZxdW90Oyw8YnI+
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IEdST1VQX0JZX1NF
UklBTCw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdmYWlsYmFja8KgIMKgID0gRkFJ
TEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLm5vX3BhdGhfcmV0cnkg
PSAzMCw8YnI+DQrCoCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIC8qPGJyPg0KQEAgLTYx
Miw3ICs1ODgsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O1NHSSZx
dW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJvZHVjdMKgIMKgIMKgIMKgPSAm
cXVvdDtUUDkxMDAmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnBncG9saWN5
wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdmYWls
YmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAgwqAgwqAgwqAgfSw8YnI+DQrCoCDC
oCDCoCDCoCB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnZlbmRvcsKgIMKgIMKgIMKg
ID0gJnF1b3Q7U0dJJnF1b3Q7LDxicj4NCkBAIC03MDMsNyArNjc4LDYgQEAgc3RhdGljIHN0cnVj
dCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAu
dmVuZG9ywqAgwqAgwqAgwqAgPSAmcXVvdDtTVU4mcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7KFN0b3JFZGdlIDM1MTB8VDQpJnF1
b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wZ3BvbGljecKgIMKgIMKgID0gTVVM
VElCVVMsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBnZmFpbGJhY2vCoCDCoCA9IEZB
SUxCQUNLX1VOREVGLDxicj4NCsKgIMKgIMKgIMKgIH0sPGJyPg0KwqAgwqAgwqAgwqAgezxicj4N
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9ICZxdW90O1NVTiZx
dW90Oyw8YnI+DQpAQCAtNzY2LDcgKzc0MCw2IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZh
dWx0X2h3W10gPSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1Y3TCoCDCoCDC
oCDCoD0gJnF1b3Q7UkFJR0UgVk9MVU1FJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9RVUVVRSw8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrC
oCDCoCDCoCDCoCB9LDxicj4NCsKgIMKgIMKgIMKgIC8qPGJyPg0KwqAgwqAgwqAgwqAgwqAqIElu
dGVsPGJyPg0KQEAgLTgxOCw3ICs3OTEsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVs
dF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDC
oCA9ICZxdW90O1BVUkUmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1
Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7Rmxhc2hBcnJheSZxdW90Oyw8YnI+DQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCAucGdwb2xpY3nCoCDCoCDCoCA9IE1VTFRJQlVTLDxicj4NCi3CoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoC5wZ2ZhaWxiYWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAuZmFzdF9pb19mYWlswqAgPSAxMCw8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAuZGV2X2xvc3PCoCDCoCDCoCA9IDYwLDxicj4NCsKgIMKgIMKgIMKgIH0s
PGJyPg0KQEAgLTgzMCw3ICs4MDIsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9o
d1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDCoCA9
ICZxdW90OyhIVUFXRUl8SFVBU1kpJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O1hTRzEmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgLnBncG9saWN5wqAgwqAgwqAgPSBNVUxUSUJVUyw8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAucGdmYWlsYmFja8KgIMKgID0gRkFJTEJBQ0tfVU5ERUYsPGJyPg0KwqAg
wqAgwqAgwqAgfSw8YnI+DQrCoCDCoCDCoCDCoCAvKjxicj4NCsKgIMKgIMKgIMKgIMKgKiBSZWQg
SGF0PGJyPg0KQEAgLTg1Miw3ICs4MjMsNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVs
dF9od1tdID0gezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC52ZW5kb3LCoCDCoCDCoCDC
oCA9ICZxdW90O0tPVkUmcXVvdDssPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgLnByb2R1
Y3TCoCDCoCDCoCDCoD0gJnF1b3Q7WFBEJnF1b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIC5wZ3BvbGljecKgIMKgIMKgID0gTVVMVElCVVMsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgLnBnZmFpbGJhY2vCoCDCoCA9IEZBSUxCQUNLX1VOREVGLDxicj4NCsKgIMKgIMKgIMKg
IH0sPGJyPg0KwqAjaWYgMDxicj4NCsKgIMKgIMKgIMKgIC8qPGJyPg0KQEAgLTg4Miw3ICs4NTIs
NyBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIC5od2hhbmRsZXLCoCDCoCDCoD0gJnF1b3Q7MCZxdW90Oyw8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAucHJpb19uYW1lwqAgwqAgwqA9ICZxdW90O2NvbnN0JnF1
b3Q7LDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX2FyZ3PCoCDCoCDCoD0gJnF1
b3Q7JnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ2ZhaWxiYWNrwqAgwqAg
PSAtRkFJTEJBQ0tfTUFOVUFMLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5wZ2ZhaWxi
YWNrwqAgwqAgPSBGQUlMQkFDS19VTkRFRiw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAu
cnJfd2VpZ2h0wqAgwqAgwqA9IFJSX1dFSUdIVF9OT05FLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIC5ub19wYXRoX3JldHJ5ID0gTk9fUEFUSF9SRVRSWV9VTkRFRiw8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCAubWluaW/CoCDCoCDCoCDCoCDCoD0gMTAwMCw8YnI+DQpkaWZmIC0t
Z2l0IGEvbXVsdGlwYXRoL211bHRpcGF0aC5jb25mLjUgYi9tdWx0aXBhdGgvbXVsdGlwYXRoLmNv
bmYuNTxicj4NCmluZGV4IDQwZGYzMTUuLjQ2NmFkOTQgMTAwNjQ0PGJyPg0KLS0tIGEvbXVsdGlw
YXRoL211bHRpcGF0aC5jb25mLjU8YnI+DQorKysgYi9tdWx0aXBhdGgvbXVsdGlwYXRoLmNvbmYu
NTxicj4NCkBAIC00MjIsNiArNDIyLDggQEAgRGVmYXVsdCB2YWx1ZSBpczogXGZCbXBhdGhcZlI8
YnI+DQrCoC5UUDxicj4NCsKgLkIgZmFpbGJhY2s8YnI+DQrCoFRlbGwgbXVsdGlwYXRoZCBob3cg
dG8gbWFuYWdlIHBhdGggZ3JvdXAgZmFpbGJhY2suPGJyPg0KK1RvIHNlbGVjdCBcZklpbW1lZGlh
dGVcZlIgb3IgYSBcZkl2YWx1ZVxmUiwgaXQmIzM5O3MgbWFuZGF0b3J5IHRoYXQgdGhlIGRldmlj
ZTxicj4NCitoYXMgc3VwcG9ydCBmb3IgYSB3b3JraW5nIHByaW9yaXRpemVyIGFuZCBhICYjMzk7
cHJlZmVycmVkIHBhdGgmIzM5Oy48YnI+DQrCoC5SUzxicj4NCsKgLlRQIDEyPGJyPg0KwqAuSSBp
bW1lZGlhdGU8YnI+DQpAQCAtNDQwLDcgKzQ0MiwxMSBAQCBhbm90aGVyIG5vZGUgcmVxdWVzdGVk
IHRoZSBmYWlsb3Zlci48YnI+DQrCoC5JIHZhbHVlcyAmZ3Q7IDA8YnI+DQrCoERlZmVycmVkIGZh
aWxiYWNrICh0aW1lIHRvIGRlZmVyIGluIHNlY29uZHMpLjxicj4NCsKgLlRQPGJyPg0KLURlZmF1
bHQgdmFsdWUgaXM6IFxmQm1hbnVhbFxmUjxicj4NCisuXCZxdW90OyBYWFg8YnI+DQorLkkgJmx0
O3Vuc2V0Jmd0Ozxicj4NCis/Pz8gVW5kZWZpbmVkLjxicj4NCisuVFA8YnI+DQorRGVmYXVsdCB2
YWx1ZSBpczogXGZCJmx0O3Vuc2V0Jmd0O1xmUjxicj4NCsKgLlJFPGJyPg0KwqAuPGJyPg0KwqAu
PGJyPg0KPHNwYW4gY2xhc3M9IkhPRW5aYiI+PGZvbnQgY29sb3I9IiM4ODg4ODgiPi0tPGJyPg0K
Mi43LjQ8YnI+DQo8YnI+DQo8L2ZvbnQ+PC9zcGFuPjwvYmxvY2txdW90ZT48L2Rpdj48YnI+PC9k
aXY+DQo=
--001a11408126c384a0053df44177--


--===============2924284723910108029==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2924284723910108029==--
