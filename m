Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E8030EF69
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 16:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773851805; cv=none; b=kpncW2qy6C12vVog2ZcOts8tvkWYZ2E+ZTkdjxf9xcueb2FIiKPjbTyAQLb1wvteL2VgdDazifsJ777vai0BlnyBhBcQK0N+IiTJ65ltKmLu7SmlyByXbx6QMpsn+CBRvWdAiFKDa2HVuFWsrOLZZeJiO0z5MBtx2CjYKmh5uz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773851805; c=relaxed/simple;
	bh=rsGqjI7NAT7u8zlE4q4bKUmQOLjJISl5ktNJe2tSH5k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XiaTwnwU5wsNF+s7rvS85Ulsdo+UO0LiIMpIpS6V8ZMmc/ZYdz9b4lIx72MRf78YUvcgkvNol6P9o1E272273tdgNteDI8Df7e9tqTNk5YXynUdA7jR/Z6uBdf2urVhkyOARWfE1InD5jssLJTB5vCKbR38egtgddnHlffOKYSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cd5rKqqQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cd5rKqqQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773851800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hB5h17lHrSgoRYfTTE5sNocOSdmpWBPr6ZTwWkBI1iM=;
	b=Cd5rKqqQ1PGk6qr+4AjIPIYPJtwpP3CR0yT7st6vyEDkTspxAZMUqe9YhjCntJu9quPwLr
	jSFaVFctYD76qfgr3hw6kT6kqEgsrdvMFcQigesO372SaS/DDzSceukjKjlRHmhaz+B5OC
	H266g3t6UA8bqh4YMrnjxtAbjGytohc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-344-8nvIqNDzMp25rgBTNdSf1w-1; Wed,
 18 Mar 2026 12:36:36 -0400
X-MC-Unique: 8nvIqNDzMp25rgBTNdSf1w-1
X-Mimecast-MFC-AGG-ID: 8nvIqNDzMp25rgBTNdSf1w_1773851794
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B106719560B4;
	Wed, 18 Mar 2026 16:36:33 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 331A830002D6;
	Wed, 18 Mar 2026 16:36:30 +0000 (UTC)
Date: Wed, 18 Mar 2026 17:36:25 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Guillaume Gonnet <ggonnet.linux@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Peter Korsgaard <peter@korsgaard.com>, dm-devel@schwermer.no, 
    chanho.min@lge.com, jaeyuel.im@lge.com, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm init: ensure device probing has finished in
 dm-mod.waitfor=
In-Reply-To: <20260317213229.18371-1-ggonnet.linux@gmail.com>
Message-ID: <46a69472-84a8-c02b-1879-af30da13523c@redhat.com>
References: <20260317213229.18371-1-ggonnet.linux@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Dd-LFRLHIe6kR1qNeDq0w5iNHCOSNGgRXlg_T-MolPs_1773851794
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I staged the patch, thanks.

Mikulas



On Tue, 17 Mar 2026, Guillaume Gonnet wrote:

> The early_lookup_bdev() function returns successfully when the disk
> device is present but not necessarily its partitions. In this situation,
> dm_early_create() fails as the partition block device does not exist
> yet.
> 
> In my case, this phenomenon occurs quite often because the device is
> an SD card with slow reading times, on which kernel takes time to
> enumerate available partitions.
> 
> Fortunately, the underlying device is back to "probing" state while
> enumerating partitions. Waiting for all probing to end is enough to fix
> this issue.
> 
> That's also the reason why this problem never occurs with rootwait=
> parameter: the while loop inside wait_for_root() explicitly waits for
> probing to be done and then the function calls async_synchronize_full().
> These lines were omitted in 035641b, even though the commit says it's
> based on the rootwait logic...
> 
> Anyway, calling wait_for_device_probe() after our while loop does the
> job (it both waits for probing and calls async_synchronize_full).
> 
> Fixes: 035641b01e72 ("dm init: add dm-mod.waitfor to wait for asynchronously probed block devices")
> Signed-off-by: Guillaume Gonnet <ggonnet.linux@gmail.com>
> ---
> 
> Hello,
> 
> This patch is my attempt to fix the dm-mod.waitfor= issue. I had this
> fix for quite a while now, but I've never made the effort to contribute
> until recently.
> 
> Some have tried to fix it this issue in the past but without finding
> its real root cause (ie. not waiting for device probe to end).
> 
> Here are the links to those patches, for reference:
> https://lore.kernel.org/all/b5c5cd56-b9dd-4368-a8e1-b9e0a07b79b4@schwermer.no/
> https://lore.kernel.org/all/20250410080056.43247-1-chanho.min@lge.com/
> https://lore.kernel.org/dm-devel/20251211073426.123026-1-jaeyuel.im@lge.com/
> 
>  drivers/md/dm-init.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
> index 7403823384c5..c1bacba92c65 100644
> --- a/drivers/md/dm-init.c
> +++ b/drivers/md/dm-init.c
> @@ -303,8 +303,10 @@ static int __init dm_init_init(void)
>  		}
>  	}
>  
> -	if (waitfor[0])
> +	if (waitfor[0]) {
> +		wait_for_device_probe();
>  		DMINFO("all devices available");
> +	}
>  
>  	list_for_each_entry(dev, &devices, list) {
>  		if (dm_early_create(&dev->dmi, dev->table,
> -- 
> 2.43.0
> 

