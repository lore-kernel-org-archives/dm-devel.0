From: Karel Zak <kzak@redhat.com>
Subject: Re: linux-next - WARNING: at
	fs/block_dev.c:824	bd_link_disk_holder+0x92/0x1ac()
Date: Thu, 13 Jan 2011 16:59:55 +0100
Message-ID: <20110113155955.GI16523@nb.net.home>
References: <4D2EE156.1050006@redhat.com> <20110113122701.GG16523@nb.net.home>
	<20110113131216.GF30719@htj.dyndns.org>
	<20110113132637.GH16523@nb.net.home>
	<20110113133722.GG30719@htj.dyndns.org>
	<4D2F04FF.1070309@redhat.com>
	<20110113141107.GI30719@htj.dyndns.org>
	<4D2F0B6A.6010201@redhat.com>
	<AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
	<AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

T24gVGh1LCBKYW4gMTMsIDIwMTEgYXQgMDM6NDM6MzhQTSArMDEwMCwgS2F5IFNpZXZlcnMgd3Jv
dGU6Cj4gT24gVGh1LCBKYW4gMTMsIDIwMTEgYXQgMTU6MzAsIFRlanVuIEhlbyA8dGpAa2VybmVs
Lm9yZz4gd3JvdGU6Cj4gPiBPbiBUaHUsIEphbiAxMywgMjAxMSBhdCAzOjI1IFBNLCBNaWxhbiBC
cm96IDxtYnJvekByZWRoYXQuY29tPiB3cm90ZToKPiA+PiBNYXliZSwgYnV0IHRoaXMgd2FzIG5v
dCBpbnZlbnRlZCBpbiBETS9NRCBjYW1wOi0pCj4gPj4gUHJvYmFibHkgS2F5IG9yIEdyZWcgY2Fu
IGFuc3dlciB3aHkgaXQgd2FzIGRvbmUgdGhpcyB3YXk/Cj4gCj4gSXQncyBub3QgZnJvbSBHcmVn
IG9yIEtheS4gSXQganVzdCBhcHBlYXJlZCBzb21lIGRheSBpbiB0aGUgY29udGV4dCBvZiBkbS4g
OikKPiAKPiBBbmQgeWVzLCBzeW1saW5rcyAqbG9vayogbmljZSBhbmQgc2ltcGxlIGZvciB0aGUg
b3V0c2lkZSwgYnV0IHRoZXkgYXJlCj4gbm90LCBhbmQgaGF2ZSBhbGwgc29ydHMgb2YgcHJvYmxl
bXMgbGlrZSBub24tYXRvbWljIHVwZGF0ZXMsIG1ha2UgaXQKCiBTb3VuZHMgbGlrZSBzeXNmcyBp
bXBsZW1lbnRhdGlvbiBwcm9ibGVtLCByaWdodD8KCiBJZiB0aGVyZSBpcyBub3dheSB0byBmaXgg
c3lzZnMgdGhlbiB3ZSBjYW4gYWRkIGEgZ2VuZXJpYyBpb2N0bCBvcgogL3N5cy9ibG9jay88ZGV2
aWNlPi97c2xhdmUsaG9sZGVyfV9saXN0IGZpbGVzIHdpdGggbGlzdCBvZgogaG9sZGVycy9zbGF2
ZXMuCiAKIEJ1dCBwbGVhc2UsIGRvbid0IGZvcmNlIHVzZXJzcGFjZSB0byB1c2UgKmNsYWltZXIt
c3BlY2lmaWMqCiBtZXRob2RzIHRvIGFuc3dlciAqZ2VuZXJpYyBxdWVzdGlvbnMqIGxpa2Ugc2xh
dmUvaG9sZGVyIGRlcGVuZGVuY2llcwogYmV0d2VlbiBkZXZpY2VzLgogCj4gaW1wb3NzaWJsZSB0
byBldmVyIHJlbmFtZSBhIGRldmljZSAoYXMgbG9uZyBhcyB0aGV5IGNvcHkgdGhlIGRldmljZQo+
IG5hbWUpLCBhbmQgYW5kIGFuZCAuLi4uIHdlIHNob3VsZCBub3QgYWRkIG1vcmUgb2YgdGhpcy4K
PiAKPiA+PiBJZiBidHJmcyBpbnRlcm5hbGx5IGNyZWF0ZXMgc29tZSB2aXJ0dWFsIF9ibG9ja18g
ZGV2aWNlIGZvciBpdHMgcG9vbCwgaXQgc2hvdWxkCj4gPj4gcHJlc2VudCBpdCBoZXJlIHRvbyB3
aXRoIHNsYXZlcy9ob2xkZXJzLiBJZiBub3QsIHdoeSBpdCBzaG91bGQgY3JlYXRlIGFueSBsaW5r
cyB0aGVyZT8KPiA+Cj4gPiBZZWFoLCB0aGF0J3MgdGhlIG1vc3QgYm90aGVyaW5nIHBhcnQgZm9y
IG1lLiDCoFRoZSBiaWdnZXN0IGN1c3RvbWVycyBvZgo+ID4gYmRfY2xhaW0gYXJlIGZpbGVzeXN0
ZW1zIGFuZCBhbGwgdGhlc2UgY3VzdG9tIHN5bWxpbmtlcmllcyBkb24ndCBkbwo+ID4gbm90aGlu
ZyBmb3IgdGhlbS4gwqBJdCBqdXN0IGRvZXNuJ3QgbWFrZSBhIHdob2xlIGxvdCBvZiBzZW5zZSB0
byBtZS4KPiAKPiBCdHJmcyBkb2VzIG5vdCB1c2UgYW55IGJsb2NrZGV2IGFzIHRoZSBtYXN0ZXIg
Zm9yIGdvb2QgcmVhc29uLCBhbmQgaXQKPiBjYW4gbmV2ZXIgbWFwIGl0cyBzbGF2ZXMgaW5zaWRl
IG9mIC9zeXMvYmxvY2suIAoKIFllcCwgZXhwZWN0ZWQgYW5kIGNvcnJlY3QgcmVzcG9uc2UgOi0p
CgogICAgS2FyZWwKCi0tIAogS2FyZWwgWmFrICA8a3pha0ByZWRoYXQuY29tPgogaHR0cDovL2th
cmVsemFrLmJsb2dzcG90LmNvbQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
