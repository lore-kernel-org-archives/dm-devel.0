From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3] multipath-tools: intermittent IO error
 accounting to improve reliability
Date: Tue, 05 Sep 2017 20:29:26 +0200
Message-ID: <1504636166.4516.5.camel@suse.com>
References: <1504533992-13392-1-git-send-email-guanjunxiong@huawei.com>
	<1504558781.4605.14.camel@suse.com>
	<ab1527fa-c2e5-85d0-8285-231b38076274@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ab1527fa-c2e5-85d0-8285-231b38076274@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Guan Junxiong <guanjunxiong@huawei.com>, dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: chengjike.cheng@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

T24gVHVlLCAyMDE3LTA5LTA1IGF0IDEwOjU5ICswODAwLCBHdWFuIEp1bnhpb25nIHdyb3RlOgo+
IEhpIE1hcnRpbiwKPiBUaGFua3MgZm9yIHlvdSByZW1hcmtzIGFuZCBjb21waWxpbmcgY2hlY2su
Cj4gQW4gbmV3IHBhdGNoIHdpbGwgYmUgdXBkYXRlZCBpbiB0aGlzIHdlZWsuCj4gT3RoZXIgcmVz
cG9uc2UgaXMgaW5saW5lLgo+IAo+IENoZWVycwo+IEd1YW4gSnVueGlvbmcKPiAKPiBPbiAyMDE3
LzkvNSA0OjU5LCBNYXJ0aW4gV2lsY2sgd3JvdGU6Cj4gPiAgbWFwX2Rpc2NvdmVyeSAoc3RydWN0
IHZlY3RvcnMgKiB2ZWNzKQo+ID4gPiAgewo+ID4gPiAgCXN0cnVjdCBtdWx0aXBhdGggKiBtcHA7
Cj4gPiA+IEBAIC0xMTM0LDYgKzExNzAsNyBAQCB1ZXZfdHJpZ2dlciAoc3RydWN0IHVldmVudCAq
IHVldiwgdm9pZCAqCj4gPiA+IHRyaWdnZXJfZGF0YSkKPiA+ID4gIAlpZiAoIXN0cm5jbXAodWV2
LT5rZXJuZWwsICJkbS0iLCAzKSkgewo+ID4gPiAgCQlpZiAoIXN0cm5jbXAodWV2LT5hY3Rpb24s
ICJjaGFuZ2UiLCA2KSkgewo+ID4gPiAgCQkJciA9IHVldl9hZGRfbWFwKHVldiwgdmVjcyk7Cj4g
PiA+ICsJCQl1ZXZfcGF0aGZhaWxfY2hlY2sodWV2LCB2ZWNzKTsKPiA+ID4gIAkJCWdvdG8gb3V0
Owo+ID4gPiAgCQl9Cj4gPiA+ICAJCWlmICghc3RybmNtcCh1ZXYtPmFjdGlvbiwgInJlbW92ZSIs
IDYpKSB7Cj4gPiAKPiA+IEl0J3MgaW50ZXJlc3RpbmcgdGhhdCB5b3UgaGF2ZSBjaG9zZW4gdG8g
YWN0IG9uIGtlcm5lbCBQQVRIX0ZBSUxFRAo+ID4gZXZlbnRzIGhlcmUuIFRoZSBleGlzdGluZyBt
dWx0aXBhdGgtdG9vbHMgY29kZSBkb2Vzbid0IGRvIHRoYXQsIGl0Cj4gPiByZWxpZXMgb24gaXRz
IGludGVybmFsIHN0YXRlIGluZm9ybWF0aW9uIChwYXRoaW5mbywgY2hlY2tlcnMpCj4gPiBpbnN0
ZWFkLgo+ID4gSSBhbSBub3Qgc2F5aW5nIHRoYXQgd2hhdCB5b3UncmUgZG9pbmcgaXMgd3Jvbmcs
IGJ1dCBpdCBkZXNlcnZlcwo+ID4gc29tZQo+ID4gZXhwbGFuYXRpb24uIAo+ID4gCj4gPiBSZWdh
cmRzCj4gPiBNYXJ0aW4KPiA+IAo+IAo+IHRoZSBrZXJuZWwgUEFUSF9GQUlMRUQgZXZlbnRzIHdp
bGwgb25seSBiZSBpc3N1ZWQgd2hlbiBwYXRoIElPIGVycm9yCj4gb2Njb3Vycy4KCkFyZSB5b3Ug
cG9zaXRpdmUgYWJvdXQgdGhhdD8gSSB0aG91Z2h0IEkgY291bGQgc3dlYXIgdGhhdCd2ZSBzZWVu
IHRob3NlCmZvciBwYXRoIGRlbGV0aW9uLgoKSSBuZWVkIHRvIGRvdWJsZS1jaGVjay4KCk1hcnRp
bgoKCi0tIApEci4gTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+LCBUZWwuICs0OSAoMCk5
MTEgNzQwNTMgMjEwNwpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEph
bmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
