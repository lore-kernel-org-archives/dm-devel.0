Return-Path: <SRS0=vJVk=ID=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4E9C433E0
	for <dm-devel@archiver.kernel.org>; Fri,  5 Mar 2021 17:56:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 768FE650A5
	for <dm-devel@archiver.kernel.org>; Fri,  5 Mar 2021 17:56:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 768FE650A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614966986;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uFBxJfEmYC/CXRDoYWKV7mvBzlql9SaATjDzfAZ4sUo=;
	b=BBxACO6MVhLavCg2uKmoKIfqE8rmNFyBgagt01gyxVK2snFI6XHQHDlmTMgxcwUxOiHBc9
	sx7cgZr/S7NCMa3+QrmL3vXrQQ29xw0jtwVQiNGw6dl5mLcn/q3WE+JjKcAFMzcHKt0Qh+
	b7Z3xCCAA0Udm1rtoXOrwf9JBChCStQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-Gv2v5YrTNdap-Z4qeEXXuw-1; Fri, 05 Mar 2021 12:56:23 -0500
X-MC-Unique: Gv2v5YrTNdap-Z4qeEXXuw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 097E7801814;
	Fri,  5 Mar 2021 17:56:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 689CE60BF3;
	Fri,  5 Mar 2021 17:56:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 41B59C85D;
	Fri,  5 Mar 2021 17:56:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 125HuDRd024002 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Mar 2021 12:56:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4736B5D9CC; Fri,  5 Mar 2021 17:56:13 +0000 (UTC)
Received: from [192.168.1.10] (ovpn-114-106.ams2.redhat.com [10.36.114.106])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BAB35D9C0;
	Fri,  5 Mar 2021 17:56:07 +0000 (UTC)
From: Heinz Mauelshagen <heinzm@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>,
	Mikulas Patocka <mpatocka@redhat.com>
References: <20210302190555.201228400@debian-a64.vm>
	<33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
	<alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
	<157a750d-3d58-ae2e-07f1-b677c1b471c7@linux.alibaba.com>
	<bd447632-f174-e6f2-ddf8-d5385da13f6b@redhat.com>
Message-ID: <fc9707dc-0a21-90d3-ed4f-e201406c50eb@redhat.com>
Date: Fri, 5 Mar 2021 18:56:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <bd447632-f174-e6f2-ddf8-d5385da13f6b@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDMvNS8yMSA2OjQ2IFBNLCBIZWlueiBNYXVlbHNoYWdlbiB3cm90ZToKPiBPbiAzLzUvMjEg
MTA6NTIgQU0sIEplZmZsZVh1IHdyb3RlOgo+Pgo+PiBPbiAzLzMvMjEgNjowOSBQTSwgTWlrdWxh
cyBQYXRvY2thIHdyb3RlOgo+Pj4KPj4+IE9uIFdlZCwgMyBNYXIgMjAyMSwgSmVmZmxlWHUgd3Jv
dGU6Cj4+Pgo+Pj4+Cj4+Pj4gT24gMy8zLzIxIDM6MDUgQU0sIE1pa3VsYXMgUGF0b2NrYSB3cm90
ZToKPj4+Pgo+Pj4+PiBTdXBwb3J0IEkvTyBwb2xsaW5nIGlmIHN1Ym1pdF9iaW9fbm9hY2N0X21x
X2RpcmVjdCByZXR1cm5lZCBub24tZW1wdHkKPj4+Pj4gY29va2llLgo+Pj4+Pgo+Pj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBNaWt1bGFzIFBhdG9ja2EgPG1wYXRvY2thQHJlZGhhdC5jb20+Cj4+Pj4+Cj4+
Pj4+IC0tLQo+Pj4+PiDCoCBkcml2ZXJzL21kL2RtLmMgfMKgwqDCoCA1ICsrKysrCj4+Pj4+IMKg
IDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykKPj4+Pj4KPj4+Pj4gSW5kZXg6IGxpbnV4
LTIuNi9kcml2ZXJzL21kL2RtLmMKPj4+Pj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQo+Pj4+PiAtLS0gbGludXgtMi42
Lm9yaWcvZHJpdmVycy9tZC9kbS5jwqDCoMKgIDIwMjEtMDMtMDIgCj4+Pj4+IDE5OjI2OjM0LjAw
MDAwMDAwMCArMDEwMAo+Pj4+PiArKysgbGludXgtMi42L2RyaXZlcnMvbWQvZG0uY8KgwqDCoCAy
MDIxLTAzLTAyIDE5OjI2OjM0LjAwMDAwMDAwMCArMDEwMAo+Pj4+PiBAQCAtMTY4Miw2ICsxNjgy
LDExIEBAIHN0YXRpYyB2b2lkIF9fc3BsaXRfYW5kX3Byb2Nlc3NfYmlvKHN0cnUKPj4+Pj4gwqDC
oMKgwqDCoMKgwqDCoMKgIH0KPj4+Pj4gwqDCoMKgwqDCoCB9Cj4+Pj4+IMKgICvCoMKgwqAgaWYg
KGNpLnBvbGxfY29va2llICE9IEJMS19RQ19UX05PTkUpIHsKPj4+Pj4gK8KgwqDCoMKgwqDCoMKg
IHdoaWxlIChhdG9taWNfcmVhZCgmY2kuaW8tPmlvX2NvdW50KSA+IDEgJiYKPj4+Pj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYmxrX3BvbGwoY2kucG9sbF9xdWV1ZSwgY2kucG9sbF9j
b29raWUsIHRydWUpKSA7Cj4+Pj4+ICvCoMKgwqAgfQo+Pj4+PiArCj4+Pj4+IMKgwqDCoMKgwqAg
LyogZHJvcCB0aGUgZXh0cmEgcmVmZXJlbmNlIGNvdW50ICovCj4+Pj4+IMKgwqDCoMKgwqAgZGVj
X3BlbmRpbmcoY2kuaW8sIGVycm5vX3RvX2Jsa19zdGF0dXMoZXJyb3IpKTsKPj4+Pj4gwqAgfQo+
Pj4+IEl0IHNlZW1zIHRoYXQgdGhlIGdlbmVyYWwgaWRlYSBvZiB5b3VyIGRlc2lnbiBpcyB0bwo+
Pj4+IDEpIHN1Ym1pdCAqb25lKiBzcGxpdCBiaW8KPj4+PiAyKSBibGtfcG9sbCgpLCB3YWl0aW5n
IHRoZSBwcmV2aW91c2x5IHN1Ym1pdHRlZCBzcGxpdCBiaW8gY29tcGxldHMKPj4+IE5vLCBJIHN1
Ym1pdCBhbGwgdGhlIGJpb3MgYW5kIHBvbGwgZm9yIHRoZSBsYXN0IG9uZS4KPj4+Cj4+Pj4gYW5k
IHRoZW4gc3VibWl0IG5leHQgc3BsaXQgYmlvLCByZXBlYXRpbmcgdGhlIGFib3ZlIHByb2Nlc3Mu
IEknbSAKPj4+PiBhZnJhaWQKPj4+PiB0aGUgcGVyZm9ybWFuY2UgbWF5IGJlIGFuIGlzc3VlIGhl
cmUsIHNpbmNlIHRoZSBiYXRjaCBldmVyeSB0aW1lCj4+Pj4gYmxrX3BvbGwoKSByZWFwcyBtYXkg
ZGVjcmVhc2UuCj4+PiBDb3VsZCB5b3UgYmVuY2htYXJrIGl0Pwo+PiBJIG9ubHkgdGVzdGVkIGRt
LWxpbmVhci4KPj4KPj4gVGhlIGNvbmZpZ3VyYXRpb24gKGRtIHRhYmxlKSBvZiBkbS1saW5lYXIg
aXM6Cj4+IDAgMTA0ODU3NiBsaW5lYXIgL2Rldi9udm1lMG4xIDAKPj4gMTA0ODU3NiAxMDQ4NTc2
IGxpbmVhciAvZGV2L252bWUybjEgMAo+PiAyMDk3MTUyIDEwNDg1NzYgbGluZWFyIC9kZXYvbnZt
ZTVuMSAwCj4+Cj4+Cj4+IGZpbyBzY3JpcHQgdXNlZCBpczoKPj4gYGBgCj4+ICRjYXQgZmlvLmNv
bmYKPj4gW2dsb2JhbF0KPj4gbmFtZT1pb3VyaW5nLXNxcG9sbC1pb3BvbGwtMQo+PiBpb2VuZ2lu
ZT1pb191cmluZwo+PiBpb2RlcHRoPTEyOAo+PiBudW1qb2JzPTEKPj4gdGhyZWFkCj4+IHJ3PXJh
bmRyZWFkCj4+IGRpcmVjdD0xCj4+IHJlZ2lzdGVyZmlsZXM9MQo+PiBoaXByaT0xCj4+IHJ1bnRp
bWU9MTAKPj4gdGltZV9iYXNlZAo+PiBncm91cF9yZXBvcnRpbmcKPj4gcmFuZHJlcGVhdD0wCj4+
IGZpbGVuYW1lPS9kZXYvbWFwcGVyL3Rlc3RkZXYKPj4gYnM9NGsKPj4KPj4gW2pvYi0xXQo+PiBj
cHVzX2FsbG93ZWQ9MTQKPj4gYGBgCj4+Cj4+IElPUFMgKElSUSBtb2RlKSB8IElPUFMgKGlvcG9s
bCBtb2RlIChoaXByaT0xKSkKPj4gLS0tLS0tLS0tLS0tLS0tIHwgLS0tLS0tLS0tLS0tLS0tLS0t
LS0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAyMTNrIHzCoMKgwqDCoMKgwqDCoMKgwqDCoCAx
OWsKPj4KPj4gQXQgbGVhc3QsIGl0IGRvZXNuJ3Qgd29yayB3ZWxsIHdpdGggaW9fdXJpbmcgaW50
ZXJmYWNlLgo+Pgo+Pgo+Cj4KPiBKZWZmbGUsCj4KPiBJIHJhbiB5b3VyIGFib3ZlIGZpbyB0ZXN0
IG9uIGEgbGluZWFyIExWIHNwbGl0IGFjcm9zcyAzIE5WTWVzIHRvIAo+IHNlY29uZCB5b3VyIHNw
bGl0IG1hcHBpbmcKPiAoc3lzdGVtOiAzMiBjb3JlIEludGVsLCAyNTZHaUIgUkFNKSBjb21wYXJp
bmcgaW8gZW5naW5lcyBzeW5jLCBsaWJhaW8gCj4gYW5kIGlvX3VyaW5nLAo+IHRoZSBsYXR0ZXIg
dy8gYW5kIHcvbyBoaXByaSAoc3luYytsaWJhaW8gb2J2aW91c2x5IHcvbyByZWdpc3RlcmZpbGVz
IAo+IGFuZCBoaXByaSkgd2hpY2ggcmVzdWx0ZWQgb2s6Cj4KPgo+Cj4gc3luY8KgIHzCoCBsaWJh
aW/CoCB8wqAgSVJRIG1vZGUgKGhpcHJpPTApIHwgaW9wb2xsIChoaXByaT0xKSAKPiAtLS0tLS18
LS0tLS0tLS0tLXwtLS0tLS0tLS0tLS0tLS0tLS0tLS18LS0tLS0tLS0tLS0tLS0tLS0gNTYuM0sg
fMKgwqDCoCAKPiAyOTBLwqAgfMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAzMjlLIHzC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMzUxSyBJIGNhbid0IHNlY29uZCB5b3VyIAo+IGRyYXN0
aWMgaGlwcmk9MSBkcm9wIGhlcmUuLi4KCgpTb3JyeSwgZW1haWwgbWVzcy4KCgpzeW5jIMKgIHzC
oCBsaWJhaW/CoCB8wqAgSVJRIG1vZGUgKGhpcHJpPTApIHwgaW9wb2xsIChoaXByaT0xKQotLS0t
LS0tfC0tLS0tLS0tLS18LS0tLS0tLS0tLS0tLS0tLS0tLS0tfC0tLS0tLS0tLS0tLS0tLS0tCjU2
LjNLwqAgfMKgwqDCoCAyOTBLwqAgfMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAzMjlL
IHzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMzUxSwoKCgpJIGNhbid0IHNlY29uZCB5b3VyIGRy
YXN0aWMgaGlwcmk9MSBkcm9wIGhlcmUuLi4KCgo+IEhlaW56IAoKLS0KZG0tZGV2ZWwgbWFpbGlu
ZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFp
bG1hbi9saXN0aW5mby9kbS1kZXZlbA==

