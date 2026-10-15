Received: from mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AC237E5D7
	for <dm-devel@lists.linux.dev>; Thu, 15 Oct 2026 06:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792044159; cv=none; b=XhYX/hy9xrkwexVjLdEii2ukHa9E0mIlbV0ZwOGK9Yl3IP2vI2eSEW7RDakw+2tZX6Nvm1bYFj0afOa40JKUJGu/CIq1uOM0K12iFTDefxpV5e1yFUjAtg0mAyb8I7IbB/QwHwWUTv/ASuipU+PwXxajh+pjl0Tk+6EsSY0tGjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792044159; c=relaxed/simple;
	bh=Z+vXKxDzBrmxnBu2A6xZkJcgxDOcSpa5WVuPCAlPPxk=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=D5UCDIFE0gmDK9dIdwHOF3mL7vEZdZ/gqJIroOMUrCWfpzZst50jMskhKaqhHGfZejDh6yakjLHJfvtIeIwW0Ky42XiMatRIe/HqmVe++lfCb9BYrw5hUe73YfMubJf42XWWLAbQUUXOlqMJh0+acqpRwBFQ1SdWKIROOLH8G8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xlHjgl+D; arc=none smtp.client-ip=91.218.175.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xlHjgl+D"
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Z+vXKxDzBrmxnBu2A6xZkJcgxDOcSpa5WVuPCAlPPxk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792044155; v=1; x=1792648955;
 b=xlHjgl+DlIl8qLRsohk0NBKmtH0u+JAW9dyU+S17mIOajs/WtnbSgBHkzMf4JIG/t2fZHgj+
 ZYXdvAf5uGHM9pCuPk4119D4Itf1PnT+UlbFZKxMYRkMcJOCRTn6IvonkjWuysWgkTYX0RaZ6kz
 LCm5FMInwoNrstz7VGksPZ5U=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 88c1f1ec9516249f;
	Thu, 15 Oct 2026 06:02:35 +0000
X-Mizu-Trace-ID: 88c1f1ec9516249f
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 15 Oct 2026 06:02:34 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: dongsheng.yang@linux.dev
Message-ID: <50deaf80941588ef5f29441fb006189017d4ede8@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] dm-pcache: do not advance dirty_tail after backing flush
 failure
To: "guolingxing" <guolingxing@tju.edu.cn>, "Zheng Gu" <cengku@gmail.com>,
 dm-devel@lists.linux.dev
Cc: "Mikulas Patocka" <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
 "guolingxing" <guolingxing@tju.edu.cn>, stable@vger.kernel.org
In-Reply-To: <20261014031150.3913245-1-guolingxing@tju.edu.cn>
References: <20261014031150.3913245-1-guolingxing@tju.edu.cn>

Hi lingxing,
Thanks for the fix. Keeping dirty_tail unchanged when the backing-device
flush fails looks correct to me.

One related question: jbd2_cleanup_journal_tail() also ignores the return
value of blkdev_issue_flush() before calling __jbd2_update_log_tail().
Do you know whether JBD2 has another mechanism that makes this safe, or
whether it has a similar error-handling gap?

This does not invalidate the dm-pcache fix, but understanding the
difference would be useful.

2026=E5=B9=B410=E6=9C=8814=E6=97=A5 11:11, "guolingxing" <guolingxing@tju=
.edu.cn mailto:guolingxing@tju.edu.cn?to=3D%22guolingxing%22%20%3Cguoling=
xing%40tju.edu.cn%3E > =E5=86=99=E5=88=B0:


>=20
>=20After all writeback bios for a kset complete, writeback_ctx_end()
> flushes the backing device and then advances the persistent dirty_tail.
> However, backing_dev_flush() discards the error returned by
> blkdev_issue_flush(), so dirty_tail is advanced even when the written
> data is not known to be durable.
>=20
>=20dirty_tail points to the first kset that still requires writeback.
> Advancing it causes recovery to treat the preceding kset as clean and
> allows its cache copy to eventually be reclaimed by garbage collection.
> If the backing device flush failed, a subsequent power failure may
> therefore result in data loss.
>=20
>=20Make backing_dev_flush() return the flush status and handle a flush
> failure like a writeback I/O failure. Leave dirty_tail unchanged so
> that the same kset will be retried.
>=20
>=20Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in devic=
e-mapper")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
> ---
>  drivers/md/dm-pcache/backing_dev.c | 4 ++--
>  drivers/md/dm-pcache/backing_dev.h | 2 +-
>  drivers/md/dm-pcache/cache_writeback.c | 28 +++++++++++++++++++-------
>  3 files changed, 24 insertions(+), 10 deletions(-)
>=20
>=20diff --git a/drivers/md/dm-pcache/backing_dev.c b/drivers/md/dm-pcach=
e/backing_dev.c
> index 7165fc0364bb..0c15bb01068e 100644
> --- a/drivers/md/dm-pcache/backing_dev.c
> +++ b/drivers/md/dm-pcache/backing_dev.c
> @@ -336,9 +336,9 @@ struct pcache_backing_dev_req *backing_dev_req_crea=
te(struct pcache_backing_dev
>  return backing_req;
>  }
>=20=20
>=20-void backing_dev_flush(struct pcache_backing_dev *backing_dev)
> +int backing_dev_flush(struct pcache_backing_dev *backing_dev)
>  {
> - blkdev_issue_flush(backing_dev->dm_dev->bdev);
> + return blkdev_issue_flush(backing_dev->dm_dev->bdev);
>  }
>=20=20
>=20 int pcache_backing_init(void)
> diff --git a/drivers/md/dm-pcache/backing_dev.h b/drivers/md/dm-pcache/=
backing_dev.h
> index b371cba483b9..8422e5e76e29 100644
> --- a/drivers/md/dm-pcache/backing_dev.h
> +++ b/drivers/md/dm-pcache/backing_dev.h
> @@ -120,7 +120,7 @@ struct pcache_backing_dev_req *backing_dev_req_allo=
c(struct pcache_backing_dev *
>  struct pcache_backing_dev_req_opts *opts);
>  void backing_dev_req_init(struct pcache_backing_dev_req *backing_req,
>  struct pcache_backing_dev_req_opts *opts);
> -void backing_dev_flush(struct pcache_backing_dev *backing_dev);
> +int backing_dev_flush(struct pcache_backing_dev *backing_dev);
>=20=20
>=20 int pcache_backing_init(void);
>  void pcache_backing_exit(void);
> diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pca=
che/cache_writeback.c
> index c8a4c8110a58..e09560f172dd 100644
> --- a/drivers/md/dm-pcache/cache_writeback.c
> +++ b/drivers/md/dm-pcache/cache_writeback.c
> @@ -18,12 +18,18 @@ static void writeback_ctx_end(struct pcache_cache *=
cache, int ret)
>  return;
>=20=20
>=20 if (!cache->writeback_ctx.ret) {
> - backing_dev_flush(cache->backing_dev);
> -
> - mutex_lock(&cache->dirty_tail_lock);
> - cache_pos_advance(&cache->dirty_tail, cache->writeback_ctx.advance);
> - cache_encode_dirty_tail(cache);
> - mutex_unlock(&cache->dirty_tail_lock);
> + ret =3D backing_dev_flush(cache->backing_dev);
> + if (ret) {
> + pcache_dev_err(CACHE_TO_PCACHE(cache),
> + "failed to flush backing device: %d", ret);
> + cache->writeback_ctx.ret =3D ret;
> + } else {
> + mutex_lock(&cache->dirty_tail_lock);
> + cache_pos_advance(&cache->dirty_tail,
> + cache->writeback_ctx.advance);
> + cache_encode_dirty_tail(cache);
> + mutex_unlock(&cache->dirty_tail_lock);
> + }
>  }
>  queue_delayed_work(cache_get_wq(cache), &cache->writeback_work, 0);
>  }
> @@ -76,8 +82,16 @@ static inline bool is_cache_clean(struct pcache_cach=
e *cache, struct pcache_cach
>=20=20
>=20 void cache_writeback_exit(struct pcache_cache *cache)
>  {
> + int ret;
> +
>  cancel_delayed_work_sync(&cache->writeback_work);
> - backing_dev_flush(cache->backing_dev);
> +
> + ret =3D backing_dev_flush(cache->backing_dev);
> + if (ret)
> + pcache_dev_err(CACHE_TO_PCACHE(cache),
> + "failed to flush backing device during exit: %d",
> + ret);
> +
>  cache_tree_exit(&cache->writeback_key_tree);
>  }
>=20=20
>=20--=20
>=202.34.1
>
