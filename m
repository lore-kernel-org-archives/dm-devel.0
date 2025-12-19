Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6D73D76
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 00:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766103039; cv=none; b=WzpimRAaelsAE008v/k+wvliD4C9A8n16WPyP/asjfzGX6yXkhZrHw2ozkMq4sT59KCCfz/916sj25mMT4zGZBdQ9UHRiMdmPikQwXqqs/mQo+6ZXsaWCZeYfFfmbZ9XcbISH1DMy6AzB1VlDD5FS4Lzq9J9TqY0RCR6KyLsdGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766103039; c=relaxed/simple;
	bh=4tLaaKrpeU9BDxb/MxUBPuzmHu2wcfvSj3o5htxWA38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ZuigLXm4qLVQwA36MkL3C1dW/WAz8j9E81UN+SEzSM/e9g3j1GVn5NCbaPyzKHcRs+3fXA0cKo4vVO6maSGUs5FZRpf0bdlxqjtSBVUAk7n2Af9PShVQJ/IjdISrtyZRuze142D3v6eDvGWJOjGDkDIWEtnDU6Lp6urrm4CDT5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hvYVYnLv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hvYVYnLv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766103036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LVlhgf0GfpqBxNko80xu6z5U0D44HdKIMQjnbcxG5Ss=;
	b=hvYVYnLvefQ4/tdBxjym8KZUjopLDathf4/1Na783Bl9GxI19gDVZWEjpvusxkWuncWozs
	Usq3pFz4JPnTUHEaFkYdmGbq4+Aa0Jhdz8It+5a9yMySNzkS/nhDAU45m5ZfqURiqd5Fu6
	akWLZBK3PaAtP2wjG18uVgZRV9vVPMY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-52-SnUW2aAOPDS4RxOTPqyG8Q-1; Thu,
 18 Dec 2025 19:10:35 -0500
X-MC-Unique: SnUW2aAOPDS4RxOTPqyG8Q-1
X-Mimecast-MFC-AGG-ID: SnUW2aAOPDS4RxOTPqyG8Q_1766103034
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F9781800451;
	Fri, 19 Dec 2025 00:10:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2886130001A2;
	Fri, 19 Dec 2025 00:10:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BJ0AXhp2124052
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 19:10:33 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BJ0AX0n2124051;
	Thu, 18 Dec 2025 19:10:33 -0500
Date: Thu, 18 Dec 2025 19:10:32 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 09/21] libmultipath: fix numeric value of free_paths in
 free_multipaths()
Message-ID: <aUSX-PumAC-MqM8m@redhat.com>
References: <20251217212113.234959-1-mwilck@suse.com>
 <20251217212113.234959-10-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217212113.234959-10-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QjIYY-MI73Vuu-Bfxrszvp1tLbAXYr-_KNX2fH9yZBQ_1766103034
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 17, 2025 at 10:21:01PM +0100, Martin Wilck wrote:
> free_paths is an enum, use the enum value.

I think free_multipath() should always keep the paths. It only doesn't
in cleanup_multipath_and_paths(), which is used in two places, and is
wrong in one and unnecessary in the other. check_usable_paths() could
just use cleanup_multipath(). The paths will be added to the pathvec by
update_multipath_table__(), and we can clean that up with a cleanup
handler that calls free_pathvec(). In add_map_without_path() using
cleanup_multipath_and_paths() is just wrong. We don't want it to free
all the paths. Instead it should orphan the paths before calling
free_multipath(). That will flag paths that need to get removed for
removing, but it won't actually free paths that are in the pathvec
(without removing them from the pathvec, to make matters worse).
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/structs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index aaa7e50..059d454 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -310,7 +310,7 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
>  		mpp->alias = NULL;
>  	}
>  
> -	if (!free_paths && mpp->pg) {
> +	if (free_paths == KEEP_PATHS && mpp->pg) {
>  		struct pathgroup *pgp;
>  		struct path *pp;
>  		int i, j;
> -- 
> 2.52.0

