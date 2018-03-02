From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] multipathd: fix inverted signal blocking
	logic
Date: Sat, 03 Mar 2018 00:16:48 +0100
Message-ID: <1520032608.4169.91.camel@suse.com>
References: <20180302200048.GJ14513@octiron.msp.redhat.com>
	<20180302211807.11434-1-mwilck@suse.com>
	<1520026513.2855.30.camel@wdc.com>
	<1520028909.4169.87.camel@suse.com> <1520029421.2855.35.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1520029421.2855.35.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE4LTAzLTAyIGF0IDIyOjIzICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gT24gRnJpLCAyMDE4LTAzLTAyIGF0IDIzOjE1ICswMTAwLCBNYXJ0aW4gV2lsY2sgd3JvdGU6
Cj4gPiBPbiBGcmksIDIwMTgtMDMtMDIgYXQgMjE6MzUgKzAwMDAsIEJhcnQgVmFuIEFzc2NoZSB3
cm90ZToKPiA+ID4gVGhpcyBjaGFuZ2UgbG9va3MgbW9yZSBjb21wbGljYXRlZCB0byBtZSB0aGFu
IG5lY2Vzc2FyeS4gSGF2ZSB5b3UKPiA+ID4gY29uc2lkZXJlZAo+ID4gPiB0byBwYXNzIGFuIGVt
cHR5IHNpZ25hbCBzZXQgYXMgdGhlIGZvdXJ0aCBwcG9sbCgpIGFyZ3VtZW50Pwo+ID4gCj4gPiBB
biBlbXB0eSBzZXQgd291bGQgbWVhbiB0aGF0IG5vIHNpZ25hbCBpcyBibG9ja2VkIGR1cmluZyBw
cG9sbCgpLgo+ID4gVGhlcmVmb3JlIGUuZy4gU0lHQUxSTSB3b3VsZCB0ZXJtaW5hdGUgbXVsdGlw
YXRoZCBpZiBpdCBhcnJpdmVzCj4gPiBkdXJpbmcgdGhlIHBwb2xsIChubyBoYW5kbGVyIHNldCwg
YW5kIGRlZmF1bHQgYWN0aW9uIGlzICJUZXJtIikuCj4gCj4gSGF2ZSB5b3UgY29uc2lkZXJlZCB0
byBvbmx5IGJsb2NrIFNJR0FMUk0gd2hpbGUgcHBvbGwoKSBpcyBpbgo+IHByb2dyZXNzPwoKV2h5
IHNob3VsZCB3ZT8gVGhlIHNhbWUgcmVhc29uaW5nIGFwcGxpZXMgdG8gb3RoZXIgc2lnbmFscyBz
dWNoIGFzIGUuZy4KU0lHVVNSMi4gV2UgbmVlZCB0byBibG9jayBhbGwgc2lnbmFscyBleGNlcHQg
dGhvc2UgdGhhdCB3ZSBjYW4gaGFuZGxlLgoKUmVnYXJkcywKTWFydGluCgotLSAKRHIuIE1hcnRp
biBXaWxjayA8bXdpbGNrQHN1c2UuY29tPiwgVGVsLiArNDkgKDApOTExIDc0MDUzIDIxMDcKU1VT
RSBMaW51eCBHbWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFo
YW0gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVs
