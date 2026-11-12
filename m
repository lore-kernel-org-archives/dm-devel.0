Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794449259;
	b=yTPRuOfWEhum+uiw7he6znh3XKTa9qtbHgXFhFsnQRFIG/E42DojmDUDomk0d3NyElqY
	 Qk10a44XnRZ2/4Pn87xHl4CUZI5tI2Xjo7dMFKQUt8rPpByfxM2LTpdU7UOWcgSbFzHXn
	 rp1wtRbbVzUOGVxizS0YVHPp9+7Vi2h8uJ0qmrrBNQ1EBTxeX+EYjKiM/12Pwg4g8d2UV
	 FuoPZRSysNeVNn5lK++VhhQeUzkJCC3NBIIK4MNUXrq9NpgZCzNNzN6JitbNl2bVWpe+K
	 xg/7bynKgzYufiDV2w9o11rXkVoZiVOpcdDwdm5yUo4wIcjw3DC/YTRSBYMPcA5vpew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794449259;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5R+6abQequBgLmMup9y18eMS4h2za/FST8uS5tLLUC4=;
	b=1HBvK38cA3C+vFtFlZB/R7VKJ6DyBLq0NubfxkdusJoIhnxXzHv2Z4MSDBoosKalxO2n
	 CrYMxynoMR7noZos1aOavjFKYsKcCnvFkk5Looul81rmbYFJlJ8nHiF3H/ntzMmaBKnor
	 ww2JquLADsC5Mo3fpmqEoOOhRf78/bYVmi9P4+R9wq2INg8ejLAUA45CCNDRntDEpuoI9
	 S/oCtsZT2g2uNENOThGSGKOm0Zg2/BUvFzrX6TLPSjdaTrqtLirp5DdbEan+dl7p8nr3F
	 ecIi9sOslaYY0N7pWpfxfTeTitEgHD3EC9KtZcSfqVY8NZDiYhlX8PWzNADDAnhUJ0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ck4hArrN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542CD606A31C;
	Thu, 12 Nov 2026 02:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ck4hArrN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288201F00A05;
	Thu, 12 Nov 2026 02:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794449258;
	bh=5R+6abQequBgLmMup9y18eMS4h2za/FST8uS5tLLUC4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ck4hArrNn+1zXR53NLzBzEQj8tgJpEJvkTUtPkvBl2PmfCYO0fB/xxR6KPygqYVwC
	 1kmRob4TdAtawL0Jxc5aX2W4/LRzFss01rfpAq+GVmPXCESRT0nVfTU72TbpSnyLeG
	 gpPINPl5bcZcwnHvvaWleh5bDsWCYH8vk6Okp6bOrLyE/iNQye3K63lVZZDS198o21
	 9b5jT+02SQWEl1jOC9YPuvIeLg3qTVZz54ZFeAvHqQXvCOl77udTGgK0tYEwGQTpDy
	 l0LjmIu1Ur/iQCs5Wh1mzIgm8n7C85OxEjokpyWCafkIG9lJgVMCeW0ZdHaROAMhNs
	 4avWACuYJWv+w==
Message-ID: <sashiko-outbox-210153@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5] md: fix sync_work vs array teardown races
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>, song@kernel.org, yukuai@fygo.io, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev, magiclinan@didiglobal.com, xiao@kernel.org, linux-raid@vger.kernel.org, "Li
 Youhong" <liyouhong@kylinos.cn>, syzbot+a53c2918175b36cfd601@syzkaller.appspotmail.com
In-Reply-To: <20261112013523.120428-1-dayou5941@163.com>
References: <20261112013523.120428-1-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 02:07:37 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] dm-raid: use-after-free in raid_dtr() due to work_pending()
  check before flush_work()
- [Medium] md: stop_sync_thread() hangs on new sync when md_start_sync()
  aborts
--

commit 232add857e22becb764a00281d703c45b875fced
Author: Li Youhong <liyouhong@kylinos.cn>

md: fix sync_work vs array teardown races

This commit stops the sync thread and flushes sync_work during md_stop(),
flushes event_work on the raid_ctr() error path, and checks
MD_RECOVERY_FROZEN on the read-only path in md_check_recovery().

> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index ac019a0f5a929..f82c09d858de3 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3319,6 +3319,13 @@ static int raid_ctr(struct dm_target *ti, unsigned=
 int argc, char **argv)
>  	md_stop(&rs->md);
>  	mddev_unlock(&rs->md);
>  bad:
> +	/*
> +	 * md_stop() may drop reconfig_mutex so mddev->thread can run
> +	 * md_reap_sync_thread() and queue event_work; wait for it before
> +	 * freeing raid_set. Skip if INIT_WORK has not run yet.
> +	 */
> +	if (rs->md.event_work.func)
> +		flush_work(&rs->md.event_work);
>  	raid_set_free(rs);
> =20
>  	return r;

[Severity: High]
Does raid_dtr() also need an unconditional flush_work(&rs->md.event_work)
instead of gating it on work_pending()?

drivers/md/dm-raid.c:raid_dtr() {
	...
	if (work_pending(&rs->md.event_work))
		flush_work(&rs->md.event_work);
	raid_set_free(rs);
}

When md_stop() drops reconfig_mutex in raid_dtr(), mddev->thread can run
md_reap_sync_thread() and queue event_work.  Once a worker dequeues
event_work to run do_table_event(), WORK_STRUCT_PENDING_BIT is cleared:

CPU0                              kworker (md_misc_wq)
raid_dtr()
  md_stop(&rs->md)
    stop_sync_thread()
      mddev_unlock()
      /* md_reap_sync_thread()
         queues event_work */
                                  process_one_work()
                                    /* clears PENDING_BIT */
                                    do_table_event()
  if (work_pending(&event_work))
    /* false, skips flush_work */
  raid_set_free(rs)
    kfree(rs)
                                      dm_table_event(rs->ti->table)
                                        <-- use-after-free

Calling flush_work(&rs->md.event_work) unconditionally in raid_dtr() avoids
freeing rs while do_table_event() is still running.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..a33075f1b8324 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5199,7 +5199,14 @@ static void stop_sync_thread(struct mddev *mddev, =
bool locked)
>  {
>  	int sync_seq =3D atomic_read(&mddev->sync_seq);
> =20
> -	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> +	/*
> +	 * If nothing is in flight, keep reconfig_mutex when locked so
> +	 * callers such as do_md_stop() cannot race with do_md_run().
> +	 * work_busy() is required: md_start_sync() may clear RUNNING and
> +	 * still use mddev after unlocking.
> +	 */
> +	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
> +	    !work_busy(&mddev->sync_work)) {
>  		if (!locked)
>  			mddev_unlock(mddev);
>  		return;
> @@ -5207,14 +5214,20 @@ static void stop_sync_thread(struct mddev *mddev,=
 bool locked)
> =20
>  	mddev_unlock(mddev);
> =20
> -	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> +		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +		/*
> +		 * Thread might be blocked waiting for metadata update which
> +		 * will now never happen
> +		 */
> +		md_wakeup_thread_directly(&mddev->sync_thread);
> +	}
>  	/*
> -	 * Thread might be blocked waiting for metadata update which will now
> -	 * never happen
> +	 * md_start_sync() may still use mddev after unlocking. Always
> +	 * flush so teardown waits for that work to return; checking
> +	 * work_pending() is not enough once the work is running.
>  	 */
> -	md_wakeup_thread_directly(&mddev->sync_thread);
> -	if (work_pending(&mddev->sync_work))
> -		flush_work(&mddev->sync_work);
> +	flush_work(&mddev->sync_work);
> =20
>  	wait_event(resync_wait,
>  		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||

[Severity: Medium]
Can stop_sync_thread() block in wait_event() for the entire duration of a
newly started sync when an in-flight md_start_sync() exits via not_running?

Unlike md_reap_sync_thread(), the not_running path in md_start_sync() clears
MD_RECOVERY_RUNNING and unlocks reconfig_mutex without incrementing
mddev->sync_seq:

drivers/md/md.c:md_start_sync() {
	...
not_running:
	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
	mddev_unlock(mddev);
	...
}

When a caller such as raid_message() -> md_idle_sync_thread() enters
stop_sync_thread() with MD_RECOVERY_FROZEN clear while sync_work is still
busy on the not_running path, stop_sync_thread() drops reconfig_mutex and
waits in flush_work(&mddev->sync_work).  Once md_start_sync() unlocks,
mddev->thread can run md_check_recovery() and start a new sync before
stop_sync_thread() reaches wait_event():

CPU0 (raid_message "idle")        kworker               mddev->thread
md_idle_sync_thread()
  stop_sync_thread()
    sync_seq =3D ...
    /* work_busy(sync_work) */
    mddev_unlock()
    flush_work(&sync_work)
                                  md_start_sync()
                                  not_running:
                                    clear RUNNING
                                    mddev_unlock()
                                                        md_check_recovery()
                                                          set RUNNING
                                                          clear INTR
                                                          queue sync_work
    wait_event(resync_wait, ...)
      <-- blocks until new sync finishes

Because MD_RECOVERY_RUNNING is set again, MD_RECOVERY_INTR was cleared by
md_check_recovery(), and sync_seq never changed, stop_sync_thread() waits
for the new sync operation to complete instead of returning once the
aborted sync_work finishes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112013523.1204=
28-1-dayou5941@163.com?part=3D1
