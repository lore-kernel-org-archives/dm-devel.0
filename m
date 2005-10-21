From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: [PATCH] device-mapper: dm-mpath.c/dm_end_io might
	dead-lock
Date: Fri, 21 Oct 2005 14:30:43 +0200
Message-ID: <OF05AB6962.4DDCCB12-ONC12570A1.0043BB4B-C12570A1.00449DA9@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_mixed 00449D66C12570A1_="
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
List-Id: dm-devel.ids

--=_mixed 00449D66C12570A1_=
Content-Type: text/plain; charset="US-ASCII"

We had a problem with the multipath target which seems to be a locking
problem. The following patch fixed the problem for us by replacing the
spin_lock calls by the _irqsave/_irqrestore counterparts.
Alasdair, is that fix acceptable? If yes, could you please include it into
the kernel source?

Regards,
Stefan Bader



SW Linux on zSeries Development & Services
Stefan.Bader@de.ibm.com
----------------------------------------------------------------------------------
  When all other means of communication fail, try words.
--=_mixed 00449D66C12570A1_=
Content-Type: application/octet-stream; name="dm-end-io-spinlock-rhel4u2.diff"
Content-Disposition: attachment; filename="dm-end-io-spinlock-rhel4u2.diff"
Content-Transfer-Encoding: base64

SW5kZXg6IGRyaXZlcnMvbWQvZG0tbXBhdGguYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09ClJDUyBmaWxlOiAvaG9tZS9j
dnMvbGludXgtUkhFTDQvZHJpdmVycy9tZC9kbS1tcGF0aC5jLHYKcmV0cmlldmluZyByZXZpc2lv
biAxLjIKZGlmZiAtdSAtcjEuMiBkbS1tcGF0aC5jCi0tLSBkcml2ZXJzL21kL2RtLW1wYXRoLmMJ
NiBPY3QgMjAwNSAxMzozNDoxNSAtMDAwMAkxLjIKKysrIGRyaXZlcnMvbWQvZG0tbXBhdGguYwkx
NyBPY3QgMjAwNSAxNDozOTozNCAtMDAwMApAQCAtMTAwMCw2ICsxMDAwLDcgQEAKIHsKIAlzdHJ1
Y3QgaHdfaGFuZGxlciAqaHdoID0gJm0tPmh3X2hhbmRsZXI7CiAJdW5zaWduZWQgZXJyX2ZsYWdz
ID0gTVBfRkFJTF9QQVRIOwkvKiBEZWZhdWx0IGJlaGF2aW9yICovCisJdW5zaWduZWQgbG9uZyBm
bGFnczsKIAogCWlmICghZXJyb3IpCiAJCXJldHVybiAwOwkvKiBJL08gY29tcGxldGUgKi8KQEAg
LTEwMTAsMTcgKzEwMTEsMTcgQEAKIAlpZiAoZXJyb3IgPT0gLUVPUE5PVFNVUFApCiAJCXJldHVy
biBlcnJvcjsKIAotCXNwaW5fbG9jaygmbS0+bG9jayk7CisJc3Bpbl9sb2NrX2lycXNhdmUoJm0t
PmxvY2ssIGZsYWdzKTsKIAlpZiAoIW0tPm5yX3ZhbGlkX3BhdGhzKSB7CiAJCWlmICghbS0+cXVl
dWVfaWZfbm9fcGF0aCkgewotCQkJc3Bpbl91bmxvY2soJm0tPmxvY2spOworCQkJc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSgmbS0+bG9jaywgZmxhZ3MpOwogCQkJcmV0dXJuIC1FSU87CiAJCX0gZWxz
ZSB7Ci0JCQlzcGluX3VubG9jaygmbS0+bG9jayk7CisJCQlzcGluX3VubG9ja19pcnFyZXN0b3Jl
KCZtLT5sb2NrLCBmbGFncyk7CiAJCQlnb3RvIHJlcXVldWU7CiAJCX0KIAl9Ci0Jc3Bpbl91bmxv
Y2soJm0tPmxvY2spOworCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm0tPmxvY2ssIGZsYWdzKTsK
IAogCWlmIChod2gtPnR5cGUgJiYgaHdoLT50eXBlLT5lcnJvcikKIAkJZXJyX2ZsYWdzID0gaHdo
LT50eXBlLT5lcnJvcihod2gsIGJpbyk7CkBAIC0xMDQyLDEyICsxMDQzLDEyIEBACiAJZG1fYmlv
X3Jlc3RvcmUoJm1waW8tPmRldGFpbHMsIGJpbyk7CiAKIAkvKiBxdWV1ZSBmb3IgdGhlIGRhZW1v
biB0byByZXN1Ym1pdCBvciBmYWlsICovCi0Jc3Bpbl9sb2NrKCZtLT5sb2NrKTsKKwlzcGluX2xv
Y2tfaXJxc2F2ZSgmbS0+bG9jaywgZmxhZ3MpOwogCWJpb19saXN0X2FkZCgmbS0+cXVldWVkX2lv
cywgYmlvKTsKIAltLT5xdWV1ZV9zaXplKys7CiAJaWYgKCFtLT5xdWV1ZV9pbykKIAkJcXVldWVf
d29yayhrbXVsdGlwYXRoZCwgJm0tPnByb2Nlc3NfcXVldWVkX2lvcyk7Ci0Jc3Bpbl91bmxvY2so
Jm0tPmxvY2spOworCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm0tPmxvY2ssIGZsYWdzKTsKIAog
CXJldHVybiAxOwkvKiBpbyBub3QgY29tcGxldGUgKi8KIH0K

--=_mixed 00449D66C12570A1_=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=_mixed 00449D66C12570A1_=--
