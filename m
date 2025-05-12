Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389D51519B8
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 18:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747074896; cv=none; b=GEv/daMNbeuOVUAg0BQ6zTSm9wSkInEZpGhFlTJ0ZDhUsyDT6hB1tcF9r9bqwzG2juMieHVhvsSkHxfBAdnynySO+m1wAG70RYA4S99G50MiolP1/rqbb0cQSp3nxg1EU2wCz8DEdRi3lRXWpf44OD2NthKXi/2uL3hBENwISHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747074896; c=relaxed/simple;
	bh=2esQvVf81JCR8ny25xp1O3D4qlD6pDROQ5lm+fZBg8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=HRcKVYJS4HdnAcHPOOs9wvGSFwXUagMzv+xp/0TDAj722ixLhiRD5L2sUqAvuPAVXs0HjNNcD6oj1uo+mCPvmeBhftfZZxBiYUhdUMyR/lUMcHDUVn+bqLZi1ebMDQTxAGaQyGS9wMQpn8MNtzu4tmVFDyNJaOyJ1W66YvSKF/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=glaizN8Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="glaizN8Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747074893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T5WGEz6B1XAFzQmJsIQkkkhDboEm7SsduDdaOr0lL9M=;
	b=glaizN8Yb8vCh7m/3IVr8wJNLpl/nYmHU7iuVZzm/eC4NRavkiQaJIsGSpjATssHFJh9KC
	+OS3cK9qI8yJ1p/dVUfrNvPa+Y11vPFqXcP4tAxlyfrb+pEoL6JUI0NYy3DYjRF3edmAi/
	bU1WRVz57ZnCTEC8Nut5HJ7TD7CevWU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-AHWPGnW5NX2aNMvsISCmkw-1; Mon,
 12 May 2025 14:34:49 -0400
X-MC-Unique: AHWPGnW5NX2aNMvsISCmkw-1
X-Mimecast-MFC-AGG-ID: AHWPGnW5NX2aNMvsISCmkw_1747074888
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D3FC180035C;
	Mon, 12 May 2025 18:34:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D96618001DA;
	Mon, 12 May 2025 18:34:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54CIYknt3568966
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 14:34:46 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54CIYktl3568965;
	Mon, 12 May 2025 14:34:46 -0400
Date: Mon, 12 May 2025 14:34:46 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 4/8] libmpathutil: vector_del_slot: modify
 v->allocated if realloc fails
Message-ID: <aCI_RnU7azD4LQ1_@redhat.com>
References: <20250507190552.209637-1-mwilck@suse.com>
 <20250507190552.209637-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250507190552.209637-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lY3DjOLup3cmlNWKpvP7iVQjxSROx40S-EW0PtMxKaE_1747074888
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2025 at 09:05:48PM +0200, Martin Wilck wrote:
> We use v->allocated with the semantics of "length" or "number of used
> elements" of a vector. If realloc() fails while deleting an element,
> we should keep the previously allocated v->slot array but still
> decrement "allocated" in order to avoid accessing invalid vector
> elements.
> 
> The next successful realloc will bring v->allocated and the actual
> size of the array in sync again.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmpathutil/vector.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
> index 7f763cb..f69d644 100644
> --- a/libmpathutil/vector.c
> +++ b/libmpathutil/vector.c
> @@ -113,7 +113,7 @@ vector_del_slot(vector v, int slot)
>  		return;
>  
>  	for (i = slot + 1; i < VECTOR_SIZE(v); i++)
> -		v->slot[i-1] = v->slot[i];
> +		v->slot[i - 1] = v->slot[i];
>  
>  	v->allocated -= VECTOR_DEFAULT_SIZE;
>  
> @@ -125,9 +125,15 @@ vector_del_slot(vector v, int slot)
>  		void *new_slot;
>  
>  		new_slot = realloc(v->slot, sizeof (void *) * v->allocated);
> -		if (!new_slot)
> -			v->allocated += VECTOR_DEFAULT_SIZE;
> -		else
> +		/*
> +		 * If realloc() fails, v->allocated will be smaller than the
> +		 * actual allocated size vector size.
> +		 * This is intentional; we want VECTOR_SIZE() to return
> +		 * the number of used elements. Otherwise, vector_for_each_slot()
> +		 * et al. wouldn't work as intended; there might be duplicate
> +		 * or stale elements at the end of the vector.
> +		 */
> +		if (new_slot)
>  			v->slot = new_slot;
>  	}
>  }
> -- 
> 2.49.0

