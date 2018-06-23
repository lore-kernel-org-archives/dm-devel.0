From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 4/6] libmpathpersist: fix byte swapping for
 big endian systems
Date: Sat, 23 Jun 2018 22:04:25 +0200
Message-ID: <8ac25430c7232548f89c89f522598d168aa62180.camel@suse.com>
References: <20180622231516.18806-1-mwilck@suse.com>
	<20180622231516.18806-4-mwilck@suse.com>
	<ea8fc535-4602-b326-73c8-7e0b18243181@wdc.com>
	<9345b1022e97ad380fc24b24fb4d5ec7bd498b6c.camel@suse.com>
	<a033a0fc-46b1-fccb-7bea-897607aa5a63@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a033a0fc-46b1-fccb-7bea-897607aa5a63@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@wdc.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE4LTA2LTIyIGF0IDE2OjQ4IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gCj4gQWRkaW5nIGFuIGltcGxlbWVudGF0aW9uIG9mIGdldF91bmFsaWduZWRfYmU2NCgpIGFu
ZCBpbnRyb2R1Y2luZyBpdAo+IGluIAo+IHRoZSBhYm92ZSBjb2RlIHdvdWxkIGJlIGhpZ2hseSBh
cHByZWNpYXRlZC4gSSB0aGluayB0aGF0IHdpbGwKPiBpbXByb3ZlIAo+IHJlYWRhYmlsaXR5LgoK
b2ssIHdpbGwgZG8uCgpNYXJ0aW4KCi0tIApEci4gTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5j
b20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMgMjEwNwpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxp
eCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24KSFJCIDIxMjg0IChB
RyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
