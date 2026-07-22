Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD774048A3
	for <dm-devel@lists.linux.dev>; Wed, 22 Jul 2026 21:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754849; cv=none; b=CoeBILmeY05126SkLvqbD3sby6CqMdhUbkLbfJFLMa6DDjiW7avf7MSlxKDM4g0Ec68xB55JohfFdF12tcElS41Q6wB/bH9XToNg2ZYudEujQhr9psWyy+0R91ugIRAJASlDSG76w83/xja/4N/ar4Y8RjR1GhBecvQWgJ3uIfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754849; c=relaxed/simple;
	bh=J+Psrg0cG31TqRLzXYL3bzXV9Jz9YG6mmHHBdJelX7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=gYfMqCjMyn2CX1b/sPDN1gQt82qZWexmlvfxKDZEi4404oBR9yMOAD0ZVFxkIHphW11/O7MfIiFb3+XYlR5sDk8XuAq5wJe0l3weEpYJMZYn6XF5sJOkhxW25Anx0wGY/v+yHtP3U8b75myBkwr4z/siAwYeQpwbMb26DAfYgc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U9I0BAfs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U9I0BAfs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784754846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RHAdKQ4o+btRrc7W6Scqe0Z1DGrRtNJQA02016weg9U=;
	b=U9I0BAfsdfxHwVl4u+F/cekvy2aEU+D3tJOnMo0+nVGgpmIyGlOxVerpeCDOP7n9kOEEdA
	rIzgAPxQdhPK4WVSAHm+LhPKaQYH0uGBQGNVTDO847KtjvnPyK2+7SHoULEr71iTxdHKW9
	7FiJO5FY4x/xEYZUyZOfgiQYRFtKjI8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-Mg02b3y5NlGAkYiSd5BNEw-1; Wed,
 22 Jul 2026 17:14:03 -0400
X-MC-Unique: Mg02b3y5NlGAkYiSd5BNEw-1
X-Mimecast-MFC-AGG-ID: Mg02b3y5NlGAkYiSd5BNEw_1784754842
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54C281955DE8;
	Wed, 22 Jul 2026 21:14:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8F88300419E;
	Wed, 22 Jul 2026 21:14:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 66MLE0O32537196
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 17:14:00 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 66MLE0TO2537195;
	Wed, 22 Jul 2026 17:14:00 -0400
Date: Wed, 22 Jul 2026 17:14:00 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "open list:DEVICE-MAPPER  (LVM)" <dm-devel@lists.linux.dev>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm dust: use target-relative sectors in badblock messages
Message-ID: <amEymCRxwtpZoR-2@redhat.com>
References: <20260609002231.1236115.614213f87db6.dm-dust-badblock-coordinate-mismatch@trailofbits.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260609002231.1236115.614213f87db6.dm-dust-badblock-coordinate-mismatch@trailofbits.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: eG5jfveDLS3kVmYVtJmMxgoWxLHzkdAqiPEAqACrfS0_1784754842
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 09, 2026 at 12:23:45AM +0000, Samuel Moelius wrote:
> dm-dust stores bad blocks in target-relative sectors, but some messages
> report or compare values in a different coordinate space. A table with a
> non-zero target offset can therefore describe one sector while reporting
> another.
> 
> This makes diagnostics misleading and can make scripted validation look
> at the wrong logical block.
> 
> Keep the badblock control path in target-relative coordinates when
> reporting and matching stored bad blocks.
> 
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>

I agree that the block number is misleading to the point of being wrong.
However I don't think that dm-dust is inconsistent. dust_message()
checks if the bad block fits in the underlying device size. It doesn't
check if it fits in the target size. When dust_map() is called, it
checks for the block relative to the underlying device. So it
consitently treats the block number as referring to a block on the
underlying device, not referring to a block relative to the start of the
dm-dust target. This is weird. It means that dm-dust allows you to mark
bad blocks that aren't actually part of the dm-dust device, or mark bad
blocks that aren't aligned with the dm-dust target. That seems wrong,
and the code setting up max_block_sectors sure makes it look like the
blocks are supposed to be relative to the target.  The question is, "Do
existing dm-dust users expect this current behavior?"
Documentation/admin-guide/device-mapper/dm-dust.rst doesn't mention what
a bad block is relative to.

Overall, I think that dm-dust is not a heavily used target, and quite
possibly you are the first person to try using it will a non-zero offset
on the underlying device, so I think it's probably o.k. to change the
behavior here to something sensible. But the commit message should be
clearer that it is changing what a badblock refers to (from a block on
the underlying device to a block relative to the start of the dm-dust
target).

Also if you wouldn't mind removing the sector_div() line from
__dust_map_write(), that would also be a welcome change. thisblock
already points to the block, and dividing it by sect_per_block again
just makes __dust_map_write() report the wrong block got removed from
the badblocklist.

-Ben

> ---
>  drivers/md/dm-dust.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
> index c7e3077fb1f5..45d4154209b7 100644
> --- a/drivers/md/dm-dust.c
> +++ b/drivers/md/dm-dust.c
> @@ -224,15 +224,16 @@ static int dust_map_write(struct dust_device *dd, sector_t thisblock,
>  static int dust_map(struct dm_target *ti, struct bio *bio)
>  {
>  	struct dust_device *dd = ti->private;
> +	sector_t dust_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
>  	int r;
>  
>  	bio_set_dev(bio, dd->dev->bdev);
> -	bio->bi_iter.bi_sector = dd->start + dm_target_offset(ti, bio->bi_iter.bi_sector);
> +	bio->bi_iter.bi_sector = dd->start + dust_sector;
>  
>  	if (bio_data_dir(bio) == READ)
> -		r = dust_map_read(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
> +		r = dust_map_read(dd, dust_sector, dd->fail_read_on_bb);
>  	else
> -		r = dust_map_write(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
> +		r = dust_map_write(dd, dust_sector, dd->fail_read_on_bb);
>  
>  	return r;
>  }
> @@ -415,7 +416,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
>  			char *result, unsigned int maxlen)
>  {
>  	struct dust_device *dd = ti->private;
> -	sector_t size = bdev_nr_sectors(dd->dev->bdev);
> +	sector_t size = dm_sector_div_up(ti->len, dd->sect_per_block);
>  	bool invalid_msg = false;
>  	int r = -EINVAL;
>  	unsigned long long tmp, block;
> @@ -462,8 +463,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
>  			return r;
>  
>  		block = tmp;
> -		sector_div(size, dd->sect_per_block);
> -		if (block > size) {
> +		if (block >= size) {
>  			DMERR("selected block value out of range");
>  			return r;
>  		}
> @@ -490,8 +490,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
>  			return r;
>  		}
>  		wr_fail_cnt = tmp_ui;
> -		sector_div(size, dd->sect_per_block);
> -		if (block > size) {
> +		if (block >= size) {
>  			DMERR("selected block value out of range");
>  			return r;
>  		}
> -- 
> 2.43.0

