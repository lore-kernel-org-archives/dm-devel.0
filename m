From: Jules Irenge <jbi.octave@gmail.com>
Subject: [PATCH 1/9] dm snapshot: Add missing annotation for dm_exception_table_lock() and dm_exception_table_unlock()
Date: Sat, 11 Apr 2020 01:19:25 +0100
Message-ID: <20200411001933.10072-2-jbi.octave@gmail.com>
References: <0/9>
 <20200411001933.10072-1-jbi.octave@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200411001933.10072-1-jbi.octave@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: boqun.feng@gmail.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Sparse reports warnings at dm_exception_table_lock()
and dm_exception_table_unlock()

warning: context imbalance in dm_exception_table_lock()
	- wrong count at exit
warning: context imbalance in dm_exception_table_unlock()
	- unexpected unlock

The root cause is the missing annotation at dm_exception_table_lock()
and dm_exception_table_unlock()

Add the missing __acquires(lock->complete_slot) annotation
Add the missing __acquires(lock->pending_slot) annotation
Add the missing __releases(lock->pending_slot) annotation
Add the missing __releases(lock->complete_slot) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/md/dm-snap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 6b11a266299f..1831dd28de5c 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -640,12 +640,16 @@ static void dm_exception_table_lock_init(struct dm_snapshot *s, chunk_t chunk,
 }
 
 static void dm_exception_table_lock(struct dm_exception_table_lock *lock)
+	__acquires(lock->complete_slot)
+	__acquires(lock->pending_slot)
 {
 	hlist_bl_lock(lock->complete_slot);
 	hlist_bl_lock(lock->pending_slot);
 }
 
 static void dm_exception_table_unlock(struct dm_exception_table_lock *lock)
+	__releases(lock->pending_slot)
+	__releases(lock->complete_slot)
 {
 	hlist_bl_unlock(lock->pending_slot);
 	hlist_bl_unlock(lock->complete_slot);
-- 
2.24.1
