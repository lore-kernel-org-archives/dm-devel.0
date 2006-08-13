From: Kay Sievers <kay.sievers@vrfy.org>
Subject: send 'change' uevent for device-mapper table resume
Date: Sun, 13 Aug 2006 16:04:56 +0200
Message-ID: <20060813140456.GA8170@vrfy.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair,
I'm not sure if Hannes already sent this, if not, please take this into
your tree. As discussed at OLS, this is one step, to make udev's operation
on dm devices more reliable.

Thanks,
Kay


From: Hannes Reinecke <hare@suse.de>

device-mapper: send 'change' uevent for device-mapper table resume

Device-mapper tables are only ever usable after a 'resume'
ioctl has been issued. But to know when this happens we need to
generate an uevent to notify udev, so that it can take appropriate
action.

As discussed with agk and kay at OLS we should be sending 'change' events
for resume; events on suspend don't give you anything interesting and indeed
might lead to failures as any I/O on that table will be blocked anyway.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
-- 

 dm.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c99bf9f..93014c4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1337,6 +1337,8 @@ int dm_resume(struct mapped_device *md)
 
 	dm_table_unplug_all(map);
 
+	kobject_uevent(&md->disk->kobj, KOBJ_CHANGE);
+
 	r = 0;
 
 out:
