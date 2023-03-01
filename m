Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C8D2C64EC7
	for <dm-devel@archiver.kernel.org>; Wed,  1 Mar 2023 00:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677631346;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/INzrYuAkd9cku2L0ronD1pr6W3b6hs4B0qmLla3noE=;
	b=KMtn/SDkQzh/MfcsF83xS7jWp5+4NxlfmGJtKL4L87sbLkWxxv3OENtSPLirC0dLDtVIWg
	Ryq0XVblX/ZSS7auMZ3mz307OxLo+JaawcjvGVhoG+ha+xbop92llU7q5ydEL2KgY76/NM
	2XFFi9Oyf/nXzJdgIHXouvrAUFFm69k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-ABSP7brPMeao0u_3RpP5tQ-1; Tue, 28 Feb 2023 19:42:22 -0500
X-MC-Unique: ABSP7brPMeao0u_3RpP5tQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F0CA85CCE1;
	Wed,  1 Mar 2023 00:42:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B2B9C492B0E;
	Wed,  1 Mar 2023 00:42:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F434194658F;
	Wed,  1 Mar 2023 00:42:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4E24D194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Mar 2023 00:42:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E2C0140C945A; Wed,  1 Mar 2023 00:42:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DB30140C6EC4
 for <dm-devel@redhat.com>; Wed,  1 Mar 2023 00:42:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B81CD101A52E
 for <dm-devel@redhat.com>; Wed,  1 Mar 2023 00:42:17 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-6QiZiZ7vNDaJER0nbZfNCg-1; Tue, 28 Feb 2023 19:42:16 -0500
X-MC-Unique: 6QiZiZ7vNDaJER0nbZfNCg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 5AF846115A;
 Wed,  1 Mar 2023 00:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74411C433D2;
 Wed,  1 Mar 2023 00:33:34 +0000 (UTC)
Date: Tue, 28 Feb 2023 17:33:31 -0700
From: Keith Busch <kbusch@kernel.org>
To: Uday Shankar <ushankar@purestorage.com>
Message-ID: <Y/6dW8rVx9LktlW6@kbusch-mbp.dhcp.thefacebook.com>
References: <20230301000655.48112-1-ushankar@purestorage.com>
MIME-Version: 1.0
In-Reply-To: <20230301000655.48112-1-ushankar@purestorage.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v3] blk-mq: enforce op-specific segment
 limits in blk_insert_cloned_request
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 kernel test robot <lkp@intel.com>, Mike Snitzer <snitzer@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Feb 28, 2023 at 05:06:55PM -0700, Uday Shankar wrote:
> The block layer might merge together discard requests up until the
> max_discard_segments limit is hit, but blk_insert_cloned_request checks
> the segment count against max_segments regardless of the req op. This
> can result in errors like the following when discards are issued through
> a DM device and max_discard_segments exceeds max_segments for the queue
> of the chosen underlying device.
> 
> blk_insert_cloned_request: over max segments limit. (256 > 129)
> 
> Fix this by looking at the req_op and enforcing the appropriate segment
> limit - max_discard_segments for REQ_OP_DISCARDs and max_segments for
> everything else.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

