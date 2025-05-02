Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C514235044
	for <dm-devel@lists.linux.dev>; Fri,  2 May 2025 11:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746184350; cv=none; b=u3HtecUvuovRVPWXrjtZ+p0GEYYxX2+isyAo0a0eBPhAmHHkB9t6EhxpXmNbWP7zlYFxbmwk2x2dtDDn7yl9SQtIAS6G1iDKcfF/XndtRXIHj++y7cnG8QsBg4MPDuiLIJe84m39vckSBO+rudltQvTr6R4IdyPpmj/9B8+5fww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746184350; c=relaxed/simple;
	bh=DREzjcl9ABYrBk8gGvFsDp9hZlwFArIofTMcBzIYSAc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DPQrYsgh9YkrUPdx0OW9uHIOqH1sujXwQ2vXUJ5dYP24ViIW/zCvYp0eagVlFB9Y1Qz2ufPJHIW8RFI+0QY7fgXtdmh8Fs7wH7EYA+o0aeUp7PuczLVHqBz8G88mGHVHKVrWISb40kks3Hg9DD8fEPBuModbJPJGg5voAd8Vxb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VvoggCUk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VvoggCUk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746184347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FNoz6tRyg3xbTY50ONWx6bXruQQy98HNaRa9a2+ivBE=;
	b=VvoggCUkXIR9IjuWpCG1U4pLcp8ZTfSz03ctImPe+zIeZKA7RBnzfTCETY3c5autujtZfZ
	KG61jmHcgG2WL+80yyDMnvI5fRzuPm9ePWBHDFAktfnHdPic1C6Mx6no8xwcBw9D3HlgLr
	hs5EDwKDoeqHhzco0LXXrGHezJI26CM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-449-AycIMfrEPkWoi_gFOLjNtg-1; Fri,
 02 May 2025 07:12:25 -0400
X-MC-Unique: AycIMfrEPkWoi_gFOLjNtg-1
X-Mimecast-MFC-AGG-ID: AycIMfrEPkWoi_gFOLjNtg_1746184345
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A6EB1800368
	for <dm-devel@lists.linux.dev>; Fri,  2 May 2025 11:12:25 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36F0218001D5;
	Fri,  2 May 2025 11:12:22 +0000 (UTC)
Date: Fri, 2 May 2025 13:12:16 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev, 
    Kevin Wolf <kwolf@redhat.com>, Hanna Czenczek <hreitz@redhat.com>
Subject: Re: [PATCH] dm-mpath: Don't probe paths that are getting
 initialized
In-Reply-To: <20250501050624.2475903-1-bmarzins@redhat.com>
Message-ID: <2b27b24b-9044-0c96-b9d1-257901b54bb1@redhat.com>
References: <20250501050624.2475903-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3eZKftt_sRSj13bFFOTHQwRPmTmXTPENtVzOXr29Dl8_1746184345
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 1 May 2025, Benjamin Marzinski wrote:

> __switch_pg() sets m->current_pg before initializing the pathgroup. If
> probe_active_paths() is called and pathgroup has not been fully
> initialized, IO to the paths may fail, even though they will be usable
> when the pathgroup has finished initializing. Instead, skip sending IO
> in this situation and just return the number of usable paths. The next
> request will wait for the pathgroup to be fully initialized.

Thanks.

I folded this change into the existing patch.

Mikulas


> Fixes: d5d16fabe431 ("dm mpath: Interface for explicit probing of active paths")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  drivers/md/dm-mpath.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index af17a35c6457..53861ad5dd1d 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -2068,19 +2068,28 @@ static int probe_path(struct pgpath *pgpath)
>   *
>   * Return -ENOTCONN if no valid path is left (even outside of current_pg). We
>   * cannot probe paths in other pgs without switching current_pg, so if valid
> - * paths are only in different pgs, they may or may not work. Userspace can
> - * submit a request and we'll switch. If the request fails, it may need to
> + * paths are only in different pgs, they may or may not work. Additionally
> + * we should not probe paths in a pathgroup that is in the process of
> + * Initializing. Userspace can submit a request and we'll switch and wait
> + * for the pathgroup to be initialized. If the request fails, it may need to
>   * probe again.
>   */
>  static int probe_active_paths(struct multipath *m)
>  {
>  	struct pgpath *pgpath;
>  	struct priority_group *pg;
> +	unsigned long flags;
>  	int r = 0;
>  
>  	mutex_lock(&m->work_mutex);
>  
> -	pg = READ_ONCE(m->current_pg);
> +	spin_lock_irqsave(&m->lock, flags);
> +	if (test_bit(MPATHF_QUEUE_IO, &m->flags))
> +		pg = NULL;
> +	else
> +		pg = m->current_pg;
> +	spin_unlock_irqrestore(&m->lock, flags);
> +
>  	if (pg) {
>  		list_for_each_entry(pgpath, &pg->pgpaths, list) {
>  			if (!pgpath->is_active)
> -- 
> 2.48.1
> 

