From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: dm-mq and end_clone_request()
Date: Tue, 19 Jul 2016 15:57:34 -0700
Message-ID: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Mike,

If I run a fio data integrity test against kernel v4.7-rc7 then I see 
often that fio reports I/O errors if a path is removed despite 
queue_if_no_path having been set in /etc/multipath.conf. Further 
analysis showed that this happens because during SCSI device removal a 
SCSI device enters state SDEV_CANCEL before the block layer queue is 
marked as "dying". In that state I/O requests submitted to that SCSI 
device are failed with -EIO. The behavior for end_clone_request() in 
drivers/md/dm.c for such requests is as follows:
- With multiqueue support disabled, call __blk_put_request() and ignore
   the "error" argument passed to end_clone_request().
- With multiqueue support enabled, pass the "error" argument to
   dm_complete_request().

Shouldn't end_clone_request() requeue failed requests in both cases 
instead of passing the I/O error to the submitter only if multiqueue is 
enabled?

Thanks,

Bart.
