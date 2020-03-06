From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: multipath-tools merges
Date: Fri, 6 Mar 2020 16:26:06 +0000
Message-ID: <5773a737cfb455e37b3b54a728080d2087332734.camel@suse.com>
References: <CABr-Gne_oOns4W0A4Ny4t4xRPbU3qdtS5Z6BSt7wQ0N7cRqDeQ@mail.gmail.com>
	<3f8ae4512f68c5ba0cce93e5da27bb812dd8107e.camel@suse.com>
	<CABr-GnckSFPe5aRMQgRqUR2Lg9q5nomX00pL9JKOk-qoGAweMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_5773a737cfb455e37b3b54a728080d2087332734camelsusecom_"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GnckSFPe5aRMQgRqUR2Lg9q5nomX00pL9JKOk-qoGAweMw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--_002_5773a737cfb455e37b3b54a728080d2087332734camelsusecom_
Content-Type: text/plain; charset=ISO-8859-15
Content-ID: <B8A6D80ABBA60043BD7131D2D4E555E5@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

Hello Christophe,

On Tue, 2020-03-03 at 00:35 +0100, Christophe Varoqui wrote:
> Hi Martin,
>=20
> Thanks for pointing these missing patches.
> They are now merged.

Thanks. Still a nit: you picked v1 of my=20
"libmultipath: drop mpp->nr_active field" patch (from Nov. 15th) rather
than v2 (from Nov. 20th):
https://www.redhat.com/archives/dm-devel/2019-November/msg00133.html

The v2 patch added some additional hunks (attached) and also a some
text in the commit message.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--_002_5773a737cfb455e37b3b54a728080d2087332734camelsusecom_
Content-Type: text/x-patch; name=drop-nr_active-v1-v2.diff;
	charset=WINDOWS-1252
Content-Description: drop-nr_active-v1-v2.diff
Content-Disposition: attachment; filename="drop-nr_active-v1-v2.diff";
	size=1917; creation-date="Fri, 06 Mar 2020 16:26:06 GMT";
	modification-date="Fri, 06 Mar 2020 16:26:06 GMT"
Content-ID: <F13AB79C14C373419007F85BC91BE2B8@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9zdHJ1Y3RzX3ZlYy5jIGIvbGlibXVsdGlwYXRoL3N0
cnVjdHNfdmVjLmMKaW5kZXggMGM1YTNhODEuLjNkYmJhYTBmIDEwMDY0NAotLS0gYS9saWJtdWx0
aXBhdGgvc3RydWN0c192ZWMuYworKysgYi9saWJtdWx0aXBhdGgvc3RydWN0c192ZWMuYwpAQCAt
MzM0LDIyICszMzQsMjMgQEAgc3RhdGljIHZvaWQgbGVhdmVfcmVjb3ZlcnlfbW9kZShzdHJ1Y3Qg
bXVsdGlwYXRoICptcHApCiAJfQogfQogCi12b2lkIHNldF9ub19wYXRoX3JldHJ5KHN0cnVjdCBt
dWx0aXBhdGggKm1wcCkKK3ZvaWQgX19zZXRfbm9fcGF0aF9yZXRyeShzdHJ1Y3QgbXVsdGlwYXRo
ICptcHAsIGJvb2wgY2hlY2tfZmVhdHVyZXMpCiB7Ci0JYm9vbCBpc19xdWV1ZWluZyA9IDA7CisJ
Ym9vbCBpc19xdWV1ZWluZzsKIAotCWlmIChtcHAtPmZlYXR1cmVzICYmIHN0cnN0cihtcHAtPmZl
YXR1cmVzLCAicXVldWVfaWZfbm9fcGF0aCIpKQotCQlpc19xdWV1ZWluZyA9IDE7CisJY2hlY2tf
ZmVhdHVyZXMgPSBjaGVja19mZWF0dXJlcyAmJiBtcHAtPmZlYXR1cmVzICE9IE5VTEw7CisJaWYg
KGNoZWNrX2ZlYXR1cmVzKQorCQlpc19xdWV1ZWluZyA9IHN0cnN0cihtcHAtPmZlYXR1cmVzLCAi
cXVldWVfaWZfbm9fcGF0aCIpOwogCiAJc3dpdGNoIChtcHAtPm5vX3BhdGhfcmV0cnkpIHsKIAlj
YXNlIE5PX1BBVEhfUkVUUllfVU5ERUY6CiAJCWJyZWFrOwogCWNhc2UgTk9fUEFUSF9SRVRSWV9G
QUlMOgotCQlpZiAoaXNfcXVldWVpbmcpCisJCWlmICghY2hlY2tfZmVhdHVyZXMgfHwgaXNfcXVl
dWVpbmcpCiAJCQlkbV9xdWV1ZV9pZl9ub19wYXRoKG1wcC0+YWxpYXMsIDApOwogCQlicmVhazsK
IAljYXNlIE5PX1BBVEhfUkVUUllfUVVFVUU6Ci0JCWlmICghaXNfcXVldWVpbmcpCisJCWlmICgh
Y2hlY2tfZmVhdHVyZXMgfHwgIWlzX3F1ZXVlaW5nKQogCQkJZG1fcXVldWVfaWZfbm9fcGF0aCht
cHAtPmFsaWFzLCAxKTsKIAkJYnJlYWs7CiAJZGVmYXVsdDoKQEAgLTM1OCw3ICszNTksOCBAQCB2
b2lkIHNldF9ub19wYXRoX3JldHJ5KHN0cnVjdCBtdWx0aXBhdGggKm1wcCkKIAkJCSAqIElmIGlu
X3JlY292ZXJ5IGlzIHNldCwgbGVhdmVfcmVjb3ZlcnlfbW9kZSgpIHRha2VzCiAJCQkgKiBjYXJl
IG9mIGRtX3F1ZXVlX2lmX25vX3BhdGguIE90aGVyd2lzZSwgZG8gaXQgaGVyZS4KIAkJCSAqLwot
CQkJaWYgKCFpc19xdWV1ZWluZyAmJiAhbXBwLT5pbl9yZWNvdmVyeSkKKwkJCWlmICgoIWNoZWNr
X2ZlYXR1cmVzIHx8ICFpc19xdWV1ZWluZykgJiYKKwkJCSAgICAhbXBwLT5pbl9yZWNvdmVyeSkK
IAkJCQlkbV9xdWV1ZV9pZl9ub19wYXRoKG1wcC0+YWxpYXMsIDEpOwogCQkJbGVhdmVfcmVjb3Zl
cnlfbW9kZShtcHApOwogCQl9IGVsc2UKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9zdHJ1Y3Rz
X3ZlYy5oIGIvbGlibXVsdGlwYXRoL3N0cnVjdHNfdmVjLmgKaW5kZXggNjc4ZWZlNGQuLjJhNWUz
ZDYwIDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgvc3RydWN0c192ZWMuaAorKysgYi9saWJtdWx0
aXBhdGgvc3RydWN0c192ZWMuaApAQCAtMTEsNyArMTEsOCBAQCBzdHJ1Y3QgdmVjdG9ycyB7CiAJ
dmVjdG9yIG1wdmVjOwogfTsKIAotdm9pZCBzZXRfbm9fcGF0aF9yZXRyeShzdHJ1Y3QgbXVsdGlw
YXRoICptcHApOwordm9pZCBfX3NldF9ub19wYXRoX3JldHJ5KHN0cnVjdCBtdWx0aXBhdGggKm1w
cCwgYm9vbCBjaGVja19mZWF0dXJlcyk7CisjZGVmaW5lIHNldF9ub19wYXRoX3JldHJ5KG1wcCkg
X19zZXRfbm9fcGF0aF9yZXRyeShtcHAsIHRydWUpCiAKIGludCBhZG9wdF9wYXRocyAodmVjdG9y
IHBhdGh2ZWMsIHN0cnVjdCBtdWx0aXBhdGggKiBtcHApOwogdm9pZCBvcnBoYW5fcGF0aHModmVj
dG9yIHBhdGh2ZWMsIHN0cnVjdCBtdWx0aXBhdGggKm1wcCwK
--_002_5773a737cfb455e37b3b54a728080d2087332734camelsusecom_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_002_5773a737cfb455e37b3b54a728080d2087332734camelsusecom_--
