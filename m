Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022342;
	b=1HWT7ygDZ/afC4YKyoFM9xptg8gmymFerPVAUtlnqRpg5Ura4684i4KidHLG9Qkib7+B
	 eGnEV/8jvjsKvF2kywScSG3E4z66pJ487kKwfRw/IrnENIIklHmo3UtdC0vUtwsBzih1j
	 W81H149yKmL96H1Z4REGc3LTdYL6ksErjIr1TYIqQfT2mrS8NVK8GP0jiifBNwrxmpLUF
	 rH2LBWkoBCZU04syd7atl6iJN91SFQAr2zzHODMLpZf/PjlN3CR3Lh15ozr5mK5vpITKM
	 8PgZHY9V4QVP/IK4bGF5jtmYIRVn/qz0R7bt0RA6loUrza7Gbhqn/3T5b+LbVcV7ucQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022342;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/9ZkymVMba9Ub548vNbI4rS6BTfxZkC2O+zt4V+dPsQ=;
	b=Pw4y7NJZWGSPeq3Rt1Gp+8UBGZWg6Ak77aOtlAuClZtHxdgLWuzc/6FkOg/VAqMur8mr
	 W1Zxy4RK8P4wdupLQ4j+ncfaB8P+HiFoFqhJg2vuimxPj7EpZNOr4G1w2RVIHOsbpp65L
	 mGQYF9SnW2fbAvF862eua3dUZxjWjncj0z5JAT3NPXevHtmU2wRqm+GD7ouFfU1crHH/q
	 IYQa4/cTYvzUJi2rSGzPwR4Cs8qXjdzMBC0rBifLLCySs1XB173qgxZJdIoMGhYD32wBD
	 2FDFJ6ICDVqzjwnaaeD9UIHIhuglUL/0D1zv8Cm3Sf+wiE+cdJZxSqKyyZ0jE/a2IFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AuTlY+8w;
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA24606A325
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 17:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BA24606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AuTlY+8w
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3b3e85baf7cso354238a91.0
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 09:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795022342; x=1795627142; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/9ZkymVMba9Ub548vNbI4rS6BTfxZkC2O+zt4V+dPsQ=;
        b=AuTlY+8wmKUw5MSj0CX6sro+mnXS5Ont+xDG6ZLE8dT2bOgnYizIe2g2RPUJ+h9HtL
         fRzzWctAsmkBnuETXzMvbo1nZqIMq4SXq3vaZMXefo50u4pFHwbet7F4eC/V4iwuan3h
         9uk2cgnN0LwgcgZJXxgnlEMv+cY1xI2JkWDea4GOFuXkFIx6VPY4Y7NJoTD3psa301Md
         xzBjBA/FYjUE9nnhJImh/mgHbzqpz9oQw8ATCNBcjWUczbePJ4AxDPsRMdYM5K80Mv97
         1MKhTJc9RiAh/BRIuVwuWJwdCIX4r2ke0lUs8JZc+eNjEkvjD1dNi6YpaCYoikm36iWs
         q07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795022342; x=1795627142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/9ZkymVMba9Ub548vNbI4rS6BTfxZkC2O+zt4V+dPsQ=;
        b=WTsrfybtIcxYuzY310lhxRhlqZ3unfMfLPrBD18xt9wURJ6oc5kecRPq/jDiClp/Gj
         ++FhqrHoW+oRAYwPmI6bM1QYeuOa3AEcqKoIQVw7d6DgcnQhPprhF7PPSrvFU8qOCsfc
         EcU8h666yqmsab9pFplU+tWTUgcC3TyPld2J2pOCQ5qyK80cBHVSgQIFzDm3MbuKdb2h
         u9wrxrfDM1nsDUWunZY6EfxRp558cP2MzZM9nLgS1+XzymZs7gboaTuxlvQDbdzEYMCV
         sqf6lUETqXSqsaCwkEQgVPUnuKYg6Bua0laE+vOUwVqVqBdcpi3XrSJRX0fvKQXN9JB0
         m2ug==
X-Forwarded-Encrypted: i=1; AL+hErF/wueq0sH9lGT8p53EsImQeYngKFbHty1W01RSkgVNM15X8UXvrs6eVknh+knMeZ/yZV37GdLfGA==@lists.linux.dev
X-Gm-Message-State: APuU4Z9dxhtMtKSy9+Io1ojFgDp0kPUarX2RbmnNFQfm9u3Iv1C87FmY
	tG9srYhbpmF9XrKVBzki8AiwdZQ178dxUvEMuakYauDz+lFzPxUnqZmo
X-Gm-Gg: AZFdTZfRZcqf2RHk59MloP3MFzSluG5ab1crVZVcfA/w/dcKQU6ywXlDJSUraZpU0La
	5PlD1Hn7eVwhLZHD9bQwnMPUkbbkKXTmaFdNQf/NbsTpCDytDBx9DXbtIsAu24gTXw/k8A8E4IN
	sbHFW4C7ktkgBQDVVQJ4gJjtKB5cyhkAQag9gyGPg1sOlhV89nrN+xErg055Leab0KsTYxBZ0n8
	u9KDmIvNaYceG74+1U5KaF0Z95YeFE5xCJfo/v6Al7zV0GFoSVl40Ck1KKHZCg8SywtzMwIEopa
	wMqZdJV89IJCT1kfnueuiss2u2JMqmnE8X/qkDvaPD8wrz5byGBHq5gI4765kKUZ762i6m3y3ao
	hCEa6BeqtjGZFTPHlUbTqQMeOaGAYK5uOVVHLI9hn9KgVUmtJepldRiAKcn23UhbkrI3NkLggeW
	dxUpJpzNSuQtgdg/U/SG1OggIjvHvgB0Dd+doJQmET3L2T2Yxi6gdmHzSuIv8EtfFj2sbxPjlxc
	hfcbzF06bD4ImuoPkInT28gn0XX3e4IbqfvapdghRUX3+O1QMn2RuquI4xjLS7/PlI7388kRaOv
	spvoDzoTbpM6NZ7TtLVHC4zXn6Fi1q3dTBXGtFbHfgRrqe7NiC9ECIIms6Ie1cbIbuxfv4WPhmk
	DTYKFAC2J
X-Received: by 2002:a17:90b:3f0b:b0:3b1:2d60:66cc with SMTP id 98e67ed59e1d1-3b3d06412f4mr3377764a91.8.1795022341430;
        Wed, 18 Nov 2026 09:19:01 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3f6a9220fsm161721a91.5.2026.11.18.09.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:19:00 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: sashiko-bot@kernel.org
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/4] dm-bufio: allow exposing a client in sysfs under a caller-chosen kobject
Date: Thu, 19 Nov 2026 01:18:57 +0800
Message-ID: <20261118171857.686036-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-218893@kernel.org>
References: <sashiko-outbox-218893@kernel.org>
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

Subject: Re: [PATCH 2/4] dm-bufio: allow exposing a client in sysfs under a caller-chosen kobject
In-Reply-To: <sashiko-outbox-218893@kernel.org>

On Tue, 17 Nov 2026 at 01:40:55PM +0000, sashiko-bot@kernel.org wrote:


> > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> > index 75b6e5c027ae2..627a64f981c5c 100644
> > --- a/drivers/md/dm-bufio.c
> > +++ b/drivers/md/dm-bufio.c
>
> [ ... ]
>
> > @@ -2504,6 +2510,144 @@ static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrin
>
> [ ... ]
>
> > +static void dm_bufio_kobj_release(struct kobject *kobj)
> > +{
> > +	struct dm_bufio_client *c = container_of(kobj, struct dm_bufio_client, kobj);
> > +
> > +	/*
> > +	 * The client is freed only after this completes, as in dm-sysfs.
> > +	 */
> > +	complete(&c->kobj_unregister);
> > +}
> > +
> > +static const struct kobj_type dm_bufio_ktype = {
> > +	.sysfs_ops	= &dm_bufio_sysfs_ops,
> > +	.default_groups	= dm_bufio_groups,
> > +	.release	= dm_bufio_kobj_release,
> > +};
> > +
> > +static int dm_bufio_kobj_add(struct dm_bufio_client *c, struct kobject *parent,
> > +			     const char *name)
> > +{
> > +	init_completion(&c->kobj_unregister);
> > +
> > +	return kobject_init_and_add(&c->kobj, &dm_bufio_ktype, parent, "%s",
> > +				    name);
> > +}
> > +
> > +/* Drop the sysfs reference and wait for the release method to run. */
> > +static void dm_bufio_kobj_del(struct dm_bufio_client *c)
> > +{
> > +	kobject_put(&c->kobj);
> > +	wait_for_completion(&c->kobj_unregister);
> > +}
> [Severity: Medium]
> Can dm-bufio.ko be unloaded while another task is still returning from
> dm_bufio_kobj_release()?
> CONFIG_DM_BUFIO is tristate, so dm_bufio_kobj_release() lives in
> loadable module text.  If the last reference to c->kobj is dropped by
> another context after dm_bufio_kobj_del() calls kobject_put() (for
> example, a concurrent sysfs reader or kobject_delayed_cleanup()), that
> context can be preempted right after complete(&c->kobj_unregister):
> CPU0                              CPU1
> dm_bufio_client_destroy()
>   dm_bufio_kobj_del()
>     kobject_put(&c->kobj)
>                                   kobject_put(&c->kobj)
>                                     dm_bufio_kobj_release()
>                                       complete(&c->kobj_unregister)
>                                       <preempted>
>     wait_for_completion()
>   kfree(c)
> delete_module("dm_bufio")
>                                       return;  <-- unmapped module text
> dm-sysfs avoids this race by placing dm_kobject_release() in built-in
> code in drivers/md/dm-builtin.c.

I don't think this race is reachable here.  dm-builtin.c exists because
the dm kobject can be referenced from outside dm-mod itself
(dm_get_from_kobject() and friends), so a foreign reference can outlive
the exit path.  Our client kobject is only ever referenced by dm-bufio:
nothing exports it, and sysfs readers hold kernfs active references,
which are drained before release runs, not kobject references.  The
final put therefore always comes from dm_bufio_kobj_del() inside
dm_bufio_client_destroy() or from the failed-add path, and
wait_for_completion() holds the exit path until release has returned,
module text included.


> > +
> > +int dm_bufio_client_sysfs_add(struct dm_bufio_client *c, struct kobject *parent,
> > +			      const char *name)
> > +{
> > +	int r;
> > +
> > +	if (c->sysfs_added)
> > +		return -EBUSY;
> > +
> > +	r = dm_bufio_kobj_add(c, parent, name);
> > +	if (r) {
> > +		dm_bufio_kobj_del(c);
> > +		return r;
> > +	}
> > +
> > +	c->sysfs_added = true;
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(dm_bufio_client_sysfs_add);
> [Severity: Medium]
> Does retrying dm_bufio_client_sysfs_add() after a failed call double free
> c->kobj.name?
> When kobject_init_and_add() fails after kobject_init() and
> kobject_set_name_vargs(), dm_bufio_kobj_del() runs kobject_cleanup(),
> which calls kfree_const(c->kobj.name) without clearing c->kobj.name or
> c->kobj.state_initialized.  Because c->sysfs_added remains false and
> c->kobj is not zeroed on the error path, a second call to
> dm_bufio_client_sysfs_add() on the same client triggers the
> state_initialized warning in kobject_init() and then calls
> kfree_const(kobj->name) on the dangling pointer in
> kobject_set_name_vargs().

Right -- kobject_cleanup() frees the name through a local variable
and leaves kobj->name dangling.  This will be fixed in v2 by zeroing
the kobject after the failure, so a retried add starts from scratch:

		if (r) {
			dm_bufio_kobj_del(c);
			/*
			 * kobject_cleanup() freed kobj.name but left the dangling
			 * pointer, so a retried add would free it again; clear the
			 * whole kobject to make a retry start from scratch.
			 */
			memset(&c->kobj, 0, sizeof(c->kobj));
			return r;
		}


> > @@ -2660,6 +2804,9 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
> >  {
> >  	unsigned int i;
> >  
> > +	if (c->sysfs_added)
> > +		dm_bufio_kobj_del(c);
> > +
> >  	drop_buffers(c);
> >  
> >  	shrinker_free(c->shrinker);
> [Severity: Medium]
> How can a device-mapper target reload its table without colliding on the
> sysfs directory when c->kobj is only removed in
> dm_bufio_client_destroy()?
> During a table reload in do_resume(), dm_suspend() suspends the old table
> and dm_resume() resumes the new table before dm_table_destroy() destroys
> the old table and its dm_bufio_client.  When a target registers its
> clients under the device-level path /sys/block/<dm-device>/dm-bufio/<name>
> (as documented in Documentation/ABI/testing/sysfs-kernel-dm-bufio and
> used by dm-verity in commit "dm-verity: size the hash retain target from
> the hash area"), the old table's sysfs entries are still present when the
> new table resumes, so kobject_init_and_add() fails with -EEXIST and
> triggers a dump_stack() warning in sysfs_warn_dup().  Without an exported
> unregistration helper that targets can call during suspend, reloading a
> table fails to publish the new client's sysfs directory and leaves the
> device without /sys/block/<dm-device>/dm-bufio/ once the old table is
> destroyed.

Will be fixed in v2 by detaching, not deferring: ->presuspend removes
the directories from sysfs (a new dm_bufio_client_sysfs_detach) but
keeps the kobjects, which are released when the table is destroyed.
The names are free before a reloaded table is resumed, so its
directories are created synchronously from ->resume -- no warning and
no delayed retry.

Presuspend runs before the queue is frozen, so the kernfs drain cannot
block on I/O.  The ->postsuspend removal has exactly the deadlock you
describe, because it drains sysfs while userspace (udev) is blocked
opening the frozen device; that is why the detach moved to the
pre-freeze hook.


Thanks for the review,
Yongpeng
