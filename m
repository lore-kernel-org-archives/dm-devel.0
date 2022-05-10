Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9BCC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 10 May 2022 11:48:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-MuXbs1OBPc-BzlQvW5SzhA-1; Tue, 10 May 2022 07:48:24 -0400
X-MC-Unique: MuXbs1OBPc-BzlQvW5SzhA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CE5C81B5A4;
	Tue, 10 May 2022 11:48:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 507779E82;
	Tue, 10 May 2022 11:48:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1EA871947055;
	Tue, 10 May 2022 11:48:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8712F1947052
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 May 2022 11:48:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5584D415F4D; Tue, 10 May 2022 11:48:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 51CD8415F33
 for <dm-devel@redhat.com>; Tue, 10 May 2022 11:48:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38F16100BAAF
 for <dm-devel@redhat.com>; Tue, 10 May 2022 11:48:07 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-sVc6kFqEN5OJUQOy2bSXMw-1; Tue, 10 May 2022 07:48:03 -0400
X-MC-Unique: sVc6kFqEN5OJUQOy2bSXMw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id C3B886194D;
 Tue, 10 May 2022 11:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC95C385C2;
 Tue, 10 May 2022 11:48:01 +0000 (UTC)
Date: Tue, 10 May 2022 13:47:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <YnpQ7gcGt872LstM@kroah.com>
References: <alpine.LRH.2.02.2205031634520.11434@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2205031634520.11434@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v4.9] dm: interlock pending dm_io and
 dm_wait_for_bios_completion
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
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
 stable@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 03, 2022 at 04:35:44PM -0400, Mikulas Patocka wrote:
> This is backport of the patch 9f6dc6337610 ("dm: interlock pending dm_io
> and dm_wait_for_bios_completion") for the kernel 4.9.
> 
> The bugs fixed by this patch can cause random crashing when reloading dm
> table, so it is eligible for stable backport.
> 
> Note that the kernel 4.9 uses md->pending to count the number of
> in-progress I/Os and md->pending is decremented after dm_stats_account_io,
> so the race condition doesn't really exist there (except for missing
> smp_rmb()).
> 
> The percpu variable md->pending_io is not needed in the stable kernels,
> because md->pending counts the same value, so it is not backported.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reviewed-by: Mike Snitzer <snitzer@kernel.org>
> 
> ---
>  drivers/md/dm.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-stable/drivers/md/dm.c
> ===================================================================
> --- linux-stable.orig/drivers/md/dm.c	2022-04-30 19:03:08.000000000 +0200
> +++ linux-stable/drivers/md/dm.c	2022-04-30 19:03:46.000000000 +0200
> @@ -2027,6 +2027,8 @@ static int dm_wait_for_completion(struct
>  	}
>  	finish_wait(&md->wait, &wait);
>  
> +	smp_rmb(); /* paired with atomic_dec_return in end_io_acct */
> +
>  	return r;
>  }
>  
> 

All now queued up, thanks.

gre gk-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

