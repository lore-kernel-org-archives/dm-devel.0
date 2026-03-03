Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E4538642A
	for <dm-devel@lists.linux.dev>; Tue,  3 Mar 2026 07:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522012; cv=none; b=ff0er+p61jii/qfziNhLvLaaJr0IlyxVfGh1eQ5i58GEWSl09WNgzyumNbthb46Gv8Jjokn+fY1R1s2IfRKs35ir+W9kdUkDvzsU2J/Rx//SE+tgQaxeIuJtkzexMDNnM/F0sQ0VArT5dhIL/eXFfuB2jJ2WdtcQgZ/7S4f3KPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522012; c=relaxed/simple;
	bh=vXeb1YMngigtTKDZStvPTDAGb3cr/q40OIJPzfwTusI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UkGORIpHlwU0anu6qSnObl8RRtif82RgQyIPF/aYJzqClVxVTWO/fsjffMyloyxbiEzfSvbPoFoQuP5Fcvz2tf91MpMx0zNg2OgyVvY1fbOF7FYvRvy1DNAIJ9DwovsjkMDV2hsGDL+QB2PjBTQTwxGRxa78i1MU1eJXlj/KzMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AVKxJEdV; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AVKxJEdV"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48374014a77so63236205e9.3
        for <dm-devel@lists.linux.dev>; Mon, 02 Mar 2026 23:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772522009; x=1773126809; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+diqLHAbCu0YIrK7BmkSHmFnH/39tPbeAFxeHFPEiPU=;
        b=AVKxJEdVod8XZry2NcxZcAsz4s0yUFtYd03cHF7pUMqVeuJHqlm5/LGxaFk+9f0s/6
         kbOAaZr3cUw5DQECZZXY6BR9RUWD7rZU2H5aWSyynw9a9moVERptyZHol2q/+xVxPXmL
         Rjfmo9MHsLieWMdNUxcwDeh+lhGTk/SHgFc9hcRfB83x3Y5rQEcQ/VTHVUqgzIpOav8B
         bIuuwaVU6wuuekl42Pty0acDOG4yXkpFhCQ3fBfbeD1PUhvEDHRL2rWum+5sYJUaB19a
         RfMLZRCInnGucZY2Boc7c5d6Qz7c5bm+Do3XoIXrO5OBXftNCfgV7Ux2Z1gYpeMdi0vj
         HOqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772522009; x=1773126809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+diqLHAbCu0YIrK7BmkSHmFnH/39tPbeAFxeHFPEiPU=;
        b=GnkB1oRJPcgvMMeo+T4wcjioFNk+knNupLt1TOSAwccIB8b/fkLHSAZGgPNgjMe+lh
         /iD7vsesS5CatvVQv0ZaBFmg/TRg/RKbNDGfySNQC9s12REUyUMcGpK36bKhjVbjmw7m
         FUnhJDAB/l0BNGsOR2hwxCUfO0XJ22KBKvp4NAgpvbKh5ftdXVBlSpieJOTOocKlw3Kd
         hbWyMFdyPhZt53Ns01UdBTeD4qsjSm1iim59e4iKhXVSbplb0Xf5UAPUoiKYpxxSnpS9
         g/nKUx++XNKp9Dt7ZfSr0XWavBzjJ5w/ti4Xwun9RWpshwFegkFPm5rhQIc9tZDAsTDf
         +VuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFSRBfzWXbSTPOJTFgIGfoR3yctggxkG81hC761WHERS8UVdrgkP2mdh6jLI0cNDGFuC5Gk3APtA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxy1lIBwAkcfdsHbjPi8vS/y/42/8JIPh/VK57IEBkMrCRW465N
	nfuRiBxhllIghn/4NYtriPTHl1aJGLEhMkbDIWxYTahIelebQCy63PV8ujlVFdQHxqo=
X-Gm-Gg: ATEYQzyEp1+6F3Jow0QSBTTUNG46VhwvlBFoF1Q8H+cPJj8Y5CGY83hDWlDTfHYWkX7
	4DBaeFutoP+zWVERS7c1wMyHfUpb4pd4gft/IdZBm9cHDbF2YAFZXogywS/9NgzAkIcgfvxneKi
	zlIjARvHRYw2+SSAscDiwgwsbyT7BJ8AHYCloqN4d5JiuPuQUnYxXdvMtqu1OyNWtOV0ZWl2N0r
	46POWNZWdo0ZZcLOhilv9CtE9T3vCeU/TI49CtsMYQsoxmd4p3EEeI4ngoGrYqWLeeapfD2J04o
	RAvX4QLqXxtIKQG1WlOMJiLG1LfMI8f3/D7CA1O5VOZZSpmQz4zu3NUfujBakoafH3rr+bmNeJu
	SrcmaukQxqOnmmjvMm8Vqphy6+gy+lf53PISpqTwxqIx24fR4hdXBu3SiyoO/LjOR9HsLvM+NP/
	nW7V31RmSJv+gFPUDW12KPHn46AxL1zrFLDa+y5uN9Oc0ghdNl5wokWaM78RcY5qejbw==
X-Received: by 2002:a05:600c:4592:b0:480:6999:27ec with SMTP id 5b1f17b1804b1-483c9bc03b1mr291390865e9.13.1772522009331;
        Mon, 02 Mar 2026 23:13:29 -0800 (PST)
Received: from [192.168.178.47] (aftr-82-135-83-117.dynamic.mnet-online.de. [82.135.83.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48512628e2asm22510605e9.1.2026.03.02.23.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 23:13:28 -0800 (PST)
Message-ID: <0809867c-796a-4bf1-a868-7ec64504723d@suse.com>
Date: Tue, 3 Mar 2026 08:13:27 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/24] scsi-multipath: introduce scsi_device head
 structure
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-4-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260225153627.1032500-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/25/26 16:36, John Garry wrote:
> Introduce a scsi_device head structure - scsi_mpath_head - to manage
> multipathing for a scsi_device. This is similar to nvme_ns_head structure.
> 
> There is no reference in scsi_mpath_head to any disk, as this would be
> mananged by the scsi_disk driver.
> 
> A list of scsi_mpath_head structures is managed to lookup for matching
> multipathed scsi_device's. Matching is done through the scsi_device
> unique id.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi_multipath.c | 147 ++++++++++++++++++++++++++++++++++
>   drivers/scsi/scsi_sysfs.c     |   3 +
>   include/scsi/scsi_multipath.h |  29 +++++++
>   3 files changed, 179 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 04e0bad3d9204..49316269fad8e 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -16,6 +16,10 @@
>   bool scsi_multipath;
>   static bool scsi_multipath_always;
>   
> +static LIST_HEAD(scsi_mpath_heads_list);
> +static DEFINE_MUTEX(scsi_mpath_heads_lock);
> +static DEFINE_IDA(scsi_multipath_dev_ida);
> +
>   static int multipath_param_set(const char *val, const struct kernel_param *kp)
>   {
>   	int ret;
> @@ -99,6 +103,73 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>   	return 0;
>   }
>   
> +struct mpath_head_template smpdt_pr = {
> +};
> +
> +static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head;
> +	int ret;
> +
> +	scsi_mpath_head = kzalloc(sizeof(*scsi_mpath_head), GFP_KERNEL);
> +	if (!scsi_mpath_head)
> +		return NULL;
> +
> +	ida_init(&scsi_mpath_head->ida);
> +	mutex_init(&scsi_mpath_head->lock);
> +
> +	scsi_mpath_head->mpath_head = mpath_alloc_head();
> +	if (IS_ERR(scsi_mpath_head->mpath_head))
> +		goto out_free;
> +	scsi_mpath_head->mpath_head->mpdt = &smpdt_pr;

mpdt?
What's that supposed to mean?
Seems to be like a persistent reservation thing, so why don't
you introduce it together with PR suppoer?

> +	scsi_mpath_head->mpath_head->drvdata = scsi_mpath_head;
> +
> +	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
> +	if (scsi_mpath_head->index < 0)
> +		goto out_put_head;
> +
> +	device_initialize(&scsi_mpath_head->dev);
> +	ret = dev_set_name(&scsi_mpath_head->dev, "%d", scsi_mpath_head->index);

Huh? The name is just the number? So we will have a device
/sys/devices/virtual/1 ?

The sysfs registration looks decidedly odd.
I guess we should add a scsi multipath class to sort the devices under.

> +	if (ret) {
> +		put_device(&scsi_mpath_head->dev);
> +		goto out_free_ida;
> +	}
> +
> +	return scsi_mpath_head;
> +
> +out_free_ida:
> +	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
> +out_put_head:
> +	mpath_put_head(scsi_mpath_head->mpath_head);
> +out_free:
> +	kfree(scsi_mpath_head);
> +	return NULL;
> +}
> +
> +static struct scsi_mpath_head *scsi_mpath_find_head(
> +			struct scsi_mpath_device *scsi_mpath_dev)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head;
> +	int ret;
> +
> +	mutex_lock(&scsi_mpath_heads_lock);
> +	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
> +		ret = scsi_mpath_get_head(scsi_mpath_head);
> +		if (ret)
> +			continue;
> +		if (strncmp(scsi_mpath_head->wwid,
> +			scsi_mpath_dev->device_id_str,
> +			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
> +
> +			mutex_unlock(&scsi_mpath_heads_lock);
> +			return scsi_mpath_head;
> +		}
> +		scsi_mpath_put_head(scsi_mpath_head);
> +	}
> +
> +	return NULL;
> +}
> +
>   static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
>   {
>   	kfree(sdev->scsi_mpath_dev);
> @@ -107,6 +178,7 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
>   
>   int scsi_mpath_dev_alloc(struct scsi_device *sdev)
>   {
> +	struct scsi_mpath_head *scsi_mpath_head;
>   	int ret;
>   
>   	if (!scsi_multipath)
> @@ -127,13 +199,75 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
>   		goto out_uninit;
>   	}
>   
> +	scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
> +	if (scsi_mpath_head)
> +		goto found;
> +	/* scsi_mpath_disks_list lock held */
> +	scsi_mpath_head = scsi_mpath_alloc_head();
> +	if (!scsi_mpath_head)
> +		goto out_uninit;
> +
> +	strcpy(scsi_mpath_head->wwid, sdev->scsi_mpath_dev->device_id_str);
> +

Do we have a sysfs attribute for this?

> +	ret = device_add(&scsi_mpath_head->dev);
> +	if (ret)
> +		goto out_put_head;
> +
> +	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
> +
> +	mutex_unlock(&scsi_mpath_heads_lock);
> +	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
> +
> +found:
> +	sdev->scsi_mpath_dev->index = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
> +	if (sdev->scsi_mpath_dev->index < 0) {
> +		ret = sdev->scsi_mpath_dev->index;
> +		goto out_put_head;
> +	}
> +
> +	mutex_lock(&scsi_mpath_head->lock);
> +	scsi_mpath_head->dev_count++;
> +	mutex_unlock(&scsi_mpath_head->lock);
> +
> +	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
>   	return 0;
>   
> +out_put_head:
> +	scsi_mpath_put_head(scsi_mpath_head);
>   out_uninit:
> +	mutex_unlock(&scsi_mpath_heads_lock);
>   	scsi_multipath_sdev_uninit(sdev);
>   	return ret;
>   }
>   
> +static void scsi_mpath_remove_head(struct scsi_mpath_device *scsi_mpath_dev)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head =
> +			scsi_mpath_dev->scsi_mpath_head;
> +	bool last_path = false;
> +
> +	mutex_lock(&scsi_mpath_head->lock);
> +	scsi_mpath_head->dev_count--;
> +	if (scsi_mpath_head->dev_count == 0)
> +		last_path = true;
> +	mutex_unlock(&scsi_mpath_head->lock);
> +
> +	if (last_path)
> +		device_del(&scsi_mpath_head->dev);
> +
> +	scsi_mpath_dev->scsi_mpath_head = NULL;
> +	scsi_mpath_put_head(scsi_mpath_head);
> +}
> +
> +void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
> +
> +	ida_free(&scsi_mpath_head->ida, scsi_mpath_dev->index);
> +
> +	scsi_mpath_remove_head(scsi_mpath_dev);
> +}
> +
>   void scsi_mpath_dev_release(struct scsi_device *sdev)
>   {
>   	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
> @@ -142,8 +276,21 @@ void scsi_mpath_dev_release(struct scsi_device *sdev)
>   		return;
>   
>   	scsi_multipath_sdev_uninit(sdev);
> +}
> +
> +int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
> +{
> +	if (!get_device(&scsi_mpath_head->dev))
> +		return -ENXIO;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(scsi_mpath_get_head);
>   
> +void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
> +{
> +	put_device(&scsi_mpath_head->dev);
>   }
> +EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
>   
>   int __init scsi_multipath_init(void)
>   {
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 0d69e27600a7a..287a683e89ae5 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1447,6 +1447,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
>   	} else
>   		put_device(&sdev->sdev_dev);
>   
> +	if (sdev->scsi_mpath_dev)
> +		scsi_mpath_remove_device(sdev->scsi_mpath_dev);
> +
>   	/*
>   	 * Stop accepting new requests and wait until all queuecommand() and
>   	 * scsi_run_queue() invocations have finished before tearing down the
> diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
> index ca00ea10cd5db..38953b05a44dc 100644
> --- a/include/scsi/scsi_multipath.h
> +++ b/include/scsi/scsi_multipath.h
> @@ -19,9 +19,22 @@
>   #ifdef CONFIG_SCSI_MULTIPATH
>   #define SCSI_MPATH_DEVICE_ID_LEN 40
>   
> +struct scsi_mpath_head {
> +	char			wwid[SCSI_MPATH_DEVICE_ID_LEN];

Don't name it WWID. That's an ATA thing. Make it vpd_id.

> +	struct list_head	entry;
> +	int			dev_count;
> +	struct ida		ida;
> +	struct mutex		lock;
> +	struct mpath_head	*mpath_head;
> +	struct device		dev;
> +	int			index;
> +};
> +
>   struct scsi_mpath_device {
>   	struct mpath_device	mpath_device;
>   	struct scsi_device 	*sdev;
> +	int			index;
> +	struct scsi_mpath_head	*scsi_mpath_head;
>   
>   	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
>   };
> @@ -32,8 +45,13 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
>   void scsi_mpath_dev_release(struct scsi_device *sdev);
>   int scsi_multipath_init(void);
>   void scsi_multipath_exit(void);
> +void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
> +int scsi_mpath_get_head(struct scsi_mpath_head *);
> +void scsi_mpath_put_head(struct scsi_mpath_head *);
>   #else /* CONFIG_SCSI_MULTIPATH */
>   
> +struct scsi_mpath_head {
> +};
>   struct scsi_mpath_device {
>   };
>   
> @@ -51,5 +69,16 @@ static inline int scsi_multipath_init(void)
>   static inline void scsi_multipath_exit(void)
>   {
>   }
> +static inline void scsi_mpath_remove_device(struct scsi_mpath_device
> +					*scsi_mpath_dev)
> +{
> +}
> +static inline int scsi_mpath_get_head(struct scsi_mpath_head *)
> +{
> +	return 0;
> +}
> +static inline void scsi_mpath_put_head(struct scsi_mpath_head *)
> +{
> +}
>   #endif /* CONFIG_SCSI_MULTIPATH */
>   #endif /* _SCSI_SCSI_MULTIPATH_H */

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
