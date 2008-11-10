From: Mikulas Patocka <mpatocka@redhat.com>
Subject: updated Chandra's patch for dm_any_congested
Date: Mon, 10 Nov 2008 12:14:40 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0811101206570.7687@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="279731514-1586419313-1226337258=:7687"
Return-path: <dm-devel-bounces@redhat.com>
Content-ID: <Pine.LNX.4.64.0811101214260.7687@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--279731514-1586419313-1226337258=:7687
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.64.0811101214261.7687@hs20-bc2-1.build.redhat.com>

Hi

This is the updated patch for dm_any_congested, the only change is that
atomic_dec(&md->pending) is changed into
if (!atomic_dec_return(&md->pending)) wake_up(&md->wait);

--- so that there is not a possibility to deadlock device suspend that 
wait for pending variable to drop to zero.

You can put it into your series as a quick "stop crash" patch, until we 
find a better solution as we talked about today.

BTW. if you some times ago wondered why I'm using yield() and not waiting 
queues in performance non-critical paths, it's to avoid bugs like this :)

Mikulas
--279731514-1586419313-1226337258=:7687
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII;
	NAME=dm-avoid-destroying-table-in-dm_any_congested.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0811101214180.7687@hs20-bc2-1.build.redhat.com>
Content-Description: 
Content-Disposition: ATTACHMENT;
	FILENAME=dm-avoid-destroying-table-in-dm_any_congested.patch

RnJvbTogQ2hhbmRyYSBTZWV0aGFyYW1hbiA8c2VraGFyYW5AdXMuaWJtLmNv
bT4NCg0KZG1fYW55X2Nvbmdlc3RlZCgpIGp1c3QgY2hlY2tzIGZvciB0aGUg
RE1GX0JMT0NLX0lPIGFuZCBoYXMgbm8NCmNvZGUgdG8gbWFrZSBzdXJlIHRo
YXQgc3VzcGVuZCB3YWl0cyBmb3IgZG1fYW55X2Nvbmdlc3RlZCgpIHRvDQpj
b21wbGV0ZS4gIFRoaXMgcGF0Y2ggYWRkcyBzdWNoIGEgY2hlY2suDQoNCldp
dGhvdXQgaXQsIGEgcmFjZSBjYW4gb2NjdXIgd2l0aCBkbV90YWJsZV9wdXQo
KSBhdHRlbXB0aW5nIHRvDQpkZXN0cm95aW5nIHRoZSB0YWJsZSBpbiB0aGUg
d3JvbmcgdGhyZWFkLCB0aGUgb25lIHJ1bm5pbmcNCmRtX2FueV9jb25nZXN0
ZWQoKSB3aGljaCBpcyBtZWFudCB0byBiZSBxdWljayBhbmQgcmV0dXJuDQpp
bW1lZGlhdGVseS4NCg0KVHdvIGV4YW1wbGVzIG9mIHByb2JsZW1zOg0KMS4g
U2xlZXBpbmcgZnVuY3Rpb25zIGNhbGxlZCBmcm9tIGNvbmdlc3RlZCBjb2Rl
LCB0aGUgY2FsbGVyDQogICBvZiB3aGljaCBob2xkcyBhIHNwaW4gbG9jay4N
CjIuIEFuIEFCQkEgZGVhZGxvY2sgYmV0d2VlbiBwZGZsdXNoIGFuZCBtdWx0
aXBhdGhkLiBUaGUgdHdvIGxvY2tzDQogICBpbiBjb250ZW50aW9uIGFyZSBp
bm9kZSBsb2NrIGFuZCBrZXJuZWwgbG9jay4NCg0KW0FHSzogSXMgdGhlIHJl
dHVybiB2YWx1ZSBhbHdheXMgY29ycmVjdCB3aGVuIHRoZSB0YWJsZSBpcyBz
a2lwcGVkP10NCg0KU2lnbmVkLW9mZi1ieTogQ2hhbmRyYSBTZWV0aGFyYW1h
biA8c2VraGFyYW5AdXMuaWJtLmNvbT4NClNpZ25lZC1vZmYtYnk6IE1pa3Vs
YXMgUGF0b2NrYSA8bXBhdG9ja2FAcmVkaGF0LmNvbT4NClNpZ25lZC1vZmYt
Ynk6IEFsYXNkYWlyIEcgS2VyZ29uIDxhZ2tAcmVkaGF0LmNvbT4NCi0tLQ0K
IGRyaXZlcnMvbWQvZG0uYyB8ICAgMjAgKysrKysrKysrKysrKy0tLS0tLS0N
CiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlv
bnMoLSkNCg0KSW5kZXg6IGxpbnV4LTIuNi4yOC1yYzMtZGV2ZWwvZHJpdmVy
cy9tZC9kbS5jDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQotLS0gbGludXgt
Mi42LjI4LXJjMy1kZXZlbC5vcmlnL2RyaXZlcnMvbWQvZG0uYwkyMDA4LTEx
LTA1IDA5OjE5OjE4LjAwMDAwMDAwMCArMDEwMA0KKysrIGxpbnV4LTIuNi4y
OC1yYzMtZGV2ZWwvZHJpdmVycy9tZC9kbS5jCTIwMDgtMTEtMTAgMTg6MDU6
MjQuMDAwMDAwMDAwICswMTAwDQpAQCAtOTQxLDE2ICs5NDEsMjIgQEAgc3Rh
dGljIHZvaWQgZG1fdW5wbHVnX2FsbChzdHJ1Y3QgcmVxdWVzdA0KIA0KIHN0
YXRpYyBpbnQgZG1fYW55X2Nvbmdlc3RlZCh2b2lkICpjb25nZXN0ZWRfZGF0
YSwgaW50IGJkaV9iaXRzKQ0KIHsNCi0JaW50IHI7DQorCWludCByID0gYmRp
X2JpdHM7DQogCXN0cnVjdCBtYXBwZWRfZGV2aWNlICptZCA9IChzdHJ1Y3Qg
bWFwcGVkX2RldmljZSAqKSBjb25nZXN0ZWRfZGF0YTsNCi0Jc3RydWN0IGRt
X3RhYmxlICptYXAgPSBkbV9nZXRfdGFibGUobWQpOw0KKwlzdHJ1Y3QgZG1f
dGFibGUgKm1hcDsNCiANCi0JaWYgKCFtYXAgfHwgdGVzdF9iaXQoRE1GX0JM
T0NLX0lPLCAmbWQtPmZsYWdzKSkNCi0JCXIgPSBiZGlfYml0czsNCi0JZWxz
ZQ0KLQkJciA9IGRtX3RhYmxlX2FueV9jb25nZXN0ZWQobWFwLCBiZGlfYml0
cyk7DQorCWF0b21pY19pbmMoJm1kLT5wZW5kaW5nKTsNCisJaWYgKHRlc3Rf
Yml0KERNRl9CTE9DS19JTywgJm1kLT5mbGFncykpDQorCQlnb3RvIGRvbmU7
DQogDQotCWRtX3RhYmxlX3B1dChtYXApOw0KKwltYXAgPSBkbV9nZXRfdGFi
bGUobWQpOw0KKwlpZiAobWFwKSB7DQorCQlyID0gZG1fdGFibGVfYW55X2Nv
bmdlc3RlZChtYXAsIGJkaV9iaXRzKTsNCisJCWRtX3RhYmxlX3B1dChtYXAp
Ow0KKwl9DQorZG9uZToNCisJaWYgKCFhdG9taWNfZGVjX3JldHVybigmbWQt
PnBlbmRpbmcpKQ0KKwkJd2FrZV91cCgmbWQtPndhaXQpOw0KIAlyZXR1cm4g
cjsNCiB9DQogDQo=

--279731514-1586419313-1226337258=:7687
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--279731514-1586419313-1226337258=:7687--
