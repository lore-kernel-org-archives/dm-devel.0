Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F317D21171D
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746560487; cv=none; b=WdzUaGDrGdH+vZJ4ZxQVa9zIthMk2KMTHIN+iPvZ9EMyaPXsYgg0W7ldvY7Cj4+QYGvAsJvkYZipdAyt8KmTU3s0ZoWtbJ1ew6G4Ol8DgyAFPrRIhaMTjg4c0Rw4mudI1mFxQwUp9M5d2AIa2wA5xLqXvyvv1uPSwlAIydjSeFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746560487; c=relaxed/simple;
	bh=BWCqkW1aGhINLY7HOXC+NV8bMZ0ZjFU/Hawo7cHpceM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=H72GzvIYpTVwMPROvuy3BcJTWdYVXdnrzbttNkBqJgJgba0nj7rqDqQuLtTHN8yQW6OskW7HNvj4D/MaSPFCEVZEJ5S+dioEZt2TiE/CAwnaBHE1JopaXCld5IuklJBFmvgylsIz8dSuaDCmQmUVCYIhOv8qQIloofkOi/466/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y9woF4uA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y9woF4uA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746560481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NSiZCXtbKymc4LuFXvPls2ItZLnxleucdaJX4cbgmnA=;
	b=Y9woF4uAu4Zq+oDl9Y6RRNxi5tszSlXU3Fp9Hcp0ikKlHiLn2c8CRMJM6XyyemH7okcUdC
	9dsy3NjiwjQGem3cjFtiLsxdMCkw/D12R8BPVfkGscEL36Hm61a8JIL9RQjxh+71Q+3RrV
	yGnwU//iSyhISxP/DlJfSiDL8oJIc54=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-434-sNqLZ-qCP3KexoYs4PFCGQ-1; Tue,
 06 May 2025 15:41:18 -0400
X-MC-Unique: sNqLZ-qCP3KexoYs4PFCGQ-1
X-Mimecast-MFC-AGG-ID: sNqLZ-qCP3KexoYs4PFCGQ_1746560476
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44C991801BD8;
	Tue,  6 May 2025 19:41:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0D5819560B1;
	Tue,  6 May 2025 19:41:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 546JfEwN2964796
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 6 May 2025 15:41:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 546JfC2f2964794;
	Tue, 6 May 2025 15:41:12 -0400
Date: Tue, 6 May 2025 15:41:12 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 4/6] libmpathutil: silence compiler warning in
 vector_del_slot()
Message-ID: <aBpl2Dx8F4q_CvLG@redhat.com>
References: <20250505163007.59352-1-mwilck@suse.com>
 <20250505163007.59352-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250505163007.59352-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IWNhQNszSsCIG81ckIUUwhZayjj8vzF8hDoaRNXX6h0_1746560476
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 05, 2025 at 06:29:56PM +0200, Martin Wilck wrote:
> Try to silence a gcc warning. Also, replace the wrong-looking
> VECTOR_DEFAULT_SIZE by 1 (after all, we've just deleted a single
> element).

I agree that VECTOR_DEFAULT_SIZE is pointless. But we shoud also stop
adding VECTOR_DEFAULT_SIZE to v->allocated in vector_alloc_slot() and
dividing v->allocated by VECTOR_DEFAULT_SIZE in VECTOR_SIZE(), otherwise
vector_del_slot() doesn't match vector_alloc_slot() and VECTOR_SIZE().
My vote is for VECTOR_DEFAULT_SIZE to go away completely.

-Ben

> 
> Found by Fedora's static analysis [1].
> 
> [1] https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathutil/vector.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
> index 7f763cb..3386651 100644
> --- a/libmpathutil/vector.c
> +++ b/libmpathutil/vector.c
> @@ -107,28 +107,28 @@ int find_slot(vector v, const void *addr)
>  void
>  vector_del_slot(vector v, int slot)
>  {
> -	int i;
> +	int i, allocated;
>  
>  	if (!v || !v->allocated || slot < 0 || slot >= VECTOR_SIZE(v))
>  		return;
>  
>  	for (i = slot + 1; i < VECTOR_SIZE(v); i++)
> -		v->slot[i-1] = v->slot[i];
> +		v->slot[i - 1] = v->slot[i];
>  
> -	v->allocated -= VECTOR_DEFAULT_SIZE;
> +	allocated = v->allocated - 1;
>  
> -	if (v->allocated <= 0) {
> +	if (allocated <= 0) {
>  		free(v->slot);
>  		v->slot = NULL;
>  		v->allocated = 0;
>  	} else {
>  		void *new_slot;
>  
> -		new_slot = realloc(v->slot, sizeof (void *) * v->allocated);
> -		if (!new_slot)
> -			v->allocated += VECTOR_DEFAULT_SIZE;
> -		else
> +		new_slot = realloc(v->slot, sizeof(void *) * allocated);
> +		if (new_slot) {
>  			v->slot = new_slot;
> +			v->allocated = allocated;
> +		}
>  	}
>  }
>  
> -- 
> 2.49.0

