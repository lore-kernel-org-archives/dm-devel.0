Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 599C8C74A5B
	for <dm-devel@archiver.kernel.org>; Fri, 17 Mar 2023 14:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679065003;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=e+OxL/js1MyzwlVDnmri+m5+CJGfkEm7J5JCRn/Q31g=;
	b=P6fefpd5dyfBI65PVjAvUBa69X3EaGkzoJ2GyBDH3FB14jgqjKQC2UmdyRlEUjHlOJop9n
	hi8hiYIbJs0MfI09sM3UQk9PAWkuyxXXl6YYMzEIn5HDFF7jexGbXdFgm0HL3AYyF3MjiZ
	Mqoturj+Oh3o+25syaBRcuX4ZEysF1w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-JE01RcaVMdm5aak-Rzu8yA-1; Fri, 17 Mar 2023 10:56:40 -0400
X-MC-Unique: JE01RcaVMdm5aak-Rzu8yA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63D423C20EEB;
	Fri, 17 Mar 2023 14:56:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 514BD40CF8F2;
	Fri, 17 Mar 2023 14:56:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 326EE19466DF;
	Fri, 17 Mar 2023 14:56:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A18771946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Mar 2023 18:52:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9588E4042AC6; Thu, 16 Mar 2023 18:52:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E8C74042AC5
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 18:52:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7351585D536
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 18:52:34 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-Hpmul2EYPOOdZ0_oAhY1pQ-1; Thu, 16 Mar 2023 14:52:32 -0400
X-MC-Unique: Hpmul2EYPOOdZ0_oAhY1pQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id A9720620E0;
 Thu, 16 Mar 2023 18:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4858C433D2;
 Thu, 16 Mar 2023 18:44:01 +0000 (UTC)
Date: Thu, 16 Mar 2023 18:44:00 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Yeongjin Gil <youngjin.gil@samsung.com>
Message-ID: <ZBNjcA1feNWUxvaW@gmail.com>
References: <CGME20230316031936epcas1p1ebd93477dcf3bf9ab1640306dd1da8ff@epcas1p1.samsung.com>
 <20230316031842.17295-1-youngjin.gil@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230316031842.17295-1-youngjin.gil@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] dm verity: fix error handling for
 check_at_most_once
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
Cc: snitzer@kernel.org, totte@google.com, linux-kernel@vger.kernel.org,
 Nathan Huckleberry <nhuck@google.com>, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Sungjong Seo <sj1557.seo@samsung.com>,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Yeongjin,

On Thu, Mar 16, 2023 at 12:18:42PM +0900, Yeongjin Gil wrote:
> In verity_work(), the return value of verity_verify_io() is converted to
> blk_status and passed to verity_finish_io(). BTW, when a bit is set in
> v->validated_blocks, verity_verify_io() skips verification regardless of
> I/O error for the corresponding bio. In this case, the I/O error could
> not be returned properly, and as a result, there is a problem that
> abnormal data could be read for the corresponding block.
> 
> To fix this problem, when an I/O error occurs, do not skip verification
> even if the bit related is set in v->validated_blocks.
> 
> Fixes: 843f38d382b1 ("dm verity: add 'check_at_most_once' option to only validate hashes once")
> 
> Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
> Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
> ---
>  drivers/md/dm-verity-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index ade83ef3b439..9316399b920e 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -523,7 +523,7 @@ static int verity_verify_io(struct dm_verity_io *io)
>  		sector_t cur_block = io->block + b;
>  		struct ahash_request *req = verity_io_hash_req(v, io);
>  
> -		if (v->validated_blocks &&
> +		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
>  		    likely(test_bit(cur_block, v->validated_blocks))) {
>  			verity_bv_skip_block(v, io, iter);
>  			continue;

Thanks for sending this patch!  This looks like a correct fix, but I have some
comments:

* Using "check_at_most_once" is strongly discouraged, as it reduces security.
  If you are using check_at_most_once to improve performance at the cost of
  reduced security, please consider that very recently, dm-verity performance
  has significantly improved due to the removal of the WQ_UNBOUND workqueue flag
  which was causing significant I/O latency.  See commit c25da5b7baf1
  ("dm verity: stop using WQ_UNBOUND for verify_wq").

* I think your commit message does not explain a key aspect of the problem which
  is why is verity even attempted when the underlying I/O has failed?  This
  appears to be because of the Forward Error Correction (FEC) feature.  So, this
  issue is specific to the case where both FEC and check_at_most_once is used.
  Can you make your commit message explain this?

* This patch does not appear to have been received by the dm-devel mailing list,
  which is the list where dm-verity patches should be reviewed on.  It doesn't
  show up in the archive at https://lore.kernel.org/dm-devel.  Also, I'm
  subscribed to dm-devel and I didn't receive this patch in my inbox.  (I had to
  download it from https://lore.kernel.org/lkml instead.)  Did you receive a
  bounce message when you sent this patch?

* Please add 'Cc: stable@vger.kernel.org' to the commit message, just below the
  Fixes line, as per Documentation/process/stable-kernel-rules.rst.  This will
  ensure that the fix will be backported to the stable kernels.

* "Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>" does not have a
  corresponding Author or Co-developed-line, which is not allowed.  Did you mean
  to list Sungjong as the Author or as a co-author?

* No blank line between Fixes and the Signed-off-by line(s), please.

Thanks!

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

