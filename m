Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B03481DD
	for <dm-devel@lists.linux.dev>; Sat, 20 Dec 2025 04:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766204772; cv=none; b=k8m0ox3g99H81kLRsse3kkzdVu8dMN8rjgemz6ONQcZA30x7QoEj5Ch1jrJgoXjXk1ogTr+pu3Bee6fc1RD6VdPmEuMRrOkR01r2jRd1jkV23xxj2RfDLGMuzQbTqhX6F6XF/5pFKWYehO3Nc07koNUxZpatMsepl3n1tJd0ESs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766204772; c=relaxed/simple;
	bh=TCab3muFXCdfaaFWDHDB9RIglSEo64i5mi5tE8s1huc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=rsLVmOEKHrypnWUoTAjAxxB3O0giDhxjv2g98iFeM3k3TXxgmP3fQM8br55cmrc/qZ7RQWma2xWQ1uY1ofkrNlDnhT2anURNOeJR+FUZiM4V1e22ctEK1nN1kyJ1PHCWm/7KVrk6HRldzO0cXcdNty7tzHWJZVUcoolBzFewMww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FCpZ63Ap; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCpZ63Ap"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766204769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IZcQT5Gdk1c2ur+usx7BxtoPi7+Vvi2DV5Uq5tbQxhg=;
	b=FCpZ63ApmJkjQ2vNUDLqZabjkbAvsNLN6hXgyG3KypfTFFw/tByKlPWegX3/ZhSi6Pp4f7
	uvv8EW+q0/hZqMDC4ToVHaN12fRgUid26hl5okf1AOqHUQkWLQBNplQQ90/h5jwb38zXFw
	ZZ2jK8sZC8Y2fQRMGy+L4I9wlzfUkoU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-pK1POYI4Mv6b5CGzY7iN8A-1; Fri,
 19 Dec 2025 23:26:05 -0500
X-MC-Unique: pK1POYI4Mv6b5CGzY7iN8A-1
X-Mimecast-MFC-AGG-ID: pK1POYI4Mv6b5CGzY7iN8A_1766204764
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A64C18005AE;
	Sat, 20 Dec 2025 04:26:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E965530001A2;
	Sat, 20 Dec 2025 04:26:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BK4Q2Y42173730
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 19 Dec 2025 23:26:02 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BK4Q2X52173729;
	Fri, 19 Dec 2025 23:26:02 -0500
Date: Fri, 19 Dec 2025 23:26:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 16/26] libmultipath: remove
 cleanup_multipath_and_paths()
Message-ID: <aUYlWsyMZyJ9peTj@redhat.com>
References: <20251219144108.237928-1-mwilck@suse.com>
 <20251219144108.237928-17-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251219144108.237928-17-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UfXzHFIjA3OcogCggfjUtnVZiAcGNUp42MHneKIHe4w_1766204764
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 19, 2025 at 03:40:58PM +0100, Martin Wilck wrote:
> This function is not used any more.
> 
> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/libmultipath.version | 1 -
>  libmultipath/structs.c            | 6 ------
>  libmultipath/structs.h            | 1 -
>  3 files changed, 8 deletions(-)
> 
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 366b829..39384d6 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -69,7 +69,6 @@ global:
>  	cleanup_bindings;
>  	cleanup_lock;
>  	cleanup_multipath;
> -	cleanup_multipath_and_paths;
>  	cleanup_pathvec_and_free_paths;
>  	cleanup_udev_device_ptr;
>  	cleanup_udev_enumerate_ptr;
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 9e1734d..868c3d6 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -324,12 +324,6 @@ void cleanup_multipath(struct multipath **pmpp)
>  		free_multipath(*pmpp);
>  }
>  
> -void cleanup_multipath_and_paths(struct multipath **pmpp)
> -{
> -	if (*pmpp)
> -		free_multipath(*pmpp);
> -}
> -

Like I said in 14/26, I think we want to keep this to clean up
add_map_without_path(). It should loop through the paths in (*pmpp)->pg,
orphaning them, before calling free_multipath().

-Ben

>  void free_multipathvec(vector mpvec)
>  {
>  	int i;
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index a637af7..251e672 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -582,7 +582,6 @@ void free_pathgroup(struct pathgroup *pgp);
>  void free_pgvec(vector pgvec);
>  void free_multipath(struct multipath *mpp);
>  void cleanup_multipath(struct multipath **pmpp);
> -void cleanup_multipath_and_paths(struct multipath **pmpp);
>  void free_multipath_attributes(struct multipath *);
>  void free_multipathvec(vector mpvec);
>  
> -- 
> 2.52.0

