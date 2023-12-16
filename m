Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B201869
	for <dm-devel@lists.linux.dev>; Sat, 16 Dec 2023 03:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dh5fsGq8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702696460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V8t0v8BPNN1v0zmHJDAI3kLVomqmIa9H+2bSSU4M/2A=;
	b=dh5fsGq8lIJU1TFFubFALpJi5x9beZpV8Gm3yXlNwSHUO5Ci7aeg43PgD45m0mUKMguA0D
	uWiy6d9bbCQeZzEVTTBCW/ns+T1XNkdf6Ifd/ms6EZYPRCbXRjN6X1P+WqayH+VNxIaTn3
	q1hC6vfCyoBxuJs25A4qDc7s9UCC5cI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-bCf6XgPzP-u4saHfVxd1Kg-1; Fri, 15 Dec 2023 22:14:16 -0500
X-MC-Unique: bCf6XgPzP-u4saHfVxd1Kg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5ACFF85CBA3;
	Sat, 16 Dec 2023 03:14:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F9D11121306;
	Sat, 16 Dec 2023 03:14:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BG3EGAe677796
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 22:14:16 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BG3EGam677795;
	Fri, 15 Dec 2023 22:14:16 -0500
Date: Fri, 15 Dec 2023 22:14:16 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] multipath-tools: update ml
Message-ID: <ZX0WCGih3Q6ElsrO@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231215233247.48078-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231215233247.48078-1-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 16, 2023 at 12:32:46AM +0100, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libdmmp/docs/man/libdmmp.h.3 | 2 +-
>  libmultipath/hwtable.c       | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libdmmp/docs/man/libdmmp.h.3 b/libdmmp/docs/man/libdmmp.h.3
> index 45d5be3e..7c57041d 100644
> --- a/libdmmp/docs/man/libdmmp.h.3
> +++ b/libdmmp/docs/man/libdmmp.h.3
> @@ -110,4 +110,4 @@ below in case you want to create your own log handler.
>  GPLv2+
>  
>  .SH "BUG"
> -Please report bug to <dm-devel@redhat.com>
> +Please report bug to <dm-devel@lists.linux.dev>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index ae6aac79..808af544 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -11,7 +11,7 @@
>  
>  /*
>   * Tuning suggestions on these parameters should go to
> - * dm-devel@redhat.com (subscribers-only, see README)
> + * <dm-devel@lists.linux.dev> (see README.md)
>   *
>   * You are welcome to claim maintainership over a controller
>   * family. Please mail the currently enlisted maintainer and
> -- 
> 2.43.0

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

