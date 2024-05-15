Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501D2158DCF
	for <dm-devel@lists.linux.dev>; Wed, 15 May 2024 18:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715799199; cv=none; b=ZTYpVRpratQeKcHLHFkdwklX+VjTdeTa5uZ90H1KG6Qpb/zzlNjqav2tDQ1yZmiPJWWsCSj6FV/duxB6GcxbNIHz3Ix1ytYikZpUqfszTRKFB3jvRMd68YsP4MAYbQ47W16kQGBSKiV+80Tb8f0u+3NBRy8ryW4QJB1Ch5ezFZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715799199; c=relaxed/simple;
	bh=LMfXCqjdrrjdMJaooKui/eoqBYBAUjSVkdeswPX9jG4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hndt8CSvtGfZ9Ah9/7m+JhKvHlaxKkHmO4j5Ud6fgORPkBHpjKXhfxIev3+ZFVWCfaJotREPibpzMNROCmpyfd0nGv+19wbCALc5FQfe7pU2n9YSgyrP2TvmPn3c/JChYZBkAiF8H6iRKJECvny5OjZSr1wtOK0Yt+zx8hG/egM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B6I5M+Mo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B6I5M+Mo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715799196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4tqFMzk8g7twG0UnDqjK3nXlA2bgjQT2ni9SykI0q/Y=;
	b=B6I5M+MogeoZEwXnjvjtyb5HoiW3ABv2i8k8QeqZljX1WJx/J5JU0gHVzI7v6El35bwu7o
	ZgIZR1zO0YuowSFeoUb0KlveNeU5Qh3B74O7zalkZ2abJ+/MwserAhcQhrPYKVuSBj4XZf
	FoRcvzawt3fISygjlEy2M2PcJTXmb+Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-5aC5IzV5PT-WFz4bDugglw-1; Wed, 15 May 2024 14:53:04 -0400
X-MC-Unique: 5aC5IzV5PT-WFz4bDugglw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5672B8058CF;
	Wed, 15 May 2024 18:53:04 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D9781C018E3;
	Wed, 15 May 2024 18:53:04 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 33A0730C1C33; Wed, 15 May 2024 18:53:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 30AB93FB4F;
	Wed, 15 May 2024 20:53:04 +0200 (CEST)
Date: Wed, 15 May 2024 20:53:04 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm: remove unneeded kvfree from alloc_targets
In-Reply-To: <20240515184832.121949-1-bmarzins@redhat.com>
Message-ID: <856a11b9-97f3-c1f9-933d-94e4ef45f315@redhat.com>
References: <20240515184832.121949-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 15 May 2024, Benjamin Marzinski wrote:

> alloc_targets() is always called with a newly initialized table where
> t->highs == NULL.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-table.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 88114719fe18..d124e37dfb00 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -117,7 +117,6 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
>  	n_targets = (struct dm_target *) (n_highs + num);
>  
>  	memset(n_highs, -1, sizeof(*n_highs) * num);
> -	kvfree(t->highs);
>  
>  	t->num_allocated = num;
>  	t->highs = n_highs;
> -- 
> 2.45.0
> 

