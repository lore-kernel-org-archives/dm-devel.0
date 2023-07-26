Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B047EB64DD
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 06:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690438982;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qC5ej69gqXhpKdFar8buqIf3BEOhjiQeIkPNbuXxVEE=;
	b=H7x7YwsEPACxWP2kstF1VfGJHl5ScG/HWkXQVvQqGG8iCCL+e8zvbuPL+4UyorFqAsLHt7
	1JrCkNv6F9yjYw252TafgPdWjX+1t+YrGTV92xmA6ws9FfWmJIGn0+w5lKtNaXokqKH94z
	061y94lUwPkbBzLoqIGEVDes/18784o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-WvEbQ31CNf6anEQjfEOgtQ-1; Thu, 27 Jul 2023 02:22:39 -0400
X-MC-Unique: WvEbQ31CNf6anEQjfEOgtQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DE43830DBD;
	Thu, 27 Jul 2023 06:22:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1D464C57963;
	Thu, 27 Jul 2023 06:22:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 236DB194E105;
	Thu, 27 Jul 2023 06:22:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 96A3B1946A69
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Jul 2023 09:22:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 54B9A4094DC5; Wed, 26 Jul 2023 09:22:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CF244094DC2
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 09:22:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E7C3185A78B
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 09:22:18 +0000 (UTC)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-h4-xqcj1MeW32t_6PVNeeg-1; Wed, 26 Jul 2023 05:22:16 -0400
X-MC-Unique: h4-xqcj1MeW32t_6PVNeeg-1
Received: by mail-pf1-f180.google.com with SMTP id
 d2e1a72fcca58-66d6a9851f3so1487685b3a.0
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 02:22:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690363335; x=1690968135;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=xHFf+qIXuXcHU2hnpeM9isQldhnSqSauyHf1oBu4R8I=;
 b=Apf8PK+DMLpK3W7FXZjzEi2oV2MZmSUjHOjk7jGg/1O1rdVXVafu/fMzW8iT6kFfej
 G5a0YdHDAH1FpKvLarDHM9lF3BoQzQ0IPT5wfLxoGBG8m8lyrGLCcidXxrn8nK5WGfWW
 lk6RyENhQZsLyJxpx+WUf++xbolqOs27XAoPIAS8a9sbb6wcEtJB6Z2em6fzPeyDzKo5
 WF7RuMvh8hA8mvcmcmSPhNRVmg9YDb7Jk4RulvPkOhZgkhU8wcOBlRyNUXn0KTnCas/6
 kasLy7yiDFbs1Bl9vNNbhklSYFEi08I290gr3qWq2ivS0Id8YT84jq0uMF+zof+t5pDt
 qdBg==
X-Gm-Message-State: ABy/qLb1mWRH3qtAqNJn/YVHt0nl1+f79JFnZ0LIiad3VGCkxYAMZbnD
 QuJJKx1gefD80jVfJ99HSzP9Rg==
X-Google-Smtp-Source: APBJJlGzKLkoeooTK7rnc1fJ6mfD6dUCrzzNETRC7Ci4c1Yh8zXhisYlXfajH5gn3qqQbLizO8XVQA==
X-Received: by 2002:a05:6a20:729a:b0:100:b92b:e8be with SMTP id
 o26-20020a056a20729a00b00100b92be8bemr1779967pzk.2.1690363335131; 
 Wed, 26 Jul 2023 02:22:15 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 k11-20020aa790cb000000b006827c26f147sm10955045pfk.138.2023.07.26.02.22.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 26 Jul 2023 02:22:14 -0700 (PDT)
Message-ID: <d96777ce-be8a-1665-dd00-1e696e5575a8@bytedance.com>
Date: Wed, 26 Jul 2023 17:22:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Muchun Song <muchun.song@linux.dev>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-12-zhengqi.arch@bytedance.com>
 <e7204276-9de5-17eb-90ae-e51657d73ef4@linux.dev>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <e7204276-9de5-17eb-90ae-e51657d73ef4@linux.dev>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 27 Jul 2023 06:20:49 +0000
Subject: Re: [dm-devel] [PATCH v2 11/47] gfs2: dynamically allocate the
 gfs2-qd shrinker
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
Cc: kvm@vger.kernel.org, djwong@kernel.org, roman.gushchin@linux.dev,
 david@fromorbit.com, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, cel@kernel.org,
 x86@kernel.org, steven.price@arm.com, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, paulmck@kernel.org,
 linux-arm-msm@vger.kernel.org, brauner@kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
 linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, tytso@mit.edu,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 senozhatsky@chromium.org, gregkh@linuxfoundation.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIzLzcvMjYgMTQ6NDksIE11Y2h1biBTb25nIHdyb3RlOgo+IAo+IAo+IE9uIDIwMjMv
Ny8yNCAxNzo0MywgUWkgWmhlbmcgd3JvdGU6Cj4+IFVzZSBuZXcgQVBJcyB0byBkeW5hbWljYWxs
eSBhbGxvY2F0ZSB0aGUgZ2ZzMi1xZCBzaHJpbmtlci4KPj4KPj4gU2lnbmVkLW9mZi1ieTogUWkg
WmhlbmcgPHpoZW5ncWkuYXJjaEBieXRlZGFuY2UuY29tPgo+PiAtLS0KPj4gwqAgZnMvZ2ZzMi9t
YWluLmPCoCB8wqAgNiArKystLS0KPj4gwqAgZnMvZ2ZzMi9xdW90YS5jIHwgMjYgKysrKysrKysr
KysrKysrKysrKystLS0tLS0KPj4gwqAgZnMvZ2ZzMi9xdW90YS5oIHzCoCAzICsrLQo+PiDCoCAz
IGZpbGVzIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQo+Pgo+PiBk
aWZmIC0tZ2l0IGEvZnMvZ2ZzMi9tYWluLmMgYi9mcy9nZnMyL21haW4uYwo+PiBpbmRleCBhZmNi
MzI4NTRmMTQuLmU0N2IxY2M3OWY1OSAxMDA2NDQKPj4gLS0tIGEvZnMvZ2ZzMi9tYWluLmMKPj4g
KysrIGIvZnMvZ2ZzMi9tYWluLmMKPj4gQEAgLTE0Nyw3ICsxNDcsNyBAQCBzdGF0aWMgaW50IF9f
aW5pdCBpbml0X2dmczJfZnModm9pZCkKPj4gwqDCoMKgwqDCoCBpZiAoIWdmczJfdHJhbnNfY2Fj
aGVwKQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBmYWlsX2NhY2hlcDg7Cj4+IC3CoMKgwqAg
ZXJyb3IgPSByZWdpc3Rlcl9zaHJpbmtlcigmZ2ZzMl9xZF9zaHJpbmtlciwgImdmczItcWQiKTsK
Pj4gK8KgwqDCoCBlcnJvciA9IGdmczJfcWRfc2hyaW5rZXJfaW5pdCgpOwo+PiDCoMKgwqDCoMKg
IGlmIChlcnJvcikKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gZmFpbF9zaHJpbmtlcjsKPj4g
QEAgLTE5Niw3ICsxOTYsNyBAQCBzdGF0aWMgaW50IF9faW5pdCBpbml0X2dmczJfZnModm9pZCkK
Pj4gwqAgZmFpbF93cTI6Cj4+IMKgwqDCoMKgwqAgZGVzdHJveV93b3JrcXVldWUoZ2ZzX3JlY292
ZXJ5X3dxKTsKPj4gwqAgZmFpbF93cTE6Cj4+IC3CoMKgwqAgdW5yZWdpc3Rlcl9zaHJpbmtlcigm
Z2ZzMl9xZF9zaHJpbmtlcik7Cj4+ICvCoMKgwqAgZ2ZzMl9xZF9zaHJpbmtlcl9leGl0KCk7Cj4+
IMKgIGZhaWxfc2hyaW5rZXI6Cj4+IMKgwqDCoMKgwqAga21lbV9jYWNoZV9kZXN0cm95KGdmczJf
dHJhbnNfY2FjaGVwKTsKPj4gwqAgZmFpbF9jYWNoZXA4Ogo+PiBAQCAtMjI5LDcgKzIyOSw3IEBA
IHN0YXRpYyBpbnQgX19pbml0IGluaXRfZ2ZzMl9mcyh2b2lkKQo+PiDCoCBzdGF0aWMgdm9pZCBf
X2V4aXQgZXhpdF9nZnMyX2ZzKHZvaWQpCj4+IMKgIHsKPj4gLcKgwqDCoCB1bnJlZ2lzdGVyX3No
cmlua2VyKCZnZnMyX3FkX3Nocmlua2VyKTsKPj4gK8KgwqDCoCBnZnMyX3FkX3Nocmlua2VyX2V4
aXQoKTsKPj4gwqDCoMKgwqDCoCBnZnMyX2dsb2NrX2V4aXQoKTsKPj4gwqDCoMKgwqDCoCBnZnMy
X3VucmVnaXN0ZXJfZGVidWdmcygpOwo+PiDCoMKgwqDCoMKgIHVucmVnaXN0ZXJfZmlsZXN5c3Rl
bSgmZ2ZzMl9mc190eXBlKTsKPj4gZGlmZiAtLWdpdCBhL2ZzL2dmczIvcXVvdGEuYyBiL2ZzL2dm
czIvcXVvdGEuYwo+PiBpbmRleCA3MDQxOTJiNzM2MDUuLmJjOTg4M2NlYTg0NyAxMDA2NDQKPj4g
LS0tIGEvZnMvZ2ZzMi9xdW90YS5jCj4+ICsrKyBiL2ZzL2dmczIvcXVvdGEuYwo+PiBAQCAtMTg2
LDEzICsxODYsMjcgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgZ2ZzMl9xZF9zaHJpbmtfY291bnQo
c3RydWN0IAo+PiBzaHJpbmtlciAqc2hyaW5rLAo+PiDCoMKgwqDCoMKgIHJldHVybiB2ZnNfcHJl
c3N1cmVfcmF0aW8obGlzdF9scnVfc2hyaW5rX2NvdW50KCZnZnMyX3FkX2xydSwgc2MpKTsKPj4g
wqAgfQo+PiAtc3RydWN0IHNocmlua2VyIGdmczJfcWRfc2hyaW5rZXIgPSB7Cj4+IC3CoMKgwqAg
LmNvdW50X29iamVjdHMgPSBnZnMyX3FkX3Nocmlua19jb3VudCwKPj4gLcKgwqDCoCAuc2Nhbl9v
YmplY3RzID0gZ2ZzMl9xZF9zaHJpbmtfc2NhbiwKPj4gLcKgwqDCoCAuc2Vla3MgPSBERUZBVUxU
X1NFRUtTLAo+PiAtwqDCoMKgIC5mbGFncyA9IFNIUklOS0VSX05VTUFfQVdBUkUsCj4+IC19Owo+
PiArc3RhdGljIHN0cnVjdCBzaHJpbmtlciAqZ2ZzMl9xZF9zaHJpbmtlcjsKPj4gKwo+PiAraW50
IGdmczJfcWRfc2hyaW5rZXJfaW5pdCh2b2lkKQo+IAo+IEl0J3MgYmV0dGVyIHRvIGRlY2xhcmUg
dGhpcyBhcyBfX2luaXQuCgpPSywgV2lsbCBkby4KCj4gCj4+ICt7Cj4+ICvCoMKgwqAgZ2ZzMl9x
ZF9zaHJpbmtlciA9IHNocmlua2VyX2FsbG9jKFNIUklOS0VSX05VTUFfQVdBUkUsICJnZnMyLXFk
Iik7Cj4+ICvCoMKgwqAgaWYgKCFnZnMyX3FkX3Nocmlua2VyKQo+PiArwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIC1FTk9NRU07Cj4+ICsKPj4gK8KgwqDCoCBnZnMyX3FkX3Nocmlua2VyLT5jb3VudF9v
YmplY3RzID0gZ2ZzMl9xZF9zaHJpbmtfY291bnQ7Cj4+ICvCoMKgwqAgZ2ZzMl9xZF9zaHJpbmtl
ci0+c2Nhbl9vYmplY3RzID0gZ2ZzMl9xZF9zaHJpbmtfc2NhbjsKPj4gK8KgwqDCoCBnZnMyX3Fk
X3Nocmlua2VyLT5zZWVrcyA9IERFRkFVTFRfU0VFS1M7Cj4+ICsKPj4gK8KgwqDCoCBzaHJpbmtl
cl9yZWdpc3RlcihnZnMyX3FkX3Nocmlua2VyKTsKPj4gK8KgwqDCoCByZXR1cm4gMDsKPj4gK30K
Pj4gKwo+PiArdm9pZCBnZnMyX3FkX3Nocmlua2VyX2V4aXQodm9pZCkKPj4gK3sKPj4gK8KgwqDC
oCBzaHJpbmtlcl91bnJlZ2lzdGVyKGdmczJfcWRfc2hyaW5rZXIpOwo+PiArfQo+PiDCoCBzdGF0
aWMgdTY0IHFkMmluZGV4KHN0cnVjdCBnZnMyX3F1b3RhX2RhdGEgKnFkKQo+PiDCoCB7Cj4+IGRp
ZmYgLS1naXQgYS9mcy9nZnMyL3F1b3RhLmggYi9mcy9nZnMyL3F1b3RhLmgKPj4gaW5kZXggMjFh
ZGEzMzJkNTU1Li5mOWNiODYzMzczZjcgMTAwNjQ0Cj4+IC0tLSBhL2ZzL2dmczIvcXVvdGEuaAo+
PiArKysgYi9mcy9nZnMyL3F1b3RhLmgKPj4gQEAgLTU5LDcgKzU5LDggQEAgc3RhdGljIGlubGlu
ZSBpbnQgZ2ZzMl9xdW90YV9sb2NrX2NoZWNrKHN0cnVjdCAKPj4gZ2ZzMl9pbm9kZSAqaXAsCj4+
IMKgIH0KPj4gwqAgZXh0ZXJuIGNvbnN0IHN0cnVjdCBxdW90YWN0bF9vcHMgZ2ZzMl9xdW90YWN0
bF9vcHM7Cj4+IC1leHRlcm4gc3RydWN0IHNocmlua2VyIGdmczJfcWRfc2hyaW5rZXI7Cj4+ICtp
bnQgZ2ZzMl9xZF9zaHJpbmtlcl9pbml0KHZvaWQpOwo+PiArdm9pZCBnZnMyX3FkX3Nocmlua2Vy
X2V4aXQodm9pZCk7Cj4+IMKgIGV4dGVybiBzdHJ1Y3QgbGlzdF9scnUgZ2ZzMl9xZF9scnU7Cj4+
IMKgIGV4dGVybiB2b2lkIF9faW5pdCBnZnMyX3F1b3RhX2hhc2hfaW5pdCh2b2lkKTsKPiAKCi0t
CmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1h
bi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

