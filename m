From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: [PATCH] multipath-tools: Fix kpartx partition
 calculation for DASD partitions.
Date: Mon, 11 Dec 2006 17:28:07 +0100
Message-ID: <OF692EC29B.B83E3C2B-ONC1257241.004E0AB0-C1257241.005A7052@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_mixed 005A7005C1257241_="
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

--=_mixed 005A7005C1257241_=
Content-Type: text/plain; charset="US-ASCII"

We found an error in the partition calculation of DASD devices. This
only applies to DASDs with CMS, LNX (old linux disk layout) and
unpartitioned devices. In these cases the partition created by kpartx
is smaller than the partion that would be accessible through the kernel
partition device. If 512B blocksize was used when formatting the DASD
the calculations are ok. The partitions are also ok if the default
(Compatible Disk Layout) was used.

BIG WARNING:
The following fix will correct this (and it should be done so kernel
and kpartx partitions are the same). However, if someone has already
used the disk layouts mentioned above and wrote data to the
partitions created by kpartx this will lead to trouble!
The data won't be found at the new start of the partition. But a
manually created linear target might be used to access the data and
move it somewhere else.

echo "0 <size> <device> <offset>" | dmsetup create <name>

<device> = /dev/dasd[a-z][a-z]*
<f>      = 8 (for 4K blocksize), 4 (2K BS), 2 (1K BS)
<size>   = $(blockdev --getsize <device>) - (3 * f) - (3 * f * f)
<offset> = 3 * f * f

To check if someone is affected by the bug the output of
"kpartx -l <device>" can be compared against the start and size
attribute in /sys/block/<devicename>/<devicename>1.
(e.g. "kpartx -l /dev/dasdb" <--> cat /sys/block/dasdb/dasdb1/...)

Stefan Bader


--=_mixed 005A7005C1257241_=
Content-Type: application/octet-stream; name="mptools-kpartx-dasd.patch"
Content-Disposition: attachment; filename="mptools-kpartx-dasd.patch"
Content-Transfer-Encoding: base64

IG11bHRpcGF0aC10b29sczoga3BhcnR4OiBmaXggcGFydGl0aW9uIGNhbGN1bGF0aW9ucyBvZiBE
QVNEIHBhcnRpdGlvbnMKCiBUaGlzIHBhdGNoIGZpeGVzIHRoZSBvZmZzZXQgYW5kIGxlbmd0aCBj
YWxjdWF0aW9ucyBmb3IgREFTRCBwYXJ0aXRpb25zCiB3aXRoIGVpdGhlciBDTVMgKHdpdGhvdXQg
ZXhwbGljaXQgb2Zmc2V0KSwgdGhlIG9sZCBsaW51eCBkaXNrIGxheW91dCBvcgogbm8gcGFydGl0
aW9uIGluZm9ybWF0aW9uIGF0IGFsbCBpZiB0aGUgZGV2aWNlcyBhcmUgdXNpbmcgYSBibG9ja3Np
emUgYmlnZ2VyCiB0aGFuIDUxMkIuCiBJbiB0aGUgY2FzZXMgbWVudGlvbmVkIGFib3ZlIHRoZSBv
ZmZzZXQgd2FzIG5vcm1hbGl6ZWQgKHRvIHRoZSBudW1iZXIgb2YKIDUxMkIgc2VjdG9ycykgdHdp
Y2UgYW5kIHRoZSBzaXplIHJlZHVjZWQgYnkgdGhlIG5vcm1hbGl6ZWQgb2Zmc2V0IGFuZCBhZ2Fp
bgogYnkgdGhlIGRvdWJsZSBub3JtYWxpemVkIG9mZnNldCBsYXRlci4KIFRoaXMgbGVhZHMgdG8g
a3BhcnR4IGRlZmluaW5nIHRoZSB3cm9uZyBsaW1pdHMgaW4gdGhlc2UgY2FzZXMuCgogU2lnbmVk
LW9mZi1ieTogU3RlZmFuIEJhZGVyIDxzaGJhZGVyQGRlLmlibS5jb20+CgogZGFzZC5jIHwgICAy
OCArKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDE2IGluc2Vy
dGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQoKZGlmZiAtTnVycCBtdWx0aXBhdGgtdG9vbHMtMC40
LjUuNTkva3BhcnR4L2Rhc2QuYyBtdWx0aXBhdGgtdG9vbHMtMC40LjUuNTkta3BhcnR4L2twYXJ0
eC9kYXNkLmMKLS0tIG11bHRpcGF0aC10b29scy0wLjQuNS41OS9rcGFydHgvZGFzZC5jCTIwMDYt
MTItMDcgMTI6NTI6MjEuMDAwMDAwMDAwICswMTAwCisrKyBtdWx0aXBhdGgtdG9vbHMtMC40LjUu
NTkta3BhcnR4L2twYXJ0eC9kYXNkLmMJMjAwNi0xMi0wNyAxMzo1OToxNC4wMDAwMDAwMDAgKzAx
MDAKQEAgLTQwLDE0ICs0MCwyMCBAQAogI2luY2x1ZGUgImJ5dGVvcmRlci5oIgogI2luY2x1ZGUg
ImRhc2QuaCIKIAordW5zaWduZWQgbG9uZyBzZWN0b3JzNTEyKHVuc2lnbmVkIGxvbmcgc2VjdG9y
cywgaW50IGJsb2Nrc2l6ZSkKK3sKKwlyZXR1cm4gc2VjdG9ycyAqIChibG9ja3NpemUgPj4gOSk7
Cit9CisKIC8qCiAgKi8KIGludCAKIHJlYWRfZGFzZF9wdChpbnQgZmQsIHN0cnVjdCBzbGljZSBh
bGwsIHN0cnVjdCBzbGljZSAqc3AsIGludCBucykKIHsKIAlpbnQgcmV0dmFsID0gLTE7Ci0JaW50
IGJsb2Nrc2l6ZSwgb2Zmc2V0LCBzaXplOworCWludCBibG9ja3NpemU7CiAJbG9uZyBkaXNrc2l6
ZTsKKwl1bnNpZ25lZCBsb25nIG9mZnNldCwgc2l6ZTsKIAlkYXNkX2luZm9ybWF0aW9uX3QgaW5m
bzsKIAlzdHJ1Y3QgaGRfZ2VvbWV0cnkgZ2VvOwogCWNoYXIgdHlwZVs1XSA9IHswLH07CkBAIC0x
NzIsMTMgKzE3OCwxMyBAQCByZWFkX2Rhc2RfcHQoaW50IGZkLCBzdHJ1Y3Qgc2xpY2UgYWxsLCBz
CiAJCQkvKiBkaXNrIGlzIHJlc2VydmVkIG1pbmlkaXNrICovCiAJCQlibG9ja3NpemUgPSBsYWJl
bFszXTsKIAkJCW9mZnNldCA9IGxhYmVsWzEzXTsKLQkJCXNpemUgPSAobGFiZWxbN10gLSAxKSoo
YmxvY2tzaXplID4+IDkpOworCQkJc2l6ZSAgID0gc2VjdG9yczUxMihsYWJlbFs3XSAtIDEsIGJs
b2Nrc2l6ZSk7CiAJCX0gZWxzZSB7Ci0JCQlvZmZzZXQgPSAoaW5mby5sYWJlbF9ibG9jayArIDEp
ICogKGJsb2Nrc2l6ZSA+PiA5KTsKLQkJCXNpemUgPSBkaXNrc2l6ZSAtIG9mZnNldDsKKwkJCW9m
ZnNldCA9IGluZm8ubGFiZWxfYmxvY2sgKyAxOworCQkJc2l6ZSAgID0gZGlza3NpemU7CiAJCX0K
LQkJc3BbMF0uc3RhcnQgPSBvZmZzZXQgKiAoYmxvY2tzaXplID4+IDkpOwotCQlzcFswXS5zaXpl
ID0gc2l6ZSAtIG9mZnNldCAqIChibG9ja3NpemUgPj4gOSk7CisJCXNwWzBdLnN0YXJ0ID0gc2Vj
dG9yczUxMihvZmZzZXQsIGJsb2Nrc2l6ZSk7CisJCXNwWzBdLnNpemUgID0gc2l6ZSAtIHNwWzBd
LnN0YXJ0OwogCQlyZXR2YWwgPSAxOwogCX0gZWxzZSBpZiAoKHN0cm5jbXAodHlwZSwgIlZPTDEi
LCA0KSA9PSAwKSAmJgogCQkoIWluZm8uRkJBX2xheW91dCkgJiYgKCFzdHJjbXAoaW5mby50eXBl
LCAiRUNLRCIpKSkgewpAQCAtMjE0LDggKzIyMCw4IEBAIHJlYWRfZGFzZF9wdChpbnQgZmQsIHN0
cnVjdCBzbGljZSBhbGwsIHMKIAkJICAgICAgICBvZmZzZXQgPSBjY2hoMmJsaygmZjEuRFMxRVhU
MS5sbGltaXQsICZnZW8pOwogCQkJc2l6ZSAgPSBjY2hoMmJsaygmZjEuRFMxRVhUMS51bGltaXQs
ICZnZW8pIC0gCiAJCQkJb2Zmc2V0ICsgZ2VvLnNlY3RvcnM7Ci0JCQlzcFtjb3VudGVyXS5zdGFy
dCA9IG9mZnNldCAqIChibG9ja3NpemUgPj4gOSk7Ci0JCQlzcFtjb3VudGVyXS5zaXplID0gc2l6
ZSAqIChibG9ja3NpemUgPj4gOSk7CisJCQlzcFtjb3VudGVyXS5zdGFydCA9IHNlY3RvcnM1MTIo
b2Zmc2V0LCBibG9ja3NpemUpOworCQkJc3BbY291bnRlcl0uc2l6ZSAgPSBzZWN0b3JzNTEyKHNp
emUsIGJsb2Nrc2l6ZSk7CiAJCQljb3VudGVyKys7CiAJCQlibGsrKzsKIAkJfQpAQCAtMjI0LDEw
ICsyMzAsOCBAQCByZWFkX2Rhc2RfcHQoaW50IGZkLCBzdHJ1Y3Qgc2xpY2UgYWxsLCBzCiAJCS8q
CiAJCSAqIE9sZCBzdHlsZSBMTlgxIG9yIHVubGFiZWxlZCBkaXNrCiAJCSAqLwotCQlvZmZzZXQg
PSAoaW5mby5sYWJlbF9ibG9jayArIDEpICogKGJsb2Nrc2l6ZSA+PiA5KTsKLQkJc2l6ZSA9IGRp
c2tzaXplIC0gb2Zmc2V0OwotCQlzcFswXS5zdGFydCA9IG9mZnNldCAqIChibG9ja3NpemUgPj4g
OSk7Ci0JCXNwWzBdLnNpemUgPSBzaXplIC0gb2Zmc2V0ICogKGJsb2Nrc2l6ZSA+PiA5KTsKKwkJ
c3BbMF0uc3RhcnQgPSBzZWN0b3JzNTEyKGluZm8ubGFiZWxfYmxvY2sgKyAxLCBibG9ja3NpemUp
OworCQlzcFswXS5zaXplICA9IGRpc2tzaXplIC0gc3BbMF0uc3RhcnQ7CiAJCXJldHZhbCA9IDE7
CiAJfQogCg==

--=_mixed 005A7005C1257241_=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=_mixed 005A7005C1257241_=--
