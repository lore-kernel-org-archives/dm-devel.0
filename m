Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 168B6C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 10 Dec 2021 07:58:44 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-F6GWLi47OayKdl3rGQnoYQ-1; Fri, 10 Dec 2021 02:58:40 -0500
X-MC-Unique: F6GWLi47OayKdl3rGQnoYQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57EA439381;
	Fri, 10 Dec 2021 07:58:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FD32100164A;
	Fri, 10 Dec 2021 07:58:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D68A41806D1C;
	Fri, 10 Dec 2021 07:58:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B9Cvf2N021896 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 9 Dec 2021 07:57:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 559DCC08095; Thu,  9 Dec 2021 12:57:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 50840C15E6F
	for <dm-devel@redhat.com>; Thu,  9 Dec 2021 12:57:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBB9A3C00138
	for <dm-devel@redhat.com>; Thu,  9 Dec 2021 12:57:40 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-517-UkKIcvjAObSyedYmLeUqcA-1; Thu, 09 Dec 2021 07:57:37 -0500
X-MC-Unique: UkKIcvjAObSyedYmLeUqcA-1
Received: from [192.168.0.175] (ip5f5aed0f.dynamic.kabel-deutschland.de
	[95.90.237.15])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested) (Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id F2E6E61E64846;
	Thu,  9 Dec 2021 13:57:34 +0100 (CET)
From: Donald Buczek <buczek@molgen.mpg.de>
To: Paul Menzel <pmenzel@molgen.mpg.de>, song@kernel.org,
	Guoqing Jiang <guoqing.jiang@linux.dev>
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
Message-ID: <2cefad59-c0fc-d48f-f7a5-5d593931feb7@molgen.mpg.de>
Date: Thu, 9 Dec 2021 13:57:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B9Cvf2N021896
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 10 Dec 2021 02:58:30 -0500
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, it+raid@molgen.mpg.de,
	snitzer@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH V2] md: don't unregister sync_thread with
 reconfig_mutex held
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

W1VwZGF0ZSBHdW9xaW5n4oCZcyBlbWFpbCBhZGRyZXNzXQoKT24gMTUuMDIuMjEgMTI6MDcsIFBh
dWwgTWVuemVsIHdyb3RlOgo+IFsrY2MgRG9uYWxkXQo+IAo+IEFtIDEzLjAyLjIxIHVtIDAxOjQ5
IHNjaHJpZWIgR3VvcWluZyBKaWFuZzoKPj4gVW5yZWdpc3RlciBzeW5jX3RocmVhZCBkb2Vzbid0
IG5lZWQgdG8gaG9sZCByZWNvbmZpZ19tdXRleCBzaW5jZSBpdAo+PiBkb2Vzbid0IHJlY29uZmln
dXJlIGFycmF5Lgo+Pgo+PiBBbmQgaXQgY291bGQgY2F1c2UgZGVhZGxvY2sgcHJvYmxlbSBmb3Ig
cmFpZDUgYXMgZm9sbG93czoKPj4KPj4gMS4gcHJvY2VzcyBBIHRyaWVkIHRvIHJlYXAgc3luYyB0
aHJlYWQgd2l0aCByZWNvbmZpZ19tdXRleCBoZWxkIGFmdGVyIGVjaG8KPj4gwqDCoMKgIGlkbGUg
dG8gc3luY19hY3Rpb24uCj4+IDIuIHJhaWQ1IHN5bmMgdGhyZWFkIHdhcyBibG9ja2VkIGlmIHRo
ZXJlIHdlcmUgdG9vIG1hbnkgYWN0aXZlIHN0cmlwZXMuCj4+IDMuIFNCX0NIQU5HRV9QRU5ESU5H
IHdhcyBzZXQgKGJlY2F1c2Ugb2Ygd3JpdGUgSU8gY29tZXMgZnJvbSB1cHBlciBsYXllcikKPj4g
wqDCoMKgIHdoaWNoIGNhdXNlcyB0aGUgbnVtYmVyIG9mIGFjdGl2ZSBzdHJpcGVzIGNhbid0IGJl
IGRlY3JlYXNlZC4KPj4gNC4gU0JfQ0hBTkdFX1BFTkRJTkcgY2FuJ3QgYmUgY2xlYXJlZCBzaW5j
ZSBtZF9jaGVja19yZWNvdmVyeSB3YXMgbm90IGFibGUKPj4gwqDCoMKgIHRvIGhvbGQgcmVjb25m
aWdfbXV0ZXguCj4+Cj4+IE1vcmUgZGV0YWlscyBpbiB0aGUgbGluazoKPj4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGludXgtcmFpZC81ZWQ1NGZmYy1jZTgyLWJmNjYtNGVmZi0zOTBjYjIzYmMx
YWNAbW9sZ2VuLm1wZy5kZS9ULyN0Cj4+Cj4+IEFuZCBhZGQgb25lIHBhcmFtZXRlciB0byBtZF9y
ZWFwX3N5bmNfdGhyZWFkIHNpbmNlIGl0IGNvdWxkIGJlIGNhbGxlZCBieQo+PiBkbS1yYWlkIHdo
aWNoIGRvZXNuJ3QgaG9sZCByZWNvbmZpZ19tdXRleC4KPj4KPj4gUmVwb3J0ZWQtYW5kLXRlc3Rl
ZC1ieTogRG9uYWxkIEJ1Y3playA8YnVjemVrQG1vbGdlbi5tcGcuZGU+CgpUaGFua3MsIFBhdWws
IGZvciBwdXR0aW5nIG1lIGludG8gdGhlIGNjLgoKR3VvcWluZywgSSBkb24ndCB0aGluaywgSSd2
ZSB0ZXN0ZWQgdGhpcyBwYXRjaC4gUGxlYXNlIHJlbW92ZSB0aGUgdGVzdGVkLWJ5LgoKYnR3OiBX
ZSBoYXZlIHRoZSBmaXggSSBzdWdnZXN0ZWQgWzFdIHJ1bm5pbmcgb24gNTkgcHJvZHVjdGlvbiBy
YWlkNiBzZXRzIHdpdGggMTYgZGlzayBlYWNoIHdpdGggdmFyaW91cyBsb2FkcyBhbmQgd2l0aCBt
b250aGx5IG1kY2hlY2sgKHBhdXNlZCBkdXJpbmcgZGF5dGltZSwgc28gYSBmZXcgdHJhbnNpdGlv
bnMgZWFjaCBtb250aCkgb24gc2V2ZXJhbCBrZXJuZWwgdmVyc2lvbnMgcnVubmluZyBmb3IgbmVh
cmx5IGEgeWVhciBub3cuIE1hbnkgbW9yZSB0cmFuc2l0aW9ucyBkdXJpbmcgdGVzdGluZy4gVGhh
dCBkb2Vzbid0IG1lYW4gdGhlIGZpeCBpcyBjb3JyZWN0LCBvZiBjb3Vyc2UuIFRoZSBjb25maWd1
cmF0aW9ucyBvZiBvdXIgc3lzdGVtcyBhcmUgYWxtb3N0IGlkZW50aWNhbCBhbmQgd2UgZG9uJ3Qg
ZG8gc3VzcGVuZCBvciBhbnl0aGluZy4gQnV0IG1heWJlIHlvdSBtaWdodCB3YW50IHRvIHJlY29u
c2lkZXIuCgpbMV06IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXJhaWQvYmMzNDJkZTAt
OThkMi0xNzMzLTM5Y2QtY2MxOTk5Nzc3ZmYzQG1vbGdlbi5tcGcuZGUvCgpJZiB5b3Ugd2FudCBt
ZSB0byB0ZXN0IFYzIG9mIHlvdXIgcGF0Y2gsIHBsZWFzZSBwdXQgbWUgaW4gdGhlIGNjLgoKQmVz
dAogICBEb25hbGQKCj4+IFNpZ25lZC1vZmYtYnk6IEd1b3FpbmcgSmlhbmcgPGd1b3Fpbmcuamlh
bmdAY2xvdWQuaW9ub3MuY29tPgo+PiAtLS0KPj4gVjI6Cj4+IDEuIGFkZCBvbmUgcGFyYW1ldGVy
IHRvIG1kX3JlYXBfc3luY190aHJlYWQgcGVyIEphY2sncyBzdWdnZXN0aW9uLgo+Pgo+PiDCoCBk
cml2ZXJzL21kL2RtLXJhaWQuYyB8wqAgMiArLQo+PiDCoCBkcml2ZXJzL21kL21kLmPCoMKgwqDC
oMKgIHwgMTQgKysrKysrKysrLS0tLS0KPj4gwqAgZHJpdmVycy9tZC9tZC5owqDCoMKgwqDCoCB8
wqAgMiArLQo+PiDCoCAzIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDcgZGVsZXRp
b25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXJhaWQuYyBiL2RyaXZlcnMv
bWQvZG0tcmFpZC5jCj4+IGluZGV4IGNhYjEyYjIuLjBjNGNiYmEgMTAwNjQ0Cj4+IC0tLSBhL2Ry
aXZlcnMvbWQvZG0tcmFpZC5jCj4+ICsrKyBiL2RyaXZlcnMvbWQvZG0tcmFpZC5jCj4+IEBAIC0z
NjY4LDcgKzM2NjgsNyBAQCBzdGF0aWMgaW50IHJhaWRfbWVzc2FnZShzdHJ1Y3QgZG1fdGFyZ2V0
ICp0aSwgdW5zaWduZWQgaW50IGFyZ2MsIGNoYXIgKiphcmd2LAo+PiDCoMKgwqDCoMKgIGlmICgh
c3RyY2FzZWNtcChhcmd2WzBdLCAiaWRsZSIpIHx8ICFzdHJjYXNlY21wKGFyZ3ZbMF0sICJmcm96
ZW4iKSkgewo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG1kZGV2LT5zeW5jX3RocmVhZCkgewo+
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZXRfYml0KE1EX1JFQ09WRVJZX0lOVFIsICZt
ZGRldi0+cmVjb3ZlcnkpOwo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtZF9yZWFwX3N5bmNf
dGhyZWFkKG1kZGV2KTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWRfcmVhcF9zeW5jX3Ro
cmVhZChtZGRldiwgZmFsc2UpOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+PiDCoMKgwqDCoMKg
IH0gZWxzZSBpZiAoZGVjaXBoZXJfc3luY19hY3Rpb24obWRkZXYsIG1kZGV2LT5yZWNvdmVyeSkg
IT0gc3RfaWRsZSkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUJVU1k7Cj4+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMKPj4gaW5kZXggY2E0MDk0
Mi4uMGMxMmI3ZiAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9tZC9tZC5jCj4+ICsrKyBiL2RyaXZl
cnMvbWQvbWQuYwo+PiBAQCAtNDg1Nyw3ICs0ODU3LDcgQEAgYWN0aW9uX3N0b3JlKHN0cnVjdCBt
ZGRldiAqbWRkZXYsIGNvbnN0IGNoYXIgKnBhZ2UsIHNpemVfdCBsZW4pCj4+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZmx1c2hfd29ya3F1ZXVlKG1kX21pc2Nfd3EpOwo+PiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAobWRkZXYtPnN5bmNfdGhyZWFkKSB7Cj4+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2V0X2JpdChNRF9SRUNPVkVSWV9JTlRS
LCAmbWRkZXYtPnJlY292ZXJ5KTsKPj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBt
ZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2KTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2LCB0cnVlKTsKPj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgfQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtZGRldl91bmxvY2so
bWRkZXYpOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+PiBAQCAtNjIzNCw3ICs2MjM0LDcgQEAg
c3RhdGljIHZvaWQgX19tZF9zdG9wX3dyaXRlcyhzdHJ1Y3QgbWRkZXYgKm1kZGV2KQo+PiDCoMKg
wqDCoMKgwqDCoMKgwqAgZmx1c2hfd29ya3F1ZXVlKG1kX21pc2Nfd3EpOwo+PiDCoMKgwqDCoMKg
IGlmIChtZGRldi0+c3luY190aHJlYWQpIHsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIHNldF9iaXQo
TURfUkVDT1ZFUllfSU5UUiwgJm1kZGV2LT5yZWNvdmVyeSk7Cj4+IC3CoMKgwqDCoMKgwqDCoCBt
ZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2KTsKPj4gK8KgwqDCoMKgwqDCoMKgIG1kX3JlYXBfc3lu
Y190aHJlYWQobWRkZXYsIHRydWUpOwo+PiDCoMKgwqDCoMKgIH0KPj4gwqDCoMKgwqDCoCBkZWxf
dGltZXJfc3luYygmbWRkZXYtPnNhZmVtb2RlX3RpbWVyKTsKPj4gQEAgLTkyNTYsNyArOTI1Niw3
IEBAIHZvaWQgbWRfY2hlY2tfcmVjb3Zlcnkoc3RydWN0IG1kZGV2ICptZGRldikKPj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIC0+c3BhcmVfYWN0aXZlIGFuZCBjbGVhciBzYXZlZF9y
YWlkX2Rpc2sKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+PiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBzZXRfYml0KE1EX1JFQ09WRVJZX0lOVFIsICZtZGRldi0+cmVjb3Zl
cnkpOwo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2
KTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWRfcmVhcF9zeW5jX3RocmVhZChtZGRldiwg
dHJ1ZSk7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNsZWFyX2JpdChNRF9SRUNPVkVS
WV9SRUNPVkVSLCAmbWRkZXYtPnJlY292ZXJ5KTsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgY2xlYXJfYml0KE1EX1JFQ09WRVJZX05FRURFRCwgJm1kZGV2LT5yZWNvdmVyeSk7Cj4+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNsZWFyX2JpdChNRF9TQl9DSEFOR0VfUEVORElORywg
Jm1kZGV2LT5zYl9mbGFncyk7Cj4+IEBAIC05MjkxLDcgKzkyOTEsNyBAQCB2b2lkIG1kX2NoZWNr
X3JlY292ZXJ5KHN0cnVjdCBtZGRldiAqbWRkZXYpCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGdvdG8gdW5sb2NrOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+PiDCoMKgwqDCoMKgwqDC
oMKgwqAgaWYgKG1kZGV2LT5zeW5jX3RocmVhZCkgewo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2KTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
bWRfcmVhcF9zeW5jX3RocmVhZChtZGRldiwgdHJ1ZSk7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGdvdG8gdW5sb2NrOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+PiDCoMKgwqDCoMKg
wqDCoMKgwqAgLyogU2V0IFJVTk5JTkcgYmVmb3JlIGNsZWFyaW5nIE5FRURFRCB0byBhdm9pZAo+
PiBAQCAtOTM2NCwxNCArOTM2NCwxOCBAQCB2b2lkIG1kX2NoZWNrX3JlY292ZXJ5KHN0cnVjdCBt
ZGRldiAqbWRkZXYpCj4+IMKgIH0KPj4gwqAgRVhQT1JUX1NZTUJPTChtZF9jaGVja19yZWNvdmVy
eSk7Cj4+IC12b2lkIG1kX3JlYXBfc3luY190aHJlYWQoc3RydWN0IG1kZGV2ICptZGRldikKPj4g
K3ZvaWQgbWRfcmVhcF9zeW5jX3RocmVhZChzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBib29sIHJlY29u
ZmlnX211dGV4X2hlbGQpCj4+IMKgIHsKPj4gwqDCoMKgwqDCoCBzdHJ1Y3QgbWRfcmRldiAqcmRl
djsKPj4gwqDCoMKgwqDCoCBzZWN0b3JfdCBvbGRfZGV2X3NlY3RvcnMgPSBtZGRldi0+ZGV2X3Nl
Y3RvcnM7Cj4+IMKgwqDCoMKgwqAgYm9vbCBpc19yZXNoYXBlZCA9IGZhbHNlOwo+PiDCoMKgwqDC
oMKgIC8qIHJlc3luYyBoYXMgZmluaXNoZWQsIGNvbGxlY3QgcmVzdWx0ICovCj4+ICvCoMKgwqAg
aWYgKHJlY29uZmlnX211dGV4X2hlbGQpCj4+ICvCoMKgwqDCoMKgwqDCoCBtZGRldl91bmxvY2so
bWRkZXYpOwo+PiDCoMKgwqDCoMKgIG1kX3VucmVnaXN0ZXJfdGhyZWFkKCZtZGRldi0+c3luY190
aHJlYWQpOwo+PiArwqDCoMKgIGlmIChyZWNvbmZpZ19tdXRleF9oZWxkKQo+PiArwqDCoMKgwqDC
oMKgwqAgbWRkZXZfbG9ja19ub2ludHIobWRkZXYpOwo+PiDCoMKgwqDCoMKgIGlmICghdGVzdF9i
aXQoTURfUkVDT1ZFUllfSU5UUiwgJm1kZGV2LT5yZWNvdmVyeSkgJiYKPj4gwqDCoMKgwqDCoMKg
wqDCoMKgICF0ZXN0X2JpdChNRF9SRUNPVkVSWV9SRVFVRVNURUQsICZtZGRldi0+cmVjb3Zlcnkp
ICYmCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBtZGRldi0+ZGVncmFkZWQgIT0gbWRkZXYtPnJhaWRf
ZGlza3MpIHsKPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvbWQuaCBiL2RyaXZlcnMvbWQvbWQu
aAo+PiBpbmRleCAzNDA3MGFiLi43YWUzZDk4IDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL21kL21k
LmgKPj4gKysrIGIvZHJpdmVycy9tZC9tZC5oCj4+IEBAIC03MDUsNyArNzA1LDcgQEAgZXh0ZXJu
IHN0cnVjdCBtZF90aHJlYWQgKm1kX3JlZ2lzdGVyX3RocmVhZCgKPj4gwqAgZXh0ZXJuIHZvaWQg
bWRfdW5yZWdpc3Rlcl90aHJlYWQoc3RydWN0IG1kX3RocmVhZCAqKnRocmVhZHApOwo+PiDCoCBl
eHRlcm4gdm9pZCBtZF93YWtldXBfdGhyZWFkKHN0cnVjdCBtZF90aHJlYWQgKnRocmVhZCk7Cj4+
IMKgIGV4dGVybiB2b2lkIG1kX2NoZWNrX3JlY292ZXJ5KHN0cnVjdCBtZGRldiAqbWRkZXYpOwo+
PiAtZXh0ZXJuIHZvaWQgbWRfcmVhcF9zeW5jX3RocmVhZChzdHJ1Y3QgbWRkZXYgKm1kZGV2KTsK
Pj4gK2V4dGVybiB2b2lkIG1kX3JlYXBfc3luY190aHJlYWQoc3RydWN0IG1kZGV2ICptZGRldiwg
Ym9vbCByZWNvbmZpZ19tdXRleF9oZWxkKTsKPj4gwqAgZXh0ZXJuIGludCBtZGRldl9pbml0X3dy
aXRlc19wZW5kaW5nKHN0cnVjdCBtZGRldiAqbWRkZXYpOwo+PiDCoCBleHRlcm4gYm9vbCBtZF93
cml0ZV9zdGFydChzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBzdHJ1Y3QgYmlvICpiaSk7Cj4+IMKgIGV4
dGVybiB2b2lkIG1kX3dyaXRlX2luYyhzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBzdHJ1Y3QgYmlvICpi
aSk7Cj4+CgotLSAKRG9uYWxkIEJ1Y3plawpidWN6ZWtAbW9sZ2VuLm1wZy5kZQpUZWw6ICs0OSAz
MCA4NDEzIDE0MzMKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

