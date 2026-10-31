Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793463120;
	b=VPWl2LN+62FCcNqKGbDhiXokoTHCSk9PzNWrUNBTSrJ9iTECEN/ONe8bgOiPSXEwK9/1
	 GmQ0ejivXONrayWTO8bhmOiKfAdgYvi/rbBNey7X+3zjdp5naWG1gCs5ElVzqzCVQW9sa
	 R+QIL3jo2bo7DHyPt3r/97EFWK9GOgxt84rQp9yDsyFWb36HsKWBFZnaj8F+EvQL1U8In
	 0dpRLakI02HuTbeCNF3UYTlkaA287q0D/OzS+Ei8JaiukDzrd7bD5qgjvKzBwsBGipTUv
	 h8x17EoUGNthe9/Zf9z/6Vil5X51oD/YGSueJwR3kr+zWkn5rcvYMfbBzC9gTEoBuwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793463120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bqKuAGO7fIG+WCUUm+LSWdZk8Wyi5YGM40d8cuBo11s=;
	b=e9drazmuqF1WL0xZ9thKcULGMNldGf63saQkhbr2PZUUjwEJZoHsHZNlSbok2R4a64aS
	 C0gmPbYuM+T7oVsxvCeFRKLQtScmrWp2Dgcaionm1EEB0vbMw2msGvTa8K6T0Rt2b/8kR
	 jj31PFb1/lcYJGi/cI9/HyWYeNWnSwH0AEiU86Yf6kXk7a3x0+3NDuluYgBeFSYImpGfh
	 qKkbilHdorYjUS5LhR0kqZNWXeQm+kMtWkrR4q7gKGMRChzfbqgpqsrra8ik1fPpTGhLd
	 0ZnXPT2B8zPli1NCqzYam7NS/4zVHdNYx/FgfOU0lcosqmnvo+Ir3pscDSU+86F3Zfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZOelg7bD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ABD606A31A
	for <dm-devel@lists.linux.dev>; Sat, 31 Oct 2026 16:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZOelg7bD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8071F000C1;
	Sat, 31 Oct 2026 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793463120;
	bh=bqKuAGO7fIG+WCUUm+LSWdZk8Wyi5YGM40d8cuBo11s=;
	h=From:To:Cc:Subject:Date;
	b=ZOelg7bDE7GNkACOldlbqvXAg1hhROCSHcMrllXXKxhn4OD3aflJqx9fJoQ1JJyAW
	 7xeR+GbIG4f3hZkRikjU6z4OpIR9uVqc2bqF/762vdSDBnBZFT8KQtSiuFCpjEx/sw
	 SffnPVZVDKumjOtzHgUtSi5+Za1dCbut1NqbJVXn3rJftr8Tprew9T4hBbfRAzu+U5
	 9kN4XMW0lrH8uKFDVey3k72F+ZSSgA1GdyKFtd/lEED+1O4bsVhWHFOkorYplbiOm2
	 xIo1CGLnkrqbcUvCbaNPRmbUpl66jk4dt9NM2P5d02KmQdjnIcCZ94psNvuhTy9yxT
	 Qg8E6hI3YasYw==
From: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-delay: do not round a short delay up to the next timer tick
Date: Sat, 31 Oct 2026 12:11:58 -0400
Message-ID: <20261031161158.94403-1-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For delays under 50 ms dm-delay hands its bios to a kthread, which
polls for expired bios eight times per delay period.  But the time a
bio is due is still kept in jiffies:

	delayed->expires = jiffies + msecs_to_jiffies(c->delay);

so however often the kthread looks, a bio is released at a tick.  With
HZ=1000 that is invisible.  With HZ=100 every delay under 10 ms becomes
a delay until the next tick, and a task that writes synchronously
falls into step with the tick and sees 10 ms each time.

Keep the due time in nanoseconds when the kthread is in use.  The
timer and workqueue path, for delays of 50 ms and more, is unchanged.

Single 4 KiB direct writes through a delay target on a memory-backed
null_blk device, arm64, HZ=100, mean latency in ms (300 writes each):

	delay	before	after
	 1	 9.97	 1.16
	 2	 9.97	 2.38
	 5	 9.99	 5.85
	20	20.06	21.29

What remains above the requested delay is the kthread's polling
interval, one eighth of the delay.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-delay.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 4864671c2222f..4c732b240801f 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
+#include <linux/timekeeping.h>
 
 #include <linux/device-mapper.h>
 
@@ -51,7 +52,15 @@ struct dm_delay_info {
 	struct delay_c *context;
 	struct delay_class *class;
 	struct list_head list;
-	unsigned long expires;
+	/*
+	 * When the bio is due: in jiffies for the timer, or in nanoseconds
+	 * for the kthread, which polls more often than the tick and must
+	 * not round a short delay up to it.
+	 */
+	union {
+		unsigned long expires;
+		u64 expires_ns;
+	};
 };
 
 static void handle_delayed_timer(struct timer_list *t)
@@ -83,6 +92,13 @@ static void flush_bios(struct bio *bio)
 	}
 }
 
+static bool delay_expired(struct delay_c *dc, struct dm_delay_info *delayed)
+{
+	if (delay_is_fast(dc))
+		return ktime_get_ns() >= delayed->expires_ns;
+	return time_after_eq(jiffies, delayed->expires);
+}
+
 static void flush_delayed_bios(struct delay_c *dc, bool flush_all)
 {
 	struct dm_delay_info *delayed, *next;
@@ -98,7 +114,7 @@ static void flush_delayed_bios(struct delay_c *dc, bool flush_all)
 	spin_unlock(&dc->delayed_bios_lock);
 	list_for_each_entry_safe(delayed, next, &local_list, list) {
 		cond_resched();
-		if (flush_all || time_after_eq(jiffies, delayed->expires)) {
+		if (flush_all || delay_expired(dc, delayed)) {
 			struct bio *bio = dm_bio_from_per_bio_data(delayed,
 						sizeof(struct dm_delay_info));
 			list_del(&delayed->list);
@@ -322,7 +338,10 @@ static int delay_bio(struct delay_c *dc, struct delay_class *c, struct bio *bio)
 	delayed = dm_per_bio_data(bio, sizeof(struct dm_delay_info));
 
 	delayed->context = dc;
-	delayed->expires = expires = jiffies + msecs_to_jiffies(c->delay);
+	if (delay_is_fast(dc))
+		delayed->expires_ns = ktime_get_ns() + (u64)c->delay * NSEC_PER_MSEC;
+	else
+		delayed->expires = expires = jiffies + msecs_to_jiffies(c->delay);
 
 	spin_lock(&dc->delayed_bios_lock);
 	if (unlikely(!dc->may_delay)) {
-- 
2.44.0

