Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F61F156661
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 07:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765439661; cv=none; b=JauAb3DkHcgTWH6uydoUsX3wnMg2FCPndhSvi9139GMQegFkYRslIo4HaOHb42WDCN/BroWh4N9qpxMwk45t5tUCM1Omme0warYhKw/Zl+cg9sWHTxY4ET3925zalLRthxmLeZR2ktYIQYAHW5gL1lPuqdnllEvMVDNSf2ufGIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765439661; c=relaxed/simple;
	bh=AIQaUlm89sSpTZDPzr6t+G3NNUaBJzk1nskOjpZ/DH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FjJzkCWJ6P/BQozbNihQuFVPb6fyVfW3Fy9NmfDd82fDEHtFM5jNvjphqmuQAHq1x2xqVXCGESG7YOlhRCB5kjxiR1x+//CqxW6bPil+qUtsbfoQyJVxNpz5PrZpcoegP/LFkGyJI7bkStccGQjgGoBApq1PrvUnZQGfeOrwXkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rmosW7U5; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rmosW7U5"
Message-ID: <85b833aa-aa6d-4352-ac2c-08d988a55de3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765439656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xaN62d5sr5WjKNa60qe476D9yu9oBEkr6LF10Yd0LDw=;
	b=rmosW7U5KWq1SwtrI78xYjmryXe4Nps58H+nqOeAUbSZbXL7IjiR3MX5qrSkNXbS9+n7+c
	iheruHPZYrztxOiTzM7MY7oeXJQOytmTESDEI4wo/h2XPtDIoev0WOEU55R5OUO5KPsV8L
	9wKk4b3+/jFwuVFEbVvCJC62DCKLHjk=
Date: Thu, 11 Dec 2025 15:54:11 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] dm pcache: reject mappings larger than backing
To: Li Chen <me@linux.beauty>
Cc: dm-devel <dm-devel@lists.linux.dev>,
 linux-kernel <linux-kernel@vger.kernel.org>, Zheng Gu <cengku@gmail.com>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20251208112552.147756-1-me@linux.beauty>
 <562c7d90-7c8b-46ef-b01f-561d86c722b4@linux.dev>
 <19b0614ca46.65ed8ae3522798.9016216162556753318@linux.beauty>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <19b0614ca46.65ed8ae3522798.9016216162556753318@linux.beauty>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 12/10/2025 10:26 AM, Li Chen 写道:
> Hi Dongsheng,
>
> Thanks for your quick reply.
>   ---- On Mon, 08 Dec 2025 19:44:40 +0800  Dongsheng Yang <dongsheng.yang@linux.dev> wrote ---
>   >
>   > 在 12/8/2025 7:25 PM, Li Chen 写道:
>   > > Reject pcache targets whose logical size exceeds the backing device.
>   > > Prevent oversized tables from issuing IO past the end of the backing,
>   > > which may corrupt memory and cause kernel crash.
>   > >
>   > > Signed-off-by: Li Chen <me@linux.beauty>
>   > > ---
>   > >   drivers/md/dm-pcache/dm_pcache.c | 15 +++++++++++++++
>   > >   1 file changed, 15 insertions(+)
>   > >
>   > > diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/dm_pcache.c
>   > > index e5f5936fa6f0..f72d1ba4b740 100644
>   > > --- a/drivers/md/dm-pcache/dm_pcache.c
>   > > +++ b/drivers/md/dm-pcache/dm_pcache.c
>   > > @@ -199,6 +199,8 @@ static int parse_cache_opts(struct dm_pcache *pcache, struct dm_arg_set *as,
>   > >   static int pcache_start(struct dm_pcache *pcache, char **error)
>   > >   {
>   > >       int ret;
>   > > +    struct dm_target *ti = pcache->ti;
>   > > +    struct pcache_backing_dev *backing_dev;
>   > >
>   > >       ret = cache_dev_start(pcache);
>   > >       if (ret) {
>   > > @@ -212,6 +214,19 @@ static int pcache_start(struct dm_pcache *pcache, char **error)
>   > >           goto stop_cache;
>   > >       }
>   > >
>   > > +    /* Sanity-check: logical size must not exceed backing device size */
>   > > +    backing_dev = &pcache->backing_dev;
>   > > +    if (ti->len > backing_dev->dev_size) {
>   > > +        pcache_dev_err(
>   > > +            pcache,
>   > > +            "backing device too small: logical=%llu sectors, backing=%llu sectors",
>   > > +            (unsigned long long)ti->len,
>   > > +            (unsigned long long)backing_dev->dev_size);
>   > > +        *error = "Requested mapping exceeds backing device size";
>   > > +        ret = -EINVAL;
>   > > +        goto stop_backing;
>   > > +    }
>   > > +
>   >
>   >
>   > Thanx for your patch, When developing dm-pcache, I considered whether to
>   > add a check there (for target size vs backing device size). But after
>   > looking at other existing targets, it seems none of them implement such
>   > a check, so I wasn't sure there is a requirement; hence I didn't add it
>   > at that time.
>
>   I did a quick search and found some examples:
> https://github.com/torvalds/linux/blob/c9b47175e9131118e6f221cc8fb81397d62e7c91/drivers/md/dm-cache-target.c#L2117
> https://github.com/torvalds/linux/blob/c9b47175e9131118e6f221cc8fb81397d62e7c91/drivers/md/dm-verity-target.c#L1416
> https://github.com/torvalds/linux/blob/c9b47175e9131118e6f221cc8fb81397d62e7c91/drivers/md/dm-integrity.c#L5166
>
>   > On the other hand, given that the “target size” parameter in the mapping
>   > table is a generic parameter, if we want such a check, it would be
>   > better to implement a generic mechanism in the Device-Mapper core
>   > construction path — provide a hook that allows every target to return a
>   > “maximum creatable target size”, and then in the core path validate the
>   > user-provided target size against that max size before creation.
>   >
>   > That is just my personal idea; I hope Mikulas can provide more
>   > information about it.
>
> I just found a common helper called device_area_is_invalid check, already used within target_type->iterate_devices, validates target size.
> Therefore, targets implementing iterate_devices can perform size validation. I confirmed this with a quick test:
>
> modified   drivers/md/dm-pcache/dm_pcache.c
> @@ -446,6 +446,15 @@ static int dm_pcache_message(struct dm_target *ti, unsigned int argc,
>   	return -EINVAL;
>   }
>   
> +static int pcache_iterate_devices(struct dm_target *ti,
> +				  iterate_devices_callout_fn fn, void *data)
> +{
> +	struct dm_pcache *pcache = ti->private;
> +	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
> +
> +	return fn(ti, backing_dev->dm_dev, 0, ti->len, data);
> +}
> +
>   static struct target_type dm_pcache_target = {
>   	.name		= "pcache",
>   	.version	= {0, 1, 0},
> @@ -456,6 +465,7 @@ static struct target_type dm_pcache_target = {
>   	.map		= dm_pcache_map_bio,
>   	.status		= dm_pcache_status,
>   	.message	= dm_pcache_message,
> +	.iterate_devices = pcache_iterate_devices,
>   };
>   
>   static int __init dm_pcache_init(void)
>
> And it is rejected as expected too:
>
> ```
> root@localhost ~# dmsetup create pcache_vdb --table \
>                                                                                                "0 31457284 pcache /dev/pmem0 /dev/vdb 4 cache_mode writeback data_crc false"
> device-mapper: reload ioctl on pcache_vdb (253:0) failed: Invalid argument
> Complete cookie 0xd4d9a60 success.
> Complete cookie 0xd4d9a60 success.
> Command failed.
> root@localhost ~ [1]# dmesg | tail
> [    1.937147] EXT4-fs (vda2): re-mounted dc39223f-5278-4b19-80bc-de1edf4a5a96 r/w.
> [    1.941399] systemd-journald[166]: Received client request to flush runtime journal.
> [    2.051496] virtio_net virtio0 enp0s3: renamed from eth0
> [    2.253929] FAT-fs (vda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
> [    2.395796] tsc: Refined TSC clocksource calibration: 3792.905 MHz
> [    2.395834] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x6d585308801, max_idle_ns: 881590710907 ns
> [    2.396195] clocksource: Switched to clocksource tsc
> [  175.269911] device-mapper: table: 253:0: vdb too small for target: start=0, len=31457284, dev_size=31457280
> [  175.271582] device-mapper: core: Cannot calculate initial queue limits
> [  175.272688] device-mapper: ioctl: unable to set up device queue for new table.
> ```
>
> Which do you prefer: pcache_iterate_devices or checking in parse_cache_opts? Thanks.


iterate_devices() sounds not the proper place to do size checking. If there is no generic way to do size checking, I prefer to do it in parse_backing_dev() rather than pcache_iterate_devices.

Thanx


>
> Li​
>
>
