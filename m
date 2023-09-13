Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D459EE020F
	for <dm-devel@archiver.kernel.org>; Wed, 13 Sep 2023 22:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694644332;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Dk7KL2CV5efTRqYqZTXVuE8OHXa86rY3skqMQxmIvk8=;
	b=bY0naA1L22Tl841Gzw/5nlFhWumrdDuUb9OhSE7AjtfRbETSeKOpG39kwLZw/sHihk79Bz
	B3rWpZehcPyz79VtnndsMhNn4JeXbMmuZuRWXwl9ca8nJvGVhEtz0mSX6inXFBIZeTEzEY
	bRzEVxO9ksvYXb6qUgyBzeM2X1wneP0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-ij8uj-q-Pzm8uoMgl6kVfQ-1; Wed, 13 Sep 2023 18:32:08 -0400
X-MC-Unique: ij8uj-q-Pzm8uoMgl6kVfQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BD1A800045;
	Wed, 13 Sep 2023 22:32:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D2A302156721;
	Wed, 13 Sep 2023 22:32:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8FFE019465B5;
	Wed, 13 Sep 2023 22:31:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 49F7A19465B1
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Sep 2023 22:30:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ECC8010F1BE9; Wed, 13 Sep 2023 22:30:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D525410F1BE7;
 Wed, 13 Sep 2023 22:30:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38DMU4Fa004485;
 Wed, 13 Sep 2023 17:30:04 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38DMU43K004484;
 Wed, 13 Sep 2023 17:30:04 -0500
Date: Wed, 13 Sep 2023 17:30:03 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230913223003.GZ7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-30-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-30-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2 29/37] multipath-tools Makefile: sanitize
 paths for configuration files
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:38PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Make the path to multipath.conf configurable, and use the same prefix
> by default for multipath.conf and multipath/conf.d. For "usr-merged"
> distributions with immutable /usr, we'll want to have the configuration
> under a different prefix. This can be achieved by using e.g.
> 
>     make prefix=/usr etc_prefix=""
> 
> Note that with prefix=/usr, before this patch the code would use
> /usr/etc/multipath/conf.d, but /etc/multipath.conf. If this (rather
> inconsistent) behavior is desired, use the following command line:
> 
>     make prefix=/usr configfile=/etc/multipath.conf

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  Makefile.inc            | 9 ++++++---
>  libmultipath/defaults.h | 1 -
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index 502cd0f..39972d9 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -37,6 +37,8 @@ prefix		:=
>  exec_prefix	:= $(prefix)
>  # Prefix for non-essential libraries (libdmmp)
>  usr_prefix	:= $(prefix)
> +# Prefix for configfuration files (multipath.conf)
> +etc_prefix	:= $(prefix)
>  # Where to install systemd-related files. systemd is usually installed under /usr
>  # Note: some systemd installations use separate "prefix" and "rootprefix".
>  # In this case, override only unitdir to use systemd's "rootprefix" instead of $(systemd_prefix)
> @@ -54,7 +56,8 @@ usrlibdir	:= $(usr_prefix)/$(LIB)
>  includedir	:= $(usr_prefix)/include
>  pkgconfdir	:= $(usrlibdir)/pkgconfig
>  plugindir       := $(prefix)/$(LIB)/multipath
> -configdir       := $(prefix)/etc/multipath/conf.d
> +configdir       := $(etc_prefix)/etc/multipath/conf.d
> +configfile      := $(etc_prefix)/etc/multipath.conf
>  runtimedir      := $(if $(shell test -L /var/run -o ! -d /var/run && echo 1),/run,/var/run)
>  devmapper_incdir := $(or $(shell $(PKG_CONFIG) --variable=includedir devmapper),/usr/include)
>  libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr/include)
> @@ -84,8 +87,8 @@ WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implici
>  		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS) $(W_URCU_TYPE_LIMITS)
>  CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) \
>  		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(plugindir)\" \
> -		   -DRUNTIME_DIR=\"$(runtimedir)\" \
> -		   -DCONFIG_DIR=\"$(configdir)\" -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
> +		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(configdir)\" \
> +		   -DDEFAULT_CONFIGFILE=\"$(configfile)\" -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
>  CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe
>  BIN_CFLAGS	:= -fPIE -DPIE
>  LIB_CFLAGS	:= -fPIC
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index b3f11d4..bc2d638 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -66,7 +66,6 @@
>  #define MAX_DEV_LOSS_TMO	UINT_MAX
>  #define DEFAULT_PIDFILE		RUNTIME_DIR "/multipathd.pid"
>  #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
> -#define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
>  #define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
>  #define DEFAULT_WWIDS_FILE	"/etc/multipath/wwids"
>  #define DEFAULT_PRKEYS_FILE    "/etc/multipath/prkeys"
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

