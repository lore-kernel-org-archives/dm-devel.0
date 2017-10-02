From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-crypt: Reject sector_size feature if
 device length is not aligned to it
Date: Mon, 2 Oct 2017 10:43:56 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1710021034380.2597@file01.intranet.prod.int.rdu2.redhat.com>
References: <20170913134556.23145-1-gmazyland@gmail.com>
	<b6c539ce-c841-a21c-1a2c-4ee93d826680@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b6c539ce-c841-a21c-1a2c-4ee93d826680@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Sat, 30 Sep 2017, Milan Broz wrote:

> On 09/13/2017 03:45 PM, Milan Broz wrote:
> > If a crypt mapping uses optional sector_size feature, additional
> > restrictions to mapped device segment size must be applied in constructor,
> > otherwise the device activation will fail later.
> 
> Hi,
> 
> we had some discussion with Mikulas if this check should be better in generic DM code.
> 
> I think that for this case it is not a good idea - dm-crypt can increase
> encryption sector size during load (it is stupid to do, but I see no reason why to block it).
> And then only constructor of the target itself know what is possible and what should be rejected.

The same argument also applies to verity, integrity and zoned target. I 
think it should be tested in the generic dm code, not duplicated in these 
targets.

Here I send a patch that checks invalid limits when the table is loaded 
and aborts the table load ioctl with an error.

> Anyway, there is a short reproducer what this patch solves:
> 
> Create simple mapping with 4096 encryption sector:
> 
> # dmsetup create test --table "0 8 crypt cipher_null - 0 /dev/sdb 0 1 sector_size:4096"
> 
> Now load new unaligned-length table (this should fail!)
> # dmsetup load test --table "0 9 crypt cipher_null - 0 /dev/sdb 0 1 sector_size:4096"
> 
> Inactive table is apparently accepted:
> # dmsetup table --inactive
> test: 0 9 crypt cipher_null 0 0 8:16 0 1 sector_size:4096
> 
> And now, resume fails, keeping the device in suspended state afterward:
> 
> # dmsetup resume test
> device-mapper: resume ioctl on test failed: Invalid argument
> Command failed
> kernel: device-mapper: table: 254:0: len=9 not aligned to h/w logical block size 4096 of sdb

BTW. if you resume it twice, it will continue working with the old table.

> # dmsetup info -c
> Name             Maj Min Stat Open Targ Event  UUID
> test             254   0 L-sw    0    1      0
> 
> With the patch applied, the load step correctly fails:
> # dmsetup load test --table "0 9 crypt cipher_null - 0 /dev/sdb 0 1 sector_size:4096"
> device-mapper: reload ioctl on test failed: Invalid argument
> kernel: device-mapper: table: 254:0: crypt: Device size is not multiple of sector_size feature
> 
> Please consider this for 4.14 (and stable 4.12+ perhaps).
> 
> Thanks,
> Milan

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: dm: check invalid limits when table is created

Device mapper checks invalid limits when resuming a device and swapping a 
table, however it may be too late becuase it makes the resume ioctl fail. 
This patch checks the limits when a table is loaded, so that the table 
load ioctl will fail.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -1308,6 +1308,7 @@ static int table_load(struct file *filp,
 	struct dm_table *t, *old_map = NULL;
 	struct mapped_device *md;
 	struct target_type *immutable_target_type;
+	struct queue_limits dummy_limits;
 
 	md = find_device(param);
 	if (!md)
@@ -1349,6 +1350,10 @@ static int table_load(struct file *filp,
 		goto err_unlock_md_type;
 	}
 
+	r = dm_calculate_queue_limits(t, &dummy_limits);
+	if (r)
+		goto err_unlock_md_type;
+
 	dm_unlock_md_type(md);
 
 	/* stage inactive table */
