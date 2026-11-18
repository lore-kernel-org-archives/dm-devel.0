Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020113;
	b=Y7TwgdsQGrr6OkGS2uJQtlHy9apBGwiNFZ0D4Qtg1wL1MICc0ysct17TLXawm3uz0Jej
	 M7osSj3EwKtxvI8Q0elEFTmY4rL9HEQk4GWX/llZ1E3bShCRp7wOV//19e3TDVlJShgHi
	 lzSgRJqOTVHHYxcEgsS99vydZIfeyHy120qjrGsZK9feJGutj2+EJm24L392V0UZmJ2ky
	 UyXOjK/fxraP4IuWJNyg+SqQ4SkzcPsCb1whEBg82dveUE9m/mCPa1Kq72wOZ4PgKVLHF
	 uTvePXacwSqdTcPGJ6CcIy1Ds/IvINl5aH5LMG/maokJJx2vYu28Z1+oUTXbhXJ023Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020113;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type;
	bh=LWYdyd7QSa93Qd1MzqeRbimxYKXxQK6qefqEMJMUOyo=;
	b=FHmXpW0nwFYODtwdFvK8gYmt51TxMQFDQDhUuefa5iH/G0g92dUSUrEFSnPjaeGIDoMB
	 2czyNwaP0UH/K6h7Vmp12Qntd+NY+ahZKWwMqStJ6tTsB78aqdBJ9wdiqnlBntwOkJCZW
	 p5YjFIobJXyCUajT/mY71ai5i73Fljy79sOGjvwj6f58MuZ89sY2sSdnafG+YSrjgn1UE
	 VyXqkoUGPkwrsq2Oil5atIXbUtquLRqq3tBlnCWcPb73wuN/YkLlZNSHmsH2l74/URuiK
	 Z7a8mXSZcxAdmbZMNHXwcArnNE5FbsXUMl2ELzM50McezWwCTJrRDVcV47OwO1GuaXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="ZiAFik/4";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EBF606A325
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 16:41:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2EBF606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZiAFik/4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795020111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LWYdyd7QSa93Qd1MzqeRbimxYKXxQK6qefqEMJMUOyo=;
	b=ZiAFik/41pIkL3QwzMwNnuhVd5tlXm7WvAAIEoUoGJ1laGnRpSUuGH9nTjKdn7VGJO17h4
	q91BGqNv9CyEeXkzraY8zDBfMqf2PlAkEKPtvA1EVAwgdAbaH5TgxOBy59gPU0w1Z+iKvo
	1wR6F4PgSdUbGO7yF+DSu2ngPA/PfXk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-427-mcNpI7d1O3CCap94ylScVg-1; Wed,
 18 Nov 2026 11:41:48 -0500
X-MC-Unique: mcNpI7d1O3CCap94ylScVg-1
X-Mimecast-MFC-AGG-ID: mcNpI7d1O3CCap94ylScVg_1795020107
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32FCB1956094;
	Wed, 18 Nov 2026 16:41:47 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1003B195B3C2;
	Wed, 18 Nov 2026 16:41:44 +0000 (UTC)
Date: Wed, 18 Nov 2026 17:41:42 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yongpeng Yang <yangyongpeng.storage@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
    Yongpeng Yang <yangyongpeng@xiaomi.com>, 
    Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH 2/4] dm-bufio: allow exposing a client in sysfs under a
 caller-chosen kobject
In-Reply-To: <20261117131918.2745193-5-yangyongpeng.storage@gmail.com>
Message-ID: <d4fc9150-4768-f747-ca97-688bc9bebc46@redhat.com>
References: <20261117131918.2745193-2-yangyongpeng.storage@gmail.com> <20261117131918.2745193-5-yangyongpeng.storage@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rHk9VAULGFswznLbevpxUNzm-OQvw2HJ-MoQhaGxliY_1795020107
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

I discussed it with Alasdair and Zdenek and we concluded that it is not 
clear how to assign sysfs names to dm-bufio instances.

There may be multiple targets in a table - if you use the name of the md 
device as the base directory, they will clash.

There may be at most two tables for a given "md" device (the active table 
and the inactive table). Each will have its own dm-bufio instance and they 
will clash.

Another problem is that if you reload a dm table, you lose all dm-bufio 
settings that were set by the user in sysfs.

So, we concluded that it's better to do it the device-mapper-way - use the 
messages or constructor line to specify the dm-bufio parameters.

There is a requirement that the returned table line must be equivalent to 
the passed table line. If we report something different on the returned 
table line, it would confuse lvm.

So, we can use either constructor line or messages, but not both.

Using the mwssages has the advantage that we would not need userspace 
support (the settings could be modified or queried with the 'dmsetup 
message' command), the disadvantage is that the settings would be lost 
when someone reloads the table.

Using the constructor line would need userspace support (from 
veritysetup/integritysetup/lvm2), but the settings could be stored in 
metadata and re-applied when the table is reloaded.

What do you think? Which of these two possibilities is better?

Mikulas


On Tue, 17 Nov 2026, Yongpeng Yang wrote:

> From: Yongpeng Yang <yangyongpeng@xiaomi.com>
> 
> There is no way to see how much memory a particular dm-bufio client is
> using, or to change one client's retain target without also affecting
> every future client.
> 
> Add dm_bufio_client_sysfs_add(), which publishes a client as <name>
> under a kobject supplied by its user, with the retain target writable
> and the rest of its state read-only.  Callers that have no use for it
> simply never call it.
> 
> The kobject is embedded in the client, which is therefore freed only
> after the release method runs, as in dm-sysfs.
> 
> Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
> Assisted-by: LLM
> ---
>  .../ABI/testing/sysfs-kernel-dm-bufio         |  76 +++++++++
>  .../admin-guide/device-mapper/dm-bufio.rst    |  54 +++++++
>  .../admin-guide/device-mapper/index.rst       |   1 +
>  drivers/md/dm-bufio.c                         | 147 ++++++++++++++++++
>  include/linux/dm-bufio.h                      |   8 +
>  5 files changed, 286 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-kernel-dm-bufio
>  create mode 100644 Documentation/admin-guide/device-mapper/dm-bufio.rst
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-dm-bufio b/Documentation/ABI/testing/sysfs-kernel-dm-bufio
> new file mode 100644
> index 000000000000..f514e7a6a019
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-kernel-dm-bufio
> @@ -0,0 +1,76 @@
> +What:		/sys/block/<dm-device>/dm-bufio/<name>/
> +Date:		November 2026
> +KernelVersion:	7.4
> +Contact:	dm-devel@lists.linux.dev
> +Description:
> +		Directory exposing one dm-bufio client whose user opted in
> +		through dm_bufio_client_sysfs_add().  <name> is chosen by that
> +		user; dm-verity, which places the directory under the block
> +		device of its own dm device, uses <name> "hash" for the hash
> +		tree client, "fec" for the FEC parity client and "fec-data"
> +		for the FEC data client.  The directory lives from
> +		registration until the client is destroyed, independently of
> +		any device-mapper table loaded on the device, so a suspend or
> +		table reload never leaves dangling entries behind.  The
> +		read-only counters are instantaneous snapshots and may be
> +		approximate.
> +
> +What:		/sys/block/<dm-device>/dm-bufio/<name>/bdev
> +Date:		November 2026
> +KernelVersion:	7.4
> +Contact:	dm-devel@lists.linux.dev
> +Description:
> +		Major and minor of the client's block device, in the form
> +		<major>:<minor>.  Read-only.
> +
> +What:		/sys/block/<dm-device>/dm-bufio/<name>/bdev_name
> +Date:		November 2026
> +KernelVersion:	7.4
> +Contact:	dm-devel@lists.linux.dev
> +Description:
> +		Name of the client's block device.  Read-only.
> +
> +What:		/sys/block/<dm-device>/dm-bufio/<name>/block_size
> +Date:		November 2026
> +KernelVersion:	7.4
> +Contact:	dm-devel@lists.linux.dev
> +Description:
> +		Block size of the client in bytes.  Read-only.
> +
> +What:		/sys/block/<dm-device>/dm-bufio/<name>/retain_bytes
> +Date:		November 2026
> +KernelVersion:	7.4
> +Contact:	dm-devel@lists.linux.dev
> +Description:
> +		Number of bytes dm-bufio tries to keep cached for this
> +		client.  It is a floor applied by the memory shrinker, not a
> +		cap, so the cache may grow past it when memory is plentiful.
> +
> +		Writable.  A non-zero value is rounded to a block
> +		boundary (but at least one block); zero restores the
> +		dm-bufio default.  Writing it affects only this client,
> +		not the retain_bytes module parameter and not other
> +		clients.
> +
> +What:		/sys/block/<dm-device>/dm-bufio/<name>/current_bytes
> +Date:		November 2026
> +KernelVersion:	7.4
> +Contact:	dm-devel@lists.linux.dev
> +Description:
> +		Number of bytes currently cached by this client.  Read-only.
> +
> +What:		/sys/block/<dm-device>/dm-bufio/<name>/buffers
> +Date:		November 2026
> +KernelVersion:	7.4
> +Contact:	dm-devel@lists.linux.dev
> +Description:
> +		Number of buffers currently cached by this client.
> +		Read-only.
> +
> +What:		/sys/block/<dm-device>/dm-bufio/<name>/minimum_buffers
> +Date:		November 2026
> +KernelVersion:	7.4
> +Contact:	dm-devel@lists.linux.dev
> +Description:
> +		Minimum number of buffers the client keeps before cleanup
> +		happens.  Read-only.
> diff --git a/Documentation/admin-guide/device-mapper/dm-bufio.rst b/Documentation/admin-guide/device-mapper/dm-bufio.rst
> new file mode 100644
> index 000000000000..c35e415acacd
> --- /dev/null
> +++ b/Documentation/admin-guide/device-mapper/dm-bufio.rst
> @@ -0,0 +1,54 @@
> +========
> +dm-bufio
> +========
> +
> +dm-bufio caches small metadata blocks on block devices for several
> +device-mapper targets (dm-verity, dm-thin, dm-cache, dm-integrity and
> +dm-ebs among others).  Each user creates clients on a block device; the
> +caches are independent, even for clients on the same device.
> +
> +Retain target
> +=============
> +
> +dm-bufio bounds nothing by itself: buffers live until the memory shrinker
> +evicts them, and the shrinker stops once a client is back down to its
> +retain target.  The target is a floor under memory pressure, not a cap,
> +so a fully warmed cache may hold far more.
> +
> +The default is the ``retain_bytes`` module parameter of dm_bufio
> +(256 KiB), which only affects clients created after it is changed.  One
> +client changes its own target through the ``retain_bytes`` attribute of
> +its sysfs directory or a target-specific message.
> +
> +sysfs interface
> +===============
> +
> +A client may be published in sysfs with dm_bufio_client_sysfs_add(),
> +passing the parent kobject and the directory name; dm-bufio does not
> +choose where it lives.  The directory lives until the client is
> +destroyed.  dm-verity registers its clients under the block device of
> +its own dm device::
> +
> +  /sys/block/dm-N/dm-bufio/hash/        the hash tree client
> +  /sys/block/dm-N/dm-bufio/fec/         the FEC parity client
> +  /sys/block/dm-N/dm-bufio/fec-data/    the FEC data client
> +
> +The attributes, including the read-write ``retain_bytes``, are documented
> +in Documentation/ABI/testing/sysfs-kernel-dm-bufio.
> +
> +Example
> +=======
> +
> +Inspect the hash client of a dm-verity device::
> +
> +  # ls /sys/block/dm-1/dm-bufio/
> +  fec  fec-data  hash
> +
> +  # cat /sys/block/dm-1/dm-bufio/hash/retain_bytes
> +  2535424
> +
> +  # echo 8388608 > /sys/block/dm-1/dm-bufio/hash/retain_bytes
> +  # cat /sys/block/dm-1/dm-bufio/hash/retain_bytes
> +  8388608
> +
> +The other clients keep their own targets.
> diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
> index 73c1f2002134..3b6c348f71f5 100644
> --- a/Documentation/admin-guide/device-mapper/index.rst
> +++ b/Documentation/admin-guide/device-mapper/index.rst
> @@ -8,6 +8,7 @@ Device Mapper
>      cache-policies
>      cache
>      delay
> +    dm-bufio
>      dm-clone
>      dm-crypt
>      dm-dust
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 75b6e5c027ae..627a64f981c5 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -20,6 +20,9 @@
>  #include <linux/rbtree.h>
>  #include <linux/stacktrace.h>
>  #include <linux/jump_label.h>
> +#include <linux/kobject.h>
> +#include <linux/sysfs.h>
> +#include <linux/completion.h>
>  
>  #include "dm.h"
>  
> @@ -995,6 +998,9 @@ struct dm_bufio_client {
>  	unsigned int minimum_buffers;
>  
>  	unsigned long retain_bytes;	/* READ_ONCE/WRITE_ONCE, no lock needed */
> +	bool sysfs_added;
> +	struct kobject kobj;
> +	struct completion kobj_unregister;
>  
>  	sector_t start;
>  
> @@ -2504,6 +2510,144 @@ static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrin
>  	return count;
>  }
>  
> +/*
> + * A client may be published in sysfs with dm_bufio_client_sysfs_add();
> + * the directory lives until the client is destroyed.
> + */
> +
> +static ssize_t dm_bufio_attr_show(struct kobject *kobj, struct attribute *attr,
> +				  char *buf);
> +static ssize_t dm_bufio_attr_store(struct kobject *kobj, struct attribute *attr,
> +				   const char *buf, size_t size);
> +
> +#define DM_BUFIO_ATTR_RO(_name)						\
> +	static struct attribute dm_bufio_attr_##_name =			\
> +		{ .name = #_name, .mode = 0444 }
> +
> +#define DM_BUFIO_ATTR_RW(_name)						\
> +	static struct attribute dm_bufio_attr_##_name =			\
> +		{ .name = #_name, .mode = 0644 }
> +
> +DM_BUFIO_ATTR_RO(bdev);
> +DM_BUFIO_ATTR_RO(bdev_name);
> +DM_BUFIO_ATTR_RO(block_size);
> +DM_BUFIO_ATTR_RW(retain_bytes);
> +DM_BUFIO_ATTR_RO(current_bytes);
> +DM_BUFIO_ATTR_RO(buffers);
> +DM_BUFIO_ATTR_RO(minimum_buffers);
> +
> +static ssize_t dm_bufio_attr_show(struct kobject *kobj, struct attribute *attr,
> +				  char *buf)
> +{
> +	struct dm_bufio_client *c = container_of(kobj, struct dm_bufio_client, kobj);
> +
> +	if (attr == &dm_bufio_attr_bdev)
> +		return sysfs_emit(buf, "%d:%d\n", MAJOR(c->bdev->bd_dev),
> +				  MINOR(c->bdev->bd_dev));
> +	if (attr == &dm_bufio_attr_bdev_name)
> +		return sysfs_emit(buf, "%pg\n", c->bdev);
> +	if (attr == &dm_bufio_attr_block_size)
> +		return sysfs_emit(buf, "%u\n", c->block_size);
> +	if (attr == &dm_bufio_attr_retain_bytes)
> +		return sysfs_emit(buf, "%lu\n", READ_ONCE(c->retain_bytes));
> +	if (attr == &dm_bufio_attr_current_bytes)
> +		return sysfs_emit(buf, "%llu\n",
> +				  (u64)cache_total(&c->cache) * c->block_size);
> +	if (attr == &dm_bufio_attr_buffers)
> +		return sysfs_emit(buf, "%lu\n", cache_total(&c->cache));
> +	if (attr == &dm_bufio_attr_minimum_buffers)
> +		return sysfs_emit(buf, "%u\n", c->minimum_buffers);
> +
> +	return -EINVAL;
> +}
> +
> +static ssize_t dm_bufio_attr_store(struct kobject *kobj, struct attribute *attr,
> +				   const char *buf, size_t size)
> +{
> +	struct dm_bufio_client *c = container_of(kobj, struct dm_bufio_client, kobj);
> +
> +	if (attr == &dm_bufio_attr_retain_bytes) {
> +		unsigned long new;
> +
> +		if (kstrtoul(buf, 0, &new))
> +			return -EINVAL;
> +
> +		dm_bufio_set_retain_bytes(c, new);
> +
> +		return size;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static struct attribute *dm_bufio_attrs[] = {
> +	&dm_bufio_attr_bdev,
> +	&dm_bufio_attr_bdev_name,
> +	&dm_bufio_attr_block_size,
> +	&dm_bufio_attr_retain_bytes,
> +	&dm_bufio_attr_current_bytes,
> +	&dm_bufio_attr_buffers,
> +	&dm_bufio_attr_minimum_buffers,
> +	NULL,
> +};
> +ATTRIBUTE_GROUPS(dm_bufio);
> +
> +static const struct sysfs_ops dm_bufio_sysfs_ops = {
> +	.show	= dm_bufio_attr_show,
> +	.store	= dm_bufio_attr_store,
> +};
> +
> +static void dm_bufio_kobj_release(struct kobject *kobj)
> +{
> +	struct dm_bufio_client *c = container_of(kobj, struct dm_bufio_client, kobj);
> +
> +	/*
> +	 * The client is freed only after this completes, as in dm-sysfs.
> +	 */
> +	complete(&c->kobj_unregister);
> +}
> +
> +static const struct kobj_type dm_bufio_ktype = {
> +	.sysfs_ops	= &dm_bufio_sysfs_ops,
> +	.default_groups	= dm_bufio_groups,
> +	.release	= dm_bufio_kobj_release,
> +};
> +
> +static int dm_bufio_kobj_add(struct dm_bufio_client *c, struct kobject *parent,
> +			     const char *name)
> +{
> +	init_completion(&c->kobj_unregister);
> +
> +	return kobject_init_and_add(&c->kobj, &dm_bufio_ktype, parent, "%s",
> +				    name);
> +}
> +
> +/* Drop the sysfs reference and wait for the release method to run. */
> +static void dm_bufio_kobj_del(struct dm_bufio_client *c)
> +{
> +	kobject_put(&c->kobj);
> +	wait_for_completion(&c->kobj_unregister);
> +}
> +
> +int dm_bufio_client_sysfs_add(struct dm_bufio_client *c, struct kobject *parent,
> +			      const char *name)
> +{
> +	int r;
> +
> +	if (c->sysfs_added)
> +		return -EBUSY;
> +
> +	r = dm_bufio_kobj_add(c, parent, name);
> +	if (r) {
> +		dm_bufio_kobj_del(c);
> +		return r;
> +	}
> +
> +	c->sysfs_added = true;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dm_bufio_client_sysfs_add);
> +
>  /*
>   * Create the buffering interface
>   */
> @@ -2660,6 +2804,9 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
>  {
>  	unsigned int i;
>  
> +	if (c->sysfs_added)
> +		dm_bufio_kobj_del(c);
> +
>  	drop_buffers(c);
>  
>  	shrinker_free(c->shrinker);
> diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
> index 9bf3f805c43c..6d82f1200aeb 100644
> --- a/include/linux/dm-bufio.h
> +++ b/include/linux/dm-bufio.h
> @@ -17,6 +17,7 @@
>  
>  struct dm_bufio_client;
>  struct dm_buffer;
> +struct kobject;
>  
>  /*
>   * Flags for dm_bufio_client_create
> @@ -165,6 +166,13 @@ void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n);
>  void dm_bufio_set_retain_bytes(struct dm_bufio_client *c, unsigned long bytes);
>  unsigned long dm_bufio_get_retain_bytes(struct dm_bufio_client *c);
>  
> +/*
> + * Publish the client as <name> under <parent> in sysfs; removed in
> + * dm_bufio_client_destroy().
> + */
> +int dm_bufio_client_sysfs_add(struct dm_bufio_client *c, struct kobject *parent,
> +			      const char *name);
> +
>  unsigned int dm_bufio_get_block_size(struct dm_bufio_client *c);
>  sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
>  struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c);
> -- 
> 2.43.0
> 

