Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA9230C368
	for <dm-devel@lists.linux.dev>; Fri,  6 Mar 2026 23:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772840881; cv=none; b=dMGSKKSLwR8yzCUoPj04SmJ0ral1WsUoYiDeT++l8VrLHaADb5AZ5VxgtQXOSeNsrOeNmNEvogRCzQaZxrRexV9twBZDg94GV/aNJjns6A5d80cBUR57nMgUUD1cbDMmQDJoGOURS8mBNtn3fKYVGPT1VX4T0cJ3eV2bGSJA/SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772840881; c=relaxed/simple;
	bh=MuffJ8cV+b81+CCFgaGxbTsOBjxJJiMSxtmtaszX+Rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=It40F4uKlSn6hqrLXCPANwlqEyFxd9iU1ks/NCDXwP9rC8LfBJ+Mp5NYgzDsucmssPjLVeteGRRiiIg2Ok/Feg3vhpAz2+B663/qWix2LyCRhllhttgEV59iXeLqt7au+4Gq1X8DKkC19Q8lUcB+/nYzWQQ/F4HC9SAY9dt0rcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BwIgU29n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BwIgU29n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772840879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JQmmUGuLbriGLig2g9To9mIBST3QPI8EO5FGJApZ5AU=;
	b=BwIgU29n8axr3CAeb5A83uPyDE4sg9n8XLrOJ1bEeX4MWtYFRDuFfvu6HoOemg4k8C4XGv
	I2ackdpP5wOON4qPMztdmYzAIRKCaJvd38Ef/8u6li5BEtRmlpMkn/tpgfUDTC9uag1Ec2
	HOpv1oZwcni0Kwmh3jxU2/agwdTPQmA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-150-57eK97dTM4Wv4As_wFsJ-w-1; Fri,
 06 Mar 2026 18:47:56 -0500
X-MC-Unique: 57eK97dTM4Wv4As_wFsJ-w-1
X-Mimecast-MFC-AGG-ID: 57eK97dTM4Wv4As_wFsJ-w_1772840875
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 06171195608D;
	Fri,  6 Mar 2026 23:47:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E01F180035F;
	Fri,  6 Mar 2026 23:47:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 626Nlr612026325
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 6 Mar 2026 18:47:53 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 626Nlrkc2026324;
	Fri, 6 Mar 2026 18:47:53 -0500
Date: Fri, 6 Mar 2026 18:47:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: luoqing <l1138897701@163.com>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
        mpatocka@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dm-bufio: Use struct_size() helper in kmalloc()
Message-ID: <aatnqYei263w5RHG@redhat.com>
References: <20260306080257.1268206-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260306080257.1268206-1-l1138897701@163.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: bHGODJ7urAtFxAuX62l_7eub1RVKCrghi6dqp35fQ9s_1772840875
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 06, 2026 at 04:02:57PM +0800, luoqing wrote:
> From: luoqing <luoqing@kylinos.cn>
> 
> Make use of the struct_size() helper instead of an open-coded version,
> in order to avoid any potential type mistakes or integer overflows that,
> in the worst scenario, could lead to heap overflows.
> 
> Signed-off-by: luoqing <luoqing@kylinos.cn>
> ---
>  drivers/md/dm-bufio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 60f7badec91f..f8a6b423b4ea 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -2511,7 +2511,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
>  	}
>  
>  	num_locks = dm_num_hash_locks();
> -	c = kzalloc(sizeof(*c) + (num_locks * sizeof(struct buffer_tree)), GFP_KERNEL);
> +	c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);

buffer_tree isn't a member of struct dm_bufio_client (which is the type
of *c). Its a member of struct dm_buffer_cache (which is the type of
c->cache). Since struct_size() uses the same variable for referring to the
base structure and the structure holding the flex array, it won't work
here.

-Ben

>  	if (!c) {
>  		r = -ENOMEM;
>  		goto bad_client;
> -- 
> 2.25.1

