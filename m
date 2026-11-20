Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795164627;
	b=ILnSogsjFdKz/kKc5JQNQehmWzAZkSAzi39EeE4ibokVxCOanpgK2187/xKKvsjF3C7e
	 gi2RT4DWfTyelCZpOIohopHZK1Pj9ZWhzgORi78jkASTtRVHwUPE7/Q1aEB+5XhdwPrJ2
	 tORu8xmRbMfVpWE2IlCrtOxZOUGwN2twOYoOQCjsh2/ku1126lFa8sUmTpQBraqIHN4Io
	 7Bh2XxXSY0wqcNISG/hk3EOztwJhp5WXZjA8CSPmU8SxMON2mLz9JwbjVy3Vq2E9XqL/s
	 XuNyqPevUS/7ATxSNSLx/AYk6zrTi79aAcX9qSSRQk3wl7u19iyd45ARIH71DEfJQ3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795164627;
	h=DMARC-Filter:DKIM-Signature:References:Content-Type:Cc:Subject:
	 Received:User-Agent:To:Mime-Version:Date:Message-Id:X-Lms-Return-Path:
	 In-Reply-To:Content-Transfer-Encoding:Reply-To:From:X-Original-From;
	bh=8AbiXIB/gnjp1Z+owg6HEbOnhKQ+HwREgu1dRQMA7/Y=;
	b=4a9lKpaVEXlVtMAxQ9deD3IDTHiTbkGI/7tLRK9ewtNL/+vjWL+J25oc5M0YB/QnKWoj
	 03QMNUGB3/yGOCoG4MmeGLZBKrI4Kv3G3qAaHX09BA9Fq37x0tT2DnhaDE6yTk5IWvTxe
	 7wwklP+D45QVUrXKPyGeTiSc1ZxAn7DELgCU9mP04kGM1KB10WXCIdih8pObvy5uzyrjF
	 /T6FWmrXzb56+FUbIjj+yLtZSJF1pQyOjM9Dl6vWNeRq/OsCteuBV0EIwKxuK9OTSQHP1
	 VUmYdDkOVvwoy9O6Y3FZlC1dQl0jwOX8fVKVEReMwtKyE0VB1Zxiv7H+f8WbbmMIuFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=Pwy5hfeW;
	arc=none smtp.remote-ip=209.127.231.56
Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18342606A330
	for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 08:50:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18342606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=Pwy5hfeW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795164617;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=8AbiXIB/gnjp1Z+owg6HEbOnhKQ+HwREgu1dRQMA7/Y=;
 b=Pwy5hfeWY1nlYc5/ikB/RpQvjZPfddWQbeKmtys3oQwEYLXniEHO9J/bruwI1P9ZtSeTFn
 NBRpo/sQt5890xodQBvt322LfjqYKl+O+ByT89qTzz/XeZhTd56LlzpKxbg1PI+6pcXKH7
 fe5vQ2Vy6QsD7eRIkV9eZR5EwtOMsQ2H3Bfs0w5FYST39y5Q/+KLhisygsUochbjG8HxCw
 rgBBOxzvCPuxuIZXBsLmd+ahiIJXEz6eIlglvC7xHE1YrOk+btqAadg+obRsE8untO8XUx
 qR8PIoi3tbFHQ/Wrz6LGrGsnq87KVzXbUL3cXczC9YCBcvgrv8vN1dHqd0isGA==
References: <20261112013523.120428-1-dayou5941@163.com>
Content-Type: text/plain; charset=UTF-8
Cc: <dm-devel@lists.linux.dev>, <magiclinan@didiglobal.com>, 
	<xiao@kernel.org>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, "Li Youhong" <liyouhong@kylinos.cn>, 
	<syzbot+a53c2918175b36cfd601@syzkaller.appspotmail.com>, 
	<stable@vger.kernel.org>
Subject: Re: [PATCH v5] md: fix sync_work vs array teardown races
Received: from [192.168.1.104] ([39.182.0.159]) by smtp.larksuite.com with ESMTPS; Fri, 20 Nov 2026 08:50:16 +0000
User-Agent: Mozilla Thunderbird
To: "Li Youhong" <dayou5941@163.com>, <song@kernel.org>, <agk@redhat.com>, 
	<snitzer@kernel.org>, <mpatocka@redhat.com>, <bmarzins@redhat.com>, 
	"yu kuai" <yukuai@fygo.io>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Date: Fri, 20 Nov 2026 16:50:11 +0800
Message-Id: <0849198e-cbd3-42c4-bbce-4496ffbc974a@fygo.io>
X-Lms-Return-Path: <lba+26b0009c9+654985+lists.linux.dev+yukuai@fygo.io>
In-Reply-To: <20261112013523.120428-1-dayou5941@163.com>
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/11/12 9:35, Li Youhong =E5=86=99=E9=81=93:
> From: Li Youhong <liyouhong@kylinos.cn>
>
> dm-raid tears down arrays via md_stop(), which cleared mddev->pers
> without waiting for previously queued sync_work. That work could
> then call remove_spares() with pers =3D=3D NULL, or keep using mddev
> after raid_dtr() frees it.
>
> do_md_stop()/md_stop_writes() already call stop_sync_thread() before
> teardown. Do the same in md_stop(). Because md_start_sync() may still
> use mddev after unlocking / clearing MD_RECOVERY_RUNNING, flush
> sync_work whenever it is busy rather than only when work_pending().
>
> Calling stop_sync_thread() from md_stop() can drop reconfig_mutex,
> which introduces two follow-on issues:
>
> - When nothing is in flight, keep reconfig_mutex if the caller held
>    it (gate the idle early-return with work_busy()). Otherwise clear
>    of an inactive array can race with do_md_run().
>
> - While the mutex is dropped, mddev->thread may run
>    md_reap_sync_thread() and queue event_work. Flush event_work on
>    the raid_ctr() error path before raid_set_free().
>
> Separately, the read-only path in md_check_recovery() queued
> sync_work without honouring MD_RECOVERY_FROZEN, unlike the
> read-write path. Check FROZEN there so freeze/stop cannot race
> with a new queue.
>
> Fixes: db5e653d7c9f ("md: delay choosing sync action to md_start_sync()")
> Fixes: 81e2ce1b3d5a ("md: delay remove_and_add_spares() for read only arr=
ay to md_start_sync()")
> Reported-by: syzbot+a53c2918175b36cfd601@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Da53c2918175b36cfd601
> Cc: stable@vger.kernel.org
> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
> ---
> v5:
> - Restore idle early-return in stop_sync_thread() gated by work_busy(),
>    so locked callers keep reconfig_mutex and do not race with do_md_run()=
.
> - Flush event_work before raid_set_free() on the raid_ctr error path
>    (md_stop() may drop the mutex and let md_reap queue it).
> - v4: https://lore.kernel.org/linux-raid/20261111015027.4029184-1-dayou59=
41@163.com
>
> v4:
> - Always flush_work(&sync_work) in stop_sync_thread(); do not delay
>    clearing MD_RECOVERY_RUNNING (that can drop MD_RECOVERY_NEEDED via
>    md_check_recovery, and does not cover the successful sync_thread
>    registration path).
> - v3: https://lore.kernel.org/linux-raid/20261110063045.912703-1-dayou594=
1@163.com
>
> v3:
> - Honour MD_RECOVERY_FROZEN before queueing sync_work on the
>    read-only md_check_recovery() path.
> - (superseded) delayed MD_RECOVERY_RUNNING clear on not_running.
> - v2: https://lore.kernel.org/linux-raid/20261109023055.2164333-1-dayou59=
41@163.com
>
> v2:
> - Drop the pers NULL check in md_start_sync().
> - Call stop_sync_thread() from md_stop() before clearing pers,
>    matching do_md_stop()/md_stop_writes().
> - v1: https://lore.kernel.org/linux-raid/20261106083543.249267-1-dayou594=
1@163.com
>
>   drivers/md/dm-raid.c |  7 +++++++
>   drivers/md/md.c      | 41 ++++++++++++++++++++++++++++++++---------
>   2 files changed, 39 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index ac019a0f5a92..f82c09d858de 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3319,6 +3319,13 @@ static int raid_ctr(struct dm_target *ti, unsigned=
 int argc, char **argv)
>   	md_stop(&rs->md);
>   	mddev_unlock(&rs->md);
>   bad:
> +	/*
> +	 * md_stop() may drop reconfig_mutex so mddev->thread can run
> +	 * md_reap_sync_thread() and queue event_work; wait for it before
> +	 * freeing raid_set. Skip if INIT_WORK has not run yet.
> +	 */
> +	if (rs->md.event_work.func)
> +		flush_work(&rs->md.event_work);
>   	raid_set_free(rs);
>  =20
>   	return r;
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..79c564320f18 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5184,7 +5184,14 @@ static void stop_sync_thread(struct mddev *mddev, =
bool locked)
>   {
>   	int sync_seq =3D atomic_read(&mddev->sync_seq);
>  =20
> -	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> +	/*
> +	 * If nothing is in flight, keep reconfig_mutex when locked so
> +	 * callers such as do_md_stop() cannot race with do_md_run().
> +	 * work_busy() is required: md_start_sync() may clear RUNNING and
> +	 * still use mddev after unlocking.
> +	 */
> +	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
> +	    !work_busy(&mddev->sync_work)) {

I'll prefer to use mddev_get() in md_start_sync() to prevent accessing free=
d mddev,
this way there is no need to call mddev_unlock().

>   		if (!locked)
>   			mddev_unlock(mddev);
>   		return;
> @@ -5192,14 +5199,20 @@ static void stop_sync_thread(struct mddev *mddev,=
 bool locked)
>  =20
>   	mddev_unlock(mddev);
>  =20
> -	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> +		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +		/*
> +		 * Thread might be blocked waiting for metadata update which
> +		 * will now never happen
> +		 */
> +		md_wakeup_thread_directly(&mddev->sync_thread);
> +	}
>   	/*
> -	 * Thread might be blocked waiting for metadata update which will now
> -	 * never happen
> +	 * md_start_sync() may still use mddev after unlocking. Always
> +	 * flush so teardown waits for that work to return; checking
> +	 * work_pending() is not enough once the work is running.
>   	 */
> -	md_wakeup_thread_directly(&mddev->sync_thread);
> -	if (work_pending(&mddev->sync_work))

work_pending() is not correct in the first place, I think this should be a =
separate
patch to replace it with work_busy().

> -		flush_work(&mddev->sync_work);
> +	flush_work(&mddev->sync_work);
>  =20
>   	wait_event(resync_wait,
>   		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
> @@ -7101,6 +7114,14 @@ void md_stop(struct mddev *mddev)
>   {
>   	lockdep_assert_held(&mddev->reconfig_mutex);
>  =20
> +	/*
> +	 * md_check_recovery() may have queued sync_work; that work accesses
> +	 * pers. Wait for it here before __md_stop() clears pers, as
> +	 * do_md_stop()/md_stop_writes() do.
> +	 */
> +	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +	stop_sync_thread(mddev, true);
> +
>   	/* stop the array and free an attached data structures.
>   	 * This is called from dm-raid
>   	 */
> @@ -10494,9 +10515,11 @@ void md_check_recovery(struct mddev *mddev)
>  =20
>   			/*
>   			 * Let md_start_sync() to remove and add rdevs to the
> -			 * array.
> +			 * array. Honour MD_RECOVERY_FROZEN like the read-write
> +			 * path so freeze/stop does not race with a new queue.
>   			 */
> -			if (md_spares_need_change(mddev)) {
> +			if (md_spares_need_change(mddev) &&
> +			    !test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
>   				set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>   				queue_work(md_misc_wq, &mddev->sync_work);
>   			}

--=20
Thanks,
Kuai
