Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94966EE0210
	for <dm-devel@archiver.kernel.org>; Wed, 13 Sep 2023 22:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694644370;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oD/ZYSO5uy7Fmlt/KyBD7Fr4ur8M6fEw68WJsLARylU=;
	b=QGxDQ+ssHR5IHET3999DQhEqg/xKKsU2yZ1MaMfVVDoHVBg1+LCzaraEzRXBpv9X3weW9N
	MEN0H0qollD5Wq6iNtSJglTYDPftGzHGq9FUXl1f81VA7PG2PTguIjY2ek5Of0XdXjXVeJ
	LfbnkiTurJIa4XaMHbVrLcjeVRVb6U4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-6aVOHl7XP2ycMK0C687ICA-1; Wed, 13 Sep 2023 18:32:46 -0400
X-MC-Unique: 6aVOHl7XP2ycMK0C687ICA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2670A857A9D;
	Wed, 13 Sep 2023 22:32:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1021940C6EA8;
	Wed, 13 Sep 2023 22:32:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C9AFA19465B5;
	Wed, 13 Sep 2023 22:32:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9643319465B5
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Sep 2023 22:32:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 81F84404A251; Wed, 13 Sep 2023 22:32:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BB12404A250;
 Wed, 13 Sep 2023 22:32:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38DMWKKF004492;
 Wed, 13 Sep 2023 17:32:20 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38DMWJ8G004491;
 Wed, 13 Sep 2023 17:32:19 -0500
Date: Wed, 13 Sep 2023 17:32:19 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230913223219.GA7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-31-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-31-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v2 30/37] multipath-tools: add compile time
 configuration for "/etc/multipath"
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:39PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Instead of hard-conding "/etc/multipath" as the path for the state
> files "bindings", "prkeys", and "wwids", make this path configurable
> via the "statedir" compile-time option. The default is currently still
> /etc, it might change to /var/lib or similar in the future.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  Makefile.inc            | 4 +++-
>  libmultipath/defaults.h | 6 +++---
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index 39972d9..96206b2 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -58,6 +58,7 @@ pkgconfdir	:= $(usrlibdir)/pkgconfig
>  plugindir       := $(prefix)/$(LIB)/multipath
>  configdir       := $(etc_prefix)/etc/multipath/conf.d
>  configfile      := $(etc_prefix)/etc/multipath.conf
> +statedir        := $(etc_prefix)/etc/multipath
>  runtimedir      := $(if $(shell test -L /var/run -o ! -d /var/run && echo 1),/run,/var/run)
>  devmapper_incdir := $(or $(shell $(PKG_CONFIG) --variable=includedir devmapper),/usr/include)
>  libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr/include)
> @@ -88,7 +89,8 @@ WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implici
>  CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) \
>  		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(plugindir)\" \
>  		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(configdir)\" \
> -		   -DDEFAULT_CONFIGFILE=\"$(configfile)\" -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
> +		   -DDEFAULT_CONFIGFILE=\"$(configfile)\" -DSTATE_DIR=\"$(statedir)\" \
> +		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
>  CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe
>  BIN_CFLAGS	:= -fPIE -DPIE
>  LIB_CFLAGS	:= -fPIC
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index bc2d638..d01f971 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -66,9 +66,9 @@
>  #define MAX_DEV_LOSS_TMO	UINT_MAX
>  #define DEFAULT_PIDFILE		RUNTIME_DIR "/multipathd.pid"
>  #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
> -#define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
> -#define DEFAULT_WWIDS_FILE	"/etc/multipath/wwids"
> -#define DEFAULT_PRKEYS_FILE    "/etc/multipath/prkeys"
> +#define DEFAULT_BINDINGS_FILE	STATE_DIR "/bindings"
> +#define DEFAULT_WWIDS_FILE	STATE_DIR "/wwids"
> +#define DEFAULT_PRKEYS_FILE	STATE_DIR "/prkeys"
>  #define MULTIPATH_SHM_BASE	RUNTIME_DIR "/multipath/"
>  
>  
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

