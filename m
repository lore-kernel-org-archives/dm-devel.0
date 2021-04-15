Return-Path: <SRS0=YP8V=JM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E119C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 23:20:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EBD7061131
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 23:20:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBD7061131
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618528852;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QDURpB220vqoSK1b28OulxVbPv5+1/l2H1JMcksSoZI=;
	b=SY3teR7qySku/L6s7jYLaU3qQSTmUqD1Gjrlf7y6DdVEE057uCxhFYE27Z6dwAf321BLn3
	0Fk9ehuNtFr1+xUlNjBspXty0cQ6aRmrKc+JbZdqkpkZnP83tdvK6meNxkIeT7lzy1yc70
	Vhe1zXLt2THok0fGm3hxWETEZExj+5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-jMHgKZWxMtCV15Nr6GwVHA-1; Thu, 15 Apr 2021 19:20:49 -0400
X-MC-Unique: jMHgKZWxMtCV15Nr6GwVHA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A78AC81744F;
	Thu, 15 Apr 2021 23:20:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F82D62677;
	Thu, 15 Apr 2021 23:20:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F1BD344A5B;
	Thu, 15 Apr 2021 23:20:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13FNIJla011362 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Apr 2021 19:18:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AE1965D71F; Thu, 15 Apr 2021 23:18:19 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8631E62677;
	Thu, 15 Apr 2021 23:18:16 +0000 (UTC)
Date: Thu, 15 Apr 2021 19:18:15 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Message-ID: <20210415231815.GA16047@redhat.com>
References: <20210415231126.8746-1-snitzer@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210415231126.8746-1-snitzer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org
Subject: Re: [dm-devel] nvme: Return BLK_STS_TARGET if the DNR bit is set
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Sorry, emailed from wrong terminal... have since emailed correct v2

On Thu, Apr 15 2021 at  7:11pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> BZ: 1948690
> Upstream Status: RHEL-only
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> rhel-8.git commit ef4ab90c12db5e0e50800ec323736b95be7a6ff5
> Author: Mike Snitzer <snitzer@redhat.com>
> Date:   Tue Aug 25 21:52:45 2020 -0400
> 
>     [nvme] nvme: Return BLK_STS_TARGET if the DNR bit is set
>     
>     Message-id: <20200825215248.2291-8-snitzer@redhat.com>
>     Patchwork-id: 325178
>     Patchwork-instance: patchwork
>     O-Subject: [RHEL8.3 PATCH 07/10] nvme: Return BLK_STS_TARGET if the DNR bit is set
>     Bugzilla: 1843515
>     RH-Acked-by: David Milburn <dmilburn@redhat.com>
>     RH-Acked-by: Gopal Tiwari <gtiwari@redhat.com>
>     RH-Acked-by: Ewan Milne <emilne@redhat.com>
>     
>     BZ: 1843515
>     Upstream Status: RHEL-only
>     
>     If the DNR bit is set we should not retry the command, even if
>     the standard status evaluation indicates so.
>     
>     SUSE is carrying this patch in their kernel:
>     https://lwn.net/Articles/800370/
>     
>     Based on patch posted for upstream inclusion but rejected:
>     v1: https://lore.kernel.org/linux-nvme/20190806111036.113233-1-hare@suse.de/
>     v2: https://lore.kernel.org/linux-nvme/20190807071208.101882-1-hare@suse.de/
>     v2-keith: https://lore.kernel.org/linux-nvme/20190807144725.GB25621@localhost.localdomain/
>     v3: https://lore.kernel.org/linux-nvme/20190812075147.79598-1-hare@suse.de/
>     v3-keith: https://lore.kernel.org/linux-nvme/20190813141510.GB32686@localhost.localdomain/
>     
>     This commit's change is basically "v3-keith".
>     
>     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>     Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
> 
> ---
>  drivers/nvme/host/core.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-rhel9/drivers/nvme/host/core.c
> ===================================================================
> --- linux-rhel9.orig/drivers/nvme/host/core.c
> +++ linux-rhel9/drivers/nvme/host/core.c
> @@ -237,6 +237,9 @@ static void nvme_delete_ctrl_sync(struct
>  
>  static blk_status_t nvme_error_status(u16 status)
>  {
> +	if (unlikely(status & NVME_SC_DNR))
> +		return BLK_STS_TARGET;
> +
>  	switch (status & 0x7ff) {
>  	case NVME_SC_SUCCESS:
>  		return BLK_STS_OK;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

