Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0AC3AFAEA
	for <dm-devel@lists.linux.dev>; Fri, 14 Aug 2026 19:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786736136; cv=none; b=YnSWNvfEXsoWzlXvZwjKRYLwFeCPnN/Jpasyn4PI0E98j9gMXaMlI+0dG322r818axo/pYHmz6FsA+eEwkf0W094drezHjx+qmj/7QNDogDHPkABOpBsfcIlmDHFUvOg/+q4OYZ2mYM3qir+yMcxcnB1oQo/PDeqgFA7rK8Njcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786736136; c=relaxed/simple;
	bh=i5d9ZXjVbFVw2IAyarL45/jKamKGLhjVLY2+/Tgubrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=MynEeakIIzphc1z1FJxrzmC8+Dgcvb/F2//bhHhjQkZkItsFY+7ZaU/l3rLajd2qjpiVlGBiupEGdBC7i1B5lqPPOgpmR0Bf6w+uIjX9/M8cz8OUO59YIkZk63jgfZFSRBTj9ardxDETT+dtXSiHd1sqboWJGSAxQwHwaoaEkDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dEwEDN27; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dEwEDN27"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786736134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LUb9dhVio4DSRlBYDRsE8kJk432qxKPW9ktdvsEm2bs=;
	b=dEwEDN27zbHDpeCZ+LMCL9xzJIK8cy0XaL/8rFrIZQEhQcLD8i5LfcPWwBOuG1em7us+qg
	/ZAf9iSoVfNcg+z9ytJIo4qSDF/+GXz8xXI0mNpIREQalXqPtZcvlXI6MdHCOt6ZvlScWG
	ZjcsjmbavFa2i9Jbn8pXy4CHrSHn0NY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-V3ufYIMEP-2_Ouiv-EAoMQ-1; Fri,
 14 Aug 2026 15:35:28 -0400
X-MC-Unique: V3ufYIMEP-2_Ouiv-EAoMQ-1
X-Mimecast-MFC-AGG-ID: V3ufYIMEP-2_Ouiv-EAoMQ_1786736126
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C2A1180064C;
	Fri, 14 Aug 2026 19:35:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 14D391800346;
	Fri, 14 Aug 2026 19:35:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 67EJZOq11707320
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 15:35:24 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 67EJZOVN1707319;
	Fri, 14 Aug 2026 15:35:24 -0400
Date: Fri, 14 Aug 2026 15:35:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: dm-devel@lists.linux.dev, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-delay: advertise flush support
Message-ID: <an9t_JepVb2zJcD_@redhat.com>
References: <20260814045813.3148127-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260814045813.3148127-1-matthias.goergens@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: yZtpPiBl_AICypxy9c4HEZQqWbCierNwjxx5N9OTnHE_1786736126
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 14, 2026 at 12:58:12PM +0800, Matthias Goergens wrote:
> dm-delay parses and reports a flush delay class (the 9-argument table
> form's <flush_device> <flush_offset> <flush_delay>), delay_map() routes
> REQ_PREFLUSH bios to it, the target sets num_flush_bios = 1, and
> Documentation/admin-guide/device-mapper/delay.rst documents flush
> delays. But the target never sets ti->flush_supported, so
> dm_table_supports_flush() is false: the block layer strips REQ_PREFLUSH
> as a no-op before the bio ever reaches the target (blk_insert_flush()),
> REQ_FUA is stripped too, and the flush delay class is dead code. Anyone
> who configures a flush delay on dm-delay (e.g. to model slow-flush
> devices in tests) silently measures nothing.
> 
> Set ti->flush_supported = true so the flush delay class is actually
> reachable. dm core clones empty flushes with
> REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC (__send_empty_flush), which
> delay_map() already routes to the flush class, and delayed completion
> is already handled for every class by the delay worker.
> 
> Verified with dm-delay over a virtio-scsi disk: without this change
> REQ_PREFLUSH completes immediately and REQ_FUA writes are stripped by
> the block layer; with it, flushes take the configured delay and FUA
> writes reach the wire (measured as device-time per MB at D_f = 200 ms
> and 800 ms flush delays).
> 

The code seems fine, but could you please change the commit message.
It's not true that "Anyone who configures a flush delay on dm-delay
silently measures nothing". dm-delay doesn't *force* the dm device to
support flushes. It works just like most of the dm targets: linear,
stripe, raid, etc. If an underlying device sets BLK_FEAT_WRITE_CACHE or
BLK_FEAT_FUA, the dm device will as well (see blk_stack_limits, called
by dm_set_device_limits). I assume if you look at
/sys/block/<underlying_disk>/queue/write_cache, you see "write through".

-Ben

> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
> ---
>  drivers/md/dm-delay.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
> --- a/drivers/md/dm-delay.c
> +++ b/drivers/md/dm-delay.c
> @@ -301,6 +301,7 @@
>  	}
> 
>  	ti->num_flush_bios = 1;
> +	ti->flush_supported = true;
>  	ti->num_discard_bios = 1;
>  	ti->accounts_remapped_io = true;
>  	ti->per_io_data_size = sizeof(struct dm_delay_info);
> @@ -451,7 +452,7 @@
> 
>  static struct target_type delay_target = {
>  	.name	     = "delay",
> -	.version     = {1, 5, 0},
> +	.version     = {1, 5, 1},
>  	.features    = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ZONED_HM,
>  	.module      = THIS_MODULE,
>  	.ctr	     = delay_ctr,

