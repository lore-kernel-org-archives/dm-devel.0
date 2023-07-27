Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50103C04A94
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690480517;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=itaO42P0gjMsewYDkY76zT8ObssCt986EorHDnM2Y/E=;
	b=EL0JwYay66cCdLaBgfbtkt5tDDvUaGopHM0Dr/MWPH8LJsPQBLB9oBhFF89jKJlx8iawGV
	BVPFwu0NcoEy4uE76MjdsnXtmpaaXZv6bEUYxkiEVTMDd0bEBEUJrVpZQNbOTfddk8VDDk
	/gxNjJyzlZz6QUAcleylc7tGulP3sMg=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-K0PDPTcyPamSfiXzeaWrqA-1; Thu, 27 Jul 2023 13:55:15 -0400
X-MC-Unique: K0PDPTcyPamSfiXzeaWrqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92B5D28237D6;
	Thu, 27 Jul 2023 17:55:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 78525207B31A;
	Thu, 27 Jul 2023 17:55:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E177A194E11A;
	Thu, 27 Jul 2023 17:54:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 581DA1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 10:32:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 469CC414A80E; Thu, 27 Jul 2023 10:32:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F418414A80D
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 10:32:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8E2729AA3B4
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 10:32:28 +0000 (UTC)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-TQYbMqA3MF-bCfgqFAyRgg-1; Thu, 27 Jul 2023 06:32:26 -0400
X-MC-Unique: TQYbMqA3MF-bCfgqFAyRgg-1
Received: by mail-pj1-f45.google.com with SMTP id
 98e67ed59e1d1-2659b1113c2so160325a91.1
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 03:32:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690453945; x=1691058745;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=4VsKgOIlO7JTMbURB3u+V7Qr/QzOpc+0Bt56AjhAYAM=;
 b=Mnaw4veS7cuAWK4ssFn0I93tbg4AgoJOPGs8tdjPz46+iBh4BgKws/envVQGjw7Jx9
 SncWus69WvpXUx48GpKc71tHxElssQv4haLM7eG+vOf02wFMx+MtB1IWo5k74he7UveJ
 IIJpX/nskhIzUwcRVTkErRZQ5gss4Wg7wBWLghQplfBwCGSwAbHT4VZlAt+3/yQCqKXf
 npYcdpA9fYF64sAChvZjcJZ3kivlLaKmzeVu4EiVcbM3tW+x4HXn2JgWJUdy+3O00kzs
 H7VcTDbns4k2WOVuFxEUYdxZOk4c8iOMEiKRCN7PwF51jBBV8x746ZoZOopMx52c/hd7
 s1kg==
X-Gm-Message-State: ABy/qLbxj3gOQTe5NFiCIt9pyqEVegMwHNWE+1cwaWFv6kIKD1ESw7pt
 rpNFIIXI6FCNib90QiiS61yVTQ==
X-Google-Smtp-Source: APBJJlGmzPZn88CMJAqpsojyTb97uikW28yo5O3pi8rH8SDlSH8BwjASuoOudfeGFyxgCSRxAf0mLA==
X-Received: by 2002:a17:90a:1b06:b0:263:2312:60c2 with SMTP id
 q6-20020a17090a1b0600b00263231260c2mr4299433pjq.3.1690453945653; 
 Thu, 27 Jul 2023 03:32:25 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 8-20020a17090a018800b0026309d57724sm2755058pjc.39.2023.07.27.03.32.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 27 Jul 2023 03:32:25 -0700 (PDT)
Message-ID: <cc819e13-cb25-ddaa-e0e3-7328f5ea3a4f@bytedance.com>
Date: Thu, 27 Jul 2023 18:32:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Damien Le Moal <dlemoal@kernel.org>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
 <20230727080502.77895-29-zhengqi.arch@bytedance.com>
 <baaf7de4-9a0e-b953-2b6a-46e60c415614@kernel.org>
 <56ee1d92-28ee-81cb-9c41-6ca7ea6556b0@bytedance.com>
 <ba0868b2-9f90-3d81-1c91-8810057fb3ce@kernel.org>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <ba0868b2-9f90-3d81-1c91-8810057fb3ce@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 27 Jul 2023 17:54:53 +0000
Subject: Re: [dm-devel] [PATCH v3 28/49] dm zoned: dynamically allocate the
 dm-zoned-meta shrinker
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
 linux-bcache@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 yujie.liu@intel.com, vbabka@suse.cz, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, tytso@mit.edu, netdev@vger.kernel.org,
 muchun.song@linux.dev, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 senozhatsky@chromium.org, gregkh@linuxfoundation.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIzLzcvMjcgMTg6MjAsIERhbWllbiBMZSBNb2FsIHdyb3RlOgo+IE9uIDcvMjcvMjMg
MTc6NTUsIFFpIFpoZW5nIHdyb3RlOgo+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBlcnI7
Cj4+Pj4gIMKgwqDCoMKgwqAgfQo+Pj4+ICDCoCArwqDCoMKgIHptZC0+bWJsa19zaHJpbmtlci0+
Y291bnRfb2JqZWN0cyA9IGRtel9tYmxvY2tfc2hyaW5rZXJfY291bnQ7Cj4+Pj4gK8KgwqDCoCB6
bWQtPm1ibGtfc2hyaW5rZXItPnNjYW5fb2JqZWN0cyA9IGRtel9tYmxvY2tfc2hyaW5rZXJfc2Nh
bjsKPj4+PiArwqDCoMKgIHptZC0+bWJsa19zaHJpbmtlci0+c2Vla3MgPSBERUZBVUxUX1NFRUtT
Owo+Pj4+ICvCoMKgwqAgem1kLT5tYmxrX3Nocmlua2VyLT5wcml2YXRlX2RhdGEgPSB6bWQ7Cj4+
Pj4gKwo+Pj4+ICvCoMKgwqAgc2hyaW5rZXJfcmVnaXN0ZXIoem1kLT5tYmxrX3Nocmlua2VyKTsK
Pj4+Cj4+PiBJIGZhaWwgdG8gc2VlIGhvdyB0aGlzIG5ldyBzaHJpbmtlciBBUEkgaXMgYmV0dGVy
Li4uIFdoeSBpc24ndCB0aGVyZSBhCj4+PiBzaHJpbmtlcl9hbGxvY19hbmRfcmVnaXN0ZXIoKSBm
dW5jdGlvbiA/IFRoYXQgd291bGQgYXZvaWQgYWRkaW5nIGFsbCB0aGlzIGNvZGUKPj4+IGFsbCBv
dmVyIHRoZSBwbGFjZSBhcyB0aGUgbmV3IEFQSSBjYWxsIHdvdWxkIGJlIHZlcnkgc2ltaWxhciB0
byB0aGUgY3VycmVudAo+Pj4gc2hyaW5rZXJfcmVnaXN0ZXIoKSBjYWxsIHdpdGggc3RhdGljIGFs
bG9jYXRpb24uCj4+Cj4+IEluIHNvbWUgcmVnaXN0cmF0aW9uIHNjZW5hcmlvcywgbWVtb3J5IG5l
ZWRzIHRvIGJlIGFsbG9jYXRlZCBpbiBhZHZhbmNlLgo+PiBTbyB3ZSBjb250aW51ZSB0byB1c2Ug
dGhlIHByZXZpb3VzIHByZWFsbG9jL3JlZ2lzdGVyX3ByZXBhcmVkKCkKPj4gYWxnb3JpdGhtLiBU
aGUgc2hyaW5rZXJfYWxsb2NfYW5kX3JlZ2lzdGVyKCkgaXMganVzdCBhIGhlbHBlciBmdW5jdGlv
bgo+PiB0aGF0IGNvbWJpbmVzIHRoZSB0d28sIGFuZCB0aGlzIGluY3JlYXNlcyB0aGUgbnVtYmVy
IG9mIEFQSXMgdGhhdAo+PiBzaHJpbmtlciBleHBvc2VzIHRvIHRoZSBvdXRzaWRlLCBzbyBJIGNo
b29zZSBub3QgdG8gYWRkIHRoaXMgaGVscGVyLgo+IAo+IEFuZCB0aGF0IHJlc3VsdHMgaW4gbW9y
ZSBjb2RlIGluIG1hbnkgcGxhY2VzIGluc3RlYWQgb2YgbGVzcyBjb2RlICsgYSBzaW1wbGUKPiBp
bmxpbmUgaGVscGVyIGluIHRoZSBzaHJpbmtlciBoZWFkZXIgZmlsZS4uLiBTbyBub3QgYWRkaW5n
IHRoYXQgc3VwZXIgc2ltcGxlCgpJdCBhbHNvIG5lZWRzIHRvIGJlIGV4cG9ydGVkIHRvIHRoZSBk
cml2ZXIgZm9yIHVzZS4KCj4gaGVscGVyIGlzIG5vdCBleGFjdGx5IHRoZSBiZXN0IGNob2ljZSBp
biBteSBvcGluaW9uLgoKSG0sIGVpdGhlciBvbmUgaXMgZmluZSBmb3IgbWUuIElmIG5vIG9uZSBl
bHNlIG9iamVjdHMsIEkgY2FuIGFkZCB0aGlzCmhlbHBlci4gOykKCj4gCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

