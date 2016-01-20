From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] kpartx: support device names with spaces
Date: Wed, 20 Jan 2016 08:15:05 +0100
Message-ID: <CABr-GncCqpkdNcw4ShHxigHKqB+feesNDoUHHfkR_1vkJQ5BmA@mail.gmail.com>
References: <1452191515-4027-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3009493185717095273=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1452191515-4027-1-git-send-email-mauricfo@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3009493185717095273==
Content-Type: multipart/alternative; boundary=089e01177191d79fa70529bebe5d

--089e01177191d79fa70529bebe5d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

shouldn't you either define the MAJOR and MINOR macros, or include the
appropriate kernel header ? As is the build emits :

kpartx.c:481:8: warning: implicit declaration of function =E2=80=98MAJOR=E2=
=80=99
[-Wimplicit-function-declaration]
        MAJOR(buf.st_rdev), MINOR(buf.st_rdev), slices[j].start)) {
...

And the linking emits :

kpartx.o: In function `main':
/home/cvaroqui/multipath-tools/kpartx/kpartx.c:480: undefined reference to
`MINOR'
/home/cvaroqui/multipath-tools/kpartx/kpartx.c:480: undefined reference to
`MAJOR'
...

Regards,
Christophe Varoqui
OpenSVC

On Thu, Jan 7, 2016 at 7:31 PM, Mauricio Faria de Oliveira <
mauricfo@linux.vnet.ibm.com> wrote:

> Device names with spaces fail to be added to device-mapper tables
> because spaces are field separators.  In order to support it, use
> device major:minor numbers, instead.  While still there, make the
> verbose output of container- and contained-slices consistent.
>
> This is useful on some scenarios with arbitrary loop device names,
> and non-user_friendly_names multipath WWIDs with spaces (eg, QEMU
> emulated hard drives, and some IBM devices) on some distros.
>
> Test-case:
>
>         # img=3D"/tmp/my.img"
>         # spacename=3D"/dev/my space name"
>
>         # truncate --size=3D1G "$img"
>         # lodev=3D$(sudo losetup --find --show "$img")
>         # ln -sf "$lodev" "$spacename"
>
>         # ls -l $lodev "$spacename"
>         brw-rw---- 1 root disk 7, 0 Jan  7 10:36 /dev/loop0
>         lrwxrwxrwx 1 root root   10 Jan  7 10:36 /dev/my space name ->
> /dev/loop0
>
>         # fdisk $lodev
>         <...>
>
>         # fdisk -l $lodev
>         <...>
>               Device Boot      Start         End      Blocks   Id  System
>         /dev/loop0p1            2048      264191      131072   83  Linux
>         /dev/loop0p2          264192      788479      262144   83  Linux
>         /dev/loop0p3          788480     2097151      654336    5  Extend=
ed
>         /dev/loop0p5          790528      856063       32768   83  Linux
>         /dev/loop0p6          858112      989183       65536   83  Linux
>         /dev/loop0p7          991232     1515519      262144   83  Linux
>
> Without patch:
>
>         # kpartx -av "$spacename"
>         device-mapper: reload ioctl on my\x20space\x20name1 failed:
> Invalid argument
>         create/reload failed on my space name1
>         add map my space name1 (0:0): 0 262144 linear /dev/my space name
> 2048
>
>         device-mapper: reload ioctl on my\x20space\x20name2 failed:
> Invalid argument
>         create/reload failed on my space name2
>         add map my space name2 (0:0): 0 524288 linear /dev/my space name
> 264192
>
>         device-mapper: reload ioctl on my\x20space\x20name3 failed:
> Invalid argument
>         create/reload failed on my space name3
>         add map my space name3 (0:0): 0 2 linear /dev/my space name 78848=
0
>
>         device-mapper: reload ioctl on my\x20space\x20name5 failed:
> Invalid argument
>         add map my space name5 : 0 65536 linear /dev/my space name 790528
>
>         device-mapper: reload ioctl on my\x20space\x20name6 failed:
> Invalid argument
>         add map my space name6 : 0 131072 linear /dev/my space name 85811=
2
>
>         device-mapper: reload ioctl on my\x20space\x20name7 failed:
> Invalid argument
>         add map my space name7 : 0 524288 linear /dev/my space name 99123=
2
>
> With patch:
>
>         # kpartx -av "$spacename"
>         add map my space name1 (252:6): 0 262144 linear 7:0 2048
>         add map my space name2 (252:7): 0 524288 linear 7:0 264192
>         add map my space name3 (252:8): 0 2 linear 7:0 788480
>         add map my space name5 (252:9): 0 65536 linear 7:0 790528
>         add map my space name6 (252:10): 0 131072 linear 7:0 858112
>         add map my space name7 (252:11): 0 524288 linear 7:0 991232
>
>         # dmsetup table | sort
>         my space name1: 0 262144 linear 7:0 2048
>         my space name2: 0 524288 linear 7:0 264192
>         my space name3: 0 2 linear 7:0 788480
>         my space name5: 0 65536 linear 7:0 790528
>         my space name6: 0 131072 linear 7:0 858112
>         my space name7: 0 524288 linear 7:0 991232
>
>         # ls -l /dev/mapper/
>         total 0
>         crw------- 1 root root  10, 236 Jan  7 12:00 control
>         brw-rw---- 1 root disk 252,   6 Jan  7 15:50 my\x20space\x20name1
>         brw-rw---- 1 root disk 252,   7 Jan  7 15:50 my\x20space\x20name2
>         brw-rw---- 1 root disk 252,   8 Jan  7 15:50 my\x20space\x20name3
>         brw-rw---- 1 root disk 252,   9 Jan  7 15:50 my\x20space\x20name5
>         brw-rw---- 1 root disk 252,  10 Jan  7 15:50 my\x20space\x20name6
>         brw-rw---- 1 root disk 252,  11 Jan  7 15:50 my\x20space\x20name7
>
> Thanks: Scott Moser (pointers to the error and test-case).
>
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> ---
>  kpartx/kpartx.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index a9d4c98..d5eeea9 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -477,8 +477,8 @@ main(int argc, char **argv){
>                                 }
>                                 strip_slash(partname);
>
> -                               if (safe_sprintf(params, "%s %" PRIu64 ,
> -                                                device, slices[j].start)=
)
> {
> +                               if (safe_sprintf(params, "%d:%d %" PRIu64=
 ,
> +                                                MAJOR(buf.st_rdev),
> MINOR(buf.st_rdev), slices[j].start)) {
>                                         fprintf(stderr, "params too
> small\n");
>                                         exit(1);
>                                 }
> @@ -540,8 +540,8 @@ main(int argc, char **argv){
>                                         }
>                                         strip_slash(partname);
>
> -                                       if (safe_sprintf(params, "%s %"
> PRIu64,
> -                                                        device,
> +                                       if (safe_sprintf(params, "%d:%d %=
"
> PRIu64,
> +
> MAJOR(buf.st_rdev), MINOR(buf.st_rdev),
>                                                          slices[j].start)=
)
> {
>                                                 fprintf(stderr, "params
> too small\n");
>                                                 exit(1);
> @@ -563,8 +563,8 @@ main(int argc, char **argv){
>                                                 &slices[j].minor);
>
>                                         if (verbose)
> -                                               printf("add map %s : 0 %"
> PRIu64 " %s %s\n",
> -                                                      partname,
> slices[j].size,
> +                                               printf("add map %s
> (%d:%d): 0 %" PRIu64 " %s %s\n",
> +                                                      partname,
> slices[j].major, slices[j].minor, slices[j].size,
>                                                        DM_TARGET, params)=
;
>                                         c--;
>                                 }
> --
> 1.8.3.1
>
>

--089e01177191d79fa70529bebe5d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+SGVsbG8sPGRpdj48YnI+PC9kaXY+PGRpdj5zaG91bGRuJiMzOTt0IHlv
dSBlaXRoZXIgZGVmaW5lIHRoZSBNQUpPUiBhbmQgTUlOT1IgbWFjcm9zLCBvciBpbmNsdWRlIHRo
ZSBhcHByb3ByaWF0ZSBrZXJuZWwgaGVhZGVyID8gQXMgaXMgdGhlIGJ1aWxkIGVtaXRzIDo8L2Rp
dj48ZGl2Pjxicj48L2Rpdj48ZGl2PjxkaXY+a3BhcnR4LmM6NDgxOjg6IHdhcm5pbmc6IGltcGxp
Y2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uIOKAmE1BSk9S4oCZIFstV2ltcGxpY2l0LWZ1bmN0
aW9uLWRlY2xhcmF0aW9uXTwvZGl2PjxkaXY+wqAgwqAgwqAgwqAgTUFKT1IoYnVmLnN0X3JkZXYp
LCBNSU5PUihidWYuc3RfcmRldiksIHNsaWNlc1tqXS5zdGFydCkpIHs8L2Rpdj48L2Rpdj48ZGl2
Pi4uLjwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+QW5kIHRoZSBsaW5raW5nIGVtaXRzIDo8L2Rp
dj48ZGl2Pjxicj48L2Rpdj48ZGl2PjxkaXY+a3BhcnR4Lm86IEluIGZ1bmN0aW9uIGBtYWluJiMz
OTs6PC9kaXY+PGRpdj4vaG9tZS9jdmFyb3F1aS9tdWx0aXBhdGgtdG9vbHMva3BhcnR4L2twYXJ0
eC5jOjQ4MDogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgTUlOT1ImIzM5OzwvZGl2PjxkaXY+L2hv
bWUvY3Zhcm9xdWkvbXVsdGlwYXRoLXRvb2xzL2twYXJ0eC9rcGFydHguYzo0ODA6IHVuZGVmaW5l
ZCByZWZlcmVuY2UgdG8gYE1BSk9SJiMzOTs8L2Rpdj48L2Rpdj48ZGl2Pi4uLjwvZGl2PjxkaXY+
PGJyPjwvZGl2PjxkaXY+UmVnYXJkcyw8L2Rpdj48ZGl2PkNocmlzdG9waGUgVmFyb3F1aTwvZGl2
PjxkaXY+T3BlblNWQzwvZGl2PjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48YnI+PGRp
diBjbGFzcz0iZ21haWxfcXVvdGUiPk9uIFRodSwgSmFuIDcsIDIwMTYgYXQgNzozMSBQTSwgTWF1
cmljaW8gRmFyaWEgZGUgT2xpdmVpcmEgPHNwYW4gZGlyPSJsdHIiPiZsdDs8YSBocmVmPSJtYWls
dG86bWF1cmljZm9AbGludXgudm5ldC5pYm0uY29tIiB0YXJnZXQ9Il9ibGFuayI+bWF1cmljZm9A
bGludXgudm5ldC5pYm0uY29tPC9hPiZndDs8L3NwYW4+IHdyb3RlOjxicj48YmxvY2txdW90ZSBj
bGFzcz0iZ21haWxfcXVvdGUiIHN0eWxlPSJtYXJnaW46MCAwIDAgLjhleDtib3JkZXItbGVmdDox
cHggI2NjYyBzb2xpZDtwYWRkaW5nLWxlZnQ6MWV4Ij5EZXZpY2UgbmFtZXMgd2l0aCBzcGFjZXMg
ZmFpbCB0byBiZSBhZGRlZCB0byBkZXZpY2UtbWFwcGVyIHRhYmxlczxicj4NCmJlY2F1c2Ugc3Bh
Y2VzIGFyZSBmaWVsZCBzZXBhcmF0b3JzLsKgIEluIG9yZGVyIHRvIHN1cHBvcnQgaXQsIHVzZTxi
cj4NCmRldmljZSBtYWpvcjptaW5vciBudW1iZXJzLCBpbnN0ZWFkLsKgIFdoaWxlIHN0aWxsIHRo
ZXJlLCBtYWtlIHRoZTxicj4NCnZlcmJvc2Ugb3V0cHV0IG9mIGNvbnRhaW5lci0gYW5kIGNvbnRh
aW5lZC1zbGljZXMgY29uc2lzdGVudC48YnI+DQo8YnI+DQpUaGlzIGlzIHVzZWZ1bCBvbiBzb21l
IHNjZW5hcmlvcyB3aXRoIGFyYml0cmFyeSBsb29wIGRldmljZSBuYW1lcyw8YnI+DQphbmQgbm9u
LXVzZXJfZnJpZW5kbHlfbmFtZXMgbXVsdGlwYXRoIFdXSURzIHdpdGggc3BhY2VzIChlZywgUUVN
VTxicj4NCmVtdWxhdGVkIGhhcmQgZHJpdmVzLCBhbmQgc29tZSBJQk0gZGV2aWNlcykgb24gc29t
ZSBkaXN0cm9zLjxicj4NCjxicj4NClRlc3QtY2FzZTo8YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCAj
IGltZz0mcXVvdDsvdG1wL215LmltZyZxdW90Ozxicj4NCsKgIMKgIMKgIMKgICMgc3BhY2VuYW1l
PSZxdW90Oy9kZXYvbXkgc3BhY2UgbmFtZSZxdW90Ozxicj4NCjxicj4NCsKgIMKgIMKgIMKgICMg
dHJ1bmNhdGUgLS1zaXplPTFHICZxdW90OyRpbWcmcXVvdDs8YnI+DQrCoCDCoCDCoCDCoCAjIGxv
ZGV2PSQoc3VkbyBsb3NldHVwIC0tZmluZCAtLXNob3cgJnF1b3Q7JGltZyZxdW90Oyk8YnI+DQrC
oCDCoCDCoCDCoCAjIGxuIC1zZiAmcXVvdDskbG9kZXYmcXVvdDsgJnF1b3Q7JHNwYWNlbmFtZSZx
dW90Ozxicj4NCjxicj4NCsKgIMKgIMKgIMKgICMgbHMgLWwgJGxvZGV2ICZxdW90OyRzcGFjZW5h
bWUmcXVvdDs8YnI+DQrCoCDCoCDCoCDCoCBicnctcnctLS0tIDEgcm9vdCBkaXNrIDcsIDAgSmFu
wqAgNyAxMDozNiAvZGV2L2xvb3AwPGJyPg0KwqAgwqAgwqAgwqAgbHJ3eHJ3eHJ3eCAxIHJvb3Qg
cm9vdMKgIMKgMTAgSmFuwqAgNyAxMDozNiAvZGV2L215IHNwYWNlIG5hbWUgLSZndDsgL2Rldi9s
b29wMDxicj4NCjxicj4NCsKgIMKgIMKgIMKgICMgZmRpc2sgJGxvZGV2PGJyPg0KwqAgwqAgwqAg
wqAgJmx0Oy4uLiZndDs8YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCAjIGZkaXNrIC1sICRsb2Rldjxi
cj4NCsKgIMKgIMKgIMKgICZsdDsuLi4mZ3Q7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgRGV2
aWNlIEJvb3TCoCDCoCDCoCBTdGFydMKgIMKgIMKgIMKgIMKgRW5kwqAgwqAgwqAgQmxvY2tzwqAg
wqBJZMKgIFN5c3RlbTxicj4NCsKgIMKgIMKgIMKgIC9kZXYvbG9vcDBwMcKgIMKgIMKgIMKgIMKg
IMKgIDIwNDjCoCDCoCDCoCAyNjQxOTHCoCDCoCDCoCAxMzEwNzLCoCDCoDgzwqAgTGludXg8YnI+
DQrCoCDCoCDCoCDCoCAvZGV2L2xvb3AwcDLCoCDCoCDCoCDCoCDCoCAyNjQxOTLCoCDCoCDCoCA3
ODg0NznCoCDCoCDCoCAyNjIxNDTCoCDCoDgzwqAgTGludXg8YnI+DQrCoCDCoCDCoCDCoCAvZGV2
L2xvb3AwcDPCoCDCoCDCoCDCoCDCoCA3ODg0ODDCoCDCoCDCoDIwOTcxNTHCoCDCoCDCoCA2NTQz
MzbCoCDCoCA1wqAgRXh0ZW5kZWQ8YnI+DQrCoCDCoCDCoCDCoCAvZGV2L2xvb3AwcDXCoCDCoCDC
oCDCoCDCoCA3OTA1MjjCoCDCoCDCoCA4NTYwNjPCoCDCoCDCoCDCoDMyNzY4wqAgwqA4M8KgIExp
bnV4PGJyPg0KwqAgwqAgwqAgwqAgL2Rldi9sb29wMHA2wqAgwqAgwqAgwqAgwqAgODU4MTEywqAg
wqAgwqAgOTg5MTgzwqAgwqAgwqAgwqA2NTUzNsKgIMKgODPCoCBMaW51eDxicj4NCsKgIMKgIMKg
IMKgIC9kZXYvbG9vcDBwN8KgIMKgIMKgIMKgIMKgIDk5MTIzMsKgIMKgIMKgMTUxNTUxOcKgIMKg
IMKgIDI2MjE0NMKgIMKgODPCoCBMaW51eDxicj4NCjxicj4NCldpdGhvdXQgcGF0Y2g6PGJyPg0K
PGJyPg0KwqAgwqAgwqAgwqAgIyBrcGFydHggLWF2ICZxdW90OyRzcGFjZW5hbWUmcXVvdDs8YnI+
DQrCoCDCoCDCoCDCoCBkZXZpY2UtbWFwcGVyOiByZWxvYWQgaW9jdGwgb24gbXlceDIwc3BhY2Vc
eDIwbmFtZTEgZmFpbGVkOiBJbnZhbGlkIGFyZ3VtZW50PGJyPg0KwqAgwqAgwqAgwqAgY3JlYXRl
L3JlbG9hZCBmYWlsZWQgb24gbXkgc3BhY2UgbmFtZTE8YnI+DQrCoCDCoCDCoCDCoCBhZGQgbWFw
IG15IHNwYWNlIG5hbWUxICgwOjApOiAwIDI2MjE0NCBsaW5lYXIgL2Rldi9teSBzcGFjZSBuYW1l
IDIwNDg8YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCBkZXZpY2UtbWFwcGVyOiByZWxvYWQgaW9jdGwg
b24gbXlceDIwc3BhY2VceDIwbmFtZTIgZmFpbGVkOiBJbnZhbGlkIGFyZ3VtZW50PGJyPg0KwqAg
wqAgwqAgwqAgY3JlYXRlL3JlbG9hZCBmYWlsZWQgb24gbXkgc3BhY2UgbmFtZTI8YnI+DQrCoCDC
oCDCoCDCoCBhZGQgbWFwIG15IHNwYWNlIG5hbWUyICgwOjApOiAwIDUyNDI4OCBsaW5lYXIgL2Rl
di9teSBzcGFjZSBuYW1lIDI2NDE5Mjxicj4NCjxicj4NCsKgIMKgIMKgIMKgIGRldmljZS1tYXBw
ZXI6IHJlbG9hZCBpb2N0bCBvbiBteVx4MjBzcGFjZVx4MjBuYW1lMyBmYWlsZWQ6IEludmFsaWQg
YXJndW1lbnQ8YnI+DQrCoCDCoCDCoCDCoCBjcmVhdGUvcmVsb2FkIGZhaWxlZCBvbiBteSBzcGFj
ZSBuYW1lMzxicj4NCsKgIMKgIMKgIMKgIGFkZCBtYXAgbXkgc3BhY2UgbmFtZTMgKDA6MCk6IDAg
MiBsaW5lYXIgL2Rldi9teSBzcGFjZSBuYW1lIDc4ODQ4MDxicj4NCjxicj4NCsKgIMKgIMKgIMKg
IGRldmljZS1tYXBwZXI6IHJlbG9hZCBpb2N0bCBvbiBteVx4MjBzcGFjZVx4MjBuYW1lNSBmYWls
ZWQ6IEludmFsaWQgYXJndW1lbnQ8YnI+DQrCoCDCoCDCoCDCoCBhZGQgbWFwIG15IHNwYWNlIG5h
bWU1IDogMCA2NTUzNiBsaW5lYXIgL2Rldi9teSBzcGFjZSBuYW1lIDc5MDUyODxicj4NCjxicj4N
CsKgIMKgIMKgIMKgIGRldmljZS1tYXBwZXI6IHJlbG9hZCBpb2N0bCBvbiBteVx4MjBzcGFjZVx4
MjBuYW1lNiBmYWlsZWQ6IEludmFsaWQgYXJndW1lbnQ8YnI+DQrCoCDCoCDCoCDCoCBhZGQgbWFw
IG15IHNwYWNlIG5hbWU2IDogMCAxMzEwNzIgbGluZWFyIC9kZXYvbXkgc3BhY2UgbmFtZSA4NTgx
MTI8YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCBkZXZpY2UtbWFwcGVyOiByZWxvYWQgaW9jdGwgb24g
bXlceDIwc3BhY2VceDIwbmFtZTcgZmFpbGVkOiBJbnZhbGlkIGFyZ3VtZW50PGJyPg0KwqAgwqAg
wqAgwqAgYWRkIG1hcCBteSBzcGFjZSBuYW1lNyA6IDAgNTI0Mjg4IGxpbmVhciAvZGV2L215IHNw
YWNlIG5hbWUgOTkxMjMyPGJyPg0KPGJyPg0KV2l0aCBwYXRjaDo8YnI+DQo8YnI+DQrCoCDCoCDC
oCDCoCAjIGtwYXJ0eCAtYXYgJnF1b3Q7JHNwYWNlbmFtZSZxdW90Ozxicj4NCsKgIMKgIMKgIMKg
IGFkZCBtYXAgbXkgc3BhY2UgbmFtZTEgKDI1Mjo2KTogMCAyNjIxNDQgbGluZWFyIDc6MCAyMDQ4
PGJyPg0KwqAgwqAgwqAgwqAgYWRkIG1hcCBteSBzcGFjZSBuYW1lMiAoMjUyOjcpOiAwIDUyNDI4
OCBsaW5lYXIgNzowIDI2NDE5Mjxicj4NCsKgIMKgIMKgIMKgIGFkZCBtYXAgbXkgc3BhY2UgbmFt
ZTMgKDI1Mjo4KTogMCAyIGxpbmVhciA3OjAgNzg4NDgwPGJyPg0KwqAgwqAgwqAgwqAgYWRkIG1h
cCBteSBzcGFjZSBuYW1lNSAoMjUyOjkpOiAwIDY1NTM2IGxpbmVhciA3OjAgNzkwNTI4PGJyPg0K
wqAgwqAgwqAgwqAgYWRkIG1hcCBteSBzcGFjZSBuYW1lNiAoMjUyOjEwKTogMCAxMzEwNzIgbGlu
ZWFyIDc6MCA4NTgxMTI8YnI+DQrCoCDCoCDCoCDCoCBhZGQgbWFwIG15IHNwYWNlIG5hbWU3ICgy
NTI6MTEpOiAwIDUyNDI4OCBsaW5lYXIgNzowIDk5MTIzMjxicj4NCjxicj4NCsKgIMKgIMKgIMKg
ICMgZG1zZXR1cCB0YWJsZSB8IHNvcnQ8YnI+DQrCoCDCoCDCoCDCoCBteSBzcGFjZSBuYW1lMTog
MCAyNjIxNDQgbGluZWFyIDc6MCAyMDQ4PGJyPg0KwqAgwqAgwqAgwqAgbXkgc3BhY2UgbmFtZTI6
IDAgNTI0Mjg4IGxpbmVhciA3OjAgMjY0MTkyPGJyPg0KwqAgwqAgwqAgwqAgbXkgc3BhY2UgbmFt
ZTM6IDAgMiBsaW5lYXIgNzowIDc4ODQ4MDxicj4NCsKgIMKgIMKgIMKgIG15IHNwYWNlIG5hbWU1
OiAwIDY1NTM2IGxpbmVhciA3OjAgNzkwNTI4PGJyPg0KwqAgwqAgwqAgwqAgbXkgc3BhY2UgbmFt
ZTY6IDAgMTMxMDcyIGxpbmVhciA3OjAgODU4MTEyPGJyPg0KwqAgwqAgwqAgwqAgbXkgc3BhY2Ug
bmFtZTc6IDAgNTI0Mjg4IGxpbmVhciA3OjAgOTkxMjMyPGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAg
IyBscyAtbCAvZGV2L21hcHBlci88YnI+DQrCoCDCoCDCoCDCoCB0b3RhbCAwPGJyPg0KwqAgwqAg
wqAgwqAgY3J3LS0tLS0tLSAxIHJvb3Qgcm9vdMKgIDEwLCAyMzYgSmFuwqAgNyAxMjowMCBjb250
cm9sPGJyPg0KwqAgwqAgwqAgwqAgYnJ3LXJ3LS0tLSAxIHJvb3QgZGlzayAyNTIswqAgwqA2IEph
bsKgIDcgMTU6NTAgbXlceDIwc3BhY2VceDIwbmFtZTE8YnI+DQrCoCDCoCDCoCDCoCBicnctcnct
LS0tIDEgcm9vdCBkaXNrIDI1MizCoCDCoDcgSmFuwqAgNyAxNTo1MCBteVx4MjBzcGFjZVx4MjBu
YW1lMjxicj4NCsKgIMKgIMKgIMKgIGJydy1ydy0tLS0gMSByb290IGRpc2sgMjUyLMKgIMKgOCBK
YW7CoCA3IDE1OjUwIG15XHgyMHNwYWNlXHgyMG5hbWUzPGJyPg0KwqAgwqAgwqAgwqAgYnJ3LXJ3
LS0tLSAxIHJvb3QgZGlzayAyNTIswqAgwqA5IEphbsKgIDcgMTU6NTAgbXlceDIwc3BhY2VceDIw
bmFtZTU8YnI+DQrCoCDCoCDCoCDCoCBicnctcnctLS0tIDEgcm9vdCBkaXNrIDI1MizCoCAxMCBK
YW7CoCA3IDE1OjUwIG15XHgyMHNwYWNlXHgyMG5hbWU2PGJyPg0KwqAgwqAgwqAgwqAgYnJ3LXJ3
LS0tLSAxIHJvb3QgZGlzayAyNTIswqAgMTEgSmFuwqAgNyAxNTo1MCBteVx4MjBzcGFjZVx4MjBu
YW1lNzxicj4NCjxicj4NClRoYW5rczogU2NvdHQgTW9zZXIgKHBvaW50ZXJzIHRvIHRoZSBlcnJv
ciBhbmQgdGVzdC1jYXNlKS48YnI+DQo8YnI+DQpTaWduZWQtb2ZmLWJ5OiBNYXVyaWNpbyBGYXJp
YSBkZSBPbGl2ZWlyYSAmbHQ7PGEgaHJlZj0ibWFpbHRvOm1hdXJpY2ZvQGxpbnV4LnZuZXQuaWJt
LmNvbSI+bWF1cmljZm9AbGludXgudm5ldC5pYm0uY29tPC9hPiZndDs8YnI+DQotLS08YnI+DQrC
oGtwYXJ0eC9rcGFydHguYyB8IDEyICsrKysrKy0tLS0tLTxicj4NCsKgMSBmaWxlIGNoYW5nZWQs
IDYgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSk8YnI+DQo8YnI+DQpkaWZmIC0tZ2l0IGEv
a3BhcnR4L2twYXJ0eC5jIGIva3BhcnR4L2twYXJ0eC5jPGJyPg0KaW5kZXggYTlkNGM5OC4uZDVl
ZWVhOSAxMDA2NDQ8YnI+DQotLS0gYS9rcGFydHgva3BhcnR4LmM8YnI+DQorKysgYi9rcGFydHgv
a3BhcnR4LmM8YnI+DQpAQCAtNDc3LDggKzQ3Nyw4IEBAIG1haW4oaW50IGFyZ2MsIGNoYXIgKiph
cmd2KXs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCB9PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
c3RyaXBfc2xhc2gocGFydG5hbWUpOzxicj4NCjxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmIChzYWZlX3NwcmludGYocGFyYW1zLCAmcXVvdDsl
cyAlJnF1b3Q7IFBSSXU2NCAsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGRldmljZSwgc2xpY2VzW2pd
LnN0YXJ0KSkgezxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoGlmIChzYWZlX3NwcmludGYocGFyYW1zLCAmcXVvdDslZDolZCAlJnF1b3Q7IFBSSXU2
NCAsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIE1BSk9SKGJ1Zi5zdF9yZGV2KSwgTUlOT1IoYnVmLnN0
X3JkZXYpLCBzbGljZXNbal0uc3RhcnQpKSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZnByaW50ZihzdGRlcnIsICZxdW90
O3BhcmFtcyB0b28gc21hbGxcbiZxdW90Oyk7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZXhpdCgxKTs8YnI+DQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB9PGJyPg0KQEAgLTU0MCw4
ICs1NDAsOCBAQCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndil7PGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfTxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IHN0cmlwX3NsYXNoKHBhcnRuYW1lKTs8YnI+DQo8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAoc2FmZV9zcHJpbnRmKHBh
cmFtcywgJnF1b3Q7JXMgJSZxdW90OyBQUkl1NjQsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIGRldmljZSw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAoc2FmZV9zcHJpbnRmKHBhcmFtcywgJnF1b3Q7JWQ6
JWQgJSZxdW90OyBQUkl1NjQsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIE1BSk9S
KGJ1Zi5zdF9yZGV2KSwgTUlOT1IoYnVmLnN0X3JkZXYpLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgc2xpY2VzW2pdLnN0YXJ0KSkgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGZwcmlu
dGYoc3RkZXJyLCAmcXVvdDtwYXJhbXMgdG9vIHNtYWxsXG4mcXVvdDspOzxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIGV4aXQoMSk7PGJyPg0KQEAgLTU2Myw4ICs1NjMsOCBAQCBtYWluKGludCBhcmdjLCBj
aGFyICoqYXJndil7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgJmFtcDtzbGljZXNbal0ubWlub3IpOzxi
cj4NCjxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIGlmICh2ZXJib3NlKTxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHByaW50ZigmcXVv
dDthZGQgbWFwICVzIDogMCAlJnF1b3Q7IFBSSXU2NCAmcXVvdDsgJXMgJXNcbiZxdW90Oyw8YnI+
DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcGFydG5hbWUsIHNsaWNlc1tqXS5zaXplLDxicj4N
CivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoHByaW50ZigmcXVvdDthZGQgbWFwICVzICglZDolZCk6IDAgJSZxdW90
OyBQUkl1NjQgJnF1b3Q7ICVzICVzXG4mcXVvdDssPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIHBhcnRuYW1lLCBzbGljZXNbal0ubWFqb3IsIHNsaWNlc1tqXS5taW5vciwgc2xpY2VzW2pd
LnNpemUsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBETV9UQVJHRVQsIHBhcmFtcyk7
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgYy0tOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIH08YnI+DQo8c3BhbiBjbGFzcz0iSE9FblpiIj48Zm9udCBjb2xvcj0iIzg4ODg4
OCI+LS08YnI+DQoxLjguMy4xPGJyPg0KPGJyPg0KPC9mb250Pjwvc3Bhbj48L2Jsb2NrcXVvdGU+
PC9kaXY+PGJyPjwvZGl2Pg0K
--089e01177191d79fa70529bebe5d--


--===============3009493185717095273==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3009493185717095273==--
