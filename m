From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 01/11] libmultipath: load_config: skip
 setting unnecessary defaults
Date: Thu, 22 Jun 2017 08:01:38 +0200
Message-ID: <4184fd97-3d27-2b53-160c-915045d33011@suse.de>
References: <20170621150630.25773-1-mwilck@suse.com>
	<20170621150630.25773-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170621150630.25773-2-mwilck@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

T24gMDYvMjEvMjAxNyAwNTowNiBQTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+IFdlIGhhdmUgdGhl
IGxvZ2ljIGZvciBzZXR0aW5nIGRlZmF1bHRzIGZvciBwYXRocyBhbmQgbWFwcwo+IGluIHByb3Bz
ZWwuYy4gQnkgcHJlLXNldHRpbmcgY29uZiB2YWx1ZXMgd2l0aCBkZWZhdWx0cyBpbgo+IGxvYWRf
Y29uZmlnKCksIHdlIGdlbmVyYXRlIGlycml0YXRpbmcgbG9nIG1lc3NhZ2VzIGxpa2UKPiAnZmVh
dHVyZXMgPSAiMCIgKHNldHRpbmc6IG11bHRpcGF0aC5jb25mIGRlZmF1bHRzL2RldmljZXMgc2Vj
dGlvbiknCj4gaWYgbXVsdGlwYXRoLmNvbmYgZG9lc24ndCBjb250YWluIGEgZmVhdHVyZXMgc2V0
dGluZyBhdCBhbGwuCj4gCj4gRm9yIHNvbWUgY29uZmlnIHNldHRpbmdzLCB3ZSBuZWVkIHRvIHVz
ZSBkZWNsYXJlX2RlZl9zbnByaW50X2RlZmludCgpCj4gbm93IHRvIG1ha2Ugc3VyZSAibXVsdGlw
YXRoZCBzaG93IGNvbmZpZyIgcHJpbnRzIGFsbCBkZWZhdWx0cyBjb3JyZWN0bHkuCj4gVG8gYXZv
aWQgY29uZnVzaW9uLCB3ZSBkb24ndCBkbyB0aGlzIGZvciAibWF4X3NlY3RvcnMiLCBiZWNhdXNl
Cj4gbXVsdGlwYXRoZCBsZWF2ZXMgdGhpcyB1bnRvdWNoZWQgYnkgZGVmYXVsdC4KPiAKPiBTaWdu
ZWQtb2ZmLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KPiBBY2tlZC1ieTogQmVu
amFtaW4gTWFyemluc2tpIDxibWFyemluc0ByZWRoYXQuY29tPgo+IC0tLQo+ICBsaWJtdWx0aXBh
dGgvY29uZmlnLmMgIHwgMTYgLS0tLS0tLS0tLS0tLS0tLQo+ICBsaWJtdWx0aXBhdGgvZGljdC5j
ICAgIHwgMTEgKysrKysrKy0tLS0KPiAgbGlibXVsdGlwYXRoL3Byb3BzZWwuYyB8ICA2ICsrKysr
Kwo+ICAzIGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDIwIGRlbGV0aW9ucygtKQo+
IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuY29tPgoKQ2hlZXJzLAoK
SGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlCQkgICBUZWFtbGVhZCBTdG9yYWdlICYgTmV0
d29ya2luZwpoYXJlQHN1c2UuZGUJCQkgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApT
VVNFIExJTlVYIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpHRjogRi4gSW1l
bmTDtnJmZmVyLCBKLiBTbWl0aGFyZCwgSi4gR3VpbGQsIEQuIFVwbWFueXUsIEcuIE5vcnRvbgpI
UkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbA==
