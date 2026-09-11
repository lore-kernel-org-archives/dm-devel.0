Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B268C361DB8
	for <dm-devel@lists.linux.dev>; Fri, 11 Sep 2026 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142879; cv=none; b=LJ8MrlH0cZH1idhpaZ9pYsMYOu7rzqoVoVP8vslVOZdU3picPv69vTnsE8FgNvj0+hfWXqzVa146vORzS+zplEM0ttHGnB5AEcbSlRwwHLYqUA41wuEZP2eDpkJR0HShTpQGdcIQfs85qWrqOu8Tg8RZko/5CFwhRQGUGeBezRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142879; c=relaxed/simple;
	bh=Qk8yNt3dIw9MmiYHBJfZI8dXlL65XA8tjJbeaLoEjKw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DIBqvKXbmuscyCJlHuE2yrIu7koOI9T+BWLGrU82XYGfQRR2A9Iuu/tlwvsrrtPlVvXgi/JwMiTRyk6f6b7cOF4GhoHaGqO35RfA9Nu+K5mZ9jWSRgFEampJ/D8tz2sxRf2HPFiY4EVm/vJaMPaC3pqMcWH2/OmUpLchRs51Eus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZkKLvWwh; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZkKLvWwh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Message-ID:MIME-Version:
	Content-Type; bh=MfL9H/fohvo4ifqEg/LeDNsotyf7q1p0FbmL7Ufgp78=;
	b=ZkKLvWwhcmHInno6dlbPvWHVyGP5WEii4Mxq1bHeWtUxcye9bKsJdvdnF2tH8f
	RCmkAw/k47IqZobLi8njrrjXe4IOhZ6arssdXFEGb/cPU/VN4zDaZAWayROWol8z
	3D+OH+s9QtKXEZnHV/kVlvI/HssrO408OSv1z3AkdP8fw=
Received: from localhost (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgA36GFFJ6RqZNzfOg--.56920S2;
	Sat, 12 Sep 2026 00:07:33 +0800 (CST)
Date: Sat, 12 Sep 2026 00:07:33 +0800
From: Hao Zhang <hao_zhang_kdev@163.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	bmarzins@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] dm thin: Remove unnecessary locking from pool_map()
Message-ID: <aqQnRRAJkEBNw6Vp@192.168.1.215>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-CM-TRANSID:PCgvCgA36GFFJ6RqZNzfOg--.56920S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1fGF13KFy3XFyxXr4Utwb_yoW8Jw4UpF
	ZFga9xZ34UWrW2gF1DX3yv9F45X3ZYg3y2kry7Ga4Sqrn5WFyfZFy7tFWavF9YgF9xGryY
	vFWjyr98ZF45t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j0g4fUUUUU=
X-CM-SenderInfo: pkdrs65kdqwshngh4qqrwthudrp/xtbC3QWekWqkJ0XYmQAA36

From: Hao Zhang <zhanghao1@kylinos.cn>

pool_map() takes pool->lock only while setting the bio's data device.

The pool target's data_dev is initialized when the target is
constructed and is not changed afterwards.  The device-mapper target
remains alive while its map callback is running, so pool->lock is not
needed to protect data_dev.

Remove the unnecessary locking.  This also avoids holding pool->lock
across bio_set_dev(), which may perform a blkcg lookup and acquire the
request queue's queue_lock.

Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>
---
 drivers/md/dm-thin.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 59392de7a477..358ed77ffb2b 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3438,14 +3438,11 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 static int pool_map(struct dm_target *ti, struct bio *bio)
 {
 	struct pool_c *pt = ti->private;
-	struct pool *pool = pt->pool;
 
 	/*
 	 * As this is a singleton target, ti->begin is always zero.
 	 */
-	spin_lock_irq(&pool->lock);
 	bio_set_dev(bio, pt->data_dev->bdev);
-	spin_unlock_irq(&pool->lock);
 
 	return DM_MAPIO_REMAPPED;
 }

base-commit: 08df884136f1c1197bab2a27814404fd329d9aac
-- 
2.15.0

