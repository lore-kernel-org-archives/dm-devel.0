From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH V2] kpartx: support device names with spaces
Date: Wed, 20 Jan 2016 15:53:42 +0100
Message-ID: <CABr-GnfeNpQPcuoRSLHTA5q8E3OF8as1zOTY7SP=bwMwtC=MFQ@mail.gmail.com>
References: <1453297965-32278-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4652234551246862716=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1453297965-32278-1-git-send-email-mauricfo@linux.vnet.ibm.com>
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

--===============4652234551246862716==
Content-Type: multipart/alternative; boundary=001a114035acf325bd0529c526d0

--001a114035acf325bd0529c526d0
Content-Type: text/plain; charset=UTF-8

Applied,
thanks.

On Wed, Jan 20, 2016 at 2:52 PM, Mauricio Faria de Oliveira <
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
> Changelog:
> - V2: Use major()/minor() instead of MAJOR()/MINOR() (build errors).
>       Update test-case verification output.
>       Thanks: Christophe Varoqui
>
> Test-case:
>
>         # img="/tmp/my.img"
>         # spacename="/dev/my space name"
>
>         # truncate --size=1G "$img"
>         # lodev=$(sudo losetup --find --show "$img")
>         # ln -sf "$lodev" "$spacename"
>
>         # ls -l $lodev "$spacename"
>         brw-rw----. 1 root disk 7, 0 Jan 20 11:15 /dev/loop0
>         lrwxrwxrwx. 1 root root   10 Jan 20 11:16 /dev/my space name ->
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
>         /dev/loop0p3          788480     2097151      654336    5  Extended
>         /dev/loop0p5          790528      856063       32768   83  Linux
>         /dev/loop0p6          858112      989183       65536   83  Linux
>         /dev/loop0p7          991232     1515519      262144   83  Linux
>
> Without patch:
>
>         # ./kpartx/kpartx -av "$spacename"
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
>         add map my space name3 (0:0): 0 2 linear /dev/my space name 788480
>
>         device-mapper: reload ioctl on my\x20space\x20name5 failed:
> Invalid argument
>         add map my space name5 : 0 65536 linear /dev/my space name 790528
>
>         device-mapper: reload ioctl on my\x20space\x20name6 failed:
> Invalid argument
>         add map my space name6 : 0 131072 linear /dev/my space name 858112
>
>         device-mapper: reload ioctl on my\x20space\x20name7 failed:
> Invalid argument
>         add map my space name7 : 0 524288 linear /dev/my space name 991232
>
>         (note: line breaks added for clarity)
>
> With patch:
>
>         # ./kpartx/kpartx -av "$spacename"
>         add map my space name1 (253:3): 0 262144 linear 7:0 2048
>         add map my space name2 (253:4): 0 524288 linear 7:0 264192
>         add map my space name3 (253:5): 0 2 linear 7:0 788480
>         add map my space name5 (253:6): 0 65536 linear 7:0 790528
>         add map my space name6 (253:7): 0 131072 linear 7:0 858112
>         add map my space name7 (253:8): 0 524288 linear 7:0 991232
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
>         crw-------. 1 root root 10, 236 Jan 11 16:29 control
>         lrwxrwxrwx. 1 root root       7 Jan 20 11:19 my\x20space\x20name1
> -> ../dm-3
>         lrwxrwxrwx. 1 root root       7 Jan 20 11:19 my\x20space\x20name2
> -> ../dm-4
>         lrwxrwxrwx. 1 root root       7 Jan 20 11:19 my\x20space\x20name3
> -> ../dm-5
>         lrwxrwxrwx. 1 root root       7 Jan 20 11:19 my\x20space\x20name5
> -> ../dm-6
>         lrwxrwxrwx. 1 root root       7 Jan 20 11:19 my\x20space\x20name6
> -> ../dm-7
>         lrwxrwxrwx. 1 root root       7 Jan 20 11:19 my\x20space\x20name7
> -> ../dm-8
>
> Thanks: Scott Moser (pointers to the error and test-case).
>
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> ---
>  kpartx/kpartx.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index a9d4c98..ee7c38a 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -477,8 +477,8 @@ main(int argc, char **argv){
>                                 }
>                                 strip_slash(partname);
>
> -                               if (safe_sprintf(params, "%s %" PRIu64 ,
> -                                                device, slices[j].start))
> {
> +                               if (safe_sprintf(params, "%d:%d %" PRIu64 ,
> +                                                major(buf.st_rdev),
> minor(buf.st_rdev), slices[j].start)) {
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
> +                                       if (safe_sprintf(params, "%d:%d %"
> PRIu64,
> +
> major(buf.st_rdev), minor(buf.st_rdev),
>                                                          slices[j].start))
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
>                                                        DM_TARGET, params);
>                                         c--;
>                                 }
> --
> 1.8.3.1
>
>

--001a114035acf325bd0529c526d0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+QXBwbGllZCw8ZGl2PnRoYW5rcy48L2Rpdj48L2Rpdj48ZGl2IGNsYXNz
PSJnbWFpbF9leHRyYSI+PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj5PbiBXZWQsIEphbiAy
MCwgMjAxNiBhdCAyOjUyIFBNLCBNYXVyaWNpbyBGYXJpYSBkZSBPbGl2ZWlyYSA8c3BhbiBkaXI9
Imx0ciI+Jmx0OzxhIGhyZWY9Im1haWx0bzptYXVyaWNmb0BsaW51eC52bmV0LmlibS5jb20iIHRh
cmdldD0iX2JsYW5rIj5tYXVyaWNmb0BsaW51eC52bmV0LmlibS5jb208L2E+Jmd0Ozwvc3Bhbj4g
d3JvdGU6PGJyPjxibG9ja3F1b3RlIGNsYXNzPSJnbWFpbF9xdW90ZSIgc3R5bGU9Im1hcmdpbjow
IDAgMCAuOGV4O2JvcmRlci1sZWZ0OjFweCAjY2NjIHNvbGlkO3BhZGRpbmctbGVmdDoxZXgiPkRl
dmljZSBuYW1lcyB3aXRoIHNwYWNlcyBmYWlsIHRvIGJlIGFkZGVkIHRvIGRldmljZS1tYXBwZXIg
dGFibGVzPGJyPg0KYmVjYXVzZSBzcGFjZXMgYXJlIGZpZWxkIHNlcGFyYXRvcnMuwqAgSW4gb3Jk
ZXIgdG8gc3VwcG9ydCBpdCwgdXNlPGJyPg0KZGV2aWNlIG1ham9yOm1pbm9yIG51bWJlcnMsIGlu
c3RlYWQuwqAgV2hpbGUgc3RpbGwgdGhlcmUsIG1ha2UgdGhlPGJyPg0KdmVyYm9zZSBvdXRwdXQg
b2YgY29udGFpbmVyLSBhbmQgY29udGFpbmVkLXNsaWNlcyBjb25zaXN0ZW50Ljxicj4NCjxicj4N
ClRoaXMgaXMgdXNlZnVsIG9uIHNvbWUgc2NlbmFyaW9zIHdpdGggYXJiaXRyYXJ5IGxvb3AgZGV2
aWNlIG5hbWVzLDxicj4NCmFuZCBub24tdXNlcl9mcmllbmRseV9uYW1lcyBtdWx0aXBhdGggV1dJ
RHMgd2l0aCBzcGFjZXMgKGVnLCBRRU1VPGJyPg0KZW11bGF0ZWQgaGFyZCBkcml2ZXMsIGFuZCBz
b21lIElCTSBkZXZpY2VzKSBvbiBzb21lIGRpc3Ryb3MuPGJyPg0KPGJyPg0KQ2hhbmdlbG9nOjxi
cj4NCi0gVjI6IFVzZSBtYWpvcigpL21pbm9yKCkgaW5zdGVhZCBvZiBNQUpPUigpL01JTk9SKCkg
KGJ1aWxkIGVycm9ycykuPGJyPg0KwqAgwqAgwqAgVXBkYXRlIHRlc3QtY2FzZSB2ZXJpZmljYXRp
b24gb3V0cHV0Ljxicj4NCsKgIMKgIMKgIFRoYW5rczogQ2hyaXN0b3BoZSBWYXJvcXVpPGJyPg0K
PGJyPg0KVGVzdC1jYXNlOjxicj4NCjxicj4NCsKgIMKgIMKgIMKgICMgaW1nPSZxdW90Oy90bXAv
bXkuaW1nJnF1b3Q7PGJyPg0KwqAgwqAgwqAgwqAgIyBzcGFjZW5hbWU9JnF1b3Q7L2Rldi9teSBz
cGFjZSBuYW1lJnF1b3Q7PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgIyB0cnVuY2F0ZSAtLXNpemU9
MUcgJnF1b3Q7JGltZyZxdW90Ozxicj4NCsKgIMKgIMKgIMKgICMgbG9kZXY9JChzdWRvIGxvc2V0
dXAgLS1maW5kIC0tc2hvdyAmcXVvdDskaW1nJnF1b3Q7KTxicj4NCsKgIMKgIMKgIMKgICMgbG4g
LXNmICZxdW90OyRsb2RldiZxdW90OyAmcXVvdDskc3BhY2VuYW1lJnF1b3Q7PGJyPg0KPGJyPg0K
wqAgwqAgwqAgwqAgIyBscyAtbCAkbG9kZXYgJnF1b3Q7JHNwYWNlbmFtZSZxdW90Ozxicj4NCsKg
IMKgIMKgIMKgIGJydy1ydy0tLS0uIDEgcm9vdCBkaXNrIDcsIDAgSmFuIDIwIDExOjE1IC9kZXYv
bG9vcDA8YnI+DQrCoCDCoCDCoCDCoCBscnd4cnd4cnd4LiAxIHJvb3Qgcm9vdMKgIMKgMTAgSmFu
IDIwIDExOjE2IC9kZXYvbXkgc3BhY2UgbmFtZSAtJmd0OyAvZGV2L2xvb3AwPGJyPg0KPGJyPg0K
wqAgwqAgwqAgwqAgIyBmZGlzayAkbG9kZXY8YnI+DQrCoCDCoCDCoCDCoCAmbHQ7Li4uJmd0Ozxi
cj4NCjxicj4NCsKgIMKgIMKgIMKgICMgZmRpc2sgLWwgJGxvZGV2PGJyPg0KwqAgwqAgwqAgwqAg
Jmx0Oy4uLiZndDs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCBEZXZpY2UgQm9vdMKgIMKgIMKg
IFN0YXJ0wqAgwqAgwqAgwqAgwqBFbmTCoCDCoCDCoCBCbG9ja3PCoCDCoElkwqAgU3lzdGVtPGJy
Pg0KwqAgwqAgwqAgwqAgL2Rldi9sb29wMHAxwqAgwqAgwqAgwqAgwqAgwqAgMjA0OMKgIMKgIMKg
IDI2NDE5McKgIMKgIMKgIDEzMTA3MsKgIMKgODPCoCBMaW51eDxicj4NCsKgIMKgIMKgIMKgIC9k
ZXYvbG9vcDBwMsKgIMKgIMKgIMKgIMKgIDI2NDE5MsKgIMKgIMKgIDc4ODQ3OcKgIMKgIMKgIDI2
MjE0NMKgIMKgODPCoCBMaW51eDxicj4NCsKgIMKgIMKgIMKgIC9kZXYvbG9vcDBwM8KgIMKgIMKg
IMKgIMKgIDc4ODQ4MMKgIMKgIMKgMjA5NzE1McKgIMKgIMKgIDY1NDMzNsKgIMKgIDXCoCBFeHRl
bmRlZDxicj4NCsKgIMKgIMKgIMKgIC9kZXYvbG9vcDBwNcKgIMKgIMKgIMKgIMKgIDc5MDUyOMKg
IMKgIMKgIDg1NjA2M8KgIMKgIMKgIMKgMzI3NjjCoCDCoDgzwqAgTGludXg8YnI+DQrCoCDCoCDC
oCDCoCAvZGV2L2xvb3AwcDbCoCDCoCDCoCDCoCDCoCA4NTgxMTLCoCDCoCDCoCA5ODkxODPCoCDC
oCDCoCDCoDY1NTM2wqAgwqA4M8KgIExpbnV4PGJyPg0KwqAgwqAgwqAgwqAgL2Rldi9sb29wMHA3
wqAgwqAgwqAgwqAgwqAgOTkxMjMywqAgwqAgwqAxNTE1NTE5wqAgwqAgwqAgMjYyMTQ0wqAgwqA4
M8KgIExpbnV4PGJyPg0KPGJyPg0KV2l0aG91dCBwYXRjaDo8YnI+DQo8YnI+DQrCoCDCoCDCoCDC
oCAjIC4va3BhcnR4L2twYXJ0eCAtYXYgJnF1b3Q7JHNwYWNlbmFtZSZxdW90Ozxicj4NCsKgIMKg
IMKgIMKgIGRldmljZS1tYXBwZXI6IHJlbG9hZCBpb2N0bCBvbiBteVx4MjBzcGFjZVx4MjBuYW1l
MSBmYWlsZWQ6IEludmFsaWQgYXJndW1lbnQ8YnI+DQrCoCDCoCDCoCDCoCBjcmVhdGUvcmVsb2Fk
IGZhaWxlZCBvbiBteSBzcGFjZSBuYW1lMTxicj4NCsKgIMKgIMKgIMKgIGFkZCBtYXAgbXkgc3Bh
Y2UgbmFtZTEgKDA6MCk6IDAgMjYyMTQ0IGxpbmVhciAvZGV2L215IHNwYWNlIG5hbWUgMjA0ODxi
cj4NCjxicj4NCsKgIMKgIMKgIMKgIGRldmljZS1tYXBwZXI6IHJlbG9hZCBpb2N0bCBvbiBteVx4
MjBzcGFjZVx4MjBuYW1lMiBmYWlsZWQ6IEludmFsaWQgYXJndW1lbnQ8YnI+DQrCoCDCoCDCoCDC
oCBjcmVhdGUvcmVsb2FkIGZhaWxlZCBvbiBteSBzcGFjZSBuYW1lMjxicj4NCsKgIMKgIMKgIMKg
IGFkZCBtYXAgbXkgc3BhY2UgbmFtZTIgKDA6MCk6IDAgNTI0Mjg4IGxpbmVhciAvZGV2L215IHNw
YWNlIG5hbWUgMjY0MTkyPGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgZGV2aWNlLW1hcHBlcjogcmVs
b2FkIGlvY3RsIG9uIG15XHgyMHNwYWNlXHgyMG5hbWUzIGZhaWxlZDogSW52YWxpZCBhcmd1bWVu
dDxicj4NCsKgIMKgIMKgIMKgIGNyZWF0ZS9yZWxvYWQgZmFpbGVkIG9uIG15IHNwYWNlIG5hbWUz
PGJyPg0KwqAgwqAgwqAgwqAgYWRkIG1hcCBteSBzcGFjZSBuYW1lMyAoMDowKTogMCAyIGxpbmVh
ciAvZGV2L215IHNwYWNlIG5hbWUgNzg4NDgwPGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgZGV2aWNl
LW1hcHBlcjogcmVsb2FkIGlvY3RsIG9uIG15XHgyMHNwYWNlXHgyMG5hbWU1IGZhaWxlZDogSW52
YWxpZCBhcmd1bWVudDxicj4NCsKgIMKgIMKgIMKgIGFkZCBtYXAgbXkgc3BhY2UgbmFtZTUgOiAw
IDY1NTM2IGxpbmVhciAvZGV2L215IHNwYWNlIG5hbWUgNzkwNTI4PGJyPg0KPGJyPg0KwqAgwqAg
wqAgwqAgZGV2aWNlLW1hcHBlcjogcmVsb2FkIGlvY3RsIG9uIG15XHgyMHNwYWNlXHgyMG5hbWU2
IGZhaWxlZDogSW52YWxpZCBhcmd1bWVudDxicj4NCsKgIMKgIMKgIMKgIGFkZCBtYXAgbXkgc3Bh
Y2UgbmFtZTYgOiAwIDEzMTA3MiBsaW5lYXIgL2Rldi9teSBzcGFjZSBuYW1lIDg1ODExMjxicj4N
Cjxicj4NCsKgIMKgIMKgIMKgIGRldmljZS1tYXBwZXI6IHJlbG9hZCBpb2N0bCBvbiBteVx4MjBz
cGFjZVx4MjBuYW1lNyBmYWlsZWQ6IEludmFsaWQgYXJndW1lbnQ8YnI+DQrCoCDCoCDCoCDCoCBh
ZGQgbWFwIG15IHNwYWNlIG5hbWU3IDogMCA1MjQyODggbGluZWFyIC9kZXYvbXkgc3BhY2UgbmFt
ZSA5OTEyMzI8YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCAobm90ZTogbGluZSBicmVha3MgYWRkZWQg
Zm9yIGNsYXJpdHkpPGJyPg0KPGJyPg0KV2l0aCBwYXRjaDo8YnI+DQo8YnI+DQrCoCDCoCDCoCDC
oCAjIC4va3BhcnR4L2twYXJ0eCAtYXYgJnF1b3Q7JHNwYWNlbmFtZSZxdW90Ozxicj4NCsKgIMKg
IMKgIMKgIGFkZCBtYXAgbXkgc3BhY2UgbmFtZTEgKDI1MzozKTogMCAyNjIxNDQgbGluZWFyIDc6
MCAyMDQ4PGJyPg0KwqAgwqAgwqAgwqAgYWRkIG1hcCBteSBzcGFjZSBuYW1lMiAoMjUzOjQpOiAw
IDUyNDI4OCBsaW5lYXIgNzowIDI2NDE5Mjxicj4NCsKgIMKgIMKgIMKgIGFkZCBtYXAgbXkgc3Bh
Y2UgbmFtZTMgKDI1Mzo1KTogMCAyIGxpbmVhciA3OjAgNzg4NDgwPGJyPg0KwqAgwqAgwqAgwqAg
YWRkIG1hcCBteSBzcGFjZSBuYW1lNSAoMjUzOjYpOiAwIDY1NTM2IGxpbmVhciA3OjAgNzkwNTI4
PGJyPg0KwqAgwqAgwqAgwqAgYWRkIG1hcCBteSBzcGFjZSBuYW1lNiAoMjUzOjcpOiAwIDEzMTA3
MiBsaW5lYXIgNzowIDg1ODExMjxicj4NCsKgIMKgIMKgIMKgIGFkZCBtYXAgbXkgc3BhY2UgbmFt
ZTcgKDI1Mzo4KTogMCA1MjQyODggbGluZWFyIDc6MCA5OTEyMzI8YnI+DQo8YnI+DQrCoCDCoCDC
oCDCoCAjIGRtc2V0dXAgdGFibGUgfCBzb3J0PGJyPg0KwqAgwqAgwqAgwqAgbXkgc3BhY2UgbmFt
ZTE6IDAgMjYyMTQ0IGxpbmVhciA3OjAgMjA0ODxicj4NCsKgIMKgIMKgIMKgIG15IHNwYWNlIG5h
bWUyOiAwIDUyNDI4OCBsaW5lYXIgNzowIDI2NDE5Mjxicj4NCsKgIMKgIMKgIMKgIG15IHNwYWNl
IG5hbWUzOiAwIDIgbGluZWFyIDc6MCA3ODg0ODA8YnI+DQrCoCDCoCDCoCDCoCBteSBzcGFjZSBu
YW1lNTogMCA2NTUzNiBsaW5lYXIgNzowIDc5MDUyODxicj4NCsKgIMKgIMKgIMKgIG15IHNwYWNl
IG5hbWU2OiAwIDEzMTA3MiBsaW5lYXIgNzowIDg1ODExMjxicj4NCsKgIMKgIMKgIMKgIG15IHNw
YWNlIG5hbWU3OiAwIDUyNDI4OCBsaW5lYXIgNzowIDk5MTIzMjxicj4NCjxicj4NCsKgIMKgIMKg
IMKgICMgbHMgLWwgL2Rldi9tYXBwZXIvPGJyPg0KwqAgwqAgwqAgwqAgdG90YWwgMDxicj4NCsKg
IMKgIMKgIMKgIGNydy0tLS0tLS0uIDEgcm9vdCByb290IDEwLCAyMzYgSmFuIDExIDE2OjI5IGNv
bnRyb2w8YnI+DQrCoCDCoCDCoCDCoCBscnd4cnd4cnd4LiAxIHJvb3Qgcm9vdMKgIMKgIMKgIMKg
NyBKYW4gMjAgMTE6MTkgbXlceDIwc3BhY2VceDIwbmFtZTEgLSZndDsgLi4vZG0tMzxicj4NCsKg
IMKgIMKgIMKgIGxyd3hyd3hyd3guIDEgcm9vdCByb290wqAgwqAgwqAgwqA3IEphbiAyMCAxMTox
OSBteVx4MjBzcGFjZVx4MjBuYW1lMiAtJmd0OyAuLi9kbS00PGJyPg0KwqAgwqAgwqAgwqAgbHJ3
eHJ3eHJ3eC4gMSByb290IHJvb3TCoCDCoCDCoCDCoDcgSmFuIDIwIDExOjE5IG15XHgyMHNwYWNl
XHgyMG5hbWUzIC0mZ3Q7IC4uL2RtLTU8YnI+DQrCoCDCoCDCoCDCoCBscnd4cnd4cnd4LiAxIHJv
b3Qgcm9vdMKgIMKgIMKgIMKgNyBKYW4gMjAgMTE6MTkgbXlceDIwc3BhY2VceDIwbmFtZTUgLSZn
dDsgLi4vZG0tNjxicj4NCsKgIMKgIMKgIMKgIGxyd3hyd3hyd3guIDEgcm9vdCByb290wqAgwqAg
wqAgwqA3IEphbiAyMCAxMToxOSBteVx4MjBzcGFjZVx4MjBuYW1lNiAtJmd0OyAuLi9kbS03PGJy
Pg0KwqAgwqAgwqAgwqAgbHJ3eHJ3eHJ3eC4gMSByb290IHJvb3TCoCDCoCDCoCDCoDcgSmFuIDIw
IDExOjE5IG15XHgyMHNwYWNlXHgyMG5hbWU3IC0mZ3Q7IC4uL2RtLTg8YnI+DQo8YnI+DQpUaGFu
a3M6IFNjb3R0IE1vc2VyIChwb2ludGVycyB0byB0aGUgZXJyb3IgYW5kIHRlc3QtY2FzZSkuPGJy
Pg0KPGJyPg0KU2lnbmVkLW9mZi1ieTogTWF1cmljaW8gRmFyaWEgZGUgT2xpdmVpcmEgJmx0Ozxh
IGhyZWY9Im1haWx0bzptYXVyaWNmb0BsaW51eC52bmV0LmlibS5jb20iPm1hdXJpY2ZvQGxpbnV4
LnZuZXQuaWJtLmNvbTwvYT4mZ3Q7PGJyPg0KLS0tPGJyPg0KwqBrcGFydHgva3BhcnR4LmMgfCAx
MiArKysrKystLS0tLS08YnI+DQrCoDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDYg
ZGVsZXRpb25zKC0pPGJyPg0KPGJyPg0KZGlmZiAtLWdpdCBhL2twYXJ0eC9rcGFydHguYyBiL2tw
YXJ0eC9rcGFydHguYzxicj4NCmluZGV4IGE5ZDRjOTguLmVlN2MzOGEgMTAwNjQ0PGJyPg0KLS0t
IGEva3BhcnR4L2twYXJ0eC5jPGJyPg0KKysrIGIva3BhcnR4L2twYXJ0eC5jPGJyPg0KQEAgLTQ3
Nyw4ICs0NzcsOCBAQCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndil7PGJyPg0KwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfTxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN0cmlwX3NsYXNoKHBhcnRuYW1l
KTs8YnI+DQo8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqBpZiAoc2FmZV9zcHJpbnRmKHBhcmFtcywgJnF1b3Q7JXMgJSZxdW90OyBQUkl1NjQgLDxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCBkZXZpY2UsIHNsaWNlc1tqXS5zdGFydCkpIHs8YnI+DQorwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAoc2FmZV9zcHJp
bnRmKHBhcmFtcywgJnF1b3Q7JWQ6JWQgJSZxdW90OyBQUkl1NjQgLDxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBtYWpvcihidWYuc3RfcmRldiksIG1pbm9yKGJ1Zi5zdF9yZGV2KSwgc2xpY2VzW2pdLnN0
YXJ0KSkgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIGZwcmludGYoc3RkZXJyLCAmcXVvdDtwYXJhbXMgdG9vIHNtYWxsXG4m
cXVvdDspOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIGV4aXQoMSk7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgfTxicj4NCkBAIC01NDAsOCArNTQwLDggQEAgbWFpbihpbnQg
YXJnYywgY2hhciAqKmFyZ3Ypezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIH08YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBzdHJpcF9zbGFzaChwYXJ0bmFt
ZSk7PGJyPg0KPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgaWYgKHNhZmVfc3ByaW50ZihwYXJhbXMsICZxdW90OyVzICUmcXVv
dDsgUFJJdTY0LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBkZXZpY2UsPGJyPg0K
K8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgaWYgKHNhZmVfc3ByaW50ZihwYXJhbXMsICZxdW90OyVkOiVkICUmcXVvdDsgUFJJdTY0LDxi
cj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBtYWpvcihidWYuc3RfcmRldiksIG1pbm9y
KGJ1Zi5zdF9yZGV2KSw8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHNsaWNlc1tq
XS5zdGFydCkpIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBmcHJpbnRmKHN0ZGVyciwgJnF1b3Q7cGFy
YW1zIHRvbyBzbWFsbFxuJnF1b3Q7KTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBleGl0KDEpOzxicj4N
CkBAIC01NjMsOCArNTYzLDggQEAgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3Ypezxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgICZhbXA7c2xpY2VzW2pdLm1pbm9yKTs8YnI+DQo8YnI+DQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAodmVy
Ym9zZSk8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBwcmludGYoJnF1b3Q7YWRkIG1hcCAlcyA6IDAgJSZx
dW90OyBQUkl1NjQgJnF1b3Q7ICVzICVzXG4mcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIHBhcnRuYW1lLCBzbGljZXNbal0uc2l6ZSw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBwcmlu
dGYoJnF1b3Q7YWRkIG1hcCAlcyAoJWQ6JWQpOiAwICUmcXVvdDsgUFJJdTY0ICZxdW90OyAlcyAl
c1xuJnF1b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBwYXJ0bmFtZSwgc2xpY2Vz
W2pdLm1ham9yLCBzbGljZXNbal0ubWlub3IsIHNsaWNlc1tqXS5zaXplLDxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgRE1fVEFSR0VULCBwYXJhbXMpOzxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGMtLTs8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB9PGJyPg0KPHNw
YW4gY2xhc3M9IkhPRW5aYiI+PGZvbnQgY29sb3I9IiM4ODg4ODgiPi0tPGJyPg0KMS44LjMuMTxi
cj4NCjxicj4NCjwvZm9udD48L3NwYW4+PC9ibG9ja3F1b3RlPjwvZGl2Pjxicj48L2Rpdj4NCg==
--001a114035acf325bd0529c526d0--


--===============4652234551246862716==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4652234551246862716==--
