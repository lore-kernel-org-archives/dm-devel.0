From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Fw: [PATCH tip/core/rcu 4/9] dm: sparse: Annotate field
 with __rcu for checking
Date: Tue, 28 Oct 2014 16:49:25 -0700
Message-ID: <20141028234925.GB8321@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

And similarly for this one on both counts.

						Thanx, Paul

----- Forwarded message from "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> -----

Date: Tue, 28 Oct 2014 15:09:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org, mathieu.desnoyers@efficios.com, josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
	oleg@redhat.com, bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/9] dm: sparse: Annotate field with __rcu for checking
X-Mailer: git-send-email 1.8.1.5

From: Pranith Kumar <bobby.prani@gmail.com>

Annotate the map field with __rcu since this is a rcu pointer which is checked
by sparse.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e7399362722e..3372b8378830 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -140,7 +140,7 @@ struct mapped_device {
 	 * Use dm_get_live_table{_fast} or take suspend_lock for
 	 * dereference.
 	 */
-	struct dm_table *map;
+	struct dm_table __rcu *map;

 	struct list_head table_devices;
 	struct mutex table_devices_lock;
-- 
1.8.1.5


----- End forwarded message -----

----- End forwarded message -----
