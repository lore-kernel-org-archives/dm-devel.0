From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: grub 0.96 bug
Date: Mon, 21 Mar 2005 15:55:02 +0100
Message-ID: <62b0912f050321065558fc956@mail.gmail.com>
References: <62b0912f05031606396a3a47db@mail.gmail.com>
	<20050318125120.GQ3301@redhat.com>
	<62b0912f0503181112ea853a6@mail.gmail.com>
	<62b0912f050318142923419b20@mail.gmail.com>
	<62b0912f05031914513909bcfb@mail.gmail.com>
	<62b0912f050319145547c4a7db@mail.gmail.com>
	<20050320163001.GB643@percy.comedia.it>
	<62b0912f05032019262c009465@mail.gmail.com>
	<62b0912f0503202121607bd38a@mail.gmail.com>
	<62b0912f05032104052e78fd60@mail.gmail.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_4337_12037739.1111416902024"
In-Reply-To: <62b0912f05032104052e78fd60@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bug-grub@gnu.org, dm-devel@redhat.com
Cc: ataraid-list@redhat.com
List-Id: dm-devel.ids

------=_Part_4337_12037739.1111416902024
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> grub> device (hd0) /dev/mapper/hpt37x_ehgjaggaf
> grub> device (hd0,5) /dev/mapper/hpt37x_ehgjaggaf6
> grub> root (hd0,5)/boot
> Attempt to open drive 0x80 (/dev/mapper/hpt37x_ehgjaggaf6)
> Error 5: Partition table invalid or corrupt
> grub> root (hd0,5)/boot
> Attempt to open drive 0x80 (/dev/mapper/hpt37x_ehgjaggaf6)
> Error 5: Partition table invalid or corrupt

Think it tries to read a partition table out of a logical partition, humn...
No idea where to look for this bug; hints appreciated.

> grub> root (hd0,5)/boot
> Attempt to open drive 0x80 (/dev/mapper/hpt37x_ehgjaggaf)
> Error 18: Selected cylinder exceeds maximum supported by BIOS

Examining further, GRUB thinks the disk has only 4999680 sectors.
It corresponds to about 2.441 MB, while the disk is really about 160.000 MB.

Looking through the source code, the above sector value is some insane
default in GRUB.
The code tries to use 3 different ways of getting the sector count:

1.) ioctl(fd, HDIO_GETGEO) call in lib/device.c
Fails with error -1.
Documentation/hdio.txt from kernel sources has this to say with
regards to that function:
"Not particularly useful with modern disk drives, whose geometry is a
polite fiction anyway. "

2.) fstat (fd, &st)
Fails with error 0.
No idea what this should do :-).

3.) ioctl(fd, BLKGETSIZE) call in lib/device.c
This works for device-mapped devices!
Seems to be a widely used function, there's even a 64-bit version.
Unfortunately, GRUB only attempts this approach after having
*successfully* retrieved cylinder, head and sector values through
HDIO_GETGEO.


I've gone ahead and solved my problems myself; the attached patch
fixes GRUB 0.96 to work correctly (at least for me) with device-mapped
devices.

This is my first hack ever with anything Linux-ie.
So go ahead and flame at will :-).

------=_Part_4337_12037739.1111416902024
Content-Type: application/octet-stream; name="grub-0.96-devicemapper.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="grub-0.96-devicemapper.patch"

ZGlmZiAtYXVyIGdydWItMC45Ni1vcmlnL2xpYi9kZXZpY2UuYyBncnViLTAuOTYvbGliL2Rldmlj
ZS5jCi0tLSBncnViLTAuOTYtb3JpZy9saWIvZGV2aWNlLmMJMjAwNS0wMy0yMSAxNTowNzoxNy4z
OTQzMzMwMDAgKzAxMDAKKysrIGdydWItMC45Ni9saWIvZGV2aWNlLmMJMjAwNS0wMy0yMSAxNTo0
Nzo1Ni42OTU1MDI4NTYgKzAxMDAKQEAgLTE0Nyw2ICsxNDcsOCBAQAogCiAgIC8qIFhYWCBUaGlz
IGlzIHRoZSBkZWZhdWx0IHNpemUuICAqLwogICBnZW9tLT5zZWN0b3Jfc2l6ZSA9IFNFQ1RPUl9T
SVpFOworICAvKiBVc2UgMCB0byB0ZXN0IGxhdGVyIG9uIGlmIHNlY3RvciB2YWx1ZSBoYXMgYWxy
ZWFkeSBiZWVuIGNvcnJlY3RseSByZXRyaWV2ZWQuICovCisgIGdlb20tPnRvdGFsX3NlY3RvcnMg
PSAwOwogICAKICNpZiBkZWZpbmVkKF9fbGludXhfXykKICAgLyogTGludXggKi8KQEAgLTE1NCwx
NyArMTU2LDE2IEBACiAgICAgc3RydWN0IGhkX2dlb21ldHJ5IGhkZzsKICAgICB1bnNpZ25lZCBs
b25nIG5yOwogICAgIAorICAgIGlmICghIGlvY3RsIChmZCwgQkxLR0VUU0laRSwgJm5yKSkKKyAg
ICAgIGdlb20tPnRvdGFsX3NlY3RvcnMgPSBucjsKKyAgICAKICAgICBpZiAoaW9jdGwgKGZkLCBI
RElPX0dFVEdFTywgJmhkZykpCiAgICAgICBnb3RvIGZhaWw7CiAKLSAgICBpZiAoaW9jdGwgKGZk
LCBCTEtHRVRTSVpFLCAmbnIpKQotICAgICAgZ290byBmYWlsOwotICAgIAogICAgIC8qIEdvdCB0
aGUgZ2VvbWV0cnksIHNvIHNhdmUgaXQuICovCiAgICAgZ2VvbS0+Y3lsaW5kZXJzID0gaGRnLmN5
bGluZGVyczsKICAgICBnZW9tLT5oZWFkcyA9IGhkZy5oZWFkczsKICAgICBnZW9tLT5zZWN0b3Jz
ID0gaGRnLnNlY3RvcnM7Ci0gICAgZ2VvbS0+dG90YWxfc2VjdG9ycyA9IG5yOwogICAgIAogICAg
IGdvdG8gc3VjY2VzczsKICAgfQpAQCAtMjM2LDkgKzIzNywxNyBAQAogICAgICAgIGdpdmVuIGEg
cHJvcGVyIHN0X2Jsb2NrcyBzaXplLiAqLwogICAgIGlmIChkcml2ZSAmIDB4ODApCiAgICAgICB7
CisgICAgICAgLyogSWYgYSB0b3RhbCBzZWN0b3IgY291bnQgaGFzIGJlZW4gZm91bmQgYW5kIGl0
IGV4Y2VlZHMgQ0hTIGNhcGFjaXRpZXMsCisJKiB1c2UgbGFyZ2UgZHJpdmUgcGxhY2Vob2xkZXIg
dmFsdWVzLiAqLworICAgICAgIGlmIChnZW9tLT50b3RhbF9zZWN0b3JzICYmIChnZW9tLT50b3Rh
bF9zZWN0b3JzID49IDI1NSo2MyoxMDI0KSkgeworCWdlb20tPmN5bGluZGVycyA9IDEwMjQ7CisJ
Z2VvbS0+aGVhZHMgPSAyNTU7CisJZ2VvbS0+c2VjdG9ycyA9IDYzOworICAgICAgIH0gZWxzZSB7
CiAJZ2VvbS0+Y3lsaW5kZXJzID0gREVGQVVMVF9IRF9DWUxJTkRFUlM7CiAJZ2VvbS0+aGVhZHMg
PSBERUZBVUxUX0hEX0hFQURTOwogCWdlb20tPnNlY3RvcnMgPSBERUZBVUxUX0hEX1NFQ1RPUlM7
CisgICAgICAgfQogICAgICAgfQogICAgIGVsc2UKICAgICAgIHsKQEAgLTI0NywxMSArMjU2LDEz
IEBACiAJZ2VvbS0+c2VjdG9ycyA9IERFRkFVTFRfRkRfU0VDVE9SUzsKICAgICAgIH0KIAotICAg
IC8qIFNldCB0aGUgdG90YWwgc2VjdG9ycyBwcm9wZXJseSwgaWYgd2UgY2FuLiAqLworICAgLyog
SWYgdG90YWwgc2VjdG9ycyBoYXNuJ3QgYmVlbiBzZXQgeWV0LCB0cnkgYW5kIGdldCBhIHByb3Bl
ciB2YWx1ZS4gKi8KKyAgIGlmICghIGdlb20tPnRvdGFsX3NlY3RvcnMpIHsKICAgICBpZiAoISBm
c3RhdCAoZmQsICZzdCkgJiYgc3Quc3RfYmxvY2tzKQogICAgICAgZ2VvbS0+dG90YWxfc2VjdG9y
cyA9IHN0LnN0X2Jsb2NrczsKICAgICBlbHNlCiAgICAgICBnZW9tLT50b3RhbF9zZWN0b3JzID0g
Z2VvbS0+Y3lsaW5kZXJzICogZ2VvbS0+aGVhZHMgKiBnZW9tLT5zZWN0b3JzOworICAgfQogICB9
CiAKICBzdWNjZXNzOgo=
------=_Part_4337_12037739.1111416902024
Content-Type: text/plain; name="oh joy it works.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="oh joy it works.txt"

GNU GRUB  version 0.96  (640K lower / 3072K upper memory)
grub> device (hd0) /dev/mapper/hpt37x_ehgjaggaf

grub> root (hd0,5)
Attempt to open drive 0x80 (/dev/mapper/hpt37x_ehgjaggaf)
Filesystem type is reiserfs, partition type 0x83

grub>

------=_Part_4337_12037739.1111416902024
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_Part_4337_12037739.1111416902024--
