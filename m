From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] multipath-tools: multipathd makes offline
	devices active
Date: Fri, 11 Nov 2005 18:43:22 -0500 (EST)
Message-ID: <20051111.184322.71083111.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

multipathd(8) continues calling reinstate_path() in checkerloop(),
if multipathd(8) is started on the system which has multipath maps
including offline devices.
The reason is pp->checkfn() returns -1 for offline devices and
pp->state of these paths are 1.
(I'm using "echo offline > /sys/block/sd?/device/state" for the testing.)

As a result, multipathd(8) makes offline devices active state.
And this behavior also affects the no_path_retry feature, since 
struct multipath.nr_active is incremented in reinstate_path().

The following patch fixes this problem.
If the return value from pp->checkfn is -1, the path isn't available.
So I think that we can ignore it.

Any comments?


diff --git a/multipathd/main.c b/multipathd/main.c
index 4275a37..3d2848c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1239,7 +1239,12 @@ checkerloop (void *ap)
 			}
 			newstate = pp->checkfn(pp->fd, checker_msg,
 					       &pp->checker_context);
-			
+			if (newstate < 0) {
+				condlog(2, "%s: unusable path", pp->dev);
+				pathinfo(pp, conf->hwtable, 0);
+				continue;
+			}
+
 			if (newstate != pp->state) {
 				pp->state = newstate;
 				LOG_MSG(1, checker_msg);

Thanks,
Kiyoshi Ueda
