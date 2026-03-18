Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8FA37C925
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 08:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.193.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773822214; cv=none; b=RGxiH2F3r5O3n/CYyYX8YXzRBHVBpq7DaHDKD/tPefJ8otrtDmKsiW7UJwZaowyMh/vxajlYuCLjEfVntIi0goX8w5Mx+yc3LSQKINlRskPb5MZe2qdoATYjy5OEEu2a+q6sk06siSK6nNYbcrk8hv3J2r0x34B5TOch+i1nXBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773822214; c=relaxed/simple;
	bh=tDVdM7imo2+yWmLyqVINZy+kumE/PvcXoVtN1AHgv0g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CQjUlEbgpQmfcMFFTjBdmlzdbGZDDYkUnwOymykp9hHfDRZDIIDe3wE32dOsyuwt+Qn84MBHxa0gMgoMHBANq84nlfLWsqe9b58Ovgf8UMrNAqiQc33hOdCP2hIm5e5L5UvRn8BgXTUGE++v2mxqyTKQso2+dQru0ikjOIWmBdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=korsgaard.com; spf=pass smtp.mailfrom=korsgaard.com; dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b=1q46+aoI; arc=none smtp.client-ip=34.202.193.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=korsgaard.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=korsgaard.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b="1q46+aoI"
DKIM-Signature: a=rsa-sha256; b=1q46+aoIs1w+6aDBd/dQTXGjFAIS5r7eMiZayLBFNk1V575QpPe+ukwF/hvhdQTv7IoR+f2ItHAoD8XvtvoRZNgxB9CqVOLoFcUlkDVI+AAqniQKVh/FOLF80kdacTQdNZZOC5Q3doSyDLl/odPt0KOlcrUvImK9G0ybglwoqLjqy8xVTEV/c4GraJ+GAgCE62Y//Auo66m+7ZrWfWwD8218Nd2UhhZWRPnHLLrR6lh2SZ63uw0s3wo0YlYflphWR4QQpDp84F5ARmHyDvdhevmM18zVYVGhOfwpo3xMewBprDLUn/lYN/jV2ER8aCvfVU1SrYk3D1k+6Uat69F1Fw==; s=purelymail2; d=purelymail.com; v=1; bh=tDVdM7imo2+yWmLyqVINZy+kumE/PvcXoVtN1AHgv0g=; h=Feedback-ID:Received:Received:From:To:Subject:Date;
Feedback-ID: 21632:4007:null:purelymail
X-Pm-Original-To: dm-devel@lists.linux.dev
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id -964822359;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Wed, 18 Mar 2026 08:22:57 +0000 (UTC)
Received: from peko by dell.be.48ers.dk with local (Exim 4.98.2)
	(envelope-from <peter@korsgaard.com>)
	id 1w2mB6-00000007Xov-05LA;
	Wed, 18 Mar 2026 09:22:56 +0100
From: Peter Korsgaard <peter@korsgaard.com>
To: Guillaume Gonnet <ggonnet.linux@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>,  Mike Snitzer <snitzer@kernel.org>,
  Mikulas Patocka <mpatocka@redhat.com>,  Benjamin Marzinski
 <bmarzins@redhat.com>,  dm-devel@schwermer.no,  chanho.min@lge.com,
  jaeyuel.im@lge.com,  dm-devel@lists.linux.dev,
  linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] dm init: ensure device probing has finished in
 dm-mod.waitfor=
In-Reply-To: <20260317213229.18371-1-ggonnet.linux@gmail.com> (Guillaume
	Gonnet's message of "Tue, 17 Mar 2026 22:32:28 +0100")
References: <20260317213229.18371-1-ggonnet.linux@gmail.com>
Date: Wed, 18 Mar 2026 09:22:55 +0100
Message-ID: <87341xh7hc.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

>>>>> "Guillaume" == Guillaume Gonnet <ggonnet.linux@gmail.com> writes:

Hello,

 > The early_lookup_bdev() function returns successfully when the disk
 > device is present but not necessarily its partitions. In this situation,
 > dm_early_create() fails as the partition block device does not exist
 > yet.

 > In my case, this phenomenon occurs quite often because the device is
 > an SD card with slow reading times, on which kernel takes time to
 > enumerate available partitions.

 > Fortunately, the underlying device is back to "probing" state while
 > enumerating partitions. Waiting for all probing to end is enough to fix
 > this issue.

 > That's also the reason why this problem never occurs with rootwait=
 > parameter: the while loop inside wait_for_root() explicitly waits for
 > probing to be done and then the function calls async_synchronize_full().
 > These lines were omitted in 035641b, even though the commit says it's
 > based on the rootwait logic...

 > Anyway, calling wait_for_device_probe() after our while loop does the
 > job (it both waits for probing and calls async_synchronize_full).

 > Fixes: 035641b01e72 ("dm init: add dm-mod.waitfor to wait for asynchronously probed block devices")
 > Signed-off-by: Guillaume Gonnet <ggonnet.linux@gmail.com>
 > ---

 > Hello,

 > This patch is my attempt to fix the dm-mod.waitfor= issue. I had this
 > fix for quite a while now, but I've never made the effort to contribute
 > until recently.

 > Some have tried to fix it this issue in the past but without finding
 > its real root cause (ie. not waiting for device probe to end).

Interesting, this is the first I hear about this (was not CC'ed on these
other patches).


 > Here are the links to those patches, for reference:
 > https://lore.kernel.org/all/b5c5cd56-b9dd-4368-a8e1-b9e0a07b79b4@schwermer.no/
 > https://lore.kernel.org/all/20250410080056.43247-1-chanho.min@lge.com/

I see that Christoph does not like the whole dm-mod.waitfor logic, but
this patch seems quite clear to me about what the issue is and how to
fix it.


 > diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
 > index 7403823384c5..c1bacba92c65 100644
 > --- a/drivers/md/dm-init.c
 > +++ b/drivers/md/dm-init.c
 > @@ -303,8 +303,10 @@ static int __init dm_init_init(void)
 >  		}
 >  	}
 
 > -	if (waitfor[0])
 > +	if (waitfor[0]) {
 > +		wait_for_device_probe();

There is already a wait_for_device_probe() just above the loop, so what
does this fix exactly? Do we need both?

Interesting enough, I have never encountered this issue myself. I do use
a partition identifier (dm-mod.waitfor="PARTLABEL=root-a") which
presumably sidetracks the /dev/mmcblk0 available, but partition table
not yet parsed issue.

-- 
Bye, Peter Korsgaard
