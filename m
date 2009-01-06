From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-table-rework-reference-counting.patch
Date: Tue, 6 Jan 2009 16:27:12 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0901061611590.2209@hs20-bc2-1.build.redhat.com>
References: <49630562.3090107@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49630562.3090107@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

You are right, thanks for the review. I grepped for other uses of 
dm_table_put and they seem correct - just these two were bad.

Alasdair: push this patch to Linus soon.


Another point: it looks somehow scary to free the table before unlocking 
_hash_lock --- most of the time, _hash_lock is took only on behalf of 
userspace ioctls (no problem with that), but it is also took in 
dm_copy_name_and_uuid that can be called from uevent code:

dm_table_event -> event_callback -> dm_send_uevents -> takes _hash_lock
And dm_table_event is called directly from targets, targets wait for 
dm_table_event to finish in their destructor --- so calling the destructor 
with locked _hash_lock seems to be a deadlock possibility --- what do you 
think?

Mikulas

On Tue, 6 Jan 2009, Kiyoshi Ueda wrote:

> Hi Alasdair, Mikulas,
> 
> Although I'm not sure this is correct, don't we need to convert
> the following 2 dm_table_put()s to dm_table_destroy()?
> Otherwise, the created table won't be destroyed and memory leak
> will happen in such error cases?
> 
> drivers/md/dm-ioctl.c:table_load()
> 1060         r = dm_table_create(&t, get_mode(param), param->target_count, md);
> 1061         if (r)
> 1062                 goto out;
> 1063 
> 1064         r = populate_table(t, param, param_size);
> 1065         if (r) {
> 1066                 dm_table_put(t);
> 1067                 goto out;
> 1068         }
> 1069 
> 1070         down_write(&_hash_lock);
> 1071         hc = dm_get_mdptr(md);
> 1072         if (!hc || hc->md != md) {
> 1073                 DMWARN("device has been removed from the dev hash table.");
> 1074                 dm_table_put(t);
> 1075                 up_write(&_hash_lock);
> 1076                 r = -ENXIO;
> 1077                 goto out;
> 1078         }
> 
> Thanks,
> Kiyoshi Ueda
> 

Fix an error introduced in dm-table-rework-reference-counting.patch.

When there is failure after table initialization, we need to use
dm_table_destroy, not dm_table_put, to free the table.

dm_table_put may be used only after dm_table_get.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
CC: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

---
 drivers/md/dm-ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.28-devel/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.28-devel.orig/drivers/md/dm-ioctl.c	2009-01-06 22:06:01.000000000 +0100
+++ linux-2.6.28-devel/drivers/md/dm-ioctl.c	2009-01-06 22:07:05.000000000 +0100
@@ -1063,7 +1063,7 @@ static int table_load(struct dm_ioctl *p
 
 	r = populate_table(t, param, param_size);
 	if (r) {
-		dm_table_put(t);
+		dm_table_destroy(t);
 		goto out;
 	}
 
@@ -1071,7 +1071,7 @@ static int table_load(struct dm_ioctl *p
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
 		DMWARN("device has been removed from the dev hash table.");
-		dm_table_put(t);
+		dm_table_destroy(t);
 		up_write(&_hash_lock);
 		r = -ENXIO;
 		goto out;
