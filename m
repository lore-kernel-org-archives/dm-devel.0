From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Don't lose writes if errors are not handled and
	log fails
Date: Sun, 31 Jan 2010 15:34:53 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1001311530280.13480@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

This fixes bug https://bugzilla.redhat.com/show_bug.cgi?id=555197

Please submit this patch before 2.6.33 goes out. It fixes a bug when old 
LVM (<= 2.02.51) is used, that doesn't pass errors_handled flag to 
dm-raid1.

It doesn't need to be backported to RHEL 5.5, because lvm always passes a 
flag to handle errors there.

Mikulas

Don't lose writes if errors are not handled and log fails

If the log fails and errors are not handled by dmeventd, the writes
are successfully finished without being actually written to the device.

This code path is taken:
do_writes:
	bio_list_merge(&ms->failures, &sync);
do_failures:
	if (!get_valid_mirror(ms)) (false)
	else if (errors_handled(ms)) (false)
	else bio_endio(bio, 0);

The logic in do_failures is based on presuming that the write was already
tried --- if it succeeded at least on one leg and errors are not handled,
it is reported as success.

However, bio can be added to the failures queue without being submitted, in
do_writes.

This patch changes it so that bios are added to the failures list only if
errors are handled --- then, they will be held with hold_bio() called from
do_failures.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.33-rc5-devel/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.33-rc5-devel.orig/drivers/md/dm-raid1.c	2010-01-29 20:29:37.000000000 +0100
+++ linux-2.6.33-rc5-devel/drivers/md/dm-raid1.c	2010-01-30 00:04:18.000000000 +0100
@@ -724,7 +724,7 @@ static void do_writes(struct mirror_set 
 	/*
 	 * Dispatch io.
 	 */
-	if (unlikely(ms->log_failure)) {
+	if (unlikely(ms->log_failure) && errors_handled(ms)) {
 		spin_lock_irq(&ms->lock);
 		bio_list_merge(&ms->failures, &sync);
 		spin_unlock_irq(&ms->lock);
