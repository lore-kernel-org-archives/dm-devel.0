Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2AA946F
	for <dm-devel@lists.linux.dev>; Thu,  5 Sep 2024 02:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725503398; cv=none; b=pZBaNYtUjuJLYvyDIKO+Ex0kjp4eAUO7tAbFNqX1cp6e/nHs2Fjt9ZMyEsdik6zT5YIKhvu/tvTbwqId6uLNSThyg2diNUnPcMmiBMg2w6pKd7eHUvk6ondlntQLkNjVwMLSWNluicNnVOZ0P/mSyPaVerZqXLl6WW8SN84CbH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725503398; c=relaxed/simple;
	bh=ae9fOuXZopXvmfOsqp0lz2GELEyMOiciacDszGvHOPU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TjEh5X6QziQSFR+9xjy23/ffi9gMjjfHFmMEOFv0J5wa/9qzMLL1GRaWt+hJEDSHDZNy6WYtYhPJxkX7NKNOSo1Jd29f3SPRhKLeO4sqcAxHE3XcIpqxDbiUv3LrhnwDXNUwiKPcbV7yvCUHLKpo+XoI2PkZRlt+MVESHOs85KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowACHauqhF9lmv+ZZAQ--.15231S2;
	Thu, 05 Sep 2024 10:29:53 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] dm integrity: Convert comma to semicolon
Date: Thu,  5 Sep 2024 10:28:32 +0800
Message-Id: <20240905022832.1642756-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACHauqhF9lmv+ZZAQ--.15231S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KF17ur4DKrWUZF4ktF1xGrg_yoW8Wryfpr
	yj934ayrW8Ar1IkanFvF1fA3ZIgF97G3yUCayYy3s2qw4DAF18X3s5tFyUJrWUJF1fZF47
	Wr1rtr1qvF4jkF7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4
	AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kK
	e7AKxVWUAVWUtwCY02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfU5VbkUUUUU
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Replace comma between expressions with semicolons.

Using a ',' in place of a ';' can have unintended side effects.
Although that is not the case here, it is seems best to use ';'
unless ',' is intended.

Found by inspection.
No functional change intended.
Compile tested only.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 drivers/md/dm-integrity.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index b3489d3fe7db..34fa98efa9fa 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1500,15 +1500,15 @@ static void dm_integrity_flush_buffers(struct dm_integrity_c *ic, bool flush_dat
 	if (!ic->meta_dev)
 		flush_data = false;
 	if (flush_data) {
-		fr.io_req.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC,
-		fr.io_req.mem.type = DM_IO_KMEM,
-		fr.io_req.mem.ptr.addr = NULL,
-		fr.io_req.notify.fn = flush_notify,
+		fr.io_req.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
+		fr.io_req.mem.type = DM_IO_KMEM;
+		fr.io_req.mem.ptr.addr = NULL;
+		fr.io_req.notify.fn = flush_notify;
 		fr.io_req.notify.context = &fr;
-		fr.io_req.client = dm_bufio_get_dm_io_client(ic->bufio),
-		fr.io_reg.bdev = ic->dev->bdev,
-		fr.io_reg.sector = 0,
-		fr.io_reg.count = 0,
+		fr.io_req.client = dm_bufio_get_dm_io_client(ic->bufio);
+		fr.io_reg.bdev = ic->dev->bdev;
+		fr.io_reg.sector = 0;
+		fr.io_reg.count = 0;
 		fr.ic = ic;
 		init_completion(&fr.comp);
 		r = dm_io(&fr.io_req, 1, &fr.io_reg, NULL, IOPRIO_DEFAULT);
-- 
2.25.1

