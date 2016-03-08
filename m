From: Hannes Reinecke <hare@suse.de>
Subject: dm-multipath performance patches
Date: Tue, 8 Mar 2016 08:39:33 +0100
Message-ID: <56DE81B5.80001@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

SGkgTWlrZSwKCnRvIHBpY2tpbmcgdXAgYW4gb2xkIHRvcGljLCB3aGF0J3MgdGhlIHN0YXR1cyBv
ZiB5b3VyIHBlcmZvcm1hbmNlCnBhdGNoZXMgZm9yIGRtLW11bHRpcGF0aD8KCkkndmUgc3RhcnRl
ZCBsb29raW5nIGEgYnJhbmNoICdkZXZlbDMnLCBhbmQgd2FzIHdvbmRlcmluZyBpZiB0aGVzZQph
cmUgdGhlIGxhdGVzdCBwYXRjaGVzIGF2YWlsYWJsZS4KT3Igd291bGQgeW91IGhhdmUgbmV3ZXI/
CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgIFRlYW1sZWFkIFN0
b3JhZ2UgJiBOZXR3b3JraW5nCmhhcmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAgICs0OSA5MTEg
NzQwNTMgNjg4ClNVU0UgTElOVVggR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJn
CkdGOiBGLiBJbWVuZMO2cmZmZXIsIEouIFNtaXRoYXJkLCBKLiBHdWlsZCwgRC4gVXBtYW55dSwg
Ry4gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVs
