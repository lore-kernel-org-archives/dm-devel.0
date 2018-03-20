From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/2] libmultipath: fallback to const prio if
 getprio() fails
Date: Tue, 20 Mar 2018 22:13:24 +0100
Message-ID: <1521580404.3798.175.camel@suse.com>
References: <20180320165010.15259-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180320165010.15259-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

T24gVHVlLCAyMDE4LTAzLTIwIGF0IDE3OjUwICswMTAwLCBNYXJ0aW4gV2lsY2sgd3JvdGU6Cj4g
U29tZSBzdG9yYWdlIGNvbnRyb2xsZXJzIGRvbid0IHN1cHBvcnQgQUxVQSBldmVuIHRob3VnaCB0
aGV5IGhhdmUKPiBod3RhYmxlIGVudHJpZXMgdGVsbGluZyBzby4gT25lIHN1Y2ggZXhhbXBsZSBp
cyB0aGUgSUJNIElQUiBTQVMKPiBjb250cm9sbGVyCj4gZm91bmQgb24gY2VydGFpbiBJQk0gUG93
ZXIgc3lzdGVtcy4gSUJNIGhhcyBjb25maXJtZWQgdGhhdCByZWxpYWJsZQo+IGRldGVjdGlvbiBv
ZiBBTFVBIHN1cHBvcnQgZm9yIHRoaXMgY29udHJvbGxlciBieSB2ZW5kb3IvbW9kZWwvcmV2IGlz
Cj4gaW1wb3NzaWJsZS4KPiAKPiBGb3Igc3VjaCBjYXNlcywgaW5zdGVhZCBvZiBzaW1wbHkgZmFp
bGluZyB0byBzZXR1cCBtdWx0aXBhdGgsIGZhbGwKPiBiYWNrCj4gdG8gY29uc3QgcHJpby4KPiAK
PiBTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KCk5BQ0sgdG8g
c2VsZi4gSSBqdXN0IHJlYWxpemVkIHRoYXQgdGhpcyB3b24ndCB3b3JrLCBiZWNhdXNlIHdlIG1p
Z2h0IGJlCnJlc2V0dGluZyBlLmcuIGFsdWEgcHJpb3JpdGl6ZXIgdG8gImNvbnN0IiBiZWNhdXNl
IG9mIGEgdGVtcG9yYXJ5CnByb2JsZW0uIFNvIHRoaXMgbmVlZHMgbW9yZSB0aG91Z2h0LgoKTWFy
dGluCgotLSAKRHIuIE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPiwgVGVsLiArNDkgKDAp
OTExIDc0MDUzIDIxMDcKU1VTRSBMaW51eCBHbWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBK
YW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
