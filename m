From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 3/3] multipathd: "san_path_err" failure
	optimization
Date: Wed, 2 Oct 2019 06:48:07 +0000
Message-ID: <20191002064655.2669-4-martin.wilck@suse.com>
References: <20191002064655.2669-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191002064655.2669-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Chongyun Wu <wu.chongyun@h3c.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Chongyun Wu <wu.chongyun@h3c.com>

Let san_path_err_recovery_time path unstable can be
detected and not reinstate it until this path keep up in
san_path_err_recovery_time. It will fix heavy IO delay
caused by parts of paths state shaky in multipath device.

Test and result:
Run up eth1 30s and down eth1 30s with 100 loops script to
make some paths shaky in each multipath devices.
Using below multipath.conf configure in defaults section:
    san_path_err_recovery_time 30
    san_path_err_threshold 2
    san_path_err_forget_rate 6
After test, not found any IO delay logs except several logs in the very
beginning which before san_path_err filter shaky path works .
If without above config and this patch there will be lots of IO delay
in syslog and some paths state change from up to down again and again.

Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
---
 multipathd/main.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 70172d71..34a57689 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1896,6 +1896,18 @@ static int check_path_reinstate_state(struct path * pp) {
 			goto reinstate_path;
 		}
 		get_monotonic_time(&curr_time);
+
+		/* If path became failed again or continue failed, should reset
+		 * path san_path_err_forget_rate and path dis_reinstate_time to
+		 * start a new stable check. 
+		 */
+		if ((pp->state != PATH_UP) && (pp->state != PATH_GHOST) &&
+			(pp->state != PATH_DELAYED)) {
+			pp->san_path_err_forget_rate =
+				pp->mpp->san_path_err_forget_rate;
+			pp->dis_reinstate_time = curr_time.tv_sec;
+		}
+
 		if ((curr_time.tv_sec - pp->dis_reinstate_time ) > pp->mpp->san_path_err_recovery_time) {
 			condlog(2,"%s : reinstate the path after err recovery time", pp->dev);
 			goto reinstate_path;
@@ -2066,6 +2078,11 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		pathinfo(pp, conf, 0);
 		pthread_cleanup_pop(1);
 		return 1;
+	} else if ((newstate != PATH_UP && newstate != PATH_GHOST) &&
+			(pp->state == PATH_DELAYED)) {
+		/* If path state become failed again cancel path delay state */
+		pp->state = newstate;
+		return 1;
 	}
 	if (!pp->mpp) {
 		if (!strlen(pp->wwid) &&
-- 
2.23.0
