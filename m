Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670C836AEA
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 19:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K4wOQXct"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698434843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/T5TCgES1CQ+TQMzy6IqM1DNO8wVBHHUaK3x6YkLwO4=;
	b=K4wOQXctrIAF3okF7JuOky16a1ucn77e/0C3ix8ZpfgeblymWVviUArOLpZbl90mdd8Lfb
	Stk/+2v6STHN5x3cMMoF7x75DK1JSOPQmY40KJKMZHkKQmzne1xRQlZmwB34Xsiec40ZsV
	FxGh00Q2j63DwAdFffjSumJx+fV74YA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-F3K8S4q0OWOETP5M1UhqzQ-1; Fri,
 27 Oct 2023 15:27:20 -0400
X-MC-Unique: F3K8S4q0OWOETP5M1UhqzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CA582810D63;
	Fri, 27 Oct 2023 19:27:19 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 954341C060AE;
	Fri, 27 Oct 2023 19:27:19 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39RJRJpv049738
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Oct 2023 15:27:19 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39RJRJqK049737;
	Fri, 27 Oct 2023 15:27:19 -0400
Date: Fri, 27 Oct 2023 15:27:19 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v2 11/14] Makefile.inc, README.md: fix docs for prefix in
 split-usr case
Message-ID: <ZTwPF2zsBVeUT6wV@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231026174153.1133-1-mwilck@suse.com>
 <20231026174153.1133-12-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231026174153.1133-12-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2023 at 07:41:50PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> systemd with "split-usr=true" uses rootprefixdir as prefix for
> units and for udev libraries and rules ("udevlibexecdir" in
> systemd). Fix the documentation for this case. Also, slightly
> improve the paragraph about SCSI module loading.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  Makefile.inc |  6 ++++--
>  README.md    | 25 ++++++++++++++++++-------
>  2 files changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index 8655cba..a20e2ce 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -40,8 +40,10 @@ usr_prefix	:= $(prefix)
>  # Prefix for configfuration files (multipath.conf)
>  etc_prefix	:= $(prefix)
>  # Where to install systemd-related files. systemd is usually installed under /usr
> -# Note: some systemd installations use separate "prefix" and "rootprefix".
> -# In this case, override only unitdir to use systemd's "rootprefix" instead of $(systemd_prefix)
> +# Note: systemd installations with "split-usr=true" use separate "prefixdir" and
> +# "rootprefixdir". Our systemd_prefix corresponds to "prefixdir".
> +# In this case, override only unitdir and libudevdir below to use
> +# systemd's "rootprefixdir" instead of $(systemd_prefix)
>  systemd_prefix  := /usr
>  
>  # Make sure all prefix variables end in "/"
> diff --git a/README.md b/README.md
> index 524c9fb..25ce963 100644
> --- a/README.md
> +++ b/README.md
> @@ -111,6 +111,13 @@ The following variables can be passed to the `make` command line:
>     polling API. For use with pre-5.0 kernels that don't support dmevent polling
>     (but even if you don't use this option, multipath-tools will work with
>     these kernels).
> + * `SYSTEMD`: The version number of systemd (e.g. "244") to compile the code for.
> +   The default is autodetected, assuming that the systemd version in the build
> +   environment is the same as on the target system. Override the value to
> +   build for a different systemd version, or set it to `""` to build for a
> +   system without systemd.
> +   **Caution:** multipathd without systemd has been largely untested by the
> +   upstream maintainers since at least 2020.
>   * `SCSI_DH_MODULES_PRELOAD="(list)"`: specify a space-separated list of SCSI
>     device handler kernel modules to load early during boot. Some
>     multipath-tools functionality depends on these modules being loaded
> @@ -122,7 +129,9 @@ The following variables can be passed to the `make` command line:
>     It's especially useful if `scsi_mod` is builtin but `scsi_dh_alua` and
>     other device handler modules are built as modules. If `scsi_mod` itself is compiled
>     as a module, it might make more sense to use a module softdep for the same
> -   purpose.
> +   purpose by creating a `modprobe.d` file like this:
> +       
> +        softdep scsi_mod post: scsi_dh_alua scsi_dh_rdac
>  
>  ### Installation Paths
>  
> @@ -133,9 +142,9 @@ The following variables can be passed to the `make` command line:
>     for booting. Non-usr-merged distributions[^systemd] may want to set this to
>     `/usr`. The default is `$(prefix)`.
>   * `systemd_prefix`: Prefix for systemd-related files[^systemd]. The default is `/usr`.
> - * `etc_prefix`: The prefix for configuration files. "Usr-merged"
> + * `etc_prefix`: The prefix for configuration files. "usr-merged"
>     distributions with immutable `/usr`[^systemd] may want to set this to
> -   `/etc`. The default is `$(prefix)`.
> +   `""`. The default is `$(prefix)`.
>   * `LIB`: the subdirectory under `prefix` where shared libraries will be
>     installed. By default, the makefile uses `/lib64` if this directory is
>     found on the build system, and `/lib` otherwise.
> @@ -144,10 +153,12 @@ The options `configdir`, `plugindir`, `configfile`, and `statedir` above can
>  be used for setting individual paths where the `prefix` variables don't provide
>  sufficient control. See `Makefile.inc` for even more fine-grained control.
>  
> -[^systemd]: Some systemd installations use separate `prefix` and `rootprefix`. 
> -	On such a distribution, set `prefix`, and override `unitdir` to use systemd's
> -   `rootprefix`. Recent systemd releases generally require everything to be
> -	installed under `/usr` (so-called "usr-merged" distribution). On "usr-
> +[^systemd]: systemd installations up to v254 which have been built with
> +    `split-usr=true` may use separate `prefixdir` and `rootprefixdir`
> +    directories, where `prefixdir` is a subdirectory of `rootprefixdir`.
> +	multipath-tools' `systemd_prefix` corresponds to systemd's `prefixdir`.
> +	On such distributions, override `unitdir` and `libudevdir` to use systemd's
> +   `rootprefix`: `make libudevdir=/lib/udev unitdir=/lib/systemd/system`
>  
>  ### Compiler Options
>  
> -- 
> 2.42.0

