From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V5 0/1] dm-zoned: Drive-managed zoned block
	device target
Date: Wed,  7 Jun 2017 15:55:38 +0900
Message-ID: <20170607065539.16774-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

Mike,

I folded all your patches from your dm-zoned branch together with further
rewrite to finish the data structure separation that you started. Folded in
this version are also several bug fixes and code cleanup.

In more details, the changes from the previous version are as follow:
* Completed the dmz_target structure split into dmz_metadata, dmz_reclaim and
  a smaller dmz_target structure. These structures are respectively defined in
  dm-zoned-metadata.c, dm-zoned-reclaim.c and dm-zoned-target.c.
  In the include file dm-zoned.h remains only the dm_zone data structure
  definition and the newly defined dmz_dev data structure to hold static
  device information shared between all files (bdev handle, device name,
  number of zones, zone size, etc)
* Various code shuffle and cleanup, function rename and message fixes.
  Most of the code changes are to avoid the need for back-pointers and cross
  access to the data structure members. There was no functionality loss due to
  these changes. The code is in fact now a lot cleaner in many places.
* Fixed a deadlock happening when a chunk work is waiting for a zone to be
  reclaimed with the flush work concurrently executing (all three of these
  running together could deadlock on the metadata semaphore).

I ran several long run tests applying various workloads with XFS running on
top of a dm-zoned device. No problems were detected. I will keep testing to
make sure that stability was not affected by all the changes.

Please review and let me know of any further change or correction you think is
needed. Thank you.

Best regards.

Damien Le Moal (1):
  dm-zoned: Drive-managed zoned block device target

 Documentation/device-mapper/dm-zoned.txt |  144 ++
 drivers/md/Kconfig                       |   17 +
 drivers/md/Makefile                      |    2 +
 drivers/md/dm-zoned-metadata.c           | 2514 ++++++++++++++++++++++++++++++
 drivers/md/dm-zoned-reclaim.c            |  570 +++++++
 drivers/md/dm-zoned-target.c             |  970 ++++++++++++
 drivers/md/dm-zoned.h                    |  228 +++
 7 files changed, 4445 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-zoned.txt
 create mode 100644 drivers/md/dm-zoned-metadata.c
 create mode 100644 drivers/md/dm-zoned-reclaim.c
 create mode 100644 drivers/md/dm-zoned-target.c
 create mode 100644 drivers/md/dm-zoned.h

-- 
2.9.4
