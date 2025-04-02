Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB0F1514F6
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 09:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743587824; cv=none; b=ZF8sr+O4VvuhkYqSN9Joq6OpSmX2OMOZ3I/7l0o2+XHojd2VRAepF/jHur90137q5eclD1fZWjWZPvX2DgSxcG2oxLyxRkCRLf4mPvq69yjR7tQu4jMQg6M7CCt9xSeAEBYxqvFgeXk0efi6IGLhZw+jhT+f0xAm4gl2PjyDjv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743587824; c=relaxed/simple;
	bh=n0FrxmPnmDEsmjQmCsBHNTfqG/BeSqguYTaC6seNFJw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pVjp9pblLvWgSnP/OSH5YdC+8EU3LI1G8qAeB6CmOKJA0fSkFge/69OTCg0WoUF72eNGY2ffY1EZENgerUVFlWc5DX97f0y2h7ZYdO4uESce9inLXQWsl10GCKyNTjOf7mRXinsWuENKSqxtFx13QmAW8+F/z7U3eDEx2NKyFas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E0j2wJAn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E0j2wJAn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743587821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mk5Sq95sewudm1JEA4ZbLel264jd+9Y3ySkwO0Xh4wY=;
	b=E0j2wJAnPC2Ks+aqjsw5c8cKclfKCAWt8ESaBqcztLROAAchiIb4Hco8j1LFKW0dylAENL
	XTg23DwGpe7f18n6lS6c8u/6+uJeMnCn2rmJ2XDQAVv8HdCRa2ZWZ6LEN9zOMeHFA3Y5/0
	EVushfrxgMvJvRjibAkkhZ1clcmSkF4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-Zs_QBm35PtyS4nL41Kzu8A-1; Wed,
 02 Apr 2025 05:57:00 -0400
X-MC-Unique: Zs_QBm35PtyS4nL41Kzu8A-1
X-Mimecast-MFC-AGG-ID: Zs_QBm35PtyS4nL41Kzu8A_1743587818
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE37D1955BC1;
	Wed,  2 Apr 2025 09:56:58 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A43311801752;
	Wed,  2 Apr 2025 09:56:56 +0000 (UTC)
Date: Wed, 2 Apr 2025 11:56:51 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: snitzer@kernel.org, dm-devel@lists.linux.dev, guoweichao@oppo.com, 
    ebiggers@kernel.org, bvanassche@acm.org
Subject: Re: [PATCH 2/2] dm-verity: prefetch all hash blocks in verity_ctr
In-Reply-To: <20250402070934.2387587-2-weilongping@oppo.com>
Message-ID: <8ec81db3-fff0-71be-e643-b74cb5bb88de@redhat.com>
References: <20250402070934.2387587-1-weilongping@oppo.com> <20250402070934.2387587-2-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qgtyBjKBect89iDy7kG1kuyPt76TfPInyJWXNTBnJPk_1743587818
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 2 Apr 2025, LongPing Wei wrote:

> At this time, all bios for hash blocks should eventually
> be merged into a single large bio.
> 
> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> ---
>  drivers/md/dm-verity-target.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 3c427f18a04b..813d5cfc7ffa 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1683,6 +1683,10 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  
>  	verity_verify_sig_opts_cleanup(&verify_args);
>  
> +	dm_bufio_prefetch_with_ioprio(v->bufio, v->hash_start,
> +		v->hash_blocks - v->hash_start,
> +		IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 0));
> +
>  	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
>  
>  	return 0;
> -- 
> 2.34.1

Hi

I would move it into the "resume" callback, so that if the user 
reconfigures the device stack between "ctr" and "resume", it won't read 
the data too early.

Don't use IOPRIO_CLASS_RT, this is not real-time requirement, 
IOPRIO_CLASS_RT would slow down concurrent I/O.

Another problem with this approach is that when the verity device is big 
and system memory is small, it just causes I/O churn - new bufio blocks 
will be displacing old blocks - and it will degrade performance, not 
improve it.

Please, describe some scenario, where this prefetch actually helps. What 
is the size of the metadata that you are prefetching? What is the total 
memory size? Is there any benchmark that shows the advantage of this 
patch?

Mikulas

