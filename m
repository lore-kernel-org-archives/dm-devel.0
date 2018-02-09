From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 1/7] libmultipath: fix tur checker locking
Date: Sat, 10 Feb 2018 00:36:05 +0100
Message-ID: <1518219365.2937.22.camel@suse.com>
References: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
	<1518134167-15938-2-git-send-email-bmarzins@redhat.com>
	<1518208256.2937.16.camel@suse.com>
	<20180209230449.GW14513@octiron.msp.redhat.com>
	<1518218931.2937.20.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-kIrAoSYJXLW5LbLHCfVx"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518218931.2937.20.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--=-kIrAoSYJXLW5LbLHCfVx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Sat, 2018-02-10 at 00:28 +0100, Martin Wilck wrote:
> Maybe it's easier than we thought. Attached is a patch on top of
> yours that I think might work, please have a look. 
> 

That one didn't even compile. This one is better.

Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)

--=-kIrAoSYJXLW5LbLHCfVx
Content-Disposition: attachment;
	filename*0=0001-tur-checker-make-sure-pthread_cancel-isn-t-called-fo.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-tur-checker-make-sure-pthread_cancel-isn-t-called-fo.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSBhZmI5YzdkZTM2NThkNDljNGYyOGY2YjllZTYxOGE4N2I4MDZlY2RkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KRGF0ZTog
U2F0LCAxMCBGZWIgMjAxOCAwMDoyMjoxNyArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIHR1ciBjaGVj
a2VyOiBtYWtlIHN1cmUgcHRocmVhZF9jYW5jZWwgaXNuJ3QgY2FsbGVkIGZvciBleGl0ZWQKIHRo
cmVhZAoKSWYgd2UgZW50ZXIgdGhlIGNsZWFudXAgZnVuY3Rpb24gYXMgdGhlIHJlc3VsdCBvZiBh
IHB0aHJlYWRfY2FuY2VsIGJ5IGFub3RoZXIKdGhyZWFkLCB3ZSBkb24ndCBuZWVkIHRvIHdhaXQg
Zm9yIGEgY2FuY2VsbGF0aW9uIGFueSBtb3JlLiBJZiB3ZSBleGl0CnJlZ3VsYXJseSwganVzdCB0
ZWxsIHRoZSBvdGhlciB0aHJlYWQgbm90IHRvIHRyeSB0byBjYW5jZWwgdXMuCi0tLQogbGlibXVs
dGlwYXRoL2NoZWNrZXJzL3R1ci5jIHwgOSArKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGlu
c2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL2No
ZWNrZXJzL3R1ci5jIGIvbGlibXVsdGlwYXRoL2NoZWNrZXJzL3R1ci5jCmluZGV4IDg5NGFkNDFj
ODljMy4uNWQyYjM2YmZhODgzIDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgvY2hlY2tlcnMvdHVy
LmMKKysrIGIvbGlibXVsdGlwYXRoL2NoZWNrZXJzL3R1ci5jCkBAIC0yMTQsMTUgKzIxNCwxMyBA
QCByZXRyeToKIAogc3RhdGljIHZvaWQgY2xlYW51cF9mdW5jKHZvaWQgKmRhdGEpCiB7Ci0JaW50
IHJ1bm5pbmcsIGhvbGRlcnM7CisJaW50IGhvbGRlcnM7CiAJc3RydWN0IHR1cl9jaGVja2VyX2Nv
bnRleHQgKmN0ID0gZGF0YTsKIAotCXJ1bm5pbmcgPSB1YXRvbWljX3hjaGcoJmN0LT5ydW5uaW5n
LCAwKTsKKwl1YXRvbWljX3NldCgmY3QtPnJ1bm5pbmcsIDApOwogCWhvbGRlcnMgPSB1YXRvbWlj
X3N1Yl9yZXR1cm4oJmN0LT5ob2xkZXJzLCAxKTsKIAlpZiAoIWhvbGRlcnMpCiAJCWNsZWFudXBf
Y29udGV4dChjdCk7Ci0JaWYgKCFydW5uaW5nKQotCQlwYXVzZSgpOwogfQogCiBzdGF0aWMgaW50
IHR1cl9ydW5uaW5nKHN0cnVjdCB0dXJfY2hlY2tlcl9jb250ZXh0ICpjdCkKQEAgLTI2Niw2ICsy
NjQsOSBAQCBzdGF0aWMgdm9pZCAqdHVyX3RocmVhZCh2b2lkICpjdHgpCiAJcHRocmVhZF9jb25k
X3NpZ25hbCgmY3QtPmFjdGl2ZSk7CiAJcHRocmVhZF9tdXRleF91bmxvY2soJmN0LT5sb2NrKTsK
IAorCS8qIFRlbGwgbWFpbiBjaGVja2VyIHRocmVhZCBub3QgdG8gY2FuY2VsIHVzLCBhcyB3ZSBl
eGl0IGFueXdheSAqLworCXVhdG9taWNfc2V0KCZjdC0+cnVubmluZywgMCk7CisKIAljb25kbG9n
KDMsICIlczogdHVyIGNoZWNrZXIgZmluaXNoZWQsIHN0YXRlICVzIiwKIAkJdHVyX2RldnQoZGV2
dCwgc2l6ZW9mKGRldnQpLCBjdCksIGNoZWNrZXJfc3RhdGVfbmFtZShzdGF0ZSkpOwogCXR1cl90
aHJlYWRfY2xlYW51cF9wb3AoY3QpOwotLSAKMi4xNi4xCgo=


--=-kIrAoSYJXLW5LbLHCfVx
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-kIrAoSYJXLW5LbLHCfVx--
