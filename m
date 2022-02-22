Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C7C3C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 19:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645557386;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=S130lTXhpcXVBZdN+WmE36o1mgymAY3996xp31qzMIY=;
	b=bnvOI5DGXrWohwe7WYqgrZkq93FtSGin+ZOa6liuf4lMm8TfpynklC9IvBUMPcTbwcrHam
	SjOHEGSJQR4PebDwG7gj0s0R84bsdhYuyAUlKewF1xvuR7Ayrw3g4I2VTQx0+JsSr56ntq
	JFzGafKNJyR1DweZoiQ/+dAV+4bPBsc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-7RfUGbxVMqCihNDqW-L7Jw-1; Tue, 22 Feb 2022 14:16:24 -0500
X-MC-Unique: 7RfUGbxVMqCihNDqW-L7Jw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C94781091DA2;
	Tue, 22 Feb 2022 19:16:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CD0160843;
	Tue, 22 Feb 2022 19:16:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ABFE24ED66;
	Tue, 22 Feb 2022 19:16:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21MJGH1P028594 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 14:16:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4A385C08090; Tue, 22 Feb 2022 19:16:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 465B3C08F13
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 19:16:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BB1B800B21
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 19:16:17 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-97-BlJTk_wzOkqEvwrGxQWxaQ-1; Tue, 22 Feb 2022 14:16:15 -0500
X-MC-Unique: BlJTk_wzOkqEvwrGxQWxaQ-1
Received: by mail-qk1-f200.google.com with SMTP id
	7-20020a05620a048700b00648b76040f6so687729qkr.9
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 11:16:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=T+GUkN0EwP3DJ0lx9lCnDa6Z8wiaRvOcLwpTDRLmnnU=;
	b=fRFa0KPwLQjETkFSmOUxIz7R59Nvr4rZH9Hn4YDIv8hmtUBoY+Kq5Fc4HdupOMsOX/
	w8jTNh/qFX2JmRgulPgWzwRI2s2X6+1SWGJVinIUVuV/HKu9clu4vPuP6JLG5Le4AAKt
	lBZw0VdPTqb94U4I9HJXQHKB7WkTHyFICwmbB7C5k+JLoUtFrz/SQZJWQBeyKWk76hjf
	E9sYHhUcKvVw8C+lnO82wlkwfTlcZN0CDs9LR3X7eIVF7MwYDcFAW4bt/O9PELcYz8lC
	67vL2w0M3N18Sbg+SqzUCAywGfPOILTXiGPLI8HbZVXS4qbt+Ku7G/7sqBrXg+J0IhDG
	C2yQ==
X-Gm-Message-State: AOAM532kI5gtsOqtSUrTDuH0PUJNwrzhbXJzY9YNTwJes6Nd149rZCCy
	rzmt7kQr5YWzUB4mkB/dKYnlEfaafN9ZHg1ijB7+Uy9xxJIcAIFwptLoCgp8FMqLQmUMKibUIpx
	OvOORyVCaIoZg5Q==
X-Received: by 2002:a37:8602:0:b0:62c:de8f:ad74 with SMTP id
	i2-20020a378602000000b0062cde8fad74mr13357244qkd.142.1645557375260;
	Tue, 22 Feb 2022 11:16:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyoqR48S+c52tioZfwhQpWLjHci5jUdhUMN36vrY1CYw/3YuAqGThC/L/gVEu0PVsn1GFntaQ==
X-Received: by 2002:a37:8602:0:b0:62c:de8f:ad74 with SMTP id
	i2-20020a378602000000b0062cde8fad74mr13357235qkd.142.1645557375068;
	Tue, 22 Feb 2022 11:16:15 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id b14sm426205qtk.44.2022.02.22.11.16.14
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 22 Feb 2022 11:16:14 -0800 (PST)
Date: Tue, 22 Feb 2022 14:16:13 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YhU2faRZJ4NstJ6L@redhat.com>
References: <20220125002025.GA21887@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<20220126192234.572058-1-bgeffon@google.com>
	<CADyq12yugY0g2EMYvyrPVn98x3Tp4PR+eVddmmjZpKSYyrrzag@mail.gmail.com>
	<YfqYTuhGqOl4SneK@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YfqYTuhGqOl4SneK@infradead.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Brian Geffon <bgeffon@google.com>,
	Alasdair Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] dm: introduce a DM_ENFORCE_OPEN_COUNT flag.
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 02 2022 at  9:42P -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> Withmy block hat on: nak to this.  No block driver has any business at
> all rejecting "too many openers".  In fact any opener but the first of
> a partition is already not counted as an opener, and I plan to complete
> hide the open count from the device driver.

I agree that this proposal exposes controls to userspace that simply
shouldn't be meaningful given the arbitrary nature of openers.  And
preventing openers can result in a race where systemd or some other
service opens before the intended primary consumer of the device.

Seriously brittle and even if finely tuned to have a suitable value
for some niche usecase like android: an absolute hack.

Sorry, not interested in taking this.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

