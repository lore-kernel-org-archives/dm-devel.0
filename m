From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 22/22] libmultipath: make checker_message
	thread safe
Date: Fri, 02 Nov 2018 09:50:07 +0100
Message-ID: <00ac6224763b7bb2b0ec04da98e0528fa89605c5.camel@suse.com>
References: <20181030210653.29677-1-mwilck@suse.com>
	<20181030210653.29677-23-mwilck@suse.com>
	<20181101195303.GC29522@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181101195303.GC29522@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, mwilck+gmail@suse.de
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

T24gVGh1LCAyMDE4LTExLTAxIGF0IDE0OjUzIC0wNTAwLCAgQmVuamFtaW4gTWFyemluc2tpICB3
cm90ZToKPiBPbiBUdWUsIE9jdCAzMCwgMjAxOCBhdCAxMDowNjo1M1BNICswMTAwLCBNYXJ0aW4g
V2lsY2sgd3JvdGU6Cj4gPiBHZXQgcmlkIG9mIHRoZSBzdGF0aWMgY2hhciBidWZmZXIgaW4gY2hl
Y2tlcl9tZXNzYWdlKCkKPiA+IGludHJvZHVjZWQgaW4gdGhlIHByZXZpb3VzICJyZXBsYWNlIG1l
c3NhZ2UgYnkgbXNnaWQiIHBhdGNoLgo+IAo+IFdoYXQgeW91IGhhdmUgaXMgZmluZSwgYnV0IHdo
eSBub3Qgc29tZXRoaW5nIGxpa2UgdGhpcywgd2hpY2ggZG9lc24ndAo+IG5lZWQgdG8gZG8gYW55
IGFsbG9jYXRpbmc/CgpUaGUgcmVhc29uIChhcGFydCBmcm9tIG15c2VsZiBiZWluZyBibGluZCkg
d2FzIHRoYXQgY2hlY2tlcl9tZXNzYWdlKCkKcHJpbnRzIHNvbWUgZXh0cmEgdGV4dCBhcm91bmQg
dGhlIG1lc3NhZ2UuIEJ1dCB3aXRoIG9ubHkgdHdvIGNhbGxlcnMsCnRoYXQncyBhY3R1YWxseSBv
dmVyLWNvbXBsaWNhdGluZyBtYXR0ZXJzLgoKVGhhbmtzIGZvciBwb2ludGludCB0aGlzIG91dCwg
SSdsbCByZS1wb3N0LgoKTWFydGluCgotLSAKRHIuIE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2Uu
Y29tPiwgVGVsLiArNDkgKDApOTExIDc0MDUzIDIxMDcKU1VTRSBMaW51eCBHbWJILCBHRjogRmVs
aXggSW1lbmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9uCkhSQiAyMTI4NCAo
QUcgTsO8cm5iZXJnKQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQu
Y29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
