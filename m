From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 4/4] multipath: Fix a potential buffer
 overflow
Date: Tue, 13 Jun 2017 22:18:09 +0200
Message-ID: <1497385089.4654.54.camel@suse.com>
References: <20170613163339.23005-1-bart.vanassche@sandisk.com>
	<20170613163339.23005-5-bart.vanassche@sandisk.com>
	<1497382123.4654.48.camel@suse.com>
	<5549db47-506b-f564-19ff-8d9dd1c36177@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5549db47-506b-f564-19ff-8d9dd1c36177@sandisk.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gVHVlLCAyMDE3LTA2LTEzIGF0IDEyOjUzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gT24gMDYvMTMvMTcgMTI6MjksIE1hcnRpbiBXaWxjayB3cm90ZToKPiA+IGhvdyBhYm91dCB0
aGlzIHNpbXBsZXIgcGF0Y2gsIGFzIHByZmxhZyBpcyBhY3R1YWxseSBhIGJvb2xlYW4/Cj4gPiAK
PiA+IGRpZmYgLS1naXQgYS9tdWx0aXBhdGhkL2NsaV9oYW5kbGVycy5jIGIvbXVsdGlwYXRoZC9j
bGlfaGFuZGxlcnMuYwo+ID4gaW5kZXggMDRjNzM4NjYuLmMzMWViZDM0IDEwMDY0NAo+ID4gLS0t
IGEvbXVsdGlwYXRoZC9jbGlfaGFuZGxlcnMuYwo+ID4gKysrIGIvbXVsdGlwYXRoZC9jbGlfaGFu
ZGxlcnMuYwo+ID4gQEAgLTEzMzcsNyArMTMzNyw3IEBAIGNsaV9nZXRwcnN0YXR1cyAodm9pZCAq
IHYsIGNoYXIgKiogcmVwbHksIGludAo+ID4gKiBsZW4sIHZvaWQgKiBkYXRhKQo+ID4gICAgICAg
ICBtZW1zZXQoKnJlcGx5LDAsMik7Cj4gPiAgCj4gPiAgCj4gPiAtICAgICAgIHNwcmludGYoKnJl
cGx5LCIlZCIsbXBwLT5wcmZsYWcpOwo+ID4gKyAgICAgICBzcHJpbnRmKCpyZXBseSwgIiVkIiwg
ISFtcHAtPnByZmxhZyk7Cj4gPiAgICAgICAgICgqcmVwbHkpWzFdPSdcMCc7Cj4gCj4gSGVsbG8g
TWFydGluLAo+IAo+IEV2ZXJ5IHNwcmludGYoKSBjYWxsIHJlcXVpcmVzIGNhcmVmdWwgYW5hbHlz
aXMgdG8gc2VlIHdoZXRoZXIgb3Igbm90Cj4gaXQKPiB0cmlnZ2VycyBhIGJ1ZmZlciBvdmVyZmxv
dy4gSSByZWFsbHkgd291bGQgbGlrZSB0byBnZXQgcmlkIG9mIHRoYXQKPiBzcHJpbnRmKCkgY2Fs
bC4KClRoZW4gd2UgY291bGQgd3JpdGUKCglzbnByaW50ZigqcmVwbHksIDIsICIlZCIsICEhbXBw
LT5wcmZsYWcpOwogIAp3aXRob3V0IG5lZWRpbmcgX0dOVV9TT1VSQ0UuCgpNYXJ0aW4KCi0tIApE
ci4gTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMg
MjEwNwpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhh
cmQsIEdyYWhhbSBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
