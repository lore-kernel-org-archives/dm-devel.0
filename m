Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022347;
	b=4Fq9g8M8hO1c/F7j6kH/781oIynIUCNhG7GMBQSlSlDmSlrQ9Yj5lqAI/LEX6r8z46KX
	 iCyr1U7lqgABeSaz3KCcBcqPQpRxhEe15OsRSQh3C4gSnX56EhQK2B8xzmZURXq42UZ8i
	 tipExR/RKmhNZRc6qUcROjvzNAWUIJK91+INfz2Kbwjzp5Z7c2litPWrjjVyexufKd7E3
	 IiwNhO5OR5zhC8rVrXv03UbE7M+seBv+EFdwPF38a7bDrSI7ogulp5VMKXv02srbGgXLz
	 jzJM/HZ9UEIQ0aJ7yZyRUG86/oZEHP+XG39Cf+mcITKVf90HC7Leg3skZSmRA1EwKGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022347;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zg2I7WlJIl86j16qVhIvQflfzsU/mPaZKmCcIK8MOlk=;
	b=zJpGsMM+qPvWbLj6wGkD92OA5tWbUHkqpETWBGkN9Hu+6SgzKULGd1KcQbyMLV7GkaVn
	 W6ffKdu9AOgOEEIyCvnUFwRseo5cn3pB36ff9t8R5FBEyG53Rnn9Sn9fJPSHZtUS0x+R+
	 LM/wmI22N1hv9DwCo5X4OTCHdNVjo7rf4MJXPKwRvJQj9NJluxxzJc2OIHtkYgo/+Y3//
	 mOq31mCr9n+3Ct9Rl9jqqAWu7A7KJEgU/zNDFAwtXHjuPatCPJF69ggJUclReKroXAIi3
	 fBfsn2YhPdaL8UPLb9PX3CY3elFu02REoNQQS/epbGnWKPPEee3F7+nnRpVm+jsiI2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xjpZLlwM;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B62C606A320
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 17:19:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B62C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xjpZLlwM
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2efd659464fso5160035ad.2
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 09:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795022346; x=1795627146; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zg2I7WlJIl86j16qVhIvQflfzsU/mPaZKmCcIK8MOlk=;
        b=xjpZLlwMbbR9DE8Xm1XUzPRhTGrtbFDfuvTGwmN5sMwzVUkn/VruCunu8TWzbD/UA8
         +20NG2TaBX6QuBYbMxakUxLlvl6SOAU5CCx7oyRSQkoCNETwsL/xZD1LT+Nknheo2sFc
         zFMGDoj/YVmgPDHQ5NpsPLjarnu7PTtHJPknYWLfg1tN97DmbIuUUUy9Nxk3XXAzmscZ
         zVxeqISRMTvUEUekHkKSZDenQksHCecV0TDC1Zlt/nbUKJzkU3cqiO+tvZYSFz3TMXBP
         QC1kymHqBw16VWN/VXX5acOyFHgmM5xHFib1QQqd6J+P6ttjBMOiLOVPn2j1XuJwq6Ud
         GPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795022346; x=1795627146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zg2I7WlJIl86j16qVhIvQflfzsU/mPaZKmCcIK8MOlk=;
        b=LLy6R49nttwq1CtSl723a42YZkuzVYIgnggJ2i/fSnjzSSDQYLzUdgy8uisNDBy38a
         +R6SvcCn94TpyiCgVgaPP6DOgMFDOXVDChfiDRDKTLjuVsHE/RmjgDowBNMi9NdgADO0
         TbaLqKmuLGO28uHPxKWSaJ1/dOKb132Wa1NmP7hESJP1Dbqce4/BBpHWzcWrptknHx6+
         UvEk9e/rUXpvEOBSAtZOvzhkcLT8wZ6qBOSNxFgnARjS5Hvw0KxVakY7zcGOpuWZDRg8
         n0xvXID7NCmhvzZi7YtjwmJ7MnfKLORUfAWgM9MFjl5AZtp3s/Luddz2ClN6gDXByTkU
         Cxqw==
X-Forwarded-Encrypted: i=1; AL+hErGmwQdswSkjMnmVgpiuq7Dd5VHjTFUpXvkVU/GHgDHH25WVD3RAe/BqUoQjkvzBfMYhAm7y0kXaSQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z8fkrCq/nn7z5/HJ2lR0WFpyHeBGddMYqyla5ty5UnUmefshldN
	Q7oCZsy9LiWZ0d7+RsFOWifp8/seqQGCT4UjvHEWdwEBPworJ1/3SudO
X-Gm-Gg: AZFdTZcsfqrZW0FZ4Lb/c3/XodW6oznID1lONmKyKCqs5ig2ZQ07WgO6aTkN22HIU/h
	f3kmsPLpAXoVdl+EYMKzr4B3PkYOu9If605o8FAU6mUEyz/ne/UtesaoPdd5lWcPjSpnbpJV0vK
	pMpn8yBUwFMqZI6SQQP6+eG91M3NOhx+PQa9fBTrFuJ+kPZX6RtzoloQmIpr6rmnICkTnhLl8X1
	lN4dpuUwQXzLACRgKPTLXeVexxLb6nfxg1NWWw7OqSe3+ycCbcyGxWuFR9Fd0suX9+Tb0cy2/hK
	ADhg/R7w9pkSnEegB7mHi7Qp6ZJ6EbaC/jqBcKhE70OFBqIMto+Z1nzy86iTeveuflrxyx0OIUl
	wXyPWPj2AKadySjpqItd2ZpFQfi34gnv7izEd6wpiYSYhElQTRzRUBYA6KksrmWxzwZHTXbmHj2
	LA4cnKmPxshycp+5TCxTP6oMO5HhBihyRs8IcduNG7dYqv8FteBFq7oBCTD58E+KF6kxQ20IzO2
	bhcDWcfRXtq3oXSU7gXe7pnzymzkkGRdqipRi/64XucKLPjMRy3NT2qinS8K62bAIpsDAPwjaMi
	urtTJLC3Xs+ru29AZ/8ILZlx5kIhzAqophN87nWaIWmhEKvhWsjOYn7njOTP9qRYA5Y+g2uF+e/
	81Boz20Ff
X-Received: by 2002:a17:902:f792:b0:2ed:3d74:b63d with SMTP id d9443c01a7336-2eff71f7453mr32858195ad.4.1795022346236;
        Wed, 18 Nov 2026 09:19:06 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6182330sm16810085ad.36.2026.11.18.09.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:19:05 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: sashiko-bot@kernel.org
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH 3/4] dm-verity: size the hash retain target from the hash area
Date: Thu, 19 Nov 2026 01:19:01 +0800
Message-ID: <20261118171901.686164-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-218898@kernel.org>
References: <sashiko-outbox-218898@kernel.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Subject: Re: [PATCH 3/4] dm-verity: size the hash retain target from the hash area
In-Reply-To: <sashiko-outbox-218898@kernel.org>

On Tue, 17 Nov 2026 at 01:44:55PM +0000, sashiko-bot@kernel.org wrote:


> > diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> > index 6d589867623c0..d4fb06cb4e7ea 100644
> > --- a/drivers/md/dm-verity-target.c
> > +++ b/drivers/md/dm-verity-target.c
> > @@ -32,6 +32,8 @@
> >  #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
> >  #define DM_VERITY_USE_BH_DEFAULT_BYTES	8192
> >  
> > +#define DM_VERITY_DEFAULT_HASH_RETAIN_PERCENT	10
> > +
> >  #define DM_VERITY_MAX_CORRUPTED_ERRS	100
> >  
> >  #define DM_VERITY_OPT_LOGGING		"ignore_corruption"
> > @@ -50,6 +52,13 @@ static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE
> >  
> >  module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
> >  
> > +/* Default fraction of the hash tree that dm-bufio is asked to keep cached. */
> > +static unsigned int dm_verity_hash_retain_percent = DM_VERITY_DEFAULT_HASH_RETAIN_PERCENT;
> > +
> > +module_param_named(hash_retain_percent, dm_verity_hash_retain_percent, uint, 0644);
> > +MODULE_PARM_DESC(hash_retain_percent,
> > +	"Percentage of the hash area to keep cached by default");
> [Severity: Low]
> Since Documentation/admin-guide/kernel-parameters.txt already documents
> dm_verity.keyring_unsealed=, should dm_verity.hash_retain_percent= be added
> there as well?

Will be done in v2.


> > @@ -1083,6 +1092,9 @@ static void verity_dtr(struct dm_target *ti)
> >  
> >  	verity_fec_dtr(v);
> >  
> > +	if (v->bufio_kobj)
> > +		kobject_put(v->bufio_kobj);
> > +
> [Severity: Medium]
> Can exposing v->fec->data_bufio in sysfs cause a use-after-free of
> v->data_dev->bdev during teardown?
> verity_dtr() calls dm_put_device(ti, v->data_dev) before verity_fec_dtr(v)
> destroys and unregisters f->data_bufio:
> drivers/md/dm-verity-target.c:verity_dtr() {
>     ...
> 	if (v->data_dev)
> 		dm_put_device(ti, v->data_dev);
> 	verity_fec_dtr(v);
>     ...
> }
> v->fec->data_bufio is created on v->data_dev->bdev, and
> dm_bufio_client_create() stores c->bdev without taking its own reference.
> When FEC uses a separate device from data_dev, dm_put_device(ti, v->data_dev)
> closes the underlying block device while /sys/block/dm-N/dm-bufio/fec-data is
> still registered in sysfs, so a concurrent read of the bdev or bdev_name
> attribute in dm_bufio_attr_show() can dereference c->bdev after it has been
> released:
> CPU0                                  CPU1
> verity_dtr()
>   dm_put_device(ti, v->data_dev)
>                                       dm_bufio_attr_show()
>                                         sysfs_emit(buf, "%pg\n", c->bdev)
>                                           <-- use-after-free
>   verity_fec_dtr(v)
>     dm_bufio_client_destroy(f->data_bufio)
> Calling verity_fec_dtr(v) before releasing v->data_dev and v->hash_dev would
> ensure the FEC bufio clients are unregistered before their backing devices
> are put.

Will be fixed in v2 exactly this way: verity_dtr() will call
verity_fec_dtr() before dm_put_device() of the hash and data devices,
so the FEC bufio clients (and their sysfs entries) are gone before the
bdev is released.


> [ ... ]
>
> > @@ -1629,6 +1642,13 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >  		goto bad;
> >  	}
> >  
> > +	hash_retain_percent = READ_ONCE(dm_verity_hash_retain_percent);
> > +	if (hash_retain_percent <= 100)
> > +		dm_bufio_set_retain_bytes(v->bufio,
> > +			mult_frac((u64)(v->hash_end - v->hash_start) <<
> > +				  v->hash_dev_block_bits,
> > +				  hash_retain_percent, 100));
> > +
> [Severity: High]
> Does passing a u64 expression to mult_frac() break 32-bit builds and silently
> truncate the retain target above ULONG_MAX?
> mult_frac(x, n, d) declares its internal variables with typeof(x) and expands
> to raw '/' and '%' operations, which emit __udivdi3 and __umoddi3 libcalls on
> 32-bit architectures when x is u64 and n is a runtime variable.  In addition,
> dm_bufio_set_retain_bytes() takes an unsigned long, so on 32-bit kernels a
> u64 result at or above 4 GiB is truncated modulo 2^32 (and if truncated to 0,
> resets retain_bytes to the global default).  Using mul_u64_u32_div() and
> min_t(u64, ..., ULONG_MAX) would avoid both problems.

The build claim is a false positive: 64-bit division links fine on
32-bit, the kernel provides those libcalls.  The truncation is real
though, so v2 will compute the percentage with mul_u64_u32_div() and
clamp the result at ULONG_MAX -- the same way dm-bufio sizes its own
cache -- so a large area cannot truncate to near-zero on 32-bit.


> > @@ -1806,6 +1826,45 @@ static void verity_postsuspend(struct dm_target *ti)
> >  	verity_security_clear_integrity(ti);
> >  }
> >  
> > +/*
> > + * Publish the bufio clients under /sys/block/dm-N/dm-bufio/.  Runs from
> > + * ->resume because the dm device's block device does not exist in ->ctr.
> > + */
> > +static void verity_register_bufio_sysfs(struct dm_verity *v)
> > +{
> > +	struct mapped_device *md = dm_table_get_md(v->ti->table);
> > +	struct kobject *parent;
> > +
> > +	if (v->bufio_kobj)
> > +		return;
> > +
> > +	parent = &disk_to_dev(dm_disk(md))->kobj;
> > +	/*
> > +	 * On a table reload the old table's directory is still there; it is
> > +	 * removed only after this resume returns.  We retry on the next one.
> > +	 */
> > +	v->bufio_kobj = kobject_create_and_add("dm-bufio", parent);
> > +	if (!v->bufio_kobj) {
> > +		DMERR("cannot create dm-bufio sysfs directory, will retry on next resume");
> > +		return;
> > +	}
> [Severity: Medium]
> Does reloading a dm-verity table trigger a sysfs_warn_dup() stack trace and
> leave the device without a /sys/block/dm-N/dm-bufio directory?
> On table reload, do_resume() suspends the old table, swaps in the new table,
> and calls dm_resume(md) before calling dm_table_destroy(old_map):
> drivers/md/dm-ioctl.c:do_resume() {
>     ...
> 	if (dm_suspended_md(md)) {
> 		r = dm_resume(md);
>     ...
> 	}
>     ...
> 	if (old_map)
> 		dm_table_destroy(old_map);
>     ...
> }
> Because the old table's v->bufio_kobj is only freed in verity_dtr(),
> /sys/block/dm-N/dm-bufio still exists when verity_resume() runs on the new
> table.  kobject_create_and_add("dm-bufio", parent) hits -EEXIST in
> sysfs_create_dir_ns() and calls sysfs_warn_dup(), which logs a duplicate
> filename warning and a full dump_stack() backtrace.  Then
> dm_table_destroy(old_map) runs verity_dtr() on the old table and removes the
> directory, and since no second resume occurs, the reloaded table is left with
> v->bufio_kobj == NULL and no dm-bufio sysfs directory.
> Unregistering and freeing v->bufio_kobj (and removing the bufio clients from
> sysfs) in verity_postsuspend() would release the old table's directory before
> the new table's ->resume hook runs.

Same fix as in patch 2: ->presuspend detaches the directories and
frees the names, keeping the kobjects until the table is destroyed, so
the reloaded table publishes its directories synchronously from
->resume.  The ->postsuspend variant deadlocks against udev probing
the frozen device, which is what prompted the pre-freeze detach.


Thanks for the review,
Yongpeng
