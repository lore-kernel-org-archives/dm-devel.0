Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3014EE0213
	for <dm-devel@archiver.kernel.org>; Wed, 13 Sep 2023 22:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694645926;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tsNOetonXMFBpowuVfMBSJqDghPTt1rasESoEpOy91g=;
	b=SGnFTBt0DbVPQm84205yCOFnOHRj76oOoyipn5l6+seTwtfbRQhBjMAtAYVl6jJpNCdcMw
	gXUX2G3vdLp/4Hln1NH91eHN5Z7w2J6uWoP8mxoJ8CnZC6V2fcIHzHtHfzaPM43Azszyl9
	t2CKrwy6pIdqj9EO5rQcUjw5W4vVvOQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-ifumwj_XPYG3LWavxF3raw-1; Wed, 13 Sep 2023 18:58:43 -0400
X-MC-Unique: ifumwj_XPYG3LWavxF3raw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE823185A790;
	Wed, 13 Sep 2023 22:58:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 61D67403CFA0;
	Wed, 13 Sep 2023 22:58:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2F95819465B5;
	Wed, 13 Sep 2023 22:58:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0773819465B1
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Sep 2023 22:58:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DA2BE64671; Wed, 13 Sep 2023 22:58:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B61287B62;
 Wed, 13 Sep 2023 22:58:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38DMwHeR004538;
 Wed, 13 Sep 2023 17:58:17 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38DMwGvc004537;
 Wed, 13 Sep 2023 17:58:16 -0500
Date: Wed, 13 Sep 2023 17:58:16 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230913225816.GD7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-34-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-34-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 33/37] multipath-tools: README.md: improve
 documentation for compile-time options
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:42PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  README.md | 38 ++++++++++++++++++++++++++------------
>  1 file changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/README.md b/README.md
> index a7f994a..679e55b 100644
> --- a/README.md
> +++ b/README.md
> @@ -89,9 +89,17 @@ The following variables can be passed to the `make` command line:
>   * `plugindir="/some/path"`: directory where libmultipath plugins (path
>     checkers, prioritizers, and foreign multipath support) will be looked up.
>     This used to be the run-time option `multipath_dir` in earlier versions.
> - * `configdir="/some/path"` : directory to search for configuration files.
> +   The default is `$(prefix)/$(LIB)/multipath`, where `$(LIB)` is `lib64` on
> +   systems that have `/lib64`, and `lib` otherwise.
> + * `configfile="/some/path`": The path to the main configuration file.
> +    The defalt is `$(etc_prefix)/etc/multipath.conf`.
> + * `configdir="/some/path"` : directory to search for additional configuration files.
>      This used to be the run-time option `config_dir` in earlier versions.
> -	The default is `/etc/multipath/conf.d`.
> +	The default is `$(etc_prefix)/etc/multipath/conf.d`.
> + * `statedir="/some/path"`: The path of the directory where multipath-tools
> +    stores run-time settings that need persist between reboots, such as known
> +	WWIDs, user-friendly names, and persistent reservation keys.
> +	The default is `$(etc_prefix)/etc/multipath`.
>   * `READLINE=libedit` or `READLINE=libreadline`: enable command line history
>      and TAB completion in the interactive mode *(which is entered with `multipathd -k` or `multipathc`)*.
>      The respective development package will be required for building.
> @@ -119,21 +127,27 @@ The following variables can be passed to the `make` command line:
>  ### Installation Paths
>  
>   * `prefix`: The directory prefix for (almost) all files to be installed.
> -   Distributions may want to set this to `/usr`.
> -   **Note**: for multipath-tools, unlike many other packages, `prefix`
> -   defaults to the empty string, which resolves to the root directory (`/`).
> +   "Usr-merged" distributions[^systemd] may want to set this to `/usr`. The
> +   default is empty (`""`).
>   * `usr_prefix`: where to install those parts of the code that aren't necessary
> -   for booting. You may want to set this to `/usr` if `prefix` is empty.
> - * `systemd_prefix`: Prefix for systemd-related files. It defaults to `/usr`.
> -   Some systemd installations use separate `prefix` and `rootprefix`. On such
> -   a distribution, set `prefix`, and override `unitdir` to use systemd's
> -   `rootprefix`.
> +   for booting. Non-usr-merged distributions[^systemd] may want to set this to
> +   `/usr`. The default is `$(prefix)`.
> + * `systemd_prefix`: Prefix for systemd-related files[^systemd]. The default is `/usr`.
> + * `etc_prefix`: The prefix for configuration files. "Usr-merged"
> +   distributions with immutable `/usr`[^systemd] may want to set this to
> +   `/etc`. The default is `$(prefix)`.
>   * `LIB`: the subdirectory under `prefix` where shared libraries will be
>     installed. By default, the makefile uses `/lib64` if this directory is
>     found on the build system, and `/lib` otherwise.
>     
> -See also `configdir` and `plugindir` above. See `Makefile.inc` for more
> -fine-grained control.
> +The options `configdir`, `plugindir`, `configfile`, and `statedir` above can
> +be used for setting indvidual paths where the `prefix` variables don't provide
> +sufficient control. See `Makefile.inc` for even more fine-grained control.
> +
> +[^systemd]: Some systemd installations use separate `prefix` and `rootprefix`. 
> +	On such a distribution, set `prefix`, and override `unitdir` to use systemd's
> +   `rootprefix`. Recent systemd releases generally require everything to be
> +	installed under `/usr` (so-called "usr-merged" distribution). On "usr-
>  
>  ### Compiler Options
>  
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

