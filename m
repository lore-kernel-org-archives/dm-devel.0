Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E09D1802D1
	for <dm-devel@lists.linux.dev>; Wed, 10 Apr 2024 18:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712775549; cv=none; b=av4Qp4wf+EzOR5JmrzYPEwtwdiqWsJqw9bIEKy1MCbpE2VFK84HAZ/4x8CtoQ1gxP78rzC9wxEJSaR+4gzU/0/DvWEiIJUZ77QSubdGyknqZOq9nGPf/UKW5QemhoJaDOH/rPeUpUxExPVHXCO41JucRmSckZqm4Gx7uDzrJ+Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712775549; c=relaxed/simple;
	bh=HcTvQPAA9NUPS2igJbqEH//WEl4aZTKvJGY0XkzAfiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZyOqnMtRK3P3yOA0PG1WvRwzb5F0aXhT+ozaDtymZGr/05ltVHHuCVkYiSawWu6zBe1P6zEU5MUkzcgrJRqt1Q568NmgjtmvXGV8csWvyUSnT6OHwVt3I2V81b71+T/LVS6zLIZw8gqLQJxN2YEjONhrs1ugjCG4Wo/ybBYX+Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BCnb2Uh6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BCnb2Uh6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712775547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XxpkuxUnIrOWR5YmuW0AIjNYXGEKvHqlxiu3ZzXtRNg=;
	b=BCnb2Uh6fMCJOejfHM8WLfYlscTvZuKzJiWVobfJv7cJVzxOuU9xRroooT0BKAQMEIlFXY
	172KNU43Q6Ivr8DsnqSE7PPIvXn5G2idDfYIEHs6GVPNU733P6NEN9kked83FvjDp/8xg+
	uv6pWy+/B+dPlDsOj5U0TlE8jlHKJu8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-aetmdrmwP5qwcXTE89KtwA-1; Wed, 10 Apr 2024 14:59:05 -0400
X-MC-Unique: aetmdrmwP5qwcXTE89KtwA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-69b1effbc16so32654506d6.0
        for <dm-devel@lists.linux.dev>; Wed, 10 Apr 2024 11:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712775545; x=1713380345;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XxpkuxUnIrOWR5YmuW0AIjNYXGEKvHqlxiu3ZzXtRNg=;
        b=pMFSHG17ZCYPWc+JVBOVmtiaSTApVoxk5nEMac8wckVW6AYUtSBiS8osS1lvRbiKzc
         vxWG1SZC7mHMkWYk7sqzatJ0Hrfi6n812K9eeU7TToxEb+W/gamg4MUdn+vUpiNJMOvA
         2jCsXMp4qtMArQxtCm2IDRenwjuSTlpLJxinR63dAN6QqaPmwBUY5gsUR065AH//mKW5
         quA9sQOpRXfqniwqduBAOryngJ9snFUqMXm+xpY4CLSQzHZHi+GYj6O1PbEjwt/Sv2+o
         W0Lbwbdet/seGLinU7Ri05oW7J0+1TPZPzjDsVFP8flNigvskdWm2OkqlPurl4/xnqNv
         hGEA==
X-Forwarded-Encrypted: i=1; AJvYcCWFxoe6QkjtwpNQ+oQjAuConfEPyyb6n0yGqi5HWwl3+Q4LMjs38QNmJYm/9+zU/mnYRhpwqIuU5pPWlKrYf7+pm+XfHM4b8Jo=
X-Gm-Message-State: AOJu0YzZhEs0fyeYlRrMMyh6HuYVmKy6CndAFH4bebf5oQXfRDBbSKn/
	vLQ3pRk8flbrWr7ZnONJTTwzIhFMwCNrR5ldw5ik9hPjG6oBF9yOOOTWY4Kno3GRmIYsaPUPZt7
	87dtDC6HhcSH7Cwt2ryT5wh0oD+JqUxfrJTuIJn+3ua/OPirM6rCQFyp9
X-Received: by 2002:a05:6214:4111:b0:69b:1efb:9d42 with SMTP id kc17-20020a056214411100b0069b1efb9d42mr3445946qvb.6.1712775545306;
        Wed, 10 Apr 2024 11:59:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1rZzHlFdlKErUaVzaIIBoz+uophffHDufiBosrVM2ScG6c79A0tsfU5q3lB5GUj4EtqyQxA==
X-Received: by 2002:a05:6214:4111:b0:69b:1efb:9d42 with SMTP id kc17-20020a056214411100b0069b1efb9d42mr3445922qvb.6.1712775544953;
        Wed, 10 Apr 2024 11:59:04 -0700 (PDT)
Received: from [192.168.1.165] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id p20-20020a05621415d400b00698d06df322sm5418657qvz.122.2024.04.10.11.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Apr 2024 11:59:04 -0700 (PDT)
Message-ID: <1e344d3b-1e30-6638-83c3-f743546374ec@redhat.com>
Date: Wed, 10 Apr 2024 14:59:03 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH vfs.all 19/26] dm-vdo: convert to use bdev_file
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, jack@suse.cz, hch@lst.de,
 brauner@kernel.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
 linux-block@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 yukuai3@huawei.com, dm-devel@lists.linux.dev
References: <20240406090930.2252838-1-yukuai1@huaweicloud.com>
 <20240406090930.2252838-20-yukuai1@huaweicloud.com>
 <a8493592-2a9b-ac14-f914-c747aa4455f3@redhat.com>
 <20240410174022.GF2118490@ZenIV>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20240410174022.GF2118490@ZenIV>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/10/24 13:40, Al Viro wrote:
> On Wed, Apr 10, 2024 at 01:26:47PM -0400, Matthew Sakai wrote:
> 
>>> 'dm_dev->bdev_file', it's ok to get inode from the file.
> 
> It can be done much easier, though -
> 
> [PATCH] dm-vdo: use bdev_nr_bytes(bdev) instead of i_size_read(bdev->bd_inode)
> 
> going to be faster, actually - shift is cheaper than dereference...

This does look simpler. And doing this means there's no reason to switch 
dm-vdo from using struct block_device * to using struct file *, so the 
rest of the original patch is unnecessary.

Reviewed-by: Matthew Sakai <msakai@redhat.com>

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
> index 5a4b0a927f56..b423bec6458b 100644
> --- a/drivers/md/dm-vdo/dm-vdo-target.c
> +++ b/drivers/md/dm-vdo/dm-vdo-target.c
> @@ -878,7 +878,7 @@ static int parse_device_config(int argc, char **argv, struct dm_target *ti,
>   	}
>   
>   	if (config->version == 0) {
> -		u64 device_size = i_size_read(config->owned_device->bdev->bd_inode);
> +		u64 device_size = bdev_nr_bytes(config->owned_device->bdev);
>   
>   		config->physical_blocks = device_size / VDO_BLOCK_SIZE;
>   	}
> @@ -1011,7 +1011,7 @@ static void vdo_status(struct dm_target *ti, status_type_t status_type,
>   
>   static block_count_t __must_check get_underlying_device_block_count(const struct vdo *vdo)
>   {
> -	return i_size_read(vdo_get_backing_device(vdo)->bd_inode) / VDO_BLOCK_SIZE;
> +	return bdev_nr_bytes(vdo_get_backing_device(vdo)) / VDO_BLOCK_SIZE;
>   }
>   
>   static int __must_check process_vdo_message_locked(struct vdo *vdo, unsigned int argc,
> diff --git a/drivers/md/dm-vdo/indexer/io-factory.c b/drivers/md/dm-vdo/indexer/io-factory.c
> index 515765d35794..1bee9d63dc0a 100644
> --- a/drivers/md/dm-vdo/indexer/io-factory.c
> +++ b/drivers/md/dm-vdo/indexer/io-factory.c
> @@ -90,7 +90,7 @@ void uds_put_io_factory(struct io_factory *factory)
>   
>   size_t uds_get_writable_size(struct io_factory *factory)
>   {
> -	return i_size_read(factory->bdev->bd_inode);
> +	return bdev_nr_bytes(factory->bdev);
>   }
>   
>   /* Create a struct dm_bufio_client for an index region starting at offset. */
> 

