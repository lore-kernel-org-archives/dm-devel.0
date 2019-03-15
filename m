From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 09/12] multipathd: use update_path_groups
 instead of reload_map
Date: Fri, 15 Mar 2019 12:49:01 +0100
Message-ID: <3d078933c638d228717c5333feddcb72bb565392.camel@suse.com>
References: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
	<1552086725-18476-10-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1552086725-18476-10-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gRnJpLCAyMDE5LTAzLTA4IGF0IDE3OjEyIC0wNjAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gcmVsb2FkX21hcCgpIGRvZXNuJ3QgZG8gdGhlIHdvcmsgdG8gc3luYyB0aGUgc3RhdGUg
YWZ0ZXIgcmVsb2FkaW5nCj4gdGhlCj4gbWFwLiAgSW5zdGVhZCBvZiBjYWxsaW5nIGl0IGRpcmVj
dGx5LCBjbGlfcmVsb2FkKCkgYW5kCj4gdWV2X3VwZGF0ZV9wYXRoKCkKPiBzaG91bGQgY2FsbCB1
cGRhdGVfcGF0aF9ncm91cHMoKSwgd2hpY2ggY2FsbHMgcmVsb2FkX21hcCgpIHdpdGggYWxsCj4g
dGhlCj4gbmVjZXNzYXJ5IHN5bmNpbmcuCj4gCj4gU2lnbmVkLW9mZi1ieTogQmVuamFtaW4gTWFy
emluc2tpIDxibWFyemluc0ByZWRoYXQuY29tPgo+IC0tLQo+ICBtdWx0aXBhdGhkL2NsaV9oYW5k
bGVycy5jIHwgIDIgKy0KPiAgbXVsdGlwYXRoZC9tYWluLmMgICAgICAgICB8IDEzICsrKysrKysr
LS0tLS0KPiAgbXVsdGlwYXRoZC9tYWluLmggICAgICAgICB8ICAyICsrCj4gIDMgZmlsZXMgY2hh
bmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKClJldmlld2VkLWJ5OiBNYXJ0
aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KCi0tIApEci4gTWFydGluIFdpbGNrIDxtd2lsY2tA
c3VzZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMgMjEwNwpTVVNFIExpbnV4IEdtYkgsIEdG
OiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24KSFJCIDIx
Mjg0IChBRyBOw7xybmJlcmcpCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
