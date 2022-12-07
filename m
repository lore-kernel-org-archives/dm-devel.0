Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF2EC352A1
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670418580;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wstb0CaDiJWBNWvAmH1QPzrOAqPqtEodmiTlKUtjO8Q=;
	b=O5MuAfcIs4ztJ4+V+GxIV58MjmLkN7TaM7ACIxOWGFA6DEaPm4OdZkWMx1cvzeMjf7XGft
	WNJFp3F5OOac6Fa++z8ijMRSDFLR5fKI22k1FLiWLYHY5XpFv/fnWtw8gUGUk/NT+6rhjf
	nhrINqahZc0Nek+v+si9nj555Yb3Ve4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-hFmR-PXCOe-wPgMnTmsqLw-1; Wed, 07 Dec 2022 08:09:37 -0500
X-MC-Unique: hFmR-PXCOe-wPgMnTmsqLw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60135101A54E;
	Wed,  7 Dec 2022 13:09:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D33717585;
	Wed,  7 Dec 2022 13:09:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 40F3719465B2;
	Wed,  7 Dec 2022 13:09:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 144E919465B1
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Dec 2022 13:09:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EA10840C206B; Wed,  7 Dec 2022 13:09:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E288340C2064
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 13:09:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5E4529AA384
 for <dm-devel@redhat.com>; Wed,  7 Dec 2022 13:09:26 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-661-OLmj2BAbO3mUQKentyZ3Hg-1; Wed, 07 Dec 2022 08:09:19 -0500
X-MC-Unique: OLmj2BAbO3mUQKentyZ3Hg-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4NRyKc68Wfz4f3mSH;
 Wed,  7 Dec 2022 21:09:08 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgBni9h0kJBjx41CBw--.7669S3;
 Wed, 07 Dec 2022 21:09:11 +0800 (CST)
To: Ming Lei <ming.lei@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20221206181536.13333-1-gulam.mohamed@oracle.com>
 <936a498b-19fe-36d5-ff32-817f153e57e3@huaweicloud.com>
 <Y5AFX4sxLRLV4uSt@T590>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <aadfc6d2-ad04-279c-a1d6-7f634d0b2c99@huaweicloud.com>
Date: Wed, 7 Dec 2022 21:09:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Y5AFX4sxLRLV4uSt@T590>
X-CM-TRANSID: gCh0CgBni9h0kJBjx41CBw--.7669S3
X-Coremail-Antispam: 1UD129KBjvJXoWrKF13ZrWDCw43Cw15CF1DAwb_yoW8Jr4kpr
 y3A3ZIkw48WFyFkwnFya1UJrWYvrn3ArZ8uFW5K3s7trn0kas3Jr4UG3WDCF92gFsIkF12
 gay2gas8ur48C3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9F14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
 0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
 kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
 67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
 CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
 3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
 sGvfC2KfnxnUUI43ZEXa7VUbJ73DUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
 linux-bcache@vger.kernel.org, dan.j.williams@intel.com, axboe@kernel.dk,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 philipp.reisner@linbit.com, junxiao.bi@oracle.com, minchan@kernel.org,
 lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMi8xMi8wNyAxMToxNSwgTWluZyBMZWkg5YaZ6YGTOgo+IE9uIFdlZCwgRGVj
IDA3LCAyMDIyIGF0IDEwOjE5OjA4QU0gKzA4MDAsIFl1IEt1YWkgd3JvdGU6Cj4+IEhpLAo+Pgo+
PiDlnKggMjAyMi8xMi8wNyAyOjE1LCBHdWxhbSBNb2hhbWVkIOWGmemBkzoKPj4+IFVzZSBrdGlt
ZSB0byBjaGFuZ2UgdGhlIGdyYW51bGFyaXR5IG9mIElPIGFjY291bnRpbmcgaW4gYmxvY2sgbGF5
ZXIgZnJvbQo+Pj4gbWlsbGktc2Vjb25kcyB0byBuYW5vLXNlY29uZHMgdG8gZ2V0IHRoZSBwcm9w
ZXIgbGF0ZW5jeSB2YWx1ZXMgZm9yIHRoZQo+Pj4gZGV2aWNlcyB3aG9zZSBsYXRlbmN5IGlzIGlu
IG1pY3JvLXNlY29uZHMuIEFmdGVyIGNoYW5naW5nIHRoZSBncmFudWxhcml0eQo+Pj4gdG8gbmFu
by1zZWNvbmRzIHRoZSBpb3N0YXQgY29tbWFuZCwgd2hpY2ggd2FzIHNob3dpbmcgaW5jb3JyZWN0
IHZhbHVlcyBmb3IKPj4+ICV1dGlsLCBpcyBub3cgc2hvd2luZyBjb3JyZWN0IHZhbHVlcy4KPj4K
Pj4gVGhpcyBwYXRjaCBkaWRuJ3QgY29ycmVjdCB0aGUgY291bnRpbmcgb2YgaW9fdGlja3MsIGp1
c3QgbWFrZSB0aGUKPj4gZXJyb3IgYWNjb3VudGluZyBmcm9tIGppZmZpZXMobXMpIHRvIG5zLiBU
aGUgcHJvYmxlbSB0aGF0IHV0aWwgY2FuIGJlCj4+IHNtYWxsZXIgb3IgbGFyZ2VyIHN0aWxsIGV4
aXN0Lgo+IAo+IEFncmVlLgo+IAo+Pgo+PiBIb3dldmVyLCBJIHRoaW5rIHRoaXMgY2hhbmdlIG1h
a2Ugc2Vuc2UgY29uc2lkZXIgdGhhdCBlcnJvciBtYXJnaW4gaXMKPj4gbXVjaCBzbWFsbGVyLCBh
bmQgcGVyZm9ybWFuY2Ugb3ZlcmhlYWQgc2hvdWxkIGJlIG1pbmltdW0uCj4+Cj4+IEhpLCBNaW5n
LCBob3cgZG8geW91IHRoaW5rPwo+IAo+IEkgcmVtZW1iZXJlZCB0aGF0IGt0aW1lX2dldCgpIGhh
cyBub24tbmVnbGlnaWJsZSBvdmVyaGVhZCwgaXMgdGhlcmUgYW55Cj4gdGVzdCBkYXRhKGlvcHMv
Y3B1IHV0aWxpemF0aW9uKSB3aGVuIHJ1bm5pbmcgZmlvIG9yIHQvaW9fdXJpbmcgb24KPiBudWxs
X2JsayB3aXRoIHRoaXMgcGF0Y2g/CgpZZXMsIHRlc3Rpbmcgd2l0aCBudWxsX2JsayBpcyBuZWNl
c3NhcnksIHdlIGRvbid0IHdhbnQgYW55IHBlcmZvcm1hbmNlCnJlZ3Jlc3Npb24uCgpCVFcsIEkg
dGhvdWdodCBpdCdzIGZpbmUgYmVjYXVzZSBpdCdzIGFscmVhZHkgdXNlZCBmb3IgdHJhY2tpbmcg
aW8KbGF0ZW5jeS4KPiAKPiAKPiBUaGFua3MsCj4gTWluZwo+IAo+IAo+IC4KPiAKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

