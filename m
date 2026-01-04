Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A443A1E7F
	for <dm-devel@lists.linux.dev>; Sun,  4 Jan 2026 19:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767555490; cv=none; b=pGrfIZt2nYWyvKWLT9UJBa0xHZnDfnDKlQUmT3KaE8eBvTtqjhDW4IsveLp334BtjB9x0tp2X8odscz6FFb3Zdtu2Vo/e4Fxti8SKDXNxRIVpav08bznyEa/DJxdjjj5LxFJ4OoGyN/BIZDrLNKOSiuWb6nqw/ff6BW2qgUkjhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767555490; c=relaxed/simple;
	bh=FjPrdJ0DnKy34nfI1kQnwVbxhP/c+PMF0czbMq7E28k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=EHNIIwMZ/FxQr4CntIlrcyoJKiYwjsCubmL0sQwLaMcnAA9NU9IWfAV2dAkmBr6W/4146YsSnLR1z5jehc+FSysE7fCxTrhBPoZv/ZAINzrxzrv/FViq6OyAesHnunxNJHFtJ3gj+OMln7I0ZC0e3/AyT7t1J/3HSGfTKBnYtfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CfCTHDIt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CfCTHDIt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767555485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e4FQq9bgTO64JKvCK31u3/i9EX231rTKwrlrMLGEJSI=;
	b=CfCTHDItM3B/0VqdIV9YNJwQqM9VlsZcukNJkv7Gr0ut/rQhHyM2XHYmSurNJpVAgl/iy9
	QdwEsOJuCbtWx8mzb4c72pmctW8urqprTGdOGOOr1xhF04CaHfOjhB/z1SSABEd1QibMj4
	582LvUMsyEHQRoCeAyv+kyaIgW8dga0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-Hy4fXwHOMKCAd9p-Git3UQ-1; Sun,
 04 Jan 2026 14:38:02 -0500
X-MC-Unique: Hy4fXwHOMKCAd9p-Git3UQ-1
X-Mimecast-MFC-AGG-ID: Hy4fXwHOMKCAd9p-Git3UQ_1767555481
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F12011800669;
	Sun,  4 Jan 2026 19:37:59 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C80E419560AB;
	Sun,  4 Jan 2026 19:37:58 +0000 (UTC)
Date: Sun, 4 Jan 2026 20:37:53 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "jaeyuel.im" <jaeyuel.im@lge.com>
cc: dm-devel@lists.linux.dev
Subject: Re: [device-mapper-dm:for-next 6/15] drivers/md/dm-init.c:314:41:
 error: implicit declaration of function 'blkdev_get_no_open'; did you mean
 'blkdev_get_zone_info'?
In-Reply-To: <202601050152.9pJILlEG-lkp@intel.com>
Message-ID: <992a6ce0-c9aa-fe0b-68ad-d2f1f3fed8ab@redhat.com>
References: <202601050152.9pJILlEG-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3I1EhELVxxIw6YoxlCQHXZnUwZIeal6DWOpvFZbJm6k_1767555481
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

I reverted this patch.

Mikulas



On Mon, 5 Jan 2026, kernel test robot wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   89db2b980bb27a5ec625382f8fe7798f6ab10d01
> commit: 5cf739d81755e49c39a3bd3c8bf5ec57441710b5 [6/15] dm init: ensure block device is ready before creating mapped device
> config: sparc-randconfig-002-20260104 (https://download.01.org/0day-ci/archive/20260105/202601050152.9pJILlEG-lkp@intel.com/config)
> compiler: sparc-linux-gcc (GCC) 12.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260105/202601050152.9pJILlEG-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601050152.9pJILlEG-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/md/dm-init.c: In function 'dm_init_init':
> >> drivers/md/dm-init.c:314:41: error: implicit declaration of function 'blkdev_get_no_open'; did you mean 'blkdev_get_zone_info'? [-Werror=implicit-function-declaration]
>      314 |                         while (!(bdev = blkdev_get_no_open(dev, false)))
>          |                                         ^~~~~~~~~~~~~~~~~~
>          |                                         blkdev_get_zone_info
>    drivers/md/dm-init.c:314:39: warning: assignment to 'struct block_device *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
>      314 |                         while (!(bdev = blkdev_get_no_open(dev, false)))
>          |                                       ^
> >> drivers/md/dm-init.c:316:25: error: implicit declaration of function 'blkdev_put_no_open' [-Werror=implicit-function-declaration]
>      316 |                         blkdev_put_no_open(bdev);
>          |                         ^~~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
> 
> 
> vim +314 drivers/md/dm-init.c
> 
>    267	
>    268	/**
>    269	 * dm_init_init - parse "dm-mod.create=" argument and configure drivers
>    270	 */
>    271	static int __init dm_init_init(void)
>    272	{
>    273		struct dm_device *dev;
>    274		LIST_HEAD(devices);
>    275		char *str;
>    276		int i, r;
>    277	
>    278		if (!create)
>    279			return 0;
>    280	
>    281		if (strlen(create) >= DM_MAX_STR_SIZE) {
>    282			DMERR("Argument is too big. Limit is %d", DM_MAX_STR_SIZE);
>    283			return -EINVAL;
>    284		}
>    285		str = kstrndup(create, DM_MAX_STR_SIZE, GFP_KERNEL);
>    286		if (!str)
>    287			return -ENOMEM;
>    288	
>    289		r = dm_parse_devices(&devices, str);
>    290		if (r)
>    291			goto out;
>    292	
>    293		DMINFO("waiting for all devices to be available before creating mapped devices");
>    294		wait_for_device_probe();
>    295	
>    296		for (i = 0; i < ARRAY_SIZE(waitfor); i++) {
>    297			if (waitfor[i]) {
>    298				dev_t dev;
>    299				struct block_device *bdev;
>    300	
>    301				DMINFO("waiting for device %s ...", waitfor[i]);
>    302				while (early_lookup_bdev(waitfor[i], &dev))
>    303					fsleep(5000);
>    304	
>    305				/*
>    306				 * early_lookup_bdev() only checks if the device node exists and
>    307				 * returns the dev_t. It does not guarantee that the underlying
>    308				 * block device is fully initialized and ready to be opened. On
>    309				 * some platforms, this can lead to a race condition where
>    310				 * dm_early_create() fails because the device is not yet ready.
>    311				 * Ensure the block device is truly available by attempting to
>    312				 * get it.
>    313				 */
>  > 314				while (!(bdev = blkdev_get_no_open(dev, false)))
>    315					fsleep(5000);
>  > 316				blkdev_put_no_open(bdev);
>    317			}
>    318		}
>    319	
>    320		if (waitfor[0])
>    321			DMINFO("all devices available");
>    322	
>    323		list_for_each_entry(dev, &devices, list) {
>    324			if (dm_early_create(&dev->dmi, dev->table,
>    325					    dev->target_args_array))
>    326				break;
>    327		}
>    328	out:
>    329		kfree(str);
>    330		dm_setup_cleanup(&devices);
>    331		return r;
>    332	}
>    333	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 

