Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BD31E9B1C
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 01:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013294; cv=none; b=iOkHMgg3A8ATH1+rEDLBMhrhYXleedvD526u6y6geTX8fyIN+myq1s4jgNERB3QiWm2YNhBbumDM49KYSo0SUVTD96tBzh7sOxVpct31jxjr0ou42hwmWKD6YiBDwg690T1JYuLtevTjBw/xAkiMERZsJ6SxM9p7auo9bustF0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013294; c=relaxed/simple;
	bh=5kMQtNH0vL/8NUzJ8hwKVaz0ZDkw8lGeSo6POxNb4pA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kxaO3IEp8bjXZx72aNr0lqUAuRwhD+XAoDhjYjcznfn5VrH6d8cwZ3XmRSlSaFL+oLF6OSq+sWFAJawsSt8tdzOaQzjxDfqcycQ8SiAKtHRWFpwhAVsSruGCBsejkfDgTsq0UzXoICFpFMLCPi+gGUlTwWGS5/R3sydhn3OA9AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zwhn13mhwz4f3jq5
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:27:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 019C41A08FB
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 09:28:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CdTiFoNFCWMA--.55093S16;
	Mon, 12 May 2025 09:28:08 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH RFC md-6.16 v3 12/19] md/md-llbitmap: implement bit state machine
Date: Mon, 12 May 2025 09:19:20 +0800
Message-Id: <20250512011927.2809400-13-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2CdTiFoNFCWMA--.55093S16
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw43Cw4kXr18JryfWr4xXrb_yoW7Xw4xpw
	sxZrnxGrs8JF4xW3y7t34xtF95Kr4kt3sIqF93A3s5Ww1YyrZI9r1kWFy8J3yUWryFqF1D
	JFs8Gr95GF4UZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Each bit is one byte, contain 6 difference state, see llbitmap_state. And
there are total 8 differenct actions, see llbitmap_action, can change
state:

llbitmap state machine: transitions between states

|           | Startwrite | Startsync | Endsync | Abortsync| Reload   | Daemon | Discard   | Stale     |
| --------- | ---------- | --------- | ------- | -------  | -------- | ------ | --------- | --------- |
| Unwritten | Dirty      | x         | x       | x        | x        | x      | x         | x         |
| Clean     | Dirty      | x         | x       | x        | x        | x      | Unwritten | NeedSync  |
| Dirty     | x          | x         | x       | x        | NeedSync | Clean  | Unwritten | NeedSync  |
| NeedSync  | x          | Syncing   | x       | x        | x        | x      | Unwritten | x         |
| Syncing   | x          | Syncing   | Dirty   | NeedSync | NeedSync | x      | Unwritten | NeedSync  |

Typical scenarios:

1) Create new array
All bits will be set to Unwritten by default, if --assume-clean is set,
All bits will be set to Clean instead.

2) write data, raid1/raid10 have full copy of data, while raid456 donen't and
rely on xor data

2.1) write new data to raid1/raid10:
Unwritten --StartWrite--> Dirty

2.2) write new data to raid456:
Unwritten --StartWrite--> NeedSync

Because the initial recover for raid456 is skipped, the xor data is not build
yet, the bit must set to NeedSync first and after lazy initial recover is
finished, the bit will finially set to Dirty(see 4.1 and 4.4);

2.3) cover write
Clean --StartWrite--> Dirty

3) daemon, if the array is not degraded:
Dirty --Daemon--> Clean

For degraded array, the Dirty bit will never be cleared, prevent full disk
recovery while readding a removed disk.

4) discard
{Clean, Dirty, NeedSync, Syncing} --Discard--> Unwritten

4) resync and recover

4.1) common process
NeedSync --Startsync--> Syncing --Endsync--> Dirty --Daemon--> Clean

4.2) resync after power failure
Dirty --Reload--> NeedSync

4.3) recover while replacing with a new disk
By default, the old bitmap framework will recover all data, and llbitmap
implement this by a new helper llbitmap_skip_sync_blocks:

skip recover for bits other than dirty or clean;

4.4) lazy initial recover for raid5:
By default, the old bitmap framework will only allow new recover when there
are spares(new disk), a new recovery flag MD_RECOVERY_LAZY_RECOVER is add
to perform raid456 lazy recover for set bits(from 2.2).

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 100 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index b27d10661387..315a4eb7627c 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -462,3 +462,103 @@ static int llbitmap_cache_pages(struct llbitmap *llbitmap)
 
 	return 0;
 }
+
+static void llbitmap_init_state(struct llbitmap *llbitmap)
+{
+	enum llbitmap_state state = BitUnwritten;
+	unsigned long i;
+
+	if (test_and_clear_bit(BITMAP_CLEAN, &llbitmap->flags))
+		state = BitClean;
+
+	for (i = 0; i < llbitmap->chunks; i++) {
+		int ret = llbitmap_write(llbitmap, state, i);
+
+		if (ret < 0) {
+			set_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
+			break;
+		}
+	}
+}
+
+/* The return value is only used from resync, where @start == @end. */
+static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
+						  unsigned long start,
+						  unsigned long end,
+						  enum llbitmap_action action)
+{
+	struct mddev *mddev = llbitmap->mddev;
+	enum llbitmap_state state = BitNone;
+	bool need_resync = false;
+	bool need_recovery = false;
+
+	if (test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags))
+		return BitNone;
+
+	if (action == BitmapActionInit) {
+		llbitmap_init_state(llbitmap);
+		return BitNone;
+	}
+
+	while (start <= end) {
+		ssize_t ret;
+		enum llbitmap_state c;
+
+		ret = llbitmap_read(llbitmap, &c, start);
+		if (ret < 0) {
+			set_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
+			return BitNone;
+		}
+
+		if (c < 0 || c >= nr_llbitmap_state) {
+			pr_err("%s: invalid bit %lu state %d action %d, forcing resync\n",
+			       __func__, start, c, action);
+			state = BitNeedSync;
+			goto write_bitmap;
+		}
+
+		if (c == BitNeedSync)
+			need_resync = true;
+
+		state = state_machine[c][action];
+		if (state == BitNone) {
+			start++;
+			continue;
+		}
+
+write_bitmap:
+		/* Delay raid456 initial recovery to first write. */
+		if (c == BitUnwritten && state == BitDirty &&
+		    action == BitmapActionStartwrite && is_raid456(mddev)) {
+			state = BitNeedSync;
+			need_recovery = true;
+		}
+
+		ret = llbitmap_write(llbitmap, state, start);
+		if (ret < 0) {
+			set_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
+			return BitNone;
+		}
+
+		if (state == BitNeedSync)
+			need_resync = true;
+		else if (state == BitDirty &&
+			 !timer_pending(&llbitmap->pending_timer))
+			mod_timer(&llbitmap->pending_timer,
+				  jiffies + mddev->bitmap_info.daemon_sleep * HZ);
+
+		start++;
+	}
+
+	if (need_recovery) {
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		set_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
+	} else if (need_resync) {
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
+	}
+
+	return state;
+}
-- 
2.39.2

