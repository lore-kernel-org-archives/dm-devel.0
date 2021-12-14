Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB846C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 15 Dec 2021 06:28:41 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-Po5BrdmvMMuRcmKyYmrLaQ-1; Wed, 15 Dec 2021 01:28:37 -0500
X-MC-Unique: Po5BrdmvMMuRcmKyYmrLaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 477B1100C610;
	Wed, 15 Dec 2021 06:28:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C84E5798AC;
	Wed, 15 Dec 2021 06:28:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EDED04BB7C;
	Wed, 15 Dec 2021 06:28:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BECLgkc027884 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 14 Dec 2021 07:21:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6A276400E127; Tue, 14 Dec 2021 12:21:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 651CB40D1B98
	for <dm-devel@redhat.com>; Tue, 14 Dec 2021 12:21:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CC16805BFC
	for <dm-devel@redhat.com>; Tue, 14 Dec 2021 12:21:42 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-84-Fy_xjiqnMMKB4TS87GRHYw-1; Tue, 14 Dec 2021 07:21:38 -0500
X-MC-Unique: Fy_xjiqnMMKB4TS87GRHYw-1
Received: from [192.168.0.175] (ip5f5aed0f.dynamic.kabel-deutschland.de
	[95.90.237.15])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest
	SHA256) (No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id AC5EB61EA1923;
	Tue, 14 Dec 2021 13:21:35 +0100 (CET)
To: Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de>
	<87206712-b066-9d1d-3e46-14338e704c1a@linux.dev>
	<75958549-03d4-e396-e761-9956c4b2f991@molgen.mpg.de>
	<2ed2d0ba-14e9-f708-265e-8fc64902bd93@linux.dev>
From: Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <c270e560-3d92-f05e-26a7-86523a79f1d8@molgen.mpg.de>
Date: Tue, 14 Dec 2021 13:21:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2ed2d0ba-14e9-f708-265e-8fc64902bd93@linux.dev>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BECLgkc027884
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 15 Dec 2021 01:28:27 -0500
Cc: linux-raid@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
	dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTQuMTIuMjEgMTE6MDMsIEd1b3FpbmcgSmlhbmcgd3JvdGU6Cj4gCj4gCj4gT24gMTIvMTQv
MjEgNTozMSBQTSwgRG9uYWxkIEJ1Y3playB3cm90ZToKPiAKPj4+Pj4gwqAgLXZvaWQgbWRfcmVh
cF9zeW5jX3RocmVhZChzdHJ1Y3QgbWRkZXYgKm1kZGV2KQo+Pj4+PiArdm9pZCBtZF9yZWFwX3N5
bmNfdGhyZWFkKHN0cnVjdCBtZGRldiAqbWRkZXYsIGJvb2wgcmVjb25maWdfbXV0ZXhfaGVsZCkK
Pj4+Pj4gwqAgewo+Pj4+PiDCoMKgwqDCoMKgIHN0cnVjdCBtZF9yZGV2ICpyZGV2Owo+Pj4+PiDC
oMKgwqDCoMKgIHNlY3Rvcl90IG9sZF9kZXZfc2VjdG9ycyA9IG1kZGV2LT5kZXZfc2VjdG9yczsK
Pj4+Pj4gwqDCoMKgwqDCoCBib29sIGlzX3Jlc2hhcGVkID0gZmFsc2U7Cj4+Pj4+IMKgIMKgwqDC
oMKgwqAgLyogcmVzeW5jIGhhcyBmaW5pc2hlZCwgY29sbGVjdCByZXN1bHQgKi8KPj4+Pj4gK8Kg
wqDCoCBpZiAocmVjb25maWdfbXV0ZXhfaGVsZCkKPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIG1kZGV2
X3VubG9jayhtZGRldik7Cj4+Pj4KPj4+Pgo+Pj4+IElmIG9uZSB0aHJlYWQgZ290IGhlcmUsIGUu
Zy4gdmlhIGFjdGlvbl9zdG9yZSggLyogImlkbGUiICovICksIG5vdyB0aGF0IHRoZSBtdXRleCBp
cyB1bmxvY2tlZCwgaXMgdGhlcmUgYW55dGhpbmcgd2hpY2ggd291bGQgcHJldmVudCBhbm90aGVy
IHRocmVhZCBnZXR0aW5nwqAgaGVyZSBhcyB3ZWxsLCBlLmcuIHZpYSB0aGUgc2FtZSBwYXRoPwo+
Pj4+Cj4+Pj4gSWYgbm90LCB0aGV5IGJvdGggbWlnaHQgY2FsbAo+Pj4+Cj4+Pj4+IG1kX3VucmVn
aXN0ZXJfdGhyZWFkKCZtZGRldi0+c3luY190aHJlYWQpOwo+Pj4+Cj4+Pj4gV2hpY2ggaXMgbm90
IHJlZW50cmFudDoKPj4+Pgo+Pj4+IHZvaWQgbWRfdW5yZWdpc3Rlcl90aHJlYWQoc3RydWN0IG1k
X3RocmVhZCAqKnRocmVhZHApCj4+Pj4gewo+Pj4+IMKgwqDCoMKgc3RydWN0IG1kX3RocmVhZCAq
dGhyZWFkID0gKnRocmVhZHA7Cj4+Pj4gwqDCoMKgwqBpZiAoIXRocmVhZCkKPj4+PiDCoMKgwqDC
oMKgwqDCoCByZXR1cm47Cj4+Pj4gwqDCoMKgwqBwcl9kZWJ1ZygiaW50ZXJydXB0aW5nIE1ELXRo
cmVhZCBwaWQgJWRcbiIsIHRhc2tfcGlkX25yKHRocmVhZC0+dHNrKSk7Cj4+Pj4gwqDCoMKgwqAv
KiBMb2NraW5nIGVuc3VyZXMgdGhhdCBtZGRldl91bmxvY2sgZG9lcyBub3Qgd2FrZV91cCBhCj4+
Pj4gwqDCoMKgwqAgKiBub24tZXhpc3RlbnQgdGhyZWFkCj4+Pj4gwqDCoMKgwqAgKi8KPj4+PiDC
oMKgwqDCoHNwaW5fbG9jaygmcGVyc19sb2NrKTsKPj4+PiDCoMKgwqDCoCp0aHJlYWRwID0gTlVM
TDsKPj4+PiDCoMKgwqDCoHNwaW5fdW5sb2NrKCZwZXJzX2xvY2spOwo+Pj4+Cj4+Pj4gwqDCoMKg
wqBrdGhyZWFkX3N0b3AodGhyZWFkLT50c2spOwo+Pj4+IMKgwqDCoMKga2ZyZWUodGhyZWFkKTsK
Pj4+PiB9Cj4+Pj4KPj4+PiBUaGlzIG1pZ2h0IGJlIGEgcHJlZXhpc3RpbmcgcHJvYmxlbSwgYmVj
YXVzZSB0aGUgY2FsbCBzaXRlIGluIGRtLXJhaWQuYywgd2hpY2ggeW91IHVwZGF0ZWQgdG8gYG1k
X3JlYXBfc3luY190aHJlYWQobWRkZXYsIGZhbHNlKTtgLCBkaWRuJ3QgaG9sZCB0aGUgbXV0ZXgg
YW55d2F5Lgo+Pj4+Cj4+Pj4gQW0gSSBtaXNzaW5nIHNvbWV0aGluZz8gUHJvYmFibHksIEkgZG8u
Cj4+Pj4KPj4+PiBPdGhlcndpc2U6IE1vdmUgdGhlIGRlcmVmIG9mIHRocmVhZHAgaW4gbWRfdW5y
ZWdpc3Rlcl90aHJlYWQoKSBpbnRvIHRoZSBzcGlubG9jayBzY29wZT8KPj4+Cj4+PiBHb29kIHBv
aW50LCBJIHRoaW5rIHlvdSBhcmUgcmlnaHQuCj4+Pgo+Pj4gQW5kIGFjdHVhbGx5IHBlcnNfbG9j
ayBkb2VzIGV4dHJhIHNlcnZpY2UgdG8gcHJvdGVjdCBhY2Nlc3NlcyB0byBtZGRldi0+dGhyZWFk
IChJIHRoaW5rIGl0Cj4+PiBhbHNvIHN1aXRhYmxlIGZvciBtZGRldi0+c3luY190aHJlYWQgKSB3
aGVuIHRoZSBtdXRleCBjYW4ndCBiZSBoZWxkLiBDYXJlIHRvIHNlbmQgYSBwYXRjaAo+Pj4gZm9y
IGl0Pwo+Pgo+PiBJJ20gcmVhbGx5IHNvcnJ5LCBidXQgaXQncyBvbmUgdGhpbmcgdG8gcG9pbnQg
dG8gYSBwb3NzaWJsZSBwcm9ibGVtIGFuZCBhbm90aGVyIHRoaW5nIHRvIGNvbWUgdXAgd2l0aCBh
IGNvcnJlY3Qgc29sdXRpb24uCj4gCj4gWWVzLCBpdCBpcyBvZnRlbiB0aGUgcmVhbGl0eSBvZiBs
aWZlLCBhbmQgd2UgY2FuIGFsd2F5cyBjb3JyZWN0IG91cnNlbHZlcyBpZiB0aGVyZSBpcyBwcm9i
bGVtIPCfmI4uCj4gCj4+IFdoaWxlIEkgdGhpbmsgaXQgd291bGQgYmUgZWFzeSB0byBhdm9pZCB0
aGUgZG91YmxlIGZyZWUgd2l0aCB0aGUgc3BpbmxvY2sgKG9yIG1heWJlIGF0b21pYyBSTVcpICwg
d2Ugc3VyZWx5IGRvbid0IHdhbnQgdG8gaG9sZCB0aGUgc3BpbmxvY2sgd2hpbGUgd2UgYXJlIHNs
ZWVwaW5nIGluIGt0aHJlYWRfc3RvcCgpLiBJZiB3ZSBkb24ndCBob2xkIHNvbWUga2luZCBvZiBs
b2NrLCB3aGF0IGFyZSB0aGUgc2lkZSBlZmZlY3RzIG9mIGFub3RoZXIgc3luYyB0aHJlYWQgYmVp
bmcgc3RhcnRlZCBvciBhbnkgb3RoZXIgcmVjb25maWd1cmF0aW9uPyBBcmUgdGhlIGV4aXN0aW5n
IGZsYWdzIGVub3VnaCB0byBwcm90ZWN0IHVzIGZyb20gdGhpcz8gSWYgd2UgZG8gd2FudCB0byBo
b2xkIHRoZSBsb2NrIHdoaWxlIHdhaXRpbmcgZm9yIHRoZSB0aHJlYWQgdG8gdGVybWluYXRlLCBz
aG91bGQgaXQgYmUgbWFkZSBpbnRvIGEgbXV0ZXg/IElmIHNvLCBpdCBwcm9iYWJseSBzaG91bGRu
J3QgYmUgc3RhdGljIGJ1dCBtb3ZlZCBpbnRvIHRoZSBtZGRldiBzdHJ1Y3R1cmUuIEknZCBuZWVk
IHdlZWtzIGlmIG5vdCBtb250aCB0byBmaWd1cmUgdGhhdCBvdXQgYW5kIHRvIGZlZWwgYm9sZCBl
bm91Z2ggdG8gcG9zdCBpdC4KPiAKPiBUaGFua3MgZm9yIGRlZXAgdGhpbmtpbmcgYWJvdXQgaXQs
IEkgdGhpbmsgd2UgY2FuIGF2b2lkIHRvIGNhbGwga3RocmVhZF9zdG9wIHdpdGggc3BpbmxvY2sK
PiBoZWxkLiBNYXliZSBzb21ldGhpbmcgbGlrZSB0aGlzLCBidXQganVzdCBteSByYXcgaWRlYSwg
cGxlYXNlIGhhdmUgYSB0aG9yb3VnaCByZXZpZXcuCj4gCj4gIMKgdm9pZCBtZF91bnJlZ2lzdGVy
X3RocmVhZChzdHJ1Y3QgbWRfdGhyZWFkICoqdGhyZWFkcCkKPiAgwqB7Cj4gLcKgwqDCoMKgwqDC
oCBzdHJ1Y3QgbWRfdGhyZWFkICp0aHJlYWQgPSAqdGhyZWFkcDsKPiAtwqDCoMKgwqDCoMKgIGlm
ICghdGhyZWFkKQo+ICvCoMKgwqDCoMKgwqAgc3RydWN0IG1kX3RocmVhZCAqdGhyZWFkID0gUkVB
RF9PTkNFKCp0aHJlYWRwKTsKCi0gVGhlIGFjY2VzcyB0byAqdGhyZWFkcCBuZWVkcyB0byBiZSBh
ZnRlciB0aGUgc3Bpbl9sb2NrKCkuIE90aGVyd2lzZSB0d28gQ1BVcyBtaWdodCByZWFkIG5vbi1O
VUxMIGhlcmUuCgotIElmIGl0IHdhcyBhZnRlciBzcGluX2xvY2soKSwgSSB0aGluayAoIT0gSSBr
bm93KSwgd2UgZG9uJ3QgbmVlZCB0aGUgUkVBRF9PTkNFLCBiZWNhdXNlIHNwaW5fbG9jaygpIGlt
cGxpZXMgYSBjb21waWxlciBiYXJyaWVyLgoKPiArCj4gK8KgwqDCoMKgwqDCoCBzcGluX2xvY2so
JnBlcnNfbG9jayk7Cj4gK8KgwqDCoMKgwqDCoCBpZiAoIXRocmVhZCkgewo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHNwaW5fdW5sb2NrKCZwZXJzX2xvY2spOwo+ICDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuOwo+ICvCoMKgwqDCoMKgwqAgfQo+ICDCoMKgwqDC
oMKgwqDCoCBwcl9kZWJ1ZygiaW50ZXJydXB0aW5nIE1ELXRocmVhZCBwaWQgJWRcbiIsIHRhc2tf
cGlkX25yKHRocmVhZC0+dHNrKSk7Cj4gIMKgwqDCoMKgwqDCoMKgIC8qIExvY2tpbmcgZW5zdXJl
cyB0aGF0IG1kZGV2X3VubG9jayBkb2VzIG5vdCB3YWtlX3VwIGEKPiAgwqDCoMKgwqDCoMKgwqDC
oCAqIG5vbi1leGlzdGVudCB0aHJlYWQKPiAgwqDCoMKgwqDCoMKgwqDCoCAqLwo+IC3CoMKgwqDC
oMKgwqAgc3Bpbl9sb2NrKCZwZXJzX2xvY2spOwo+ICDCoMKgwqDCoMKgwqDCoCAqdGhyZWFkcCA9
IE5VTEw7Cj4gIMKgwqDCoMKgwqDCoMKgIHNwaW5fdW5sb2NrKCZwZXJzX2xvY2spOwo+IAo+IC3C
oMKgwqDCoMKgwqAga3RocmVhZF9zdG9wKHRocmVhZC0+dHNrKTsKPiArwqDCoMKgwqDCoMKgIGlm
IChJU19FUlJfT1JfTlVMTCh0aHJlYWQtPnRzaykpIHsKCi0gVGVzdCBhY2NpZGVudGFsbHkgbmVn
YXRlZD8gVGhpcyB0ZXN0IGlzIG5ldy4gSXMgdGhpcyBhbiB1bnJlbGF0ZWQgY2hhbmdlPyBBbnl3
YXksIEkgZG9uJ3QgZ2V0IGl0LgoKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrdGhy
ZWFkX3N0b3AodGhyZWFkLT50c2spOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRo
cmVhZC0+dHNrID0gTlVMTDsKCi0gVGhpcyBhc3NpZ25tZW50IGNhbid0IGJlIHJlcXVpcmVkLCBi
ZWNhdXNlIHdlIGFyZSBnb2luZyB0byBrZnJlZSh0aHJlYWQpIGluIHRoZSBuZXh0IGxpbmUuCgo+
ICvCoMKgwqDCoMKgwqAgfQo+ICDCoMKgwqDCoMKgwqDCoCBrZnJlZSh0aHJlYWQpOwo+ICDCoH0K
PiAgwqBFWFBPUlRfU1lNQk9MKG1kX3VucmVnaXN0ZXJfdGhyZWFkKTsKPiAKPj4gSSBkb24ndCB3
YW50IHRvIHB1c2ggd29yayB0byBvdGhlcnMsIGJ1dCBteSBvd24gbXkgdW5kZXJzdGFuZGluZyBv
ZiBtZCBpcyB0byBuYXJyb3cuCj4gCj4gTWUgZWl0aGVyIPCfmIkKPiAKPiBUaGFua3MsCj4gR3Vv
cWluZwoKQmVzdAoKICAgRG9uYWxkCgotLSAKRG9uYWxkIEJ1Y3plawpidWN6ZWtAbW9sZ2VuLm1w
Zy5kZQpUZWw6ICs0OSAzMCA4NDEzIDE0MzMKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVs

