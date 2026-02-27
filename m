Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156C946AF25
	for <dm-devel@lists.linux.dev>; Fri, 27 Feb 2026 19:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772221951; cv=none; b=Qxnt60Ke0T+UdBMvaZHb9X5vwFtH1J8fJTVeLNdvLggquopTVHvj3/4PUp6VehqCqQOGjwU53r9QiOBdnHgU5WNq3MrmbVIu0VapjGECP7mENVlMp98XiSbxa7J8oOKmbPqeETbAt8cGAIr7PnnDSEr+7RuglYfTLj5uIREHtnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772221951; c=relaxed/simple;
	bh=AVjNWv52I/SShc+g8l5QzIxcmqI4KZIzz5YjHaqQqns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fsFzjGt21+xxcxjzlEcmMpWPN3GmFZVqZZcRHjAljQcgNTLx1ux27kkmYUBFQ7F6syOUBfoyQYggVAweK/sLxQBVTBfeF4EDYgYMgan8fK2/CzHSKPtTQAtpcYmkhJfwNMqYN9pZtZt/4VbeH/WOstI7GxT3xX9U2jIvexYzPEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fYb/hcWa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fYb/hcWa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772221945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i9XwpDxs/qoFLn1Jvyqbmikgtgk6yGhzXhIV9M3DNKQ=;
	b=fYb/hcWaUK5VducarmXvXRPd00jg3evRo4KqabMDXhjJEWOBQ0+8kzjLIPcdUy7PA+ZFyl
	Of8fAGWwQ2ZXN6zPf95dgrQn4XM/JNA636nohBLCEF7RWoxlmbrrrBlG2ILrdkVGqwYVpC
	NwSL6tPmsboqaWfiil8kTFFOATBcpmQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-AAfjTlalMvC76zMyXgTzMA-1; Fri,
 27 Feb 2026 14:52:21 -0500
X-MC-Unique: AAfjTlalMvC76zMyXgTzMA-1
X-Mimecast-MFC-AGG-ID: AAfjTlalMvC76zMyXgTzMA_1772221939
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C8E61956063;
	Fri, 27 Feb 2026 19:52:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47D8B1800286;
	Fri, 27 Feb 2026 19:52:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 61RJqH8H1743483
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 14:52:17 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 61RJqG1o1743482;
	Fri, 27 Feb 2026 14:52:16 -0500
Date: Fri, 27 Feb 2026 14:52:16 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/13] libmultipath: Add support for block device IOCTL
Message-ID: <aaH18HKCMdjuUhUh@redhat.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-12-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260225153225.1031169-12-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 38gFNqWNdXvoDPKrDk7HACXDUCSbxy_eKs1fWRFz6pk_1772221939
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 25, 2026 at 03:32:23PM +0000, John Garry wrote:
> Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
> handler calls into driver mpath_head_template.ioctl handler.
> 
> It is expected that the .ioctl handler will unlock the SRCU read lock,
> as this is what NVMe requires - see nvme_ns_head_ctrl_ioctl(). As such,
> export a handler to unlock, mpath_head_read_unlock().
> 
> The .compat_ioctl handler is given the standard handler.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  include/linux/multipath.h |  4 ++++
>  lib/multipath.c           | 42 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+)
> 
> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
> index 3846ea8cfd319..40dda6a914c5f 100644
> --- a/include/linux/multipath.h
> +++ b/include/linux/multipath.h
> @@ -72,6 +72,9 @@ struct mpath_head_template {
>  	bool (*is_disabled)(struct mpath_device *);
>  	bool (*is_optimized)(struct mpath_device *);
>  	enum mpath_access_state (*get_access_state)(struct mpath_device *);
> +	int (*bdev_ioctl)(struct block_device *bdev, struct mpath_device *,
> +			blk_mode_t mode, unsigned int cmd, unsigned long arg,
> +			int srcu_idx);

I don't know that this API is going to work out. SCSI persistent
reservations need access to all the mpath_devices, not just one, and
they are commonly handled via SG_IO ioctls. Unless you want to disallow
SCSI persistent reservations via SG_IO, you need to be able to detect
them, and handle them using the persistent reservation code with the
mpath_head.

-Ben 

