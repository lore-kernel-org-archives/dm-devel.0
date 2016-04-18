From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2 00/18] Multipath patch sync
Date: Mon, 18 Apr 2016 11:36:49 +0200
Message-ID: <CABr-GneuiiKE4xyXW0kG1i-QmDJFuUzAoDsh-ACZDbgcTdhg8A@mail.gmail.com>
References: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5462914942399381472=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
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

--===============5462914942399381472==
Content-Type: multipart/alternative; boundary=001a1140160c94d27e0530bf1996

--001a1140160c94d27e0530bf1996
Content-Type: text/plain; charset=UTF-8

Hi Ben,

This patchset is merged, thanks.

The version code has been bumped to 0.6.0

Best regards,
Christophe Varoqui
www.opensvc.com


On Fri, Apr 8, 2016 at 1:19 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> This is a resend of my previous batch of patches.  The only one that has
> changed (besides in offsets) is patch 10 "multipathd: delay reloads during
> creation". I renamed the config option "missing_uev_wait_timeout". When
> it triggers, multipath will simply print a warning message and re-enable
> reloads as if it had received the uevent.
>
> I also added a new patch that adds a new keyword to the weightedpath
> prioritizer, so that you can refer to paths in a persistent way.
>
> Benjamin Marzinski (18):
>   multipathd: use /run instead of /var/run
>   retrigger uevents to try and get the uid through udev
>   Fix issues with user_friendly_names initramfs bindings
>   Add libmpathcmd library and use it internally
>   libmultipath: add ignore_new_boot_devs option
>   libmultipath: fix PAD and PRINT macros
>   libmultipath: Cut down on alua prioritizer ioctls
>   multipathd: fail if pidfile can't be created
>   libmultipath: check correct function for define
>   multipathd: delay reloads during creation
>   multipath: Fix minor text issues
>   kpartx: verify partition devices
>   multipath: add exclusive_pref_bit for alua prio
>   multipathd: print "fail" when remove fails
>   multipath: check partitions unused before removing
>   multipathd.service: remove blk-availability Requires
>   multipathd: use 64-bit int for command key
>   multipath: add wwn keyword to weightedpath prio
>
>  Makefile                                 |   1 +
>  Makefile.inc                             |  12 +-
>  kpartx/devmapper.c                       |  17 ++-
>  kpartx/devmapper.h                       |   2 +-
>  kpartx/kpartx.c                          |  70 ++++++++++-
>  libmpathcmd/Makefile                     |  30 +++++
>  libmpathcmd/mpath_cmd.c                  | 178 +++++++++++++++++++++++++++
>  libmpathcmd/mpath_cmd.h                  | 125 +++++++++++++++++++
>  libmpathpersist/Makefile                 |   9 +-
>  libmpathpersist/mpath_persist.c          |   2 +-
>  libmpathpersist/mpath_updatepr.c         |  14 +--
>  libmultipath/Makefile                    |   5 +-
>  libmultipath/config.c                    |   7 +-
>  libmultipath/config.h                    |   5 +
>  libmultipath/configure.c                 |  20 +--
>  libmultipath/defaults.h                  |   6 +-
>  libmultipath/devmapper.c                 |  46 +++++--
>  libmultipath/devmapper.h                 |   2 +-
>  libmultipath/dict.c                      |  20 ++-
>  libmultipath/discovery.c                 |  28 +++--
>  libmultipath/discovery.h                 |   2 +
>  libmultipath/print.c                     |  25 ++--
>  libmultipath/print.h                     |   4 +
>  libmultipath/prioritizers/alua.c         |  44 ++++---
>  libmultipath/prioritizers/alua_rtpg.c    |  69 +++++++----
>  libmultipath/prioritizers/alua_rtpg.h    |   2 +-
>  libmultipath/prioritizers/weightedpath.c |  37 ++++++
>  libmultipath/prioritizers/weightedpath.h |   1 +
>  libmultipath/propsel.c                   |   2 +-
>  libmultipath/structs.h                   |  10 ++
>  libmultipath/uxsock.c                    |  73 +++--------
>  libmultipath/uxsock.h                    |   5 +-
>  libmultipath/wwids.c                     |  19 +--
>  mpathpersist/Makefile                    |   2 +-
>  multipath.conf.defaults                  |   1 +
>  multipath/Makefile                       |   5 +-
>  multipath/main.c                         |   6 +-
>  multipath/multipath.conf.5               |  36 +++++-
>  multipathd/Makefile                      |   5 +-
>  multipathd/cli.c                         |  22 ++--
>  multipathd/cli.h                         |  20 +--
>  multipathd/cli_handlers.c                |  73 ++++++++---
>  multipathd/main.c                        | 205
> ++++++++++++++++++++++++++-----
>  multipathd/main.h                        |   1 +
>  multipathd/multipathd.8                  |   4 +
>  multipathd/multipathd.init.suse          |   2 +-
>  multipathd/multipathd.service            |   3 +-
>  multipathd/uxclnt.c                      |  13 +-
>  multipathd/uxlsnr.c                      |  11 +-
>  49 files changed, 1031 insertions(+), 270 deletions(-)
>  create mode 100644 libmpathcmd/Makefile
>  create mode 100644 libmpathcmd/mpath_cmd.c
>  create mode 100644 libmpathcmd/mpath_cmd.h
>
> --
> 1.8.3.1
>
>

--001a1140160c94d27e0530bf1996
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+SGkgQmVuLDxkaXY+PGJyPjwvZGl2PjxkaXY+VGhpcyBwYXRjaHNldCBp
cyBtZXJnZWQsIHRoYW5rcy48L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PlRoZSB2ZXJzaW9uIGNv
ZGUgaGFzIGJlZW4gYnVtcGVkIHRvIDAuNi4wPC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj5CZXN0
IHJlZ2FyZHMsPC9kaXY+PGRpdj5DaHJpc3RvcGhlIFZhcm9xdWk8L2Rpdj48ZGl2PjxhIGhyZWY9
Imh0dHA6Ly93d3cub3BlbnN2Yy5jb20iPnd3dy5vcGVuc3ZjLmNvbTwvYT48L2Rpdj48ZGl2Pjxi
cj48L2Rpdj48L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9leHRyYSI+PGJyPjxkaXYgY2xhc3M9Imdt
YWlsX3F1b3RlIj5PbiBGcmksIEFwciA4LCAyMDE2IGF0IDE6MTkgQU0sIEJlbmphbWluIE1hcnpp
bnNraSA8c3BhbiBkaXI9Imx0ciI+Jmx0OzxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQu
Y29tIiB0YXJnZXQ9Il9ibGFuayI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT4mZ3Q7PC9zcGFuPiB3
cm90ZTo8YnI+PGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAg
MCAwIC44ZXg7Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI+VGhp
cyBpcyBhIHJlc2VuZCBvZiBteSBwcmV2aW91cyBiYXRjaCBvZiBwYXRjaGVzLsKgIFRoZSBvbmx5
IG9uZSB0aGF0IGhhczxicj4NCmNoYW5nZWQgKGJlc2lkZXMgaW4gb2Zmc2V0cykgaXMgcGF0Y2gg
MTAgJnF1b3Q7bXVsdGlwYXRoZDogZGVsYXkgcmVsb2FkcyBkdXJpbmc8YnI+DQpjcmVhdGlvbiZx
dW90Oy4gSSByZW5hbWVkIHRoZSBjb25maWcgb3B0aW9uICZxdW90O21pc3NpbmdfdWV2X3dhaXRf
dGltZW91dCZxdW90Oy4gV2hlbjxicj4NCml0IHRyaWdnZXJzLCBtdWx0aXBhdGggd2lsbCBzaW1w
bHkgcHJpbnQgYSB3YXJuaW5nIG1lc3NhZ2UgYW5kIHJlLWVuYWJsZTxicj4NCnJlbG9hZHMgYXMg
aWYgaXQgaGFkIHJlY2VpdmVkIHRoZSB1ZXZlbnQuPGJyPg0KPGJyPg0KSSBhbHNvIGFkZGVkIGEg
bmV3IHBhdGNoIHRoYXQgYWRkcyBhIG5ldyBrZXl3b3JkIHRvIHRoZSB3ZWlnaHRlZHBhdGg8YnI+
DQpwcmlvcml0aXplciwgc28gdGhhdCB5b3UgY2FuIHJlZmVyIHRvIHBhdGhzIGluIGEgcGVyc2lz
dGVudCB3YXkuPGJyPg0KPGJyPg0KQmVuamFtaW4gTWFyemluc2tpICgxOCk6PGJyPg0KwqAgbXVs
dGlwYXRoZDogdXNlIC9ydW4gaW5zdGVhZCBvZiAvdmFyL3J1bjxicj4NCsKgIHJldHJpZ2dlciB1
ZXZlbnRzIHRvIHRyeSBhbmQgZ2V0IHRoZSB1aWQgdGhyb3VnaCB1ZGV2PGJyPg0KwqAgRml4IGlz
c3VlcyB3aXRoIHVzZXJfZnJpZW5kbHlfbmFtZXMgaW5pdHJhbWZzIGJpbmRpbmdzPGJyPg0KwqAg
QWRkIGxpYm1wYXRoY21kIGxpYnJhcnkgYW5kIHVzZSBpdCBpbnRlcm5hbGx5PGJyPg0KwqAgbGli
bXVsdGlwYXRoOiBhZGQgaWdub3JlX25ld19ib290X2RldnMgb3B0aW9uPGJyPg0KwqAgbGlibXVs
dGlwYXRoOiBmaXggUEFEIGFuZCBQUklOVCBtYWNyb3M8YnI+DQrCoCBsaWJtdWx0aXBhdGg6IEN1
dCBkb3duIG9uIGFsdWEgcHJpb3JpdGl6ZXIgaW9jdGxzPGJyPg0KwqAgbXVsdGlwYXRoZDogZmFp
bCBpZiBwaWRmaWxlIGNhbiYjMzk7dCBiZSBjcmVhdGVkPGJyPg0KwqAgbGlibXVsdGlwYXRoOiBj
aGVjayBjb3JyZWN0IGZ1bmN0aW9uIGZvciBkZWZpbmU8YnI+DQrCoCBtdWx0aXBhdGhkOiBkZWxh
eSByZWxvYWRzIGR1cmluZyBjcmVhdGlvbjxicj4NCsKgIG11bHRpcGF0aDogRml4IG1pbm9yIHRl
eHQgaXNzdWVzPGJyPg0KwqAga3BhcnR4OiB2ZXJpZnkgcGFydGl0aW9uIGRldmljZXM8YnI+DQrC
oCBtdWx0aXBhdGg6IGFkZCBleGNsdXNpdmVfcHJlZl9iaXQgZm9yIGFsdWEgcHJpbzxicj4NCsKg
IG11bHRpcGF0aGQ6IHByaW50ICZxdW90O2ZhaWwmcXVvdDsgd2hlbiByZW1vdmUgZmFpbHM8YnI+
DQrCoCBtdWx0aXBhdGg6IGNoZWNrIHBhcnRpdGlvbnMgdW51c2VkIGJlZm9yZSByZW1vdmluZzxi
cj4NCsKgIG11bHRpcGF0aGQuc2VydmljZTogcmVtb3ZlIGJsay1hdmFpbGFiaWxpdHkgUmVxdWly
ZXM8YnI+DQrCoCBtdWx0aXBhdGhkOiB1c2UgNjQtYml0IGludCBmb3IgY29tbWFuZCBrZXk8YnI+
DQrCoCBtdWx0aXBhdGg6IGFkZCB3d24ga2V5d29yZCB0byB3ZWlnaHRlZHBhdGggcHJpbzxicj4N
Cjxicj4NCsKgTWFrZWZpbGXCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoHzCoCDCoDEgKzxicj4NCsKgTWFrZWZpbGUuaW5jwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB8wqAgMTIgKy08YnI+DQrCoGtwYXJ0eC9kZXZtYXBw
ZXIuY8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfMKgIDE3ICsrLTxicj4NCsKg
a3BhcnR4L2Rldm1hcHBlci5owqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB8wqAg
wqAyICstPGJyPg0KwqBrcGFydHgva3BhcnR4LmPCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCB8wqAgNzAgKysrKysrKysrKy08YnI+DQrCoGxpYm1wYXRoY21kL01ha2VmaWxl
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB8wqAgMzAgKysrKys8YnI+DQrCoGxpYm1w
YXRoY21kL21wYXRoX2NtZC5jwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfCAxNzggKysrKysr
KysrKysrKysrKysrKysrKysrKysrPGJyPg0KwqBsaWJtcGF0aGNtZC9tcGF0aF9jbWQuaMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIHwgMTI1ICsrKysrKysrKysrKysrKysrKys8YnI+DQrCoGxp
Ym1wYXRocGVyc2lzdC9NYWtlZmlsZcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfMKgIMKgOSAr
LTxicj4NCsKgbGlibXBhdGhwZXJzaXN0L21wYXRoX3BlcnNpc3QuY8KgIMKgIMKgIMKgIMKgIHzC
oCDCoDIgKy08YnI+DQrCoGxpYm1wYXRocGVyc2lzdC9tcGF0aF91cGRhdGVwci5jwqAgwqAgwqAg
wqAgwqB8wqAgMTQgKy0tPGJyPg0KwqBsaWJtdWx0aXBhdGgvTWFrZWZpbGXCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCB8wqAgwqA1ICstPGJyPg0KwqBsaWJtdWx0aXBhdGgvY29uZmlnLmPC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB8wqAgwqA3ICstPGJyPg0KwqBsaWJtdWx0aXBh
dGgvY29uZmlnLmjCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB8wqAgwqA1ICs8YnI+DQrC
oGxpYm11bHRpcGF0aC9jb25maWd1cmUuY8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfMKgIDIw
ICstLTxicj4NCsKgbGlibXVsdGlwYXRoL2RlZmF1bHRzLmjCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCB8wqAgwqA2ICstPGJyPg0KwqBsaWJtdWx0aXBhdGgvZGV2bWFwcGVyLmPCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoHzCoCA0NiArKysrKy0tPGJyPg0KwqBsaWJtdWx0aXBhdGgvZGV2bWFw
cGVyLmjCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHzCoCDCoDIgKy08YnI+DQrCoGxpYm11bHRp
cGF0aC9kaWN0LmPCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB8wqAgMjAgKystPGJy
Pg0KwqBsaWJtdWx0aXBhdGgvZGlzY292ZXJ5LmPCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHzC
oCAyOCArKystLTxicj4NCsKgbGlibXVsdGlwYXRoL2Rpc2NvdmVyeS5owqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqB8wqAgwqAyICs8YnI+DQrCoGxpYm11bHRpcGF0aC9wcmludC5jwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB8wqAgMjUgKystLTxicj4NCsKgbGlibXVsdGlwYXRoL3By
aW50LmjCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHzCoCDCoDQgKzxicj4NCsKgbGli
bXVsdGlwYXRoL3ByaW9yaXRpemVycy9hbHVhLmPCoCDCoCDCoCDCoCDCoHzCoCA0NCArKysrLS0t
PGJyPg0KwqBsaWJtdWx0aXBhdGgvcHJpb3JpdGl6ZXJzL2FsdWFfcnRwZy5jwqAgwqAgfMKgIDY5
ICsrKysrKystLS0tPGJyPg0KwqBsaWJtdWx0aXBhdGgvcHJpb3JpdGl6ZXJzL2FsdWFfcnRwZy5o
wqAgwqAgfMKgIMKgMiArLTxicj4NCsKgbGlibXVsdGlwYXRoL3ByaW9yaXRpemVycy93ZWlnaHRl
ZHBhdGguYyB8wqAgMzcgKysrKysrPGJyPg0KwqBsaWJtdWx0aXBhdGgvcHJpb3JpdGl6ZXJzL3dl
aWdodGVkcGF0aC5oIHzCoCDCoDEgKzxicj4NCsKgbGlibXVsdGlwYXRoL3Byb3BzZWwuY8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfMKgIMKgMiArLTxicj4NCsKgbGlibXVsdGlwYXRoL3N0
cnVjdHMuaMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfMKgIDEwICsrPGJyPg0KwqBsaWJt
dWx0aXBhdGgvdXhzb2NrLmPCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB8wqAgNzMgKysr
LS0tLS0tLS08YnI+DQrCoGxpYm11bHRpcGF0aC91eHNvY2suaMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIHzCoCDCoDUgKy08YnI+DQrCoGxpYm11bHRpcGF0aC93d2lkcy5jwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB8wqAgMTkgKy0tPGJyPg0KwqBtcGF0aHBlcnNpc3QvTWFr
ZWZpbGXCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB8wqAgwqAyICstPGJyPg0KwqBtdWx0
aXBhdGguY29uZi5kZWZhdWx0c8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHzCoCDCoDEgKzxi
cj4NCsKgbXVsdGlwYXRoL01ha2VmaWxlwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqB8wqAgwqA1ICstPGJyPg0KwqBtdWx0aXBhdGgvbWFpbi5jwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqB8wqAgwqA2ICstPGJyPg0KwqBtdWx0aXBhdGgvbXVsdGlwYXRoLmNv
bmYuNcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfMKgIDM2ICsrKysrLTxicj4NCsKgbXVsdGlwYXRo
ZC9NYWtlZmlsZcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHzCoCDCoDUgKy08YnI+
DQrCoG11bHRpcGF0aGQvY2xpLmPCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oHzCoCAyMiArKy0tPGJyPg0KwqBtdWx0aXBhdGhkL2NsaS5owqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqB8wqAgMjAgKy0tPGJyPg0KwqBtdWx0aXBhdGhkL2NsaV9oYW5kbGVy
cy5jwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfMKgIDczICsrKysrKysrLS0tPGJyPg0KwqBtdWx0
aXBhdGhkL21haW4uY8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHwgMjA1ICsr
KysrKysrKysrKysrKysrKysrKysrKysrLS0tLS08YnI+DQrCoG11bHRpcGF0aGQvbWFpbi5owqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfMKgIMKgMSArPGJyPg0KwqBtdWx0aXBh
dGhkL211bHRpcGF0aGQuOMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHzCoCDCoDQgKzxicj4N
CsKgbXVsdGlwYXRoZC9tdWx0aXBhdGhkLmluaXQuc3VzZcKgIMKgIMKgIMKgIMKgIHzCoCDCoDIg
Ky08YnI+DQrCoG11bHRpcGF0aGQvbXVsdGlwYXRoZC5zZXJ2aWNlwqAgwqAgwqAgwqAgwqAgwqAg
fMKgIMKgMyArLTxicj4NCsKgbXVsdGlwYXRoZC91eGNsbnQuY8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIHzCoCAxMyArLTxicj4NCsKgbXVsdGlwYXRoZC91eGxzbnIuY8KgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHzCoCAxMSArLTxicj4NCsKgNDkgZmlsZXMgY2hhbmdl
ZCwgMTAzMSBpbnNlcnRpb25zKCspLCAyNzAgZGVsZXRpb25zKC0pPGJyPg0KwqBjcmVhdGUgbW9k
ZSAxMDA2NDQgbGlibXBhdGhjbWQvTWFrZWZpbGU8YnI+DQrCoGNyZWF0ZSBtb2RlIDEwMDY0NCBs
aWJtcGF0aGNtZC9tcGF0aF9jbWQuYzxicj4NCsKgY3JlYXRlIG1vZGUgMTAwNjQ0IGxpYm1wYXRo
Y21kL21wYXRoX2NtZC5oPGJyPg0KPHNwYW4gY2xhc3M9IkhPRW5aYiI+PGZvbnQgY29sb3I9IiM4
ODg4ODgiPjxicj4NCi0tPGJyPg0KMS44LjMuMTxicj4NCjxicj4NCjwvZm9udD48L3NwYW4+PC9i
bG9ja3F1b3RlPjwvZGl2Pjxicj48L2Rpdj4NCg==
--001a1140160c94d27e0530bf1996--


--===============5462914942399381472==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5462914942399381472==--
