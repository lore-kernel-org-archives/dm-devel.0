Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A82C001DD
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971632;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pm15j70h8w0ju+fFIQIl0inNUYpiHP9Ln7gyZXZCOsY=;
	b=MI2HA4d+vkuioWUXbIYKEyruqJlJEt68ZFaOYGd9ShfbK+OJfNnNJUwZa4Fx5qcRDkksf7
	Y2OGU/pVwHc+LKyi075ElfgX4nzvFtMFGsMpFUbsHgH2q2CrV+VGAzxGEplRTOr25Ly1Zc
	R59HZfpl/KOs4pFhn+e1Nxah6UVhuNc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-5MqKTF4SNVCXp4RO69cm1w-1; Mon, 10 Jul 2023 02:47:07 -0400
X-MC-Unique: 5MqKTF4SNVCXp4RO69cm1w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E254388D125;
	Mon, 10 Jul 2023 06:47:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C439E4CD0D0;
	Mon, 10 Jul 2023 06:47:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6051219451EA;
	Mon, 10 Jul 2023 06:46:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B72EF1946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  5 Jul 2023 03:27:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9ED3CC478DE; Wed,  5 Jul 2023 03:27:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 96FC9C478DD
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 03:27:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74CD8185A78F
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 03:27:40 +0000 (UTC)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-Wj1gAScUOdu7Eucdz_VWPQ-1; Tue, 04 Jul 2023 23:27:38 -0400
X-MC-Unique: Wj1gAScUOdu7Eucdz_VWPQ-1
Received: by mail-pf1-f180.google.com with SMTP id
 d2e1a72fcca58-66d6a9851f3so1321875b3a.0
 for <dm-devel@redhat.com>; Tue, 04 Jul 2023 20:27:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688527657; x=1691119657;
 h=content-transfer-encoding:in-reply-to:references:cc:to:from
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=NOwOUvz1NPkWlBxAp0GPGGO2Nrixl73uZn6xROfOEj8=;
 b=KjxVza48x4yBQ/duHTOw/62Pm8B7NnVOcUtwXlqXHOoQoKQrCMSwweq87hIAr9/H9C
 Xob4Np0j9HC8k6Z2UcQ3LWP/Dt/TNBH+/k8mi5iBb3qrEi0F1Y7HWTuVMj9XSKihVj8W
 ZqItoOms9tq36iKCNFLz/em9HQ2MO67Cfjcf+WDkFY50GnYBOu/xNI29z0ki67UxIyX7
 sZ3ZVfyrFEzg3XW/OaBhwergwftj3HgYrpzpeRnPuVT/53H6vdf2zZ+2HNgJZWuMHgII
 iUW+TZd/OMUME3RL7d1odkke0Q3HF2Gjgmz3WdTRBVvlOwC+aY1+QqZKNEDtFkcsEppM
 hlRw==
X-Gm-Message-State: ABy/qLbhHrUer6F40eRbgEWk+j9FI+qQTBw7SW/Eamin4WAFOIfmN5vt
 J/PNpUOQewUFpbUit4je8UxrXw==
X-Google-Smtp-Source: APBJJlHJ/xdp2D4mprG7cOjZwHFFckWD0OnUdfulMpel6EsGVgn6d2uqpP3j7nke+gBKkBfRchiLhg==
X-Received: by 2002:a05:6a00:1f90:b0:675:8627:a291 with SMTP id
 bg16-20020a056a001f9000b006758627a291mr16245087pfb.3.1688527657628; 
 Tue, 04 Jul 2023 20:27:37 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 fe10-20020a056a002f0a00b0064fde7ae1ffsm13136627pfb.38.2023.07.04.20.27.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 04 Jul 2023 20:27:37 -0700 (PDT)
Message-ID: <733af312-fb2d-3ec4-54c8-f154447c2051@bytedance.com>
Date: Wed, 5 Jul 2023 11:27:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: paulmck@kernel.org, Dave Chinner <david@fromorbit.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-25-zhengqi.arch@bytedance.com>
 <cf0d9b12-6491-bf23-b464-9d01e5781203@suse.cz>
 <ZJU708VIyJ/3StAX@dread.disaster.area>
 <cc894c77-717a-4e9f-b649-48bab40e7c60@paulmck-laptop>
 <3efa68e0-b04f-5c11-4fe2-2db0784064fc@bytedance.com>
In-Reply-To: <3efa68e0-b04f-5c11-4fe2-2db0784064fc@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH 24/29] mm: vmscan: make global slab shrink
 lockless
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, brauner@kernel.org,
 tytso@mit.edu, djwong@kernel.org, intel-gfx@lists.freedesktop.org,
 roman.gushchin@linux.dev, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-raid@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 linux-btrfs@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
 Vlastimil Babka <vbabka@suse.cz>, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIzLzcvNCAxMTo0NSwgUWkgWmhlbmcgd3JvdGU6Cj4gCj4gCj4gT24gMjAyMy83LzQg
MDA6MzksIFBhdWwgRS4gTWNLZW5uZXkgd3JvdGU6Cj4+IE9uIEZyaSwgSnVuIDIzLCAyMDIzIGF0
IDA0OjI5OjM5UE0gKzEwMDAsIERhdmUgQ2hpbm5lciB3cm90ZToKPj4+IE9uIFRodSwgSnVuIDIy
LCAyMDIzIGF0IDA1OjEyOjAyUE0gKzAyMDAsIFZsYXN0aW1pbCBCYWJrYSB3cm90ZToKPj4+PiBP
biA2LzIyLzIzIDEwOjUzLCBRaSBaaGVuZyB3cm90ZToKPj4+Pj4gQEAgLTEwNjcsMzMgKzEwNjgs
MjcgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgc2hyaW5rX3NsYWIoZ2ZwX3QgCj4+Pj4+IGdmcF9t
YXNrLCBpbnQgbmlkLAo+Pj4+PiDCoMKgwqDCoMKgIGlmICghbWVtX2Nncm91cF9kaXNhYmxlZCgp
ICYmICFtZW1fY2dyb3VwX2lzX3Jvb3QobWVtY2cpKQo+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIHNocmlua19zbGFiX21lbWNnKGdmcF9tYXNrLCBuaWQsIG1lbWNnLCBwcmlvcml0eSk7
Cj4+Pj4+IC3CoMKgwqAgaWYgKCFkb3duX3JlYWRfdHJ5bG9jaygmc2hyaW5rZXJfcndzZW0pKQo+
Pj4+PiAtwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+Pj4+IC0KPj4+Pj4gLcKgwqDCoCBsaXN0
X2Zvcl9lYWNoX2VudHJ5KHNocmlua2VyLCAmc2hyaW5rZXJfbGlzdCwgbGlzdCkgewo+Pj4+PiAr
wqDCoMKgIHJjdV9yZWFkX2xvY2soKTsKPj4+Pj4gK8KgwqDCoCBsaXN0X2Zvcl9lYWNoX2VudHJ5
X3JjdShzaHJpbmtlciwgJnNocmlua2VyX2xpc3QsIGxpc3QpIHsKPj4+Pj4gwqDCoMKgwqDCoMKg
wqDCoMKgIHN0cnVjdCBzaHJpbmtfY29udHJvbCBzYyA9IHsKPj4+Pj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgLmdmcF9tYXNrID0gZ2ZwX21hc2ssCj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIC5uaWQgPSBuaWQsCj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC5t
ZW1jZyA9IG1lbWNnLAo+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgfTsKPj4+Pj4gK8KgwqDCoMKg
wqDCoMKgIGlmICghc2hyaW5rZXJfdHJ5X2dldChzaHJpbmtlcikpCj4+Pj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgcmN1X3JlYWRfdW5s
b2NrKCk7Cj4+Pj4KPj4+PiBJIGRvbid0IHRoaW5rIHlvdSBjYW4gZG8gdGhpcyB1bmxvY2s/Cj4+
Cj4+IFNvcnJ5IHRvIGJlIHNsb3cgdG8gcmVzcG9uZCBoZXJlLCB0aGlzIG9uZSBmZWxsIHRocm91
Z2ggdGhlIGNyYWNrcy4KPj4gQW5kIHRoYW5rIHlvdSB0byBRaSBmb3IgcmVtaW5kaW5nIG1lIQo+
Pgo+PiBJZiB5b3UgZG8gdGhpcyB1bmxvY2ssIHlvdSBoYWQgam9sbHkgd2VsbCBiZXR0ZXIgbmFp
bCBkb3duIHRoZSBjdXJyZW50Cj4+IGVsZW1lbnQgKHRoZSBvbmUgcmVmZXJlbmNlZCBieSBzaHJp
bmtlciksIGZvciBleGFtcGxlLCBieSBhY3F1aXJpbmcgYW4KPj4gZXhwbGljaXQgcmVmZXJlbmNl
IGNvdW50IG9uIHRoZSBvYmplY3QuwqAgQW5kIHByZXN1bWFibHkgdGhpcyBpcyBleGFjdGx5Cj4+
IHdoYXQgc2hyaW5rZXJfdHJ5X2dldCgpIGlzIGRvaW5nLsKgIEFuZCBhIGxvb2sgYXQgeW91ciAy
NC8yOSBjb25maXJtcyAKPj4gdGhpcywKPj4gYXQgbGVhc3QgYXNzdW1pbmcgdGhhdCBzaHJpbmtl
ci0+cmVmY291bnQgaXMgc2V0IHRvIHplcm8gYmVmb3JlIHRoZSBjYWxsCj4+IHRvIHN5bmNocm9u
aXplX3JjdSgpIGluIGZyZWVfbW9kdWxlKCkgKmFuZCogdGhhdCBzeW5jaHJvbml6ZV9yY3UoKSAK
Pj4gZG9lc24ndAo+PiBzdGFydCB1bnRpbCAqYWZ0ZXIqIHNocmlua2VyX3B1dCgpIGNhbGxzIGNv
bXBsZXRlKCkuwqAgUGx1cywgYXMgYWx3YXlzLAo+PiB0aGUgb2JqZWN0IG11c3QgYmUgcmVtb3Zl
ZCBmcm9tIHRoZSBsaXN0IGJlZm9yZSB0aGUgc3luY2hyb25pemVfcmN1KCkKPj4gc3RhcnRzLsKg
IChPbiB0aGVzZSBwYXJ0cyBvZiB0aGUgcHV6emxlLCBJIGRlZmVyIHRvIHRob3NlIG1vcmUgZmFt
aWxpYXIKPj4gd2l0aCB0aGlzIGNvZGUgcGF0aC7CoCBBbmQgSSBzdHJvbmdseSBzdWdnZXN0IGNh
cmVmdWxseSBjb21tZW50aW5nIHRoaXMKPj4gdHlwZSBvZiBhY3Rpb24tYXQtYS1kaXN0YW5jZSBk
ZXNpZ24gcGF0dGVybi4pCj4gCj4gWWVhaCwgSSB0aGluayBJJ3ZlIGRvbmUgaXQgbGlrZSBhYm92
ZS4gQSBtb3JlIGRldGFpbGVkIHRpbWluZyBkaWFncmFtIGlzCj4gYmVsb3cuCj4gCj4+Cj4+IFdo
eSBpcyB0aGlzIGltcG9ydGFudD/CoCBCZWNhdXNlIG90aGVyd2lzZSB0aGF0IG9iamVjdCBtaWdo
dCBiZSBmcmVlZAo+PiBiZWZvcmUgeW91IGdldCB0byB0aGUgY2FsbCB0byByY3VfcmVhZF9sb2Nr
KCkgYXQgdGhlIGVuZCBvZiB0aGlzIGxvb3AuCj4+IEFuZCBpZiB0aGF0IGhhcHBlbnMsIGxpc3Rf
Zm9yX2VhY2hfZW50cnlfcmN1KCkgd2lsbCBiZSB3YWxraW5nIHRoZQo+PiBmcmVlbGlzdCwgd2hp
Y2ggaXMgcXVpdGUgYmFkIGZvciB0aGUgaGVhbHRoIGFuZCB3ZWxsLWJlaW5nIG9mIHlvdXIgCj4+
IGtlcm5lbC4KPj4KPj4gVGhlcmUgYXJlIGEgZmV3IG90aGVyIHdheXMgdG8gbWFrZSB0aGlzIHNv
cnQgb2YgdGhpbmcgd29yazoKPj4KPj4gMS7CoMKgwqAgRGVmZXIgdGhlIHNocmlua2VyX3B1dCgp
IHRvIHRoZSBiZWdpbm5pbmcgb2YgdGhlIGxvb3AuCj4+IMKgwqDCoMKgWW91IHdvdWxkIG5lZWQg
YSBmbGFnIGluaXRpYWxseSBzZXQgdG8gemVybywgYW5kIHRoZW4gc2V0IHRvCj4+IMKgwqDCoMKg
b25lIGp1c3QgYmVmb3JlIChvciBqdXN0IGFmdGVyKSB0aGUgcmN1X3JlYWRfbG9jaygpIGFib3Zl
Lgo+PiDCoMKgwqDCoFlvdSB3b3VsZCBhbHNvIG5lZWQgYW5vdGhlciBzaHJpbmtlcl9vbGQgcG9p
bnRlciB0byB0cmFjayB0aGUKPj4gwqDCoMKgwqBvbGQgcG9pbnRlci7CoCBUaGVuIGF0IHRoZSB0
b3Agb2YgdGhlIGxvb3AsIGlmIHRoZSBmbGFnIGlzIHNldCwKPj4gwqDCoMKgwqBpbnZva2Ugc2hy
aW5rZXJfcHV0KCkgb24gc2hyaW5rZXJfb2xkLsKgwqDCoCBUaGlzIGVuc3VyZXMgdGhhdCB0aGUK
Pj4gwqDCoMKgwqBwcmV2aW91cyBzaHJpbmtlciBzdHJ1Y3R1cmUgc3RheXMgYXJvdW5kIGxvbmcg
ZW5vdWdoIHRvIGFsbG93Cj4+IMKgwqDCoMKgdGhlIGxvb3AgdG8gZmluZCB0aGUgbmV4dCBzaHJp
bmtlciBzdHJ1Y3R1cmUgaW4gdGhlIGxpc3QuCj4+Cj4+IMKgwqDCoMKgVGhpcyBhcHByb2FjaCBp
cyBhdHRyYWN0aXZlIHdoZW4gdGhlIHJlbW92YWwgY29kZSBwYXRoCj4+IMKgwqDCoMKgY2FuIGlu
dm9rZSBzaHJpbmtlcl9wdXQoKSBhZnRlciB0aGUgZ3JhY2UgcGVyaW9kIGVuZHMuCj4+Cj4+IDIu
wqDCoMKgIE1ha2Ugc2hyaW5rZXJfcHV0KCkgaW52b2tlIGNhbGxfcmN1KCkgd2hlbiAtPnJlZmNv
dW50IHJlYWNoZXMKPj4gwqDCoMKgwqB6ZXJvLCBhbmQgaGF2ZSB0aGUgY2FsbGJhY2sgZnVuY3Rp
b24gZnJlZSB0aGUgb2JqZWN0LsKgIFRoaXMgb2YKPj4gwqDCoMKgwqBjb3Vyc2UgcmVxdWlyZXMg
YWRkaW5nIGFuIHJjdV9oZWFkIHN0cnVjdHVyZSB0byB0aGUgc2hyaW5rZXIKPj4gwqDCoMKgwqBz
dHJ1Y3R1cmUsIHdoaWNoIG1pZ2h0IG9yIG1pZ2h0IG5vdCBiZSBhIHJlYXNvbmFibGUgY291cnNl
IG9mCj4+IMKgwqDCoMKgYWN0aW9uLsKgIElmIGFkZGluZyB0aGF0IHJjdV9oZWFkIGlzIHJlYXNv
bmFibGUsIHRoaXMgc2ltcGxpZmllcwo+PiDCoMKgwqDCoHRoZSBsb2dpYyBxdWl0ZSBhIGJpdC4K
Pj4KPj4gMy7CoMKgwqAgRm9yIHRoZSBzaHJpbmtlci1zdHJ1Y3R1cmUtcmVtb3ZhbCBjb2RlIHBh
dGgsIHJlbW92ZSB0aGUgc2hyaW5rZXIKPj4gwqDCoMKgwqBzdHJ1Y3R1cmUsIHRoZW4gcmVtb3Zl
IHRoZSBpbml0aWFsIGNvdW50IGZyb20gLT5yZWZjb3VudCwKPj4gwqDCoMKgwqBhbmQgdGhlbiBr
ZWVwIGRvaW5nIGdyYWNlIHBlcmlvZHMgdW50aWwgLT5yZWZjb3VudCBpcyB6ZXJvLAo+PiDCoMKg
wqDCoHRoZW4gZG8gb25lIG1vcmUuwqAgT2YgY291cnNlLCBpZiB0aGUgcmVzdWx0IG9mIHJlbW92
aW5nIHRoZQo+PiDCoMKgwqDCoGluaXRpYWwgY291bnQgd2FzIHplcm8sIHRoZW4gb25seSBhIHNp
bmdsZSBhZGRpdGlvbmFsIGdyYWNlCj4+IMKgwqDCoMKgcGVyaW9kIGlzIHJlcXVpcmVkLgo+Pgo+
PiDCoMKgwqDCoFRoaXMgd291bGQgbmVlZCB0byBiZSBjYXJlZnVsbHkgY29tbWVudGVkLCBhcyBp
dCBpcyBhIGJpdAo+PiDCoMKgwqDCoHVuY29udmVudGlvbmFsLgo+IAo+IFRoYW5rcyBmb3Igc3Vj
aCBhIGRldGFpbGVkIGFkZGl0aW9uIQo+IAo+Pgo+PiBUaGVyZSBhcmUgcHJvYmFibHkgbWFueSBv
dGhlciB3YXlzLCBidXQganVzdCB0byBnaXZlIGFuIGlkZWEgb2YgYSBmZXcKPj4gb3RoZXIgd2F5
cyB0byBkbyB0aGlzLgo+Pgo+Pj4+PiArCj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBk
b19zaHJpbmtfc2xhYigmc2MsIHNocmlua2VyLCBwcmlvcml0eSk7Cj4+Pj4+IMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAocmV0ID09IFNIUklOS19FTVBUWSkKPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcmV0ID0gMDsKPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIGZyZWVkICs9IHJldDsK
Pj4+Pj4gLcKgwqDCoMKgwqDCoMKgIC8qCj4+Pj4+IC3CoMKgwqDCoMKgwqDCoMKgICogQmFpbCBv
dXQgaWYgc29tZW9uZSB3YW50IHRvIHJlZ2lzdGVyIGEgbmV3IHNocmlua2VyIHRvCj4+Pj4+IC3C
oMKgwqDCoMKgwqDCoMKgICogcHJldmVudCB0aGUgcmVnaXN0cmF0aW9uIGZyb20gYmVpbmcgc3Rh
bGxlZCBmb3IgbG9uZyAKPj4+Pj4gcGVyaW9kcwo+Pj4+PiAtwqDCoMKgwqDCoMKgwqDCoCAqIGJ5
IHBhcmFsbGVsIG9uZ29pbmcgc2hyaW5raW5nLgo+Pj4+PiAtwqDCoMKgwqDCoMKgwqDCoCAqLwo+
Pj4+PiAtwqDCoMKgwqDCoMKgwqAgaWYgKHJ3c2VtX2lzX2NvbnRlbmRlZCgmc2hyaW5rZXJfcndz
ZW0pKSB7Cj4+Pj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGZyZWVkID0gZnJlZWQgPyA6IDE7
Cj4+Pj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4+PiAtwqDCoMKgwqDCoMKg
wqAgfQo+Pj4+PiAtwqDCoMKgIH0KPj4+Pj4gLcKgwqDCoCB1cF9yZWFkKCZzaHJpbmtlcl9yd3Nl
bSk7Cj4+Pj4+IC1vdXQ6Cj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCByY3VfcmVhZF9sb2NrKCk7Cj4+
Pj4KPj4+PiBUaGF0IG5ldyByY3VfcmVhZF9sb2NrKCkgd29uJ3QgaGVscCBBRkFJSywgdGhlIHdo
b2xlCj4+Pj4gbGlzdF9mb3JfZWFjaF9lbnRyeV9yY3UoKSBuZWVkcyB0byBiZSB1bmRlciB0aGUg
c2luZ2xlIAo+Pj4+IHJjdV9yZWFkX2xvY2soKSB0byBiZQo+Pj4+IHNhZmUuCj4+Pgo+Pj4gWWVh
aCwgdGhhdCdzIHRoZSBwYXR0ZXJuIHdlJ3ZlIGJlZW4gdGF1Z2h0IGFuZCB0aGUgb25lIHdlIGNh
biBsb29rCj4+PiBhdCBhbmQgaW1tZWRpYXRlbHkgc2F5ICJ0aGlzIGlzIHNhZmUiLgo+Pj4KPj4+
IFRoaXMgaXMgYSBkaWZmZXJlbnQgcGF0dGVybiwgYXMgaGFzIGJlZW4gZXhwbGFpbmVkIGJpIFFp
LCBhbmQgSQo+Pj4gdGhpbmsgaXQgKm1pZ2h0KiBiZSBzYWZlLgo+Pj4KPj4+ICpIb3dldmVyLioK
Pj4+Cj4+PiBSaWdodCBub3cgSSBkb24ndCBoYXZlIHRpbWUgdG8gZ28gdGhyb3VnaCBhIG5vdmVs
IFJDVSBsaXN0IGl0ZXJhdGlvbgo+Pj4gcGF0dGVybiBpdCBvbmUgc3RlcCBhdCB0byBkZXRlcm1p
bmUgdGhlIGNvcnJlY3RuZXNzIG9mIHRoZQo+Pj4gYWxnb3JpdGhtLiBJJ20gbW9zdGx5IHdvcnJp
ZWQgYWJvdXQgbGlzdCBtYW5pcHVsYXRpb25zIHRoYXQgY2FuCj4+PiBvY2N1ciBvdXRzaWRlIHJj
dV9yZWFkX2xvY2soKSBzZWN0aW9uIGJsZWVkaW5nIGludG8gdGhlIFJDVQo+Pj4gY3JpdGljYWwg
c2VjdGlvbiBiZWNhdXNlIHJjdV9yZWFkX2xvY2soKSBieSBpdHNlbGYgaXMgbm90IGEgbWVtb3J5
Cj4+PiBiYXJyaWVyLgo+Pj4KPj4+IE1heWJlIFBhdWwgaGFzIHNlZW4gdGhpcyBwYXR0ZXJuIG9m
dGVuIGVub3VnaCBoZSBjb3VsZCBzaW1wbHkgdGVsbAo+Pj4gdXMgd2hhdCBjb25kaXRpb25zIGl0
IGlzIHNhZmUgaW4uIEJ1dCBmb3IgbWUgdG8gd29yayB0aGF0IG91dCBmcm9tCj4+PiBmaXJzdCBw
cmluY2lwbGVzPyBJIGp1c3QgZG9uJ3QgaGF2ZSB0aGUgdGltZSB0byBkbyB0aGF0IHJpZ2h0IG5v
dy4KPj4KPj4gSWYgdGhlIGNvZGUgZG9lcyBqdXN0IHRoZSByaWdodCBzZXF1ZW5jZSBvZiB0aGlu
Z3Mgb24gdGhlIHJlbW92YWwgcGF0aAo+PiAocmVtb3ZlLCBkZWNyZW1lbnQgcmVmZXJlbmNlLCB3
YWl0IGZvciByZWZlcmVuY2UgdG8gZ28gdG8gemVybywgd2FpdCBmb3IKPj4gZ3JhY2UgcGVyaW9k
LCBmcmVlKSwgdGhlbiBpdCB3b3VsZCB3b3JrLsKgIElmIHRoaXMgaXMgd2hhdCBpcyBoYXBwZW5p
bmcsCj4+IEkgd291bGQgYXJndWUgZm9yIG1vcmUgY29tbWVudHMuwqAgOy0pCj4gCj4gVGhlIG9y
ZGVyIG9mIHRoZSByZW1vdmFsIHBhdGggaXMgc2xpZ2h0bHkgZGlmZmVyZW50IGZyb20gdGhpczoK
PiAKPiAgwqDCoMKgIHNocmlua19zbGFiwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
dW5yZWdpc3Rlcl9zaHJpbmtlcgo+ICDCoMKgwqAgPT09PT09PT09PT3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCA9PT09PT09PT09PT09PT09PT09Cj4gCj4gIMKgwqAgc2hyaW5rZXJf
dHJ5X2dldCgpCj4gIMKgwqAgcmN1X3JlYWRfdW5sb2NrKCkKPiAgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMS4gZGVjcmVtZW50
IGluaXRpYWwgcmVmZXJlbmNlCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzaHJp
bmtlcl9wdXQoKQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMi4gd2FpdCBmb3Ig
cmVmZXJlbmNlIHRvIGdvIHRvIHplcm8KPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHdhaXRfZm9yX2NvbXBsZXRpb24oKQo+ICDCoMKgIHJjdV9yZWFkX2xvY2soKQo+IAo+ICDCoMKg
IHNocmlua2VyX3B1dCgpCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAzLiByZW1v
dmUgdGhlIHNocmlua2VyIGZyb20gbGlzdAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgbGlzdF9kZWxfcmN1KCkKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgNC4gd2FpdCBmb3IgZ3JhY2UgcGVyaW9kCj4gIMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrZnJlZV9yY3UoKS9zeW5jaHJvbml6ZV9yY3Uo
KQo+IAo+IAo+ICDCoMKgIGxpc3RfZm9yX2VhY2hfZW50cnkoKQo+IAo+ICDCoMKgIHNocmlua2Vy
X3RyeV9nZXQoKQo+ICDCoMKgIHJjdV9yZWFkX3VubG9jaygpCj4gIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCA1LiBmcmVlIHRoZSBzaHJpbmtlcgo+IAo+IFNvIHRoZSBvcmRlciBpczog
ZGVjcmVtZW50IHJlZmVyZW5jZSwgd2FpdCBmb3IgcmVmZXJlbmNlIHRvIGdvIHRvIHplcm8sCj4g
cmVtb3ZlLCB3YWl0IGZvciBncmFjZSBwZXJpb2QsIGZyZWUuCj4gCj4gSSB0aGluayB0aGlzIGNh
biB3b3JrLiBBbmQgd2UgY2FuIG9ubHkgZG8gdGhlICpzdGVwIDMqIGFmdGVyIHdlIGhvbGQgdGhl
Cj4gUkNVIHJlYWQgbG9jayBhZ2FpbiwgcmlnaHQ/IFBsZWFzZSBsZXQgbWUga25vdyBpZiBJIG1p
c3NlZCBzb21ldGhpbmcuCgpPaCwgeW91IGFyZSByaWdodCwgSXQgd291bGQgYmUgYmV0dGVyIHRv
IG1vdmUgc3RlcCAzIHRvIHN0ZXAgMS4gV2UKc2hvdWxkIGZpcnN0IHJlbW92ZSB0aGUgc2hyaW5r
ZXIgZnJvbSB0aGUgc2hyaW5rZXJfbGlzdCB0byBwcmV2ZW50Cm90aGVyIHRyYXZlcnNlcnMgZnJv
bSBmaW5kaW5nIGl0IGFnYWluLCBvdGhlcndpc2UgdGhlIGZvbGxvd2luZwpzaXR1YXRpb25zIG1h
eSBvY2N1ciB0aGVvcmV0aWNhbGx5OgoKQ1BVIDAgICAgICAgICAgICAgICAgIENQVSAxCgpzaHJp
bmtlcl90cnlfZ2V0KCkKCiAgICAgICAgICAgICAgICAgICAgICAgc2hyaW5rZXJfdHJ5X2dldCgp
CgpzaHJpbmtlcl9wdXQoKQpzaHJpbmtlcl90cnlfZ2V0KCkKICAgICAgICAgICAgICAgICAgICAg
ICBzaHJpbmtlcl9wdXQoKQoKVGhhbmtzLApRaQoKPiAKPiBUaGFua3MsCj4gUWkKPiAKPj4KPj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFRo
YW54LCBQYXVsCj4+Cj4+Pj4gSUlVQyB0aGlzIGlzIHdoeSBEYXZlIGluIFs0XSBzdWdnZXN0cyB1
bmlmeWluZyBzaHJpbmtfc2xhYigpIHdpdGgKPj4+PiBzaHJpbmtfc2xhYl9tZW1jZygpLCBhcyB0
aGUgbGF0dGVyIGRvZXNuJ3QgaXRlcmF0ZSB0aGUgbGlzdCBidXQgdXNlcyAKPj4+PiBJRFIuCj4+
Pgo+Pj4gWWVzLCBJIHN1Z2dlc3RlZCB0aGUgSURSIHJvdXRlIGJlY2F1c2UgcmFkaXggdHJlZSBs
b29rdXBzIHVuZGVyIFJDVQo+Pj4gd2l0aCByZWZlcmVuY2UgY291bnRlZCBvYmplY3RzIGFyZSBh
IGtub3duIHNhZmUgcGF0dGVybiB0aGF0IHdlIGNhbgo+Pj4gZWFzaWx5IGNvbmZpcm0gaXMgY29y
cmVjdCBvciBub3QuwqAgSGVuY2UgSSBzdWdnZXN0ZWQgdGhlIHVuaWZpY2F0aW9uCj4+PiArIElE
UiByb3V0ZSBiZWNhdXNlIGl0IG1ha2VzIHRoZSBsaWZlIG9mIHJldmlld2VycyBzbywgc28gbXVj
aAo+Pj4gZWFzaWVyLi4uCj4+Pgo+Pj4gQ2hlZXJzLAo+Pj4KPj4+IERhdmUuCj4+PiAtLSAKPj4+
IERhdmUgQ2hpbm5lcgo+Pj4gZGF2aWRAZnJvbW9yYml0LmNvbQoKLS0KZG0tZGV2ZWwgbWFpbGlu
ZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFp
bG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

