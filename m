From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/7] dm-mpath: Fix a race condition in the
	blk-mq path
Date: Wed, 16 Nov 2016 08:39:34 +0100
Message-ID: <05d83937-9fcc-7bee-8507-fd59ec25ec7f@suse.de>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gMTEvMTYvMjAxNiAxMjozMSBBTSwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOgo+IEhlbGxvIE1p
a2UsCj4gCj4gVGhlIHNldmVuIHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMgaXMgd2hhdCBJIGNhbWUg
dXAgd2l0aCB3aGlsZSByZXZpZXdpbmcKPiBhbmQgdGVzdGluZyB0aGUgZG0tbXBhdGggc2luZ2xl
IHF1ZXVlIGFuZCBtdWx0aXF1ZXVlIGNvZGUuIEl0IHdvdWxkIGJlCj4gYXBwcmVjaWF0ZWQgaWYg
dGhlc2UgcGF0Y2hlcyB3b3VsZCBiZSBjb25zaWRlcmVkIGZvciBpbmNsdXNpb24gaW4gdGhlCj4g
dXBzdHJlYW0ga2VybmVsLgo+IApGb3IgdGhlIHdob2xlIHNlcmllczoKClJldmlld2VkLWJ5OiBI
YW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5jb20+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBI
YW5uZXMgUmVpbmVja2UJCSAgIFRlYW1sZWFkIFN0b3JhZ2UgJiBOZXR3b3JraW5nCmhhcmVAc3Vz
ZS5kZQkJCSAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgTElOVVggR21iSCwg
TWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkdGOiBGLiBJbWVuZMO2cmZmZXIsIEouIFNt
aXRoYXJkLCBKLiBHdWlsZCwgRC4gVXBtYW55dSwgRy4gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8
cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
