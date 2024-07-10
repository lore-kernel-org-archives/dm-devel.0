Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D49D1411ED
	for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 22:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720652088; cv=none; b=TP+wLxcWS271ty9LQXB/+uZRGlAdWAnZFmjXM0P/gom5Qi/CjucUz7S6AnbxGz1n/OdEs9hKIR1iYysCM5qsNn4gsjWeK6RbBxSUEg7YRhW8/ZbLVi+AHhVyTFRQf16Dy4igj+k9yGIEcUym9Se9pv10wblJgZhgsmmOfvK+9wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720652088; c=relaxed/simple;
	bh=l1HrtH72ZQM5L0LmZ7WnqcAQcVJQ7wk91hryri3FQgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=GvU3UqV91Nk6nXg7+1NyKzI7aAfO5mt1pG9DFQI06jd39G4y7s5C9IDBlaZpKsNqAiefQPlYcGEKfDWFvq0Bqyzqq5yeWdqGiyBYwz/fs+mLXDNIT7BxtKI54aw173itFElPtx865hBkMtQ4Fy4QgXJn4Pmjajkm6dw6C9u3WeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QN3mBlVK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QN3mBlVK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720652086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pvno/7DGMkSC5YhvQIeH/DyuGiGK2nPzRbsZZSgi9G8=;
	b=QN3mBlVK8GJn0ELYmQUwqhd/b+h5gKrqOM8q0cHAlvSrNMESX7pTIHvS+s+YXVcuqRA0Wq
	Gdkruq8gLyO5TV6L24VH8Jbzji41jrTu6n4/V9jEPPE7UmQvRovXKbbllvM3HDLoTAbRe8
	+QBKN10t2vzkmlQ2B9oLck74xmCEGkE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-258-McllgRjqNJCMguNrzqumkg-1; Wed,
 10 Jul 2024 18:54:43 -0400
X-MC-Unique: McllgRjqNJCMguNrzqumkg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B58D219560A3;
	Wed, 10 Jul 2024 22:54:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C14D1955F3B;
	Wed, 10 Jul 2024 22:54:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46AMse0u1921368
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 18:54:40 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46AMsecp1921367;
	Wed, 10 Jul 2024 18:54:40 -0400
Date: Wed, 10 Jul 2024 18:54:40 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 21/44] libmultipath: is_mpath_part(): improve parsing
Message-ID: <Zo8RMOqoXP-b3dWz@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-22-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-22-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:39:12PM +0200, Martin Wilck wrote:
> Use sscanf to make the parsing of the UUID more robust.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 56157af..d62a7dd 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -846,23 +846,20 @@ int dm_get_uuid(const char *name, char *uuid, int uuid_len)
>  
>  static int is_mpath_part(const char *part_name, const char *map_name)
>  {
> -	char *p;
> -	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN];
> +	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN], c;
> +	int np, nc;
>  
>  	if (dm_get_dm_uuid(part_name, part_uuid) != DMP_OK)
>  		return 0;
>  
> +	if (2 != sscanf(part_uuid, "part%d-%n" UUID_PREFIX "%c", &np, &nc, &c)

we should probably use "part%u-%n" so we can't match a "-" before the
number.

-Ben

> +	    || np <= 0)
> +		return 0;
> +
>  	if (dm_get_dm_uuid(map_name, map_uuid) != DMP_OK)
>  		return 0;
>  
> -	if (strncmp(part_uuid, "part", 4) != 0)
> -		return 0;
> -
> -	p = strstr(part_uuid, UUID_PREFIX);
> -	if (p && !strcmp(p, map_uuid))
> -		return 1;
> -
> -	return 0;
> +	return !strcmp(part_uuid + nc, map_uuid);
>  }
>  
>  int dm_get_status(const char *name, char **outstatus)
> -- 
> 2.45.2

