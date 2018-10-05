From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 01/19] libmultipath: fix tur checker
 timeout
Date: Fri, 05 Oct 2018 21:23:48 +0200
Message-ID: <9e0a80956e39bc384eda1165f8d4758ccc1db057.camel@suse.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-2-git-send-email-bmarzins@redhat.com>
	<deb772629c403acaf8c39a0e74f947a7f8b9d2bf.camel@suse.com>
	<20181004163118.GA3172@octiron.msp.redhat.com>
	<fd4fb2bec1f7b4dfa5703b2fb395a8f7bc8974bb.camel@suse.com>
	<20181005170259.GD3172@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181005170259.GD3172@octiron.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE4LTEwLTA1IGF0IDEyOjAyIC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gT24gRnJpLCBPY3QgMDUsIDIwMTggYXQgMTI6MTE6MThQTSArMDIwMCwgTWFydGluIFdp
bGNrIHdyb3RlOgo+ID4gT24gVGh1LCAyMDE4LTEwLTA0IGF0IDExOjMxIC0wNTAwLCAgQmVuamFt
aW4gTWFyemluc2tpICB3cm90ZToKPiA+ID4gCj4gPiA+IHRob3VnaHRzPwo+ID4gCj4gPiBHZW5l
cmFsbHkgc3BlYWtpbmcsIHdlJ3JlIGRlZXBseSBpbiB0aGUgcmVhbG0gb2YgaGlnaGx5IHVubGlr
ZWx5Cj4gPiBzaXR1YXRpb25zIEkgd291bGQgc2F5LiBCdXQgd2Ugc2hvdWxkIGdldCBpdCByaWdo
dCBldmVudHVhbGx5Lgo+ID4gCj4gPiBNYXliZSB3ZSBjYW4gYWRkIGxvZ2ljIHRvIHRoZSB0dXIg
dGhyZWFkIHRvIGtlZXAgaXRzIGhhbmRzIG9mZiB0aGUKPiA+IGNvbnRleHQgaWYgaXQncyBhICJ6
b21iaWUiLCBsaWtlIGJlbG93IChqdXN0IGEgdGhvdWdodCwgdW50ZXN0ZWQpPwo+IAo+IFRoaXMg
c3RpbGwgd291bGRuJ3Qgc3RvcCBhIHRocmVhZCBmcm9tIHJhY2luZyB3aXRoIG5ldyB0aHJlYWQK
PiBjcmVhdGlvbgo+IHRvIGNoYW5nZSBjdC0+aG9sZGVycyBvciBjdC0+cnVubmluZy4KCkkgZG9u
J3Qgc2VlIGEgcHJvYmxlbSB3aXRoIGN0LT5ob2xkZXJzLiBCZWluZyBhIHJlZmNvdW50LCBpdCBz
ZWVtcyB0bwpiZSBtYWRlIHF1aXRlIGZvciB0aGlzIHB1cnBvc2UuIFRoZSB6b21iaWUgdGhyZWFk
IF9tdXN0XyBkZWNyZW1lbnQgaXQKd2hlbiBpdCBldmVudHVhbGx5IGV4aXRzLiBXcnQgY3QtPnJ1
bm5pbmcsIHdlIG1heSBoYXZlIHRvIG1vdmUgaXQgdW5kZXIKdGhlIGxvY2sgYWdhaW4gaWYgd2Ug
d2FudCB0byBiZSBhYnNvbHV0ZWx5IHN1cmUuIAoKUmVnYXJkcwpNYXJ0aW4KCi0tIApEci4gTWFy
dGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMgMjEwNwpT
VVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdy
YWhhbSBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgoKLS0KZG0tZGV2ZWwgbWFpbGlu
ZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVs
