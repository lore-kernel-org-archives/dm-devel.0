From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: Add Dell 36xxi/f support to
 internal hardware table
Date: Thu, 8 Jan 2015 23:22:48 +0100
Message-ID: <CABr-Gnd+RB-3xxfCHggtkS4A7E1dk0=G=xsmLhF+LL-WW5vC7Q@mail.gmail.com>
References: <1414073430-5495-1-git-send-email-jcastillo@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1354656370178497884=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1414073430-5495-1-git-send-email-jcastillo@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Yanqing Liu <Yanqing_Liu@dell.com>
List-Id: dm-devel.ids

--===============1354656370178497884==
Content-Type: multipart/alternative; boundary=001a11c36474e9d8ad050c2b7a3e

--001a11c36474e9d8ad050c2b7a3e
Content-Type: text/plain; charset=UTF-8

Applied,
thanks.

On Thu, Oct 23, 2014 at 4:10 PM, Jose Castillo <jcastillo@redhat.com> wrote:

> This patch adds support for Dell 36xxi and 36xxf arrays.
>
> Signed-off-by: Jose Castillo <jcastillo@redhat.com>
> ---
>  libmultipath/hwtable.c  | 30 ++++++++++++++++++++++++++++++
>  multipath.conf.defaults | 26 ++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index a9dde7f..bf2c2ca 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -772,6 +772,36 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_RDAC,
>                 .prio_args     = NULL,
>         },
> +       {
> +               /* DELL MD36xxi */
> +               .vendor        = "DELL",
> +               .product       = "MD36xxi",
> +               .bl_product    = "Universal Xport",
> +               .features      = "2 pg_init_retries 50",
> +               .hwhandler     = "1 rdac",
> +               .pgpolicy      = GROUP_BY_PRIO,
> +               .pgfailback    = -FAILBACK_IMMEDIATE,
> +               .rr_weight     = RR_WEIGHT_NONE,
> +               .no_path_retry = 15,
> +               .checker_name  = RDAC,
> +               .prio_name     = PRIO_RDAC,
> +               .prio_args     = NULL,
> +       },
> +       {
> +               /* DELL MD36xxf */
> +               .vendor        = "DELL",
> +               .product       = "MD36xxf",
> +               .bl_product    = "Universal Xport",
> +               .features      = "2 pg_init_retries 50",
> +               .hwhandler     = "1 rdac",
> +               .pgpolicy      = GROUP_BY_PRIO,
> +               .pgfailback    = -FAILBACK_IMMEDIATE,
> +               .rr_weight     = RR_WEIGHT_NONE,
> +               .no_path_retry = 15,
> +               .checker_name  = RDAC,
> +               .prio_name     = PRIO_RDAC,
> +               .prio_args     = NULL,
> +       },
>         /*
>          * NETAPP controller family
>          *
> diff --git a/multipath.conf.defaults b/multipath.conf.defaults
> index 654be97..f838f02 100644
> --- a/multipath.conf.defaults
> +++ b/multipath.conf.defaults
> @@ -654,6 +654,32 @@
>  #              no_path_retry 15
>  #      }
>  #      device {
> +#              vendor "DELL"
> +#              product "MD36xxi"
> +#              product_blacklist "Universal Xport"
> +#              path_grouping_policy "group_by_prio"
> +#              path_checker "rdac"
> +#              features "2 pg_init_retries 50"
> +#              hardware_handler "1 rdac"
> +#              prio "rdac"
> +#              failback "immediate"
> +#              rr_weight "uniform"
> +#              no_path_retry 15
> +#      }
> +#      device {
> +#              vendor "DELL"
> +#              product "MD36xxf"
> +#              product_blacklist "Universal Xport"
> +#              path_grouping_policy "group_by_prio"
> +#              path_checker "rdac"
> +#              features "2 pg_init_retries 50"
> +#              hardware_handler "1 rdac"
> +#              prio "rdac"
> +#              failback "immediate"
> +#              rr_weight "uniform"
> +#              no_path_retry 15
> +#      }
> +#      device {
>  #              vendor "NETAPP"
>  #              product "LUN.*"
>  #              path_grouping_policy "group_by_prio"
> --
> 1.9.3
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11c36474e9d8ad050c2b7a3e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+QXBwbGllZCw8ZGl2PnRoYW5rcy48L2Rpdj48L2Rpdj48ZGl2IGNsYXNz
PSJnbWFpbF9leHRyYSI+PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj5PbiBUaHUsIE9jdCAy
MywgMjAxNCBhdCA0OjEwIFBNLCBKb3NlIENhc3RpbGxvIDxzcGFuIGRpcj0ibHRyIj4mbHQ7PGEg
aHJlZj0ibWFpbHRvOmpjYXN0aWxsb0ByZWRoYXQuY29tIiB0YXJnZXQ9Il9ibGFuayI+amNhc3Rp
bGxvQHJlZGhhdC5jb208L2E+Jmd0Ozwvc3Bhbj4gd3JvdGU6PGJyPjxibG9ja3F1b3RlIGNsYXNz
PSJnbWFpbF9xdW90ZSIgc3R5bGU9Im1hcmdpbjowIDAgMCAuOGV4O2JvcmRlci1sZWZ0OjFweCAj
Y2NjIHNvbGlkO3BhZGRpbmctbGVmdDoxZXgiPlRoaXMgcGF0Y2ggYWRkcyBzdXBwb3J0IGZvciBE
ZWxsIDM2eHhpIGFuZCAzNnh4ZiBhcnJheXMuPGJyPg0KPGJyPg0KU2lnbmVkLW9mZi1ieTogSm9z
ZSBDYXN0aWxsbyAmbHQ7PGEgaHJlZj0ibWFpbHRvOmpjYXN0aWxsb0ByZWRoYXQuY29tIj5qY2Fz
dGlsbG9AcmVkaGF0LmNvbTwvYT4mZ3Q7PGJyPg0KLS0tPGJyPg0KwqBsaWJtdWx0aXBhdGgvaHd0
YWJsZS5jwqAgfCAzMCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKys8YnI+DQrCoG11bHRp
cGF0aC5jb25mLmRlZmF1bHRzIHwgMjYgKysrKysrKysrKysrKysrKysrKysrKysrKys8YnI+DQrC
oDIgZmlsZXMgY2hhbmdlZCwgNTYgaW5zZXJ0aW9ucygrKTxicj4NCjxicj4NCmRpZmYgLS1naXQg
YS9saWJtdWx0aXBhdGgvaHd0YWJsZS5jIGIvbGlibXVsdGlwYXRoL2h3dGFibGUuYzxicj4NCmlu
ZGV4IGE5ZGRlN2YuLmJmMmMyY2EgMTAwNjQ0PGJyPg0KLS0tIGEvbGlibXVsdGlwYXRoL2h3dGFi
bGUuYzxicj4NCisrKyBiL2xpYm11bHRpcGF0aC9od3RhYmxlLmM8YnI+DQpAQCAtNzcyLDYgKzc3
MiwzNiBAQCBzdGF0aWMgc3RydWN0IGh3ZW50cnkgZGVmYXVsdF9od1tdID0gezxicj4NCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX25hbWXCoCDCoCDCoD0gUFJJT19SREFDLDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIC5wcmlvX2FyZ3PCoCDCoCDCoD0gTlVMTCw8YnI+DQrCoCDC
oCDCoCDCoCB9LDxicj4NCivCoCDCoCDCoCDCoHs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAvKiBERUxMIE1EMzZ4eGkgKi88YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAudmVuZG9y
wqAgwqAgwqAgwqAgPSAmcXVvdDtERUxMJnF1b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoC5wcm9kdWN0wqAgwqAgwqAgwqA9ICZxdW90O01EMzZ4eGkmcXVvdDssPGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLmJsX3Byb2R1Y3TCoCDCoCA9ICZxdW90O1VuaXZlcnNhbCBYcG9y
dCZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuZmVhdHVyZXPCoCDCoCDCoCA9
ICZxdW90OzIgcGdfaW5pdF9yZXRyaWVzIDUwJnF1b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoC5od2hhbmRsZXLCoCDCoCDCoD0gJnF1b3Q7MSByZGFjJnF1b3Q7LDxicj4NCivCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoC5wZ3BvbGljecKgIMKgIMKgID0gR1JPVVBfQllfUFJJTyw8YnI+
DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdmYWlsYmFja8KgIMKgID0gLUZBSUxCQUNLX0lN
TUVESUFURSw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucnJfd2VpZ2h0wqAgwqAgwqA9
IFJSX1dFSUdIVF9OT05FLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5ub19wYXRoX3Jl
dHJ5ID0gMTUsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmNoZWNrZXJfbmFtZcKgID0g
UkRBQyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19uYW1lwqAgwqAgwqA9IFBS
SU9fUkRBQyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucHJpb19hcmdzwqAgwqAgwqA9
IE5VTEwsPGJyPg0KK8KgIMKgIMKgIMKgfSw8YnI+DQorwqAgwqAgwqAgwqB7PGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgLyogREVMTCBNRDM2eHhmICovPGJyPg0KK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLnZlbmRvcsKgIMKgIMKgIMKgID0gJnF1b3Q7REVMTCZxdW90Oyw8YnI+DQorwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAucHJvZHVjdMKgIMKgIMKgIMKgPSAmcXVvdDtNRDM2eHhmJnF1
b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5ibF9wcm9kdWN0wqAgwqAgPSAmcXVv
dDtVbml2ZXJzYWwgWHBvcnQmcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLmZl
YXR1cmVzwqAgwqAgwqAgPSAmcXVvdDsyIHBnX2luaXRfcmV0cmllcyA1MCZxdW90Oyw8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAuaHdoYW5kbGVywqAgwqAgwqA9ICZxdW90OzEgcmRhYyZx
dW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAucGdwb2xpY3nCoCDCoCDCoCA9IEdS
T1VQX0JZX1BSSU8sPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBnZmFpbGJhY2vCoCDC
oCA9IC1GQUlMQkFDS19JTU1FRElBVEUsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnJy
X3dlaWdodMKgIMKgIMKgPSBSUl9XRUlHSFRfTk9ORSw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAubm9fcGF0aF9yZXRyeSA9IDE1LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC5j
aGVja2VyX25hbWXCoCA9IFJEQUMsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnByaW9f
bmFtZcKgIMKgIMKgPSBQUklPX1JEQUMsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgLnBy
aW9fYXJnc8KgIMKgIMKgPSBOVUxMLDxicj4NCivCoCDCoCDCoCDCoH0sPGJyPg0KwqAgwqAgwqAg
wqAgLyo8YnI+DQrCoCDCoCDCoCDCoCDCoCogTkVUQVBQIGNvbnRyb2xsZXIgZmFtaWx5PGJyPg0K
wqAgwqAgwqAgwqAgwqAqPGJyPg0KZGlmZiAtLWdpdCBhL211bHRpcGF0aC5jb25mLmRlZmF1bHRz
IGIvbXVsdGlwYXRoLmNvbmYuZGVmYXVsdHM8YnI+DQppbmRleCA2NTRiZTk3Li5mODM4ZjAyIDEw
MDY0NDxicj4NCi0tLSBhL211bHRpcGF0aC5jb25mLmRlZmF1bHRzPGJyPg0KKysrIGIvbXVsdGlw
YXRoLmNvbmYuZGVmYXVsdHM8YnI+DQpAQCAtNjU0LDYgKzY1NCwzMiBAQDxicj4NCsKgI8KgIMKg
IMKgIMKgIMKgIMKgIMKgIG5vX3BhdGhfcmV0cnkgMTU8YnI+DQrCoCPCoCDCoCDCoCB9PGJyPg0K
wqAjwqAgwqAgwqAgZGV2aWNlIHs8YnI+DQorI8KgIMKgIMKgIMKgIMKgIMKgIMKgIHZlbmRvciAm
cXVvdDtERUxMJnF1b3Q7PGJyPg0KKyPCoCDCoCDCoCDCoCDCoCDCoCDCoCBwcm9kdWN0ICZxdW90
O01EMzZ4eGkmcXVvdDs8YnI+DQorI8KgIMKgIMKgIMKgIMKgIMKgIMKgIHByb2R1Y3RfYmxhY2ts
aXN0ICZxdW90O1VuaXZlcnNhbCBYcG9ydCZxdW90Ozxicj4NCisjwqAgwqAgwqAgwqAgwqAgwqAg
wqAgcGF0aF9ncm91cGluZ19wb2xpY3kgJnF1b3Q7Z3JvdXBfYnlfcHJpbyZxdW90Ozxicj4NCisj
wqAgwqAgwqAgwqAgwqAgwqAgwqAgcGF0aF9jaGVja2VyICZxdW90O3JkYWMmcXVvdDs8YnI+DQor
I8KgIMKgIMKgIMKgIMKgIMKgIMKgIGZlYXR1cmVzICZxdW90OzIgcGdfaW5pdF9yZXRyaWVzIDUw
JnF1b3Q7PGJyPg0KKyPCoCDCoCDCoCDCoCDCoCDCoCDCoCBoYXJkd2FyZV9oYW5kbGVyICZxdW90
OzEgcmRhYyZxdW90Ozxicj4NCisjwqAgwqAgwqAgwqAgwqAgwqAgwqAgcHJpbyAmcXVvdDtyZGFj
JnF1b3Q7PGJyPg0KKyPCoCDCoCDCoCDCoCDCoCDCoCDCoCBmYWlsYmFjayAmcXVvdDtpbW1lZGlh
dGUmcXVvdDs8YnI+DQorI8KgIMKgIMKgIMKgIMKgIMKgIMKgIHJyX3dlaWdodCAmcXVvdDt1bmlm
b3JtJnF1b3Q7PGJyPg0KKyPCoCDCoCDCoCDCoCDCoCDCoCDCoCBub19wYXRoX3JldHJ5IDE1PGJy
Pg0KKyPCoCDCoCDCoCB9PGJyPg0KKyPCoCDCoCDCoCBkZXZpY2Ugezxicj4NCisjwqAgwqAgwqAg
wqAgwqAgwqAgwqAgdmVuZG9yICZxdW90O0RFTEwmcXVvdDs8YnI+DQorI8KgIMKgIMKgIMKgIMKg
IMKgIMKgIHByb2R1Y3QgJnF1b3Q7TUQzNnh4ZiZxdW90Ozxicj4NCisjwqAgwqAgwqAgwqAgwqAg
wqAgwqAgcHJvZHVjdF9ibGFja2xpc3QgJnF1b3Q7VW5pdmVyc2FsIFhwb3J0JnF1b3Q7PGJyPg0K
KyPCoCDCoCDCoCDCoCDCoCDCoCDCoCBwYXRoX2dyb3VwaW5nX3BvbGljeSAmcXVvdDtncm91cF9i
eV9wcmlvJnF1b3Q7PGJyPg0KKyPCoCDCoCDCoCDCoCDCoCDCoCDCoCBwYXRoX2NoZWNrZXIgJnF1
b3Q7cmRhYyZxdW90Ozxicj4NCisjwqAgwqAgwqAgwqAgwqAgwqAgwqAgZmVhdHVyZXMgJnF1b3Q7
MiBwZ19pbml0X3JldHJpZXMgNTAmcXVvdDs8YnI+DQorI8KgIMKgIMKgIMKgIMKgIMKgIMKgIGhh
cmR3YXJlX2hhbmRsZXIgJnF1b3Q7MSByZGFjJnF1b3Q7PGJyPg0KKyPCoCDCoCDCoCDCoCDCoCDC
oCDCoCBwcmlvICZxdW90O3JkYWMmcXVvdDs8YnI+DQorI8KgIMKgIMKgIMKgIMKgIMKgIMKgIGZh
aWxiYWNrICZxdW90O2ltbWVkaWF0ZSZxdW90Ozxicj4NCisjwqAgwqAgwqAgwqAgwqAgwqAgwqAg
cnJfd2VpZ2h0ICZxdW90O3VuaWZvcm0mcXVvdDs8YnI+DQorI8KgIMKgIMKgIMKgIMKgIMKgIMKg
IG5vX3BhdGhfcmV0cnkgMTU8YnI+DQorI8KgIMKgIMKgIH08YnI+DQorI8KgIMKgIMKgIGRldmlj
ZSB7PGJyPg0KwqAjwqAgwqAgwqAgwqAgwqAgwqAgwqAgdmVuZG9yICZxdW90O05FVEFQUCZxdW90
Ozxicj4NCsKgI8KgIMKgIMKgIMKgIMKgIMKgIMKgIHByb2R1Y3QgJnF1b3Q7TFVOLiomcXVvdDs8
YnI+DQrCoCPCoCDCoCDCoCDCoCDCoCDCoCDCoCBwYXRoX2dyb3VwaW5nX3BvbGljeSAmcXVvdDtn
cm91cF9ieV9wcmlvJnF1b3Q7PGJyPg0KPHNwYW4gY2xhc3M9IkhPRW5aYiI+PGZvbnQgY29sb3I9
IiM4ODg4ODgiPi0tPGJyPg0KMS45LjM8YnI+DQo8YnI+DQotLTxicj4NCmRtLWRldmVsIG1haWxp
bmcgbGlzdDxicj4NCjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29tIj5kbS1kZXZl
bEByZWRoYXQuY29tPC9hPjxicj4NCjxhIGhyZWY9Imh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFp
bG1hbi9saXN0aW5mby9kbS1kZXZlbCIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQo8L2ZvbnQ+PC9zcGFuPjwv
YmxvY2txdW90ZT48L2Rpdj48YnI+PC9kaXY+DQo=
--001a11c36474e9d8ad050c2b7a3e--


--===============1354656370178497884==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1354656370178497884==--
