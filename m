Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8741C388F9
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 13:20:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4917D20829
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 13:20:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RWMMMWDt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4917D20829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603804843;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=J1iz8xa2nRUkVBSCGdje0Hawe+SXtRZnzSKEmM8zjek=;
	b=RWMMMWDtCblqW7tRG2dLna2P64yWK8NUUBpwiGAP8+DzNKVZV/g13B7Hs+GEFvQrOR1c9b
	yDlnC3rwcpvYVplmz/SHqli6+UyMDNi5X/YP8oiyNM1Z9ybkz7eA4HHyqzVaHlIVPratML
	s+c/hlyJR/40ZWA/uD/hW7Ky1EAHtAw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-DMKAMqLFNtaQ5m0zwiJxqA-1; Tue, 27 Oct 2020 09:20:39 -0400
X-MC-Unique: DMKAMqLFNtaQ5m0zwiJxqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E1181084D67;
	Tue, 27 Oct 2020 13:20:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32F9755796;
	Tue, 27 Oct 2020 13:20:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 01F34CF47;
	Tue, 27 Oct 2020 13:20:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09RDKST3024369 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Oct 2020 09:20:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 95CA45D9E8; Tue, 27 Oct 2020 13:20:28 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56F045D9DD;
	Tue, 27 Oct 2020 13:20:25 +0000 (UTC)
Date: Tue, 27 Oct 2020 08:19:59 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Sasha Levin <sashal@kernel.org>
Message-ID: <20201027121959.GA13012@redhat.com>
References: <20201026234905.1022767-1-sashal@kernel.org>
	<20201026234905.1022767-89-sashal@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20201026234905.1022767-89-sashal@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [dm-devel] [PATCH AUTOSEL 5.9 089/147] dm: change max_io_len()
 to use blk_max_size_offset()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 26 2020 at  7:48pm -0400,
Sasha Levin <sashal@kernel.org> wrote:

> From: Mike Snitzer <snitzer@redhat.com>
> 
> [ Upstream commit 5091cdec56faeaefa79de4b6cb3c3c55e50d1ac3 ]
> 
> Using blk_max_size_offset() enables DM core's splitting to impose
> ti->max_io_len (via q->limits.chunk_sectors) and also fallback to
> respecting q->limits.max_sectors if chunk_sectors isn't set.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Not sure why this commit elevated to stable@ picking it up, please
explain.

But you cannot take this commit standalone. These commits are prereqs:

22ada802ede8 block: use lcm_not_zero() when stacking chunk_sectors
07d098e6bbad block: allow 'chunk_sectors' to be non-power-of-2
882ec4e609c1 dm table: stack 'chunk_sectors' limit to account for target-specific splitting

This goes for all stable@ trees you AUTOSEL'd commit 5091cdec56f for.

Mike

> ---
>  drivers/md/dm.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 6ed05ca65a0f8..3982012b1309c 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1051,22 +1051,18 @@ static sector_t max_io_len_target_boundary(sector_t sector, struct dm_target *ti
>  static sector_t max_io_len(sector_t sector, struct dm_target *ti)
>  {
>  	sector_t len = max_io_len_target_boundary(sector, ti);
> -	sector_t offset, max_len;
> +	sector_t max_len;
>  
>  	/*
>  	 * Does the target need to split even further?
> +	 * - q->limits.chunk_sectors reflects ti->max_io_len so
> +	 *   blk_max_size_offset() provides required splitting.
> +	 * - blk_max_size_offset() also respects q->limits.max_sectors
>  	 */
> -	if (ti->max_io_len) {
> -		offset = dm_target_offset(ti, sector);
> -		if (unlikely(ti->max_io_len & (ti->max_io_len - 1)))
> -			max_len = sector_div(offset, ti->max_io_len);
> -		else
> -			max_len = offset & (ti->max_io_len - 1);
> -		max_len = ti->max_io_len - max_len;
> -
> -		if (len > max_len)
> -			len = max_len;
> -	}
> +	max_len = blk_max_size_offset(dm_table_get_md(ti->table)->queue,
> +				      dm_target_offset(ti, sector));
> +	if (len > max_len)
> +		len = max_len;
>  
>  	return len;
>  }
> -- 
> 2.25.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

