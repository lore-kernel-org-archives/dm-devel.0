Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC0F1547CC
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 22:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746568911; cv=none; b=ZWaguEGZSAaba/RQXCT/4K4G2Jm4GXvs3qwf7kNwfyKvUKmsow2vwxDM/Ox+aIBXVinxV8InBESuvZlPTS7Ok32gw6GAHQq1JCq7NVGfquk8ZZsd4bTttAaI21kDm0ZUy5cchqnzecHsV4P3BaNsGyTsaT0Iau0byGQQpPZPJvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746568911; c=relaxed/simple;
	bh=yLy+JISwYEhY49oGa7Dot+mQvcqqC0xMbVdAixXJQ8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Mu/PMeJ7bCDli8GYD/fd8Wazj4jCbCEVb1iv4Uyq0jgNgD/+BNtzP/0Rp4rrp5LGnWpJjiDQuZ2gGp1dmNkppJo/FFUJ20PPLtGhztOPzLWnvLzor0CAllFA+9vqDA0Kzj01EAyCXFFEzI/VzeDJ2xyLSRjH0IXy5OeK5QUqytw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GWftfIQS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GWftfIQS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746568908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0YTKrWMtNpYkwIcFkD1EuN5UvlzE13KoJSXhEEDeArE=;
	b=GWftfIQSRuvg5AEBc+ZLZnRVOiIKhar/bmh6UPPFHnshGDPAcpgGllAcs5UWEdsl1quQHL
	NvXmFKYOrXFDda2+GN/DFTD0nmJxZkeTDcjVfiGfQbDT3+ceoA7rRer8go+q7xPAITJP5T
	mzl1OBKRH92hcXUdhZFg9nI3vO8+Yu8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-NesNwHT0P8u1GxRIeqDwJg-1; Tue,
 06 May 2025 18:01:46 -0400
X-MC-Unique: NesNwHT0P8u1GxRIeqDwJg-1
X-Mimecast-MFC-AGG-ID: NesNwHT0P8u1GxRIeqDwJg_1746568905
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3AF251955D63;
	Tue,  6 May 2025 22:01:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8B301954B02;
	Tue,  6 May 2025 22:01:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 546M1hTk2972694
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 6 May 2025 18:01:43 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 546M1gPJ2972693;
	Tue, 6 May 2025 18:01:42 -0400
Date: Tue, 6 May 2025 18:01:42 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 4/6] libmpathutil: silence compiler warning in
 vector_del_slot()
Message-ID: <aBqGxgGHFuvADCQ4@redhat.com>
References: <20250505163007.59352-1-mwilck@suse.com>
 <20250505163007.59352-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250505163007.59352-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PB9BEiBUXyA3vJFoDiyOsURMEKPVBR-goW7BoL_LZHw_1746568905
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 05, 2025 at 06:29:56PM +0200, Martin Wilck wrote:
> Try to silence a gcc warning. Also, replace the wrong-looking
> VECTOR_DEFAULT_SIZE by 1 (after all, we've just deleted a single
> element).
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

Actually, now that I think about this a bit more, I don't think that
this was ever the right thing to do. If the realloc() fails, I see no
harm in keeping the smaller v->allocated value. Future realloc()s and
free()s will still work correctly. On the other hand, if we restore the
old, larger v->allocated value (or with your code, never reduce it in
the first place) there will be a duplicate value on the list, which I
can definitely see causing problems.

-Ben

>  	}
>  }
>  
> -- 
> 2.49.0

