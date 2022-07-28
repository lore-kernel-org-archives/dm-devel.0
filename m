Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C5B5C00144
	for <dm-devel@archiver.kernel.org>; Mon,  1 Aug 2022 07:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659340060;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GRT/Q4XPmd7GYayBofvDa3Zlf/sZjU3qgf3P+QsaLvY=;
	b=E7J/dYuqItjVIZciqGuq8rc9Hzfp+dqyVtJLla0KT8ekBXMWxzw/G1hsvnoimibrm+0Dkd
	JpSyCwIG2De/b18oyZ/RXa2Icz8z1G3Id2UCDlPM8CMY5kawmn3tJ9AYQ9Ovuex1GITk81
	gI0HWqL2w2gtTh1nMkSRbXL13G593u0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-JS2DEXU2PfGN_nTIjm-XSQ-1; Mon, 01 Aug 2022 03:47:37 -0400
X-MC-Unique: JS2DEXU2PfGN_nTIjm-XSQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B87EA2806AA4;
	Mon,  1 Aug 2022 07:47:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A61892166B26;
	Mon,  1 Aug 2022 07:47:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 679711946A40;
	Mon,  1 Aug 2022 07:47:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9340E1945D85
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 15:19:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 87941403163; Thu, 28 Jul 2022 15:19:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 831E440315E
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 15:19:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A700185A7B2
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 15:19:29 +0000 (UTC)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-zYS0d3EhOGqnMqYdHDjd4w-1; Thu, 28 Jul 2022 11:19:27 -0400
X-MC-Unique: zYS0d3EhOGqnMqYdHDjd4w-1
Received: by mail-pg1-f169.google.com with SMTP id h132so1770501pgc.10
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 08:19:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
 :content-language:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=pQ1fJw+UH4q0bslSdkcMAKD/A55dsZAH6NsrWi3ntuY=;
 b=lqJJ91IvbOKIC797IvsHySPI2RTrHkCvkXUP9KyCzcGXHwnFsGmHQoVEkhKLTe8jKi
 VptAbPflQDKz/fMh5q9+0icxWZBznfjFdlPzR8ZY7x8ZYUYTmpBhaiBuipDxvDqEYWl4
 TAK3CxsUolTd/aG6H2D+y1kN1dilkctGWREXYHRdcgCzAqG4fdRaIFBmoey1SdcEeRww
 7nt1q2a251HYJ9h8rP2OophAcwNmuTuaVXB/ijkpc1b7tCdebyAPgo/dH4UWcAcWv8Xd
 WFxTAUnFfpRu4rEeoXDo0Tm25xSTuLDJR7thZXMFNupD0RQhLzw0/aqa7iu0YMA56ddH
 ryJA==
X-Gm-Message-State: AJIora/VP8j1UXTsTprta9Sj+DauUZ5pRdW6wsIoQpcTf+6A+plkBPNi
 vCgYwmHctSDXe3e3RGDQkO/ALw==
X-Google-Smtp-Source: AGRyM1uiE5loJGnLpiRRHlyA820KFf+7q1Uek3db/YZiwO8yNQb8Kd1rb7tFROXcy/mXpMQrBBH5cg==
X-Received: by 2002:a63:5b5e:0:b0:41a:5e8f:b127 with SMTP id
 l30-20020a635b5e000000b0041a5e8fb127mr22670240pgm.104.1659021566293; 
 Thu, 28 Jul 2022 08:19:26 -0700 (PDT)
Received: from ?IPV6:2601:1c0:4c00:ad20:feaa:14ff:fe3a:b225?
 ([2601:1c0:4c00:ad20:feaa:14ff:fe3a:b225])
 by smtp.gmail.com with ESMTPSA id
 r17-20020aa79ed1000000b00528c26c84a3sm917844pfq.64.2022.07.28.08.19.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 28 Jul 2022 08:19:25 -0700 (PDT)
Message-ID: <94c6cdb7-7884-b95e-da32-9e46756f6cdb@linaro.org>
Date: Thu, 28 Jul 2022 08:19:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Greg KH <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>
References: <20220718211226.506362-1-tadeusz.struk@linaro.org>
 <YtwM3uHugOOdDQZT@kroah.com> <YuKgW9BCNl8ChT/v@kroah.com>
 <20220728144520.GA18285@lst.de> <YuKkgPx2XF6rQnLq@kroah.com>
From: Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <YuKkgPx2XF6rQnLq@kroah.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Mon, 01 Aug 2022 07:47:32 +0000
Subject: Re: [dm-devel] [PATCH 5.10 1/2] block: split bio_kmalloc from
 bio_alloc_bioset
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
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <damien.lemoal@wdc.com>,
 Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, stable@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 syzbot+4f441e6ca0fcad141421@syzkaller.appspotmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 7/28/22 08:00, Greg KH wrote:
> On Thu, Jul 28, 2022 at 04:45:20PM +0200, Christoph Hellwig wrote:
>> On Thu, Jul 28, 2022 at 04:42:35PM +0200, Greg KH wrote:
>>>>> Link:https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84
>>>> Both now queued up, thanks.
>>> As was just reported, this breaks things all over the place:
>>> 	https://lore.kernel.org/r/219030d8-3408-cc9d-7aec-1fb14ab891ce@roeck-us.net
>>>
>>> Note, I also had to add lots of fix-up patches on top of these two that
>>> you missed, so odds are there are other fix-ups that I also missed.
>>>
>>> Please go and test this again, and submit ALL patches that are needed
>>> after they pass the proper testing and I will be glad to reconsider them
>>> again.
>> Why did this even get backported?  It was a cleanup that required a lot
>> of prep work, and should not by itself fix anything.
> Looks like syzkaller is reporting something odd...
> 
> Tadeusz, how was this tested?

Yes, I tested it with syzbot and locally and it fixed the syzbot reported
"kernel BUG at block/blk-mq.c:567" issue:

https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84

I only tested it with booting from ext4 fs, as I don't have any btrfs setup.

-- 
Thanks,
Tadeusz

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

