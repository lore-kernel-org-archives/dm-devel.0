Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3D2C2D0A3
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:20:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 08C93222EA
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:20:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08C93222EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-ag66YfF3Nd2MQ9BjnLHIuw-1; Mon, 26 Oct 2020 03:20:01 -0400
X-MC-Unique: ag66YfF3Nd2MQ9BjnLHIuw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78B3C1008548;
	Mon, 26 Oct 2020 07:19:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FF6819C66;
	Mon, 26 Oct 2020 07:19:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 77D471832FC2;
	Mon, 26 Oct 2020 07:19:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09M5SSEn030042 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Oct 2020 01:28:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6F9FC202DD56; Thu, 22 Oct 2020 05:28:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AF9F202450E
	for <dm-devel@redhat.com>; Thu, 22 Oct 2020 05:28:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CCD3800183
	for <dm-devel@redhat.com>; Thu, 22 Oct 2020 05:28:26 +0000 (UTC)
Received: from out30-42.freemail.mail.aliyun.com
	(out30-42.freemail.mail.aliyun.com [115.124.30.42]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-425-UU-TZ_AhMyiaZFWfMmXQcQ-1;
	Thu, 22 Oct 2020 01:28:19 -0400
X-MC-Unique: UU-TZ_AhMyiaZFWfMmXQcQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UCoWYuG_1603344481
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UCoWYuG_1603344481) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 22 Oct 2020 13:28:02 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
	<20201021203906.GA10896@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
Date: Thu, 22 Oct 2020 13:28:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
	Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201021203906.GA10896@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 26 Oct 2020 03:19:19 -0400
Cc: axboe@kernel.dk, xiaoguang.wang@linux.alibaba.com,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, haoxu@linux.alibaba.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [RFC 0/3] Add support of iopoll for dm device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDEwLzIyLzIwIDQ6MzkgQU0sIE1pa2UgU25pdHplciB3cm90ZToKCj4gV2hhdCB5b3UndmUg
X2RvbmVfIGNvdWxkIHNlcnZlIGFzIGEgc3RvcC1nYXAgYnV0IEknZCByZWFsbHkgcmF0aGVyIHdl
Cj4gZ2V0IGl0IHByb3Blcmx5IGRlc2lnbmVkIGZyb20gdGhlIHN0YXJ0LgoKSW5kZWVkIEkgdG90
YWxseSBhZ3JlZSB3aXRoIHlvdSB0aGF0IHRoZSBkZXNpZ24gc2hvdWxkIGJlIGRvbmUgbmljZWx5
IGF0IAp0aGUgdmVyeSBiZWdpbm5pbmcuIEFuZCB0aGlzCgppcyBpbmRlZWQgdGhlIHB1cnBvc2Ug
b2YgdGhpcyBSRkMgcGF0Y2guCgoKPj4gVGhpcyBwYXRjaCBzZXQgYWRkcyBzdXBwb3J0IG9mIGlv
cG9sbCBmb3IgZG0gZGV2aWNlLgo+Pgo+PiBUaGlzIGlzIG9ubHkgYW4gUkZDIHBhdGNoLiBJJ20g
cmVhbGx5IGxvb2tpbmcgZm9yd2FyZCBnZXR0aW5nIHlvdXIKPj4gZmVlZGJhY2tzIG9uIGlmIHlv
dSdyZSBpbnRlcmVzdGVkIGluIHN1cHBvcnRpbmcgaW9wb2xsIGZvciBkbSBkZXZpY2UsCj4+IG9y
IGlmIHRoZXJlJ3MgYSBiZXR0ZXIgZGVzaWduIHRvIGltcGxlbWVudCB0aGF0Lgo+Pgo+PiBUaGFu
a3MuCj4+Cj4+Cj4+IFtQdXJwb3NlXQo+PiBJTyBwb2xsaW5nIGlzIGFuIGltcG9ydGFudCBtb2Rl
IG9mIGlvX3VyaW5nLiBDdXJyZW50bHkgb25seSBtcSBkZXZpY2VzCj4+IHN1cHBvcnQgaW9wb2xs
LiBBcyBmb3IgZG0gZGV2aWNlcywgb25seSBkbS1tdWx0aXBhdGggaXMgcmVxdWVzdC1iYXNlLAo+
PiB3aGlsZSBvdGhlcnMgYXJlIGFsbCBiaW8tYmFzZWQgYW5kIGhhdmUgbm8gc3VwcG9ydCBmb3Ig
aW9wb2xsLgo+PiBTdXBwb3J0aW5nIGlvcG9sbCBmb3IgZG0gZGV2aWNlcyBjYW4gYmUgb2YgZ3Jl
YXQgbWVhbmluZyB3aGVuIHRoZQo+PiBkZXZpY2Ugc2VlbiBieSBhcHBsaWNhdGlvbiBpcyBkbSBk
ZXZpY2Ugc3VjaCBhcyBkbS1saW5lYXIvZG0tc3RyaXBlLAo+PiBpbiB3aGljaCBjYXNlIGlvcG9s
bCBpcyBub3QgdXNhYmxlIGZvciBpb191cmluZy4KPiBJIGFwcHJlY2lhdGUgeW91IHRha2luZyB0
aGUgaW5pdGlhdGl2ZSBvbiB0aGlzOyBwb2xsaW5nIHN1cHBvcnQgaXMgb24gbXkKPiBUT0RPIHNv
IHlvdXIgd29yayBzZXJ2ZXMgYXMgYSBuaWNlIHJlbWluZGVyIHRvIHB1cnN1ZSB0aGlzIG1vcmUK
PiB1cmdlbnRseS4KCkl0J3MgYSBnb29kIG5ld3MgdGhhdCBpb3BvbGwgZm9yIERNIGlzIG1lYW5p
bmdmdWwuCgoKPiBidXQgd2UgY2Fubm90IGF2b2lkIHByb3Blcmx5IG1hcHBpbmcgYSBjb29raWUg
dG8gZWFjaAo+IHNwbGl0IGJpby4gIE90aGVyd2lzZSB5b3UgcmVzb3J0IHRvIGluZWZmaWNpZW50
bHkgcG9sbGluZyBldmVyeXRoaW5nLgoKWWVzLiBBdCB0aGUgdmVyeSBiZWdpbm5pbmfCoCBJIHRy
aWVkIHRvIGJ1aWxkIHRoZSBtYXBwaW5nIGEgY29va2llIHRvIAplYWNoIGJpbywgYnV0IEkgZmFp
bGVkIHdpdGggc2V2ZXJhbAoKYmxvY2tpbmcgZGVzaWduIGlzc3Vlcy4gQnkgdGhlIHdheSBtYXli
ZSB3ZSBjb3VsZCBjbGFyaWZ5IHRoZXNlIGRlc2lnbiAKaXNzdWVzIGhlcmUsIGlmIHlvdSdkIGxp
a2UuCgoKPgo+IFNlZW1zIHlvdXIgYXR0ZW1wdCB0byBoYXZlIHRoZSBjb29raWUgcG9pbnQgdG8g
YSBkbV9pbyBvYmplY3Qgd2FzIGxpa2VseQo+IHRvbyBjb2Fyc2UtZ3JhaW5lZCAod2hlbiBiaW9z
IGFyZSBzcGxpdCB0aGV5IGdldCB0aGVpciBvd24gZG1faW8gb24KPiByZWN1cnNpdmUgcmUtZW50
cnkgdG8gRE0gY29yZSBmcm9tIC0+c3VibWl0X2Jpbyk7IGJ1dCBpc24ndCBoYXZpbmcgYQo+IGxp
c3Qgb2YgY29va2llcyBzdGlsbCB0b28gaW1wcmVjaXNlIGZvciBwb2xsaW5nIHB1cnBvc2VzPyAg
WW91IGNvdWxkCj4gZWFzaWx5IGhhdmUgYSBsaXN0IHRoYXQgdHJhbnNsYXRlcyB0byBtYW55IGJs
ay1tcSBxdWV1ZXMuICBQb3NzaWJseQo+IGJldHRlciB0aGFuIHlvdXIgY3VycmVudCBhcHByb2Fj
aCBvZiBwb2xsaW5nIGV2ZXJ5dGhpbmcgLS0gYnV0IG5vdAo+IG11Y2guCgpUbyBtYWtlIHRoZSBk
aXNjdXNzaW9uIG1vcmUgc3BlY2lmaWMsIGFzc3VtZSB0aGF0IGRtMCBpcyBtYXBwZWQgdG8gCmRt
MS8yLzMsIHdoaWxlIGRtMSBtYXBwZWQgdG8KCm52bWUxLCBkbTIgbWFwcGVkIHRvIGRtMiwgZXRj
Li4KCiDCoMKgwqAgwqDCoMKgIMKgwqDCoCDCoMKgwqAgwqDCoMKgIGRtMAoKZG0xwqDCoMKgIMKg
wqAgwqAgwqDCoMKgIGRtMsKgwqDCoCDCoMKgwqAgwqDCoMKgIGRtMwoKbnZtZTEgwqDCoCDCoMKg
wqAgbnZtZTLCoMKgwqAgwqDCoMKgIG52bWUzCgoKVGhlbiB0aGUgcmV0dXJuZWQgY29va2llIG9m
IGRtMCBjb3VsZCBiZSBwb2ludGVyIHBvaW50aW5nIHRvIGRtX2lvIApvYmplY3Qgb2YgZG0wLgoK
c3RydWN0IGRtX2lvIHsgIC8vIHRoZSByZXR1cm5lZCBjb29raWUgcG9pbnRzIHRvIGRtX2lvIG9i
amVjdAoJLi4uCisJc3RydWN0IGxpc3RfaGVhZCBjb29raWVzOwp9OwoKc3RydWN0IGRtX3Rhcmdl
dF9pbyB7CgkuLi4KCS8qCgkgKiBUaGUgY29ycmVzcG9uZGluZyBwb2xsaW5nIGh3IHF1ZXVlIGlm
IHN1Ym1pdHRlZCB0byBtcSBkZXZpY2UgKHN1Y2ggYXMgbnZtZTEvMi8zKSwKCSAqIE5VTEwgaWYg
c3VibWl0dGVkIHRvIGRtIGRldmljZSAoc3VjaCBhcyBkbTEvMi8zKQoJICovCisJc3RydWN0IGJs
a19tcV9od19jdHggKmhjdHg7CisJc3RydWN0IGxpc3RfaGVhZCAgICAgIG5vZGU7ICAvLyBhZGQg
dG8gQGNvb2tpZXMgbGlzdAp9OwoKVGhlIEBjb29raWVzIGxpc3Qgb2YgZG1faW8gb2JqZWN0IGNv
dWxkIG1haW50YWluIGFsbCBkbV90YXJnZXRfaW8gb2JqZWN0cwpvZiBhbGwgKipub25lLWRtKiog
ZGV2aWNlcywgdGhhdCBpcywgYWxsIGh3IHF1ZXVlcyB0aGF0IHdlIHNob3VsZCBwb2xsIG9uLgoK
CnJldHVybmVkICAtPiAgQGNvb2tpZXMgbGlzdAkKY29va2llCSAgICAgIG9mIGRtX2lvIG9iamVj
dCBvZiBkbTAKCQkgICB8CgkJICAgKy0tPiBkbV90YXJnZXRfaW8JIC0+ICBkbV90YXJnZXRfaW8g
ICAgIC0+ICBkbV90YXJnZXRfaW8KCQkJb2JqZWN0IG9mIG52bWUxICAgICAgb2JqZWN0IG9mIG52
bWUyCSAgb2JqZWN0IG9mIG52bWUzCgpXaGVuIHBvbGxpbmcgcmV0dXJuZWQgY29va2llIG9mIGRt
MCwgYWN0dWFsbHkgd2UncmUgcG9sbGluZyBAY29va2llcyAKbGlzdC4gT25jZSBvbmUgb2YgdGhl
IGRtX3RhcmdldF9pbwoKY29tcGxldGVkIChlLmcuIG52bWUyKSwgaXQgc2hvdWxkIGJlIHJlbW92
ZWQgZnJvbSB0aGUgQGNvb2tpZXMgbGlzdC4sIAphbmQgdGh1cyB3ZSBzaG91bGQgb25seSBmb2N1
cyBvbgoKaHcgcXVldWVzIHRoYXQgaGF2ZSBub3QgY29tcGxldGVkLgoKCgo+PiBbRGVzaWduIE5v
dGVzXQo+Pgo+PiBjb29raWUKPj4gLS0tLS0tCj4+IExldCdzIHN0YXJ0IGZyb20gY29va2llLiBD
b29raWUgaXMgb25lIGltcG9ydGFudCBjb25jZXB0IGluIGlvcG9sbC4gSXQKPj4gaXMgdXNlZCB0
byBpZGVudGlmeSBvbmUgc3BlY2lmaWMgcmVxdWVzdCBpbiBvbmUgc3BlY2lmaWMgaGFyZHdhcmUg
cXVldWUuCj4+IFRoZSBjb25jZXB0IG9mIGNvb2tpZSBpcyBpbml0aWFsbHkgZGVzaWduZWQgYXMg
YSBwZXItYmlvIGNvbmNlcHQsIGFuZAo+PiB0aHVzIGl0IGRvZXNuJ3Qgd29yayB3ZWxsIHdoZW4g
YmlvLXNwbGl0IGludm9sdmVkLiBXaGVuIGJpbyBpcyBzcGxpdCwKPj4gdGhlIHJldHVybmVkIGNv
b2tpZSBpcyBpbmRlZWQgdGhlIGNvb2tpZSBvZiBvbmUgb2YgdGhlIHNwbGl0IGJpbywgYW5kCj4+
IHRoZSBmb2xsb3dpbmcgcG9sbGluZyBvbiB0aGlzIHJldHVybmVkIGNvb2tpZSBjYW4gb25seSBn
dWFyYW50ZWUgdGhlCj4+IGNvbXBsZXRpb24gb2YgdGhpcyBzcGVjaWZpYyBzcGxpdCBiaW8sIHdo
aWxlIHRoZSBvdGhlciBzcGxpdCBiaW9zIG1heQo+PiBiZSBzdGlsbCB1bmNvbXBsZXRlZC4gQmlv
LXNwbGl0IGlzIGFsc28gcmVzb2x2ZWQgZm9yIGRtIGRldmljZSwgdGhvdWdoCj4+IGluIGFub3Ro
ZXIgZm9ybSwgaW4gd2hpY2ggY2FzZSB0aGUgb3JpZ2luYWwgYmlvIHN1Ym1pdHRlZCB0byB0aGUg
ZG0KPj4gZGV2aWNlIG1heSBiZSBzcGxpdCBpbnRvIG11bHRpcGxlIGJpb3Mgc3VibWl0dGVkIHRv
IHRoZSB1bmRlcmx5aW5nCj4+IGRldmljZXMuCj4+Cj4+IEluIHByZXZpb3VzIGRpc2N1c3Npb24s
IExlaSBNaW5nIGhhcyBzdWdnZXN0ZWQgdGhhdCBpb3BvbGwgc2hvdWxkIGJlCj4+IGRpc2FibGVk
IGZvciBiaW8tc3BsaXQuIFRoaXMgd29ya3MgZm9yIHRoZSBub3JtYWwgYmlvLXNwbGl0IChkb25l
IGluCj4+IGJsa19tcV9zdWJtaXRfYmlvLT5fX2Jsa19xdWV1ZV9zcGxpdCksIHdoaWxlIGlvcG9s
bCB3aWxsIG5ldmVyIGJlCj4+IHVzYWJsZSBmb3IgZG0gZGV2aWNlcyBpZiB0aGlzIGFsc28gYXBw
bGllcyBmb3IgZG0gZGV2aWNlLgo+Pgo+PiBTbyBjb21lIGJhY2sgdG8gdGhlIGRlc2lnbiBvZiB0
aGUgY29va2llIGZvciBkbSBkZXZpY2VzLiBBdCB0aGUgdmVyeQo+PiBiZWdpbm5pbmcgSSB3YW50
IHRvIHJlZmFjdG9yIHRoZSBkZXNpZ24gb2YgY29va2llLCBmcm9tICd1bnNpZ25lZCBpbnQnCj4+
IHR5cGUgdG8gdGhlIHBvaW50ZXIgdHlwZSBmb3IgZG0gZGV2aWNlLCBzbyB0aGF0IGNvb2tpZSBj
YW4gcG9pbnQgdG8KPj4gc29tZXRoaW5nLCBlLmcuIGEgbGlzdCBjb250YWluaW5nIGFsbCBjb29r
aWVzIG9mIG9uZSBvcmlnaW5hbCBiaW8sCj4+IHNvbWV0aGluZyBsaWtlIHRoaXM6Cj4+Cj4+IHN0
cnVjdCBkbV9pbyB7IC8vIHRoZSByZXR1cm5lZCBjb29raWUgcG9pbnRzIHRvIGRtX2lvCj4+IAku
Li4KPj4gCXN0cnVjdCBsaXN0X2hlYWQgY29va2llczsKPj4gfTsKPj4KPj4gSW4gdGhpcyBkZXNp
Z24sIHdlIGNhbiBmZXRjaCBhbGwgY29va2llcyBvZiBvbmUgb3JpZ2luYWwgYmlvLCBidXQgdGhl
Cj4+IGltcGxlbWVudGF0aW9uIGNhbiBiZSBkaWZmaWN1bHQgYW5kIGJ1Z2d5LiBGb3IgZXhhbXBs
ZSwgdGhlCj4+ICdzdHJ1Y3QgZG1faW8nIHN0cnVjdHVyZSBtYXkgYmUgYWxyZWFkeSBmcmVlZCB3
aGVuIHRoZSByZXR1cm5lZCBjb29raWUKPj4gaXMgdXNlZCBpbiBibGtfcG9sbCgpLiBUaGVuIHdo
YXQgaWYgbWFpbnRhaW4gYSByZWZjb3VudCBpbiBzdHJ1Y3QgZG1faW8KPj4gc28gdGhhdCAnc3Ry
dWN0IGRtX2lvJyBzdHJ1Y3R1cmUgY2FuIG5vdCBiZSBmcmVlZCB1bnRpbCBibGtfcG9sbCgpCj4+
IGNhbGxlZD8gVGhlbiB0aGUgJ3N0cnVjdCBkbV9pbycgc3RydWN0dXJlIHdpbGwgbmV2ZXIgYmUg
ZnJlZWQgaWYgdGhlCj4+IElPIHBvbGxpbmcgaXMgbm90IHVzZWQgYXQgYWxsLgo+IEknZCBoYXZl
IHRvIGxvb2sgY2xvc2VyIGF0IHRoZSByYWNlIGluIHRoZSBjb2RlIHlvdSB3cm90ZSAodGhvdWdo
IHlvdQo+IGRpZG4ndCBzaGFyZSBpdCk7CgpJIHdvcnJpZWQgdGhhdCBkbV90YXJnZXRfaW8vZG1f
aW8gb2JqZWN0cyBjb3VsZCBoYXZlIGJlZW4gZnJlZWQgCmJlZm9yZS93aGVuIHdlIGFyZSBwb2xs
aW5nIG9uIHRoZW0sCgphbmQgdGh1cyBjb3VsZCBjYXVzZSB1c2UtYWZ0ZXItZnJlZSB3aGVuIGFj
Y2Vzc2luZyBAY29va2llcyBsaXN0IGluIApkbV90YXJnZXRfaW8uIEl0IGNvdWxkIGhhcHBlbgoK
d2hlbiB0aGVyZSBhcmUgbXVsdGlwbGUgcG9sbGluZyBpbnN0YW5jZS4gaW9fdXJpbmcgaGFzIGlt
cGxlbWVudGVkIApwZXItaW5zdGFuY2UgcG9sbGluZyB0aHJlYWQuIElmCgp0aGVyZSBhcmUgdHdv
IGJpb3Mgc3VibWl0dGVkIHRvIGRtMCwgcGxlYXNlIGNvbnNpZGVyIHRoZSBmb2xsb3dpbmcgcmFj
ZSAKc2VxdWVuY2U6CgoKMS4gcmFjZSAxOiBkbV90YXJnZXRfaW8vZG1faW8gb2JqZWN0cyBjb3Vs
ZCBoYXZlIGJlZW4gZnJlZWQgKioqKndoZW4qKioqIAp3ZSBhcmUgcG9sbGluZyBvbiB0aGVtCgpg
YGAqCioKCip0aHJlYWQxIHBvbGxpbmcgb24gYmlvMcKgwqDCoCDCoMKgwqAgwqDCoMKgIMKgwqDC
oCDCoMKgwqAgdGhyZWFkMiBwb2xsaW5nIG9uIGJpbzIqCgogwqDCoMKgIGZldGNoIGRtX2lvIG9i
amVjdCBieSB0aGUgY29va2llCgpyZWFwcyBjb21wbGV0aW9ucyBpbiBudm1lIDEvMi8zLAoKY29t
cGxldGVzIGJpbzEgYW5kIGZyZWVzIGRtX2lvIG9iamVjdCBvZiBiaW8xIGJ5IHRoZSB3YXkKCiDC
oMKgwqAgdXNlLWFmdGVyLWZyZWUgd2hlbiBhY2Nlc3NpbmcgZG1faW8gb2JqZWN0CgpgYGAKCk1h
eWJlIHdlIHNob3VsZCBnZXQgYSByZWZjb3VudCBvZiBkbV9pbyBvZiBiaW8xIHdoZW4gc3RhcnQg
cG9sbGluZywgYnV0IApJJ20gbm90IHN1cmUgaWYgdGhlIGRlc2lnbiBpcwoKZWxlZ2FudCBvciBu
b3QuCgoKCjIuIHJhY2UgMjogZG1fdGFyZ2V0X2lvL2RtX2lvIG9iamVjdHMgY291bGQgaGF2ZSBi
ZWVuIGZyZWVkIAoqKioqYmVmb3JlKioqKiB3ZSBhcmUgcG9sbGluZyBvbiB0aGVtCgpgYGAKCip0
aHJlYWQxIHBvbGxpbmcgb24gYmlvMcKgwqDCoCDCoMKgwqAgwqDCoMKgIMKgwqDCoCDCoMKgwqAg
dGhyZWFkMiBwb2xsaW5nIG9uIGJpbzIqCgpyZWFwcyBjb21wbGV0aW9ucyBpbiBudm1lIDEvMi8z
LAoKY2xvbmVfZW5kaW8KCiDCoMKgwqAgZGVjX3BlbmRpbmcKCiDCoMKgwqAgwqDCoMKgIGZyZWVf
aW8obWQsIGlvKTvCoCAvLyBmcmVlIGRtX2lvIG9iamVjdAoKIMKgwqDCoCBfX2Jsa2Rldl9kaXJl
Y3RfSU8KCiDCoMKgwqAgwqDCoMKgIFJFQURfT05DRShkaW8tPndhaXRlcinCoCAvLyBkaW8tPndh
aXRlciBpcyBzdGlsbCBub25lLU5VTEwKCiDCoMKgwqAgwqDCoMKgIGJpb19lbmRpbyhpby0+b3Jp
Z19iaW8pIC8vY2FsbCBiaV9lbmRfaW8oKSBvZiBvcmlnaW5hbCBiaW8sIAp0aGF0IGlzIGJsa2Rl
dl9iaW9fZW5kX2lvCgogwqDCoMKgIMKgwqDCoCDCoMKgwqAgV1JJVEVfT05DRShkaW8tPndhaXRl
ciwgTlVMTCk7CgogwqDCoMKgIMKgwqDCoCBibGtfcG9sbAoKIMKgwqDCoCDCoMKgwqAgwqDCoMKg
IGZldGNoIGRtX2lvIG9iamVjdCBieSB0aGUgY29va2llwqAgLy8gdXNlLWFmdGVyLWZyZWUhCgpg
YGAKCgpUaGFua3MuCgpKZWZmbGUuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw=

