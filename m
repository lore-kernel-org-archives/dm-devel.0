Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643833DFE2
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 19:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IH7QrEQL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698434976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gkb+dHOyzWEzqj+ZVcvSnSNdyKPOL0PpaZhhSWcoLXY=;
	b=IH7QrEQL8lI9ig4MpCBHF47A15BFhl+U0zCg1gaEEliwXhRNu5qGiMOsnYL/pwPewElKT7
	gsBVDMkq+a7Y6ZWwJYvGm/sVzTD6kojYDslf4vkcno7onw/HcWE3nf0L6GEwcj/KQHc2RS
	DcFdDvaxyhFq/b5irRj4Td/q3Y+gHAo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-UexiSL4vN467bInDNop4-g-1; Fri, 27 Oct 2023 15:29:34 -0400
X-MC-Unique: UexiSL4vN467bInDNop4-g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 478E189B3F0;
	Fri, 27 Oct 2023 19:29:34 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4048C1121320;
	Fri, 27 Oct 2023 19:29:34 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39RJTY78049751
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Oct 2023 15:29:34 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39RJTYlb049750;
	Fri, 27 Oct 2023 15:29:34 -0400
Date: Fri, 27 Oct 2023 15:29:34 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v2 12/14] README.md: update mailing list and contributing
 information
Message-ID: <ZTwPnti1mnkGK19V@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231026174153.1133-1-mwilck@suse.com>
 <20231026174153.1133-13-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231026174153.1133-13-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2023 at 07:41:51PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Create a "Contributing" section. Move the the current sections
> related to contributing into that section.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  README.md | 56 ++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 37 insertions(+), 19 deletions(-)
> 
> diff --git a/README.md b/README.md
> index 25ce963..b2ed1f2 100644
> --- a/README.md
> +++ b/README.md
> @@ -42,14 +42,6 @@ Go to: https://github.com/opensvc/multipath-tools/tags
>  Select a release-tag and then click on "zip" or "tar.gz".
>  
>  
> -Devel code
> -==========
> -
> -To get latest devel code:
> -
> -    git clone -b queue https://github.com/openSUSE/multipath-tools
> -
> -
>  Building multipath-tools
>  ========================
>  
> @@ -188,19 +180,45 @@ The following targets are intended for developers only.
>   * `make compile-commands.json` to create input for [clangd](https://clangd.llvm.org/).
>  
>  
> -Add storage devices
> -===================
> -
> -Follow the instructions in the `libmultipath/hwtable.c` header.
> -
> -
> -Mailing list
> +Contributing
>  ============
>  
> -(subscribers-only)
> -To subscribe and archives: https://listman.redhat.com/mailman/listinfo/dm-devel
> -Searchable: https://marc.info/?l=dm-devel
> +Please send patches or contributions for general discussion about
> +multipath tools to the mailing list (see below). You can also create
> +issues or pull requests on
> +[GitHub](https://github.com/opensvc/multipath-tools).
> +You will be asked to send your patches to the mailing list
> +unless your patch is trivial.
>  
> +Mailing list
> +------------
> +
> +The mailing list for multipath-tools is `dm-devel@lists.linux.dev`.
> +To subscribe, send an email to `dm-devel+subscribe@lists.linux.dev`.
> +Mailing list archives are available on
> +[lore.kernel.org](https://lore.kernel.org/dm-devel/) and
> +[marc.info](https://marc.info/?l=dm-devel). See also the
> +[lists.linux.dev home page](https://subspace.kernel.org/lists.linux.dev.html).
> +
> +When sending patches to the mailing list, lease add a `Signed-off-by:`

Missed the 'p' in please. Otherwise this looks fine.

-Ben

> +tag, and add Benjamin Marzinski <bmarzins@redhat.com> and 
> +Martin Wilck <mwilck@suse.com> to the Cc list.
> +
> +Staging area
> +------------
> +
> +Between releases, the latest reviewed code can be obtained from
> +[the queue branch](https://github.com/openSUSE/multipath-tools/tree/queue)
> +in the openSUSE/multipath-tools repository on GitHub. From there,
> +pull requests for new releases in the master repository are
> +created roughly every 3 months.
> +
> +Adding new storage devices
> +--------------------------
> +
> +If you want to add special settings for a storage device which is
> +new on the market, follow the instructions at the top of the
> +file `libmultipath/hwtable.c`.
>  
>  Changelog
>  =========
> @@ -213,7 +231,7 @@ Maintainer
>  ==========
>  
>  Christophe Varoqui <christophe.varoqui@opensvc.com>
> -Device-mapper development mailing list <dm-devel@redhat.com>
> +Device-mapper development mailing list <dm-devel@lists.linux.dev>
>  
>  
>  Licence
> -- 
> 2.42.0

