Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E7437BE97
	for <dm-devel@lists.linux.dev>; Mon, 19 Jan 2026 14:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768832609; cv=none; b=NMXlkwP05WU+f5aHr63rONO6TbZiNN8J/l3SWzSdLczyDearMtXLZMFTHLIPFR/NmU5HNosCzceUBqVkkra9+sH0aloO97NwXqM/pthVzNoxS7MP7IVZxuzSweZHuOd6cDSFZY/zYdhRkOfVjBd0Xz0OoAwx/2XLRBTjzlUGPc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768832609; c=relaxed/simple;
	bh=afNzdDnaNRtBTxVHInMO1PCMbDPxoP+mW8GAhHq3nkk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hKED7msMVTIcnaL4LXe9qpYXCW5iEnE5grcBtxSbx2nvh2eaC+IsrrupdNhM/o5H5pGkJSf57TeMM3wor2gf1Y404JR80tfJ7Icgbt8KCWQmf2DcgbQ+mf5M+cbRfcGZxMp1w6VcCDrsxt8ki+6lohz6R8WTH6hpGM+246TLK8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i7aTJ50X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i7aTJ50X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768832606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kxHKO0lst+mJSTcNdIGAIxQuG8jghJAAM75HeAbsIvw=;
	b=i7aTJ50XZY8cvEkZwXGQLoBk8qAWEO2dqJtDuDaPsKlo7jSpXXhR/9hH7Ev8/xiDlnAtRi
	5qmwGMSg2cOjf+/tYudLFUWu/hbRDdcOG/2JCinMFdwWT+d14eVP0oXajfF6/xdZ5PKiKY
	/qKttZNgwaU6qCkNbyd4gu353yniIMw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-256-iavnxOVjNKSxg0yU2-PJVg-1; Mon,
 19 Jan 2026 09:23:25 -0500
X-MC-Unique: iavnxOVjNKSxg0yU2-PJVg-1
X-Mimecast-MFC-AGG-ID: iavnxOVjNKSxg0yU2-PJVg_1768832603
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61ED0190A379;
	Mon, 19 Jan 2026 14:23:03 +0000 (UTC)
Received: from [10.44.34.158] (unknown [10.44.34.158])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F4601800999;
	Mon, 19 Jan 2026 14:23:00 +0000 (UTC)
Date: Mon, 19 Jan 2026 15:22:58 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Christian Brauner <brauner@kernel.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] dm-verity: add dm-verity keyring
In-Reply-To: <20260116-work-dm-verity-keyring-v1-1-0d3de29b0618@kernel.org>
Message-ID: <5ad502f9-2d97-8e56-72b9-67a255d95d72@redhat.com>
References: <20260116-work-dm-verity-keyring-v1-0-0d3de29b0618@kernel.org> <20260116-work-dm-verity-keyring-v1-1-0d3de29b0618@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9uj5l7yvtgpLEllwA1JR4X4aOiLRIDRdyUchNWdo24c_1768832603
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 16 Jan 2026, Christian Brauner wrote:

> Add a dedicated ".dm-verity" keyring for root hash signature
> verification, similar to the ".fs-verity" keyring used by fs-verity.
> 
> By default the keyring is unused retaining the exact same old behavior.
> For systems that provision additional keys only intended for dm-verity
> images during boot, the dm_verity.keyring_unsealed=1 kernel parameter
> leaves the keyring open.
> 
> We want to use this in systemd as a way add keys during boot that are
> only used for creating dm-verity devices for later mounting and nothing
> else. The discoverable disk image (DDI) spec at [1] heavily relies on
> dm-verity and we would like to expand this even more. This will allow us
> to do that in a fully backward compatible way.
> 
> Once provisioning is complete, userspace restricts and activates it for
> dm-verity verification. If userspace fully seals the keyring then it
> gains the guarantee that no new keys can be added.
> 
> Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification [1]
> Co-developed-by: Aleksa Sarai <cyphar@cyphar.com>
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  7 ++++
>  drivers/md/dm-verity-target.c                   | 20 ++++++++++-
>  drivers/md/dm-verity-verify-sig.c               | 45 +++++++++++++++++++++++++
>  drivers/md/dm-verity-verify-sig.h               | 12 +++++++
>  4 files changed, 83 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index a8d0afde7f85..374571c7921a 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1370,6 +1370,13 @@ Kernel parameters
>  			For details see:
>  			Documentation/admin-guide/hw-vuln/reg-file-data-sampling.rst
>  
> +	dm_verity.keyring_unsealed=
> +			[KNL] When set to 1, leave the dm-verity keyring
> +			unsealed after initialization so userspace can
> +			provision keys. Once the keyring is restricted
> +			it becomes active and is searched during signature
> +			verification.
> +
>  	driver_async_probe=  [KNL]
>  			List of driver names to be probed asynchronously. *
>  			matches with all driver names. If * is specified, the
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 5c17472d7896..835358f63d09 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1803,7 +1803,25 @@ static struct target_type verity_target = {
>  	.preresume	= verity_preresume,
>  #endif /* CONFIG_SECURITY */
>  };
> -module_dm(verity);
> +
> +static int __init dm_verity_init(void)
> +{
> +	int r;
> +
> +	r = dm_verity_verify_sig_init();
> +	if (r)
> +		return r;
> +
> +	return dm_register_target(&verity_target);
> +}

Hi

There's a bug that if dm_register_target fails, you leak the keyring. I 
fixed it and accepted the patch.

Mikulas

