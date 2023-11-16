Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0698548CE1
	for <dm-devel@lists.linux.dev>; Thu, 16 Nov 2023 17:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b24jq/2z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700154885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=almFEi8vTZA58gr6fCZahQGEc7wY7XjRk6JQup9swIw=;
	b=b24jq/2z4aw1TLCIB6tr7SSqY+eAt2yb7Uq7an+zuEGxZ9eCq6GSNbpwyZGu6YX4Ec3SFL
	kYAWOiCYX5xYwx8TJxMnk+/SWborL/JtoUt/nJZCkxLk6FYCLV39uM+GtvBLQYvq4XXCQ1
	ENr2HN29jqyzFlgixC1rYPs45eiUdjo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-CNINN3UyO5-NjI1uFvLJcg-1; Thu, 16 Nov 2023 12:14:44 -0500
X-MC-Unique: CNINN3UyO5-NjI1uFvLJcg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37EF380C344;
	Thu, 16 Nov 2023 17:14:44 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D80C40C6EB9;
	Thu, 16 Nov 2023 17:14:44 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3AGHEhr6161035
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Nov 2023 12:14:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3AGHEhTi161034;
	Thu, 16 Nov 2023 12:14:43 -0500
Date: Thu, 16 Nov 2023 12:14:43 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] multipath-tools: set usr_prefix to /usr in default
 configuration
Message-ID: <ZVZOA6alWweIdnLC@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231113140826.15399-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231113140826.15399-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 13, 2023 at 03:08:26PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> In the default configuration (both prefix and usr_prefix unset),
> we'd install man pages and headers under /share/man and /include,
> respectively, which is very unusual. Have usr_prefix default to
> /usr in (the default) case where prefix is empty, and set it equal
> to /prefix otherwise.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> 
> This is submitted as an alternative approach to Ben Marzinski's
> late patch set "Makefile cleanups."
> 
> ---
>  Makefile.inc | 2 +-
>  README.md    | 3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index a20e2ce..6b45430 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -36,7 +36,7 @@ prefix		:=
>  # Prefix for binaries
>  exec_prefix	:= $(prefix)
>  # Prefix for non-essential libraries (libdmmp)
> -usr_prefix	:= $(prefix)
> +usr_prefix	:= $(if $(prefix),$(prefix),/usr)
>  # Prefix for configfuration files (multipath.conf)
>  etc_prefix	:= $(prefix)
>  # Where to install systemd-related files. systemd is usually installed under /usr
> diff --git a/README.md b/README.md
> index db03a33..d4f35f5 100644
> --- a/README.md
> +++ b/README.md
> @@ -131,8 +131,7 @@ The following variables can be passed to the `make` command line:
>     "Usr-merged" distributions[^systemd] may want to set this to `/usr`. The
>     default is empty (`""`).
>   * `usr_prefix`: where to install those parts of the code that aren't necessary
> -   for booting. Non-usr-merged distributions[^systemd] may want to set this to
> -   `/usr`. The default is `$(prefix)`.
> +   for booting. The default is `/usr` if `$(prefix)` is empty, and `$(prefix)` otherwise.
>   * `systemd_prefix`: Prefix for systemd-related files[^systemd]. The default is `/usr`.
>   * `etc_prefix`: The prefix for configuration files. "usr-merged"
>     distributions with immutable `/usr`[^systemd] may want to set this to
> -- 
> 2.42.1

