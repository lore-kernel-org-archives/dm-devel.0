From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: [PATCH] kernel-2.6.13 queue_if_no_path feature is
	ignored on creation
Date: Mon, 19 Sep 2005 15:07:07 +0200
Message-ID: <OF5B409D12.DC187AE1-ONC1257081.004732E5-C1257081.0047DB49@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_mixed 0047DADEC1257081_="
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

--=_mixed 0047DADEC1257081_=
Content-Type: text/plain; charset="US-ASCII"

Hi,

I noticed that (at least when using multipath-tools for setup) the 
queue_if_no_path
feature is not recognized any more with kernel 2.6.13. I believe the 
problem is
the constructor in dm_mpath.c which calls the queue_if_no_path() function 
which
copies the current value of m->queue_if_no_path to the save area so resume 
will
throw away the setting.
The following patch would pre-set the current value so the copy is also 
set to the
new value.

Regards,
Stefan Bader

SW Linux on zSeries Development & Services
Stefan.Bader #at# de.ibm.com
----------------------------------------------------------------------------------
  When all other means of communication fail, try words.


--=_mixed 0047DADEC1257081_=
Content-Type: application/octet-stream; name="kernel-2.6.13-dm-fix1.patch"
Content-Disposition: attachment; filename="kernel-2.6.13-dm-fix1.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtcnVOcCBsaW51eC0yLjYuMTMtZGV2ZWwvZHJpdmVycy9tZC9kbS1tcGF0aC5jIGxpbnV4
LTIuNi4xMy1kbXNtYi9kcml2ZXJzL21kL2RtLW1wYXRoLmMKLS0tIGxpbnV4LTIuNi4xMy1kZXZl
bC9kcml2ZXJzL21kL2RtLW1wYXRoLmMJMjAwNS0wOS0xNCAxNTo0MDozMS4wMDAwMDAwMDAgKzAy
MDAKKysrIGxpbnV4LTIuNi4xMy1kbXNtYi9kcml2ZXJzL21kL2RtLW1wYXRoLmMJMjAwNS0wOS0x
OSAxNDo0NjoyOC4wMDAwMDAwMDAgKzAyMDAKQEAgLTY4NCw5ICs2OTAsMTAgQEAgc3RhdGljIGlu
dCBwYXJzZV9mZWF0dXJlcyhzdHJ1Y3QgYXJnX3NldAogCWlmICghYXJnYykKIAkJcmV0dXJuIDA7
CiAKLQlpZiAoIXN0cm5pY21wKHNoaWZ0KGFzKSwgTUVTR19TVFIoInF1ZXVlX2lmX25vX3BhdGgi
KSkpCisJaWYgKCFzdHJuaWNtcChzaGlmdChhcyksIE1FU0dfU1RSKCJxdWV1ZV9pZl9ub19wYXRo
IikpKSB7CisJCW0tPnF1ZXVlX2lmX25vX3BhdGggPSAxOwogCQlyZXR1cm4gcXVldWVfaWZfbm9f
cGF0aChtLCAxKTsKLQllbHNlIHsKKwl9IGVsc2UgewogCQl0aS0+ZXJyb3IgPSAiVW5yZWNvZ25p
c2VkIG11bHRpcGF0aCBmZWF0dXJlIHJlcXVlc3QiOwogCQlyZXR1cm4gLUVJTlZBTDsKIAl9Cg==

--=_mixed 0047DADEC1257081_=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=_mixed 0047DADEC1257081_=--
