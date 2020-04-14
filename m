From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/11] dm-zoned: store zone id within the
 zone structure and kill dmz_id()
Date: Tue, 14 Apr 2020 08:31:15 +0200
Message-ID: <b200b775-cd2e-e257-c3e9-3268ba87f352@suse.de>
References: <20200409064527.82992-1-hare@suse.de>
	<20200409064527.82992-2-hare@suse.de>
	<BY5PR04MB69007B6D7B177B226272C72DE7DE0@BY5PR04MB6900.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BY5PR04MB69007B6D7B177B226272C72DE7DE0@BY5PR04MB6900.namprd04.prod.outlook.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gNC8xMC8yMCA4OjM3IEFNLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPiBPbiAyMDIwLzA0LzA5
IDE1OjQ1LCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4+IEluc3RlYWQgb2YgY2FsY3VsYXRpbmcg
dGhlIHpvbmUgaW5kZXggYnkgdGhlIG9mZnNldCB3aXRoaW4gdGhlCj4+IHpvbmUgYXJyYXkgc3Rv
cmUgdGhlIGluZGV4IHdpdGhpbiB0aGUgc3RydWN0dXJlIGl0c2VsZi4gV2l0aCB0aGF0Cj4+IHRo
ZSBoZWxwZXIgZG16X2lkKCkgaXMgcG9pbnRsZXNzIGFuZCBjYW4gYmUgcmVwbGFjZWQgd2l0aCBh
Y2Nlc3NpbmcKPj4gdGhlIC0+aWQgdmFsdWUgZGlyZWN0bHkuCj4gCj4gTG9va3MgZ29vZC4gQWx0
aG91Z2ggdGhlIGtidWlsZCByb2JvdCBjb21wbGFpbmVkIHRoYXQgeW91IGZvcmdvdCB0byBjaGFu
Z2UgdGhlCj4gZG16X2lkKCkgdXNlIGluIHNvbWUgZG16X2Rldl93YXJuKCkgY2FsbHMgOikKPiBK
dXN0IHNlZW4gaXQuIFdpbGwgYmUgZml4aW5nIGl0IHVwIGluIHRoZSBuZXh0IHJvdW5kLgoKQ2hl
ZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgVGVhbWxlYWQg
U3RvcmFnZSAmIE5ldHdvcmtpbmcKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1h
eGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdl
c2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw=
