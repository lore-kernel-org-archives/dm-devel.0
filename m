From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: remove final \ in fprintf
Date: Fri, 22 Jul 2016 11:42:56 +0200
Message-ID: <CABr-GncGCtC7XRxU7gpEMuv_JL0VH042h0qpKSqUxT45w0uaEg@mail.gmail.com>
References: <1468848239-6163-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6466910103574572259=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468848239-6163-1-git-send-email-xose.vazquez@gmail.com>
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

--===============6466910103574572259==
Content-Type: multipart/alternative; boundary=001a114102e465660205383642c4

--001a114102e465660205383642c4
Content-Type: text/plain; charset=UTF-8

Merged.

On Mon, Jul 18, 2016 at 3:23 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Useless.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipath/main.c | 64
> ++++++++++++++++++++++++++++----------------------------
>  1 file changed, 32 insertions(+), 32 deletions(-)
>
> diff --git a/multipath/main.c b/multipath/main.c
> index 907a96c..0bec0d2 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -110,38 +110,38 @@ usage (char * progname)
>         fprintf (stderr,
>                 "\n"
>                 "Where:\n"
> -               "  -h      print this usage text\n" \
> -               "  -l      show multipath topology (sysfs and DM info)\n" \
> -               "  -ll     show multipath topology (maximum info)\n" \
> -               "  -f      flush a multipath device map\n" \
> -               "  -F      flush all multipath device maps\n" \
> -               "  -a      add a device wwid to the wwids file\n" \
> -               "  -c      check if a device should be a path in a
> multipath device\n" \
> -               "  -q      allow queue_if_no_path when multipathd is not
> running\n"\
> -               "  -d      dry run, do not create or update devmaps\n" \
> -               "  -t      dump internal hardware table\n" \
> -               "  -r      force devmap reload\n" \
> -               "  -i      ignore wwids file\n" \
> -               "  -B      treat the bindings file as read only\n" \
> -               "  -b fil  bindings file location\n" \
> -               "  -w      remove a device from the wwids file\n" \
> -               "  -W      reset the wwids file include only the current
> devices\n" \
> -               "  -p pol  force all maps to specified path grouping
> policy :\n" \
> -               "          . failover            one path per priority
> group\n" \
> -               "          . multibus            all paths in one priority
> group\n" \
> -               "          . group_by_serial     one priority group per
> serial\n" \
> -               "          . group_by_prio       one priority group per
> priority lvl\n" \
> -               "          . group_by_node_name  one priority group per
> target node\n" \
> -               "  -v lvl  verbosity level\n" \
> -               "          . 0 no output\n" \
> -               "          . 1 print created devmap names only\n" \
> -               "          . 2 default verbosity\n" \
> -               "          . 3 print debug information\n" \
> -               "  dev     action limited to:\n" \
> -               "          . multipath named 'dev' (ex: mpath0) or\n" \
> -               "          . multipath whose wwid is 'dev' (ex:
> 60051..)\n" \
> -               "          . multipath including the path named 'dev' (ex:
> /dev/sda)\n" \
> -               "          . multipath including the path with maj:min
> 'dev' (ex: 8:0)\n" \
> +               "  -h      print this usage text\n"
> +               "  -l      show multipath topology (sysfs and DM info)\n"
> +               "  -ll     show multipath topology (maximum info)\n"
> +               "  -f      flush a multipath device map\n"
> +               "  -F      flush all multipath device maps\n"
> +               "  -a      add a device wwid to the wwids file\n"
> +               "  -c      check if a device should be a path in a
> multipath device\n"
> +               "  -q      allow queue_if_no_path when multipathd is not
> running\n"
> +               "  -d      dry run, do not create or update devmaps\n"
> +               "  -t      dump internal hardware table\n"
> +               "  -r      force devmap reload\n"
> +               "  -i      ignore wwids file\n"
> +               "  -B      treat the bindings file as read only\n"
> +               "  -b fil  bindings file location\n"
> +               "  -w      remove a device from the wwids file\n"
> +               "  -W      reset the wwids file include only the current
> devices\n"
> +               "  -p pol  force all maps to specified path grouping
> policy :\n"
> +               "          . failover            one path per priority
> group\n"
> +               "          . multibus            all paths in one priority
> group\n"
> +               "          . group_by_serial     one priority group per
> serial\n"
> +               "          . group_by_prio       one priority group per
> priority lvl\n"
> +               "          . group_by_node_name  one priority group per
> target node\n"
> +               "  -v lvl  verbosity level\n"
> +               "          . 0 no output\n"
> +               "          . 1 print created devmap names only\n"
> +               "          . 2 default verbosity\n"
> +               "          . 3 print debug information\n"
> +               "  dev     action limited to:\n"
> +               "          . multipath named 'dev' (ex: mpath0) or\n"
> +               "          . multipath whose wwid is 'dev' (ex: 60051..)\n"
> +               "          . multipath including the path named 'dev' (ex:
> /dev/sda)\n"
> +               "          . multipath including the path with maj:min
> 'dev' (ex: 8:0)\n"
>                 );
>
>  }
> --
> 2.7.4
>
>

--001a114102e465660205383642c4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+TWVyZ2VkLjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48YnI+
PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIE1vbiwgSnVsIDE4LCAyMDE2IGF0IDM6MjMgUE0s
IFhvc2UgVmF6cXVleiBQZXJleiA8c3BhbiBkaXI9Imx0ciI+Jmx0OzxhIGhyZWY9Im1haWx0bzp4
b3NlLnZhenF1ZXpAZ21haWwuY29tIiB0YXJnZXQ9Il9ibGFuayI+eG9zZS52YXpxdWV6QGdtYWls
LmNvbTwvYT4mZ3Q7PC9zcGFuPiB3cm90ZTo8YnI+PGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1
b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29saWQ7
cGFkZGluZy1sZWZ0OjFleCI+VXNlbGVzcy48YnI+DQo8YnI+DQpDYzogQ2hyaXN0b3BoZSBWYXJv
cXVpICZsdDs8YSBocmVmPSJtYWlsdG86Y2hyaXN0b3BoZS52YXJvcXVpQG9wZW5zdmMuY29tIj5j
aHJpc3RvcGhlLnZhcm9xdWlAb3BlbnN2Yy5jb208L2E+Jmd0Ozxicj4NCkNjOiBkZXZpY2UtbWFw
cGVyIGRldmVsb3BtZW50ICZsdDs8YSBocmVmPSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+
ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT4mZ3Q7PGJyPg0KU2lnbmVkLW9mZi1ieTogWG9zZSBWYXpx
dWV6IFBlcmV6ICZsdDs8YSBocmVmPSJtYWlsdG86eG9zZS52YXpxdWV6QGdtYWlsLmNvbSI+eG9z
ZS52YXpxdWV6QGdtYWlsLmNvbTwvYT4mZ3Q7PGJyPg0KLS0tPGJyPg0KwqBtdWx0aXBhdGgvbWFp
bi5jIHwgNjQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS08YnI+DQrCoDEgZmlsZSBjaGFuZ2VkLCAzMiBpbnNlcnRpb25zKCspLCAzMiBkZWxl
dGlvbnMoLSk8YnI+DQo8YnI+DQpkaWZmIC0tZ2l0IGEvbXVsdGlwYXRoL21haW4uYyBiL211bHRp
cGF0aC9tYWluLmM8YnI+DQppbmRleCA5MDdhOTZjLi4wYmVjMGQyIDEwMDY0NDxicj4NCi0tLSBh
L211bHRpcGF0aC9tYWluLmM8YnI+DQorKysgYi9tdWx0aXBhdGgvbWFpbi5jPGJyPg0KQEAgLTEx
MCwzOCArMTEwLDM4IEBAIHVzYWdlIChjaGFyICogcHJvZ25hbWUpPGJyPg0KwqAgwqAgwqAgwqAg
ZnByaW50ZiAoc3RkZXJyLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgICZxdW90O1xuJnF1
b3Q7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgJnF1b3Q7V2hlcmU6XG4mcXVvdDs8YnI+
DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCAtaMKgIMKgIMKgIHByaW50IHRoaXMg
dXNhZ2UgdGV4dFxuJnF1b3Q7IFw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvC
oCAtbMKgIMKgIMKgIHNob3cgbXVsdGlwYXRoIHRvcG9sb2d5IChzeXNmcyBhbmQgRE0gaW5mbylc
biZxdW90OyBcPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgLWxswqAgwqAg
wqBzaG93IG11bHRpcGF0aCB0b3BvbG9neSAobWF4aW11bSBpbmZvKVxuJnF1b3Q7IFw8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCAtZsKgIMKgIMKgIGZsdXNoIGEgbXVsdGlw
YXRoIGRldmljZSBtYXBcbiZxdW90OyBcPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1
b3Q7wqAgLUbCoCDCoCDCoCBmbHVzaCBhbGwgbXVsdGlwYXRoIGRldmljZSBtYXBzXG4mcXVvdDsg
XDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIC1hwqAgwqAgwqAgYWRkIGEg
ZGV2aWNlIHd3aWQgdG8gdGhlIHd3aWRzIGZpbGVcbiZxdW90OyBcPGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgJnF1b3Q7wqAgLWPCoCDCoCDCoCBjaGVjayBpZiBhIGRldmljZSBzaG91bGQg
YmUgYSBwYXRoIGluIGEgbXVsdGlwYXRoIGRldmljZVxuJnF1b3Q7IFw8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAmcXVvdDvCoCAtccKgIMKgIMKgIGFsbG93IHF1ZXVlX2lmX25vX3BhdGgg
d2hlbiBtdWx0aXBhdGhkIGlzIG5vdCBydW5uaW5nXG4mcXVvdDtcPGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgJnF1b3Q7wqAgLWTCoCDCoCDCoCBkcnkgcnVuLCBkbyBub3QgY3JlYXRlIG9y
IHVwZGF0ZSBkZXZtYXBzXG4mcXVvdDsgXDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZx
dW90O8KgIC10wqAgwqAgwqAgZHVtcCBpbnRlcm5hbCBoYXJkd2FyZSB0YWJsZVxuJnF1b3Q7IFw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCAtcsKgIMKgIMKgIGZvcmNlIGRl
dm1hcCByZWxvYWRcbiZxdW90OyBcPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7
wqAgLWnCoCDCoCDCoCBpZ25vcmUgd3dpZHMgZmlsZVxuJnF1b3Q7IFw8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAmcXVvdDvCoCAtQsKgIMKgIMKgIHRyZWF0IHRoZSBiaW5kaW5ncyBmaWxl
IGFzIHJlYWQgb25seVxuJnF1b3Q7IFw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVv
dDvCoCAtYiBmaWzCoCBiaW5kaW5ncyBmaWxlIGxvY2F0aW9uXG4mcXVvdDsgXDxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIC13wqAgwqAgwqAgcmVtb3ZlIGEgZGV2aWNlIGZy
b20gdGhlIHd3aWRzIGZpbGVcbiZxdW90OyBcPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
JnF1b3Q7wqAgLVfCoCDCoCDCoCByZXNldCB0aGUgd3dpZHMgZmlsZSBpbmNsdWRlIG9ubHkgdGhl
IGN1cnJlbnQgZGV2aWNlc1xuJnF1b3Q7IFw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAm
cXVvdDvCoCAtcCBwb2zCoCBmb3JjZSBhbGwgbWFwcyB0byBzcGVjaWZpZWQgcGF0aCBncm91cGlu
ZyBwb2xpY3kgOlxuJnF1b3Q7IFw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvC
oCDCoCDCoCDCoCDCoCAuIGZhaWxvdmVywqAgwqAgwqAgwqAgwqAgwqAgb25lIHBhdGggcGVyIHBy
aW9yaXR5IGdyb3VwXG4mcXVvdDsgXDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90
O8KgIMKgIMKgIMKgIMKgIC4gbXVsdGlidXPCoCDCoCDCoCDCoCDCoCDCoCBhbGwgcGF0aHMgaW4g
b25lIHByaW9yaXR5IGdyb3VwXG4mcXVvdDsgXDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCZxdW90O8KgIMKgIMKgIMKgIMKgIC4gZ3JvdXBfYnlfc2VyaWFswqAgwqAgwqBvbmUgcHJpb3Jp
dHkgZ3JvdXAgcGVyIHNlcmlhbFxuJnF1b3Q7IFw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAmcXVvdDvCoCDCoCDCoCDCoCDCoCAuIGdyb3VwX2J5X3ByaW/CoCDCoCDCoCDCoG9uZSBwcmlv
cml0eSBncm91cCBwZXIgcHJpb3JpdHkgbHZsXG4mcXVvdDsgXDxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIMKgIMKgIC4gZ3JvdXBfYnlfbm9kZV9uYW1lwqAgb25l
IHByaW9yaXR5IGdyb3VwIHBlciB0YXJnZXQgbm9kZVxuJnF1b3Q7IFw8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAmcXVvdDvCoCAtdiBsdmzCoCB2ZXJib3NpdHkgbGV2ZWxcbiZxdW90OyBc
PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgwqAgwqAgLiAwIG5v
IG91dHB1dFxuJnF1b3Q7IFw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCDC
oCDCoCDCoCDCoCAuIDEgcHJpbnQgY3JlYXRlZCBkZXZtYXAgbmFtZXMgb25seVxuJnF1b3Q7IFw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCDCoCDCoCDCoCDCoCAuIDIgZGVm
YXVsdCB2ZXJib3NpdHlcbiZxdW90OyBcPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1
b3Q7wqAgwqAgwqAgwqAgwqAgLiAzIHByaW50IGRlYnVnIGluZm9ybWF0aW9uXG4mcXVvdDsgXDxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIGRldsKgIMKgIMKgYWN0aW9uIGxp
bWl0ZWQgdG86XG4mcXVvdDsgXDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8Kg
IMKgIMKgIMKgIMKgIC4gbXVsdGlwYXRoIG5hbWVkICYjMzk7ZGV2JiMzOTsgKGV4OiBtcGF0aDAp
IG9yXG4mcXVvdDsgXDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKg
IMKgIMKgIC4gbXVsdGlwYXRoIHdob3NlIHd3aWQgaXMgJiMzOTtkZXYmIzM5OyAoZXg6IDYwMDUx
Li4pXG4mcXVvdDsgXDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKg
IMKgIMKgIC4gbXVsdGlwYXRoIGluY2x1ZGluZyB0aGUgcGF0aCBuYW1lZCAmIzM5O2RldiYjMzk7
IChleDogL2Rldi9zZGEpXG4mcXVvdDsgXDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZx
dW90O8KgIMKgIMKgIMKgIMKgIC4gbXVsdGlwYXRoIGluY2x1ZGluZyB0aGUgcGF0aCB3aXRoIG1h
ajptaW4gJiMzOTtkZXYmIzM5OyAoZXg6IDg6MClcbiZxdW90OyBcPGJyPg0KK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgJnF1b3Q7wqAgLWjCoCDCoCDCoCBwcmludCB0aGlzIHVzYWdlIHRleHRcbiZx
dW90Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIC1swqAgwqAgwqAgc2hv
dyBtdWx0aXBhdGggdG9wb2xvZ3kgKHN5c2ZzIGFuZCBETSBpbmZvKVxuJnF1b3Q7PGJyPg0KK8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgLWxswqAgwqAgwqBzaG93IG11bHRpcGF0aCB0
b3BvbG9neSAobWF4aW11bSBpbmZvKVxuJnF1b3Q7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgJnF1b3Q7wqAgLWbCoCDCoCDCoCBmbHVzaCBhIG11bHRpcGF0aCBkZXZpY2UgbWFwXG4mcXVv
dDs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCAtRsKgIMKgIMKgIGZsdXNo
IGFsbCBtdWx0aXBhdGggZGV2aWNlIG1hcHNcbiZxdW90Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCZxdW90O8KgIC1hwqAgwqAgwqAgYWRkIGEgZGV2aWNlIHd3aWQgdG8gdGhlIHd3aWRz
IGZpbGVcbiZxdW90Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIC1jwqAg
wqAgwqAgY2hlY2sgaWYgYSBkZXZpY2Ugc2hvdWxkIGJlIGEgcGF0aCBpbiBhIG11bHRpcGF0aCBk
ZXZpY2VcbiZxdW90Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIC1xwqAg
wqAgwqAgYWxsb3cgcXVldWVfaWZfbm9fcGF0aCB3aGVuIG11bHRpcGF0aGQgaXMgbm90IHJ1bm5p
bmdcbiZxdW90Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIC1kwqAgwqAg
wqAgZHJ5IHJ1biwgZG8gbm90IGNyZWF0ZSBvciB1cGRhdGUgZGV2bWFwc1xuJnF1b3Q7PGJyPg0K
K8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgLXTCoCDCoCDCoCBkdW1wIGludGVybmFs
IGhhcmR3YXJlIHRhYmxlXG4mcXVvdDs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVv
dDvCoCAtcsKgIMKgIMKgIGZvcmNlIGRldm1hcCByZWxvYWRcbiZxdW90Ozxicj4NCivCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIC1pwqAgwqAgwqAgaWdub3JlIHd3aWRzIGZpbGVcbiZx
dW90Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIC1CwqAgwqAgwqAgdHJl
YXQgdGhlIGJpbmRpbmdzIGZpbGUgYXMgcmVhZCBvbmx5XG4mcXVvdDs8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAmcXVvdDvCoCAtYiBmaWzCoCBiaW5kaW5ncyBmaWxlIGxvY2F0aW9uXG4m
cXVvdDs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCAtd8KgIMKgIMKgIHJl
bW92ZSBhIGRldmljZSBmcm9tIHRoZSB3d2lkcyBmaWxlXG4mcXVvdDs8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAmcXVvdDvCoCAtV8KgIMKgIMKgIHJlc2V0IHRoZSB3d2lkcyBmaWxlIGlu
Y2x1ZGUgb25seSB0aGUgY3VycmVudCBkZXZpY2VzXG4mcXVvdDs8YnI+DQorwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAmcXVvdDvCoCAtcCBwb2zCoCBmb3JjZSBhbGwgbWFwcyB0byBzcGVjaWZpZWQg
cGF0aCBncm91cGluZyBwb2xpY3kgOlxuJnF1b3Q7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgJnF1b3Q7wqAgwqAgwqAgwqAgwqAgLiBmYWlsb3ZlcsKgIMKgIMKgIMKgIMKgIMKgIG9uZSBw
YXRoIHBlciBwcmlvcml0eSBncm91cFxuJnF1b3Q7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgJnF1b3Q7wqAgwqAgwqAgwqAgwqAgLiBtdWx0aWJ1c8KgIMKgIMKgIMKgIMKgIMKgIGFsbCBw
YXRocyBpbiBvbmUgcHJpb3JpdHkgZ3JvdXBcbiZxdW90Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCZxdW90O8KgIMKgIMKgIMKgIMKgIC4gZ3JvdXBfYnlfc2VyaWFswqAgwqAgwqBvbmUg
cHJpb3JpdHkgZ3JvdXAgcGVyIHNlcmlhbFxuJnF1b3Q7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgJnF1b3Q7wqAgwqAgwqAgwqAgwqAgLiBncm91cF9ieV9wcmlvwqAgwqAgwqAgwqBvbmUg
cHJpb3JpdHkgZ3JvdXAgcGVyIHByaW9yaXR5IGx2bFxuJnF1b3Q7PGJyPg0KK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgwqAgwqAgLiBncm91cF9ieV9ub2RlX25hbWXCoCBv
bmUgcHJpb3JpdHkgZ3JvdXAgcGVyIHRhcmdldCBub2RlXG4mcXVvdDs8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAmcXVvdDvCoCAtdiBsdmzCoCB2ZXJib3NpdHkgbGV2ZWxcbiZxdW90Ozxi
cj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIMKgIMKgIC4gMCBubyBv
dXRwdXRcbiZxdW90Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKg
IMKgIMKgIC4gMSBwcmludCBjcmVhdGVkIGRldm1hcCBuYW1lcyBvbmx5XG4mcXVvdDs8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCDCoCDCoCDCoCDCoCAuIDIgZGVmYXVsdCB2
ZXJib3NpdHlcbiZxdW90Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKg
IMKgIMKgIMKgIC4gMyBwcmludCBkZWJ1ZyBpbmZvcm1hdGlvblxuJnF1b3Q7PGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgZGV2wqAgwqAgwqBhY3Rpb24gbGltaXRlZCB0bzpc
biZxdW90Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIMKgIMKg
IC4gbXVsdGlwYXRoIG5hbWVkICYjMzk7ZGV2JiMzOTsgKGV4OiBtcGF0aDApIG9yXG4mcXVvdDs8
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCDCoCDCoCDCoCDCoCAuIG11bHRp
cGF0aCB3aG9zZSB3d2lkIGlzICYjMzk7ZGV2JiMzOTsgKGV4OiA2MDA1MS4uKVxuJnF1b3Q7PGJy
Pg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgwqAgwqAgLiBtdWx0aXBh
dGggaW5jbHVkaW5nIHRoZSBwYXRoIG5hbWVkICYjMzk7ZGV2JiMzOTsgKGV4OiAvZGV2L3NkYSlc
biZxdW90Ozxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIMKgIMKg
IC4gbXVsdGlwYXRoIGluY2x1ZGluZyB0aGUgcGF0aCB3aXRoIG1hajptaW4gJiMzOTtkZXYmIzM5
OyAoZXg6IDg6MClcbiZxdW90Ozxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgICk7PGJyPg0K
PGJyPg0KwqB9PGJyPg0KPHNwYW4gY2xhc3M9IkhPRW5aYiI+PGZvbnQgY29sb3I9IiM4ODg4ODgi
Pi0tPGJyPg0KMi43LjQ8YnI+DQo8YnI+DQo8L2ZvbnQ+PC9zcGFuPjwvYmxvY2txdW90ZT48L2Rp
dj48YnI+PC9kaXY+DQo=
--001a114102e465660205383642c4--


--===============6466910103574572259==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6466910103574572259==--
