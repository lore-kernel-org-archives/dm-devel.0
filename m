Return-Path: <SRS0=ZVdP=FM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87ACC433FE
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 14:16:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 05A9323A33
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 14:16:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05A9323A33
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-Ad-JkFDfMbK3U107Ti8osQ-1; Tue, 08 Dec 2020 09:16:13 -0500
X-MC-Unique: Ad-JkFDfMbK3U107Ti8osQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E153107AD9A;
	Tue,  8 Dec 2020 14:15:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8CDC10002A6;
	Tue,  8 Dec 2020 14:15:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 49BF44BB7B;
	Tue,  8 Dec 2020 14:15:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B8EFsJs022210 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 09:15:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1788F2026D48; Tue,  8 Dec 2020 14:15:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11C862026D11
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 14:15:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8759B811E86
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 14:15:47 +0000 (UTC)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
	[209.85.166.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-525-EDQ5ZQp8MaCoGDrbreLkeA-1; Tue, 08 Dec 2020 09:15:43 -0500
X-MC-Unique: EDQ5ZQp8MaCoGDrbreLkeA-1
Received: by mail-io1-f52.google.com with SMTP id r9so17010655ioo.7
	for <dm-devel@redhat.com>; Tue, 08 Dec 2020 06:15:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=aFEq0S7a57DGwr5Vv73yvEZmzOjbCOIiqXWdjglEIDM=;
	b=qogbc9Mtg6UA8eiuXocOT5YCCZ6/p9AJpDBTjhVJJT/6LxrGRuGirGRG+YbL6A882g
	16YVOast8nZ1LMIxFzzaNLk3CnLeA18sD4SLQVX3XhTHpqfgsQDV8qTyl9AkaJgOJz0B
	Kg5icHB27N0jbySPNDIY8vVgeCZ10iIxkTLBD1vbkFsFcQkdxWRavrsuFO2MEE4MK8jU
	kcOiXOEEyCeI/JcIU9m5LeNqZgQ3wYDkHqxFksxqntE8fbMel0Bn+eLyGm80S7fP/Adx
	7zPH7KcX5h4N936MUtEdxZ14DxVzkEW6jcEjvK1ylCDMKhTvo4lA2FYh9ddFwZnr8r6x
	1ZZA==
X-Gm-Message-State: AOAM532lsnyVsGbkHXeFUFnFJfx9jIEA8sY3K30mVw1V6C+qHXiT+bFv
	2HZgbZBFcW2u8ub/yL57nTWYZQ==
X-Google-Smtp-Source: ABdhPJzD7k++Tng4C23t2AsnQOqZkMhInrVVHvjmUGn3gedrlrpTsFJu1dm1X/5LMt9jMiPy6Cba9Q==
X-Received: by 2002:a02:b02:: with SMTP id 2mr16161804jad.15.1607436943117;
	Tue, 08 Dec 2020 06:15:43 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
	by smtp.gmail.com with ESMTPSA id
	h70sm7716957iof.31.2020.12.08.06.15.42
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 08 Dec 2020 06:15:42 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>, Qian Cai <qcai@redhat.com>
References: <20201201165424.2030647-1-hch@lst.de>
	<920899710c9e8dcce16e561c6d832e4e9c03cd73.camel@redhat.com>
	<20201208110403.GA22179@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <cc95b9eb-6278-4b0d-6cf9-19c35714bfe7@kernel.dk>
Date: Tue, 8 Dec 2020 07:15:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201208110403.GA22179@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-s390@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, Linux Next Mailing List <linux-next@vger.kernel.org>,
	linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] store a pointer to the block_device in struct bio
	(again)
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/8/20 4:04 AM, Christoph Hellwig wrote:
> Hi Qian,
> 
> can you send me details of your device mapper setup, e.g. which targets
> are used, are they used on top of whole device or partitions.  Do you
> use partitions on top of the dm devices?  Are any other stacking devices
> involved?

Don't think this needs anything fancy at all - I know Pavel got his
test box corrupted, and mine did as well. Looks like it pretty much
affected everyone that got unlucky enough to try it, not great...

Mine is just ext4 root on nvme.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

