Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A339EC7619A
	for <dm-devel@archiver.kernel.org>; Mon, 20 Mar 2023 21:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679347393;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fvTQ2tvqDR3peOPm6SCQr1GO13QCVbqoUwwn1lose1k=;
	b=cVVL+3q8wbJAxf5Qlj99MF5KWRhwepqs4jNVsv8R/slbnI10754O2O5O4ZggP4TpdIebAr
	oGOsramC+L8f72vFFAGfn43X3Bk3sMLQ7qBri5MPYBFqu96IFFvX9+788q+vdm1Fbb93/h
	LD8ldkEkctDNlC1mx0p+qCfsHC+J04g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-GrkVS6KBObyMJif4eFYH9A-1; Mon, 20 Mar 2023 17:23:10 -0400
X-MC-Unique: GrkVS6KBObyMJif4eFYH9A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B532F3C0E447;
	Mon, 20 Mar 2023 21:23:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 688322166B29;
	Mon, 20 Mar 2023 21:23:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 281D119465A2;
	Mon, 20 Mar 2023 21:23:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF0361946594
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Mar 2023 21:23:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD64D1410F1C; Mon, 20 Mar 2023 21:23:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B5795140EBF4
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 21:23:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99A3B85A588
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 21:23:06 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-XuKayaheMvixYpfNQO4Mlw-1; Mon, 20 Mar 2023 17:23:05 -0400
X-MC-Unique: XuKayaheMvixYpfNQO4Mlw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3943461811;
 Mon, 20 Mar 2023 21:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545A8C433EF;
 Mon, 20 Mar 2023 21:23:03 +0000 (UTC)
Date: Mon, 20 Mar 2023 14:23:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Yeongjin Gil <youngjin.gil@samsung.com>
Message-ID: <20230320212301.GD1434@sol.localdomain>
References: <CGME20230320070011epcas1p12f0fe9f9f417dd1a3441efdde55a4132@epcas1p1.samsung.com>
 <20230320065932.28116-1-youngjin.gil@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230320065932.28116-1-youngjin.gil@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v2] dm verity: fix error handling for
 check_at_most_once on FEC
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
Cc: snitzer@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 dm-devel@redhat.com, Sungjong Seo <sj1557.seo@samsung.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 20, 2023 at 03:59:32PM +0900, Yeongjin Gil wrote:
> In verity_end_io(), if bi_status is not BLK_STS_OK, it can be return
> directly. But if FEC configured, it is desired to correct the data page
> through verity_verify_io. And the return value will be converted to
> blk_status and passed to verity_finish_io().
> 
> BTW, when a bit is set in v->validated_blocks, verity_verify_io() skips
> verification regardless of I/O error for the corresponding bio. In this
> case, the I/O error could not be returned properly, and as a result,
> there is a problem that abnormal data could be read for the
> corresponding block.
> 
> To fix this problem, when an I/O error occurs, do not skip verification
> even if the bit related is set in v->validated_blocks.
> 
> Fixes: 843f38d382b1 ("dm verity: add 'check_at_most_once' option to only validate hashes once")
> Cc: stable@vger.kernel.org
> Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
> Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
> ---
> v2:
> -change commit message and tag
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
> -- 

Looks good now, thanks!

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

