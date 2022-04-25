Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E4FC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 25 Apr 2022 12:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1650890913;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YrWtQC8o2BdzylBNZ+M9a7lWfzCAGI+w/zm+AIvhBDE=;
	b=cgv4oR7dWvoj0z4KKG0rxKMoATQAsQtyPIjJAy6kZfq5LH+roi7IeAv5hbhmKgFyrCAVrW
	6LTDIKrLLq4D09LLAhBvAcU1dk5RCR9tYong6cWz9ghuOuh8xIyBswo7/ga42objypO3GC
	m9SEbO/dcW6B7HSiV+qZAhsIztcZhoA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-H0aeIJjiO5W13IqLqWIakw-1; Mon, 25 Apr 2022 08:48:30 -0400
X-MC-Unique: H0aeIJjiO5W13IqLqWIakw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AE7B811E78;
	Mon, 25 Apr 2022 12:48:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1053740D0160;
	Mon, 25 Apr 2022 12:48:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 661511947BBF;
	Mon, 25 Apr 2022 12:48:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 506DC1947BBE
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Apr 2022 12:48:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2F75140D2962; Mon, 25 Apr 2022 12:48:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2566140C1241;
 Mon, 25 Apr 2022 12:48:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 23PCmRVk003883; Mon, 25 Apr 2022 08:48:27 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 23PCmRVa003879; Mon, 25 Apr 2022 08:48:27 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 25 Apr 2022 08:48:27 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Dan Carpenter <dan.carpenter@oracle.com>
In-Reply-To: <YmaMgPr8bM/0PFUi@kili>
Message-ID: <alpine.LRH.2.02.2204250846510.1699@file01.intranet.prod.int.rdu2.redhat.com>
References: <YmaMgPr8bM/0PFUi@kili>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] dm integrity: fix error code in
 dm_integrity_ctr()
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
Cc: Mike Snitzer <snitzer@kernel.org>, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks for finding it.


On Mon, 25 Apr 2022, Dan Carpenter wrote:

> The "r" variable shadows an earlier "r" that has function scope.  It
> means that we accidentally return success instead of an error code.
> Smatch has a warning for this:
> 
> 	drivers/md/dm-integrity.c:4503 dm_integrity_ctr()
> 	warn: missing error code 'r'
> 
> Fixes: 7eada909bfd7 ("dm: add integrity target")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

add:

Cc: stable@vger.kernel.org
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-integrity.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 36ae30b73a6e..3d5a0ce123c9 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -4494,8 +4494,6 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	}
>  
>  	if (should_write_sb) {
> -		int r;
> -
>  		init_journal(ic, 0, ic->journal_sections, 0);
>  		r = dm_integrity_failed(ic);
>  		if (unlikely(r)) {
> -- 
> 2.35.1
> 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

