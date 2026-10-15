Received: from mta1.migadu.com (out-46.mta1.migadu.com [95.215.58.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7A5457E6E
	for <dm-devel@lists.linux.dev>; Thu, 15 Oct 2026 06:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792044312; cv=none; b=YBbkh9OQld+r/FGIY31eqxSCmSFJe12rPYvlK+r+iGzCan6nXboYv8iz+NkgGNNNREbg4aQvTUrrICeN8kbgvXBUdO/JPxmk75M64Rnp8d3hjtWC/RFmlM2W/ghxNxWa6MYzaLhdT5FlMkPXIeJCWHoAxSM5DUafg5nM+xcHbQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792044312; c=relaxed/simple;
	bh=2UKZZEqwm+PGOqM3elFIPAy+Pfwujs+x/P/q927mlmc=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=rnjlbRRO7c+bgy+Qf6VdTiaV2RlmbKinqsW5OAd92pEkDyJDpPzL+S6//9pyRCdGjdwAbcxEZtl09plxjz3KzmegMxTwpnrm8leJZ9Z37oENL96Frv8zm2ZlJTBUPKyaGpq5r7ME/J9WnO8WxXqA4vvzHEPVtHZZL5ViCLBIBWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VXkTfzLa; arc=none smtp.client-ip=95.215.58.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VXkTfzLa"
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=2UKZZEqwm+PGOqM3elFIPAy+Pfwujs+x/P/q927mlmc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792044305; v=1; x=1792649105;
 b=VXkTfzLa3mZ5Y+36GumixpOIzQ2j+eGQc6z+YJs5cKaL9CL5N4Dpx78TI2LukFTdjncdeVce
 2AINNXpRvTt6Tg0sgwa3nqTrsW7sfArBcjkqxlTmu+SwKIcopTWsjp94gLeozaee2wz1RdYsjaQ
 GKRwa0B/Ibw3L4UIcz9KVzs8=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2c47d87e372fc303;
	Thu, 15 Oct 2026 06:05:04 +0000
X-Mizu-Trace-ID: 2c47d87e372fc303
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 15 Oct 2026 06:05:04 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: dongsheng.yang@linux.dev
Message-ID: <66ade47f4080e47ab82bad177f69ef1e1627b2be@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] dm-pcache: do not advance dirty_tail after backing flush
 failure
To: "=?utf-8?B?6YOt546y5YW0?=" <guolingxing@tju.edu.cn>
Cc: cengku@gmail.com, dm-devel@lists.linux.dev, mpatocka@redhat.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <AIAAVACtLN6RcesfKovGLKrx.2.1792044142752.Hmail.2017202219@tju.edu.cn>
References: <20261014031150.3913245-1-guolingxing@tju.edu.cn>
 <fba60fb2a8c7261c54ca866bc235c1553cacc6a5@linux.dev>
 <AIAAVACtLN6RcesfKovGLKrx.2.1792044142752.Hmail.2017202219@tju.edu.cn>

Thanks for the explanation and the link. That addresses my question
about JBD2.

Reviewed-by: Dongsheng Yang <dongsheng.yang@linux.dev>



2026=E5=B9=B410=E6=9C=8815=E6=97=A5 14:02, "=E9=83=AD=E7=8E=B2=E5=85=B4" =
<guolingxing@tju.edu.cn mailto:guolingxing@tju.edu.cn?to=3D%22%E9%83%AD%E=
7%8E%B2%E5%85%B4%22%20%3Cguolingxing%40tju.edu.cn%3E > =E5=86=99=E5=88=B0=
:


>=20
>=20Hi,
>=20
>=20Thanks for reviewing the fix.
>=20
>=20Yes, JBD2 has a similar error-handling gap. I submitted a patch for t=
hat exact issue earlier, and it has already received a Reviewed-by from t=
he maintainer:
>=20
>=20https://lore.kernel.org/all/20261012114713.4049391-1-guolingxing@tju.=
edu.cn/
>=20
>=20The subsequent journal superblock write uses REQ_FUA, but that does n=
ot guarantee that the preceding checkpoint writes are durable, particular=
ly when the journal is on a separate device.
>=20
>=20It was while working on the JBD2 fix that I checked other blkdev_issu=
e_flush() call sites and found similar omissions in dm-pcache and ext4. T=
his dm-pcache patch came out of that investigation.
>=20
>=20Thanks,
> lingxing
>=20
>=20=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9Adongsheng.yang@linux.dev
> =E5=8F=91=E9=80=81=E6=97=A5=E6=9C=9F=EF=BC=9A2026-10-15 13:51:23
> =E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9Aguolingxing <guolingxing@tju.edu.cn=
>,Zheng Gu <cengku@gmail.com>,dm-devel@lists.linux.dev
> =E6=8A=84=E9=80=81=E4=BA=BA=EF=BC=9AMikulas Patocka <mpatocka@redhat.co=
m>,linux-kernel@vger.kernel.org,guolingxing <guolingxing@tju.edu.cn>,stab=
le@vger.kernel.org
> =E4=B8=BB=E9=A2=98=EF=BC=9ARe: [PATCH] dm-pcache: do not advance dirty_=
tail after backing flush failure
>=20
>=20>=20
>=20> Hi lingxing,
> > Thanks for the fix. Keeping dirty_tail unchanged when the backing-dev=
ice
> > flush fails looks correct to me.
> >=20
>=20> One related question: jbd2_cleanup_journal_tail() also ignores the =
return
> > value of blkdev_issue_flush() before calling __jbd2_update_log_tail()=
.
> > Do you know whether JBD2 has another mechanism that makes this safe, =
or
> > whether it has a similar error-handling gap?
> >=20
>=20> This does not invalidate the dm-pcache fix, but understanding the
> > difference would be useful.
> >=20
>=20> 2026=E5=B9=B410=E6=9C=8814=E6=97=A5 11:11, "guolingxing" <guolingxi=
ng@tju.edu.cn mailto:guolingxing@tju.edu.cn?to=3D%22guolingxing%22%20%3Cg=
uolingxing%40tju.edu.cn%3E > =E5=86=99=E5=88=B0:
> >=20
>=20> >=20
>=20> > After all writeback bios for a kset complete, writeback_ctx_end()
> > > flushes the backing device and then advances the persistent dirty_t=
ail.
> > > However, backing_dev_flush() discards the error returned by
> > > blkdev_issue_flush(), so dirty_tail is advanced even when the writt=
en
> > > data is not known to be durable.
> > >=20
>=20> > dirty_tail points to the first kset that still requires writeback=
.
> > > Advancing it causes recovery to treat the preceding kset as clean a=
nd
> > > allows its cache copy to eventually be reclaimed by garbage collect=
ion.
> > > If the backing device flush failed, a subsequent power failure may
> > > therefore result in data loss.
> > >=20
>=20> > Make backing_dev_flush() return the flush status and handle a flu=
sh
> > > failure like a writeback I/O failure. Leave dirty_tail unchanged so
> > > that the same kset will be retried.
> > >=20
>=20> > Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in d=
evice-mapper")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
> > > ---
> > >  drivers/md/dm-pcache/backing_dev.c | 4 ++--
> > >  drivers/md/dm-pcache/backing_dev.h | 2 +-
> > >  drivers/md/dm-pcache/cache_writeback.c | 28 +++++++++++++++++++---=
----
> > >  3 files changed, 24 insertions(+), 10 deletions(-)
> > >=20
>=20> > diff --git a/drivers/md/dm-pcache/backing_dev.c b/drivers/md/dm-p=
cache/backing_dev.c
> > > index 7165fc0364bb..0c15bb01068e 100644
> > > --- a/drivers/md/dm-pcache/backing_dev.c
> > > +++ b/drivers/md/dm-pcache/backing_dev.c
> > > @@ -336,9 +336,9 @@ struct pcache_backing_dev_req *backing_dev_req_=
create(struct pcache_backing_dev
> > >  return backing_req;
> > >  }
> > >=20=20
>=20> > -void backing_dev_flush(struct pcache_backing_dev *backing_dev)
> > > +int backing_dev_flush(struct pcache_backing_dev *backing_dev)
> > >  {
> > > - blkdev_issue_flush(backing_dev->dm_dev->bdev);
> > > + return blkdev_issue_flush(backing_dev->dm_dev->bdev);
> > >  }
> > >=20=20
>=20> >  int pcache_backing_init(void)
> > > diff --git a/drivers/md/dm-pcache/backing_dev.h b/drivers/md/dm-pca=
che/backing_dev.h
> > > index b371cba483b9..8422e5e76e29 100644
> > > --- a/drivers/md/dm-pcache/backing_dev.h
> > > +++ b/drivers/md/dm-pcache/backing_dev.h
> > > @@ -120,7 +120,7 @@ struct pcache_backing_dev_req *backing_dev_req_=
alloc(struct pcache_backing_dev *
> > >  struct pcache_backing_dev_req_opts *opts);
> > >  void backing_dev_req_init(struct pcache_backing_dev_req *backing_r=
eq,
> > >  struct pcache_backing_dev_req_opts *opts);
> > > -void backing_dev_flush(struct pcache_backing_dev *backing_dev);
> > > +int backing_dev_flush(struct pcache_backing_dev *backing_dev);
> > >=20=20
>=20> >  int pcache_backing_init(void);
> > >  void pcache_backing_exit(void);
> > > diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm=
-pcache/cache_writeback.c
> > > index c8a4c8110a58..e09560f172dd 100644
> > > --- a/drivers/md/dm-pcache/cache_writeback.c
> > > +++ b/drivers/md/dm-pcache/cache_writeback.c
> > > @@ -18,12 +18,18 @@ static void writeback_ctx_end(struct pcache_cac=
he *cache, int ret)
> > >  return;
> > >=20=20
>=20> >  if (!cache->writeback_ctx.ret) {
> > > - backing_dev_flush(cache->backing_dev);
> > > -
> > > - mutex_lock(&cache->dirty_tail_lock);
> > > - cache_pos_advance(&cache->dirty_tail, cache->writeback_ctx.advanc=
e);
> > > - cache_encode_dirty_tail(cache);
> > > - mutex_unlock(&cache->dirty_tail_lock);
> > > + ret =3D backing_dev_flush(cache->backing_dev);
> > > + if (ret) {
> > > + pcache_dev_err(CACHE_TO_PCACHE(cache),
> > > + "failed to flush backing device: %d", ret);
> > > + cache->writeback_ctx.ret =3D ret;
> > > + } else {
> > > + mutex_lock(&cache->dirty_tail_lock);
> > > + cache_pos_advance(&cache->dirty_tail,
> > > + cache->writeback_ctx.advance);
> > > + cache_encode_dirty_tail(cache);
> > > + mutex_unlock(&cache->dirty_tail_lock);
> > > + }
> > >  }
> > >  queue_delayed_work(cache_get_wq(cache), &cache->writeback_work, 0)=
;
> > >  }
> > > @@ -76,8 +82,16 @@ static inline bool is_cache_clean(struct pcache_=
cache *cache, struct pcache_cach
> > >=20=20
>=20> >  void cache_writeback_exit(struct pcache_cache *cache)
> > >  {
> > > + int ret;
> > > +
> > >  cancel_delayed_work_sync(&cache->writeback_work);
> > > - backing_dev_flush(cache->backing_dev);
> > > +
> > > + ret =3D backing_dev_flush(cache->backing_dev);
> > > + if (ret)
> > > + pcache_dev_err(CACHE_TO_PCACHE(cache),
> > > + "failed to flush backing device during exit: %d",
> > > + ret);
> > > +
> > >  cache_tree_exit(&cache->writeback_key_tree);
> > >  }
> > >=20=20
>=20> > --=20
>=20> > 2.34.1
> > >
> >
>
