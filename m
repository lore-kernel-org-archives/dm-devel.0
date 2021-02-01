Return-Path: <SRS0=uUVj=HD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8215AC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 15:48:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C9D5B64E2A
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 15:48:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9D5B64E2A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-8Y2hWyMzPT6QlohYmDl1Cg-1; Mon, 01 Feb 2021 10:48:24 -0500
X-MC-Unique: 8Y2hWyMzPT6QlohYmDl1Cg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF572100921D;
	Mon,  1 Feb 2021 15:45:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 736161A8A6;
	Mon,  1 Feb 2021 15:45:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C2EC8180954D;
	Mon,  1 Feb 2021 15:45:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 111FjrgR010274 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Feb 2021 10:45:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 12E501004022; Mon,  1 Feb 2021 15:45:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EF2A1111C89
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 15:45:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D1348582BB
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 15:45:50 +0000 (UTC)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
	[209.85.216.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-531-mtAMgji6Ptmk8LjZWTZEvw-1; Mon, 01 Feb 2021 10:45:48 -0500
X-MC-Unique: mtAMgji6Ptmk8LjZWTZEvw-1
Received: by mail-pj1-f42.google.com with SMTP id nm1so2231804pjb.3;
	Mon, 01 Feb 2021 07:45:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=X70HM1Jnz3qrVVjbkN2EvIvS8g7eAJX5EFfgJe7cNBI=;
	b=HVJSpjDqOq/GagOVgGqHgCV14gz/sCsGzrSaKQCOPxQtAzmOcsUb8nFR5giFHtuLd8
	b2sl3V+RgeklQRyx+ZMDpeyZPoIdsC9JhdXLBb2bvYWvD6nscqE1DwiqzmVjyjMB+028
	1dmDwc8LnRXnqsq6j6f95Ef1+zRhKJTAcdLd3bNFcZ9Bs1DmjeCsJxCqDbiaT1/UCGWp
	BrOq+gbRsBthkfX6ca33/60z+4JdD1kv9EJRVLKPVJdjWOE8DaW3hgxpHDaG/hNpxCe2
	WO1Cb16eGzG66/FMoz+KHJb29NMtB3shMd641ZZkPKmr8lr1ek4L6fSlCLyM/EQ7ilhJ
	Uz5Q==
X-Gm-Message-State: AOAM5335tdZiOamMoX+870vKoFcm0tPKqeHGHYt9qKJnQKaGWb1cJKlt
	kUv03RzjpF66/ZskslEB+gM=
X-Google-Smtp-Source: ABdhPJyeqD6ibhG9JLW/yNlRnv2IHGp1UBDL/FUZSQN1RTR1OXdZgBRh8yV0p9jPrhMzMtrLDPEx0w==
X-Received: by 2002:a17:90b:30d4:: with SMTP id
	hi20mr17169051pjb.41.1612194346196; 
	Mon, 01 Feb 2021 07:45:46 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19]) by smtp.gmail.com with ESMTPSA id
	m18sm18345641pfd.206.2021.02.01.07.45.44
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 01 Feb 2021 07:45:44 -0800 (PST)
To: Sergei Shtepa <sergei.shtepa@veeam.com>, hare@suse.de, ming.lei@redhat.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	linux-block@vger.kernel.org
References: <1611853955-32167-1-git-send-email-sergei.shtepa@veeam.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <5c6c936a-f213-eaa3-f4fb-3461a0b4dbe1@acm.org>
Date: Mon, 1 Feb 2021 07:45:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611853955-32167-1-git-send-email-sergei.shtepa@veeam.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: pavel.tide@veeam.com
Subject: Re: [dm-devel] [PATCH 0/2] block: blk_interposer v3
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 1/28/21 9:12 AM, Sergei Shtepa wrote:
> I`m ready to suggest the blk_interposer again.
> blk_interposer allows to intercept bio requests, remap bio to
> another devices or add new bios.
> 
> This version has support from device mapper.
> 
> For the dm-linear device creation command, the `noexcl` parameter
> has been added, which allows to open block devices without
> FMODE_EXCL mode. It allows to create dm-linear device on a block
> device with an already mounted file system.
> The new ioctl DM_DEV_REMAP allows to enable and disable bio
> interception.
> 
> Thus, it is possible to add the dm-device to the block layer stack
> without reconfiguring and rebooting.

What functionality does this driver provide that is not yet available in 
a RAID level 1 (mirroring) driver + a custom dm driver? My understanding 
is that there are already two RAID level 1 drivers in the kernel tree 
and that both driver support sending bio's to two different block devices.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

