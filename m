From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 2/3] dm core: export dm_disk to allow for
	dm-raid to pass it on to the MD raid0 personality
Date: Tue, 21 Apr 2015 10:57:50 -0500
Message-ID: <40F0784D-F4FB-4068-83A2-DEA7AD6B358D@redhat.com>
References: <1429274386-16385-3-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1429274386-16385-3-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

Cj4gT24gQXByIDE3LCAyMDE1LCBhdCA3OjM5IEFNLCBoZWluem1AcmVkaGF0LmNvbSB3cm90ZToK
PiAKPiBGcm9tOiBIZWlueiBNYXVlbHNoYWdlbiA8aGVpbnptQHJlZGhhdC5jb20+Cj4gCj4gVGhp
cyBwYXRjaCBpcyBhIHByZXJlcXVpc2l0ZSBmb3IgZG0tcmFpZCAicmFpZDAiIHN1cHBvcnQgdG8g
YWxsb3cKPiBkbS1yYWlkIHRvIHNldCBycy0+bWQuZ2VuZGlzaywgd2hpY2ggaXMgcmVxdWlyZWQg
YnkgdGhlIE1EIFJBSUQwCj4gcGVzb25hbGl0eSB0byBzZXQgZGlzayBzdGFja2luZyBsaW1pdHMu
Cj4gCj4gU2lnbmVkLW9mZi1ieTogSGVpbnogTWF1ZWxzaGFnZW4gPGhlaW56bUByZWRoYXQuY29t
Pgo+IAo+IC0tLQo+IGRyaXZlcnMvbWQvZG0uYyB8IDEgKwo+IDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLmMgYi9kcml2ZXJzL21k
L2RtLmMKPiBpbmRleCA4MDAxZmU5Li5mMTFlMmY1IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbWQv
ZG0uYwo+ICsrKyBiL2RyaXZlcnMvbWQvZG0uYwo+IEBAIC0zMjA2LDYgKzMyMDYsNyBAQCBzdHJ1
Y3QgZ2VuZGlzayAqZG1fZGlzayhzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQpCj4gewo+IAlyZXR1
cm4gbWQtPmRpc2s7Cj4gfQo+ICtFWFBPUlRfU1lNQk9MX0dQTChkbV9kaXNrKTsKPiAKPiBzdHJ1
Y3Qga29iamVjdCAqZG1fa29iamVjdChzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQpCj4gewo+IOKA
lCAKClRoaXMgcGF0Y2ggZ29lcyBhd2F5IGR1ZSB0byBjaGFuZ2VzIGluIHByZXYgcGF0Y2guCgog
YnJhc3NvdwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
