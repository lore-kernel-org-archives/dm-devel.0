Received: from m15.mail.163.com (m15.mail.163.com [45.254.50.219])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3F75B5B5
	for <dm-devel@lists.linux.dev>; Fri, 12 Jan 2024 05:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mzhBGFgJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=/NYM0
	Ugmi9mOXgsDU9vW/LSp9grSGNGvGGp9Ka4NfHY=; b=mzhBGFgJL6JvI8ncjQB7i
	gsn5Lyr+ZN2TKLBWFaFCurIyUq9VUo4JbpytpeSNyul/2GLjwR2PRw/mLquIa8Re
	tpoEgIQpfHqPjE2AnEeQ+cQZEQ6gW3t/WUcLMsyE/etY58HfdWiguwnQWkr/0s/y
	vYfzmg9z1n9ocDgHJGTPR0=
Received: from localhost.localdomain (unknown [36.4.236.25])
	by zwqz-smtp-mta-g2-1 (Coremail) with SMTP id _____wDnTxtWx6BlkUenAA--.40024S4;
	Fri, 12 Jan 2024 13:00:34 +0800 (CST)
From: Lizhe <sensor1010@163.com>
To: tglx@linutronix.de,
	ilpo.jarvinen@linux.intel.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Lizhe <sensor1010@163.com>
Subject: [PATCH] drivers/dm-crypt.c : remove redundant state settings after waking up
Date: Thu, 11 Jan 2024 21:00:05 -0800
Message-Id: <20240112050005.4952-1-sensor1010@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnTxtWx6BlkUenAA--.40024S4
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRjNtxUUUUU
X-CM-SenderInfo: 5vhq20jurqiii6rwjhhfrp/xtbBXhVjq2VOA8ircwAAs7

The task status has been set to TASK_RUNNING in schedule().
No need to set again here.

Signed-off-by: Lizhe <sensor1010@163.com>
---
 drivers/md/dm-crypt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 855b482cbff1..ab1e30630e64 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1948,7 +1948,6 @@ static int dmcrypt_write(void *data)
 
 		schedule();
 
-		set_current_state(TASK_RUNNING);
 		spin_lock_irq(&cc->write_thread_lock);
 		goto continue_locked;
 
-- 
2.25.1

