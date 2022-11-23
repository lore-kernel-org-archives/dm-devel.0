Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F309C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 15:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669216224;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V19V5oDCErAbC9ITVpr6g2CC/2r3gCtvAhYPoCMfMJw=;
	b=PRHeg0XWqADAgGiZD/xtoo/4BBNnIQTdA/zsy4YryK4X6kGwcGYi21v5p/tp3daoEQaGhl
	l9wRRU4hZGiiWWFhLl5+kFrOApa1QwoFRkk5158yYpXkDpct3zaXGUfuqoUkpc6vzIFp9I
	PPcJSwIUOfDgUFrVvQRD84EUN0Uiy/0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-HZChuQ05OhKMvDl0plKung-1; Wed, 23 Nov 2022 10:10:21 -0500
X-MC-Unique: HZChuQ05OhKMvDl0plKung-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D84CE3C0F234;
	Wed, 23 Nov 2022 15:10:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F3DF72028E8F;
	Wed, 23 Nov 2022 15:10:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A9BCC1946589;
	Wed, 23 Nov 2022 15:10:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6D307194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 15:04:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 53B0140C83BB; Wed, 23 Nov 2022 15:04:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BA1640C2086
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 15:04:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3487C8039A6
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 15:04:44 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-kziQA-auNu2atQXtC-kFmA-1; Wed, 23 Nov 2022 10:04:42 -0500
X-MC-Unique: kziQA-auNu2atQXtC-kFmA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 59F1E61D4F;
 Wed, 23 Nov 2022 15:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37600C433C1;
 Wed, 23 Nov 2022 15:04:40 +0000 (UTC)
Date: Wed, 23 Nov 2022 08:04:37 -0700
From: Keith Busch <kbusch@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Message-ID: <Y342hZgFQdLfTfdx@kbusch-mbp.dhcp.thefacebook.com>
References: <20221123124234.265396-1-sashal@kernel.org>
 <20221123124234.265396-25-sashal@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20221123124234.265396-25-sashal@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH AUTOSEL 5.15 25/31] dm-log-writes: set
 dma_alignment limit in io_hints
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, dm-devel@redhat.com,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 23, 2022 at 07:42:26AM -0500, Sasha Levin wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> [ Upstream commit 50a893359cd2643ee1afc96eedc9e7084cab49fa ]
> 
> This device mapper needs bio vectors to be sized and memory aligned to
> the logical block size. Set the minimum required queue limit
> accordingly.

Probably harmless, but these dm dma_alignment patches are not needed
prior to 6.0.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

