Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0B67C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 14 Dec 2021 10:11:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-npvB7mO7NC6Sgg3rr_5WKA-1; Tue, 14 Dec 2021 05:11:48 -0500
X-MC-Unique: npvB7mO7NC6Sgg3rr_5WKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADC821023F4E;
	Tue, 14 Dec 2021 10:11:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 472B14ABAD;
	Tue, 14 Dec 2021 10:11:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 97C781809CB8;
	Tue, 14 Dec 2021 10:11:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BEABdCj017166 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 14 Dec 2021 05:11:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1A73C2166B26; Tue, 14 Dec 2021 10:11:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 149C82166B25
	for <dm-devel@redhat.com>; Tue, 14 Dec 2021 10:11:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0521E3800E92
	for <dm-devel@redhat.com>; Tue, 14 Dec 2021 10:11:36 +0000 (UTC)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-131-3Gg_KTgSMAaM6l09eDDogg-1; Tue, 14 Dec 2021 05:11:32 -0500
X-MC-Unique: 3Gg_KTgSMAaM6l09eDDogg-1
To: Donald Buczek <buczek@molgen.mpg.de>, song@kernel.org
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de>
	<87206712-b066-9d1d-3e46-14338e704c1a@linux.dev>
	<75958549-03d4-e396-e761-9956c4b2f991@molgen.mpg.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
	include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <2ed2d0ba-14e9-f708-265e-8fc64902bd93@linux.dev>
Date: Tue, 14 Dec 2021 18:03:43 +0800
MIME-Version: 1.0
In-Reply-To: <75958549-03d4-e396-e761-9956c4b2f991@molgen.mpg.de>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BEABdCj017166
X-loop: dm-devel@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAxMi8xNC8yMSA1OjMxIFBNLCBEb25hbGQgQnVjemVrIHdyb3RlOgoKPj4+PiDCoCAtdm9p
ZCBtZF9yZWFwX3N5bmNfdGhyZWFkKHN0cnVjdCBtZGRldiAqbWRkZXYpCj4+Pj4gK3ZvaWQgbWRf
cmVhcF9zeW5jX3RocmVhZChzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBib29sIAo+Pj4+IHJlY29uZmln
X211dGV4X2hlbGQpCj4+Pj4gwqAgewo+Pj4+IMKgwqDCoMKgwqAgc3RydWN0IG1kX3JkZXYgKnJk
ZXY7Cj4+Pj4gwqDCoMKgwqDCoCBzZWN0b3JfdCBvbGRfZGV2X3NlY3RvcnMgPSBtZGRldi0+ZGV2
X3NlY3RvcnM7Cj4+Pj4gwqDCoMKgwqDCoCBib29sIGlzX3Jlc2hhcGVkID0gZmFsc2U7Cj4+Pj4g
wqAgwqDCoMKgwqDCoCAvKiByZXN5bmMgaGFzIGZpbmlzaGVkLCBjb2xsZWN0IHJlc3VsdCAqLwo+
Pj4+ICvCoMKgwqAgaWYgKHJlY29uZmlnX211dGV4X2hlbGQpCj4+Pj4gK8KgwqDCoMKgwqDCoMKg
IG1kZGV2X3VubG9jayhtZGRldik7Cj4+Pgo+Pj4KPj4+IElmIG9uZSB0aHJlYWQgZ290IGhlcmUs
IGUuZy4gdmlhIGFjdGlvbl9zdG9yZSggLyogImlkbGUiICovICksIG5vdyAKPj4+IHRoYXQgdGhl
IG11dGV4IGlzIHVubG9ja2VkLCBpcyB0aGVyZSBhbnl0aGluZyB3aGljaCB3b3VsZCBwcmV2ZW50
IAo+Pj4gYW5vdGhlciB0aHJlYWQgZ2V0dGluZ8KgIGhlcmUgYXMgd2VsbCwgZS5nLiB2aWEgdGhl
IHNhbWUgcGF0aD8KPj4+Cj4+PiBJZiBub3QsIHRoZXkgYm90aCBtaWdodCBjYWxsCj4+Pgo+Pj4+
IG1kX3VucmVnaXN0ZXJfdGhyZWFkKCZtZGRldi0+c3luY190aHJlYWQpOwo+Pj4KPj4+IFdoaWNo
IGlzIG5vdCByZWVudHJhbnQ6Cj4+Pgo+Pj4gdm9pZCBtZF91bnJlZ2lzdGVyX3RocmVhZChzdHJ1
Y3QgbWRfdGhyZWFkICoqdGhyZWFkcCkKPj4+IHsKPj4+IMKgwqDCoMKgc3RydWN0IG1kX3RocmVh
ZCAqdGhyZWFkID0gKnRocmVhZHA7Cj4+PiDCoMKgwqDCoGlmICghdGhyZWFkKQo+Pj4gwqDCoMKg
wqDCoMKgwqAgcmV0dXJuOwo+Pj4gwqDCoMKgwqBwcl9kZWJ1ZygiaW50ZXJydXB0aW5nIE1ELXRo
cmVhZCBwaWQgJWRcbiIsIAo+Pj4gdGFza19waWRfbnIodGhyZWFkLT50c2spKTsKPj4+IMKgwqDC
oMKgLyogTG9ja2luZyBlbnN1cmVzIHRoYXQgbWRkZXZfdW5sb2NrIGRvZXMgbm90IHdha2VfdXAg
YQo+Pj4gwqDCoMKgwqAgKiBub24tZXhpc3RlbnQgdGhyZWFkCj4+PiDCoMKgwqDCoCAqLwo+Pj4g
wqDCoMKgwqBzcGluX2xvY2soJnBlcnNfbG9jayk7Cj4+PiDCoMKgwqDCoCp0aHJlYWRwID0gTlVM
TDsKPj4+IMKgwqDCoMKgc3Bpbl91bmxvY2soJnBlcnNfbG9jayk7Cj4+Pgo+Pj4gwqDCoMKgwqBr
dGhyZWFkX3N0b3AodGhyZWFkLT50c2spOwo+Pj4gwqDCoMKgwqBrZnJlZSh0aHJlYWQpOwo+Pj4g
fQo+Pj4KPj4+IFRoaXMgbWlnaHQgYmUgYSBwcmVleGlzdGluZyBwcm9ibGVtLCBiZWNhdXNlIHRo
ZSBjYWxsIHNpdGUgaW4gCj4+PiBkbS1yYWlkLmMsIHdoaWNoIHlvdSB1cGRhdGVkIHRvIGBtZF9y
ZWFwX3N5bmNfdGhyZWFkKG1kZGV2LCAKPj4+IGZhbHNlKTtgLCBkaWRuJ3QgaG9sZCB0aGUgbXV0
ZXggYW55d2F5Lgo+Pj4KPj4+IEFtIEkgbWlzc2luZyBzb21ldGhpbmc/IFByb2JhYmx5LCBJIGRv
Lgo+Pj4KPj4+IE90aGVyd2lzZTogTW92ZSB0aGUgZGVyZWYgb2YgdGhyZWFkcCBpbiBtZF91bnJl
Z2lzdGVyX3RocmVhZCgpIGludG8gCj4+PiB0aGUgc3BpbmxvY2sgc2NvcGU/Cj4+Cj4+IEdvb2Qg
cG9pbnQsIEkgdGhpbmsgeW91IGFyZSByaWdodC4KPj4KPj4gQW5kIGFjdHVhbGx5IHBlcnNfbG9j
ayBkb2VzIGV4dHJhIHNlcnZpY2UgdG8gcHJvdGVjdCBhY2Nlc3NlcyB0byAKPj4gbWRkZXYtPnRo
cmVhZCAoSSB0aGluayBpdAo+PiBhbHNvIHN1aXRhYmxlIGZvciBtZGRldi0+c3luY190aHJlYWQg
KSB3aGVuIHRoZSBtdXRleCBjYW4ndCBiZSBoZWxkLiAKPj4gQ2FyZSB0byBzZW5kIGEgcGF0Y2gK
Pj4gZm9yIGl0Pwo+Cj4gSSdtIHJlYWxseSBzb3JyeSwgYnV0IGl0J3Mgb25lIHRoaW5nIHRvIHBv
aW50IHRvIGEgcG9zc2libGUgcHJvYmxlbSAKPiBhbmQgYW5vdGhlciB0aGluZyB0byBjb21lIHVw
IHdpdGggYSBjb3JyZWN0IHNvbHV0aW9uLgoKWWVzLCBpdCBpcyBvZnRlbiB0aGUgcmVhbGl0eSBv
ZiBsaWZlLCBhbmQgd2UgY2FuIGFsd2F5cyBjb3JyZWN0IApvdXJzZWx2ZXMgaWYgdGhlcmUgaXMg
cHJvYmxlbSDwn5iOLgoKPiBXaGlsZSBJIHRoaW5rIGl0IHdvdWxkIGJlIGVhc3kgdG8gYXZvaWQg
dGhlIGRvdWJsZSBmcmVlIHdpdGggdGhlIAo+IHNwaW5sb2NrIChvciBtYXliZSBhdG9taWMgUk1X
KSAsIHdlIHN1cmVseSBkb24ndCB3YW50IHRvIGhvbGQgdGhlIAo+IHNwaW5sb2NrIHdoaWxlIHdl
IGFyZSBzbGVlcGluZyBpbiBrdGhyZWFkX3N0b3AoKS4gSWYgd2UgZG9uJ3QgaG9sZCAKPiBzb21l
IGtpbmQgb2YgbG9jaywgd2hhdCBhcmUgdGhlIHNpZGUgZWZmZWN0cyBvZiBhbm90aGVyIHN5bmMg
dGhyZWFkIAo+IGJlaW5nIHN0YXJ0ZWQgb3IgYW55IG90aGVyIHJlY29uZmlndXJhdGlvbj8gQXJl
IHRoZSBleGlzdGluZyBmbGFncyAKPiBlbm91Z2ggdG8gcHJvdGVjdCB1cyBmcm9tIHRoaXM/IElm
IHdlIGRvIHdhbnQgdG8gaG9sZCB0aGUgbG9jayB3aGlsZSAKPiB3YWl0aW5nIGZvciB0aGUgdGhy
ZWFkIHRvIHRlcm1pbmF0ZSwgc2hvdWxkIGl0IGJlIG1hZGUgaW50byBhIG11dGV4PyAKPiBJZiBz
bywgaXQgcHJvYmFibHkgc2hvdWxkbid0IGJlIHN0YXRpYyBidXQgbW92ZWQgaW50byB0aGUgbWRk
ZXYgCj4gc3RydWN0dXJlLiBJJ2QgbmVlZCB3ZWVrcyBpZiBub3QgbW9udGggdG8gZmlndXJlIHRo
YXQgb3V0IGFuZCB0byBmZWVsIAo+IGJvbGQgZW5vdWdoIHRvIHBvc3QgaXQuCgpUaGFua3MgZm9y
IGRlZXAgdGhpbmtpbmcgYWJvdXQgaXQsIEkgdGhpbmsgd2UgY2FuIGF2b2lkIHRvIGNhbGwgCmt0
aHJlYWRfc3RvcCB3aXRoIHNwaW5sb2NrCmhlbGQuIE1heWJlIHNvbWV0aGluZyBsaWtlIHRoaXMs
IGJ1dCBqdXN0IG15IHJhdyBpZGVhLCBwbGVhc2UgaGF2ZSBhIAp0aG9yb3VnaCByZXZpZXcuCgog
wqB2b2lkIG1kX3VucmVnaXN0ZXJfdGhyZWFkKHN0cnVjdCBtZF90aHJlYWQgKip0aHJlYWRwKQog
wqB7Ci3CoMKgwqDCoMKgwqAgc3RydWN0IG1kX3RocmVhZCAqdGhyZWFkID0gKnRocmVhZHA7Ci3C
oMKgwqDCoMKgwqAgaWYgKCF0aHJlYWQpCivCoMKgwqDCoMKgwqAgc3RydWN0IG1kX3RocmVhZCAq
dGhyZWFkID0gUkVBRF9PTkNFKCp0aHJlYWRwKTsKKworwqDCoMKgwqDCoMKgIHNwaW5fbG9jaygm
cGVyc19sb2NrKTsKK8KgwqDCoMKgwqDCoCBpZiAoIXRocmVhZCkgeworwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBzcGluX3VubG9jaygmcGVyc19sb2NrKTsKIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCByZXR1cm47CivCoMKgwqDCoMKgwqAgfQogwqDCoMKgwqDCoMKgwqAgcHJf
ZGVidWcoImludGVycnVwdGluZyBNRC10aHJlYWQgcGlkICVkXG4iLCAKdGFza19waWRfbnIodGhy
ZWFkLT50c2spKTsKIMKgwqDCoMKgwqDCoMKgIC8qIExvY2tpbmcgZW5zdXJlcyB0aGF0IG1kZGV2
X3VubG9jayBkb2VzIG5vdCB3YWtlX3VwIGEKIMKgwqDCoMKgwqDCoMKgwqAgKiBub24tZXhpc3Rl
bnQgdGhyZWFkCiDCoMKgwqDCoMKgwqDCoMKgICovCi3CoMKgwqDCoMKgwqAgc3Bpbl9sb2NrKCZw
ZXJzX2xvY2spOwogwqDCoMKgwqDCoMKgwqAgKnRocmVhZHAgPSBOVUxMOwogwqDCoMKgwqDCoMKg
wqAgc3Bpbl91bmxvY2soJnBlcnNfbG9jayk7CgotwqDCoMKgwqDCoMKgIGt0aHJlYWRfc3RvcCh0
aHJlYWQtPnRzayk7CivCoMKgwqDCoMKgwqAgaWYgKElTX0VSUl9PUl9OVUxMKHRocmVhZC0+dHNr
KSkgeworwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrdGhyZWFkX3N0b3AodGhyZWFkLT50
c2spOworwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0aHJlYWQtPnRzayA9IE5VTEw7CivC
oMKgwqDCoMKgwqAgfQogwqDCoMKgwqDCoMKgwqAga2ZyZWUodGhyZWFkKTsKIMKgfQogwqBFWFBP
UlRfU1lNQk9MKG1kX3VucmVnaXN0ZXJfdGhyZWFkKTsKCj4gSSBkb24ndCB3YW50IHRvIHB1c2gg
d29yayB0byBvdGhlcnMsIGJ1dCBteSBvd24gbXkgdW5kZXJzdGFuZGluZyBvZiBtZCAKPiBpcyB0
byBuYXJyb3cuCgpNZSBlaXRoZXIg8J+YiQoKVGhhbmtzLApHdW9xaW5nCgoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

