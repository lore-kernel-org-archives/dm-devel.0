Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3355345EB7
	for <dm-devel@lists.linux.dev>; Fri,  7 Aug 2026 15:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786118327; cv=none; b=I2ikuvgqUjlGI7c/2VN0/rpGCnxB/AePSn+qs+q+5MN9Vikpo6I7+9ztaYgxGfZHjgdUaPg7rR0nDNa/igR+dOS10jDnXQx0J6+fgOkXxAwhIBDO7uLXuu68W8ygVl1c+bwlZHOlGdkRagqyWMMx/biCyLGdwbIVJdBFpcKnxBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786118327; c=relaxed/simple;
	bh=HXwFKoMvjs0TmlmvBSlL34L+QPx5rBHifQmWXRokN0E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mVBjxKubU//eSRa2iN74GK2Mi5v9R1xaNClEA5yvPFou9/CWlmhA5USeDsSLiAuJRbW71epnERWKqGhOEeNsYkzEmlCdV80Xz2+xy3y6LwTUXsTbJ5mpoQH6aoaGwvRSxqPrYrEKVw151mfBUPJSJ/ufWvCoGMZZ41LEfkMn/SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=lM8PBXgN; arc=none smtp.client-ip=220.197.31.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="lM8PBXgN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=qB
	/T9uO/CEivuY5YxwMqjdDII0Q/62wuGCjSQBKNUn8=; b=lM8PBXgNyVoumKcaq+
	0gQETxchDm0IfWhz1GN8+hbJVOPY9KcBprKVAkV1Tyx46CWcuX3Bhthzz8j5pOWc
	Zhp++bE4hFZJ8/f72pIxLXCQjizfFuOXOdwBFNxb61Wv07oKPbIJvbWsTVVrIyi1
	h4FUtthjVJs9+p+Cscbztkk+w=
Received: from LAPTOP-N9A9U1FG.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PikvCgDn15teAHZqLn67Eg--.20550S4;
	Fri, 07 Aug 2026 23:57:50 +0800 (CST)
From: Genjian <zhanggenjian@126.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com
Cc: rdunlap@infradead.org,
	DamienLeMoal@wdc.com,
	zhengbin13@huawei.com,
	heinzm@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zhanggenjian@126.com,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: [PATCH] dm-ebs: fix incorrect device offset check in ebs_ctr()
Date: Fri,  7 Aug 2026 23:57:15 +0800
Message-ID: <20260807155715.465254-1-zhanggenjian@126.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PikvCgDn15teAHZqLn67Eg--.20550S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFW7JFWUtryrGryfWw4rXwb_yoWkCFb_Cw
	1rXFyqgr4UWr1F9Fy5Cw4rZrZ2yrs5ur47Z3WftFsavFyxWryDZF1kW3ZYyF1fur4fArZ0
	yas8G3yfGr17WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRZAwIDUUUUU==
X-CM-SenderInfo: x2kd0wxjhqyxldq6ij2wof0z/xtbBtR5X1Wp2AH6bVgAA3G

From: Genjian Zhang <zhanggenjian@kylinos.cn>

<offset> is a backing-device sector offset; ti->len is the virtual
target length. Comparing them rejects valid tables, e.g.:

  dmsetup create ebs0 --table "0 1048576 ebs /dev/sda 2097152 1 8"
  -> ebs: Invalid device offset sector (-EINVAL)

Drop the check. Bounds against the backing device are already
enforced later by device_area_is_invalid() via ebs_iterate_devices().

Fixes: d3c7b35c20d6 ("dm: add emulated block size target")
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
---
 drivers/md/dm-ebs-target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 1e52bde48b91..5d67c6c19d4b 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -265,8 +265,7 @@ static int ebs_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	r = -EINVAL;
 	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) != 1 ||
-	    tmp != (sector_t)tmp ||
-	    (sector_t)tmp >= ti->len) {
+	    tmp != (sector_t)tmp) {
 		ti->error = "Invalid device offset sector";
 		goto bad;
 	}
-- 
2.43.0

