Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C38B26D4CA
	for <dm-devel@lists.linux.dev>; Sat, 11 Jul 2026 03:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783742042; cv=none; b=OH5jP1RFDL6H9L04kJuG5nz5XBiYjHv858bgj4n5BdyuajieB7C6c7EfrryjhOU2O2oNdIqHTuFBgE2TxqrFiLi0MfXowaED4o+BDTKHepo9TER1MELVnPIlDqy6pZRuwwoQbg43IfBE/oe8m5JPK4WSDamoKBRitH5O0X3iF54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783742042; c=relaxed/simple;
	bh=srPVJCsDCwJpreSZBjTL6r9CjCk7m3RghtL1c3fa7sM=;
	h=Message-Id:Mime-Version:Content-Type:References:Cc:From:Subject:
	 To:Date:In-Reply-To; b=hLHNRBDClZUfpaAYuSMnvkz1u87GFXGt/QQeDKyGMFAsw+dXTsY7bnq5FXmZNXKoVNxCu02+kywDUAVJnC8fym+EmQridMR18//7qWHrE7IrxpbNFBkfZPKmC1SWT8OWTjYiTJYJToOxbAvfv+TO9O47Jvbe/bwROQJ6XBQ7DWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=uSdVsj0p; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="uSdVsj0p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783742029;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=/7fwGyR6JGS0+B9Xw4mmP4HUvoxPU2abFXp4b8iR5uE=;
 b=uSdVsj0pSkHrHICtV7TkBhhKsgW6OFvaa+0UNQE1JpbSI/ofVmSn1wqh5haNHAfOlykt3C
 HQ3CHpQoDodBtKM3rrwz3BJLXlbJx0WkK0rgAgo0uOlgyp5YIKY6ZZl0MbmFiDBxiPKjDW
 lNyclDUlNExL0NI/cvKDsR0vu+w0bKJk48jC/uU5/HLY+W5Ty4pbDM/siD4uj/3GSfTNRO
 d21WVc734NvUMTKHZNs+rYgdRCokiDnXojE5T9w2Id+3VISpe5NuEelGJMEL9RNDvj5Dfo
 cHT02geXE7Mk2rSmRgAoU2JbKpZJJUcDfqNrptcg8rVdbOQfZrivMGInTQOiZw==
Message-Id: <66351561-519e-474b-9388-8944f7d77b44@fnnas.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
References: <20260624101353.2678126-1-chencheng@fnnas.com> <da94b991-fe62-4a8b-b448-c4ee226b6b4f@fygo.io>
Cc: <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: Re: [RFC PATCH] md,dm: caller-owned memalloc_noio token in mddev_suspend()/resume()
Received: from [192.168.8.91] ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 11:53:47 +0800
Content-Transfer-Encoding: quoted-printable
To: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>, 
	<dm-devel@lists.linux.dev>
Date: Sat, 11 Jul 2026 11:53:46 +0800
X-Lms-Return-Path: <lba+26a51be4c+8ff215+lists.linux.dev+chencheng@fnnas.com>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
In-Reply-To: <da94b991-fe62-4a8b-b448-c4ee226b6b4f@fygo.io>

=E5=9C=A8 2026/7/5 21:10, yu kuai =E5=86=99=E9=81=93:
> Hi,
>=20
> =E5=9C=A8 2026/6/24 18:13, Chen Cheng =E5=86=99=E9=81=93:
>> From: Chen Cheng <chencheng@fnnas.com>
>>
>> Save token as mddev-scoped in mddev->noio_flags cause PF_MEMALLOC_NOIO
>> leak into task A, while task B restores a token that it never saved.
>>
>> scenario:
>>
>> task A                          mddev                         task B
>> =3D=3D=3D=3D=3D=3D                          =3D=3D=3D=3D=3D=3D=3D       =
                =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> write suspend_lo
>> mddev_suspend()
>>                                   suspended =3D=3D 0
>>                                   drain active_io
>>                                   suspended =3D 1
>> A: noio_A =3D memalloc_noio_save()
>> A returns with PF_MEMALLOC_NOIO set
>>
>>                                                                 write su=
spend_hi
>>                                                                 mddev_su=
spend()
>>                                   suspended =3D=3D 1
>>                                   suspended =3D 2
>>                                                                 B return=
s
>>                                                                 (no save=
)
>>
>> mddev_resume()
>>                                   suspended =3D 1
>>                                   not last resume
>> A returns
>> A still has PF_MEMALLOC_NOIO   <-- leaked
>>
>>                                                                 mddev_re=
sume()
>>                                   suspended =3D 0
>>                                                                 memalloc=
_noio_restore(noio_A)
>>                                                                 (restore=
s A's token in B)
>>
>> Fixed by:
>>     - return each caller's noio_flags from mddev_suspend()
>>     - pass that token back into mddev_resume()
>>     - update the suspend-and-lock helpers to carry the token
>>     - store the token in struct raid_set for dm-raid paths where suspend
>>       and resume are paired across callbacks
>>
>> Validation:
>> repeatedly updates the array's suspend_lo and suspend_hi sysfs from many
>> concurrent userspace workers. That makes multiple tasks to call
>> mddev_suspend()/mddev_resume() concurrently.
>>
>> Each worker:
>>     - reads its initial /proc/self/stat flags and verifies that PF_MEMAL=
LOC_NOIO is not already
>>       set
>>     - writes 0 to either suspend_lo or suspend_hi
>>     - immediately reads its own task flags again
>>     - reports success if flags & PF_MEMALLOC_NOIO is true after the writ=
e returns
>>
>> Link: https://github.com/chencheng-fnnas/reproducer/blob/main/repro-md-n=
oio-token-leak.sh
>>
>> Fixes: 78f57ef9d50a ("md: use memalloc scope APIs in mddev_suspend()/mdd=
ev_resume()")
>>
>> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
>> ---
>>    drivers/md/dm-raid.c       |  7 ++--
>>    drivers/md/md-autodetect.c |  5 ++-
>>    drivers/md/md-bitmap.c     | 12 +++---
>>    drivers/md/md.c            | 85 ++++++++++++++++++++++---------------=
-
>>    drivers/md/md.h            | 23 ++++++-----
>>    drivers/md/raid5-cache.c   | 11 +++--
>>    drivers/md/raid5.c         | 25 ++++++-----
>>    7 files changed, 97 insertions(+), 71 deletions(-)
>>
>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>> index 8f5a5e1342a9..d89207e3722a 100644
>> --- a/drivers/md/dm-raid.c
>> +++ b/drivers/md/dm-raid.c
>> @@ -239,10 +239,11 @@ struct raid_set {
>>    	int raid_disks;
>>    	int delta_disks;
>>    	int data_offset;
>>    	int raid10_copies;
>>    	int requested_bitmap_chunk_sectors;
>> +	unsigned int suspend_noio_flags;
>>   =20
>>    	struct mddev md;
>>    	struct raid_type *raid_type;
>>   =20
>>    	sector_t array_sectors;
>> @@ -3251,11 +3252,11 @@ static int raid_ctr(struct dm_target *ti, unsign=
ed int argc, char **argv)
>>    	/* Start raid set read-only and assumed clean to change in raid_resu=
me() */
>>    	rs->md.ro =3D MD_RDONLY;
>>    	rs->md.in_sync =3D 1;
>>   =20
>>    	/* Has to be held on running the array */
>> -	mddev_suspend_and_lock_nointr(&rs->md);
>> +	mddev_suspend_and_lock_nointr(&rs->md, &rs->suspend_noio_flags);
>>   =20
>>    	/* Keep array frozen until resume. */
>>    	md_frozen_sync_thread(&rs->md);
>>   =20
>>    	r =3D md_run(&rs->md);
>> @@ -3863,11 +3864,11 @@ static void raid_postsuspend(struct dm_target *t=
i)
>>    		/*
>>    		 * sync_thread must be stopped during suspend, and writes have
>>    		 * to be stopped before suspending to avoid deadlocks.
>>    		 */
>>    		md_stop_writes(&rs->md);
>> -		mddev_suspend(&rs->md, false);
>> +		mddev_suspend(&rs->md, false, &rs->suspend_noio_flags);
>>    		rs->md.ro =3D MD_RDONLY;
>>    	}
>>    	clear_bit(MD_DM_SUSPENDING, &mddev->flags);
>>   =20
>>    }
>> @@ -4141,11 +4142,11 @@ static void raid_resume(struct dm_target *ti)
>>    						       lockdep_is_held(&mddev->reconfig_mutex)));
>>    		clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
>>    		mddev->ro =3D MD_RDWR;
>>    		mddev->in_sync =3D 0;
>>    		md_unfrozen_sync_thread(mddev);
>> -		mddev_unlock_and_resume(mddev);
>> +		mddev_unlock_and_resume(mddev, rs->suspend_noio_flags);
>>    	}
>>    }
>=20
> For mdraid, changes looks fine. However, for dm-raid, for example:
>=20
> dmsetup suspend ...
>=20
> In this case, array will be suspended while task returned to user. Take a=
 look at
> the commit to introduce memalloc_noio_save(), it's supposed to be called =
for mdraid
> arrays to allocate memory while array is suspended, I don't see why dm-ra=
id need it.
> So I'll suggest just bypass the memalloc_noio_save() for dm-raid where md=
dev_suspend()
> is not paired with mddev_resume() in the same task context.
>=20

Hi Kuai.

I check the commit you mentioned., and I truelly misused=20
memalloc_noio_save() in dmraid side, really thanks for point-out.

thanks,
cheng.

>>   =20
>>    static struct target_type raid_target =3D {
>>    	.name =3D "raid",
>> diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
>> index 4b80165afd23..58e062cd0580 100644
>> --- a/drivers/md/md-autodetect.c
>> +++ b/drivers/md/md-autodetect.c
>> @@ -126,10 +126,11 @@ static void __init md_setup_drive(struct md_setup_=
args *args)
>>    	dev_t devices[MD_SB_DISKS + 1], mdev;
>>    	struct mdu_array_info_s ainfo =3D { };
>>    	struct mddev *mddev;
>>    	int err =3D 0, i;
>>    	char name[16];
>> +	unsigned int noio_flags;
>>   =20
>>    	if (args->partitioned) {
>>    		mdev =3D MKDEV(mdp_major, args->minor << MdpMinorShift);
>>    		sprintf(name, "md_d%d", args->minor);
>>    	} else {
>> @@ -173,11 +174,11 @@ static void __init md_setup_drive(struct md_setup_=
args *args)
>>    	if (IS_ERR(mddev)) {
>>    		pr_err("md: md_alloc failed - cannot start array %s\n", name);
>>    		return;
>>    	}
>>   =20
>> -	err =3D mddev_suspend_and_lock(mddev);
>> +	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
>>    	if (err) {
>>    		pr_err("md: failed to lock array %s\n", name);
>>    		goto out_mddev_put;
>>    	}
>>   =20
>> @@ -219,11 +220,11 @@ static void __init md_setup_drive(struct md_setup_=
args *args)
>>    	if (!err)
>>    		err =3D do_md_run(mddev);
>>    	if (err)
>>    		pr_warn("md: starting %s failed\n", name);
>>    out_unlock:
>> -	mddev_unlock_and_resume(mddev);
>> +	mddev_unlock_and_resume(mddev, noio_flags);
>>    out_mddev_put:
>>    	mddev_put(mddev);
>>    }
>>   =20
>>    static int __init raid_setup(char *str)
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index 028b9ca8ce52..74b7f569a3f4 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -2620,13 +2620,14 @@ location_show(struct mddev *mddev, char *page)
>>    }
>>   =20
>>    static ssize_t
>>    location_store(struct mddev *mddev, const char *buf, size_t len)
>>    {
>> +	unsigned int noio_flags;
>>    	int rv;
>>   =20
>> -	rv =3D mddev_suspend_and_lock(mddev);
>> +	rv =3D mddev_suspend_and_lock(mddev, &noio_flags);
>>    	if (rv)
>>    		return rv;
>>   =20
>>    	if (mddev->pers) {
>>    		if (mddev->recovery || mddev->sync_thread) {
>> @@ -2711,11 +2712,11 @@ location_store(struct mddev *mddev, const char *=
buf, size_t len)
>>    		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>>    		md_wakeup_thread(mddev->thread);
>>    	}
>>    	rv =3D 0;
>>    out:
>> -	mddev_unlock_and_resume(mddev);
>> +	mddev_unlock_and_resume(mddev, noio_flags);
>>    	if (rv)
>>    		return rv;
>>    	return len;
>>   =20
>>    merge_err:
>> @@ -2831,17 +2832,18 @@ backlog_store(struct mddev *mddev, const char *b=
uf, size_t len)
>>    {
>>    	unsigned long backlog;
>>    	unsigned long old_mwb =3D mddev->bitmap_info.max_write_behind;
>>    	struct md_rdev *rdev;
>>    	bool has_write_mostly =3D false;
>> +	unsigned int noio_flags;
>>    	int rv =3D kstrtoul(buf, 10, &backlog);
>>    	if (rv)
>>    		return rv;
>>    	if (backlog > COUNTER_MAX)
>>    		return -EINVAL;
>>   =20
>> -	rv =3D mddev_suspend_and_lock(mddev);
>> +	rv =3D mddev_suspend_and_lock(mddev, &noio_flags);
>>    	if (rv)
>>    		return rv;
>>   =20
>>    	/*
>>    	 * Without write mostly device, it doesn't make sense to set
>> @@ -2854,11 +2856,11 @@ backlog_store(struct mddev *mddev, const char *b=
uf, size_t len)
>>    		}
>>    	}
>>    	if (!has_write_mostly) {
>>    		pr_warn_ratelimited("%s: can't set backlog, no write mostly device =
available\n",
>>    				    mdname(mddev));
>> -		mddev_unlock(mddev);
>> +		mddev_unlock_and_resume(mddev, noio_flags);
>>    		return -EINVAL;
>>    	}
>>   =20
>>    	mddev->bitmap_info.max_write_behind =3D backlog;
>>    	if (!backlog && mddev->serial_info_pool) {
>> @@ -2871,11 +2873,11 @@ backlog_store(struct mddev *mddev, const char *b=
uf, size_t len)
>>    			mddev_create_serial_pool(mddev, rdev);
>>    	}
>>    	if (old_mwb !=3D backlog)
>>    		bitmap_update_sb(mddev->bitmap);
>>   =20
>> -	mddev_unlock_and_resume(mddev);
>> +	mddev_unlock_and_resume(mddev, noio_flags);
>>    	return len;
>>    }
>>   =20
>>    static struct md_sysfs_entry bitmap_backlog =3D
>>    __ATTR(backlog, S_IRUGO|S_IWUSR, backlog_show, backlog_store);
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 1377c407614c..86d938dee50a 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -459,11 +459,12 @@ static void md_submit_bio(struct bio *bio)
>>   =20
>>    /*
>>     * Make sure no new requests are submitted to the device, and any req=
uests that
>>     * have been submitted are completely handled.
>>     */
>> -int mddev_suspend(struct mddev *mddev, bool interruptible)
>> +int mddev_suspend(struct mddev *mddev, bool interruptible,
>> +		  unsigned int *noio_flags)
>>    {
>>    	int err =3D 0;
>>   =20
>>    	/*
>>    	 * hold reconfig_mutex to wait for normal io will deadlock, because
>> @@ -478,10 +479,11 @@ int mddev_suspend(struct mddev *mddev, bool interr=
uptible)
>>    		mutex_lock(&mddev->suspend_mutex);
>>    	if (err)
>>    		return err;
>>   =20
>>    	if (mddev->suspended) {
>> +		*noio_flags =3D memalloc_noio_save();
>>    		WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
>>    		mutex_unlock(&mddev->suspend_mutex);
>>    		return 0;
>>    	}
>>   =20
>> @@ -515,31 +517,30 @@ int mddev_suspend(struct mddev *mddev, bool interr=
uptible)
>>    	 * prevent deadlock.
>>    	 */
>>    	WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
>>   =20
>>    	/* restrict memory reclaim I/O during raid array is suspend */
>> -	mddev->noio_flag =3D memalloc_noio_save();
>> +	*noio_flags =3D memalloc_noio_save();
>>   =20
>>    	mutex_unlock(&mddev->suspend_mutex);
>>    	return 0;
>>    }
>>    EXPORT_SYMBOL_GPL(mddev_suspend);
>>   =20
>> -static void __mddev_resume(struct mddev *mddev, bool recovery_needed)
>> +static void __mddev_resume(struct mddev *mddev, bool recovery_needed,
>> +			   unsigned int noio_flags)
>>    {
>>    	lockdep_assert_not_held(&mddev->reconfig_mutex);
>>   =20
>>    	mutex_lock(&mddev->suspend_mutex);
>> +	memalloc_noio_restore(noio_flags);
>>    	WRITE_ONCE(mddev->suspended, mddev->suspended - 1);
>>    	if (mddev->suspended) {
>>    		mutex_unlock(&mddev->suspend_mutex);
>>    		return;
>>    	}
>>   =20
>> -	/* entred the memalloc scope from mddev_suspend() */
>> -	memalloc_noio_restore(mddev->noio_flag);
>> -
>>    	percpu_ref_resurrect(&mddev->active_io);
>>    	wake_up(&mddev->sb_wait);
>>   =20
>>    	if (recovery_needed)
>>    		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>> @@ -547,13 +548,13 @@ static void __mddev_resume(struct mddev *mddev, bo=
ol recovery_needed)
>>    	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape=
 */
>>   =20
>>    	mutex_unlock(&mddev->suspend_mutex);
>>    }
>>   =20
>> -void mddev_resume(struct mddev *mddev)
>> +void mddev_resume(struct mddev *mddev, unsigned int noio_flags)
>>    {
>> -	return __mddev_resume(mddev, true);
>> +	return __mddev_resume(mddev, true, noio_flags);
>>    }
>>    EXPORT_SYMBOL_GPL(mddev_resume);
>>   =20
>>    /* sync bdev before setting device to readonly or stopping raid*/
>>    static int mddev_set_closing_and_sync_blockdev(struct mddev *mddev, i=
nt opener_num)
>> @@ -3737,10 +3738,11 @@ rdev_attr_store(struct kobject *kobj, struct att=
ribute *attr,
>>    {
>>    	struct rdev_sysfs_entry *entry =3D container_of(attr, struct rdev_sy=
sfs_entry, attr);
>>    	struct md_rdev *rdev =3D container_of(kobj, struct md_rdev, kobj);
>>    	struct kernfs_node *kn =3D NULL;
>>    	bool suspend =3D false;
>> +	unsigned int noio_flags =3D 0;
>>    	ssize_t rv;
>>    	struct mddev *mddev =3D READ_ONCE(rdev->mddev);
>>   =20
>>    	if (!entry->store)
>>    		return -EIO;
>> @@ -3756,17 +3758,17 @@ rdev_attr_store(struct kobject *kobj, struct att=
ribute *attr,
>>    		    cmd_match(page, "writemostly") ||
>>    		    cmd_match(page, "-writemostly"))
>>    			suspend =3D true;
>>    	}
>>   =20
>> -	rv =3D suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
>> +	rv =3D suspend ? mddev_suspend_and_lock(mddev, &noio_flags) : mddev_lo=
ck(mddev);
>>    	if (!rv) {
>>    		if (rdev->mddev =3D=3D NULL)
>>    			rv =3D -ENODEV;
>>    		else
>>    			rv =3D entry->store(rdev, page, length);
>> -		suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
>> +		suspend ? mddev_unlock_and_resume(mddev, noio_flags) : mddev_unlock(m=
ddev);
>>    	}
>>   =20
>>    	if (kn)
>>    		sysfs_unbreak_active_protection(kn);
>>   =20
>> @@ -4049,15 +4051,16 @@ level_store(struct mddev *mddev, const char *buf=
, size_t len)
>>    	size_t slen =3D len;
>>    	struct md_personality *pers, *oldpers;
>>    	long level;
>>    	void *priv, *oldpriv;
>>    	struct md_rdev *rdev;
>> +	unsigned int noio_flags;
>>   =20
>>    	if (slen =3D=3D 0 || slen >=3D sizeof(clevel))
>>    		return -EINVAL;
>>   =20
>> -	rv =3D mddev_suspend_and_lock(mddev);
>> +	rv =3D mddev_suspend_and_lock(mddev, &noio_flags);
>>    	if (rv)
>>    		return rv;
>>   =20
>>    	if (mddev->pers =3D=3D NULL) {
>>    		memcpy(mddev->clevel, buf, slen);
>> @@ -4231,11 +4234,11 @@ level_store(struct mddev *mddev, const char *buf=
, size_t len)
>>    		md_update_sb(mddev, 1);
>>    	sysfs_notify_dirent_safe(mddev->sysfs_level);
>>    	md_new_event();
>>    	rv =3D len;
>>    out_unlock:
>> -	mddev_unlock_and_resume(mddev);
>> +	mddev_unlock_and_resume(mddev, noio_flags);
>>    	return rv;
>>    }
>>   =20
>>    static struct md_sysfs_entry md_level =3D
>>    __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
>> @@ -4410,17 +4413,18 @@ static int update_raid_disks(struct mddev *mddev=
, int raid_disks);
>>   =20
>>    static ssize_t
>>    raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
>>    {
>>    	unsigned int n;
>> +	unsigned int noio_flags;
>>    	int err;
>>   =20
>>    	err =3D kstrtouint(buf, 10, &n);
>>    	if (err < 0)
>>    		return err;
>>   =20
>> -	err =3D mddev_suspend_and_lock(mddev);
>> +	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
>>    	if (err)
>>    		return err;
>>    	if (mddev->pers) {
>>    		if (n !=3D mddev->raid_disks)
>>    			err =3D update_raid_disks(mddev, n);
>> @@ -4442,11 +4446,11 @@ raid_disks_store(struct mddev *mddev, const char=
 *buf, size_t len)
>>    		mddev->raid_disks =3D n;
>>    		mddev->reshape_backwards =3D (mddev->delta_disks < 0);
>>    	} else
>>    		mddev->raid_disks =3D n;
>>    out_unlock:
>> -	mddev_unlock_and_resume(mddev);
>> +	mddev_unlock_and_resume(mddev, noio_flags);
>>    	return err ? err : len;
>>    }
>>    static struct md_sysfs_entry md_raid_disks =3D
>>    __ATTR(raid_disks, S_IRUGO|S_IWUSR, raid_disks_show, raid_disks_store=
);
>>   =20
>> @@ -4822,10 +4826,11 @@ new_dev_store(struct mddev *mddev, const char *b=
uf, size_t len)
>>    	char *e;
>>    	int major =3D simple_strtoul(buf, &e, 10);
>>    	int minor;
>>    	dev_t dev;
>>    	struct md_rdev *rdev;
>> +	unsigned int noio_flags;
>>    	int err;
>>   =20
>>    	if (!*buf || *e !=3D ':' || !e[1] || e[1] =3D=3D '\n')
>>    		return -EINVAL;
>>    	minor =3D simple_strtoul(e+1, &e, 10);
>> @@ -4834,11 +4839,11 @@ new_dev_store(struct mddev *mddev, const char *b=
uf, size_t len)
>>    	dev =3D MKDEV(major, minor);
>>    	if (major !=3D MAJOR(dev) ||
>>    	    minor !=3D MINOR(dev))
>>    		return -EOVERFLOW;
>>   =20
>> -	err =3D mddev_suspend_and_lock(mddev);
>> +	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
>>    	if (err)
>>    		return err;
>>    	if (mddev->persistent) {
>>    		rdev =3D md_import_device(dev, mddev->major_version,
>>    					mddev->minor_version);
>> @@ -4855,18 +4860,18 @@ new_dev_store(struct mddev *mddev, const char *b=
uf, size_t len)
>>    		rdev =3D md_import_device(dev, -2, -1);
>>    	else
>>    		rdev =3D md_import_device(dev, -1, -1);
>>   =20
>>    	if (IS_ERR(rdev)) {
>> -		mddev_unlock_and_resume(mddev);
>> +		mddev_unlock_and_resume(mddev, noio_flags);
>>    		return PTR_ERR(rdev);
>>    	}
>>    	err =3D bind_rdev_to_array(rdev, mddev);
>>     out:
>>    	if (err)
>>    		export_rdev(rdev);
>> -	mddev_unlock_and_resume(mddev);
>> +	mddev_unlock_and_resume(mddev, noio_flags);
>>    	if (!err)
>>    		md_new_event();
>>    	return err ? err : len;
>>    }
>>   =20
>> @@ -5257,28 +5262,29 @@ static int mddev_start_reshape(struct mddev *mdd=
ev)
>>    static ssize_t
>>    action_store(struct mddev *mddev, const char *page, size_t len)
>>    {
>>    	int ret;
>>    	enum sync_action action;
>> +	unsigned int noio_flags =3D 0;
>>   =20
>>    	if (!mddev->pers || !mddev->pers->sync_request)
>>    		return -EINVAL;
>>   =20
>>    	action =3D md_sync_action_by_name(page);
>>    retry:
>>    	if (work_busy(&mddev->sync_work))
>>    		flush_work(&mddev->sync_work);
>>   =20
>>    	ret =3D (action =3D=3D ACTION_RESHAPE) ?
>> -		mddev_suspend_and_lock(mddev) :
>> +		mddev_suspend_and_lock(mddev, &noio_flags) :
>>    		mddev_lock(mddev);
>>    	if (ret)
>>    		return ret;
>>   =20
>>    	if (work_busy(&mddev->sync_work)) {
>>    		if (action =3D=3D ACTION_RESHAPE)
>> -			mddev_unlock_and_resume(mddev);
>> +			mddev_unlock_and_resume(mddev, noio_flags);
>>    		else
>>    			mddev_unlock(mddev);
>>    		goto retry;
>>    	}
>>   =20
>> @@ -5349,11 +5355,11 @@ action_store(struct mddev *mddev, const char *pa=
ge, size_t len)
>>    	sysfs_notify_dirent_safe(mddev->sysfs_action);
>>    	ret =3D len;
>>   =20
>>    out:
>>    	if (action =3D=3D ACTION_RESHAPE)
>> -		mddev_unlock_and_resume(mddev);
>> +		mddev_unlock_and_resume(mddev, noio_flags);
>>    	else
>>    		mddev_unlock(mddev);
>>    	return ret;
>>    }
>>   =20
>> @@ -5640,24 +5646,25 @@ suspend_lo_show(struct mddev *mddev, char *page)
>>   =20
>>    static ssize_t
>>    suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
>>    {
>>    	unsigned long long new;
>> +	unsigned int noio_flags;
>>    	int err;
>>   =20
>>    	err =3D kstrtoull(buf, 10, &new);
>>    	if (err < 0)
>>    		return err;
>>    	if (new !=3D (sector_t)new)
>>    		return -EINVAL;
>>   =20
>> -	err =3D mddev_suspend(mddev, true);
>> +	err =3D mddev_suspend(mddev, true, &noio_flags);
>>    	if (err)
>>    		return err;
>>   =20
>>    	WRITE_ONCE(mddev->suspend_lo, new);
>> -	mddev_resume(mddev);
>> +	mddev_resume(mddev, noio_flags);
>>   =20
>>    	return len;
>>    }
>>    static struct md_sysfs_entry md_suspend_lo =3D
>>    __ATTR(suspend_lo, S_IRUGO|S_IWUSR, suspend_lo_show, suspend_lo_store=
);
>> @@ -5671,24 +5678,25 @@ suspend_hi_show(struct mddev *mddev, char *page)
>>   =20
>>    static ssize_t
>>    suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
>>    {
>>    	unsigned long long new;
>> +	unsigned int noio_flags;
>>    	int err;
>>   =20
>>    	err =3D kstrtoull(buf, 10, &new);
>>    	if (err < 0)
>>    		return err;
>>    	if (new !=3D (sector_t)new)
>>    		return -EINVAL;
>>   =20
>> -	err =3D mddev_suspend(mddev, true);
>> +	err =3D mddev_suspend(mddev, true, &noio_flags);
>>    	if (err)
>>    		return err;
>>   =20
>>    	WRITE_ONCE(mddev->suspend_hi, new);
>> -	mddev_resume(mddev);
>> +	mddev_resume(mddev, noio_flags);
>>   =20
>>    	return len;
>>    }
>>    static struct md_sysfs_entry md_suspend_hi =3D
>>    __ATTR(suspend_hi, S_IRUGO|S_IWUSR, suspend_hi_show, suspend_hi_store=
);
>> @@ -5928,19 +5936,20 @@ static ssize_t serialize_policy_show(struct mdde=
v *mddev, char *page)
>>    static ssize_t
>>    serialize_policy_store(struct mddev *mddev, const char *buf, size_t l=
en)
>>    {
>>    	int err;
>>    	bool value;
>> +	unsigned int noio_flags;
>>   =20
>>    	err =3D kstrtobool(buf, &value);
>>    	if (err)
>>    		return err;
>>   =20
>>    	if (value =3D=3D test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
>>    		return len;
>>   =20
>> -	err =3D mddev_suspend_and_lock(mddev);
>> +	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
>>    	if (err)
>>    		return err;
>>    	if (mddev->pers =3D=3D NULL || (mddev->pers->head.id !=3D ID_RAID1))=
 {
>>    		pr_err("md: serialize_policy is only effective for raid1\n");
>>    		err =3D -EINVAL;
>> @@ -5953,11 +5962,11 @@ serialize_policy_store(struct mddev *mddev, cons=
t char *buf, size_t len)
>>    	} else {
>>    		mddev_destroy_serial_pool(mddev, NULL);
>>    		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
>>    	}
>>    unlock:
>> -	mddev_unlock_and_resume(mddev);
>> +	mddev_unlock_and_resume(mddev, noio_flags);
>>    	return err ?: len;
>>    }
>>   =20
>>    static struct md_sysfs_entry md_serialize_policy =3D
>>    __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
>> @@ -6263,21 +6272,22 @@ EXPORT_SYMBOL_GPL(mddev_stack_new_rdev);
>>   =20
>>    /* update the optimal I/O size after a reshape */
>>    void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes=
)
>>    {
>>    	struct queue_limits lim;
>> +	unsigned int noio_flags;
>>   =20
>>    	if (mddev_is_dm(mddev))
>>    		return;
>>   =20
>>    	/* don't bother updating io_opt if we can't suspend the array */
>> -	if (mddev_suspend(mddev, false) < 0)
>> +	if (mddev_suspend(mddev, false, &noio_flags) < 0)
>>    		return;
>>    	lim =3D queue_limits_start_update(mddev->gendisk->queue);
>>    	lim.io_opt =3D lim.io_min * nr_stripes;
>>    	queue_limits_commit_update(mddev->gendisk->queue, &lim);
>> -	mddev_resume(mddev);
>> +	mddev_resume(mddev, noio_flags);
>>    }
>>    EXPORT_SYMBOL_GPL(mddev_update_io_opt);
>>   =20
>>    static void mddev_delayed_delete(struct work_struct *ws)
>>    {
>> @@ -7255,10 +7265,11 @@ static void autorun_array(struct mddev *mddev)
>>     */
>>    static void autorun_devices(int part)
>>    {
>>    	struct md_rdev *rdev0, *rdev, *tmp;
>>    	struct mddev *mddev;
>> +	unsigned int noio_flags;
>>   =20
>>    	pr_info("md: autorun ...\n");
>>    	while (!list_empty(&pending_raid_disks)) {
>>    		int unit;
>>    		dev_t dev;
>> @@ -7295,27 +7306,27 @@ static void autorun_devices(int part)
>>   =20
>>    		mddev =3D md_alloc(dev, NULL);
>>    		if (IS_ERR(mddev))
>>    			break;
>>   =20
>> -		if (mddev_suspend_and_lock(mddev))
>> +		if (mddev_suspend_and_lock(mddev, &noio_flags))
>>    			pr_warn("md: %s locked, cannot run\n", mdname(mddev));
>>    		else if (mddev->raid_disks || mddev->major_version
>>    			 || !list_empty(&mddev->disks)) {
>>    			pr_warn("md: %s already running, cannot run %pg\n",
>>    				mdname(mddev), rdev0->bdev);
>> -			mddev_unlock_and_resume(mddev);
>> +			mddev_unlock_and_resume(mddev, noio_flags);
>>    		} else {
>>    			pr_debug("md: created %s\n", mdname(mddev));
>>    			mddev->persistent =3D 1;
>>    			rdev_for_each_list(rdev, tmp, &candidates) {
>>    				list_del_init(&rdev->same_set);
>>    				if (bind_rdev_to_array(rdev, mddev))
>>    					export_rdev(rdev);
>>    			}
>>    			autorun_array(mddev);
>> -			mddev_unlock_and_resume(mddev);
>> +			mddev_unlock_and_resume(mddev, noio_flags);
>>    		}
>>    		/* on success, candidates will be empty, on error
>>    		 * it won't...
>>    		 */
>>    		rdev_for_each_list(rdev, tmp, &candidates) {
>> @@ -8329,10 +8340,11 @@ static int __md_set_array_info(struct mddev *mdd=
ev, void __user *argp)
>>   =20
>>    static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
>>    			unsigned int cmd, unsigned long arg)
>>    {
>>    	int err =3D 0;
>> +	unsigned int noio_flags =3D 0;
>>    	void __user *argp =3D (void __user *)arg;
>>    	struct mddev *mddev =3D NULL;
>>   =20
>>    	err =3D md_ioctl_valid(cmd);
>>    	if (err)
>> @@ -8380,11 +8392,11 @@ static int md_ioctl(struct block_device *bdev, b=
lk_mode_t mode,
>>    	}
>>   =20
>>    	if (!md_is_rdwr(mddev))
>>    		flush_work(&mddev->sync_work);
>>   =20
>> -	err =3D md_ioctl_need_suspend(cmd) ? mddev_suspend_and_lock(mddev) :
>> +	err =3D md_ioctl_need_suspend(cmd) ? mddev_suspend_and_lock(mddev, &no=
io_flags) :
>>    					   mddev_lock(mddev);
>>    	if (err) {
>>    		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
>>    			 err, cmd);
>>    		goto out;
>> @@ -8511,11 +8523,11 @@ static int md_ioctl(struct block_device *bdev, b=
lk_mode_t mode,
>>    unlock:
>>    	if (mddev->hold_active =3D=3D UNTIL_IOCTL &&
>>    	    err !=3D -EINVAL)
>>    		mddev->hold_active =3D 0;
>>   =20
>> -	md_ioctl_need_suspend(cmd) ? mddev_unlock_and_resume(mddev) :
>> +	md_ioctl_need_suspend(cmd) ? mddev_unlock_and_resume(mddev, noio_flags=
) :
>>    				     mddev_unlock(mddev);
>>   =20
>>    out:
>>    	if (cmd =3D=3D STOP_ARRAY_RO || (err && cmd =3D=3D STOP_ARRAY))
>>    		clear_bit(MD_CLOSING, &mddev->flags);
>> @@ -10180,20 +10192,21 @@ static bool md_choose_sync_action(struct mddev=
 *mddev, int *spares)
>>    static void md_start_sync(struct work_struct *ws)
>>    {
>>    	struct mddev *mddev =3D container_of(ws, struct mddev, sync_work);
>>    	int spares =3D 0;
>>    	bool suspend =3D false;
>> +	unsigned int noio_flags =3D 0;
>>    	char *name;
>>   =20
>>    	/*
>>    	 * If reshape is still in progress, spares won't be added or removed
>>    	 * from conf until reshape is done.
>>    	 */
>>    	if (mddev->reshape_position =3D=3D MaxSector &&
>>    	    md_spares_need_change(mddev)) {
>>    		suspend =3D true;
>> -		mddev_suspend(mddev, false);
>> +		mddev_suspend(mddev, false, &noio_flags);
>>    	}
>>   =20
>>    	mddev_lock_nointr(mddev);
>>    	if (!md_is_rdwr(mddev)) {
>>    		/*
>> @@ -10237,11 +10250,11 @@ static void md_start_sync(struct work_struct *=
ws)
>>    	 * not set it again. Otherwise, we may cause issue like this one:
>>    	 *     https://bugzilla.kernel.org/show_bug.cgi?id=3D218200
>>    	 * Therefore, use __mddev_resume(mddev, false).
>>    	 */
>>    	if (suspend)
>> -		__mddev_resume(mddev, false);
>> +		__mddev_resume(mddev, false, noio_flags);
>>    	md_wakeup_thread(mddev->sync_thread);
>>    	sysfs_notify_dirent_safe(mddev->sysfs_action);
>>    	md_new_event();
>>    	return;
>>   =20
>> @@ -10257,11 +10270,11 @@ static void md_start_sync(struct work_struct *=
ws)
>>    	 * not set it again. Otherwise, we may cause issue like this one:
>>    	 *     https://bugzilla.kernel.org/show_bug.cgi?id=3D218200
>>    	 * Therefore, use __mddev_resume(mddev, false).
>>    	 */
>>    	if (suspend)
>> -		__mddev_resume(mddev, false);
>> +		__mddev_resume(mddev, false, noio_flags);
>>   =20
>>    	wake_up(&resync_wait);
>>    	if (test_and_clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
>>    	    mddev->sysfs_action)
>>    		sysfs_notify_dirent_safe(mddev->sysfs_action);
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index d8daf0f75cbb..3337cd21eb30 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -619,11 +619,10 @@ struct mddev {
>>    	mempool_t *serial_info_pool;
>>    	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
>>    	struct md_cluster_info		*cluster_info;
>>    	struct md_cluster_operations *cluster_ops;
>>    	unsigned int			good_device_nr;	/* good device num within cluster rai=
d */
>> -	unsigned int			noio_flag; /* for memalloc scope API */
>>   =20
>>    	/*
>>    	 * Temporarily store rdev that will be finally removed when
>>    	 * reconfig_mutex is unlocked, protected by reconfig_mutex.
>>    	 */
>> @@ -953,12 +952,13 @@ extern void md_stop(struct mddev *mddev);
>>    extern void md_stop_writes(struct mddev *mddev);
>>    extern int md_rdev_init(struct md_rdev *rdev);
>>    extern void md_rdev_clear(struct md_rdev *rdev);
>>   =20
>>    extern bool md_handle_request(struct mddev *mddev, struct bio *bio);
>> -extern int mddev_suspend(struct mddev *mddev, bool interruptible);
>> -extern void mddev_resume(struct mddev *mddev);
>> +extern int mddev_suspend(struct mddev *mddev, bool interruptible,
>> +			 unsigned int *noio_flags);
>> +extern void mddev_resume(struct mddev *mddev, unsigned int noio_flags);
>>    extern void md_idle_sync_thread(struct mddev *mddev);
>>    extern void md_frozen_sync_thread(struct mddev *mddev);
>>    extern void md_unfrozen_sync_thread(struct mddev *mddev);
>>   =20
>>    extern void md_update_sb(struct mddev *mddev, int force);
>> @@ -999,35 +999,38 @@ static inline void mddev_check_write_zeroes(struct=
 mddev *mddev, struct bio *bio
>>    	if (bio_op(bio) =3D=3D REQ_OP_WRITE_ZEROES &&
>>    	    !bio->bi_bdev->bd_disk->queue->limits.max_write_zeroes_sectors)
>>    		mddev->gendisk->queue->limits.max_write_zeroes_sectors =3D 0;
>>    }
>>   =20
>> -static inline int mddev_suspend_and_lock(struct mddev *mddev)
>> +static inline int mddev_suspend_and_lock(struct mddev *mddev,
>> +					 unsigned int *noio_flags)
>>    {
>>    	int ret;
>>   =20
>> -	ret =3D mddev_suspend(mddev, true);
>> +	ret =3D mddev_suspend(mddev, true, noio_flags);
>>    	if (ret)
>>    		return ret;
>>   =20
>>    	ret =3D mddev_lock(mddev);
>>    	if (ret)
>> -		mddev_resume(mddev);
>> +		mddev_resume(mddev, *noio_flags);
>>   =20
>>    	return ret;
>>    }
>>   =20
>> -static inline void mddev_suspend_and_lock_nointr(struct mddev *mddev)
>> +static inline void mddev_suspend_and_lock_nointr(struct mddev *mddev,
>> +						 unsigned int *noio_flags)
>>    {
>> -	mddev_suspend(mddev, false);
>> +	mddev_suspend(mddev, false, noio_flags);
>>    	mddev_lock_nointr(mddev);
>>    }
>>   =20
>> -static inline void mddev_unlock_and_resume(struct mddev *mddev)
>> +static inline void mddev_unlock_and_resume(struct mddev *mddev,
>> +					   unsigned int noio_flags)
>>    {
>>    	mddev_unlock(mddev);
>> -	mddev_resume(mddev);
>> +	mddev_resume(mddev, noio_flags);
>>    }
>>   =20
>>    struct mdu_array_info_s;
>>    struct mdu_disk_info_s;
>>   =20
>> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>> index 7b7546bfa21f..6f8e3a624456 100644
>> --- a/drivers/md/raid5-cache.c
>> +++ b/drivers/md/raid5-cache.c
>> @@ -693,13 +693,15 @@ static void r5c_disable_writeback_async(struct wor=
k_struct *work)
>>    		   !READ_ONCE(conf->log) ||
>>    		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
>>   =20
>>    	log =3D READ_ONCE(conf->log);
>>    	if (log) {
>> -		mddev_suspend(mddev, false);
>> +		unsigned int noio_flags;
>> +
>> +		mddev_suspend(mddev, false, &noio_flags);
>>    		log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
>> -		mddev_resume(mddev);
>> +		mddev_resume(mddev, noio_flags);
>>    	}
>>    }
>>   =20
>>    static void r5l_submit_current_io(struct r5l_log *log)
>>    {
>> @@ -2603,10 +2605,11 @@ EXPORT_SYMBOL(r5c_journal_mode_set);
>>    static ssize_t r5c_journal_mode_store(struct mddev *mddev,
>>    				      const char *page, size_t length)
>>    {
>>    	int mode =3D ARRAY_SIZE(r5c_journal_mode_str);
>>    	size_t len =3D length;
>> +	unsigned int noio_flags;
>>    	int ret;
>>   =20
>>    	if (len < 2)
>>    		return -EINVAL;
>>   =20
>> @@ -2615,15 +2618,15 @@ static ssize_t r5c_journal_mode_store(struct mdd=
ev *mddev,
>>   =20
>>    	while (mode--)
>>    		if (strlen(r5c_journal_mode_str[mode]) =3D=3D len &&
>>    		    !strncmp(page, r5c_journal_mode_str[mode], len))
>>    			break;
>> -	ret =3D mddev_suspend_and_lock(mddev);
>> +	ret =3D mddev_suspend_and_lock(mddev, &noio_flags);
>>    	if (ret)
>>    		return ret;
>>    	ret =3D r5c_journal_mode_set(mddev, mode);
>> -	mddev_unlock_and_resume(mddev);
>> +	mddev_unlock_and_resume(mddev, noio_flags);
>>    	return ret ?: length;
>>    }
>>   =20
>>    struct md_sysfs_entry
>>    r5c_journal_mode =3D __ATTR(journal_mode, 0644,
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 65ae7d8930fc..6062c4b62cc8 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -6992,11 +6992,11 @@ raid5_show_stripe_size(struct mddev  *mddev, cha=
r *page)
>>    #if PAGE_SIZE !=3D DEFAULT_STRIPE_SIZE
>>    static ssize_t
>>    raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_=
t len)
>>    {
>>    	struct r5conf *conf;
>> -	unsigned long new;
>> +	unsigned long new, noio_flags;
>>    	int err;
>>    	int size;
>>   =20
>>    	if (len >=3D PAGE_SIZE)
>>    		return -EINVAL;
>> @@ -7011,11 +7011,11 @@ raid5_store_stripe_size(struct mddev  *mddev, co=
nst char *page, size_t len)
>>    	if (new % DEFAULT_STRIPE_SIZE !=3D 0 ||
>>    			new > PAGE_SIZE || new =3D=3D 0 ||
>>    			new !=3D roundup_pow_of_two(new))
>>    		return -EINVAL;
>>   =20
>> -	err =3D mddev_suspend_and_lock(mddev);
>> +	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
>>    	if (err)
>>    		return err;
>>   =20
>>    	conf =3D mddev->private;
>>    	if (!conf) {
>> @@ -7049,11 +7049,11 @@ raid5_store_stripe_size(struct mddev  *mddev, co=
nst char *page, size_t len)
>>    		err =3D -ENOMEM;
>>    	}
>>    	mutex_unlock(&conf->cache_size_mutex);
>>   =20
>>    out_unlock:
>> -	mddev_unlock_and_resume(mddev);
>> +	mddev_unlock_and_resume(mddev, noio_flags);
>>    	return err ?: len;
>>    }
>>   =20
>>    static struct md_sysfs_entry
>>    raid5_stripe_size =3D __ATTR(stripe_size, 0644,
>> @@ -7127,19 +7127,20 @@ raid5_show_skip_copy(struct mddev *mddev, char *=
page)
>>    static ssize_t
>>    raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t l=
en)
>>    {
>>    	struct r5conf *conf;
>>    	unsigned long new;
>> +	unsigned int noio_flags;
>>    	int err;
>>   =20
>>    	if (len >=3D PAGE_SIZE)
>>    		return -EINVAL;
>>    	if (kstrtoul(page, 10, &new))
>>    		return -EINVAL;
>>    	new =3D !!new;
>>   =20
>> -	err =3D mddev_suspend_and_lock(mddev);
>> +	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
>>    	if (err)
>>    		return err;
>>    	conf =3D mddev->private;
>>    	if (!conf)
>>    		err =3D -ENODEV;
>> @@ -7152,11 +7153,11 @@ raid5_store_skip_copy(struct mddev *mddev, const=
 char *page, size_t len)
>>    			lim.features |=3D BLK_FEAT_STABLE_WRITES;
>>    		else
>>    			lim.features &=3D ~BLK_FEAT_STABLE_WRITES;
>>    		err =3D queue_limits_commit_update(q, &lim);
>>    	}
>> -	mddev_unlock_and_resume(mddev);
>> +	mddev_unlock_and_resume(mddev, noio_flags);
>>    	return err ?: len;
>>    }
>>   =20
>>    static struct md_sysfs_entry
>>    raid5_skip_copy =3D __ATTR(skip_copy, S_IRUGO | S_IWUSR,
>> @@ -7195,10 +7196,11 @@ static int alloc_thread_groups(struct r5conf *co=
nf, int cnt,
>>    static ssize_t
>>    raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, s=
ize_t len)
>>    {
>>    	struct r5conf *conf;
>>    	unsigned int new;
>> +	unsigned int noio_flags;
>>    	int err;
>>    	struct r5worker_group *new_groups, *old_groups;
>>    	int group_cnt;
>>   =20
>>    	if (len >=3D PAGE_SIZE)
>> @@ -7207,16 +7209,16 @@ raid5_store_group_thread_cnt(struct mddev *mddev=
, const char *page, size_t len)
>>    		return -EINVAL;
>>    	/* 8192 should be big enough */
>>    	if (new > 8192)
>>    		return -EINVAL;
>>   =20
>> -	err =3D mddev_suspend_and_lock(mddev);
>> +	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
>>    	if (err)
>>    		return err;
>>    	conf =3D mddev->private;
>>    	if (!conf) {
>> -		mddev_unlock_and_resume(mddev);
>> +		mddev_unlock_and_resume(mddev, noio_flags);
>>    		return -ENODEV;
>>    	}
>>    	raid5_quiesce(mddev, true);
>>   =20
>>    	if (new !=3D conf->worker_cnt_per_group) {
>> @@ -7237,11 +7239,11 @@ raid5_store_group_thread_cnt(struct mddev *mddev=
, const char *page, size_t len)
>>    			kfree(old_groups);
>>    		}
>>    	}
>>   =20
>>    	raid5_quiesce(mddev, false);
>> -	mddev_unlock_and_resume(mddev);
>> +	mddev_unlock_and_resume(mddev, noio_flags);
>>   =20
>>    	return err ?: len;
>>    }
>>   =20
>>    static struct md_sysfs_entry
>> @@ -8940,18 +8942,19 @@ static void *raid6_takeover(struct mddev *mddev)
>>    }
>>   =20
>>    static int raid5_change_consistency_policy(struct mddev *mddev, const=
 char *buf)
>>    {
>>    	struct r5conf *conf;
>> +	unsigned int noio_flags;
>>    	int err;
>>   =20
>> -	err =3D mddev_suspend_and_lock(mddev);
>> +	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
>>    	if (err)
>>    		return err;
>>    	conf =3D mddev->private;
>>    	if (!conf) {
>> -		mddev_unlock_and_resume(mddev);
>> +		mddev_unlock_and_resume(mddev, noio_flags);
>>    		return -ENODEV;
>>    	}
>>   =20
>>    	if (strncmp(buf, "ppl", 3) =3D=3D 0) {
>>    		/* ppl only works with RAID 5 */
>> @@ -8990,11 +8993,11 @@ static int raid5_change_consistency_policy(struc=
t mddev *mddev, const char *buf)
>>    	}
>>   =20
>>    	if (!err)
>>    		md_update_sb(mddev, 1);
>>   =20
>> -	mddev_unlock_and_resume(mddev);
>> +	mddev_unlock_and_resume(mddev, noio_flags);
>>   =20
>>    	return err;
>>    }
>>   =20
>>    static int raid5_start(struct mddev *mddev)
>
