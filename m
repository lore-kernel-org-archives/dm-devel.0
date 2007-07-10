From: Neil Brown <neilb@suse.de>
Subject: dm in -mm doesn't compile with CONFIG_DM_NETLINK=n
Date: Tue, 10 Jul 2007 12:16:39 +1000
Message-ID: <18066.60423.989365.579446@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


FYI this patch is needed in 2.6.22-rc6-mm1 for dm to compile
with CONFIG_DM_NETLINK=n.

NeilBrown

--------------
Allow dm to compile without CONFIG_DM_NETLINK

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/dm-netlink.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff .prev/drivers/md/dm-netlink.h ./drivers/md/dm-netlink.h
--- .prev/drivers/md/dm-netlink.h	2007-07-10 12:12:46.000000000 +1000
+++ ./drivers/md/dm-netlink.h	2007-07-10 12:12:54.000000000 +1000
@@ -47,10 +47,10 @@ static inline int __init dm_netlink_init
 static inline void dm_netlink_exit(void)
 {
 }
-void inline dm_netlink_send_events(struct list_head *events)
+static void inline dm_netlink_send_events(struct list_head *events)
 {
 }
-void inline dm_path_event(enum dm_netlink_event_type evt_type,
+static void inline dm_path_event(enum dm_netlink_event_type evt_type,
 			  struct dm_table *t, const char *path,
 			  int nr_valid_paths)
 {
