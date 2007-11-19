From: usvyatsky_ilya@emc.com
Subject: Multipath v. 0.4.7 trips over USB flash drive
Date: Mon, 19 Nov 2007 15:43:04 -0500
Message-ID: <3A7658DE9640014CB055D6299B111F9C1EF588@CORPUSMX20B.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C82AEC.C8898D4D"
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C82AEC.C8898D4D
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi there,

I am using DM MPIO for quite a while now and in general it works.
Lately I encountered a problem with one of my boxes that is equipped
with USB flash drive and is connected to a disk array.
Namely, the flash drive has an empty bcdDevice entry, which translates
into empty /sys/block/sdXX/device/rev file.
As a result, the 'multipath -ll' command trips over this device and
bails out without listing any array mpathXX devices.
The devices are created in /dev/disk/by-name/ directory, so it's just
the userland tool issue.

I've built debug version of multipath and found the following:

1. The function sysfs_get_rev() (which is generated from macro
declare_sysfs_get_str()) assumes that the rev has to have at least 2
characters. Since in the case of my device this assumption is false, the
function returns 1.
2. The caller function is scsi_sysfs_pathinfo() and it returns 1 as
well.
3. The caller function is sysfs_pathinfo(), which returns 1 as well.
4. The caller function is pathinfo(), which also returns 1.
5. The caller function is store_pathinfo(). Here the pathinfo is not
stored and NULL is returned to the caller.
6. The caller is path_discover() that returns 1.
7. The caller is path_discovery() that returns non-zero result.
8. The caller is configure() that bails out on this result.

I have tried to work around this issue by blacklisting the device, but
unfortunately the only blacklist check that is done prior to call to
store_pathinfo() in the path_discover() is based on the devnode.=20
This means that effectively I cannot use this workaround since with USB
device I cannot guarantee that it will always be mapped to the same
devnode.

I'd like to propose a couple of options for a fix for this issue:

1. Re-implement sysfs_get_rev() in such a way that rev filed minimal
length is no longer required.=20
   Please see attached a patch that is supposed to take care of this.
2. Re-implement pathinfo() to check whether vendor and/or product are
blacklisted.=20
   This way non-compliant devices may be blacklisted based on vendor
and/or product name.

I am not sure, which option is preferable, but I clearly need at least
one of them in the product.

Your comments are greatly appreciated.=20

Please note that my patch is against v. 0.4.7 of the multipath tool.=20
I realize that upstream may differ significantly, so if option (1) makes
sense I'll revalidate with the latest version and submit the patch if
necessary.

Thanks,

Ilya.

------_=_NextPart_001_01C82AEC.C8898D4D
Content-Type: application/octet-stream;
	name="multipath-tools-0.4.7-empty-rev.diff"
Content-Transfer-Encoding: base64
Content-Description: multipath-tools-0.4.7-empty-rev.diff
Content-Disposition: attachment;
	filename="multipath-tools-0.4.7-empty-rev.diff"

ZGlmZiAtciBtdWx0aXBhdGgtdG9vbHMtMC40LjctcGF0Y2hlZC9saWJtdWx0aXBhdGgvZGlzY292
ZXJ5LmMgbXVsdGlwYXRoLXRvb2xzLTAuNC43L2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYwoxNDVj
MTQ1CjwgI2RlZmluZSBkZWNsYXJlX3N5c2ZzX2dldF9zdHIoZm5hbWUsIGZtdCwgbWluX2xlbikg
XAotLS0KPiAjZGVmaW5lIGRlY2xhcmVfc3lzZnNfZ2V0X3N0cihmbmFtZSwgZm10KSBcCjE2NGMx
NjQKPCAJaWYgKGF0dHItPmxlbiA8IG1pbl9sZW4gfHwgYXR0ci0+bGVuIC0gMSA+IGxlbikgXAot
LS0KPiAJaWYgKGF0dHItPmxlbiA8IDIgfHwgYXR0ci0+bGVuIC0gMSA+IGxlbikgXAoxNzYsMTgx
YzE3NiwxODEKPCBkZWNsYXJlX3N5c2ZzX2dldF9zdHIoZGV2dHlwZSwgIiVzL2Jsb2NrLyVzL2Rl
dmljZS9kZXZ0eXBlIiwgMik7CjwgZGVjbGFyZV9zeXNmc19nZXRfc3RyKGN1dHlwZSwgIiVzL2Js
b2NrLyVzL2RldmljZS9jdXR5cGUiLCAyKTsKPCBkZWNsYXJlX3N5c2ZzX2dldF9zdHIodmVuZG9y
LCAiJXMvYmxvY2svJXMvZGV2aWNlL3ZlbmRvciIsIDIpOwo8IGRlY2xhcmVfc3lzZnNfZ2V0X3N0
cihtb2RlbCwgIiVzL2Jsb2NrLyVzL2RldmljZS9tb2RlbCIsIDIpOwo8IGRlY2xhcmVfc3lzZnNf
Z2V0X3N0cihyZXYsICIlcy9ibG9jay8lcy9kZXZpY2UvcmV2IiwgMCk7CjwgZGVjbGFyZV9zeXNm
c19nZXRfc3RyKGRldiwgIiVzL2Jsb2NrLyVzL2RldiIsIDIpOwotLS0KPiBkZWNsYXJlX3N5c2Zz
X2dldF9zdHIoZGV2dHlwZSwgIiVzL2Jsb2NrLyVzL2RldmljZS9kZXZ0eXBlIik7Cj4gZGVjbGFy
ZV9zeXNmc19nZXRfc3RyKGN1dHlwZSwgIiVzL2Jsb2NrLyVzL2RldmljZS9jdXR5cGUiKTsKPiBk
ZWNsYXJlX3N5c2ZzX2dldF9zdHIodmVuZG9yLCAiJXMvYmxvY2svJXMvZGV2aWNlL3ZlbmRvciIp
Owo+IGRlY2xhcmVfc3lzZnNfZ2V0X3N0cihtb2RlbCwgIiVzL2Jsb2NrLyVzL2RldmljZS9tb2Rl
bCIpOwo+IGRlY2xhcmVfc3lzZnNfZ2V0X3N0cihyZXYsICIlcy9ibG9jay8lcy9kZXZpY2UvcmV2
Iik7Cj4gZGVjbGFyZV9zeXNmc19nZXRfc3RyKGRldiwgIiVzL2Jsb2NrLyVzL2RldiIpOwo=

------_=_NextPart_001_01C82AEC.C8898D4D
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C82AEC.C8898D4D--
