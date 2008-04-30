From: "Balasubramanian, Vijayakumar (STSD)" <vijayakumar@hp.com>
Subject: RE: [PATCH] [RFC] switch DM tables to readonly
	automatically
Date: Wed, 30 Apr 2008 05:43:27 +0000
Message-ID: <56E176774601654D87D9B1FE82C0576808A32154DD@G3W0068.americas.hpqcorp.net>
References: <4811EB85.8090505@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_56E176774601654D87D9B1FE82C0576808A32154DDG3W0068americ_"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4811EB85.8090505@suse.de>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--_002_56E176774601654D87D9B1FE82C0576808A32154DDG3W0068americ_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,
Though the patch creates read-only device mappings, the READONLY status is =
not reflected on device mapper multipath devices.
Example: open with O_RDWR flag succeeds for read-only mpath devices, and wr=
ite fails with "Operation not permitted" error.

Attached patch would fix this.

Thanks,
Vijay

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Hannes Reinecke
Sent: Friday, April 25, 2008 8:03 PM
To: device-mapper development
Subject: [dm-devel] [PATCH] [RFC] switch DM tables to readonly automaticall=
y

Hi all,

this patch switches the device-mapper table to read-only status automatical=
ly if one underlying device returns -EROFS.

Rationale:
Whenever a SCSI device is switched to read-only a table reload from multipa=
th-tools fails, without any indication about the reason. And it's actually =
quite tricky to detect the read-only status from userland. And quite pointl=
ess, too, as the kernel already knows about it.

And we now can create tables for CD-ROMs, too, without having to use the '-=
r' flag to dmsetup ...

Christophe, this might also fix your problem.

As usual, comments etc are welcome.

Cheers,

Hannes
--
Dr. Hannes Reinecke                   zSeries & Storage
hare@suse.de                          +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--_002_56E176774601654D87D9B1FE82C0576808A32154DDG3W0068americ_
Content-Type: application/octet-stream; name="md-patch.diff"
Content-Description: md-patch.diff
Content-Disposition: attachment; filename="md-patch.diff"; size=2076;
	creation-date="Wed, 30 Apr 2008 04:27:53 GMT";
	modification-date="Wed, 30 Apr 2008 04:30:32 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcE5hdXIgbWQtb3JnL2RtLXRhYmxlLmMgbWQvZG0tdGFibGUuYwotLS0gbWQtb3JnL2Rt
LXRhYmxlLmMJMjAwOC0wMy0xNyAyMzoyMzozMS4wMDAwMDAwMDAgKzA1MzAKKysrIG1kL2RtLXRh
YmxlLmMJMjAwOC0wNC0zMCAwOTo1ODowOS4wMDAwMDAwMDAgKzA1MzAKQEAgLTQ2MSwxMSArNDYx
LDE5IEBAIHN0YXRpYyBpbnQgX190YWJsZV9nZXRfZGV2aWNlKHN0cnVjdCBkbV8KIAkJZGQtPm1v
ZGUgPSBtb2RlOwogCQlkZC0+YmRldiA9IE5VTEw7CiAKLQkJaWYgKChyID0gb3Blbl9kZXYoZGQs
IGRldikpKSB7CisJCXIgPSBvcGVuX2RldihkZCwgZGV2KTsKKwkJaWYgKHIgPT0gLUVST0ZTKSB7
CisJCQlkZC0+bW9kZSAmPSB+Rk1PREVfV1JJVEU7CisJCQlyID0gb3Blbl9kZXYoZGQsIGRldik7
CisJCX0KKwkJaWYgKHIpIHsKIAkJCWtmcmVlKGRkKTsKIAkJCXJldHVybiByOwogCQl9CiAKKwkJ
aWYgKGRkLT5tb2RlICE9IG1vZGUpCisJCQl0LT5tb2RlID0gZGQtPm1vZGU7CisKIAkJZm9ybWF0
X2Rldl90KGRkLT5uYW1lLCBkZXYpOwogCiAJCWF0b21pY19zZXQoJmRkLT5jb3VudCwgMCk7CmRp
ZmYgLXBOYXVyIG1kLW9yZy9kbS5jIG1kL2RtLmMKLS0tIG1kLW9yZy9kbS5jCTIwMDgtMDMtMTcg
MjM6MjM6MzEuMDAwMDAwMDAwICswNTMwCisrKyBtZC9kbS5jCTIwMDgtMDQtMzAgMDk6NTg6NDYu
MDAwMDAwMDAwICswNTMwCkBAIC0yMjEsMTYgKzIyMSwyNiBAQCBzdGF0aWMgdm9pZCBfX2V4aXQg
ZG1fZXhpdCh2b2lkKQogc3RhdGljIGludCBkbV9ibGtfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2Rl
LCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIHsKIAlzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQ7CisJc3Ry
dWN0IGdlbmRpc2sgKmRpc2sgPSBpbm9kZS0+aV9iZGV2LT5iZF9kaXNrOworCWludCByZXR2YWwg
PSAwOwogCiAJc3Bpbl9sb2NrKCZfbWlub3JfbG9jayk7CiAKIAltZCA9IGlub2RlLT5pX2JkZXYt
PmJkX2Rpc2stPnByaXZhdGVfZGF0YTsKLQlpZiAoIW1kKQorCWlmICghbWQpIHsKKwkJcmV0dmFs
ID0gLUVOWElPOwogCQlnb3RvIG91dDsKKwl9CiAKIAlpZiAodGVzdF9iaXQoRE1GX0ZSRUVJTkcs
ICZtZC0+ZmxhZ3MpIHx8CiAJICAgIHRlc3RfYml0KERNRl9ERUxFVElORywgJm1kLT5mbGFncykp
IHsKIAkJbWQgPSBOVUxMOworCQlyZXR2YWwgPSAtRU5YSU87CisJCWdvdG8gb3V0OworCX0KKwlp
ZiAoZGlzay0+cG9saWN5ICYmIChmaWxlLT5mX21vZGUgJiBGTU9ERV9XUklURSkpIHsKKwkJbWQg
PSBOVUxMOworCQlyZXR2YWwgPSAtRVJPRlM7CiAJCWdvdG8gb3V0OwogCX0KIApAQCAtMjQwLDcg
KzI1MCw3IEBAIHN0YXRpYyBpbnQgZG1fYmxrX29wZW4oc3RydWN0IGlub2RlICppbm8KIG91dDoK
IAlzcGluX3VubG9jaygmX21pbm9yX2xvY2spOwogCi0JcmV0dXJuIG1kID8gMCA6IC1FTlhJTzsK
KwlyZXR1cm4gcmV0dmFsOwogfQogCiBzdGF0aWMgaW50IGRtX2Jsa19jbG9zZShzdHJ1Y3QgaW5v
ZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKQEAgLTEwODksNiArMTA5OSwxMCBAQCBzdGF0
aWMgaW50IF9fYmluZChzdHJ1Y3QgbWFwcGVkX2RldmljZSAqCiAJd3JpdGVfbG9jaygmbWQtPm1h
cF9sb2NrKTsKIAltZC0+bWFwID0gdDsKIAlkbV90YWJsZV9zZXRfcmVzdHJpY3Rpb25zKHQsIHEp
OworCWlmICghKGRtX3RhYmxlX2dldF9tb2RlKHQpICYgRk1PREVfV1JJVEUpKQorCXsKKwkJc2V0
X2Rpc2tfcm8obWQtPmRpc2ssIDEpOworCX0KIAl3cml0ZV91bmxvY2soJm1kLT5tYXBfbG9jayk7
CiAKIAlyZXR1cm4gMDsKQEAgLTExMDQsNiArMTExOCwxMCBAQCBzdGF0aWMgdm9pZCBfX3VuYmlu
ZChzdHJ1Y3QgbWFwcGVkX2RldmljCiAJZG1fdGFibGVfZXZlbnRfY2FsbGJhY2sobWFwLCBOVUxM
LCBOVUxMKTsKIAl3cml0ZV9sb2NrKCZtZC0+bWFwX2xvY2spOwogCW1kLT5tYXAgPSBOVUxMOwor
CWlmICghKGRtX3RhYmxlX2dldF9tb2RlKG1hcCkgJiBGTU9ERV9XUklURSkpCisJeworCQlzZXRf
ZGlza19ybyhtZC0+ZGlzaywgMCk7CisJfQogCXdyaXRlX3VubG9jaygmbWQtPm1hcF9sb2NrKTsK
IAlkbV90YWJsZV9wdXQobWFwKTsKIH0K

--_002_56E176774601654D87D9B1FE82C0576808A32154DDG3W0068americ_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_002_56E176774601654D87D9B1FE82C0576808A32154DDG3W0068americ_--
