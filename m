Return-Path: <SRS0=KYOW=J2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC26EC433ED
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 06:02:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CAE0361434
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 06:02:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAE0361434
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-N-SYsY74NC6dPX2HT27xww-1; Thu, 29 Apr 2021 02:02:34 -0400
X-MC-Unique: N-SYsY74NC6dPX2HT27xww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE6B4EC1A3;
	Thu, 29 Apr 2021 06:02:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D35F618B39;
	Thu, 29 Apr 2021 06:02:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CFE4944A5C;
	Thu, 29 Apr 2021 06:02:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13T62MrX019307 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Apr 2021 02:02:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 300CB113B6C; Thu, 29 Apr 2021 06:02:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AEB0113B73
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 06:02:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBA9B185A7A5
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 06:02:19 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-211-d4be-kEvOVCldV3yv8Pu6w-1;
	Thu, 29 Apr 2021 02:02:15 -0400
X-MC-Unique: d4be-kEvOVCldV3yv8Pu6w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id CE8ECAF16;
	Thu, 29 Apr 2021 06:02:12 +0000 (UTC)
To: Mike Snitzer <snitzer@redhat.com>, mwilck@suse.com
References: <20210422202130.30906-1-mwilck@suse.com>
	<20210428195457.GA46518@lobo>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <7124009b-1ea5-61eb-419f-956e659a0996@suse.de>
Date: Thu, 29 Apr 2021 08:02:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210428195457.GA46518@lobo>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13T62MrX019307
X-loop: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] dm: dm_blk_ioctl(): implement failover for SG_IO on
	dm-multipath
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC8yOC8yMSA5OjU0IFBNLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4gT24gVGh1LCBBcHIgMjIg
MjAyMSBhdCAgNDoyMVAgLTA0MDAsCj4gbXdpbGNrQHN1c2UuY29tIDxtd2lsY2tAc3VzZS5jb20+
IHdyb3RlOgo+IAo+PiBGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KPj4KPj4g
SW4gdmlydHVhbCBkZXBsb3ltZW50cywgU0NTSSBwYXNzdGhyb3VnaCBvdmVyIGRtLW11bHRpcGF0
aCBkZXZpY2VzIGlzIGEKPj4gY29tbW9uIHNldHVwLiBUaGUgcWVtdSAicHItaGVscGVyIiB3YXMg
c3BlY2lmaWNhbGx5IGludmVudGVkIGZvciBpdC4gSQo+PiBiZWxpZXZlIHRoYXQgdGhpcyBpcyB0
aGUgbW9zdCBpbXBvcnRhbnQgcmVhbC13b3JsZCBzY2VuYXJpbyBmb3Igc2VuZGluZwo+PiBTR19J
TyBpb2N0bHMgdG8gZGV2aWNlLW1hcHBlciBkZXZpY2VzLgo+Pgo+PiBJbiB0aGlzIGNvbmZpZ3Vy
YXRpb24sIGd1ZXN0cyBzZW5kIFNDU0kgSU8gdG8gdGhlIGh5cGVydmlzb3IgaW4gdGhlIGZvcm0g
b2YKPj4gU0dfSU8gaW9jdGxzIGlzc3VlZCBieSBxZW11LiBCdXQgb24gdGhlIGRldmljZS1tYXBw
ZXIgbGV2ZWwsIHRoZXNlIFNDU0kKPj4gaW9jdGxzIGFyZW4ndCB0cmVhdGVkIGxpa2UgcmVndWxh
ciBJTy4gVW50aWwgY29tbWl0IDIzNjFhZTU5NTM1MiAoImRtIG1wYXRoOgo+PiBzd2l0Y2ggcGF0
aHMgaW4gZG1fYmxrX2lvY3RsKCkgY29kZSBwYXRoIiksIG5vIHBhdGggc3dpdGNoaW5nIHdhcyBk
b25lIGF0Cj4+IGFsbC4gV29yc2UgdGhvdWdoLCBpZiBhbiBTR19JTyBjYWxsIGZhaWxzIGJlY2F1
c2Ugb2YgYSBwYXRoIGVycm9yLAo+PiBkbS1tdWx0aXBhdGggZG9lc24ndCByZXRyeSB0aGUgSU8g
b24gYSBhbm90aGVyIHBhdGg7IHJhdGhlciwgdGhlIGZhaWx1cmUgaXMKPj4gcGFzc2VkIGJhY2sg
dG8gdGhlIGd1ZXN0LCBhbmQgcGF0aHMgYXJlIG5vdCBtYXJrZWQgYXMgZmF1bHR5LiAgVGhpcyBp
cyBpbgo+PiBzdGFyayBjb250cmFzdCB3aXRoIHJlZ3VsYXIgYmxvY2sgSU8gb2YgZ3Vlc3RzIG9u
IGRtLW11bHRpcGF0aCBkZXZpY2VzLCBhbmQKPj4gY2VydGFpbmx5IGNvbWVzIGFzIGEgc3VycHJp
c2UgdG8gdXNlcnMgd2hvIHN3aXRjaCB0byBTQ1NJIHBhc3N0aHJvdWdoIGluCj4+IHFlbXUuIElu
IGdlbmVyYWwsIHVzZXJzIG9mIGRtLW11bHRpcGF0aCBkZXZpY2VzIHdvdWxkIHByb2JhYmx5IGV4
cGVjdCBmYWlsb3Zlcgo+PiB0byB3b3JrIGF0IGxlYXN0IGluIGEgYmFzaWMgd2F5Lgo+Pgo+PiBU
aGlzIHBhdGNoIGZpeGVzIHRoaXMgYnkgdGFraW5nIGEgc3BlY2lhbCBjb2RlIHBhdGggZm9yIFNH
X0lPIG9uIHJlcXVlc3QtCj4+IGJhc2VkIGRldmljZSBtYXBwZXIgdGFyZ2V0cy4gUmF0aGVyIHRo
ZW4ganVzdCBjaG9vc2luZyBhIHNpbmdsZSBwYXRoLAo+PiBzZW5kaW5nIHRoZSBJTyB0byBpdCwg
YW5kIGZhaWxpbmcgdG8gdGhlIGNhbGxlciBpZiB0aGUgSU8gb24gdGhlIHBhdGgKPj4gZmFpbGVk
LCBpdCByZXRyaWVzIHRoZSBzYW1lIElPIG9uIGFub3RoZXIgcGF0aCBmb3IgY2VydGFpbiBlcnJv
ciBjb2RlcywKPj4gdXNpbmcgdGhlIHNhbWUgbG9naWMgYXMgYmxrX3BhdGhfZXJyb3IoKSB0byBk
ZXRlcm1pbmUgaWYgYSByZXRyeSB3b3VsZCBtYWtlCj4+IHNlbnNlIGZvciB0aGUgZ2l2ZW4gZXJy
b3IgY29kZS4gTW9yZW92ZXIsIGl0IHNlbmRzIGEgbWVzc2FnZSB0byB0aGUKPj4gbXVsdGlwYXRo
IHRhcmdldCB0byBtYXJrIHRoZSBwYXRoIGFzIGZhaWxlZC4KPj4KPj4gSSBhbSBhd2FyZSB0aGF0
IHRoaXMgbG9va3Mgc29ydCBvZiBoYWNrLWlzaC4gSSdtIHN1Ym1pdHRpbmcgaXQgaGVyZSBhcyBh
bgo+PiBSRkMsIGFza2luZyBmb3IgZ3VpZGFuY2UgaG93IHRvIHJlYWNoIGEgY2xlYW4gaW1wbGVt
ZW50YXRpb24gdGhhdCB3b3VsZCBiZQo+PiBhY2NlcHRhYmxlIGluIG1haW5saW5lLiBJIGJlbGll
dmUgdGhhdCBpdCBmaXhlcyBhbiBpbXBvcnRhbnQgcHJvYmxlbS4KPj4gQWN0dWFsbHksIGl0IGZp
eGVzIHRoZSBxZW11IFNDU0ktcGFzc3Rocm91Z2ggdXNlIGNhc2Ugb24gZG0tbXVsdGlwYXRoLAo+
PiB3aGljaCBpcyBub24tZnVuY3Rpb25hbCB3aXRob3V0IGl0Lgo+Pgo+PiBPbmUgcHJvYmxlbSBy
ZW1haW5zIG9wZW46IGlmIGFsbCBwYXRocyBpbiBhIG11bHRpcGF0aCBtYXAgYXJlIGZhaWxlZCwK
Pj4gbm9ybWFsIG11bHRpcGF0aCBJTyBtYXkgc3dpdGNoIHRvIHF1ZXVlaW5nIG1vZGUgKGRlcGVu
ZGluZyBvbgo+PiBjb25maWd1cmF0aW9uKS4gVGhpcyBpc24ndCBwb3NzaWJsZSBmb3IgU0dfSU8s
IGFzIFNHX0lPIHJlcXVlc3RzIGNhbid0Cj4+IGVhc2lseSBiZSBxdWV1ZWQgbGlrZSByZWd1bGFy
IGJsb2NrIEkvTy4gVGh1cyBpbiB0aGUgIm5vIHBhdGgiIGNhc2UsIHRoZQo+PiBndWVzdCB3aWxs
IHN0aWxsIHNlZSBhbiBlcnJvci4gSWYgYW55Ym9keSBjYW4gY29uY2VpdmUgb2YgYSBzb2x1dGlv
biBmb3IKPj4gdGhhdCwgSSdkIGJlIGludGVyZXN0ZWQuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IE1h
cnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgo+PiAtLS0KPj4gICBibG9jay9zY3NpX2lvY3Rs
LmMgICAgIHwgICA1ICstCj4+ICAgZHJpdmVycy9tZC9kbS5jICAgICAgICB8IDEzNCArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQo+PiAgIGluY2x1ZGUvbGludXgvYmxr
ZGV2LmggfCAgIDIgKwo+PiAgIDMgZmlsZXMgY2hhbmdlZCwgMTM3IGluc2VydGlvbnMoKyksIDQg
ZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9ibG9jay9zY3NpX2lvY3RsLmMgYi9ibG9j
ay9zY3NpX2lvY3RsLmMKPj4gaW5kZXggNjU5OWJhYzBhNzhjLi5iY2M2MDU1MmY3YjEgMTAwNjQ0
Cj4+IC0tLSBhL2Jsb2NrL3Njc2lfaW9jdGwuYwo+PiArKysgYi9ibG9jay9zY3NpX2lvY3RsLmMK
Pj4gQEAgLTI3OSw4ICsyNzksOCBAQCBzdGF0aWMgaW50IGJsa19jb21wbGV0ZV9zZ2hkcl9ycShz
dHJ1Y3QgcmVxdWVzdCAqcnEsIHN0cnVjdCBzZ19pb19oZHIgKmhkciwKPj4gICAJcmV0dXJuIHJl
dDsKPj4gICB9Cj4+ICAgCj4+IC1zdGF0aWMgaW50IHNnX2lvKHN0cnVjdCByZXF1ZXN0X3F1ZXVl
ICpxLCBzdHJ1Y3QgZ2VuZGlzayAqYmRfZGlzaywKPj4gLQkJc3RydWN0IHNnX2lvX2hkciAqaGRy
LCBmbW9kZV90IG1vZGUpCj4+ICtpbnQgc2dfaW8oc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0
cnVjdCBnZW5kaXNrICpiZF9kaXNrLAo+PiArCSAgc3RydWN0IHNnX2lvX2hkciAqaGRyLCBmbW9k
ZV90IG1vZGUpCj4+ICAgewo+PiAgIAl1bnNpZ25lZCBsb25nIHN0YXJ0X3RpbWU7Cj4+ICAgCXNz
aXplX3QgcmV0ID0gMDsKPj4gQEAgLTM2OSw2ICszNjksNyBAQCBzdGF0aWMgaW50IHNnX2lvKHN0
cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgZ2VuZGlzayAqYmRfZGlzaywKPj4gICAJYmxr
X3B1dF9yZXF1ZXN0KHJxKTsKPj4gICAJcmV0dXJuIHJldDsKPj4gICB9Cj4+ICtFWFBPUlRfU1lN
Qk9MX0dQTChzZ19pbyk7Cj4+ICAgCj4+ICAgLyoqCj4+ICAgICogc2dfc2NzaV9pb2N0bCAgLS0g
IGhhbmRsZSBkZXByZWNhdGVkIFNDU0lfSU9DVExfU0VORF9DT01NQU5EIGlvY3RsCj4+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL21kL2RtLmMgYi9kcml2ZXJzL21kL2RtLmMKPj4gaW5kZXggNTBiNjkz
ZDc3NmQ2Li40NDNhYzVlNTQwNmMgMTAwNjQ0Cj4+IC0tLSBhL2RyaXZlcnMvbWQvZG0uYwo+PiAr
KysgYi9kcml2ZXJzL21kL2RtLmMKPj4gQEAgLTI5LDYgKzI5LDggQEAKPj4gICAjaW5jbHVkZSA8
bGludXgvcGFydF9zdGF0Lmg+Cj4+ICAgI2luY2x1ZGUgPGxpbnV4L2Jsay1jcnlwdG8uaD4KPj4g
ICAjaW5jbHVkZSA8bGludXgva2V5c2xvdC1tYW5hZ2VyLmg+Cj4+ICsjaW5jbHVkZSA8c2NzaS9z
Zy5oPgo+PiArI2luY2x1ZGUgPHNjc2kvc2NzaS5oPgo+PiAgIAo+PiAgICNkZWZpbmUgRE1fTVNH
X1BSRUZJWCAiY29yZSIKPj4gICAKPiAKPiBOZ2guLi4gbm90IGxvdmluZyB0aGlzIGF0IGFsbC4g
IEJ1dCBoZXJlIGlzIGEgcGF0Y2ggKHRoYXQgSSBkaWRuJ3QKPiBjb21waWxlIHRlc3QpIHRoYXQg
c2hvdWxkIGJlIGZvbGRlZCBpbiwgc3RpbGwgaGF2ZSB0byB0aGluayBhYm91dCBob3cKPiB0aGlz
IGNvdWxkIGJlIG1hZGUgY2xlYW5lciBpbiBnZW5lcmFsIHRob3VnaC4KPiAKPiBBbHNvLCBkbV9z
Z19pb19pb2N0bCBzaG91bGQgcHJvYmFibHkgYmUgaW4gZG0tcnEuYyAobWF5YmUgZXZlbiBkbS1t
cGF0aC5jIT8pCj4gCkkgZnVsbHkgc2hhcmUgeW91ciBzZW50aW1lbnRzOyB0aGlzIGp1c3QgZmVl
bHMgc28gYXdrd2FyZCwgaGF2aW5nIHRvIApyZWRvIHRoZSBsb2dpYyBpbiBzY3NpX2NtZF9pb2N0
bCgpLgoKTXkgb3JpZ2luYWwgaWRlYSB0byB0aGF0IHdhcyB0byBfdXNlXyBzY3NpX2NtZF9pb2N0
bCgpIGRpcmVjdGx5IGZyb20gCmRtX2Jsa19pb2N0bDoKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L2RtLmMgYi9kcml2ZXJzL21kL2RtLmMKaW5kZXggNTBiNjkzZDc3NmQ2Li4wMDdmZjk4MWY4ODgg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvZG0uYworKysgYi9kcml2ZXJzL21kL2RtLmMKQEAgLTU2
Nyw2ICs1NjcsOSBAQCBzdGF0aWMgaW50IGRtX2Jsa19pb2N0bChzdHJ1Y3QgYmxvY2tfZGV2aWNl
ICpiZGV2LCAKZm1vZGVfdCBtb2RlLAogICAgICAgICBzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQg
PSBiZGV2LT5iZF9kaXNrLT5wcml2YXRlX2RhdGE7CiAgICAgICAgIGludCByLCBzcmN1X2lkeDsK
CisgICAgICAgaWYgKGNtZCA9PSBTR19JTykKKyAgICAgICAgICAgICAgIHJldHVybiBzY3NpX2Nt
ZF9ibGtfaW9jdGwoYmRldiwgbW9kZSwgY21kLCBhcmcpOworCiAgICAgICAgIHIgPSBkbV9wcmVw
YXJlX2lvY3RsKG1kLCAmc3JjdV9pZHgsICZiZGV2KTsKICAgICAgICAgaWYgKHIgPCAwKQogICAg
ICAgICAgICAgICAgIGdvdG8gb3V0OwoKCkJ1dCB0aGF0IGNyYXNoZXMgaG9ycmlibHkgYXMgc2df
aW8oKSBleHBlY3RzIHRoZSByZXF1ZXN0IHBkdSB0byBiZSBvZiAKdHlwZSAnc2NzaV9yZXF1ZXN0
Jywgd2hpY2ggaXQgZGVmaW5pdGVseSBpc24ndCBoZXJlLgoKV2UgX2NvdWxkXyBwcmVwZW5kIHN0
cnVjdCBkbV9ycV90YXJnZXRfaW8gd2l0aCBhIHN0cnVjdCBzY3NpX3JlcXVlc3QsIApzZWVpbmcg
dGhhdCBiYXNpY2FsbHkgX2FsbF8gZG0tcnEgaW5zdGFsbGF0aW9ucyBhcmUgb24gU0NTSSBkZXZp
Y2VzOgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tcnEuYyBiL2RyaXZlcnMvbWQvZG0tcnEu
YwppbmRleCAxM2I0Mzg1ZjRkNWEuLmFhNzg1NjYyMWY4MyAxMDA2NDQKLS0tIGEvZHJpdmVycy9t
ZC9kbS1ycS5jCisrKyBiL2RyaXZlcnMvbWQvZG0tcnEuYwpAQCAtMTYsNiArMTYsNyBAQAogICAq
IE9uZSBvZiB0aGVzZSBpcyBhbGxvY2F0ZWQgcGVyIHJlcXVlc3QuCiAgICovCiAgc3RydWN0IGRt
X3JxX3RhcmdldF9pbyB7CisgICAgICAgc3RydWN0IHNjc2lfcmVxdWVzdCBzY3NpX3JlcTsKICAg
ICAgICAgc3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kOwogICAgICAgICBzdHJ1Y3QgZG1fdGFyZ2V0
ICp0aTsKICAgICAgICAgc3RydWN0IHJlcXVlc3QgKm9yaWcsICpjbG9uZTsKClRoZW4gdGhlIGFi
b3ZlIHNob3VsZCB3b3JrLCBidXQgd2Ugd291bGQgaW5jcmVhc2UgdGhlIHNpemUgb2YgCmRtX3Jx
X3RhcmdldF9pbyBieSBxdWl0ZSBhIGxvdC4gQWx0aG91Z2gsIGdpdmVuIHRoZSBjdXJyZW50IHNp
emUgb2YgaXQsIApxdWVzdGlvbiBpcyB3aGV0aGVyIGl0IG1hdHRlcnMuLi4KCkhtbT8KCkNoZWVy
cywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwg
U3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVs
ZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jD
pGZ0c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw=

