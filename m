From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: logfs: kernel NULL dereference
Date: Thu, 15 Sep 2011 16:52:04 +0200
Message-ID: <20110915145204.GF24351@logfs.org>
References: <20110903125637.GG6092@smp.if.uj.edu.pl>
	<20110907141527.GM32018@logfs.org>
	<20110907210312.GA17634@smp.if.uj.edu.pl>
	<20110907220856.GR32018@logfs.org>
	<20110908161726.GA9104@smp.if.uj.edu.pl>
	<20110914182425.GD24351@logfs.org>
	<20110914183429.GE24351@logfs.org> <4E720B68.80809@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4E720B68.80809@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Prasad Joshi <prasadjoshi124@gmail.com>, Witold Baryluk <baryluk@smp.if.uj.edu.pl>, Aniket Sane <aniketsane@gmail.com>
List-Id: dm-devel.ids

T24gVGh1LCAxNSBTZXB0ZW1iZXIgMjAxMSAxNjoyNzo1MiArMDIwMCwgTWlsYW4gQnJveiB3cm90
ZToKPiBPbiAwOS8xNC8yMDExIDA4OjM0IFBNLCBKw7ZybiBFbmdlbCB3cm90ZToKPiA+IEZvcndh
cmRlZCB0byBkbS1kZXZlbC4gIFByb2JsZW0gaXMgYSBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2Ug
aW4KPiA+IGtjcnlwdGRfaW9fcmVhZCwgd2hpY2ggaXMgdHJpZ2dlcmVkIHdoZW4gbW91bnRpbmcg
bG9nZnMuICBJZiBzb21lb25lCj4gPiB3aXRoIGRldmljZSBtYXBwZXIga25vd2xlZGdlIGNvdWxk
IGhhdmUgYSBsb29rLCB0aGF0IHdvdWxkIGJlIHVzZWZ1bC4KPiA+IAo+ID4gT24gV2VkLCAxNCBT
ZXB0ZW1iZXIgMjAxMSAyMDoyNDoyNSArMDIwMCwgSsO2cm4gRW5nZWwgd3JvdGU6Cj4gPj4KPiA+
PiBPaywgSSBjYW4gcmVsaWFibHkgcmVwcm9kdWNlIHRoZSBwcm9ibGVtIHdpdGggdGhlIGZvbGxv
d2luZywgYmFzZWQgb24KPiA+PiB5b3VyIGRlc2NyaXB0aW9uOgo+ID4+Cj4gPj4gdHJ1bmNhdGUg
LXMgMCBmb28KPiA+PiB0cnVuY2F0ZSAtcyAxRyBmb28KPiA+PiBsb3NldHVwIC12IC1mIGZvbwo+
ID4+IGNyeXB0c2V0dXAgbHVrc0Zvcm1hdCAvZGV2L2xvb3AwCj4gPj4gY3J5cHRzZXR1cCBsdWtz
T3BlbiAvZGV2L2xvb3AwIGZvbwo+ID4+IHB2Y3JlYXRlIC9kZXYvbWFwcGVyL2Zvbwo+ID4+IHZn
Y3JlYXRlIG91cl92b2x1bWUgL2Rldi9tYXBwZXIvZm9vCj4gPj4gbHZjcmVhdGUgLUwgMTI4TSAt
biBsb2dmc3Rlc3Qgb3VyX3ZvbHVtZQo+ID4+IHllcyB5ZXMgfCBta2xvZ2ZzIC9kZXYvbWFwcGVy
L291cl92b2x1bWUtbG9nZnN0ZXN0Cj4gPj4gbW91bnQgL2Rldi9tYXBwZXIvb3VyX3ZvbHVtZS1s
b2dmc3Rlc3QgL21udC8KPiAKPiBXaGljaCBrZXJuZWwgdmVyc2lvbiBhcmUgeW91IHVzaW5nPwoK
TGF0ZXN0IGdpdCAtIHdlbGwsIGNsb3NlIHRvIGxhdGVzdCwgZ2l2ZW4gdGhlIGN1cnJlbnQga2Vy
bmVsLm9yZyB0cm91YmxlLgoKPiA+PiBJdCBpcyBhIGJpdCBhbm5veWluZyB0aGF0IGNyeXB0c2V0
dXAgY2Fubm90IGVhc2lseSBiZSBzY3JpcHRlZC4KPiAKPiBJdCBjYW4gYmUgZWFzaWx5IHNjcmlw
dGVkLiAoSW4gcXVpZXQgbW9kZSBpdCB3aWxsIG5vdCBhc2sgZm9yIFlFUyByZXNwb25zZSwgYWRk
IC1xLAo+IG9yIGp1c3QgZG8gImVjaG8gLW4gJFBBU1NXT1JEIHwgY3J5cHRzZXR1cCBsdWtzRm9y
bWF0IC4uLiIpCgpPaywgSSdsbCB1c2UgdGhhdCBpbiB0aGUgZnV0dXJlLiAgVGhhbmtzLgoKSsO2
cm4KCi0tIApNb3JlIGNvbXB1dGluZyBzaW5zIGFyZSBjb21taXR0ZWQgaW4gdGhlIG5hbWUgb2Yg
ZWZmaWNpZW5jeSAod2l0aG91dApuZWNlc3NhcmlseSBhY2hpZXZpbmcgaXQpIHRoYW4gZm9yIGFu
eSBvdGhlciBzaW5nbGUgcmVhc29uIC0gaW5jbHVkaW5nCmJsaW5kIHN0dXBpZGl0eS4KLS0gVy4g
QS4gV3VsZgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
