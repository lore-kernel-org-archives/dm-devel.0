Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AB580B
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 18:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747075499; cv=none; b=bl1gUER5ZTpJekpTIjrLc0MzZTVN9/2ZyfwhP/1mAjoMWfS28V50GlbYYkaSUVkW7S1yW3tMqz/HhgLhmkh6PsTTk+IEWBAuQcGjHq81Tj0NzmZL3DRNMqIFTwQkZOmdNxQmYHIErdmtvZnvLosbLPFQUtDjdnKn4l/W57xekEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747075499; c=relaxed/simple;
	bh=4OgVDlD9mVYPMbdA9ZaU9y79UzL318WQqJh3jncm8Bo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=G+FO3n8ah0P1GBs8RZxQz3ImBDiyICVfZjEbWeetUiY8WO/J6hRIsIG+ogE3dF5sccKioXodz+uZgIN8v3bMueQjq6e+9GUkP/Ufka/HeL5wb3VNDYMd8alLkZaf5AYD0RZOF1ghfj8OeMWp2Qmalak++Il3aqJm4MeSuw4RrWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CvUvC9yM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CvUvC9yM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747075496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EXb97tV34TZtB48ata8+9ExrTLelyR/6qu+SvofSUcQ=;
	b=CvUvC9yMVkZcoKdRiF950I10x5oBk+FhU7v+c5ShQbSLRwSch3JgU7IDjtrhzUoxL1G5dd
	HBjH7UMq/2uW48atu3BcoG/LSZIOeu6pCTyVB+JxHWm3bX6u158wGDOlJVJ/Cc8w2WjmHZ
	os5LvmEYPRth7776IrBC65yq0A1jUq0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-365-0-U4tQ-IOl6QHx4aZ3VsFA-1; Mon,
 12 May 2025 14:44:51 -0400
X-MC-Unique: 0-U4tQ-IOl6QHx4aZ3VsFA-1
X-Mimecast-MFC-AGG-ID: 0-U4tQ-IOl6QHx4aZ3VsFA_1747075490
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1D371955E7A;
	Mon, 12 May 2025 18:44:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F8921800879;
	Mon, 12 May 2025 18:44:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54CIin0G3569504
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 14:44:49 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54CIimsA3569503;
	Mon, 12 May 2025 14:44:48 -0400
Date: Mon, 12 May 2025 14:44:48 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 8/8] libmpathutil: remove VECTOR_DEFAULT_SIZE macro
Message-ID: <aCJBoKZjE3ZbPuwO@redhat.com>
References: <20250507190552.209637-1-mwilck@suse.com>
 <20250507190552.209637-9-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250507190552.209637-9-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 21ojjmdwFdzRfdRWg0Z7UhenU04JhahiAekHoMkzvnU_1747075490
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2025 at 09:05:52PM +0200, Martin Wilck wrote:
> We always add or remove a single element in vector_add_slot() and
> vector_remove_slot(). Use of the VECTOR_DEFAULT_SIZE macro suggests that
> its value can be changed, but this is not the case.
> 
> Remove the macro.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmpathutil/vector.c | 4 ++--
>  libmpathutil/vector.h | 3 +--
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
> index 6ad5dd5..34a8512 100644
> --- a/libmpathutil/vector.c
> +++ b/libmpathutil/vector.c
> @@ -45,7 +45,7 @@ vector_alloc_slot(vector v)
>  	if (!v)
>  		return false;
>  
> -	new_allocated = v->allocated + VECTOR_DEFAULT_SIZE;
> +	new_allocated = v->allocated + 1;
>  	new_slot = realloc(v->slot, sizeof (void *) * new_allocated);
>  	if (!new_slot)
>  		return false;
> @@ -115,7 +115,7 @@ vector_del_slot(vector v, int slot)
>  	for (i = slot + 1; i < VECTOR_SIZE(v); i++)
>  		v->slot[i - 1] = v->slot[i];
>  
> -	v->allocated -= VECTOR_DEFAULT_SIZE;
> +	v->allocated--;
>  
>  	if (v->allocated <= 0) {
>  		free(v->slot);
> diff --git a/libmpathutil/vector.h b/libmpathutil/vector.h
> index 171ab6a..0a5b32e 100644
> --- a/libmpathutil/vector.h
> +++ b/libmpathutil/vector.h
> @@ -32,8 +32,7 @@ struct vector_s {
>  };
>  typedef struct vector_s *vector;
>  
> -#define VECTOR_DEFAULT_SIZE 1
> -#define VECTOR_SIZE(V)   ((V) ? ((V)->allocated) / VECTOR_DEFAULT_SIZE : 0)
> +#define VECTOR_SIZE(V)   ((V) ? (V)->allocated : 0)
>  #define VECTOR_SLOT(V,E) (((V) && (E) < VECTOR_SIZE(V) && (E) >= 0) ? (V)->slot[(E)] : NULL)
>  #define VECTOR_LAST_SLOT(V)   (((V) && VECTOR_SIZE(V) > 0) ? (V)->slot[(VECTOR_SIZE(V) - 1)] : NULL)
>  
> -- 
> 2.49.0

