Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8B129D266
	for <dm-devel@lists.linux.dev>; Wed, 28 Jan 2026 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769611763; cv=none; b=dZG35+sFJ8eN5CVtxt9KSwqPvxbmXncBO+jSa+M3lqP6r5qJ3+zgsO8h1bczQ6Ri5nsxrUIA8GPvHVtZzP/E9zJvNzz7929+lTkdmGmzqNHz63R9O/mRi6hP3fZe4GIw0xNTt7hzLeqhyzUP/u4OhzOFkijoO7V8iJ6wnJntMgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769611763; c=relaxed/simple;
	bh=pgKYzyXjiyZ/cUJwohrHnJWjTh1f9+sVdqqsRhUIuPU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gS3Nw9uOtoRezPNis/raqPtRc0lrmatRUzr6qb7Si1f3LE9lk/PdnA5DQaH/EsAFlI4lg5nWGumrAoRQgelb66Ex0D2w6p1nc7kYJli1O/iqmNBlLgzBz+mnOtDN1IE6HGJxBL8GQks3KeR9c+MWv11qSmExg6+MKvVWDkjlKzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eJA6XeUo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eJA6XeUo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769611761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9G9bDFnWSXeRzSK3qaPwt3SgRB4UsVE/HgAPXEV0jn4=;
	b=eJA6XeUoWUt0g6HTAAR25whnorgrdXN+VUUp+6ZXq6v5N+v/MaMt4tJ2tPGe2WVJovIQxl
	T7uGLjrQ2wjHe6Fqbj04Tx10UEkzsq1wHC3VbfFSy9AMXc0qHyd7+9oob2QQhp25w6MMLp
	lOCkZVwG/UVSrLEI8NO7XJhQ0q4XhV4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-569-nOmUJrThMxC9eXuW1psBNQ-1; Wed,
 28 Jan 2026 09:49:18 -0500
X-MC-Unique: nOmUJrThMxC9eXuW1psBNQ-1
X-Mimecast-MFC-AGG-ID: nOmUJrThMxC9eXuW1psBNQ_1769611757
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C86DC18002C9;
	Wed, 28 Jan 2026 14:49:16 +0000 (UTC)
Received: from [10.45.224.108] (unknown [10.45.224.108])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D1131800109;
	Wed, 28 Jan 2026 14:49:15 +0000 (UTC)
Date: Wed, 28 Jan 2026 15:49:10 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@kernel.org>, Martin Wilck <mwilck@suse.com>, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/3] dm mpath: Minor multipath related cleanup
In-Reply-To: <20260128001224.462746-1-bmarzins@redhat.com>
Message-ID: <8878a0af-5b83-8c54-5c00-398d768a790e@redhat.com>
References: <20260128001224.462746-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AseYrwx8sryZZ3FWgsgNE17xxpwKMeFvhFLlFUFxAM0_1769611757
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 27 Jan 2026, Benjamin Marzinski wrote:

> This patchset fixes two minor bugs in creating multipath devices, and
> removes some dm locking that is no longer necessary after a change in the
> multipath code.
> 
> Benjamin Marzinski (3):
>   dm mpath: Add missing dm_put_device when failing to get scsi dh name
>   Revert "dm: fix a race condition in retrieve_deps"
>   dm mpath: make pg_init_delay_msecs settable
> 
>  drivers/md/dm-core.h  |  1 -
>  drivers/md/dm-ioctl.c |  7 +------
>  drivers/md/dm-mpath.c | 22 +++++++++++-----------
>  drivers/md/dm-table.c | 32 ++++++++------------------------
>  4 files changed, 20 insertions(+), 42 deletions(-)
> 
> -- 
> 2.50.1

Hi

I accepted all three patches. I added Cc: stable@vger.kernel.org to patch 
1 and 3.

Mikulas

