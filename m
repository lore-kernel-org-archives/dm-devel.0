Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E53EE0212
	for <dm-devel@archiver.kernel.org>; Wed, 13 Sep 2023 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694646614;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jSijbYBHchMfLDOu3H9ydR2kKc8+7R/G/qZy6mDhZ7A=;
	b=ILQqeq2ySrOfNWGl+qjf1V2ehhL/qOC8EQgreI6UQFaNFWvDpxusn73UmMSRhLZ/QJp+8q
	ZtlTPnCqOOIbTUqkZdoxVabBhqcLgwk2u1Ru3pONNig8z2XRSZzVlOm7y3CCHkz1HzMnuy
	bNNxsC6/1yF3h3tceTb0aYWb6hYZEpw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-oRXQEsXYMNSNX6e-ShIg6A-1; Wed, 13 Sep 2023 19:10:11 -0400
X-MC-Unique: oRXQEsXYMNSNX6e-ShIg6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3026281DA1C;
	Wed, 13 Sep 2023 23:10:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0A04340C200A;
	Wed, 13 Sep 2023 23:10:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9055C19465B7;
	Wed, 13 Sep 2023 23:10:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F289119465B1
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Sep 2023 23:09:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D044F2156722; Wed, 13 Sep 2023 23:09:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B4DF22156721;
 Wed, 13 Sep 2023 23:09:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38DN9c9Y004696;
 Wed, 13 Sep 2023 18:09:38 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38DN9bHh004695;
 Wed, 13 Sep 2023 18:09:37 -0500
Date: Wed, 13 Sep 2023 18:09:37 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230913230937.GG7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-37-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-37-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v2 36/37] multipath-tools: allow prefixes
 with and w/o trailing slash
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

On Mon, Sep 11, 2023 at 06:38:45PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Add some logic to Makefile.inc that leads to the same result
> for "prefix=" and "prefix=/", or "prefix=/usr" and "prefix=/usr/".
> The logic does not work for multiple trailing slashes. It applies
> to all XYZ_prefix variables in Makefile.inc.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  Makefile.inc | 35 ++++++++++++++++++++++-------------
>  1 file changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index 79e521e..6e384e6 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -43,22 +43,31 @@ etc_prefix	:= $(prefix)
>  # Note: some systemd installations use separate "prefix" and "rootprefix".
>  # In this case, override only unitdir to use systemd's "rootprefix" instead of $(systemd_prefix)
>  systemd_prefix  := /usr
> -unitdir		:= $(systemd_prefix)/lib/systemd/system
> -tmpfilesdir	:= $(systemd_prefix)/lib/tmpfiles.d
> -modulesloaddir	:= $(systemd_prefix)/lib/modules-load.d
> -libudevdir	:= $(systemd_prefix)/lib/udev
> +
> +# Make sure all prefix variables end in "/"
> +append-slash = $(1)$(if $(filter %/,$(1)),,/)
> +override prefix          := $(call append-slash,$(prefix))
> +override exec_prefix     := $(call append-slash,$(exec_prefix))
> +override usr_prefix      := $(call append-slash,$(usr_prefix))
> +override etc_prefix      := $(call append-slash,$(etc_prefix))
> +override systemd_prefix  := $(call append-slash,$(systemd_prefix))
> +
> +unitdir		:= $(systemd_prefix)lib/systemd/system
> +tmpfilesdir	:= $(systemd_prefix)lib/tmpfiles.d
> +modulesloaddir	:= $(systemd_prefix)lib/modules-load.d
> +libudevdir	:= $(systemd_prefix)lib/udev
>  udevrulesdir	:= $(libudevdir)/rules.d
> -bindir		:= $(exec_prefix)/sbin
> -mandir		:= $(usr_prefix)/share/man
> +bindir		:= $(exec_prefix)sbin
> +mandir		:= $(usr_prefix)share/man
>  LIB		:= $(if $(shell test -d /lib64 && echo 1),lib64,lib)
> -syslibdir	:= $(prefix)/$(LIB)
> -usrlibdir	:= $(usr_prefix)/$(LIB)
> -includedir	:= $(usr_prefix)/include
> +syslibdir	:= $(prefix)$(LIB)
> +usrlibdir	:= $(usr_prefix)$(LIB)
> +includedir	:= $(usr_prefix)include
>  pkgconfdir	:= $(usrlibdir)/pkgconfig
> -plugindir       := $(prefix)/$(LIB)/multipath
> -configdir       := $(etc_prefix)/etc/multipath/conf.d
> -configfile      := $(etc_prefix)/etc/multipath.conf
> -statedir        := $(etc_prefix)/etc/multipath
> +plugindir       := $(prefix)$(LIB)/multipath
> +configdir       := $(etc_prefix)etc/multipath/conf.d
> +configfile      := $(etc_prefix)etc/multipath.conf
> +statedir        := $(etc_prefix)etc/multipath
>  runtimedir      := $(if $(shell test -L /var/run -o ! -d /var/run && echo 1),/run,/var/run)
>  devmapper_incdir := $(or $(shell $(PKG_CONFIG) --variable=includedir devmapper),/usr/include)
>  libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr/include)
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

