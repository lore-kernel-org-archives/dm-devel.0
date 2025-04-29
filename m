Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BB32528FC
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 20:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745959758; cv=none; b=B7wu5BIeSSKayCFETLRkWxrimHEyOEEWOZKjkYgps+c+KCG7fdUZXqp/2pI6AxtsBm164BVl9NiP+QfATE/J+JQv6v6On2CVfnWXE15z3easBBniiwR8fiRfqhTkvCN7c0nGHoqyx4vxEyycF5sd/nQOHZ5K2mo3/mtf+Xy8QdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745959758; c=relaxed/simple;
	bh=H90kVUeNr41GsPqc+c9SHehamRHp7XyP/K1fvfIyyBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=HIy7NtXTJM5JnCUzgyE2YJyTHeicXVJJ0xGbmzYiNKkOg1tm4Ivv8sNXPo/JMh6YK1Pkadu1rUY47lLhEc1y5kDpnJT55Dh+Ur6AqOUv7um8UPbh/upWvrxoTrx5a3f8JxEBPBTEG3qbyHqbcwKL7ENlscBDKUjLqpG7umb0WNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZeiqooaX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZeiqooaX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745959754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6RFZZwYaYJ6gmgeN2mVNtYnC6LfeVgXdMJbSW8rjYi8=;
	b=ZeiqooaX1iea2u+uFfqde4hN3HWschHH38OpFfTuaIS7NORMrLorf89J1au/g824667lkX
	LpiPheFXL0SKOL4FvJ78KQR0aRixavvldcwO3Ar5V88Lhj5t8Y7NqEgpOxG8S5+yyuCjYs
	oN/JCk8eBPTuKVWYyAeSUybhbFgQ/eA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-427-3qw-SJTVOTeonJ9IeRrjZg-1; Tue,
 29 Apr 2025 16:49:09 -0400
X-MC-Unique: 3qw-SJTVOTeonJ9IeRrjZg-1
X-Mimecast-MFC-AGG-ID: 3qw-SJTVOTeonJ9IeRrjZg_1745959748
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F48B1800446;
	Tue, 29 Apr 2025 20:49:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24B951800D97;
	Tue, 29 Apr 2025 20:49:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53TKn5DW1951915
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Apr 2025 16:49:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53TKn5Xp1951914;
	Tue, 29 Apr 2025 16:49:05 -0400
Date: Tue, 29 Apr 2025 16:49:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Yoann Congal <yoann.congal@smile.fr>,
        Sofiane HAMAM <sofiane.hamam@smile.fr>,
        Kelefa Sane <kelefa.sane@smile.fr>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] libdmmp: update time stamp of man pages
Message-ID: <aBE7QcKXe-80Vomn@redhat.com>
References: <20250407103346.55121-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250407103346.55121-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _K1HmVqyq0uAHe0qFJMNbsiDb2oSVbyHzg5iT848NNM_1745959748
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 07, 2025 at 12:33:46PM +0200, Martin Wilck wrote:
> The man pages should have the same timestamp as the last change
> in libdmmp.h, which was 216de53 ("multipath-tools: use common convention
> for "header file included" macros") in August 2024.
> 
> Together with the previous patch, this should ensure that the man pages
> will get the correct time stamp in the future.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
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
>  29 files changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/libdmmp/docs/man/dmmp_context_free.3 b/libdmmp/docs/man/dmmp_context_free.3
> index 7c109e1..2a9bbb1 100644
> --- a/libdmmp/docs/man/dmmp_context_free.3
> +++ b/libdmmp/docs/man/dmmp_context_free.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_free" 3 "dmmp_context_free" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_free" 3 "dmmp_context_free" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_free \- Release the memory of struct dmmp_context.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_log_func_set.3 b/libdmmp/docs/man/dmmp_context_log_func_set.3
> index be311ec..f593eb5 100644
> --- a/libdmmp/docs/man/dmmp_context_log_func_set.3
> +++ b/libdmmp/docs/man/dmmp_context_log_func_set.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_log_func_set" 3 "dmmp_context_log_func_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_log_func_set" 3 "dmmp_context_log_func_set" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_log_func_set \- Set log handler function.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_log_priority_get.3 b/libdmmp/docs/man/dmmp_context_log_priority_get.3
> index be38301..6f7c320 100644
> --- a/libdmmp/docs/man/dmmp_context_log_priority_get.3
> +++ b/libdmmp/docs/man/dmmp_context_log_priority_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_log_priority_get" 3 "dmmp_context_log_priority_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_log_priority_get" 3 "dmmp_context_log_priority_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_log_priority_get \- Get log priority.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_log_priority_set.3 b/libdmmp/docs/man/dmmp_context_log_priority_set.3
> index 79e4d2e..c1ff371 100644
> --- a/libdmmp/docs/man/dmmp_context_log_priority_set.3
> +++ b/libdmmp/docs/man/dmmp_context_log_priority_set.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_log_priority_set" 3 "dmmp_context_log_priority_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_log_priority_set" 3 "dmmp_context_log_priority_set" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_log_priority_set \- Set log priority.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_new.3 b/libdmmp/docs/man/dmmp_context_new.3
> index 12505f9..487ccde 100644
> --- a/libdmmp/docs/man/dmmp_context_new.3
> +++ b/libdmmp/docs/man/dmmp_context_new.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_new" 3 "dmmp_context_new" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_new" 3 "dmmp_context_new" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_new \- Create struct dmmp_context.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_timeout_get.3 b/libdmmp/docs/man/dmmp_context_timeout_get.3
> index 2ed825d..b738fb9 100644
> --- a/libdmmp/docs/man/dmmp_context_timeout_get.3
> +++ b/libdmmp/docs/man/dmmp_context_timeout_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_timeout_get" 3 "dmmp_context_timeout_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_timeout_get" 3 "dmmp_context_timeout_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_timeout_get \- Get IPC timeout.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_timeout_set.3 b/libdmmp/docs/man/dmmp_context_timeout_set.3
> index 16bc9d9..af84be9 100644
> --- a/libdmmp/docs/man/dmmp_context_timeout_set.3
> +++ b/libdmmp/docs/man/dmmp_context_timeout_set.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_timeout_set" 3 "dmmp_context_timeout_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_timeout_set" 3 "dmmp_context_timeout_set" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_timeout_set \- Set IPC timeout.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_userdata_get.3 b/libdmmp/docs/man/dmmp_context_userdata_get.3
> index eff446c..23e1da4 100644
> --- a/libdmmp/docs/man/dmmp_context_userdata_get.3
> +++ b/libdmmp/docs/man/dmmp_context_userdata_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_userdata_get" 3 "dmmp_context_userdata_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_userdata_get" 3 "dmmp_context_userdata_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_userdata_get \- Get user data pointer.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_context_userdata_set.3 b/libdmmp/docs/man/dmmp_context_userdata_set.3
> index d7be869..8a4a765 100644
> --- a/libdmmp/docs/man/dmmp_context_userdata_set.3
> +++ b/libdmmp/docs/man/dmmp_context_userdata_set.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_context_userdata_set" 3 "dmmp_context_userdata_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_context_userdata_set" 3 "dmmp_context_userdata_set" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_context_userdata_set \- Set user data pointer.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_flush_mpath.3 b/libdmmp/docs/man/dmmp_flush_mpath.3
> index 359607e..e5690ed 100644
> --- a/libdmmp/docs/man/dmmp_flush_mpath.3
> +++ b/libdmmp/docs/man/dmmp_flush_mpath.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_flush_mpath" 3 "dmmp_flush_mpath" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_flush_mpath" 3 "dmmp_flush_mpath" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_flush_mpath \- Flush specified multipath device map if unused.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_last_error_msg.3 b/libdmmp/docs/man/dmmp_last_error_msg.3
> index 378c55a..548e1a7 100644
> --- a/libdmmp/docs/man/dmmp_last_error_msg.3
> +++ b/libdmmp/docs/man/dmmp_last_error_msg.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_last_error_msg" 3 "dmmp_last_error_msg" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_last_error_msg" 3 "dmmp_last_error_msg" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_last_error_msg \- Retrieves the last error message.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_log_priority_str.3 b/libdmmp/docs/man/dmmp_log_priority_str.3
> index b276160..cf31556 100644
> --- a/libdmmp/docs/man/dmmp_log_priority_str.3
> +++ b/libdmmp/docs/man/dmmp_log_priority_str.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_log_priority_str" 3 "dmmp_log_priority_str" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_log_priority_str" 3 "dmmp_log_priority_str" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_log_priority_str \- Convert log priority to string.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_mpath_array_free.3 b/libdmmp/docs/man/dmmp_mpath_array_free.3
> index 0514a66..8d2090e 100644
> --- a/libdmmp/docs/man/dmmp_mpath_array_free.3
> +++ b/libdmmp/docs/man/dmmp_mpath_array_free.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_mpath_array_free" 3 "dmmp_mpath_array_free" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_mpath_array_free" 3 "dmmp_mpath_array_free" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_mpath_array_free \- Free 'struct dmmp_mpath' pointer array.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_mpath_array_get.3 b/libdmmp/docs/man/dmmp_mpath_array_get.3
> index 8b0e5b5..4191571 100644
> --- a/libdmmp/docs/man/dmmp_mpath_array_get.3
> +++ b/libdmmp/docs/man/dmmp_mpath_array_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_mpath_array_get" 3 "dmmp_mpath_array_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_mpath_array_get" 3 "dmmp_mpath_array_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_mpath_array_get \- Query all existing multipath devices.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3 b/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
> index ddead55..261bea6 100644
> --- a/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
> +++ b/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_mpath_kdev_name_get" 3 "dmmp_mpath_kdev_name_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_mpath_kdev_name_get" 3 "dmmp_mpath_kdev_name_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_mpath_kdev_name_get \- Retrieve kernel DEVNAME of certain mpath.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_mpath_name_get.3 b/libdmmp/docs/man/dmmp_mpath_name_get.3
> index 2b0027e..894d318 100644
> --- a/libdmmp/docs/man/dmmp_mpath_name_get.3
> +++ b/libdmmp/docs/man/dmmp_mpath_name_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_mpath_name_get" 3 "dmmp_mpath_name_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_mpath_name_get" 3 "dmmp_mpath_name_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_mpath_name_get \- Retrieve name(alias) of certain mpath.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_mpath_wwid_get.3 b/libdmmp/docs/man/dmmp_mpath_wwid_get.3
> index b8e9e7d..e6afcb1 100644
> --- a/libdmmp/docs/man/dmmp_mpath_wwid_get.3
> +++ b/libdmmp/docs/man/dmmp_mpath_wwid_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_mpath_wwid_get" 3 "dmmp_mpath_wwid_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_mpath_wwid_get" 3 "dmmp_mpath_wwid_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_mpath_wwid_get \- Retrieve WWID of certain mpath.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_array_get.3 b/libdmmp/docs/man/dmmp_path_array_get.3
> index 21f486b..de29c9d 100644
> --- a/libdmmp/docs/man/dmmp_path_array_get.3
> +++ b/libdmmp/docs/man/dmmp_path_array_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_array_get" 3 "dmmp_path_array_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_array_get" 3 "dmmp_path_array_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_array_get \- Retrieve path pointer array.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_blk_name_get.3 b/libdmmp/docs/man/dmmp_path_blk_name_get.3
> index 5938f0e..167e81c 100644
> --- a/libdmmp/docs/man/dmmp_path_blk_name_get.3
> +++ b/libdmmp/docs/man/dmmp_path_blk_name_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_blk_name_get" 3 "dmmp_path_blk_name_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_blk_name_get" 3 "dmmp_path_blk_name_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_blk_name_get \- Retrieve block name.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_group_array_get.3 b/libdmmp/docs/man/dmmp_path_group_array_get.3
> index ca3187c..b9b663f 100644
> --- a/libdmmp/docs/man/dmmp_path_group_array_get.3
> +++ b/libdmmp/docs/man/dmmp_path_group_array_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_group_array_get" 3 "dmmp_path_group_array_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_group_array_get" 3 "dmmp_path_group_array_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_group_array_get \- Retrieve path groups pointer array.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_group_id_get.3 b/libdmmp/docs/man/dmmp_path_group_id_get.3
> index a84f31f..67ba5c0 100644
> --- a/libdmmp/docs/man/dmmp_path_group_id_get.3
> +++ b/libdmmp/docs/man/dmmp_path_group_id_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_group_id_get" 3 "dmmp_path_group_id_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_group_id_get" 3 "dmmp_path_group_id_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_group_id_get \- Retrieve path group ID.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_group_priority_get.3 b/libdmmp/docs/man/dmmp_path_group_priority_get.3
> index 1cda8af..09cbea9 100644
> --- a/libdmmp/docs/man/dmmp_path_group_priority_get.3
> +++ b/libdmmp/docs/man/dmmp_path_group_priority_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_group_priority_get" 3 "dmmp_path_group_priority_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_group_priority_get" 3 "dmmp_path_group_priority_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_group_priority_get \- Retrieve path group priority.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_group_selector_get.3 b/libdmmp/docs/man/dmmp_path_group_selector_get.3
> index f55477b..dc73fa8 100644
> --- a/libdmmp/docs/man/dmmp_path_group_selector_get.3
> +++ b/libdmmp/docs/man/dmmp_path_group_selector_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_group_selector_get" 3 "dmmp_path_group_selector_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_group_selector_get" 3 "dmmp_path_group_selector_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_group_selector_get \- Retrieve path group selector.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_group_status_get.3 b/libdmmp/docs/man/dmmp_path_group_status_get.3
> index 53e68b8..a7662b6 100644
> --- a/libdmmp/docs/man/dmmp_path_group_status_get.3
> +++ b/libdmmp/docs/man/dmmp_path_group_status_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_group_status_get" 3 "dmmp_path_group_status_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_group_status_get" 3 "dmmp_path_group_status_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_group_status_get \- Retrieve path group status.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_group_status_str.3 b/libdmmp/docs/man/dmmp_path_group_status_str.3
> index 98f877a..160c8a7 100644
> --- a/libdmmp/docs/man/dmmp_path_group_status_str.3
> +++ b/libdmmp/docs/man/dmmp_path_group_status_str.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_group_status_str" 3 "dmmp_path_group_status_str" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_group_status_str" 3 "dmmp_path_group_status_str" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_group_status_str \- Convert path group status to string.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_status_get.3 b/libdmmp/docs/man/dmmp_path_status_get.3
> index baa4437..92e6433 100644
> --- a/libdmmp/docs/man/dmmp_path_status_get.3
> +++ b/libdmmp/docs/man/dmmp_path_status_get.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_status_get" 3 "dmmp_path_status_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_status_get" 3 "dmmp_path_status_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_status_get \- Retrieve the path status.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_path_status_str.3 b/libdmmp/docs/man/dmmp_path_status_str.3
> index 425e472..456cf24 100644
> --- a/libdmmp/docs/man/dmmp_path_status_str.3
> +++ b/libdmmp/docs/man/dmmp_path_status_str.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_path_status_str" 3 "dmmp_path_status_str" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_path_status_str" 3 "dmmp_path_status_str" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_path_status_str \- Convert path status to string.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_reconfig.3 b/libdmmp/docs/man/dmmp_reconfig.3
> index 36bd504..413a3e6 100644
> --- a/libdmmp/docs/man/dmmp_reconfig.3
> +++ b/libdmmp/docs/man/dmmp_reconfig.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_reconfig" 3 "dmmp_reconfig" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_reconfig" 3 "dmmp_reconfig" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_reconfig \- Instruct multipathd daemon to do reconfiguration.
>  .SH SYNOPSIS
> diff --git a/libdmmp/docs/man/dmmp_strerror.3 b/libdmmp/docs/man/dmmp_strerror.3
> index 3acd9c9..202941c 100644
> --- a/libdmmp/docs/man/dmmp_strerror.3
> +++ b/libdmmp/docs/man/dmmp_strerror.3
> @@ -1,4 +1,4 @@
> -.TH "dmmp_strerror" 3 "dmmp_strerror" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
> +.TH "dmmp_strerror" 3 "dmmp_strerror" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
>  .SH NAME
>  dmmp_strerror \- Convert error code to string.
>  .SH SYNOPSIS
> -- 
> 2.49.0

