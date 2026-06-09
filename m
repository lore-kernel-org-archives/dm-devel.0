Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B153815D9
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 03:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780977174; cv=none; b=fTm7fQtD+D9ow3iNTB9h5u80TTsJ+MKLeF+H76COfffRpaN4z8q6B3QqVBBSn/W0CK3q4kavX5YGvhclcWzTtdvfDD7CQOFWAGH+mFTnXsXfhl3/xvvZYLcHnLL72b3cRtMD422v3Nvai10IBqGHLQwmFHj+5vbV1GRKnruA+jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780977174; c=relaxed/simple;
	bh=riT7L5N3UztfxirXwAWdjKB3Ye0PfkB5zpmJwLZ/I5w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mNvVzjevWy2XdF+wpaNEC2NqS6HFjitmhnPwsBnMT5QeqRO3pUY8FwRjjxYkjOGQktepioMlxAg8sK0Afvxs/4NNY6Ks9yjPjffOUJxvZw5Lalh0tzxTVNh2juzWzJSqdPIPcPg4DhaUyU6R4KwB+pJ9nGd3tp5/0ErIoJvuLZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAnzNQSjidqKHH2AA--.12091S2;
	Tue, 09 Jun 2026 11:52:50 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] dm log writes: fix refcount leak in log_writes_map()
Date: Tue,  9 Jun 2026 03:52:43 +0000
Message-Id: <20260609035243.184530-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAnzNQSjidqKHH2AA--.12091S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ur1xKF18Cw13ury7Cw4UJwb_yoW8Xr18pa
	yUWFyYyFZ5Kw4jgFn8Za1kGFyfua17JFW3urW8W34rXay5XF9rJFZ5ta9Yq3yjkFsrCF9x
	XF4jgryUCa1UAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWrXVW3AwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUUyEEU
	UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgwNA2onYk+eiQABsy

In log_writes_map(), when a discard bio is received and the device
does not support discard, a pending block is allocated and its
pending_blocks refcount is incremented, but the block is never
freed. The function calls bio_endio(bio) and returns
DM_MAPIO_SUBMITTED directly, bypassing normal_end_io() which would
enqueue the block for later release via the kthread. As a result,
the refcount for the associated pending block is leaked, and
pending_blocks never reaches zero, preventing log_writes_dtr() from
completing and causing the device destruction to hang.

Free the block with free_pending_block() before completing the bio
in the !device_supports_discard path, matching the error handling
done when page allocation fails.

Cc: stable@vger.kernel.org
Fixes: 0e9cebe72459 ("dm: add log writes target")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/md/dm-log-writes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index c72e07c3f5a0..05133b1553ca 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -709,6 +709,8 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 		WARN_ON(flush_bio || fua_bio);
 		if (lc->device_supports_discard)
 			goto map_bio;
+		free_pending_block(lc, block);
+		pb->block = NULL;
 		bio_endio(bio);
 		return DM_MAPIO_SUBMITTED;
 	}
-- 
2.34.1

