From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 28/57] libmultipath: use a shared lock to
	co-operate with udev
Date: Wed, 27 Apr 2016 13:10:29 +0200
Message-ID: <1461755458-29225-29-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

udev since v214 is placing a shared lock on the device node
whenever it's processing the event. This introduces a race
condition with multipathd, as multipathd is processing the
event for the block device at the same time as udev is
processing the events for the partitions.
And a lock on the partitions will also be visible on the
block device itself, hence multipathd won't be able to
lock the device.
When multipath manages to take a lock on the device,
udev will fail, and consequently ignore this entire event.
Which in turn might cause the system to malfunction as it
might have been a crucial event like 'remove' or 'link down'.

So we should better use LOCK_SH here; with that the flock
call in multipathd _and_ udev will succeed and the events
can be processed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 30c7259..ca20ba5 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -546,7 +546,7 @@ lock_multipath (struct multipath * mpp, int lock)
 		if (!pgp->paths)
 			continue;
 		vector_foreach_slot(pgp->paths, pp, j) {
-			if (lock && flock(pp->fd, LOCK_EX | LOCK_NB) &&
+			if (lock && flock(pp->fd, LOCK_SH | LOCK_NB) &&
 			    errno == EWOULDBLOCK)
 				goto fail;
 			else if (!lock)
-- 
2.6.6
