Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A493C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 15:33:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1F7E960F70
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 15:33:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1F7E960F70
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636731190;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jNCwPc5/JFhx0Ch6G9N5xpI/42yHkjSQWszOReUx/9M=;
	b=BJ/y3eG3HJXq/gXeesHjbLpzcEygvL6iL9jt1fHROtv3OyWGoMF6tLm6Lt7SggXPtTn+EA
	3L/xm7mH993D1wu3nRnwkCdR6EfBmD+ty+B6bLWots+18xyvXd1YsDl21jcXgyLKds3G5X
	23uNoMch/4wqAfLEdl40KRYgKaw01zM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90--d2lKGr9NiaEbY9etVfWfA-1; Fri, 12 Nov 2021 10:33:05 -0500
X-MC-Unique: -d2lKGr9NiaEbY9etVfWfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67515192204E;
	Fri, 12 Nov 2021 15:33:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1603657CA4;
	Fri, 12 Nov 2021 15:33:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AB15C181A1CF;
	Fri, 12 Nov 2021 15:33:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACFWxUO015601 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 10:32:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A256D404727D; Fri, 12 Nov 2021 15:32:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EB14404727C
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 15:32:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A8D9185A79C
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 15:32:59 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
	[209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-332-EHp8bvFTM3O_CqFCBmQC7g-1; Fri, 12 Nov 2021 10:32:58 -0500
X-MC-Unique: EHp8bvFTM3O_CqFCBmQC7g-1
Received: by mail-qv1-f72.google.com with SMTP id
	z8-20020a0cd788000000b00384d92a0f11so8606936qvi.17
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 07:32:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=e4zeaKoPJyivwN5DGJjUIF/YNhCYhAbNgC5OLn3TBFg=;
	b=2HUvIzfG3g93Y4EhgEv45k6km5uew8gF77BFyFkRGJSS6S2+aQbTcDkx6hYhiSNQwb
	HSYyhcj4os6X5mdlve6OVfVPP0D6BISwigE4hhu3FdbwgP5AYIqp8CCdWHT1esJJcmdO
	b+Yor1ddjOpjiYOzFdYOarz+aXVnzEfa1oBlqmFuHJyd4BP0+uLTcFqzk+POsmdb+cHM
	2Ven4wwJ3ruUqH0MomVvD6RLWe/nM5de2vDO4Fnjv1kjkleUMLxYFKKcK+klORch3jUm
	HGSzXzLIUwGuxXLM50TZicH8UwzWx8zRKo//XmCtBblqocuRMZvpJ4fGPNhF20KkEACH
	ZsAg==
X-Gm-Message-State: AOAM531Ju8Z+t58pRqPw67E14r5pekVTXjvB+8cLCSHRMa9jY+PxIiyi
	vFGCjqy2Z3lOVciMt7VBYwHCcEWQf/iqLZj3KDNFJUnLptIakxC++HYHC51ozji/DU9xBhpuOCT
	fyxGsWW9fDYoA2g==
X-Received: by 2002:a05:622a:1744:: with SMTP id
	l4mr16911791qtk.418.1636731177808; 
	Fri, 12 Nov 2021 07:32:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyWEbfBGlUTOmcQnZbvVG+2bpwe2xLwY4vfOggsYdyGZJsAG/7XDMozdiWKQMhswL3pyhlXhQ==
X-Received: by 2002:a05:622a:1744:: with SMTP id
	l4mr16911759qtk.418.1636731177620; 
	Fri, 12 Nov 2021 07:32:57 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	i14sm3278776qti.25.2021.11.12.07.32.57
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 12 Nov 2021 07:32:57 -0800 (PST)
Date: Fri, 12 Nov 2021 10:32:56 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Milan Broz <gmazyland@gmail.com>, Itai Handler <itai.handler@gmail.com>
Message-ID: <YY6JKAYDl8lHE6BB@redhat.com>
References: <CAFpOueRBb9y_Fgb3-c6_eFTKZR9DoAXZmxqqx0UH1Yb2rbV0RQ@mail.gmail.com>
	<da6989dc-1fab-cbd0-4ea9-1b60ea9de964@gmail.com>
MIME-Version: 1.0
In-Reply-To: <da6989dc-1fab-cbd0-4ea9-1b60ea9de964@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com
Subject: Re: [dm-devel] [RFC PATCH 1/1] dm crypt: change maximum sector size
	to PAGE_SIZE
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 11 2021 at  8:07P -0500,
Milan Broz <gmazyland@gmail.com> wrote:

> On 10/11/2021 18:43, Itai Handler wrote:
> > Maximum sector size of dm-crypt is currently limited to 4096 bytes.
> > 
> > On systems where PAGE_SIZE is larger than 4096 bytes, using larger
> > sectors can be beneficial for performance reasons.
> 
> The limit to 4096 was set because this is the smallest possible
> page size that all platform supports.
> 
> If you allow a higher size here, the device cannot be activated on a platform
> with the smaller page size. (Encrypted sector size becomes
> atomic sector size for all upper layers - as you mention below, not
> all fs support bigger sectors.)
> 
> For LUKS, this is not acceptable - the format is portable by definition.
> 
> For specific dm-crypt device, I am not sure. I would better kept
> the 4096 page size limit here.
> 
> It also depends on crypto API driver here (performance is usually optimized to 4k).
> What cipher and encryption mode did you use for test?
> 
> How the number looks for random access? Linear test is usually misleading.
> I expect there will be big performance problem if you write small data chunks,
> writes and encryption will be amplified to full big sectors here...)
> 
> (Technical detail: such patch MUST increase dm-crypt minor version.)
> 
> Milan

Thanks for your insight Milan, much appreciated.

> > 
> > This patch changes maximum sector size from 4096 bytes to PAGE_SIZE,
> > and in addition it changes the type of sector_size in
> > struct crypt_config from 'unsigned short int' to 'unsigned int', in
> > order to be able to represent larger values.
> > 
> > On a prototype system which has PAGE_SIZE of 65536 bytes, I saw about
> > x2 performance improvement in sequential read throughput benchmark
> > while using only about half of the CPU usage, after simply increasing
> > sector size from 4096 to 65536 bytes.
> > I used ext4 filesystem for that benchmark, which supports 64KiB
> > sectors.
> > 
> > Note: A small change should be made in cryptsetup in order to add
> > support for sectors larger than 4096 bytes.
> > 
> > Signed-off-by: Itai Handler <itai.handler@gmail.com>

Your patch is way too raw.  It doesn't come with any understanding of
all the nuanced reasons for 4096 that Milan raised above, and so I've
dropped your patch from further consideration.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

