From: Risto Kankkunen <risto.kankkunen@f-secure.com>
Subject: [PATCH] kpartx: use inode to identify loopback mounts
Date: Mon, 6 Jul 2015 14:56:59 +0300
Message-ID: <559A6D0B.5090602@f-secure.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090901080200040400080801"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Risto Kankkunen <Risto.Kankkunen@f-secure.com>
List-Id: dm-devel.ids

--------------090901080200040400080801
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

This is a patch which I submitted to Launchpad 
(https://bugs.launchpad.net/ubuntu/+source/multipath-tools/+bug/1469143). I 
was told to submit it to this list instead.

Currently kpartx doesn't work correctly with relative path names, 
hardlinks, symlinks or paths longer than 63 characters. This is because 
it tries to identify mounts by a non-unique name it gives to the mount. 
The loopinfo struct contains the device and inode information of the 
backing image, it is better to identify mounts by those.

--------------090901080200040400080801
Content-Type: text/plain; charset="windows-1252";
	name="0014-kpartx-long-path.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="0014-kpartx-long-path.patch"

RnJvbTogUmlzdG8gS2Fua2t1bmVuIDxyaXN0by5rYW5ra3VuZW5AZi1zZWN1cmUuY29tPgpE
YXRlOiBNb24sIDI5IEp1biAyMDE1IDE4OjM5OjQ4ICswMzAwClN1YmplY3Q6IFVzZSBpbWFn
ZSBmaWxlIGRldmljZS9pbm9kZSB0byBmaW5kIHRoZSBjb3JyZWN0IGxvb3AgZGV2aWNlIGlu
IGtwYXJ0eAoKUHJldmlvdXNseSBrcGFydHggdXNlZCB0aGUgImxvX25hbWUiIGZpZWxkIG9m
IHN0cnVjdCBsb29wX2luZm8gdG8gc3RvcmUgCmFuZCBtYXRjaCB0aGUgaW1hZ2UgZmlsZSBu
YW1lLiBUaGF0IGZpZWxkIGlzIG5vdCBpbnRlbmRlZCB0byBzdG9yZSBwYXRoIApuYW1lcyAo
aXQncyBub3QgYmlnIGVub3VnaCkuIFRoZXJlZm9yZSBrcGFydHggd2FzIHVuYWJsZSB0byBk
ZWxldGUgCm1hcHBpbmdzIHRvIGZpbGUgcGF0aHMgbG9uZ2VyIHRoYW4gNjMgY2hhcmFjdGVy
cy4gSXQgYWxzbyBkaWRuJ3QgCnByb3Blcmx5IGhhbmRsZSByZWxhdGl2ZSBmaWxlIHBhdGhz
OiB0d28gZGlmZmVyZW50IGZpbGVzIHdpdGggaWRlbnRpY2FsCnJlbGF0aXZlIHBhdGggbmFt
ZXMgY291bGQgbm90IGJlIG1hcHBlZC4gSW5zdGVhZCBrcGFydHggd291bGQgbW9kaWZ5CnRo
ZSBleGlzdGluZyBtYXBwaW5nIHdoZW4gc2VlaW5nIGEgbmV3IGZpbGUgd2l0aCB0aGUgc2Ft
ZSByZWxhdGl2ZSBwYXRoLgoKVGhlICJsb29waW5mbyIgc3RydWN0dXJlIGNvbnRhaW5zIHRo
ZSBpbWFnZSBmaWxlIGRldmljZSBhbmQgaW5vZGUgCm51bWJlcnMuIFVzZSB0aG9zZSB0byB1
bmlxdWVseSBpZGVudGlmeSB0aGUgY29ycmVjdCBsb29wIGRldmljZS4KCi0tLSBhL2twYXJ0
eC9sb3BhcnQuYworKysgYi9rcGFydHgvbG9wYXJ0LmMKQEAgLTEwMyw2ICsxMDMsMTQgQEAK
IAlpbnQgaSwgaiwgZmQ7CiAJc3RydWN0IHN0YXQgc3RhdGJ1ZjsKIAlzdHJ1Y3QgbG9vcF9p
bmZvIGxvb3BpbmZvOworCWRldl90IGZpbGVfZGV2OworCWlub190IGZpbGVfaW5vOworCisJ
aWYgKHN0YXQgKGZpbGVuYW1lLCAmc3RhdGJ1ZikgIT0gMCkgeworCQlyZXR1cm4gTlVMTDsK
Kwl9CisJZmlsZV9kZXYgPSBzdGF0YnVmLnN0X2RldjsKKwlmaWxlX2lubyA9IHN0YXRidWYu
c3RfaW5vOwogCiAJZm9yIChqID0gMDsgaiA8IFNJWkUobG9vcF9mb3JtYXRzKTsgaisrKSB7
CiAKQEAgLTEyMyw3ICsxMzEsNyBAQAogCQkJCWNvbnRpbnVlOwogCQkJfQogCi0JCQlpZiAo
MCA9PSBzdHJjbXAoZmlsZW5hbWUsIGxvb3BpbmZvLmxvX25hbWUpKSB7CisJCQlpZiAobG9v
cGluZm8ubG9fZGV2aWNlID09IGZpbGVfZGV2ICYmIGxvb3BpbmZvLmxvX2lub2RlID09IGZp
bGVfaW5vKSB7CiAJCQkJY2xvc2UgKGZkKTsKIAkJCQlyZXR1cm4geHN0cmR1cChkZXYpOyAv
KmZvdW5kICovCiAJCQl9Cg==
--------------090901080200040400080801
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------090901080200040400080801--
