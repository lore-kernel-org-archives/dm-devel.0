From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 07/12] libmultipath: move remove_map waiter
 code to multipathd
Date: Mon, 19 Mar 2018 11:57:22 +0100
Message-ID: <1521457042.3798.23.camel@suse.com>
References: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
	<1521049605-22050-8-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521049605-22050-8-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

T24gV2VkLCAyMDE4LTAzLTE0IGF0IDEyOjQ2IC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gT25seSBtdWx0aXBhdGhkIG5lZWRzIHRvIHdvcnJ5IGFib3V0IHRoZSBtdWx0aXBhdGgg
d2FpdGVyIGNvZGUuIFRoZXJlCj4gaXMKPiBubyBwb2ludCBpbiBoYXZpbmcgcmVtb3ZlX21hcF9h
bmRfc3RvcF93YWl0ZXIoKSBvcgo+IHJlbW92ZV9tYXBzX2FuZF9zdG9wX3dhaXRlcnMoKSBpbiBs
aWJtdWx0aXBhdGgsIHNpbmNlIHRoZXkgc2hvdWxkCj4gbmV2ZXIKPiBiZSB1c2Ugb3V0c2lkZSBv
ZiBtdWx0aXBhdGhkLgo+IAo+IFJldmlld2VkLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNl
LmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBCZW5qYW1pbiBNYXJ6aW5za2kgPGJtYXJ6aW5zQHJlZGhh
dC5jb20+CgoKCj4gK3N0YXRpYyB2b2lkCj4gK3JlbW92ZV9tYXBfYW5kX3N0b3Bfd2FpdGVyKHN0
cnVjdCBtdWx0aXBhdGggKm1wcCwgc3RydWN0IHZlY3RvcnMKPiAqdmVjcywKPiArCQkJICAgaW50
IHB1cmdlX3ZlYykKPiArewo+ICsJc3RvcF93YWl0ZXJfdGhyZWFkKG1wcCwgdmVjcyk7Cj4gKwly
ZW1vdmVfbWFwKG1wcCwgdmVjcywgcHVyZ2VfdmVjKTsKPiArfQoKQUZBSUNTIHJlbW92ZV9tYXBf
YW5kX3N0b3Bfd2FpdGVyIGlzIGFsd2F5cyBjYWxsZWQgd2l0aCBwdXJnZV92ZWMgPT0gMSwKc28g
dGhpcyBjb3VsZCBiZSBmdXJ0aGVyIHNpbXBsaWZpZWQuIENvdWxkIGJlIGEgc2VwYXJhdGUgcGF0
Y2ggdGhvdWdoLgoKCgotLSAKRHIuIE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPiwgVGVs
LiArNDkgKDApOTExIDc0MDUzIDIxMDcKU1VTRSBMaW51eCBHbWJILCBHRjogRmVsaXggSW1lbmTD
tnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5i
ZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
