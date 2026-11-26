Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795682980;
	b=Ahi1i0vtIYPz7Q+rwxhRBrQkCWmVnYrzjLPPae5N+zeUZQQzx/uWqdO8CpM8hTLUhzdG
	 Af5XeYN2iK9DN6TeQ67EXIq71mBHDMGKuTm/1uYF5FL19s8Z7kGTPnmEHACmxtgpwm7hW
	 ObHmmP9Dn0yu9htKWiSHfLjQBbJSq7kEAdyAoCza2f26eEr63WlIfSWvYCNNktTgwmSsM
	 VIRiR87v8i4e6HWkFeg2b226dbZckGlm888YwNIXyqzoyIBuFbQ5NusZzfyBjv29QeP7r
	 XADwqIHkFgoOroV/SyAFYt9IqBabV/txRNEKhQ43eyBjrZzaUDzLxw3QSDrW3dqi3Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795682980;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WcowijZ2csZbTicx0dBkVnH1AG1oFs0BNQA4eL684OI=;
	b=PHfblLXFRuonLQ0CUfpzl91/IMGvVBhpurvJl/r+mCWvehS0S0sTaMz5JRfSdCeCqiEG
	 pcjaZJWc6GC8q/sfpp2ndF95E86oGMc3rdnLf8bdHIGLtM04pWj+ot7xpRUb/sJyeGoQD
	 mwlsiqpuSaEZbzRl2OGV2s+TkzQzwkPtVx6OKHbUoKOseZ5uMjcuxuA8oEg3BWOa6dtYK
	 fta58K9NSgyto4pkqlgVWbqD/vlA3HXa6fKtmiRqd8u35GVbiSTaO5tsgfa8tdVwHuZbe
	 tHJaV1Rkul8oSL5WqttHGwPt2IVJ0u0Ko7G52T4OJencFk1YpB2sqbvq3zIU799tTXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f4b9IrYn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB64606A31C;
	Thu, 26 Nov 2026 08:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f4b9IrYn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E473C1F000C4;
	Thu, 26 Nov 2026 08:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795682980;
	bh=WcowijZ2csZbTicx0dBkVnH1AG1oFs0BNQA4eL684OI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f4b9IrYnrShH9pgGxmGeXIeYecw8CLKZF/RrDh6hkfMwetFUybINQHRumwXgVhJxB
	 RkmM3ub7OH2ih+9SmJPaGh4mNupcZAYT9E9uqv7am3hF4DJgY+mdj1dpJSYtFQw1mg
	 JFHJySOrh+djRqmCcKTWFbNIRgWrvXTQ18RuKeucWxHGmY/EZjI1y7hKVSjaAdGqGU
	 ypdxz6b/s/CI5bA7TNbkDlwPTPmaJevVXtaCBlysG0pCDRd1Bu0OkM1LyTp890YLB9
	 ievoELhVIkDn6F7cLdwv5vixCo44bymz7VWM8uZE0KEKUsH/i4lUi1bmTVKx3PTSS1
	 oL0FJlaaqD7mw==
Message-ID: <sashiko-outbox-235055@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 2/2] md: fix sync_work vs array teardown races
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>, song@kernel.org, yukuai@fygo.io, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com
Cc: magiclinan@didiglobal.com, xiao@kernel.org, linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, syzbot+a53c2918175b36cfd601@syzkaller.appspotmail.com, liyouhong@kylinos.cn
In-Reply-To: <20261126083210.210866-3-dayou5941@163.com>
References: <20261126083210.210866-1-dayou5941@163.com>
 <20261126083210.210866-3-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 08:49:39 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] md: stop_sync_thread() hangs on new sync when md_start_sync()
  aborts
--

commit ad365d153f005559a18f08a3280bb7f5a9671a2f
Author: Li Youhong <liyouhong@kylinos.cn>

md: fix sync_work vs array teardown races

This commit stops any in-flight sync_work and sync_thread during md_stop(),
flushes event_work on the raid_ctr() error path, gates the stop_sync_thread=
()
early return on work_busy(&mddev->sync_work), and honors MD_RECOVERY_FROZEN
in the read-only path of md_check_recovery().

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index bb5ea106cc254..2ac93a836fb25 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5210,7 +5210,14 @@ static void stop_sync_thread(struct mddev *mddev, =
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
> @@ -5218,12 +5225,14 @@ static void stop_sync_thread(struct mddev *mddev,=
 bool locked)
> =20
>  	mddev_unlock(mddev);
> =20
> -	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -	/*
> -	 * Thread might be blocked waiting for metadata update which will now
> -	 * never happen
> -	 */
> -	md_wakeup_thread_directly(&mddev->sync_thread);
> +	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> +		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +		/*
> +		 * Thread might be blocked waiting for metadata update which
> +		 * will now never happen
> +		 */
> +		md_wakeup_thread_directly(&mddev->sync_thread);
> +	}
>  	if (work_busy(&mddev->sync_work))
>  		flush_work(&mddev->sync_work);
> =20

[Severity: Medium]
Can stop_sync_thread() end up waiting for the entire duration of a newly
started sync thread when an in-flight sync_work exits via not_running?

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
	wake_up(&resync_wait);
}

When a caller such as raid_message() -> md_idle_sync_thread() clears
MD_RECOVERY_FROZEN and enters stop_sync_thread() while sync_work is still
busy on the not_running path, stop_sync_thread() drops reconfig_mutex and
flushes sync_work, allowing mddev->thread to start a fresh sync before
wait_event() runs:

CPU0 (raid_message)         CPU1 (sync_work)          CPU2 (mddev->thread)
md_idle_sync_thread()
  clear_bit(FROZEN)
  stop_sync_thread()
    sync_seq =3D
      atomic_read(sync_seq)
    /* work_busy() is true */
    mddev_unlock()
    flush_work(sync_work)
                            md_start_sync()
                              goto not_running;
                              clear_bit(RUNNING)
                              /* sync_seq unchanged */
                              mddev_unlock()
                                                      md_check_recovery()
                                                        set_bit(RUNNING)
                                                        clear_bit(INTR)
                                                        queue_work(sync_wor=
k)
    wait_event(resync_wait,
      !test_bit(RUNNING) ||
      (!test_bit(FROZEN) &&
       sync_seq !=3D
         atomic_read(sync_seq)))
      <-- blocks until the new sync finishes

Because MD_RECOVERY_RUNNING is set again, MD_RECOVERY_INTR was cleared by
md_check_recovery(), and sync_seq never changed, stop_sync_thread() blocks
in wait_event() until the new sync completes instead of returning once the
aborted sync_work has finished.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126083210.2108=
66-1-dayou5941@163.com?part=3D2
