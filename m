From: Alasdair G Kergon <agk@redhat.com>
Subject: 2.6.12-rc2-udm1
Date: Thu, 21 Apr 2005 23:28:56 +0100
Message-ID: <20050421222856.GL10195@agk.surrey.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/2.6.12-rc2/2.6.12-rc2-udm1.tar.bz2

Updated to 2.6.12-rc2.
Several of these patches ought to be ready to go upstream.

NB If you're using snapshots, don't apply the snapshot patches in there yet!
 
Alasdair
-- 
agk@redhat.com


Revision 1:
  Use %llu not %Lu in sscanf/printf format strings.
  
  Signed-Off-By: Alasdair G Kergon <agk@redhat.com>

Revision 2:
  Store bdev between freeze and thaw.
  
  From: Christoph Hellwig <hch@lst.de>

Revision 3:
  Make __unlock_fs() void.
  
  From: Christoph Hellwig <hch@lst.de>

Revision 4:
  Allow freeze_bdev() to return an error.
  
  From: Christoph Hellwig <hch@lst.de>

Revision 5:
  Handle __lock_fs error etc.
  
  From: Christoph Hellwig <hch@lst.de>

Revision 6:
  Tidy dm_suspend.
  
  From: Christoph Hellwig <hch@lst.de>

Revision 7:
  Handle writes to a snapshot-origin device that has been extended since
  the snapshot was taken.

Revision 8:
  More snapshot metadata reading into separate function.

Revision 9:
  Move snapshot metadata loading to happen when table is created instead
  of when device is resumed.  Origin writes don't trigger exceptions until
  snapshot table becomes active (when resume() is called on snapshot).
  
  NB This patch may break some existing LVM2 and EVMS operations.

Revision 10:
  Flakey.

Revision 11:
  dm-mpath.c needs to use a private workqueue (like other dm targets
  already do) to avoid interfering with users of the default workqueue.
  
  Signed-Off-By: Alasdair G Kergon <agk@redhat.com>
  Acked-by: Jens Axboe <axboe@suse.de>
  Signed-off-by: Lars Marowsky-Bree <lmb@suse.de>
  Signed-off-by: mikenc@us.ibm.com

Revision 12:
  Make the sense data available in the bio end_io path on request.
  
  Signed-off-by: Lars Marowsky-Bree <lmb@suse.de>
  Signed-off-by: Jens Axboe <axboe@suse.de>

Revision 13:
  Use the sense data in the dm-mpath hardware handlers.
  
  Signed-off-by: Lars Marowsky-Bree <lmb@suse.de>

Revision 14:
  The dm emc hardware handler code memset the hardware handler
  structure to zero AFTER it had initialized the structure's
  spinlock field.
  
  Signed-Off-By: Alasdair G Kergon <agk@redhat.com>
  From: Dave Olien <dmo@osdl.org>

Revision 15:
  This patch makes some needlessly global code static.
  
  Signed-Off-By: Alasdair G Kergon <agk@redhat.com>
  Signed-off-by: Adrian Bunk <bunk@stusta.de>

Revision 16:
  dm multipath will report barriers as not supported with this patch.
  
  Signed-off-by: Lars Marowsky-Bree <lmb@suse.de>

Revision 17:
  DM multipath error messages were beyond useless.
   
  From: Lars Marowsky-Bree <lmb@suse.de>

Revision 18:
  mm kgdb
