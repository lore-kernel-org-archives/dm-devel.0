Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D62C63705
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670433742;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FmMuoSNuM2bsOMYjF7IPYQN9kOfxyQ/IZlkVulEx1E8=;
	b=UgdSJHcYF2zR4BIfr7oxhDxesP+5l0nzQCMoyz6d2c5mTfKrFUvWJ+bbdkQLqrKVJcdlVu
	uI0E6RUgHYDCx1UPzzvYIyctimZF6Rd7o0JAOBEDjDK+kxIaxpUmxKF9rHGe4MWjLmbmKA
	2k+7RlCYKJnZU8FvvgfJ42YMjdbxXKQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-hO54pdjdPMmQbnGbJ0UReg-1; Wed, 07 Dec 2022 12:22:18 -0500
X-MC-Unique: hO54pdjdPMmQbnGbJ0UReg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F10512999B35;
	Wed,  7 Dec 2022 17:22:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9FBA839D7C;
	Wed,  7 Dec 2022 17:22:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B0EDB19465B9;
	Wed,  7 Dec 2022 17:22:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A7D919465B1
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Dec 2022 17:22:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BCA9F1415102; Wed,  7 Dec 2022 17:22:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B52481415100
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 17:22:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99FD486C14E
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 17:22:14 +0000 (UTC)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
 [209.85.166.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-629-S4ExOQj3Mv2oFat-8HtxeQ-2; Wed, 07 Dec 2022 12:22:13 -0500
X-MC-Unique: S4ExOQj3Mv2oFat-8HtxeQ-2
Received: by mail-io1-f52.google.com with SMTP id q190so7077384iod.10
 for <dm-devel@redhat.com>; Wed, 07 Dec 2022 09:22:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=EpTDLOhW0V3+1aR8vlaV9Hai3rR7JGPJvFehDEM1z0k=;
 b=X5VbyxiYTAlsV+cn05RmP1Ksuz6LkoZIWsoUzf32kaAG/oJm+O0tS+T9BhAKX64Vbi
 A6K9e/aqHfyGFTxAcEc3c/8ARzVG/f14gDFzIJHVgA2ugSRCNlyjcFCvbuRIk7A7YXLT
 dTYzckXSCzFVCzbeVkbwXk4ON7F2PUcRCLB9wSIjQhr3+XMbJOUiO3cDiD+2oXmHptBR
 /7S/s1Lxfq6IlxSz7Vpce7QezmiwcVEpOwTj7k9yfxCzPDiHjJImw4gGckGfbkjTxypq
 e3/EyMAtq0tK6wDOSGeoQYxYGU28o2xgR2vwma2O2Et2Gxm+w2ss1NEf95nGG8Y7FUD6
 BqQw==
X-Gm-Message-State: ANoB5plrswtoNYnV634V1Dg3MmqVmjPeVe/pIkpRvgK26iyUEZShCGDk
 1/HyRYLh8ooMC6Vw1Xr/k4kRjw==
X-Google-Smtp-Source: AA0mqf7/gBf7/XEEClF7Gq7hMc0QmhQHunFYc2f4SCWfcKxA9tFoQkk2RXV+JEDjVFWOG2u7WxQZig==
X-Received: by 2002:a05:6602:4296:b0:6e0:1464:a7d7 with SMTP id
 cd22-20020a056602429600b006e01464a7d7mr5843517iob.60.1670433732410; 
 Wed, 07 Dec 2022 09:22:12 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
 by smtp.gmail.com with ESMTPSA id
 q34-20020a056638346200b0038a44dbbd8fsm3597816jav.123.2022.12.07.09.22.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 07 Dec 2022 09:22:11 -0800 (PST)
Message-ID: <b8deb6fa-8a09-c1af-278f-24e66afe367d@kernel.dk>
Date: Wed, 7 Dec 2022 10:22:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Yu Kuai <yukuai1@huaweicloud.com>, Ming Lei <ming.lei@redhat.com>
References: <20221206181536.13333-1-gulam.mohamed@oracle.com>
 <936a498b-19fe-36d5-ff32-817f153e57e3@huaweicloud.com>
 <Y5AFX4sxLRLV4uSt@T590>
 <aadfc6d2-ad04-279c-a1d6-7f634d0b2c99@huaweicloud.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aadfc6d2-ad04-279c-a1d6-7f634d0b2c99@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [RFC] block: Change the granularity of io ticks from
 ms to ns
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
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, ira.weiny@intel.com, agk@redhat.com,
 drbd-dev@lists.linbit.com, dave.jiang@intel.com,
 christoph.boehmwalder@linbit.com, vishal.l.verma@intel.com,
 konrad.wilk@oracle.com, "yukuai \(C\)" <yukuai3@huawei.com>,
 kent.overstreet@gmail.com, ngupta@vflare.org, kch@nvidia.com,
 senozhatsky@chromium.org, Gulam Mohamed <gulam.mohamed@oracle.com>,
 snitzer@kernel.org, colyli@suse.de, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, dan.j.williams@intel.com,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 philipp.reisner@linbit.com, junxiao.bi@oracle.com, minchan@kernel.org,
 lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMTIvNy8yMiA2OjA54oCvQU0sIFl1IEt1YWkgd3JvdGU6Cj4gSGksCj4gCj4g5ZyoIDIwMjIv
MTIvMDcgMTE6MTUsIE1pbmcgTGVpIOWGmemBkzoKPj4gT24gV2VkLCBEZWMgMDcsIDIwMjIgYXQg
MTA6MTk6MDhBTSArMDgwMCwgWXUgS3VhaSB3cm90ZToKPj4+IEhpLAo+Pj4KPj4+IOWcqCAyMDIy
LzEyLzA3IDI6MTUsIEd1bGFtIE1vaGFtZWQg5YaZ6YGTOgo+Pj4+IFVzZSBrdGltZSB0byBjaGFu
Z2UgdGhlIGdyYW51bGFyaXR5IG9mIElPIGFjY291bnRpbmcgaW4gYmxvY2sgbGF5ZXIgZnJvbQo+
Pj4+IG1pbGxpLXNlY29uZHMgdG8gbmFuby1zZWNvbmRzIHRvIGdldCB0aGUgcHJvcGVyIGxhdGVu
Y3kgdmFsdWVzIGZvciB0aGUKPj4+PiBkZXZpY2VzIHdob3NlIGxhdGVuY3kgaXMgaW4gbWljcm8t
c2Vjb25kcy4gQWZ0ZXIgY2hhbmdpbmcgdGhlIGdyYW51bGFyaXR5Cj4+Pj4gdG8gbmFuby1zZWNv
bmRzIHRoZSBpb3N0YXQgY29tbWFuZCwgd2hpY2ggd2FzIHNob3dpbmcgaW5jb3JyZWN0IHZhbHVl
cyBmb3IKPj4+PiAldXRpbCwgaXMgbm93IHNob3dpbmcgY29ycmVjdCB2YWx1ZXMuCj4+Pgo+Pj4g
VGhpcyBwYXRjaCBkaWRuJ3QgY29ycmVjdCB0aGUgY291bnRpbmcgb2YgaW9fdGlja3MsIGp1c3Qg
bWFrZSB0aGUKPj4+IGVycm9yIGFjY291bnRpbmcgZnJvbSBqaWZmaWVzKG1zKSB0byBucy4gVGhl
IHByb2JsZW0gdGhhdCB1dGlsIGNhbiBiZQo+Pj4gc21hbGxlciBvciBsYXJnZXIgc3RpbGwgZXhp
c3QuCj4+Cj4+IEFncmVlLgo+Pgo+Pj4KPj4+IEhvd2V2ZXIsIEkgdGhpbmsgdGhpcyBjaGFuZ2Ug
bWFrZSBzZW5zZSBjb25zaWRlciB0aGF0IGVycm9yIG1hcmdpbiBpcwo+Pj4gbXVjaCBzbWFsbGVy
LCBhbmQgcGVyZm9ybWFuY2Ugb3ZlcmhlYWQgc2hvdWxkIGJlIG1pbmltdW0uCj4+Pgo+Pj4gSGks
IE1pbmcsIGhvdyBkbyB5b3UgdGhpbms/Cj4+Cj4+IEkgcmVtZW1iZXJlZCB0aGF0IGt0aW1lX2dl
dCgpIGhhcyBub24tbmVnbGlnaWJsZSBvdmVyaGVhZCwgaXMgdGhlcmUgYW55Cj4+IHRlc3QgZGF0
YShpb3BzL2NwdSB1dGlsaXphdGlvbikgd2hlbiBydW5uaW5nIGZpbyBvciB0L2lvX3VyaW5nIG9u
Cj4+IG51bGxfYmxrIHdpdGggdGhpcyBwYXRjaD8KPiAKPiBZZXMsIHRlc3Rpbmcgd2l0aCBudWxs
X2JsayBpcyBuZWNlc3NhcnksIHdlIGRvbid0IHdhbnQgYW55IHBlcmZvcm1hbmNlCj4gcmVncmVz
c2lvbi4KCm51bGxfYmxrIGlzIGZpbmUgYXMgYSBzdWJzdGl0dXRlLCBidXQgSSdkIG11Y2ggcmF0
aGVyIHJ1biB0aGlzIG9uIG15CnRlc3QgYmVuY2ggd2l0aCBhY3R1YWwgSU8gYW5kIGRldmljZXMu
Cgo+IEJUVywgSSB0aG91Z2h0IGl0J3MgZmluZSBiZWNhdXNlIGl0J3MgYWxyZWFkeSB1c2VkIGZv
ciB0cmFja2luZyBpbwo+IGxhdGVuY3kuCgpSZWFkaW5nIGEgbnNlYyB0aW1lc3RhbXAgaXMgYSBM
T1QgbW9yZSBleHBlbnNpdmUgdGhhbiByZWFkaW5nIGppZmZpZXMsCndoaWNoIGlzIGVzc2VudGlh
bGx5IGZyZWUuIElmIHlvdSBsb29rIGF0IHRoZSBhbW91bnQgb2Ygd29yayB0aGF0J3MKZ29uZSBp
bnRvIG1pbmltaXppbmcga3RpbWVfZ2V0KCkgZm9yIHRoZSBmYXN0IHBhdGggaW4gdGhlIElPIHN0
YWNrLAp0aGVuIHRoYXQncyBhIHRlc3RhbWVudCB0byB0aGF0LgoKU28gdGhhdCdzIGEgdmVyeSBi
YWQgYXNzdW1wdGlvbiwgYW5kIGRlZmluaXRlbHkgd3JvbmcuCgotLSAKSmVucyBBeGJvZQoKCi0t
CmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1h
bi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

