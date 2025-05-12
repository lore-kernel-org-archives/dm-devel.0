Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0664175BF
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747074931; cv=none; b=cDyk3TTFvq60TdTFvTtTKlB+OQfYKHvdJkmIONL/b7du7OP97L+A8SQDLzQ1Gr110C69ju9QLrKXWon8ou+UERY0l9JYDbCHzYPoo3474WS+U2M1cJOid8npiZdDUiZOsUIustG6FLtpZeffBpBm/NkLthEasfVPQT2vaqHq9uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747074931; c=relaxed/simple;
	bh=2tEjxwxGmlR+QcYCc+MfYTYToCFc0Ws2Eww2pnK8u2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=mQTvrOltE7U5GYwmuchRd0BtsnPGoXpoVMLR3/vfaVC7aFW2BlqeE0TUoMYr40E3nPIdWCMmArgH4Md+uTEDKV7+8wM9tRblbHZVmw08nndkHaG0wrI9ctct4Jn8f0lQT1yJqwM+BnCZ24d6SE20gNqLvmDvYSzE8FJvICekacc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BtMyBMko; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BtMyBMko"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747074927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qZRfBPn3c8xLbmpf6MrJmtPHU/U/W6Mp1oxSc8AmvQg=;
	b=BtMyBMkojLdNnRBdUk7Z0PBs9L6U8k93fnkXVgqfzmHai7PsW4IDq7qvPSccAevUZFiGYG
	LFu9Bt+RSrs94OJqUg/nDs/v+8gdwRQEO07EpF2NvtIUToHVeTPWLnejtgV4aWUTn0VXHR
	MDrNfWWLBb1H/caLyIVtDYYdcsUNMIs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-161-87odw4x9NSS1t_0Kjzz8ww-1; Mon,
 12 May 2025 14:35:22 -0400
X-MC-Unique: 87odw4x9NSS1t_0Kjzz8ww-1
X-Mimecast-MFC-AGG-ID: 87odw4x9NSS1t_0Kjzz8ww_1747074920
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0F88180045C;
	Mon, 12 May 2025 18:35:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E00719560AB;
	Mon, 12 May 2025 18:35:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54CIZIJv3568999
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 14:35:18 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54CIZI4a3568998;
	Mon, 12 May 2025 14:35:18 -0400
Date: Mon, 12 May 2025 14:35:18 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 7/8] libmpathutil: remove vector_repack()
Message-ID: <aCI_Znj42P7M5fig@redhat.com>
References: <20250507190552.209637-1-mwilck@suse.com>
 <20250507190552.209637-8-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250507190552.209637-8-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: crC1BvzQQQeLr3hbG-ULR5eBexWGyfF05VsN9A1JCHc_1747074920
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2025 at 09:05:51PM +0200, Martin Wilck wrote:
> This function is unused, and its implementation looks odd.
> Remove it.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmpathutil/vector.c | 13 -------------
>  libmpathutil/vector.h |  1 -
>  2 files changed, 14 deletions(-)
> 
> diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
> index f69d644..6ad5dd5 100644
> --- a/libmpathutil/vector.c
> +++ b/libmpathutil/vector.c
> @@ -138,19 +138,6 @@ vector_del_slot(vector v, int slot)
>  	}
>  }
>  
> -void
> -vector_repack(vector v)
> -{
> -	int i;
> -
> -	if (!v || !v->allocated)
> -		return;
> -
> -	for (i = 0; i < VECTOR_SIZE(v); i++)
> -		if (i > 0 && v->slot[i] == NULL)
> -			vector_del_slot(v, i--);
> -}
> -
>  vector
>  vector_reset(vector v)
>  {
> diff --git a/libmpathutil/vector.h b/libmpathutil/vector.h
> index 85127ad..171ab6a 100644
> --- a/libmpathutil/vector.h
> +++ b/libmpathutil/vector.h
> @@ -86,7 +86,6 @@ extern void vector_del_slot(vector v, int slot);
>  extern void *vector_insert_slot(vector v, int slot, void *value);
>  int find_slot(vector v, const void *addr);
>  int vector_find_or_add_slot(vector v, void *value);
> -extern void vector_repack(vector v);
>  extern void vector_dump(vector v);
>  extern void dump_strvec(vector strvec);
>  extern int vector_move_up(vector v, int src, int dest);
> -- 
> 2.49.0

