Return-Path: <SRS0=+b8E=IH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461A4C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  9 Mar 2021 11:43:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A80896525F
	for <dm-devel@archiver.kernel.org>; Tue,  9 Mar 2021 11:43:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A80896525F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615290191;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Sz7BgDAIUVDc0ChMyUVpfCi/QdWHZqnYWJJhkNEDnzY=;
	b=aCqNC8kbe+57LzwUORLodA3dNBcQGvml0h24p+u9UzhrLyxVbIOHrPkwLbeYWg5+eLom1C
	K3H7ZHMcgaPPExT+QhwKX/0HtaMSWMo2wbQuYNVuBjb1T2ZmbkB7qysPSNNlCmJ2F9hnTG
	EN9I6eqr2krNs/38f29aDBhxjxOBGhY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-pG02f3AbP8e0JDRiwhZAUA-1; Tue, 09 Mar 2021 06:43:09 -0500
X-MC-Unique: pG02f3AbP8e0JDRiwhZAUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D21E69739;
	Tue,  9 Mar 2021 11:43:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A12215D9DE;
	Tue,  9 Mar 2021 11:43:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6E4EE1809C86;
	Tue,  9 Mar 2021 11:42:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 129BgtrE001814 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Mar 2021 06:42:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DCD5260C4A; Tue,  9 Mar 2021 11:42:55 +0000 (UTC)
Received: from [192.168.1.10] (ovpn-115-45.ams2.redhat.com [10.36.115.45])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B31C660C04;
	Tue,  9 Mar 2021 11:42:50 +0000 (UTC)
To: JeffleXu <jefflexu@linux.alibaba.com>,
	Mikulas Patocka <mpatocka@redhat.com>
References: <20210302190555.201228400@debian-a64.vm>
	<33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
	<alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
	<157a750d-3d58-ae2e-07f1-b677c1b471c7@linux.alibaba.com>
	<bd447632-f174-e6f2-ddf8-d5385da13f6b@redhat.com>
	<fc9707dc-0a21-90d3-ed4f-e201406c50eb@redhat.com>
	<06d17f27-c043-f69c-eeef-f6df714c1764@linux.alibaba.com>
From: Heinz Mauelshagen <heinzm@redhat.com>
Message-ID: <bc0cdc50-22c9-031f-2ebf-3c8b0879eeb5@redhat.com>
Date: Tue, 9 Mar 2021 12:42:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <06d17f27-c043-f69c-eeef-f6df714c1764@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, Mike Snitzer <msnitzer@redhat.com>,
	caspar@linux.alibaba.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
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

T24gMy84LzIxIDQ6NTQgQU0sIEplZmZsZVh1IHdyb3RlOgo+Cj4gT24gMy82LzIxIDE6NTYgQU0s
IEhlaW56IE1hdWVsc2hhZ2VuIHdyb3RlOgo+PiBPbiAzLzUvMjEgNjo0NiBQTSwgSGVpbnogTWF1
ZWxzaGFnZW4gd3JvdGU6Cj4+PiBPbiAzLzUvMjEgMTA6NTIgQU0sIEplZmZsZVh1IHdyb3RlOgo+
Pj4+IE9uIDMvMy8yMSA2OjA5IFBNLCBNaWt1bGFzIFBhdG9ja2Egd3JvdGU6Cj4+Pj4+IE9uIFdl
ZCwgMyBNYXIgMjAyMSwgSmVmZmxlWHUgd3JvdGU6Cj4+Pj4+Cj4+Pj4+PiBPbiAzLzMvMjEgMzow
NSBBTSwgTWlrdWxhcyBQYXRvY2thIHdyb3RlOgo+Pj4+Pj4KPj4+Pj4+PiBTdXBwb3J0IEkvTyBw
b2xsaW5nIGlmIHN1Ym1pdF9iaW9fbm9hY2N0X21xX2RpcmVjdCByZXR1cm5lZCBub24tZW1wdHkK
Pj4+Pj4+PiBjb29raWUuCj4+Pj4+Pj4KPj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBNaWt1bGFzIFBh
dG9ja2EgPG1wYXRvY2thQHJlZGhhdC5jb20+Cj4+Pj4+Pj4KPj4+Pj4+PiAtLS0KPj4+Pj4+PiAg
wqAgZHJpdmVycy9tZC9kbS5jIHzCoMKgwqAgNSArKysrKwo+Pj4+Pj4+ICDCoCAxIGZpbGUgY2hh
bmdlZCwgNSBpbnNlcnRpb25zKCspCj4+Pj4+Pj4KPj4+Pj4+PiBJbmRleDogbGludXgtMi42L2Ry
aXZlcnMvbWQvZG0uYwo+Pj4+Pj4+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KPj4+Pj4+PiAtLS0gbGludXgtMi42Lm9y
aWcvZHJpdmVycy9tZC9kbS5jwqDCoMKgIDIwMjEtMDMtMDIKPj4+Pj4+PiAxOToyNjozNC4wMDAw
MDAwMDAgKzAxMDAKPj4+Pj4+PiArKysgbGludXgtMi42L2RyaXZlcnMvbWQvZG0uY8KgwqDCoCAy
MDIxLTAzLTAyIDE5OjI2OjM0LjAwMDAwMDAwMCArMDEwMAo+Pj4+Pj4+IEBAIC0xNjgyLDYgKzE2
ODIsMTEgQEAgc3RhdGljIHZvaWQgX19zcGxpdF9hbmRfcHJvY2Vzc19iaW8oc3RydQo+Pj4+Pj4+
ICDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+Pj4+Pj4+ICDCoMKgwqDCoMKgIH0KPj4+Pj4+PiAgwqAg
K8KgwqDCoCBpZiAoY2kucG9sbF9jb29raWUgIT0gQkxLX1FDX1RfTk9ORSkgewo+Pj4+Pj4+ICvC
oMKgwqDCoMKgwqDCoCB3aGlsZSAoYXRvbWljX3JlYWQoJmNpLmlvLT5pb19jb3VudCkgPiAxICYm
Cj4+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYmxrX3BvbGwoY2kucG9sbF9x
dWV1ZSwgY2kucG9sbF9jb29raWUsIHRydWUpKSA7Cj4+Pj4+Pj4gK8KgwqDCoCB9Cj4+Pj4+Pj4g
Kwo+Pj4+Pj4+ICDCoMKgwqDCoMKgIC8qIGRyb3AgdGhlIGV4dHJhIHJlZmVyZW5jZSBjb3VudCAq
Lwo+Pj4+Pj4+ICDCoMKgwqDCoMKgIGRlY19wZW5kaW5nKGNpLmlvLCBlcnJub190b19ibGtfc3Rh
dHVzKGVycm9yKSk7Cj4+Pj4+Pj4gIMKgIH0KPj4+Pj4+IEl0IHNlZW1zIHRoYXQgdGhlIGdlbmVy
YWwgaWRlYSBvZiB5b3VyIGRlc2lnbiBpcyB0bwo+Pj4+Pj4gMSkgc3VibWl0ICpvbmUqIHNwbGl0
IGJpbwo+Pj4+Pj4gMikgYmxrX3BvbGwoKSwgd2FpdGluZyB0aGUgcHJldmlvdXNseSBzdWJtaXR0
ZWQgc3BsaXQgYmlvIGNvbXBsZXRzCj4+Pj4+IE5vLCBJIHN1Ym1pdCBhbGwgdGhlIGJpb3MgYW5k
IHBvbGwgZm9yIHRoZSBsYXN0IG9uZS4KPj4+Pj4KPj4+Pj4+IGFuZCB0aGVuIHN1Ym1pdCBuZXh0
IHNwbGl0IGJpbywgcmVwZWF0aW5nIHRoZSBhYm92ZSBwcm9jZXNzLiBJJ20KPj4+Pj4+IGFmcmFp
ZAo+Pj4+Pj4gdGhlIHBlcmZvcm1hbmNlIG1heSBiZSBhbiBpc3N1ZSBoZXJlLCBzaW5jZSB0aGUg
YmF0Y2ggZXZlcnkgdGltZQo+Pj4+Pj4gYmxrX3BvbGwoKSByZWFwcyBtYXkgZGVjcmVhc2UuCj4+
Pj4+IENvdWxkIHlvdSBiZW5jaG1hcmsgaXQ/Cj4+Pj4gSSBvbmx5IHRlc3RlZCBkbS1saW5lYXIu
Cj4+Pj4KPj4+PiBUaGUgY29uZmlndXJhdGlvbiAoZG0gdGFibGUpIG9mIGRtLWxpbmVhciBpczoK
Pj4+PiAwIDEwNDg1NzYgbGluZWFyIC9kZXYvbnZtZTBuMSAwCj4+Pj4gMTA0ODU3NiAxMDQ4NTc2
IGxpbmVhciAvZGV2L252bWUybjEgMAo+Pj4+IDIwOTcxNTIgMTA0ODU3NiBsaW5lYXIgL2Rldi9u
dm1lNW4xIDAKPj4+Pgo+Pj4+Cj4+Pj4gZmlvIHNjcmlwdCB1c2VkIGlzOgo+Pj4+IGBgYAo+Pj4+
ICRjYXQgZmlvLmNvbmYKPj4+PiBbZ2xvYmFsXQo+Pj4+IG5hbWU9aW91cmluZy1zcXBvbGwtaW9w
b2xsLTEKPj4+PiBpb2VuZ2luZT1pb191cmluZwo+Pj4+IGlvZGVwdGg9MTI4Cj4+Pj4gbnVtam9i
cz0xCj4+Pj4gdGhyZWFkCj4+Pj4gcnc9cmFuZHJlYWQKPj4+PiBkaXJlY3Q9MQo+Pj4+IHJlZ2lz
dGVyZmlsZXM9MQo+Pj4+IGhpcHJpPTEKPj4+PiBydW50aW1lPTEwCj4+Pj4gdGltZV9iYXNlZAo+
Pj4+IGdyb3VwX3JlcG9ydGluZwo+Pj4+IHJhbmRyZXBlYXQ9MAo+Pj4+IGZpbGVuYW1lPS9kZXYv
bWFwcGVyL3Rlc3RkZXYKPj4+PiBicz00awo+Pj4+Cj4+Pj4gW2pvYi0xXQo+Pj4+IGNwdXNfYWxs
b3dlZD0xNAo+Pj4+IGBgYAo+Pj4+Cj4+Pj4gSU9QUyAoSVJRIG1vZGUpIHwgSU9QUyAoaW9wb2xs
IG1vZGUgKGhpcHJpPTEpKQo+Pj4+IC0tLS0tLS0tLS0tLS0tLSB8IC0tLS0tLS0tLS0tLS0tLS0t
LS0tCj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMjEzayB8wqDCoMKgwqDCoMKgwqDCoMKg
wqAgMTlrCj4+Pj4KPj4+PiBBdCBsZWFzdCwgaXQgZG9lc24ndCB3b3JrIHdlbGwgd2l0aCBpb191
cmluZyBpbnRlcmZhY2UuCj4+Pj4KPj4+Pgo+Pj4KPj4+IEplZmZsZSwKPj4+Cj4+PiBJIHJhbiB5
b3VyIGFib3ZlIGZpbyB0ZXN0IG9uIGEgbGluZWFyIExWIHNwbGl0IGFjcm9zcyAzIE5WTWVzIHRv
Cj4+PiBzZWNvbmQgeW91ciBzcGxpdCBtYXBwaW5nCj4+PiAoc3lzdGVtOiAzMiBjb3JlIEludGVs
LCAyNTZHaUIgUkFNKSBjb21wYXJpbmcgaW8gZW5naW5lcyBzeW5jLCBsaWJhaW8KPj4+IGFuZCBp
b191cmluZywKPj4+IHRoZSBsYXR0ZXIgdy8gYW5kIHcvbyBoaXByaSAoc3luYytsaWJhaW8gb2J2
aW91c2x5IHcvbyByZWdpc3RlcmZpbGVzCj4+PiBhbmQgaGlwcmkpIHdoaWNoIHJlc3VsdGVkIG9r
Ogo+Pj4KPj4+Cj4+Pgo+Pj4gc3luY8KgIHzCoCBsaWJhaW/CoCB8wqAgSVJRIG1vZGUgKGhpcHJp
PTApIHwgaW9wb2xsIChoaXByaT0xKQo+Pj4gLS0tLS0tfC0tLS0tLS0tLS18LS0tLS0tLS0tLS0t
LS0tLS0tLS0tfC0tLS0tLS0tLS0tLS0tLS0tIDU2LjNLIHwKPj4+IDI5MEvCoCB8wqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIDMyOUsgfMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAzNTFL
IEkgY2FuJ3Qgc2Vjb25kIHlvdXIKPj4+IGRyYXN0aWMgaGlwcmk9MSBkcm9wIGhlcmUuLi4KPj4K
Pj4gU29ycnksIGVtYWlsIG1lc3MuCj4+Cj4+Cj4+IHN5bmMgwqAgfMKgIGxpYmFpb8KgIHzCoCBJ
UlEgbW9kZSAoaGlwcmk9MCkgfCBpb3BvbGwgKGhpcHJpPTEpCj4+IC0tLS0tLS18LS0tLS0tLS0t
LXwtLS0tLS0tLS0tLS0tLS0tLS0tLS18LS0tLS0tLS0tLS0tLS0tLS0KPj4gNTYuM0vCoCB8wqDC
oMKgIDI5MEvCoCB8wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDMyOUsgfMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAzNTFLCj4+Cj4+Cj4+Cj4+IEkgY2FuJ3Qgc2Vjb25kIHlvdXIgZHJh
c3RpYyBoaXByaT0xIGRyb3AgaGVyZS4uLgo+Pgo+IEh1bW1tLCB0aGF0J3MgaW5kZWVkIHNvbWV3
aGF0IHN0cmFuZ2UuLi4KPgo+IE15IHRlc3QgZW52aXJvbm1lbnQ6Cj4gLSBDUFU6IDEyOCBjb3Jl
cywgdGhvdWdoIG9ubHkgb25lIENQVSBjb3JlIGlzIHVzZWQgc2luY2UKPiAnY3B1c19hbGxvd2Vk
PTE0JyBpbiBmaW8gY29uZmlndXJhdGlvbgo+IC0gbWVtb3J5OiA5ODNHIG1lbW9yeSBmcmVlCj4g
LSBOVk1lOiBIdWF3YWkgRVMzNTEwUCAoSFdFNTJQNDM0VDBMMDA1TiksIHdpdGggJ252bWUucG9s
bF9xdWV1ZXM9MycKPgo+IE1heWJlIHlvdSBkaWRuJ3Qgc3BlY2lmeSAnbnZtZS5wb2xsX3F1ZXVl
cz1YWFgnPyBJbiB0aGlzIGNhc2UsIElPIHN0aWxsCj4gZ29lcyBpbnRvIElSUSBtb2RlLCBldmVu
IHlvdSBoYXZlIHNwZWNpZmllZCAnaGlwcmk9MSc/Cj4KSmVmZmxlLAoKbnZtZS5wb2xsX3F1ZXVl
cyB3YXMgemVybyBpbmRlZWQuCgpBdCAzIHJlc3VsdHMgYXJlIGhpcHJpPTAgLyBoaXByaT0xIDog
MTY5OUsgLyAxNzAySyBJT1BTIChhbGwgY29yZXMpCgpTaW5nbGUgY29yZSByZXN1bHRzIDogMzE1
SyAvIDMyOUsKClN0aWxsIG5vIGV4dHJlbWUgZHJvcC4uLgoKRldJVzoKClRoYW5rcywKSGVpbnoK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

