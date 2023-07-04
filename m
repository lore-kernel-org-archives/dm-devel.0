Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D19AEB64DC
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971636;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qMO78/xcvFDkxhdFPijFdysbyaNzhRcvA7/00OYCEUY=;
	b=WDcg60H3w9cnk7ansCozosPe2G8Sc0r1v4y+wS2eBZkW06uJOEokuuI/xG9ETQp71sJ5n7
	d3yvV4Uw3BI7DnZb13r78DN+4/RRXglBPhlX8JRWhqNXFDVyBgMhRIyUKNseAoZvzwd6w8
	v7HzZcTy4fD+SVVZw50Mxa3M7bI3qiM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-OmlGmoZdPIa4sdLQMlXADA-1; Mon, 10 Jul 2023 02:47:12 -0400
X-MC-Unique: OmlGmoZdPIa4sdLQMlXADA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01E0E185A795;
	Mon, 10 Jul 2023 06:47:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E3E18492CAC;
	Mon, 10 Jul 2023 06:47:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 24F7E1946586;
	Mon, 10 Jul 2023 06:47:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 40C041946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  4 Jul 2023 04:20:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0F449F641E; Tue,  4 Jul 2023 04:20:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 071D1F6419
 for <dm-devel@redhat.com>; Tue,  4 Jul 2023 04:20:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A25FB3C11C61
 for <dm-devel@redhat.com>; Tue,  4 Jul 2023 04:20:56 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-K5GZo77yMLSiNb4jYyOsLw-1; Tue, 04 Jul 2023 00:20:51 -0400
X-MC-Unique: K5GZo77yMLSiNb4jYyOsLw-1
Received: by mail-pl1-f182.google.com with SMTP id
 d9443c01a7336-1b7dfb95761so8348905ad.1
 for <dm-devel@redhat.com>; Mon, 03 Jul 2023 21:20:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688444450; x=1691036450;
 h=content-transfer-encoding:in-reply-to:references:cc:to:from
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=GQygWmEkN5we1RDXz7pkswh4Aib1XAu/CfaGHRydgSY=;
 b=aUEfiCDUmuq8Qt6Q+82ylYF+NmrNwvFiu1+YPOo9FFkjEy3XXDuutVCP0D6EcZ+O0n
 TuyyQWcKO/HYKsiBa6fAsh9j6JWGRBH6WLtEPXDuxtcIjf/rA/YowuDGBqgGRGk4cy7M
 lhTl/6vzUEDD76erugGDHDgwCrGaLvSflOKElow91q9M7YNViOSswfU4IB0IxUY2T9jD
 pY3IfydtasO1FYBJUM+A/hQf68kZ8CclTCMT5HJSxp5BZA//RU0K0t7AnTWjRKkqPaxq
 lusVSl6IX3h6K995Vxdl4YzhYa1KV17mHRoqqI9quz1feJbao5OsFrCsVe4EIetlMrjE
 +kWA==
X-Gm-Message-State: ABy/qLaPE7dpmEzmV1wbHKQ3182adaPw86DLQ8OKmhlVxYw5jST/oscK
 QPdj2bInvmxZVwmkE9r4BdvWkA==
X-Google-Smtp-Source: APBJJlGoap5rgOO/5AFt7nvyzJipf1m4SqVj/7RLWlsyusW9U2QREChVOt6WzCmgKb9akbjSddWJzw==
X-Received: by 2002:a17:903:94:b0:1ac:40f7:8b5a with SMTP id
 o20-20020a170903009400b001ac40f78b5amr12672869pld.3.1688444450336; 
 Mon, 03 Jul 2023 21:20:50 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 j6-20020a170902c3c600b001b8918da8d1sm3233936plj.80.2023.07.03.21.20.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 03 Jul 2023 21:20:49 -0700 (PDT)
Message-ID: <38b14080-4ce5-d300-8a0a-c630bca6806b@bytedance.com>
Date: Tue, 4 Jul 2023 12:20:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: Dave Chinner <david@fromorbit.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-25-zhengqi.arch@bytedance.com>
 <cf0d9b12-6491-bf23-b464-9d01e5781203@suse.cz>
 <ZJU708VIyJ/3StAX@dread.disaster.area>
 <a21047bb-3b87-a50a-94a7-f3fa4847bc08@bytedance.com>
 <ZJYaYv4pACmCaBoT@dread.disaster.area>
 <a7baf44a-1eb8-d4e1-d112-93cf9cdb7beb@bytedance.com>
In-Reply-To: <a7baf44a-1eb8-d4e1-d112-93cf9cdb7beb@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
Cc: djwong@kernel.org, roman.gushchin@linux.dev,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-mm@kvack.org, dm-devel@redhat.com, linux-ext4@vger.kernel.org,
 paulmck@kernel.org, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-nfs@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 Vlastimil Babka <vbabka@suse.cz>, brauner@kernel.org, tytso@mit.edu,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGkgRGF2ZSwKCk9uIDIwMjMvNi8yNCAxOTowOCwgUWkgWmhlbmcgd3JvdGU6Cj4gSGkgRGF2ZSwK
PiAKPiBPbiAyMDIzLzYvMjQgMDY6MTksIERhdmUgQ2hpbm5lciB3cm90ZToKPj4gT24gRnJpLCBK
dW4gMjMsIDIwMjMgYXQgMDk6MTA6NTdQTSArMDgwMCwgUWkgWmhlbmcgd3JvdGU6Cj4+PiBPbiAy
MDIzLzYvMjMgMTQ6MjksIERhdmUgQ2hpbm5lciB3cm90ZToKPj4+PiBPbiBUaHUsIEp1biAyMiwg
MjAyMyBhdCAwNToxMjowMlBNICswMjAwLCBWbGFzdGltaWwgQmFia2Egd3JvdGU6Cj4+Pj4+IE9u
IDYvMjIvMjMgMTA6NTMsIFFpIFpoZW5nIHdyb3RlOgo+Pj4+IFllcywgSSBzdWdnZXN0ZWQgdGhl
IElEUiByb3V0ZSBiZWNhdXNlIHJhZGl4IHRyZWUgbG9va3VwcyB1bmRlciBSQ1UKPj4+PiB3aXRo
IHJlZmVyZW5jZSBjb3VudGVkIG9iamVjdHMgYXJlIGEga25vd24gc2FmZSBwYXR0ZXJuIHRoYXQg
d2UgY2FuCj4+Pj4gZWFzaWx5IGNvbmZpcm0gaXMgY29ycmVjdCBvciBub3QuwqAgSGVuY2UgSSBz
dWdnZXN0ZWQgdGhlIHVuaWZpY2F0aW9uCj4+Pj4gKyBJRFIgcm91dGUgYmVjYXVzZSBpdCBtYWtl
cyB0aGUgbGlmZSBvZiByZXZpZXdlcnMgc28sIHNvIG11Y2gKPj4+PiBlYXNpZXIuLi4KPj4+Cj4+
PiBJbiBmYWN0LCBJIG9yaWdpbmFsbHkgcGxhbm5lZCB0byB0cnkgdGhlIHVuaWZpY2F0aW9uICsg
SURSIG1ldGhvZCB5b3UKPj4+IHN1Z2dlc3RlZCBhdCB0aGUgYmVnaW5uaW5nLiBCdXQgaW4gdGhl
IGNhc2Ugb2YgQ09ORklHX01FTUNHIGRpc2FibGVkLAo+Pj4gdGhlIHN0cnVjdCBtZW1fY2dyb3Vw
IGlzIG5vdCBldmVuIGRlZmluZWQsIGFuZCByb290X21lbV9jZ3JvdXAgYW5kCj4+PiBzaHJpbmtl
cl9pbmZvIHdpbGwgbm90IGJlIGFsbG9jYXRlZC7CoCBUaGlzIHJlcXVpcmVkIG1vcmUgY29kZSAK
Pj4+IGNoYW5nZXMsIHNvCj4+PiBJIGVuZGVkIHVwIGtlZXBpbmcgdGhlIHNocmlua2VyX2xpc3Qg
YW5kIGltcGxlbWVudGluZyB0aGUgYWJvdmUgcGF0dGVybi4KPj4KPj4gWWVzLiBHbyBiYWNrIGFu
ZCByZWFkIHdoYXQgSSBvcmlnaW5hbGx5IHNhaWQgbmVlZGVkIHRvIGJlIGRvbmUKPj4gZmlyc3Qu
IEluIHRoZSBjYXNlIG9mIENPTkZJR19NRU1DRz1uLCBhIGR1bW15IHJvb3QgbWVtY2cgc3RpbGwg
bmVlZHMKPj4gdG8gZXhpc3QgdGhhdCBob2xkcyBhbGwgb2YgdGhlIGdsb2JhbCBzaHJpbmtlcnMu
IFRoZW4gc2hyaW5rX3NsYWIoKQo+PiBpcyBvbmx5IGV2ZXIgcGFzc2VkIGEgbWVtY2cgdGhhdCBz
aG91bGQgYmUgaXRlcmF0ZWQuCj4+Cj4+IFllcywgaXQgbmVlZHMgY2hhbmdlcyBleHRlcm5hbCB0
byB0aGUgc2hyaW5rZXIgY29kZSBpdHNlbGYgdG8gYmUKPj4gbWFkZSB0byB3b3JrLiBBbmQgZXZl
biBpZiBtZW1jZydzIGFyZSBub3QgZW5hYmxlZCwgd2UgY2FuIHN0aWxsIHVzZQo+PiB0aGUgbWVt
Y2cgc3RydWN0dXJlcyB0byBlbnN1cmUgYSBjb21tb24gYWJzdHJhY3Rpb24gaXMgdXNlZCBmb3Ig
dGhlCj4+IHNocmlua2VyIHRyYWNraW5nIGluZnJhc3RydWN0dXJlLi4uLgo+IAo+IFllYWgsIHdo
YXQgSSBpbWFnaW5lZCBiZWZvcmUgd2FzIHRvIGRlZmluZSBhIG1vcmUgY29uY2lzZSBzdHJ1Y3QK
PiBtZW1fY2dyb3VwIGluIHRoZSBjYXNlIG9mIENPTkZJR19NRU1DRz1uLCB0aGVuIGFsbG9jYXRl
IGEgZHVtbXkgcm9vdAo+IG1lbWNnIG9uIHN5c3RlbSBib290Ogo+IAo+ICNpZmRlZiAhQ09ORklH
X01FTUNHCj4gCj4gc3RydWN0IHNocmlua2VyX2luZm8gewo+ICDCoMKgwqDCoHN0cnVjdCByY3Vf
aGVhZCByY3U7Cj4gIMKgwqDCoMKgYXRvbWljX2xvbmdfdCAqbnJfZGVmZXJyZWQ7Cj4gIMKgwqDC
oMKgdW5zaWduZWQgbG9uZyAqbWFwOwo+ICDCoMKgwqDCoGludCBtYXBfbnJfbWF4Owo+IH07Cj4g
Cj4gc3RydWN0IG1lbV9jZ3JvdXBfcGVyX25vZGUgewo+ICDCoMKgwqDCoHN0cnVjdCBzaHJpbmtl
cl9pbmZvIF9fcmN1wqDCoMKgICpzaHJpbmtlcl9pbmZvOwo+IH07Cj4gCj4gc3RydWN0IG1lbV9j
Z3JvdXAgewo+ICDCoMKgwqDCoHN0cnVjdCBtZW1fY2dyb3VwX3Blcl9ub2RlICpub2RlaW5mb1td
Owo+IH07Cj4gCj4gI2VuZGlmCgpUaGVzZSBkYXlzIEkgdHJpZWQgZG9pbmcgdGhpczoKCjEuIENP
TkZJR19NRU1DRyAmJiAhbWVtX2Nncm91cF9kaXNhYmxlZCgpCgogICAgdHJhY2sgYWxsIGdsb2Jh
bCBzaHJpbmtlcnMgd2l0aCByb290X21lbV9jZ3JvdXAuCgoyLiBDT05GSUdfTUVNQ0cgJiYgbWVt
X2Nncm91cF9kaXNhYmxlZCgpCgogICAgdGhlIHJvb3RfbWVtX2Nncm91cCBpcyBhbHNvIGFsbG9j
YXRlZCBpbiB0aGlzIGNhc2UsIHNvIHN0aWxsIHVzZQogICAgcm9vdF9tZW1fY2dyb3VwIHRvIHRy
YWNrIGFsbCBnbG9iYWwgc2hyaW5rZXJzLgoKMy4gIUNPTkZJR19NRU1DRwoKICAgIGFsbG9jYXRl
IGEgZHVtbXkgbWVtY2cgZHVyaW5nIHN5c3RlbSBzdGFydHVwIChhZnRlciBjZ3JvdXBfaW5pdCgp
KQogICAgYW5kIHVzZSBpdCB0byB0cmFjayBhbGwgZ2xvYmFsIHNocmlua2VycwoKVGhpcyB3b3Jr
cywgYnV0IG5lZWRzIHRvIG1vZGlmeSB0aGUgc3RhcnR1cCBvcmRlciBvZiBzb21lIHN1YnN5c3Rl
bXMsCmJlY2F1c2Ugc29tZSBzaHJpbmtlcnMgd2lsbCBiZSByZWdpc3RlcmVkIGJlZm9yZSByb290
X21lbV9jZ3JvdXAgaXMKYWxsb2NhdGVkLCBzdWNoIGFzOgoKMS4gcmN1LWtmcmVlIHNocmlua2Vy
IGluIHJjdV9pbml0KCkKMi4gc3VwZXIgYmxvY2sgc2hyaW5rZXJzIGluIHZmc19jYWNoZXNfaW5p
dCgpCgpBbmQgY2dyb3VwX2luaXQoKSBhbHNvIGRlcGVuZHMgb24gc29tZSBmaWxlIHN5c3RlbSBp
bmZyYXN0cnVjdHVyZSwgc28KSSBtYWRlIHNvbWUgY2hhbmdlcyAocm91Z2ggYW5kIHVub3JnYW5p
emVkKToKCmRpZmYgLS1naXQgYS9mcy9uYW1lc3BhY2UuYyBiL2ZzL25hbWVzcGFjZS5jCmluZGV4
IGUxNTdlZmM1NDAyMy4uNmExMmQzZDAwNjRlIDEwMDY0NAotLS0gYS9mcy9uYW1lc3BhY2UuYwor
KysgYi9mcy9uYW1lc3BhY2UuYwpAQCAtNDcwNiw3ICs0NzA2LDcgQEAgc3RhdGljIHZvaWQgX19p
bml0IGluaXRfbW91bnRfdHJlZSh2b2lkKQoKICB2b2lkIF9faW5pdCBtbnRfaW5pdCh2b2lkKQog
IHsKLSAgICAgICBpbnQgZXJyOworICAgICAgIC8vaW50IGVycjsKCiAgICAgICAgIG1udF9jYWNo
ZSA9IGttZW1fY2FjaGVfY3JlYXRlKCJtbnRfY2FjaGUiLCBzaXplb2Yoc3RydWN0IG1vdW50KSwK
ICAgICAgICAgICAgICAgICAgICAgICAgIDAsIFNMQUJfSFdDQUNIRV9BTElHTnxTTEFCX1BBTklD
fFNMQUJfQUNDT1VOVCwgCk5VTEwpOwpAQCAtNDcyNSwxNSArNDcyNSw3IEBAIHZvaWQgX19pbml0
IG1udF9pbml0KHZvaWQpCiAgICAgICAgIGlmICghbW91bnRfaGFzaHRhYmxlIHx8ICFtb3VudHBv
aW50X2hhc2h0YWJsZSkKICAgICAgICAgICAgICAgICBwYW5pYygiRmFpbGVkIHRvIGFsbG9jYXRl
IG1vdW50IGhhc2ggdGFibGVcbiIpOwoKLSAgICAgICBrZXJuZnNfaW5pdCgpOwotCi0gICAgICAg
ZXJyID0gc3lzZnNfaW5pdCgpOwotICAgICAgIGlmIChlcnIpCi0gICAgICAgICAgICAgICBwcmlu
dGsoS0VSTl9XQVJOSU5HICIlczogc3lzZnNfaW5pdCBlcnJvcjogJWRcbiIsCi0gICAgICAgICAg
ICAgICAgICAgICAgIF9fZnVuY19fLCBlcnIpOwotICAgICAgIGZzX2tvYmogPSBrb2JqZWN0X2Ny
ZWF0ZV9hbmRfYWRkKCJmcyIsIE5VTEwpOwotICAgICAgIGlmICghZnNfa29iaikKLSAgICAgICAg
ICAgICAgIHByaW50ayhLRVJOX1dBUk5JTkcgIiVzOiBrb2JqIGNyZWF0ZSBlcnJvclxuIiwgX19m
dW5jX18pOwogICAgICAgICBzaG1lbV9pbml0KCk7CiAgICAgICAgIGluaXRfcm9vdGZzKCk7CiAg
ICAgICAgIGluaXRfbW91bnRfdHJlZSgpOwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9yY3Vw
ZGF0ZS5oIGIvaW5jbHVkZS9saW51eC9yY3VwZGF0ZS5oCmluZGV4IDdkOWMyYTYzYjdjZC4uZDg3
YzY3ZjZmNjZlIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L3JjdXBkYXRlLmgKKysrIGIvaW5j
bHVkZS9saW51eC9yY3VwZGF0ZS5oCkBAIC0xMTksNiArMTE5LDcgQEAgc3RhdGljIGlubGluZSB2
b2lkIGNhbGxfcmN1X2h1cnJ5KHN0cnVjdCByY3VfaGVhZCAKKmhlYWQsIHJjdV9jYWxsYmFja190
IGZ1bmMpCgogIC8qIEludGVybmFsIHRvIGtlcm5lbCAqLwogIHZvaWQgcmN1X2luaXQodm9pZCk7
Cit2b2lkIHJjdV9zaHJpbmtlcl9pbml0KHZvaWQpOwogIGV4dGVybiBpbnQgcmN1X3NjaGVkdWxl
cl9hY3RpdmU7CiAgdm9pZCByY3Vfc2NoZWRfY2xvY2tfaXJxKGludCB1c2VyKTsKICB2b2lkIHJj
dV9yZXBvcnRfZGVhZCh1bnNpZ25lZCBpbnQgY3B1KTsKZGlmZiAtLWdpdCBhL2luaXQvbWFpbi5j
IGIvaW5pdC9tYWluLmMKaW5kZXggYWQ5MjBmYWMzMjVjLi40MTkwZmM2ZDEwYWQgMTAwNjQ0Ci0t
LSBhL2luaXQvbWFpbi5jCisrKyBiL2luaXQvbWFpbi5jCkBAIC0xMDQ5LDE0ICsxMDQ5LDIyIEBA
IHZvaWQgc3RhcnRfa2VybmVsKHZvaWQpCiAgICAgICAgIHNlY3VyaXR5X2luaXQoKTsKICAgICAg
ICAgZGJnX2xhdGVfaW5pdCgpOwogICAgICAgICBuZXRfbnNfaW5pdCgpOworICAgICAgIGtlcm5m
c19pbml0KCk7CisgICAgICAgaWYgKHN5c2ZzX2luaXQoKSkKKyAgICAgICAgICAgICAgIHByaW50
ayhLRVJOX1dBUk5JTkcgIiVzOiBzeXNmc19pbml0IGVycm9yXG4iLAorICAgICAgICAgICAgICAg
ICAgICAgICBfX2Z1bmNfXyk7CisgICAgICAgZnNfa29iaiA9IGtvYmplY3RfY3JlYXRlX2FuZF9h
ZGQoImZzIiwgTlVMTCk7CisgICAgICAgaWYgKCFmc19rb2JqKQorICAgICAgICAgICAgICAgcHJp
bnRrKEtFUk5fV0FSTklORyAiJXM6IGtvYmogY3JlYXRlIGVycm9yXG4iLCBfX2Z1bmNfXyk7Cisg
ICAgICAgcHJvY19yb290X2luaXQoKTsKKyAgICAgICBjZ3JvdXBfaW5pdCgpOwogICAgICAgICB2
ZnNfY2FjaGVzX2luaXQoKTsKICAgICAgICAgcGFnZWNhY2hlX2luaXQoKTsKICAgICAgICAgc2ln
bmFsc19pbml0KCk7CiAgICAgICAgIHNlcV9maWxlX2luaXQoKTsKLSAgICAgICBwcm9jX3Jvb3Rf
aW5pdCgpOwogICAgICAgICBuc2ZzX2luaXQoKTsKICAgICAgICAgY3B1c2V0X2luaXQoKTsKLSAg
ICAgICBjZ3JvdXBfaW5pdCgpOworICAgICAgIHJjdV9zaHJpbmtlcl9pbml0KCk7CiAgICAgICAg
IHRhc2tzdGF0c19pbml0X2Vhcmx5KCk7CiAgICAgICAgIGRlbGF5YWNjdF9pbml0KCk7CgpkaWZm
IC0tZ2l0IGEva2VybmVsL3JjdS90cmVlLmMgYi9rZXJuZWwvcmN1L3RyZWUuYwppbmRleCBkMDY4
Y2UzNTY3ZmMuLjcxYTA0YWU4ZGVmYiAxMDA2NDQKLS0tIGEva2VybmVsL3JjdS90cmVlLmMKKysr
IGIva2VybmVsL3JjdS90cmVlLmMKQEAgLTQ5NTMsNyArNDk1MywxMCBAQCBzdGF0aWMgdm9pZCBf
X2luaXQga2ZyZWVfcmN1X2JhdGNoX2luaXQodm9pZCkKICAgICAgICAgICAgICAgICBJTklUX0RF
TEFZRURfV09SSygma3JjcC0+cGFnZV9jYWNoZV93b3JrLCAKZmlsbF9wYWdlX2NhY2hlX2Z1bmMp
OwogICAgICAgICAgICAgICAgIGtyY3AtPmluaXRpYWxpemVkID0gdHJ1ZTsKICAgICAgICAgfQor
fQoKK3ZvaWQgX19pbml0IHJjdV9zaHJpbmtlcl9pbml0KHZvaWQpCit7CiAgICAgICAgIGtmcmVl
X3JjdV9zaHJpbmtlciA9IHNocmlua2VyX2FsbG9jKDAsICJyY3Uta2ZyZWUiKTsKICAgICAgICAg
aWYgKCFrZnJlZV9yY3Vfc2hyaW5rZXIpIHsKICAgICAgICAgICAgICAgICBwcl9lcnIoIkZhaWxl
ZCB0byBhbGxvY2F0ZSBrZnJlZV9yY3UoKSBzaHJpbmtlciFcbiIpOwoKSSBhZGp1c3RlZCBpdCBz
dGVwIGJ5IHN0ZXAgYWNjb3JkaW5nIHRvIHRoZSBlcnJvcnMgcmVwb3J0ZWQsIGFuZCB0aGVyZQpt
YXkgYmUgaGlkZGVuIHByb2JsZW1zIChuZWVkcyBtb3JlIHJldmlldyBhbmQgdGVzdGluZykuCgpJ
biBhZGRpdGlvbiwgdW5pZnlpbmcgdGhlIHByb2Nlc3Npbmcgb2YgZ2xvYmFsIGFuZCBtZW1jZyBz
bGFiIHNocmluawpkb2VzIGhhdmUgbWFueSBiZW5lZml0czoKCjEuIHNocmlua2VyOjpucl9kZWZl
cnJlZCBjYW4gYmUgcmVtb3ZlZAoyLiBzaHJpbmtlcl9saXN0IGNhbiBiZSByZW1vdmVkCjMuIHNp
bXBsaWZpZXMgdGhlIGV4aXN0aW5nIGNvZGUgbG9naWMgYW5kIHN1YnNlcXVlbnQgbG9ja2xlc3Mg
cHJvY2Vzc2luZwoKQnV0IEknbSBzdGlsbCBhIGJpdCBhcHByZWhlbnNpdmUgYWJvdXQgbW9kaWZ5
aW5nIHRoZSBib290IG9yZGVyLiA6KAoKV2hhdCBkbyB5b3UgdGhpbmsgYWJvdXQgdGhpcz8KClRo
YW5rcywKUWkKCgo+IAo+IEJ1dCBJIGhhdmUgYSBjb25jZXJuOiBpZiBhbGwgZ2xvYmFsIHNocmlu
a2VycyBhcmUgdHJhY2tpbmcgd2l0aCB0aGUKPiBpbmZvLT5tYXAgb2Ygcm9vdCBtZW1jZywgYSBz
aHJpbmtlci0+aWQgbmVlZHMgdG8gYmUgYXNzaWduZWQgdG8gdGhlbSwKPiB3aGljaCB3aWxsIGNh
dXNlIGluZm8tPm1hcF9ucl9tYXggdG8gYmVjb21lIGxhcmdlciB0aGFuIGJlZm9yZSwgdGhlbgo+
IG1ha2luZyB0aGUgdHJhdmVyc2FsIG9mIGluZm8tPm1hcCBzbG93ZXIuCj4gCj4+Cj4+PiBJZiB0
aGUgYWJvdmUgcGF0dGVybiBpcyBub3Qgc2FmZSwgSSB3aWxsIGdvIGJhY2sgdG8gdGhlIHVuaWZp
Y2F0aW9uICsKPj4+IElEUiBtZXRob2QuCj4+Cj4+IEFuZCB0aGF0IGlzIGV4YWN0bHkgaG93IHdl
IGdvdCBpbnRvIHRoaXMgbWVzcyBpbiB0aGUgZmlyc3QgcGxhY2UuLi4uCj4gCj4gSSBvbmx5IGZv
dW5kIG9uZSBzaW1pbGFyIHBhdHRlcm4gaW4gdGhlIGtlcm5lbDoKPiAKPiBmcy9zbWIvc2VydmVy
L29wbG9jay5jOmZpbmRfc2FtZV9sZWFzZV9rZXkvc21iX2JyZWFrX2FsbF9sZXZJSV9vcGxvY2sv
bG9va3VwX2xlYXNlX2luX3RhYmxlCj4gCj4gQnV0IElJVUMsIHRoZSByZWZjb3VudCBoZXJlIG5l
ZWRzIHRvIGJlIGRlY3JlbWVudGVkIGFmdGVyIGhvbGRpbmcKPiByY3UgbG9jayBhcyBJIGRpZCBh
Ym92ZS4KPiAKPiBTbyByZWdhcmRsZXNzIG9mIHdoZXRoZXIgd2UgY2hvb3NlIHVuaWZpY2F0aW9u
ICsgSURSIGluIHRoZSBlbmQsIEkgc3RpbGwKPiB3YW50IHRvIGNvbmZpcm0gd2hldGhlciB0aGUg
cGF0dGVybiBJIGltcGxlbWVudGVkIGFib3ZlIGlzIHNhZmUuIDopCj4gCj4gVGhhbmtzLAo+IFFp
Cj4gCj4+Cj4+IC1EYXZlCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
Cg==

