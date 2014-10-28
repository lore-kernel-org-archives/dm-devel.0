From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Fw: [PATCH tip/core/rcu 3/9] drivers/md: Use
 rcu_dereference() for accessing rcu pointer
Date: Tue, 28 Oct 2014 16:48:55 -0700
Message-ID: <20141028234855.GA8321@linux.vnet.ibm.com>
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

Should have Cc:ed you on this one, please accept my apologies for
failing to do so.

Would you guys like to push this patch, me to do so, or would you rather
that this patch be dropped?

							Thanx, Paul

----- Forwarded message from "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> -----

Date: Tue, 28 Oct 2014 15:09:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org, mathieu.desnoyers@efficios.com, josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
	oleg@redhat.com, bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/9] drivers/md: Use rcu_dereference() for accessing rcu pointer
X-Mailer: git-send-email 1.8.1.5

From: Pranith Kumar <bobby.prani@gmail.com>

Got Paul's email wrong the first time.

The map field in 'struct mapped_device' is an rcu pointer. Use rcu_dereference()
while accessing it.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 58f3927fd7cc..e7399362722e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2332,7 +2332,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,

 	merge_is_optional = dm_table_merge_is_optional(t);

-	old_map = md->map;
+	old_map = rcu_dereference(md->map);
 	rcu_assign_pointer(md->map, t);
 	md->immutable_target_type = dm_table_get_immutable_target_type(t);

@@ -2351,7 +2351,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
  */
 static struct dm_table *__unbind(struct mapped_device *md)
 {
-	struct dm_table *map = md->map;
+	struct dm_table *map = rcu_dereference(md->map);

 	if (!map)
 		return NULL;
@@ -2745,7 +2745,7 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 		goto out_unlock;
 	}

-	map = md->map;
+	map = rcu_dereference(md->map);

 	/*
 	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
@@ -2839,7 +2839,7 @@ int dm_resume(struct mapped_device *md)
 	if (!dm_suspended_md(md))
 		goto out;

-	map = md->map;
+	map = rcu_dereference(md->map);
 	if (!map || !dm_table_get_size(map))
 		goto out;

-- 
1.8.1.5


----- End forwarded message -----

----- End forwarded message -----
