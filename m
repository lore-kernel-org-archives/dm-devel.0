Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 050BDC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 10 Dec 2021 07:58:43 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-598-f6ue6MDTNkiXl63YGVYoTA-1; Fri, 10 Dec 2021 02:58:39 -0500
X-MC-Unique: f6ue6MDTNkiXl63YGVYoTA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A547801962;
	Fri, 10 Dec 2021 07:58:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 534EA5D6CF;
	Fri, 10 Dec 2021 07:58:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D827E4BB7C;
	Fri, 10 Dec 2021 07:58:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B9D1GAs022266 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 9 Dec 2021 08:01:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F1ADEC01784; Thu,  9 Dec 2021 13:01:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED901C08095
	for <dm-devel@redhat.com>; Thu,  9 Dec 2021 13:01:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC451811E78
	for <dm-devel@redhat.com>; Thu,  9 Dec 2021 13:01:15 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-138-KMDVcN8bPgG8bikFbKpnBA-1; Thu, 09 Dec 2021 08:01:11 -0500
X-MC-Unique: KMDVcN8bPgG8bikFbKpnBA-1
Received: from [192.168.0.175] (ip5f5aed0f.dynamic.kabel-deutschland.de
	[95.90.237.15])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest
	SHA256) (No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 139F561E5FE00;
	Thu,  9 Dec 2021 13:54:39 +0100 (CET)
To: Paul Menzel <pmenzel@molgen.mpg.de>,
	Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, song@kernel.org
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
From: Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <36efcb65-71ba-0c80-2a8e-a1ff27957645@molgen.mpg.de>
Date: Thu, 9 Dec 2021 13:54:38 +0100
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B9D1GAs022266
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTUuMDIuMjEgMTI6MDcsIFBhdWwgTWVuemVsIHdyb3RlOgo+IFsrY2MgRG9uYWxkXQo+IAo+
IEFtIDEzLjAyLjIxIHVtIDAxOjQ5IHNjaHJpZWIgR3VvcWluZyBKaWFuZzoKPj4gVW5yZWdpc3Rl
ciBzeW5jX3RocmVhZCBkb2Vzbid0IG5lZWQgdG8gaG9sZCByZWNvbmZpZ19tdXRleCBzaW5jZSBp
dAo+PiBkb2Vzbid0IHJlY29uZmlndXJlIGFycmF5Lgo+Pgo+PiBBbmQgaXQgY291bGQgY2F1c2Ug
ZGVhZGxvY2sgcHJvYmxlbSBmb3IgcmFpZDUgYXMgZm9sbG93czoKPj4KPj4gMS4gcHJvY2VzcyBB
IHRyaWVkIHRvIHJlYXAgc3luYyB0aHJlYWQgd2l0aCByZWNvbmZpZ19tdXRleCBoZWxkIGFmdGVy
IGVjaG8KPj4gwqDCoMKgIGlkbGUgdG8gc3luY19hY3Rpb24uCj4+IDIuIHJhaWQ1IHN5bmMgdGhy
ZWFkIHdhcyBibG9ja2VkIGlmIHRoZXJlIHdlcmUgdG9vIG1hbnkgYWN0aXZlIHN0cmlwZXMuCj4+
IDMuIFNCX0NIQU5HRV9QRU5ESU5HIHdhcyBzZXQgKGJlY2F1c2Ugb2Ygd3JpdGUgSU8gY29tZXMg
ZnJvbSB1cHBlciBsYXllcikKPj4gwqDCoMKgIHdoaWNoIGNhdXNlcyB0aGUgbnVtYmVyIG9mIGFj
dGl2ZSBzdHJpcGVzIGNhbid0IGJlIGRlY3JlYXNlZC4KPj4gNC4gU0JfQ0hBTkdFX1BFTkRJTkcg
Y2FuJ3QgYmUgY2xlYXJlZCBzaW5jZSBtZF9jaGVja19yZWNvdmVyeSB3YXMgbm90IGFibGUKPj4g
wqDCoMKgIHRvIGhvbGQgcmVjb25maWdfbXV0ZXguCj4+Cj4+IE1vcmUgZGV0YWlscyBpbiB0aGUg
bGluazoKPj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtcmFpZC81ZWQ1NGZmYy1jZTgy
LWJmNjYtNGVmZi0zOTBjYjIzYmMxYWNAbW9sZ2VuLm1wZy5kZS9ULyN0Cj4+Cj4+IEFuZCBhZGQg
b25lIHBhcmFtZXRlciB0byBtZF9yZWFwX3N5bmNfdGhyZWFkIHNpbmNlIGl0IGNvdWxkIGJlIGNh
bGxlZCBieQo+PiBkbS1yYWlkIHdoaWNoIGRvZXNuJ3QgaG9sZCByZWNvbmZpZ19tdXRleC4KPj4K
Pj4gUmVwb3J0ZWQtYW5kLXRlc3RlZC1ieTogRG9uYWxkIEJ1Y3playA8YnVjemVrQG1vbGdlbi5t
cGcuZGU+CgpUaGFua3MsIFBhdWwsIGZvciBwdXR0aW5nIG1lIGludG8gdGhlIGNjLgoKR3VvcWlu
ZywgSSBkb24ndCB0aGluaywgSSd2ZSB0ZXN0ZWQgdGhpcyBwYXRjaC4gUGxlYXNlIHJlbW92ZSB0
aGUgdGVzdGVkLWJ5LgoKYnR3OiBXZSBoYXZlIHRoZSBmaXggSSBzdWdnZXN0ZWQgWzFdIHJ1bm5p
bmcgb24gNTkgcHJvZHVjdGlvbiByYWlkNiBzZXRzIHdpdGggMTYgZGlzayBlYWNoIHdpdGggdmFy
aW91cyBsb2FkcyBhbmQgd2l0aCBtb250aGx5IG1kY2hlY2sgKHBhdXNlZCBkdXJpbmcgZGF5dGlt
ZSwgc28gYSBmZXcgdHJhbnNpdGlvbnMgZWFjaCBtb250aCkgb24gc2V2ZXJhbCBrZXJuZWwgdmVy
c2lvbnMgcnVubmluZyBmb3IgbmVhcmx5IGEgeWVhciBub3cuIE1hbnkgbW9yZSB0cmFuc2l0aW9u
cyBkdXJpbmcgdGVzdGluZy4gVGhhdCBkb2Vzbid0IG1lYW4gdGhlIGZpeCBpcyBjb3JyZWN0LCBv
ZiBjb3Vyc2UuIFRoZSBjb25maWd1cmF0aW9ucyBvZiBvdXIgc3lzdGVtcyBhcmUgYWxtb3N0IGlk
ZW50aWNhbCBhbmQgd2UgZG9uJ3QgZG8gc3VzcGVuZCBvciBhbnl0aGluZy4gQnV0IG1heWJlIHlv
dSBtaWdodCB3YW50IHRvIHJlY29uc2lkZXIuCgpbMV06IGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2xpbnV4LXJhaWQvYmMzNDJkZTAtOThkMi0xNzMzLTM5Y2QtY2MxOTk5Nzc3ZmYzQG1vbGdlbi5t
cGcuZGUvCgpJZiB5b3Ugd2FudCBtZSB0byB0ZXN0IFYzIG9mIHlvdXIgcGF0Y2gsIHBsZWFzZSBw
dXQgbWUgaW4gdGhlIGNjLgoKQmVzdAogICBEb25hbGQKCj4+IFNpZ25lZC1vZmYtYnk6IEd1b3Fp
bmcgSmlhbmcgPGd1b3FpbmcuamlhbmdAY2xvdWQuaW9ub3MuY29tPgo+PiAtLS0KPj4gVjI6Cj4+
IDEuIGFkZCBvbmUgcGFyYW1ldGVyIHRvIG1kX3JlYXBfc3luY190aHJlYWQgcGVyIEphY2sncyBz
dWdnZXN0aW9uLgo+Pgo+PiDCoCBkcml2ZXJzL21kL2RtLXJhaWQuYyB8wqAgMiArLQo+PiDCoCBk
cml2ZXJzL21kL21kLmPCoMKgwqDCoMKgIHwgMTQgKysrKysrKysrLS0tLS0KPj4gwqAgZHJpdmVy
cy9tZC9tZC5owqDCoMKgwqDCoCB8wqAgMiArLQo+PiDCoCAzIGZpbGVzIGNoYW5nZWQsIDExIGlu
c2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L2RtLXJhaWQuYyBiL2RyaXZlcnMvbWQvZG0tcmFpZC5jCj4+IGluZGV4IGNhYjEyYjIuLjBjNGNi
YmEgMTAwNjQ0Cj4+IC0tLSBhL2RyaXZlcnMvbWQvZG0tcmFpZC5jCj4+ICsrKyBiL2RyaXZlcnMv
bWQvZG0tcmFpZC5jCj4+IEBAIC0zNjY4LDcgKzM2NjgsNyBAQCBzdGF0aWMgaW50IHJhaWRfbWVz
c2FnZShzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgdW5zaWduZWQgaW50IGFyZ2MsIGNoYXIgKiphcmd2
LAo+PiDCoMKgwqDCoMKgIGlmICghc3RyY2FzZWNtcChhcmd2WzBdLCAiaWRsZSIpIHx8ICFzdHJj
YXNlY21wKGFyZ3ZbMF0sICJmcm96ZW4iKSkgewo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG1k
ZGV2LT5zeW5jX3RocmVhZCkgewo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZXRfYml0
KE1EX1JFQ09WRVJZX0lOVFIsICZtZGRldi0+cmVjb3ZlcnkpOwo+PiAtwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2KTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgbWRfcmVhcF9zeW5jX3RocmVhZChtZGRldiwgZmFsc2UpOwo+PiDCoMKgwqDCoMKgwqDC
oMKgwqAgfQo+PiDCoMKgwqDCoMKgIH0gZWxzZSBpZiAoZGVjaXBoZXJfc3luY19hY3Rpb24obWRk
ZXYsIG1kZGV2LT5yZWNvdmVyeSkgIT0gc3RfaWRsZSkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIHJl
dHVybiAtRUJVU1k7Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21k
L21kLmMKPj4gaW5kZXggY2E0MDk0Mi4uMGMxMmI3ZiAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9t
ZC9tZC5jCj4+ICsrKyBiL2RyaXZlcnMvbWQvbWQuYwo+PiBAQCAtNDg1Nyw3ICs0ODU3LDcgQEAg
YWN0aW9uX3N0b3JlKHN0cnVjdCBtZGRldiAqbWRkZXYsIGNvbnN0IGNoYXIgKnBhZ2UsIHNpemVf
dCBsZW4pCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZmx1c2hfd29ya3F1
ZXVlKG1kX21pc2Nfd3EpOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAobWRkZXYt
PnN5bmNfdGhyZWFkKSB7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2V0
X2JpdChNRF9SRUNPVkVSWV9JTlRSLCAmbWRkZXYtPnJlY292ZXJ5KTsKPj4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2KTsKPj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2LCB0cnVl
KTsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBtZGRldl91bmxvY2sobWRkZXYpOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+PiBA
QCAtNjIzNCw3ICs2MjM0LDcgQEAgc3RhdGljIHZvaWQgX19tZF9zdG9wX3dyaXRlcyhzdHJ1Y3Qg
bWRkZXYgKm1kZGV2KQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgZmx1c2hfd29ya3F1ZXVlKG1kX21p
c2Nfd3EpOwo+PiDCoMKgwqDCoMKgIGlmIChtZGRldi0+c3luY190aHJlYWQpIHsKPj4gwqDCoMKg
wqDCoMKgwqDCoMKgIHNldF9iaXQoTURfUkVDT1ZFUllfSU5UUiwgJm1kZGV2LT5yZWNvdmVyeSk7
Cj4+IC3CoMKgwqDCoMKgwqDCoCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2KTsKPj4gK8KgwqDC
oMKgwqDCoMKgIG1kX3JlYXBfc3luY190aHJlYWQobWRkZXYsIHRydWUpOwo+PiDCoMKgwqDCoMKg
IH0KPj4gwqDCoMKgwqDCoCBkZWxfdGltZXJfc3luYygmbWRkZXYtPnNhZmVtb2RlX3RpbWVyKTsK
Pj4gQEAgLTkyNTYsNyArOTI1Niw3IEBAIHZvaWQgbWRfY2hlY2tfcmVjb3Zlcnkoc3RydWN0IG1k
ZGV2ICptZGRldikKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIC0+c3BhcmVfYWN0
aXZlIGFuZCBjbGVhciBzYXZlZF9yYWlkX2Rpc2sKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAqLwo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZXRfYml0KE1EX1JFQ09WRVJZ
X0lOVFIsICZtZGRldi0+cmVjb3ZlcnkpOwo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtZF9y
ZWFwX3N5bmNfdGhyZWFkKG1kZGV2KTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWRfcmVh
cF9zeW5jX3RocmVhZChtZGRldiwgdHJ1ZSk7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGNsZWFyX2JpdChNRF9SRUNPVkVSWV9SRUNPVkVSLCAmbWRkZXYtPnJlY292ZXJ5KTsKPj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY2xlYXJfYml0KE1EX1JFQ09WRVJZX05FRURFRCwgJm1k
ZGV2LT5yZWNvdmVyeSk7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNsZWFyX2JpdChN
RF9TQl9DSEFOR0VfUEVORElORywgJm1kZGV2LT5zYl9mbGFncyk7Cj4+IEBAIC05MjkxLDcgKzky
OTEsNyBAQCB2b2lkIG1kX2NoZWNrX3JlY292ZXJ5KHN0cnVjdCBtZGRldiAqbWRkZXYpCj4+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gdW5sb2NrOwo+PiDCoMKgwqDCoMKgwqDCoMKg
wqAgfQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG1kZGV2LT5zeW5jX3RocmVhZCkgewo+PiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2KTsKPj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgbWRfcmVhcF9zeW5jX3RocmVhZChtZGRldiwgdHJ1ZSk7Cj4+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gdW5sb2NrOwo+PiDCoMKgwqDCoMKgwqDC
oMKgwqAgfQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgLyogU2V0IFJVTk5JTkcgYmVmb3JlIGNsZWFy
aW5nIE5FRURFRCB0byBhdm9pZAo+PiBAQCAtOTM2NCwxNCArOTM2NCwxOCBAQCB2b2lkIG1kX2No
ZWNrX3JlY292ZXJ5KHN0cnVjdCBtZGRldiAqbWRkZXYpCj4+IMKgIH0KPj4gwqAgRVhQT1JUX1NZ
TUJPTChtZF9jaGVja19yZWNvdmVyeSk7Cj4+IC12b2lkIG1kX3JlYXBfc3luY190aHJlYWQoc3Ry
dWN0IG1kZGV2ICptZGRldikKPj4gK3ZvaWQgbWRfcmVhcF9zeW5jX3RocmVhZChzdHJ1Y3QgbWRk
ZXYgKm1kZGV2LCBib29sIHJlY29uZmlnX211dGV4X2hlbGQpCj4+IMKgIHsKPj4gwqDCoMKgwqDC
oCBzdHJ1Y3QgbWRfcmRldiAqcmRldjsKPj4gwqDCoMKgwqDCoCBzZWN0b3JfdCBvbGRfZGV2X3Nl
Y3RvcnMgPSBtZGRldi0+ZGV2X3NlY3RvcnM7Cj4+IMKgwqDCoMKgwqAgYm9vbCBpc19yZXNoYXBl
ZCA9IGZhbHNlOwo+PiDCoMKgwqDCoMKgIC8qIHJlc3luYyBoYXMgZmluaXNoZWQsIGNvbGxlY3Qg
cmVzdWx0ICovCj4+ICvCoMKgwqAgaWYgKHJlY29uZmlnX211dGV4X2hlbGQpCj4+ICvCoMKgwqDC
oMKgwqDCoCBtZGRldl91bmxvY2sobWRkZXYpOwo+PiDCoMKgwqDCoMKgIG1kX3VucmVnaXN0ZXJf
dGhyZWFkKCZtZGRldi0+c3luY190aHJlYWQpOwo+PiArwqDCoMKgIGlmIChyZWNvbmZpZ19tdXRl
eF9oZWxkKQo+PiArwqDCoMKgwqDCoMKgwqAgbWRkZXZfbG9ja19ub2ludHIobWRkZXYpOwo+PiDC
oMKgwqDCoMKgIGlmICghdGVzdF9iaXQoTURfUkVDT1ZFUllfSU5UUiwgJm1kZGV2LT5yZWNvdmVy
eSkgJiYKPj4gwqDCoMKgwqDCoMKgwqDCoMKgICF0ZXN0X2JpdChNRF9SRUNPVkVSWV9SRVFVRVNU
RUQsICZtZGRldi0+cmVjb3ZlcnkpICYmCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBtZGRldi0+ZGVn
cmFkZWQgIT0gbWRkZXYtPnJhaWRfZGlza3MpIHsKPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQv
bWQuaCBiL2RyaXZlcnMvbWQvbWQuaAo+PiBpbmRleCAzNDA3MGFiLi43YWUzZDk4IDEwMDY0NAo+
PiAtLS0gYS9kcml2ZXJzL21kL21kLmgKPj4gKysrIGIvZHJpdmVycy9tZC9tZC5oCj4+IEBAIC03
MDUsNyArNzA1LDcgQEAgZXh0ZXJuIHN0cnVjdCBtZF90aHJlYWQgKm1kX3JlZ2lzdGVyX3RocmVh
ZCgKPj4gwqAgZXh0ZXJuIHZvaWQgbWRfdW5yZWdpc3Rlcl90aHJlYWQoc3RydWN0IG1kX3RocmVh
ZCAqKnRocmVhZHApOwo+PiDCoCBleHRlcm4gdm9pZCBtZF93YWtldXBfdGhyZWFkKHN0cnVjdCBt
ZF90aHJlYWQgKnRocmVhZCk7Cj4+IMKgIGV4dGVybiB2b2lkIG1kX2NoZWNrX3JlY292ZXJ5KHN0
cnVjdCBtZGRldiAqbWRkZXYpOwo+PiAtZXh0ZXJuIHZvaWQgbWRfcmVhcF9zeW5jX3RocmVhZChz
dHJ1Y3QgbWRkZXYgKm1kZGV2KTsKPj4gK2V4dGVybiB2b2lkIG1kX3JlYXBfc3luY190aHJlYWQo
c3RydWN0IG1kZGV2ICptZGRldiwgYm9vbCByZWNvbmZpZ19tdXRleF9oZWxkKTsKPj4gwqAgZXh0
ZXJuIGludCBtZGRldl9pbml0X3dyaXRlc19wZW5kaW5nKHN0cnVjdCBtZGRldiAqbWRkZXYpOwo+
PiDCoCBleHRlcm4gYm9vbCBtZF93cml0ZV9zdGFydChzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBzdHJ1
Y3QgYmlvICpiaSk7Cj4+IMKgIGV4dGVybiB2b2lkIG1kX3dyaXRlX2luYyhzdHJ1Y3QgbWRkZXYg
Km1kZGV2LCBzdHJ1Y3QgYmlvICpiaSk7Cj4+CgotLSAKRG9uYWxkIEJ1Y3plawpidWN6ZWtAbW9s
Z2VuLm1wZy5kZQpUZWw6ICs0OSAzMCA4NDEzIDE0MzMKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVs

