From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 03/19] libmultipath: fix tur memory misuse
Date: Tue, 02 Oct 2018 09:48:50 +0200
Message-ID: <93ec299b033d4346796c71730bcf67b917a3863a.camel@suse.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-4-git-send-email-bmarzins@redhat.com>
	<822645627e483781ece68ac107d0d7b25dd2b6c1.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <822645627e483781ece68ac107d0d7b25dd2b6c1.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

T24gTW9uLCAyMDE4LTEwLTAxIGF0IDIyOjU5ICswMjAwLCBNYXJ0aW4gV2lsY2sgd3JvdGU6Cj4g
Cj4gQnV0IHVwb24gY2xvc2VyIGluc3BlY3Rpb24sIHRoZSB3aG9sZSBjaGVja2VyIG1lc3NhZ2Ug
aGFuZGxpbmcgc2VlbXMKPiB0bwo+IGJlIHBvaW50bGVzcy4gQ2hlY2tlciBtZXNzYWdlcyBhcmUg
b25seSB1c2VkIGJ5IHRoZSBUVVIgY2hlY2tlciwgYW5kCj4gdGhleSBzaW1wbHkgZHVwbGljYXRl
IHRoZSBzdGF0dXMgY29kZSB0aGF0IHRoZSBjaGVja2VyIHJldHVybnMuCj4gCj4gV2UgbWlnaHQg
YXMgd2VsbCBqdXN0IGRpdGNoIHRoZW0uLi4KCkZvcmdldCBpdC4gSSB3YXMgZm9vbGVkIGJ5IHRo
ZSBmYWN0IHRoYXQgYWxsIGNoZWNrZXJzIGV4Y2VwdCBUVVIgdXNlCk1TRygpIHRvIHNldCB0aGUg
bWVzc2FnZS4gU29ycnkgZm9yIHRoZSBub2lzZS4KCk1hcnRpbgoKLS0gCkRyLiBNYXJ0aW4gV2ls
Y2sgPG13aWxja0BzdXNlLmNvbT4sIFRlbC4gKzQ5ICgwKTkxMSA3NDA1MyAyMTA3ClNVU0UgTGlu
dXggR21iSCwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgR3JhaGFtIE5v
cnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw=
