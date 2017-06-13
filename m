From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/4] libmultipath: Simplify assemble_map()
Date: Tue, 13 Jun 2017 21:32:39 +0200
Message-ID: <1497382359.4654.51.camel@suse.com>
References: <20170613163339.23005-1-bart.vanassche@sandisk.com>
	<20170613163339.23005-3-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170613163339.23005-3-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

T24gVHVlLCAyMDE3LTA2LTEzIGF0IDA5OjMzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gSW50cm9kdWNlIGEgbWFjcm8gZm9yIGFwcGVuZGluZyBmb3JtYXR0ZWQgdGV4dCB0byB0aGUg
b3V0cHV0IGJ1ZmZlci4KPiBFbGltaW5hdGUgdGhlIGxvY2FsIHZhcmlhYmxlcyAnc2hpZnQnIGFu
ZCAnZnJlZWNoYXInLiBNb3ZlIHRoZQo+IGNvZGUgZm9yIGZyZWVpbmcgYSB0ZW1wb3JhcnkgYnVm
ZmVyIHRvIHRoZSBlbmQgb2YgdGhlIGZ1bmN0aW9uLgo+IEhhbmRsZSBzbnByaW50ZigpIGNvbnZl
cnNpb24gZXJyb3JzLiBUaGlzIHBhdGNoIGF2b2lkcyB0aGF0IGdjYyA3Cj4gcmVwb3J0cyB0aGUg
Zm9sbG93aW5nIHdhcm5pbmc6Cj4gCj4gZG1wYXJzZXIuYzoxMzc6MjA6IHdhcm5pbmc6ICdfX2J1
aWx0aW5fc25wcmludGYnIG91dHB1dCB0cnVuY2F0ZWQKPiBiZWZvcmUgdGhlIGxhc3QgZm9ybWF0
IGNoYXJhY3RlciBbLVdmb3JtYXQtdHJ1bmNhdGlvbj1dCj4gICBzbnByaW50ZihwLCAxLCAiXG4i
KTsKPiAgICAgICAgICAgICAgICAgICAgIF4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBB
c3NjaGUgPGJhcnQudmFuYXNzY2hlQHNhbmRpc2suY29tPgo+IC0tLQo+ICBsaWJtdWx0aXBhdGgv
ZG1wYXJzZXIuYyB8IDY3ICsrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0KPiAt
LS0tLS0tLS0tLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDMxIGluc2VydGlvbnMoKyksIDM2IGRlbGV0
aW9ucygtKQo+IAoKUmV2aWV3ZWQtYnk6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgoK
LS0gCkRyLiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4sIFRlbC4gKzQ5ICgwKTkxMSA3
NDA1MyAyMTA3ClNVU0UgTGludXggR21iSCwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBT
bWl0aGFyZCwgR3JhaGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
