Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605853749FE
	for <dm-devel@lists.linux.dev>; Wed, 10 Jun 2026 19:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781121273; cv=none; b=aztCOOD0BWnP8WHCZQZGd4wBI1fjhbIHl//83FFCcpZ+X08rtzDFGzgl7F9H9KQu7Lz1YF7XEoiCfAN9FyO3EMCLbezMp4S5637thJuBm5h98vUJvd9uetnGKETZngTZ/S6S7O8BRe9l4AZUwi6qFoUKa118ODPLEWnb9AcDHoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781121273; c=relaxed/simple;
	bh=XJNthxqmKURM2UJj9yo315z0AKKj/oi2G2iy4pBG7JA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nqWVmL6Vlc2rS4sPI+0Kk6ukI1KQl5AfN7DkKXzwhuBWoOejfaVs92nj8QuwoabmAoi3KPNeJsdTU4TTPkK7epZ7BsJCyCYdEa/X18Zjtz7Pgf6fCsR8EUTDmLc37BmUGNV54Gr3fg8N1LnbO9N6Z+0XZMtD8aNoumaR/EybpoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DU+znmG6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DU+znmG6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781121271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ntf6WlK3nWBNbSN2818slsc3jvLVcnebpO5X4jdtvBQ=;
	b=DU+znmG6onmJS3SkwHSb09XauU2fqsBsLM56ikB3l+4KO5aL4x70qwggMUWp3CuJ+GFYbe
	qnUxoUOiwkllXNiRY3KFsNOU7NjR9URlNr8Tztf63dzApDeek5OeoQvvVfd3G/ewcMCr+o
	eDLCdElFQh44WqKiiaM7/tO6by+MSWc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-EI8_sdmwMqeV3UmqNtDmiw-1; Wed,
 10 Jun 2026 15:54:30 -0400
X-MC-Unique: EI8_sdmwMqeV3UmqNtDmiw-1
X-Mimecast-MFC-AGG-ID: EI8_sdmwMqeV3UmqNtDmiw_1781121267
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 955F5195F16A;
	Wed, 10 Jun 2026 19:54:27 +0000 (UTC)
Received: from [10.44.48.10] (unknown [10.44.48.10])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95BEA19541B0;
	Wed, 10 Jun 2026 19:54:25 +0000 (UTC)
Date: Wed, 10 Jun 2026 21:54:21 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Samuel Moelius <sam.moelius@trailofbits.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    "open list:DEVICE-MAPPER  (LVM)" <dm-devel@lists.linux.dev>, 
    open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] dm ebs: drop dirty bufio state when discarding
 blocks
In-Reply-To: <20260608160606.1134881.c0f6c631029b.dm-ebs-discard-dirty-buffer-resurrection@trailofbits.com>
Message-ID: <06985f1d-436a-9dae-b984-65e95dd0572b@redhat.com>
References: <20260608160606.1134881.c0f6c631029b.dm-ebs-discard-dirty-buffer-resurrection@trailofbits.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: cMxNmplJ_lnde-W8ntP6c0O9KZGdhoWI4jdTnUEyM8U_1781121267
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I will accept this (and the other patches) after the upcoming merge window 
ends.

Mikulas


On Mon, 8 Jun 2026, Samuel Moelius wrote:

> dm-ebs can discard a block while a dirty dm-bufio buffer for the same
> block is still cached.  If that buffer is later written back, stale data
> can be written over the discarded state.
> 
> That resurrects data that userspace explicitly discarded and breaks the
> expected discard semantics of the target.
> 
> Flush pending dirty buffers before processing a following discard, then
> forget the matching bufio state and issue the discard.  Keep writeback
> errors separate from the discard result so a flush failure is reported
> to the write bios that dirtied the buffers, while the discard bio
> reports only the discard operation's own status.
> 
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> ---
> Changes in v2
>   - fix how dirty bios are handled and how errors are reported
> 
>  drivers/md/dm-ebs-target.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
> index 1e52bde48b91..5bdd1bf6c206 100644
> --- a/drivers/md/dm-ebs-target.c
> +++ b/drivers/md/dm-ebs-target.c
> @@ -176,8 +176,8 @@ static void __ebs_forget_bio(struct ebs_c *ec, struct bio *bio)
>  /* Worker function to process incoming bios. */
>  static void __ebs_process_bios(struct work_struct *ws)
>  {
> -	int r;
> -	bool write = false;
> +	int r, rr, write_r = 0;
> +	bool dirty = false;
>  	sector_t block1, block2;
>  	struct ebs_c *ec = container_of(ws, struct ebs_c, ws);
>  	struct bio *bio;
> @@ -209,9 +209,15 @@ static void __ebs_process_bios(struct work_struct *ws)
>  		if (bio_op(bio) == REQ_OP_READ)
>  			r = __ebs_rw_bio(ec, REQ_OP_READ, bio);
>  		else if (bio_op(bio) == REQ_OP_WRITE) {
> -			write = true;
>  			r = __ebs_rw_bio(ec, REQ_OP_WRITE, bio);
> +			dirty = true;
>  		} else if (bio_op(bio) == REQ_OP_DISCARD) {
> +			if (dirty) {
> +				rr = dm_bufio_write_dirty_buffers(ec->bufio);
> +				dirty = false;
> +				if (rr && !write_r)
> +					write_r = rr;
> +			}
>  			__ebs_forget_bio(ec, bio);
>  			r = __ebs_discard_bio(ec, bio);
>  		}
> @@ -224,11 +230,15 @@ static void __ebs_process_bios(struct work_struct *ws)
>  	 * We write dirty buffers after processing I/O on them
>  	 * but before we endio thus addressing REQ_FUA/REQ_SYNC.
>  	 */
> -	r = write ? dm_bufio_write_dirty_buffers(ec->bufio) : 0;
> +	if (dirty) {
> +		r = dm_bufio_write_dirty_buffers(ec->bufio);
> +		if (r && !write_r)
> +			write_r = r;
> +	}
>  
>  	while ((bio = bio_list_pop(&bios))) {
>  		/* Any other request is endioed. */
> -		if (unlikely(r && bio_op(bio) == REQ_OP_WRITE))
> +		if (unlikely(write_r && bio_op(bio) == REQ_OP_WRITE))
>  			bio_io_error(bio);
>  		else
>  			bio_endio(bio);
> -- 
> 2.43.0
> 

