Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39582F24
	for <dm-devel@lists.linux.dev>; Thu, 31 Jul 2025 14:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753971709; cv=none; b=Bo4mYfAvX6qN3+YFffpPILm5hA2peDkPJbgLqy2/TRoJk34zTWmyDh0Zq0oQIjlMbFALUjfkl9DxYQ2HydFmOsP/lyZL6Ax0dH4OWHs0IhmhcENN1ZW6Lhpdssl2zgukq6yPB/QiKCYRanlL0nAL16PfZy6LCyz3d9nyvzEkc94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753971709; c=relaxed/simple;
	bh=Wxid77PNquvoKax5+b6T38t8BZwa3TGA331BESNnOG4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BbSJiX8p3izjkXGoMdxMIsK5yte3AiB4UztQ7JLGeo7nOzDja4680HY0dz5yxOmmHNoqeUo6TEpRes/NGGefseJWdNogM4p2zxkTN2PZipyQgKj5txo73WELtRr84WdqkjTol6+pEDYe3JlWkRORN0slFTDtg4/Pdrq77VKCXPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OqxIpzHe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OqxIpzHe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753971706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mpeZMbt4KO8kjMIsLjUpUcEmRgZRnDhDF3zL7JFRIg0=;
	b=OqxIpzHeMEUSaFs2PpprXacbad/masa/4JXdxbxxWmc9wXFbtLFZha15Kp70nN9bQ/7VhT
	zyk76fu+XWDvZRSIfooKlT2oxNgtpmkP83RtMPi160JkPrGRTCsK4orgYQAOtRDyUIPiEH
	rrPNlgs+DZHMOqxzV6QPVQKbZ2I8ldM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-255-fiBNlxWUO0iW-78Fmbh0XA-1; Thu,
 31 Jul 2025 10:21:41 -0400
X-MC-Unique: fiBNlxWUO0iW-78Fmbh0XA-1
X-Mimecast-MFC-AGG-ID: fiBNlxWUO0iW-78Fmbh0XA_1753971700
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87FC51800365;
	Thu, 31 Jul 2025 14:21:40 +0000 (UTC)
Received: from [10.22.80.24] (unknown [10.22.80.24])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E90B81800359;
	Thu, 31 Jul 2025 14:21:38 +0000 (UTC)
Date: Thu, 31 Jul 2025 16:21:32 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org
Subject: Re: [PATCH] dm-thin: update the documentation.
In-Reply-To: <20250731085326.1976997-1-weilongping@oppo.com>
Message-ID: <4a7df7ac-fc33-dfc1-19f1-b056b6c92ac2@redhat.com>
References: <20250731085326.1976997-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9os6nsrS7UKiKuYur9h1T3WF3e4Ka2ejPsUF6kM66j0_1753971700
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Applied, thanks.

Mikulas


On Thu, 31 Jul 2025, LongPing Wei wrote:

> 1. convert KB/MB/GB to KiB/MiB/GiB;
> 2. change the number of sectors for 128MiB from 256000 to 262144 as
> 256000 sectors is neither 128 MB nor 128 MiB.
> 
> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> ---
>  .../device-mapper/thin-provisioning.rst          | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/admin-guide/device-mapper/thin-provisioning.rst b/Documentation/admin-guide/device-mapper/thin-provisioning.rst
> index bafebf79da4b..b2fa49a5608a 100644
> --- a/Documentation/admin-guide/device-mapper/thin-provisioning.rst
> +++ b/Documentation/admin-guide/device-mapper/thin-provisioning.rst
> @@ -80,11 +80,11 @@ less sharing than average you'll need a larger-than-average metadata device.
>  
>  As a guide, we suggest you calculate the number of bytes to use in the
>  metadata device as 48 * $data_dev_size / $data_block_size but round it up
> -to 2MB if the answer is smaller.  If you're creating large numbers of
> +to 2MiB if the answer is smaller.  If you're creating large numbers of
>  snapshots which are recording large amounts of change, you may find you
>  need to increase this.
>  
> -The largest size supported is 16GB: If the device is larger,
> +The largest size supported is 16GiB: If the device is larger,
>  a warning will be issued and the excess space will not be used.
>  
>  Reloading a pool table
> @@ -107,13 +107,13 @@ Using an existing pool device
>  
>  $data_block_size gives the smallest unit of disk space that can be
>  allocated at a time expressed in units of 512-byte sectors.
> -$data_block_size must be between 128 (64KB) and 2097152 (1GB) and a
> -multiple of 128 (64KB).  $data_block_size cannot be changed after the
> +$data_block_size must be between 128 (64KiB) and 2097152 (1GiB) and a
> +multiple of 128 (64KiB).  $data_block_size cannot be changed after the
>  thin-pool is created.  People primarily interested in thin provisioning
> -may want to use a value such as 1024 (512KB).  People doing lots of
> -snapshotting may want a smaller value such as 128 (64KB).  If you are
> +may want to use a value such as 1024 (512KiB).  People doing lots of
> +snapshotting may want a smaller value such as 128 (64KiB).  If you are
>  not zeroing newly-allocated data, a larger $data_block_size in the
> -region of 256000 (128MB) is suggested.
> +region of 262144 (128MiB) is suggested.
>  
>  $low_water_mark is expressed in blocks of size $data_block_size.  If
>  free space on the data device drops below this level then a dm event
> @@ -291,7 +291,7 @@ i) Constructor
>        error_if_no_space:
>  	Error IOs, instead of queueing, if no space.
>  
> -    Data block size must be between 64KB (128 sectors) and 1GB
> +    Data block size must be between 64KiB (128 sectors) and 1GiB
>      (2097152 sectors) inclusive.
>  
>  
> -- 
> 2.34.1
> 

