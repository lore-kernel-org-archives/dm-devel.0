Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022352;
	b=T+Tr2eCrnwe1JtwxceH/9lRhf1NwCn3BVf6PehaOCjY9UxLTRMDNKEuPP6pyT10nPeCI
	 4QStR9P6KV14neYixxTQSJMjQ9PTZ86yMdWEaIrqGrNzwYljWTGgtU1zWTGvQxC9TM2Cv
	 V/+45dm6RshCnTJwUcMZeWj3MfozyQOknBL4dkhJiZJpOeEVNkA4moftZw2BJkv5XLgd9
	 Yi7+Gk8sp988eJXWADaGF0LqIc4i3eQzZKxTIYjew1IgGt+eefj61ALaqXGQiX6uyrHJu
	 MrTsS/1x07eoWNvGcuejn0NzuVvh8xVXYdAffTWkqS/kQ3SrrT0/+JNFM/U3+A1RfqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022352;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bIURRZURf2VUjBygPjSL4g06Fd8DFi1lyXNz0C36Unw=;
	b=GMLln76f36NGQ5hvnkC01T4WF9Ir8wrZpYqayPWCeSTlguQQt56qOWTP7axwYT90G8BC
	 DTBhO6hv59Wj1h8Ls4ok/TMPNgY1oNUZQfcwj/hU2Tn+QLpiSpgbIdJDBado3E8DDNzRz
	 EfQNYU95jjmiby6s+2WvnsGodq64SsX7L7+DvVRQqjFwnjFCeBEk0+fbwKs0kG5dnIJ2+
	 VajZVJNIbV62/tZ6XPR9TwH4gqAvNtHdnA4Rdh9we72aJkl15r5d+A0zhgGXEV2Qiu94+
	 JCgLYByR9PDkquT8m9GZycw7A05+BgSfAAiAiRyeJQAEAMoWgFTSB3+oa8KXe8sVKHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="cZ/qP4pU";
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F05606A325
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 17:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7F05606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cZ/qP4pU
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cddac941ed1so547734a12.2
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 09:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795022351; x=1795627151; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bIURRZURf2VUjBygPjSL4g06Fd8DFi1lyXNz0C36Unw=;
        b=cZ/qP4pUNnYub1D+Orkcb5+A8QZ6kl+aGBB28gH6Z6b/qJk3LM2ruqLF0RafTVMM7M
         EpBACYCCjoWDLPglntp/uc0FBytet4d7wGkv0HVta5/GqowkE3kGy0P1HIbC8JbZrj/a
         2Br39NynNX4vYi3ct7/TTnBZBPNWBvB9fwpfhf4ABlsTFnEBCTY7ScetpHU0i2fWGhet
         zOeVHnBt+jN3x/q7QkJap19xkllWQ0or591/wjs6Bc23znEdxZ4w81WQLxDi1GUWWM63
         kSPtiRi4chJr7Lkp3J8CghUxfQuyd3z/TyXbl8jVMePtKdpDj9EEeEpqsPhTliQY3u4y
         ro7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795022351; x=1795627151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bIURRZURf2VUjBygPjSL4g06Fd8DFi1lyXNz0C36Unw=;
        b=xO2A7BTBrOQX3rL9zg7yHEd7KHFlcJEa4CH4aL1wqJNrLk5MU5FqF/w5vImkSb0rm2
         AI5KW1EpR/NCyxMxDYwhOtAuuozww7d8Z11hXh9/j+2mHbHkm0UJphvRHbWEjl+AYxrf
         f9LW6JQHoZDHdQCYGFpU2D0jWWc3shWq0fSpT/yKfyBxdqhRP2QVAkhJi3XhUVNUMIFf
         UAu80da7AAWvZYr6iOKoBvhOmQ9WzHfr1UnHc6DCtZXn9JqeYMqMvmfn1O+6P3j2bica
         abl8ldBHwFY9dYvNnGS1qCLrTz006umdHD0GtQxS+bOzQl0XkVkEk2Ny8JkaMDIMp+g+
         QZ0A==
X-Forwarded-Encrypted: i=1; AL+hErH5en1yaCe4ZcMHgCtQ92aZurVFcO8DNTXmGod+Kil66bW+TanBnyn8EYDw0uX5WsrFWEfve6DH/g==@lists.linux.dev
X-Gm-Message-State: APuU4Z8Zg50jOcqgOftC+PN8TzVvh6cdjJO/NPzuLBcOKAS8QMi/439j
	N1KtikZeuMo5qcFpDDPrm9XYfIqVCChpPZTgPxOVcmSkzPAs4K7fivOq
X-Gm-Gg: AZFdTZel+ndsHDOEciliMmEbih7NBaM4QGBsCBwIzt7GA6s2v4NKAluvMkTeIbPH2WE
	0LRdcHfQWpqReWOTZK76j3GYHu92t3vDCyDlb+r4WtlSCOam2VTA0mINCpMFfhPPj+VSjf/+Ps6
	jKKfJ2W4gkP3AnqI8gstcJ8PUOsqee/diNClRGXnOAmwC5eESxZIPPCm+KmnF2WHc6RhBkWASRP
	sDkZQu34lYTd2OXUFV0oa0KXhQ3NwyZvjdFZLfJCDJpujpEnvzRYQXfufXKdpDsfaseuRsM1wmn
	3mpBowiyxTihsLhFn2pmz4DUzqQ5umUB2hZhMgT+0OeSulV8CpdvOopiAoj7qMiHfk3a6N0pfDh
	/22NZkRjKZUSjT63B65vPHCAh5ts9yIyHls1FbOjZ5nkn8hu9shJbYhBp3EysJJ/tlsMS/xeRIv
	eisu28OfwGopQZH/z4//YjWL7JtYu7i79PlMv52piOgXbwZHxxZpEy+k7a10/0UzEZAkQsrFyXa
	0ckjIt4OFwhTPZ/uAdhJ7qha7MPnbYKwLCeUAzSPmejwKP9HjlZvQorPf+b2SbQd3ChLt1h4gPN
	BeUR620jOi6g+KbErcc0wl8S6ze8YbjwDSgC8VfGuCQwbMfzljS9SMkGHv5yfjc6DY6GBDhdF68
	KJcciBlhw
X-Received: by 2002:a17:90a:dfc8:b0:3b1:b66a:c05 with SMTP id 98e67ed59e1d1-3b3d0763174mr2908317a91.14.1795022350440;
        Wed, 18 Nov 2026 09:19:10 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3f6f498e7sm124234a91.7.2026.11.18.09.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:19:10 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: sashiko-bot@kernel.org
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH 4/4] dm-verity: add messages to inspect, prefetch and drop hash blocks
Date: Thu, 19 Nov 2026 01:19:06 +0800
Message-ID: <20261118171906.686218-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-218894@kernel.org>
References: <sashiko-outbox-218894@kernel.org>
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

Subject: Re: [PATCH 4/4] dm-verity: add messages to inspect, prefetch and drop hash blocks
In-Reply-To: <sashiko-outbox-218904@kernel.org>

On Tue, 17 Nov 2026 at 01:49:07PM +0000, sashiko-bot@kernel.org wrote:


> > diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
> > index 9e9d4b8157c03..8fea6130765bb 100644
> > --- a/Documentation/admin-guide/device-mapper/verity.rst
> > +++ b/Documentation/admin-guide/device-mapper/verity.rst
> > @@ -328,6 +328,48 @@ Status
> >  2. Number of corrected blocks by Forward Error Correction.
> >     '-' if Forward Error Correction is not enabled.
> >  
> > +Metadata caching
> > +================
> > +
> > +The hash blocks, and the FEC parity blocks when FEC is enabled, are cached in
> > +memory by dm-bufio.  How much of the hash tree is kept cached is controlled by
> > +the ``hash_retain_percent`` module parameter (default 10), settable at boot
> > +time with ``dm_verity.hash_retain_percent=<0-100>`` or at run time through
> > +``/sys/module/dm_verity/parameters/hash_retain_percent``.  A value of 0 or
> > +above 100 leaves the dm-bufio default (256 KiB), which is also what the FEC
> > +clients keep.  Only devices created afterwards are affected.
> [Severity: High]
> Does the hash_retain_percent calculation in verity_ctr() from commit
> "dm-verity: size the hash retain target from the hash area" fail to link on
> 32-bit architectures and truncate retain sizes at or above 4 GiB?
> drivers/md/dm-verity-target.c:verity_ctr() {
>     ...
> 	hash_retain_percent = READ_ONCE(dm_verity_hash_retain_percent);
> 	if (hash_retain_percent <= 100)
> 		dm_bufio_set_retain_bytes(v->bufio,
> 			mult_frac((u64)(v->hash_end - v->hash_start) <<
> 				  v->hash_dev_block_bits,
> 				  hash_retain_percent, 100));
>     ...
> }
> mult_frac(x, n, d) uses typeof(x) and plain C '/' and '%' operators, so
> passing a u64 first argument emits __udivdi3 and __umoddi3 calls on 32-bit
> builds.  In addition, dm_bufio_set_retain_bytes() takes an unsigned long, so
> a 64-bit byte count at or above 4 GiB wraps modulo 2^32 on 32-bit systems
> unless clamped to ULONG_MAX.

Same answer as in patch 3: the link failure is a false positive
(__udivdi3 exists everywhere), but the truncation is real, and v2 will
compute the percentage with mul_u64_u32_div() and clamp the result at
ULONG_MAX, as dm-bufio does for its own cache sizing.


> > +
> > +Each client's retain target and memory use are visible under
> > +``/sys/block/dm-N/dm-bufio/<hash|fec|fec-data>/`` on the verity device's own
> > +block device, and the target can be changed by writing that directory's
> > +``retain_bytes`` attribute; see
> > +Documentation/admin-guide/device-mapper/dm-bufio.rst.  The directories appear
> [Severity: Medium]
> Can exposing v->fec->data_bufio under fec-data in commit "dm-verity: size
> the hash retain target from the hash area" cause a use-after-free on
> c->bdev during verity_dtr()?
> drivers/md/dm-verity-target.c:verity_dtr() {
>     ...
> 	if (v->data_dev)
> 		dm_put_device(ti, v->data_dev);
> 	verity_fec_dtr(v);
>     ...
> }
> v->fec->data_bufio stores a raw pointer to v->data_dev->bdev, which
> dm_bufio_attr_show() dereferences when reading fec-data/bdev or
> fec-data/bdev_name.  Because verity_dtr() calls dm_put_device(ti,
> v->data_dev) before verity_fec_dtr(v) destroys v->fec->data_bufio and
> removes its sysfs kobject, a concurrent sysfs read during target teardown
> can dereference v->data_dev->bdev after the device reference has been
> dropped.

Same fix as patch 3: verity_fec_dtr() will run before the device
puts, so the FEC bufio clients and their sysfs entries are gone first.


> > +when the device is first activated and disappear with it.  Reloading the
> > +table removes the old table's directories; the new table's reappear on the
> > +next resume.
> [Severity: Medium]
> Does calling kobject_create_and_add("dm-bufio", parent) in
> verity_register_bufio_sysfs() from commit "dm-verity: size the hash retain
> target from the hash area" trigger a kernel warning and stack trace on every
> table reload?
> During do_resume(), dm_resume() invokes verity_resume() on the new table
> before dm_table_destroy() runs verity_dtr() on the old table.  Because the
> old table's "dm-bufio" kobject is still registered under the disk kobject,
> kobject_create_and_add("dm-bufio", parent) fails with -EEXIST in
> sysfs_create_dir_ns() and calls sysfs_warn_dup(), which prints a kernel
> warning and calls dump_stack(), and then destroying the old table removes
> /sys/block/dm-N/dm-bufio altogether.

Same fix as in patches 2 and 3: ->presuspend detaches the directories
(names freed, kobjects kept) and ->resume publishes the new table's
directories synchronously; no -EEXIST warning, no work, no deadlock.


> [ ... ]
>
> > diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> > index d4fb06cb4e7ea..7f92bc14d39fe 100644
> > --- a/drivers/md/dm-verity-target.c
> > +++ b/drivers/md/dm-verity-target.c
> > @@ -1865,6 +1865,154 @@ static void verity_resume(struct dm_target *ti)
> >  	verity_register_bufio_sysfs(ti->private);
> >  }
> >  
> > +static int verity_prefetch_hash(struct dm_verity *v, unsigned int argc,
> > +				char **argv, char *result, unsigned int maxlen)
> > +{
> > +	sector_t total = v->hash_end - v->hash_start;
> > +	sector_t start, n;
> > +	unsigned long long value;
> > +	unsigned int sz = 0;
> > +
> > +	if (argc == 1) {
> > +		start = 0;
> > +		n = total;
> > +	} else if (argc == 3) {
> > +		if (kstrtoull(argv[1], 0, &value) || (sector_t)value != value)
> > +			return -EINVAL;
> > +		start = value;
> > +
> > +		if (kstrtoull(argv[2], 0, &value) || (sector_t)value != value)
> > +			return -EINVAL;
> > +		n = value;
> > +	} else {
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (start >= total) {
> > +		DMERR("prefetch_hash start %llu beyond hash area (%llu blocks)",
> > +		      (unsigned long long)start, (unsigned long long)total);
> > +		return -EINVAL;
> > +	}
> [Severity: Low]
> Does the start >= total check in verity_prefetch_hash() and
> verity_drop_hash() reject zero-argument calls on a valid 0-level verity
> device?
> When v->data_blocks <= 1, verity_ctr() sets v->levels = 0 and
> v->hash_end = v->hash_start, so total is 0.  A zero-argument prefetch_hash
> or drop_hash sets start = 0 and n = 0, hits start >= total, logs an error,
> and fails with -EINVAL instead of succeeding as a 0-block no-op.

Will be fixed in v2: an empty hash area will succeed as a no-op and
report 0 blocks.


> > +
> > +	n = min(n, total - start);
> > +	n = min_t(sector_t, n, UINT_MAX);
> > +
> > +	dm_bufio_prefetch(v->bufio, v->hash_start + start, n);
> [Severity: Medium]
> Can verity_prefetch_hash() race with verity_postsuspend() or submit reads to
> v->hash_dev while the target is suspended?
> CPU0                                  CPU1
> target_message()
>   verity_message()
>     verity_prefetch_hash()
>       dm_bufio_prefetch(v->bufio, ...)
>         dm_bufio_lock(c)
>         b = __bufio_new(...)
>           /* b->hold_count == 1 */
>         dm_bufio_unlock(c)
>                                       dm_suspend()
>                                         verity_postsuspend()
>                                           flush_workqueue(v->verify_wq)
>                                           dm_bufio_client_reset(v->bufio)
>                                             drop_buffers(c)
>                                               cache_iterate(..., warn_leak)
>                                                 WARN_ON(!(*warned))
>                                               WARN_ON(cache_count(...))
>         submit_io(b, ...)
>         dm_bufio_release(b)
> Unlike verity_prefetch_io(), which runs on v->verify_wq and is drained by
> flush_workqueue(v->verify_wq) in verity_postsuspend() (see 2de510fccbca
> ("dm-verity: fix prefetch-vs-suspend race")), target_message() calls
> verity_message() without holding md->suspend_lock or checking
> dm_suspended(ti).  If dm_bufio_client_reset() runs while
> __dm_bufio_prefetch() has dropped dm_bufio_lock(c) with a buffer's
> hold_count == 1, drop_buffers() cannot evict that buffer and triggers the
> leak WARN_ONs in warn_leak() and drop_buffers() (and under
> CONFIG_DM_DEBUG_BLOCK_STACK_TRACING, warn_leak() zeroes b->hold_count and
> drop_buffers() frees b before submit_io() and dm_bufio_release(b) run,
> causing a use-after-free).
> In addition, because v->bufio submits reads directly to v->hash_dev->bdev
> rather than the dm-verity mapped device, calling prefetch_hash while
> suspended immediately issues reads to v->hash_dev->bdev and populates
> v->bufio instead of queueing them until resume as described in verity.rst.

The hold_count == 1 window in this scenario doesn't exist: the
prefetch loop releases each buffer while still holding dm_bufio_lock,
so drop_buffers(), which takes the same lock, cannot observe the held
state.  What remains is the in-flight B_READING state, which on a
normal client is waited for via wait_on_bit_io(), not warned on.  So
on a sleeping client this is a safe no-op or a wasted read, and on a
no_sleep client it is the case below, to be rejected at the command
level.  I therefore left the messages available while suspended, and
verity.rst documents that a suspended prefetch queues reads that
complete on resume.


> > +
> > +	DMEMIT("prefetch_hash: started %llu blocks", (unsigned long long)n);
> > +
> > +	return 1;
> > +}
> > +
> > +static int verity_drop_hash(struct dm_verity *v, unsigned int argc,
> > +			    char **argv, char *result, unsigned int maxlen)
> > +{
> > +	sector_t total = v->hash_end - v->hash_start;
> > +	sector_t start, n;
> > +	unsigned long long value;
> > +	unsigned int sz = 0;
> > +
> > +	/*
> > +	 * dm_bufio_forget_buffers() ends up in cache_remove_range(), which
> > +	 * cannot run on a client created with DM_BUFIO_CLIENT_NO_SLEEP.
> > +	 */
> > +	if (v->use_bh_wq) {
> > +		DMERR("drop_hash unsupported on tasklet-verifying device");
> > +		return -EOPNOTSUPP;
> > +	}
> [Severity: High]
> Can calling verity_prefetch_hash() on a v->use_bh_wq device leave in-flight
> B_READING buffers that drop_buffers() cannot evict, leading to warnings and
> a use-after-free on teardown?
> drivers/md/dm-bufio.c:is_clean() {
>     ...
> 	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep &&
> 	    unlikely(test_bit(B_READING, &b->state)))
> 		return ER_DONT_EVICT;
>     ...
> }
> When v->use_bh_wq is enabled, v->bufio is created with
> DM_BUFIO_CLIENT_NO_SLEEP (c->no_sleep = true).  verity_prefetch_hash() does
> not reject v->use_bh_wq and submits asynchronous read BIOs to
> v->hash_dev->bdev with B_READING set and b->hold_count == 0, returning to
> userspace while those reads are still in flight.  If the device is then
> suspended (dm_bufio_client_reset()) or destroyed (dm_bufio_client_destroy())
> before all prefetched reads complete, __get_unclaimed_buffer() -> is_clean()
> refuses to evict the B_READING buffers.  drop_buffers() then triggers
> WARN_ON(!(*warned)) in warn_leak(), calls cond_resched() inside
> __cache_iterate() while holding spin_lock_bh(&c->spinlock), and on target
> destruction destroys c->slab_buffer and frees c while read_endio() is still
> in flight.

Confirmed.  On a normal client, reset and destroy wait for in-flight
reads via __make_buffer_clean()'s wait_on_bit_io(B_READING), but a
no_sleep client cannot wait by design, so its eviction simply refuses
the buffer and teardown proceeds with the read still in flight.  Will
be fixed in v2 the same way drop_hash handles it: prefetch_hash will
fail with -EOPNOTSUPP on try_verify_in_tasklet devices.


Thanks for the review,
Yongpeng
