Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E477C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 15:57:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A104B610A8
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 15:57:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A104B610A8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1621526274;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7M9UC/4Uk4A9JPecABXFnQIOcdV2J1b6oMvOEHyDODQ=;
	b=YN0ka1vydu9Sbk7Q/B6JKrcR3DXtPrr4bSVHfUil0cUCuHzwkD8fKuDEuYF4Ig4VwFb7z0
	U0ki70i1+fLy8AUFfJGSt0VV4S9y7KjUHnwSrozE0u13TAW/mnKEt8SuTtrfA3GAuHol8g
	k1cDc0GWgK+7OC9U1xBKc6zGfY+X6DI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-t7GYCVU_OTq_0utynPrZXQ-1; Thu, 20 May 2021 11:57:52 -0400
X-MC-Unique: t7GYCVU_OTq_0utynPrZXQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 578F86D4FB;
	Thu, 20 May 2021 15:57:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E37F60C04;
	Thu, 20 May 2021 15:57:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B619655353;
	Thu, 20 May 2021 15:57:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14KFvi3g022844 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 11:57:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D6EE519C71; Thu, 20 May 2021 15:57:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4961319C59;
	Thu, 20 May 2021 15:57:41 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14KFvdMg029734; 
	Thu, 20 May 2021 10:57:39 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14KFvddu029733;
	Thu, 20 May 2021 10:57:39 -0500
Date: Thu, 20 May 2021 10:57:39 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210520155738.GS25887@octiron.msp.redhat.com>
References: <20210517212727.25229-1-mwilck@suse.com>
	<20210517212727.25229-4-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210517212727.25229-4-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [dm-devel] [PATCH v2 4/4] libdmmp: use KBUILD_BUILD_TIMESTAMP
 when building man pages
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 17, 2021 at 11:27:27PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Use the latest commit timestamp of the "libdmmp.h" file as
> the timestamp for the man pages. This should avoid spurious rebuilds
> of the documentation.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libdmmp/Makefile                                 | 2 ++
>  libdmmp/docs/man/dmmp_context_free.3             | 2 +-
>  libdmmp/docs/man/dmmp_context_log_func_set.3     | 2 +-
>  libdmmp/docs/man/dmmp_context_log_priority_get.3 | 2 +-
>  libdmmp/docs/man/dmmp_context_log_priority_set.3 | 2 +-
>  libdmmp/docs/man/dmmp_context_new.3              | 2 +-
>  libdmmp/docs/man/dmmp_context_timeout_get.3      | 2 +-
>  libdmmp/docs/man/dmmp_context_timeout_set.3      | 2 +-
>  libdmmp/docs/man/dmmp_context_userdata_get.3     | 2 +-
>  libdmmp/docs/man/dmmp_context_userdata_set.3     | 2 +-
>  libdmmp/docs/man/dmmp_flush_mpath.3              | 2 +-
>  libdmmp/docs/man/dmmp_last_error_msg.3           | 2 +-
>  libdmmp/docs/man/dmmp_log_priority_str.3         | 2 +-
>  libdmmp/docs/man/dmmp_mpath_array_free.3         | 2 +-
>  libdmmp/docs/man/dmmp_mpath_array_get.3          | 2 +-
>  libdmmp/docs/man/dmmp_mpath_kdev_name_get.3      | 2 +-
>  libdmmp/docs/man/dmmp_mpath_name_get.3           | 2 +-
>  libdmmp/docs/man/dmmp_mpath_wwid_get.3           | 2 +-
>  libdmmp/docs/man/dmmp_path_array_get.3           | 2 +-
>  libdmmp/docs/man/dmmp_path_blk_name_get.3        | 2 +-
>  libdmmp/docs/man/dmmp_path_group_array_get.3     | 2 +-
>  libdmmp/docs/man/dmmp_path_group_id_get.3        | 2 +-
>  libdmmp/docs/man/dmmp_path_group_priority_get.3  | 2 +-
>  libdmmp/docs/man/dmmp_path_group_selector_get.3  | 2 +-
>  libdmmp/docs/man/dmmp_path_group_status_get.3    | 2 +-
>  libdmmp/docs/man/dmmp_path_group_status_str.3    | 2 +-
>  libdmmp/docs/man/dmmp_path_status_get.3          | 2 +-
>  libdmmp/docs/man/dmmp_path_status_str.3          | 2 +-
>  libdmmp/docs/man/dmmp_reconfig.3                 | 2 +-
>  libdmmp/docs/man/dmmp_strerror.3                 | 2 +-
>  30 files changed, 31 insertions(+), 29 deletions(-)
> 
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index 764a0bc..79b92fb 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -76,6 +76,8 @@ docs/man/%.3.gz:	docs/man/%.3
>  docs/man/dmmp_strerror.3:	$(HEADERS)
>  	TEMPFILE=$(shell mktemp); \
>  	cat $^ | perl docs/doc-preclean.pl >$$TEMPFILE; \
> +	LC_ALL=C \
> +	KBUILD_BUILD_TIMESTAMP=`git log -n1 --pretty=%cd --date=iso -- $^` \
>  	perl docs/kernel-doc -man $$TEMPFILE | \
>  	    perl docs/split-man.pl docs/man; \
>  	rm -f $$TEMPFILE
> diff --git a/libdmmp/docs/man/dmmp_context_free.3 b/libdmmp/docs/man/dmmp_context_free.3
> index 0d26f42..7c109e1 100644
> --- a/libdmmp/docs/man/dmmp_context_free.3
> +++ b/libdmmp/docs/man/dmmp_context_free.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_free" 3 "dmmp_context_free" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_free" 3 "dmmp_context_free" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_free \- Release the memory of struct dmmp_context.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_log_func_set.3 b/libdmmp/docs/man/dmmp_context_log_func_set.3
> index 986793d..be311ec 100644
> --- a/libdmmp/docs/man/dmmp_context_log_func_set.3
> +++ b/libdmmp/docs/man/dmmp_context_log_func_set.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_log_func_set" 3 "dmmp_context_log_func_set" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_log_func_set" 3 "dmmp_context_log_func_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_log_func_set \- Set log handler function.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_log_priority_get.3 b/libdmmp/docs/man/dmmp_context_log_priority_get.3
> index 9a273a2..be38301 100644
> --- a/libdmmp/docs/man/dmmp_context_log_priority_get.3
> +++ b/libdmmp/docs/man/dmmp_context_log_priority_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_log_priority_get" 3 "dmmp_context_log_priority_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_log_priority_get" 3 "dmmp_context_log_priority_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_log_priority_get \- Get log priority.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_log_priority_set.3 b/libdmmp/docs/man/dmmp_context_log_priority_set.3
> index 469c5a4..79e4d2e 100644
> --- a/libdmmp/docs/man/dmmp_context_log_priority_set.3
> +++ b/libdmmp/docs/man/dmmp_context_log_priority_set.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_log_priority_set" 3 "dmmp_context_log_priority_set" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_log_priority_set" 3 "dmmp_context_log_priority_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_log_priority_set \- Set log priority.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_new.3 b/libdmmp/docs/man/dmmp_context_new.3
> index 0eaeb00..12505f9 100644
> --- a/libdmmp/docs/man/dmmp_context_new.3
> +++ b/libdmmp/docs/man/dmmp_context_new.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_new" 3 "dmmp_context_new" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_new" 3 "dmmp_context_new" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_new \- Create struct dmmp_context.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_timeout_get.3 b/libdmmp/docs/man/dmmp_context_timeout_get.3
> index 1df2793..2ed825d 100644
> --- a/libdmmp/docs/man/dmmp_context_timeout_get.3
> +++ b/libdmmp/docs/man/dmmp_context_timeout_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_timeout_get" 3 "dmmp_context_timeout_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_timeout_get" 3 "dmmp_context_timeout_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_timeout_get \- Get IPC timeout.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_timeout_set.3 b/libdmmp/docs/man/dmmp_context_timeout_set.3
> index f3d7709..16bc9d9 100644
> --- a/libdmmp/docs/man/dmmp_context_timeout_set.3
> +++ b/libdmmp/docs/man/dmmp_context_timeout_set.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_timeout_set" 3 "dmmp_context_timeout_set" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_timeout_set" 3 "dmmp_context_timeout_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_timeout_set \- Set IPC timeout.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_userdata_get.3 b/libdmmp/docs/man/dmmp_context_userdata_get.3
> index fb713d5..eff446c 100644
> --- a/libdmmp/docs/man/dmmp_context_userdata_get.3
> +++ b/libdmmp/docs/man/dmmp_context_userdata_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_userdata_get" 3 "dmmp_context_userdata_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_userdata_get" 3 "dmmp_context_userdata_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_userdata_get \- Get user data pointer.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_userdata_set.3 b/libdmmp/docs/man/dmmp_context_userdata_set.3
> index c5bf63f..d7be869 100644
> --- a/libdmmp/docs/man/dmmp_context_userdata_set.3
> +++ b/libdmmp/docs/man/dmmp_context_userdata_set.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_userdata_set" 3 "dmmp_context_userdata_set" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_userdata_set" 3 "dmmp_context_userdata_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_userdata_set \- Set user data pointer.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_flush_mpath.3 b/libdmmp/docs/man/dmmp_flush_mpath.3
> index cdfd526..359607e 100644
> --- a/libdmmp/docs/man/dmmp_flush_mpath.3
> +++ b/libdmmp/docs/man/dmmp_flush_mpath.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_flush_mpath" 3 "dmmp_flush_mpath" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_flush_mpath" 3 "dmmp_flush_mpath" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_flush_mpath \- Flush specified multipath device map if unused.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_last_error_msg.3 b/libdmmp/docs/man/dmmp_last_error_msg.3
> index 20acbc6..378c55a 100644
> --- a/libdmmp/docs/man/dmmp_last_error_msg.3
> +++ b/libdmmp/docs/man/dmmp_last_error_msg.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_last_error_msg" 3 "dmmp_last_error_msg" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_last_error_msg" 3 "dmmp_last_error_msg" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_last_error_msg \- Retrieves the last error message.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_log_priority_str.3 b/libdmmp/docs/man/dmmp_log_priority_str.3
> index 3b5f828..b276160 100644
> --- a/libdmmp/docs/man/dmmp_log_priority_str.3
> +++ b/libdmmp/docs/man/dmmp_log_priority_str.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_log_priority_str" 3 "dmmp_log_priority_str" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_log_priority_str" 3 "dmmp_log_priority_str" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_log_priority_str \- Convert log priority to string.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_mpath_array_free.3 b/libdmmp/docs/man/dmmp_mpath_array_free.3
> index 8c294e0..0514a66 100644
> --- a/libdmmp/docs/man/dmmp_mpath_array_free.3
> +++ b/libdmmp/docs/man/dmmp_mpath_array_free.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_mpath_array_free" 3 "dmmp_mpath_array_free" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_mpath_array_free" 3 "dmmp_mpath_array_free" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_mpath_array_free \- Free 'struct dmmp_mpath' pointer array.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_mpath_array_get.3 b/libdmmp/docs/man/dmmp_mpath_array_get.3
> index e211db4..8b0e5b5 100644
> --- a/libdmmp/docs/man/dmmp_mpath_array_get.3
> +++ b/libdmmp/docs/man/dmmp_mpath_array_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_mpath_array_get" 3 "dmmp_mpath_array_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_mpath_array_get" 3 "dmmp_mpath_array_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_mpath_array_get \- Query all existing multipath devices.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3 b/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
> index e802fe6..ddead55 100644
> --- a/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
> +++ b/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_mpath_kdev_name_get" 3 "dmmp_mpath_kdev_name_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_mpath_kdev_name_get" 3 "dmmp_mpath_kdev_name_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_mpath_kdev_name_get \- Retrieve kernel DEVNAME of certain mpath.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_mpath_name_get.3 b/libdmmp/docs/man/dmmp_mpath_name_get.3
> index d70579e..2b0027e 100644
> --- a/libdmmp/docs/man/dmmp_mpath_name_get.3
> +++ b/libdmmp/docs/man/dmmp_mpath_name_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_mpath_name_get" 3 "dmmp_mpath_name_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_mpath_name_get" 3 "dmmp_mpath_name_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_mpath_name_get \- Retrieve name(alias) of certain mpath.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_mpath_wwid_get.3 b/libdmmp/docs/man/dmmp_mpath_wwid_get.3
> index 3d060e9..b8e9e7d 100644
> --- a/libdmmp/docs/man/dmmp_mpath_wwid_get.3
> +++ b/libdmmp/docs/man/dmmp_mpath_wwid_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_mpath_wwid_get" 3 "dmmp_mpath_wwid_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_mpath_wwid_get" 3 "dmmp_mpath_wwid_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_mpath_wwid_get \- Retrieve WWID of certain mpath.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_array_get.3 b/libdmmp/docs/man/dmmp_path_array_get.3
> index 53340b3..21f486b 100644
> --- a/libdmmp/docs/man/dmmp_path_array_get.3
> +++ b/libdmmp/docs/man/dmmp_path_array_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_array_get" 3 "dmmp_path_array_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_array_get" 3 "dmmp_path_array_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_array_get \- Retrieve path pointer array.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_blk_name_get.3 b/libdmmp/docs/man/dmmp_path_blk_name_get.3
> index da5f9f0..5938f0e 100644
> --- a/libdmmp/docs/man/dmmp_path_blk_name_get.3
> +++ b/libdmmp/docs/man/dmmp_path_blk_name_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_blk_name_get" 3 "dmmp_path_blk_name_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_blk_name_get" 3 "dmmp_path_blk_name_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_blk_name_get \- Retrieve block name.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_group_array_get.3 b/libdmmp/docs/man/dmmp_path_group_array_get.3
> index 6eee4a2..ca3187c 100644
> --- a/libdmmp/docs/man/dmmp_path_group_array_get.3
> +++ b/libdmmp/docs/man/dmmp_path_group_array_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_group_array_get" 3 "dmmp_path_group_array_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_group_array_get" 3 "dmmp_path_group_array_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_group_array_get \- Retrieve path groups pointer array.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_group_id_get.3 b/libdmmp/docs/man/dmmp_path_group_id_get.3
> index 4f07b53..a84f31f 100644
> --- a/libdmmp/docs/man/dmmp_path_group_id_get.3
> +++ b/libdmmp/docs/man/dmmp_path_group_id_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_group_id_get" 3 "dmmp_path_group_id_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_group_id_get" 3 "dmmp_path_group_id_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_group_id_get \- Retrieve path group ID.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_group_priority_get.3 b/libdmmp/docs/man/dmmp_path_group_priority_get.3
> index a48b270..1cda8af 100644
> --- a/libdmmp/docs/man/dmmp_path_group_priority_get.3
> +++ b/libdmmp/docs/man/dmmp_path_group_priority_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_group_priority_get" 3 "dmmp_path_group_priority_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_group_priority_get" 3 "dmmp_path_group_priority_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_group_priority_get \- Retrieve path group priority.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_group_selector_get.3 b/libdmmp/docs/man/dmmp_path_group_selector_get.3
> index 407b3f4..f55477b 100644
> --- a/libdmmp/docs/man/dmmp_path_group_selector_get.3
> +++ b/libdmmp/docs/man/dmmp_path_group_selector_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_group_selector_get" 3 "dmmp_path_group_selector_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_group_selector_get" 3 "dmmp_path_group_selector_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_group_selector_get \- Retrieve path group selector.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_group_status_get.3 b/libdmmp/docs/man/dmmp_path_group_status_get.3
> index a81aeb3..53e68b8 100644
> --- a/libdmmp/docs/man/dmmp_path_group_status_get.3
> +++ b/libdmmp/docs/man/dmmp_path_group_status_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_group_status_get" 3 "dmmp_path_group_status_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_group_status_get" 3 "dmmp_path_group_status_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_group_status_get \- Retrieve path group status.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_group_status_str.3 b/libdmmp/docs/man/dmmp_path_group_status_str.3
> index e4a9f74..98f877a 100644
> --- a/libdmmp/docs/man/dmmp_path_group_status_str.3
> +++ b/libdmmp/docs/man/dmmp_path_group_status_str.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_group_status_str" 3 "dmmp_path_group_status_str" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_group_status_str" 3 "dmmp_path_group_status_str" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_group_status_str \- Convert path group status to string.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_status_get.3 b/libdmmp/docs/man/dmmp_path_status_get.3
> index 025cfee..baa4437 100644
> --- a/libdmmp/docs/man/dmmp_path_status_get.3
> +++ b/libdmmp/docs/man/dmmp_path_status_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_status_get" 3 "dmmp_path_status_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_status_get" 3 "dmmp_path_status_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_status_get \- Retrieve the path status.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_status_str.3 b/libdmmp/docs/man/dmmp_path_status_str.3
> index 3944d39..425e472 100644
> --- a/libdmmp/docs/man/dmmp_path_status_str.3
> +++ b/libdmmp/docs/man/dmmp_path_status_str.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_status_str" 3 "dmmp_path_status_str" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_status_str" 3 "dmmp_path_status_str" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_status_str \- Convert path status to string.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_reconfig.3 b/libdmmp/docs/man/dmmp_reconfig.3
> index a743e30..36bd504 100644
> --- a/libdmmp/docs/man/dmmp_reconfig.3
> +++ b/libdmmp/docs/man/dmmp_reconfig.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_reconfig" 3 "dmmp_reconfig" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_reconfig" 3 "dmmp_reconfig" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_reconfig \- Instruct multipathd daemon to do reconfiguration.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_strerror.3 b/libdmmp/docs/man/dmmp_strerror.3
> index 4d753d3..3acd9c9 100644
> --- a/libdmmp/docs/man/dmmp_strerror.3
> +++ b/libdmmp/docs/man/dmmp_strerror.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_strerror" 3 "dmmp_strerror" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_strerror" 3 "dmmp_strerror" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_strerror \- Convert error code to string.
>  .SH SYNOPSIS
> -- 
> 2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

