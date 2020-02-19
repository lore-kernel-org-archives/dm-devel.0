From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 4/5] libmultipath: change directio get_events()
	timeout handling
Date: Wed, 19 Feb 2020 00:54:32 -0600
Message-ID: <1582095273-10279-5-git-send-email-bmarzins@redhat.com>
References: <1582095273-10279-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582095273-10279-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

get_events() used a NULL or a zeroed timeout to mean "don't wait".
io_getevents() uses a NULL timeout to mean "wait forever" and a
zeroed timeout to mean "don't wait". Make get_events() work like
io_getevents().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/directio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 6ad7c885..649961a4 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -262,7 +262,7 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
 	struct io_event events[128];
 	int i, nr, got_events = 0;
 	struct timespec zero_timeout = {0};
-	struct timespec *timep = (timeout)? timeout : &zero_timeout;
+	struct timespec *timep = timeout;
 
 	do {
 		errno = 0;
@@ -303,7 +303,6 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 	int		rc;
 	long		r;
 	struct timespec currtime, endtime;
-	struct timespec *timep = &timeout;
 
 	if (fstat(fd, &sb) == 0) {
 		LOG(4, "called for %x", (unsigned) sb.st_rdev);
@@ -339,18 +338,19 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 	endtime.tv_nsec += timeout.tv_nsec;
 	normalize_timespec(&endtime);
 	while(1) {
-		r = get_events(ct->aio_grp, timep);
+		r = get_events(ct->aio_grp, &timeout);
 
 		if (ct->req->state != PATH_PENDING) {
 			ct->running = 0;
 			return ct->req->state;
-		} else if (r == 0 || !timep)
+		} else if (r == 0 ||
+			   (timeout.tv_sec == 0 && timeout.tv_nsec == 0))
 			break;
 
 		get_monotonic_time(&currtime);
 		timespecsub(&endtime, &currtime, &timeout);
 		if (timeout.tv_sec < 0)
-			timep = NULL;
+			timeout.tv_sec = timeout.tv_nsec = 0;
 	}
 	if (ct->running > timeout_secs || sync) {
 		struct io_event event;
-- 
2.17.2
