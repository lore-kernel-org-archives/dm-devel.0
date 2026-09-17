Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C1B51122E
	for <dm-devel@lists.linux.dev>; Thu, 17 Sep 2026 13:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650278; cv=none; b=oa8rE8AELCXO4CSqg7nnONHyDClKDEulJOUR/F4fNvwGk7Jsyquc3XSkttRxyKc+qPjfKu696sX5TjZud0yfvu18y25atH8dP+SSxk2LTTjPxjOApJDquUEqhzzqiNR2N9oeWUsJbENBi3fBvgOjw+RQthjP8o2BsC5Wp+phzrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650278; c=relaxed/simple;
	bh=Rp/BLc9CNLUciKOM5zKPdKUP5vUmnfeaCqEiy7XMhg8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=liUwOCg5p8oSiNkZMCxgAZVQGtGPInkK/utlwjJ62/bx8QCosKNurONSRdNwUBbrUMhhjnQsm+ImaXuYW5Iy3A7vFdwTeE7MRllcxjW9ao//DCEL06d5h9yBYxsX7zXkyqIR+jgOiXsWtQ/A9+VUIUQ8zKGVEuPjPKLS9Fkg0bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LGqT7KPo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LGqT7KPo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789650265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=naiFAqVVLvn+9AEgh0Untd5WWTs3XcLs8AymZ6Lcz88=;
	b=LGqT7KPo5EGkTEQHU0J+WXRE8b4aCvOTSOAjHHOVuUwuA02aekjbOQIm/D3RkAUTNx1Qyi
	XpWLbBnkAfG11Fpyd/10zZlTCCoTzPyVUkrdIJgz23Ni+/rANdF37b9RB1rDGbJ/sPy93S
	ewrBerDtt/6J8gn6zmmH2Ya6HP603s0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-425-eUxI28GEMWyV_i1yegzz4Q-1; Thu,
 17 Sep 2026 09:04:23 -0400
X-MC-Unique: eUxI28GEMWyV_i1yegzz4Q-1
X-Mimecast-MFC-AGG-ID: eUxI28GEMWyV_i1yegzz4Q_1789650262
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E9761953971;
	Thu, 17 Sep 2026 13:04:22 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E6E71956095;
	Thu, 17 Sep 2026 13:04:20 +0000 (UTC)
Date: Thu, 17 Sep 2026 15:04:17 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Matthias Goergens <matthias.goergens@gmail.com>
cc: dm-devel@lists.linux.dev, bmarzins@redhat.com, agk@redhat.com, 
    snitzer@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dm-delay: advertise flush support when a flush delay
 is configured
In-Reply-To: <20260917111742.1328396-1-matthias.goergens@gmail.com>
Message-ID: <0ab89280-9279-f4dd-bf82-26997dbfcedd@redhat.com>
References: <20260814045813.3148127-1-matthias.goergens@gmail.com> <20260917111742.1328396-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: pcMdwm1jATqBNCpUn-fKdNva6ejuv8IsA1c8Mu215GU_1789650262
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

OK.

I updated the patch in the linux-dm repository.

Mikulas



On Thu, 17 Sep 2026, Matthias Goergens wrote:

> dm-delay has a flush delay class: the 9-argument table form takes
> <flush_device> <flush_offset> <flush_delay>, delay_map() routes
> REQ_PREFLUSH bios to it, num_flush_bios is 1, and
> Documentation/admin-guide/device-mapper/delay.rst documents it. But
> the target never sets ti->flush_supported, so the dm device only
> supports flushes when an underlying device stacks BLK_FEAT_WRITE_CACHE
> into its limits. Over a write-through device (write_cache "write
> through") it does not: submit_bio_noacct() strips REQ_PREFLUSH and
> REQ_FUA before any bio reaches the target, and a configured flush
> delay measures nothing.
> 
> Set ti->flush_supported when dc->flush.delay is non-zero. A configured
> flush delay then always sees its flushes. Without one, dm-delay keeps
> stacking flush support from the underlying device like the other
> targets, so an undelayed dm-delay behaves like linear for flushes.
> As for any table with flush support, the dm queue then also
> advertises FUA; delay_map() keeps routing REQ_FUA writes to the
> write class, and only REQ_PREFLUSH goes to the flush class.
> 
> Verified in a VM with dm-delay over a write-through virtio-scsi disk,
> using a 9-argument table with write delay 0 and a flush delay of 200
> or 800 ms. Without this change the dm queue reports write_cache "write
> through", fua 0, and five 4 KiB dd oflag=dsync writes to the dm device
> complete in 0-1 ms. With it the queue reports "write back", fua 1, and
> the same writes take 204-210 ms and 812-880 ms. Zero-delay tables over
> the write-through disk and over a write-back disk behave the same with
> and without the change and keep the underlying queue's settings.
> 
> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
> ---
> Changes since v1:
> - Set flush_supported only when dc->flush.delay is non-zero, so an
>   undelayed dm-delay behaves like linear for flushes (Ben).
> - Commit message describes only the write-through case; otherwise dm
>   stacks flush support from the underlying device (Ben).
> - Dropped the claim that FUA writes reach the wire: tracing the
>   underlying disk shows a plain data write and a REQ_PREFLUSH bio.
> - Re-measured with write delay 0 so the timing isolates the flush class.
> 
>  drivers/md/dm-delay.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
> index 4864671c2222f..96bb430215a32 100644
> --- a/drivers/md/dm-delay.c
> +++ b/drivers/md/dm-delay.c
> @@ -301,6 +301,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	}
>  
>  	ti->num_flush_bios = 1;
> +	ti->flush_supported = dc->flush.delay != 0;
>  	ti->num_discard_bios = 1;
>  	ti->accounts_remapped_io = true;
>  	ti->per_io_data_size = sizeof(struct dm_delay_info);
> @@ -451,7 +452,7 @@ static int delay_iterate_devices(struct dm_target *ti,
>  
>  static struct target_type delay_target = {
>  	.name	     = "delay",
> -	.version     = {1, 5, 0},
> +	.version     = {1, 5, 1},
>  	.features    = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ZONED_HM,
>  	.module      = THIS_MODULE,
>  	.ctr	     = delay_ctr,
> -- 
> 2.55.0
> 

