Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C85399379
	for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773149651; cv=none; b=oAHiMAuM3y9o6WfrWC6Y8IbIQmBBNSR7FprVy5gp9N3/IiSDVrXMM1sRU53GXEFxj0UcY4gttmFjCQjlpMpMuFduzNhCQf84tRMV1aK0mo7eVBoTG+oMIDTY7sa6x5dc5rQl3LPvRhUdjfQGoab9neviYwz64IYX9+se/Xgm+IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773149651; c=relaxed/simple;
	bh=VTkD031qPJOSGpZBGmc3+BQ8Cgl4lzlmo7twwWZLZW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RTeiVElJD48Yvjty/R8UxDI24Hcjk5slbsiLCTtt3nF9S0poZYuyGHAtzjFZjDX9BrnqkFSkpYVBJvP0ODkMVmqy1S5KrLbjIvCMBmROJ1mwH3Ka8FdFikjOB9xOMAP/1Q0iao/ItrvBt9UYuA30hM8Tn+9Br5MSJxjNwZP937Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Spf2B8aa; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Spf2B8aa"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48534b59cf3so21591985e9.2
        for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 06:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773149648; x=1773754448; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n1929U+2B2jsF7SJZ2DGFfE2DUFLxK1sQO/tNgjnO0w=;
        b=Spf2B8aa2h5Pfob15g3AUMfuS4o8ASVqOLZBYaqHYYs6VWKG1EKRQ54Fk64K7DOCMf
         UnxKcCHf/QK1QlTwEje2K0JwDXPq9cxokTHgPVvfrU0SlTyZ2XSnxi0c1spAxyVpWYOk
         7qCsrW7h+vZDWtJ5rGMZaV7ExeXRzElPmlFWGvPqTIWcVuqg6/VMsofE3jwatclh4gPe
         EGvPt6ImTR6f1OtWJpHf2X9fwu2Vvb+WyR0RK0hIISypREq4KIRMl/ZmraL5ZIaUB+V4
         HFwNqdJPsYyHsqPAnV34GOfojwUmu0ygyf8b8wsCbOj/v8DcZe/HeCmVQaagZHr3vAQq
         K9/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773149648; x=1773754448;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n1929U+2B2jsF7SJZ2DGFfE2DUFLxK1sQO/tNgjnO0w=;
        b=V2m3veIFDNl32S1buVe+YIDQeflHDWEG4Lp7k+NbpkpiFTePDD6CtLsQoWtBWs4/xF
         XJi1IYHKWZ1I3XiYyr/Exn1OQjFqeGahRhMcsb8kHxRPQOlQcQlbxb6vYl8q+1HniGd2
         NBY8HfSEifs1yUokcIojbXjIOcOEkWCe1vURg3RXa48H8jKzLcEIxxQxoat1qJEXGq3V
         cUfWEXdBrKc25dNbLBgUWzAa+ZEzXeVFkSv1Lr5Us871bX3HCOpoPdXG/9YwUGNIiAiC
         6EJ8/iRrEZIQhQ0s2vhYea7pi2CKWMxlQLVKxpjXNB2Xr6xbW/BkioRxe83042HJCrYq
         1h5w==
X-Forwarded-Encrypted: i=1; AJvYcCWyHZRGGT7AJ3LRDcLMKzMu2c1+BD3whGf2y1F7t2iH0U4IZ7ptU2OMu61p8Wap8yyY3oJsmevOHQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxcEp41B9eSDNGIdj19keQfgNMwx8sALKzsd8pOcHpRn6ZIBUb9
	4eJnRFW0imS5zJgo3euU9cW0DWIKJCMprjoHl28eTFKLWuF4Pt3zOaM9CcY0vAv80Qc=
X-Gm-Gg: ATEYQzwpS399DRvR9wtaOnm2Arv4qTgIwDkhrarfQ2UZUbr3g8MVaFabmEZU3I11dtV
	+nnOO+wRQAS2wZ5zrV8zezHEiq/yN6Wgm2qz06bXxH3JgDTTnLNDNwwhLDRhyRzO8+VzezpXeWG
	pdxq5oHXGbMqZeDo7OJsvFO68xXOxXJqTGV8ipX/uIdp8ttXNNnp3PyusAyN7skGJv9u3g6WaCy
	K0WJZvXSJ7LIRZ8qa1JraVc99PA4nd+fqYvkVNeS0C3MvacwQvzcvPLGLWjuciViHtWz3WaAVwJ
	1fjNEdLuc9aQAwzTKunXbq5GBG/SmwVUQjZ0kgWcKsXjbX5XXVdAhI4KVrRaA2jOp74jXsGZ0YB
	O5tfArPnarVQOn5DKaBHiqrtMyva5cVBu/OCjnhyEltQgSKRoihyxoK0QGj8zYUoxEI96jiNG6o
	oq7JkShmsAYcLuvfI7V9tREmScXuVqnWhi09fcGf1XqQXkYNDXEmsRNbM4
X-Received: by 2002:a05:600c:8b86:b0:485:3473:d4a1 with SMTP id 5b1f17b1804b1-4853473d6dcmr153991525e9.34.1773149648155;
        Tue, 10 Mar 2026 06:34:08 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae2b9ccsm35566642f8f.19.2026.03.10.06.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 06:34:07 -0700 (PDT)
Message-ID: <fa7061d7-20f1-43e8-af65-2afb02e428f9@suse.com>
Date: Tue, 10 Mar 2026 14:34:06 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] scsi: scsi-multipath: Issue a periodic TUR per path
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
 axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
 snitzer@kernel.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 nilay@linux.ibm.com
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-8-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260310114925.1222263-8-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/10/26 12:49, John Garry wrote:
> To allow the initiator know of any ALUA configuration changes, issue a
> periodic TUR.
> 
> multipathd does something similar for dm-multipath in terms of issuing
> a periodic read per path.
> 
> The purpose of the TUR is that the target can update UA info in the TUR
> response and the INI can handle it, but currently we don't for SCSI
> multipath.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_multipath.c | 36 +++++++++++++++++++++++++++++++++++
>   include/scsi/scsi_multipath.h |  1 +
>   2 files changed, 37 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 0c34b1151f5bf..2b916c7af4bd7 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -4,6 +4,7 @@
>    *
>    */
>   
> +#include <linux/kthread.h>
>   #include <scsi/scsi_alua.h>
>   #include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_driver.h>
> @@ -124,6 +125,7 @@ static void scsi_mpath_head_release(struct device *dev)
>   		container_of(dev, struct scsi_mpath_head, dev);
>   	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
>   
> +	WARN_ON_ONCE(kthread_stop(scsi_mpath_head->kua));
>   	scsi_mpath_delete_head(scsi_mpath_head);
>   	bioset_exit(&scsi_mpath_head->bio_pool);
>   	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
> @@ -514,6 +516,29 @@ struct mpath_head_template smpdt_pr = {
>   	.device_groups = mpath_device_groups,
>   };
>   
> +static void scsi_mpath_cb_ua_thread(struct mpath_device *mpath_device)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev =
> +			to_scsi_mpath_device(mpath_device);
> +
> +	if (alua_tur(scsi_mpath_dev->sdev))
> +		sdev_printk(KERN_NOTICE, scsi_mpath_dev->sdev,
> +			    "%s: No target port descriptors found\n",
> +			    __func__);
> +}
> +
> +static int scsi_mpath_ua_thread(void *data)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head = data;
> +
> +	while (!kthread_should_stop()) {
> +		mpath_call_for_all_devices(scsi_mpath_head->mpath_head,
> +			scsi_mpath_cb_ua_thread);
> +		msleep(5000);
> +	}
> +	return 0;
> +}
> +
>   static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
>   {
>   	struct scsi_mpath_head *scsi_mpath_head;
> @@ -548,6 +573,17 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
>   		goto out_free_ida;
>   	}
>   
> +	scsi_mpath_head->kua = kthread_create(scsi_mpath_ua_thread,
> +			scsi_mpath_head, "scsi-multipath-kua-%d",
> +			scsi_mpath_head->index);
> +	if (IS_ERR(scsi_mpath_head->kua)) {
> +		put_device(&scsi_mpath_head->dev);
> +		goto out_free_ida;
> +	}
> +
> +	set_user_nice(scsi_mpath_head->kua, 10);
> +	wake_up_process(scsi_mpath_head->kua);
> +
>   	return scsi_mpath_head;
>   
>   out_free_ida:
> diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
> index 7c7ee2fb7def7..d30f2c41e17de 100644
> --- a/include/scsi/scsi_multipath.h
> +++ b/include/scsi/scsi_multipath.h
> @@ -30,6 +30,7 @@ struct scsi_mpath_head {
>   	struct mpath_head	*mpath_head;
>   	struct device		dev;
>   	int			index;
> +	struct task_struct	*kua;
>   };
>   
>   struct scsi_mpath_device {

Please, don't. We should _not_ go into the business of doing TUR path 
checkers.
Path checkers turned out to be a major issue for multipathing, and
are mostly pointless for things like FC where you get reliable
path information via RSCNs.
Additionally I would advocate for scsi-multipath to be a _simple_
implementation, restricting to the most common scenarios. Namely
implicit ALUA only and reliable fabric notifications.
If you have anything else, fine, use dm-multipath.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
