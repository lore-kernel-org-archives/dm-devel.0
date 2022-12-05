Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D413FC4332F
	for <dm-devel@archiver.kernel.org>; Mon,  5 Dec 2022 18:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670264723;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GshWEusxxkj+zcbuyqgU03TQqcoRAeKPi+n9Xd1OfII=;
	b=B+CkkioJZs6nbFctDPaSsN6J3llh/yQ8LMiwHdEn6wb9XsCyOioNsw7giGeaQDMDVcZYMP
	tACrkKOcrCZ/n2X9t8p5lmAyqHQ14WK7/D0SnwABjHIlfAWxplrfkyWFQu8lfPuYvQoDIl
	iVuEg8BIwcOVJmDglGa9b7p9EKCBxvI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-FJF1aR4kPg-E02XObLClHg-1; Mon, 05 Dec 2022 13:25:20 -0500
X-MC-Unique: FJF1aR4kPg-E02XObLClHg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3385A3815D29;
	Mon,  5 Dec 2022 18:25:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 21787492B08;
	Mon,  5 Dec 2022 18:25:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F01031946589;
	Mon,  5 Dec 2022 18:25:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 346401946588
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Dec 2022 18:25:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 605D6C1D3AD; Mon,  5 Dec 2022 18:25:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 597D4C15BA8
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 18:25:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E6ED29DD987
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 18:25:11 +0000 (UTC)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-36-dvnVTXAMNQq4v1nv8TevwA-1; Mon, 05 Dec 2022 13:25:06 -0500
X-MC-Unique: dvnVTXAMNQq4v1nv8TevwA-1
Received: by mail-pg1-f173.google.com with SMTP id w37so11220778pga.5
 for <dm-devel@redhat.com>; Mon, 05 Dec 2022 10:25:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ImidpIQm24xC230ns//vzB+kQ7xYkel7WPj+tXR6tek=;
 b=NHclzeNBkZwxUMyAozXcL4ZTjtvIoK6RW1XToRRjwG+QQfdDY86YPoEx24suHuRVN3
 GYUwt12mNw1g9OKxkVc85lYZdvSsV1N39DhjGYrspLC2pvcqlTT2xNwMs9rK+3uHzVIm
 oSk3H75TuywpWE4iql9RbJRjfIXyRlLixxKgjBF49VhTMNfwMAieE9TT+wlLxy5cmLZF
 j7MoflaDw6P45dV2Z7RrrI5FfiL0vk7K5MJh9HpgeToeMghK8QTFehf/DOO+i4jnxb+g
 IfFdLm7uX6sKQSL8jDwKiT4lhP2jtoX0SIQXe8p9GtcXq3Ju2x55vIJ7RrYWd4ehFbUh
 0A5A==
X-Gm-Message-State: ANoB5pnMG8i253q67oaethJ+rAXar9aFh6+TgjcuOiA55mgT91f71jOC
 vdWjhgKwN31W2kdjTl1kv6TWsW5yXSOzzt2R
X-Google-Smtp-Source: AA0mqf6LXB3TBL6QfztXAdNGDz+SFYGDjGPt38SvDGSzimZxm0Mc+GjiJQds8/JFTJ/UbjqS/ZkzWQ==
X-Received: by 2002:a63:ce43:0:b0:476:fdde:9ac8 with SMTP id
 r3-20020a63ce43000000b00476fdde9ac8mr57775329pgi.164.1670264704207; 
 Mon, 05 Dec 2022 10:25:04 -0800 (PST)
Received: from ?IPV6:2600:380:4a37:5fe7:dac6:a7fe:6a6b:c11a?
 ([2600:380:4a37:5fe7:dac6:a7fe:6a6b:c11a])
 by smtp.gmail.com with ESMTPSA id
 ik7-20020a170902ab0700b00189529ed580sm10917190plb.60.2022.12.05.10.25.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 05 Dec 2022 10:25:03 -0800 (PST)
Message-ID: <759f50d0-75c4-7970-b145-469e87f6acc5@kernel.dk>
Date: Mon, 5 Dec 2022 11:25:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To: Alvaro Karsz <alvaro.karsz@solid-run.com>,
 virtualization@lists.linux-foundation.org
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: linux-scsi@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMTIvNS8yMiA5OjIw4oCvQU0sIEFsdmFybyBLYXJzeiB3cm90ZToKPiBJbXBsZW1lbnQgdGhl
IFZJUlRJT19CTEtfRl9MSUZFVElNRSBmZWF0dXJlIGZvciBWaXJ0SU8gYmxvY2sgZGV2aWNlcy4K
PiAKPiBUaGlzIGNvbW1pdCBpbnRyb2R1Y2VzIGEgbmV3IGlvY3RsIGNvbW1hbmQsIFZCTEtfTElG
RVRJTUUuCj4gCj4gVkJMS19MSUZFVElNRSBpb2N0bCBhc2tzIGZvciB0aGUgYmxvY2sgZGV2aWNl
IHRvIHByb3ZpZGUgbGlmZXRpbWUKPiBpbmZvcm1hdGlvbiBieSBzZW5kaW5nIGEgVklSVElPX0JM
S19UX0dFVF9MSUZFVElNRSBjb21tYW5kIHRvIHRoZSBkZXZpY2UuCgpzL1ZCTEtfTElGRVRJTUUv
VkJMS19HRVRfTElGRVRJTUUKCmZvciB0aGUgYWJvdmUuCgotLSAKSmVucyBBeGJvZQoKCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

