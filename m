From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 11/12] libmultipath: add get_uid fallback
 code for NVMe devices
Date: Fri, 15 Mar 2019 12:49:41 +0100
Message-ID: <074156cffd37513971e337ef941256a6f7ed7504.camel@suse.com>
References: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
	<1552086725-18476-12-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1552086725-18476-12-git-send-email-bmarzins@redhat.com>
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
dGU6Cj4gSWYgbXVsdGlwYXRoIGNhbid0IGdldCB0aGUgdWlkIGZvciBOVk1lIGRldmljZXMgZnJv
bSB1ZGV2LCBpdCBjYW4gZ2V0Cj4gaXQKPiBkaXJlY3RseSBmcm9tIHN5c2ZzLgo+IAo+IFNpZ25l
ZC1vZmYtYnk6IEJlbmphbWluIE1hcnppbnNraSA8Ym1hcnppbnNAcmVkaGF0LmNvbT4KPiAtLS0K
PiAgbGlibXVsdGlwYXRoL2Rpc2NvdmVyeS5jIHwgNDkgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tLS0tCj4gLS0tLQo+ICAxIGZpbGUgY2hhbmdlZCwgMzQgaW5zZXJ0aW9ucygrKSwg
MTUgZGVsZXRpb25zKC0pCgpBc2lkZSB0aGUgbml0IG92ZXIgdGhlICJvbGRfbGVuIiB2YXJpYWJs
ZSBuYW1lIHRoYXQgSSByZW1hcmtlZCBvbgowNy8xMjoKClJldmlld2VkLWJ5OiBNYXJ0aW4gV2ls
Y2sgPG13aWxja0BzdXNlLmNvbT4KCi0tIApEci4gTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5j
b20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMgMjEwNwpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxp
eCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24KSFJCIDIxMjg0IChB
RyBOw7xybmJlcmcpCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5j
b20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
