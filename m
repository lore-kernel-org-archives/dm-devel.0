From: Matteo Frigo <athena@fftw.org>
Subject: Re: [dm-devel] [BUG] pvmove corrupting XFS filesystems (was Re: [BUG]
	Internal error xfs_dir2_data_reada_verify)
Date: Thu, 07 Mar 2013 19:09:31 -0500
Message-ID: <87hakmpxac.fsf@fftw.org>
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
	<20130227010414.GD1514@agk.fab.redhat.com>
	<20130227014900.GY5551@dastard> <87y5eah4xz.fsf@fftw.org>
	<87k3pjs908.fsf@fftw.org> <20130307223140.GU23616@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20130307223140.GU23616@dastard> (Dave Chinner's message of "Fri,
	8 Mar 2013 09:31:40 +1100")
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com
List-Id: dm-devel.ids

Dave Chinner <david@fromorbit.com> writes:

> You need the XFS patch I posted so that readahead buffer
> verification is avoided in the case of an error being returned from
> the readahead.

I apologize if I was not clear in my previous post.  I mean to say that
returning -EIO from dm, even in conjunction with your patch, is not
sufficient to fix the problem.

Specifically, I repeated the experiment with v3.8.2 patched as discussed
below, running my original script (repeated here for completeness):

   pvcreate /dev/vd[bc]
   vgcreate test /dev/vd[bc]
   lvcreate -L 8G -n vol test /dev/vdb
   mkfs.xfs -f /dev/mapper/test-vol
   mount -o noatime /dev/mapper/test-vol /mnt
   cd /mnt
   git clone ~/linux-stable
   cd /
   umount /mnt

   mount -o noatime /dev/mapper/test-vol /mnt
   pvmove -b /dev/vdb /dev/vdc
   sleep 2
   rm -rf /mnt/linux-stable

I obtained a string of errors that starts with this:

  [  166.596574] XFS (dm-1): metadata I/O error: block 0x805060 ("xfs_trans_read_buf_map") error 5 numblks 8
  [  166.599556] XFS (dm-1): metadata I/O error: block 0x805060 ("xfs_trans_read_buf_map") error 5 numblks 8
  [  166.604845] XFS (dm-1): metadata I/O error: block 0x5285b8 ("xfs_trans_read_buf_map") error 5 numblks 8
  [  166.607894] XFS (dm-1): metadata I/O error: block 0x5285b8 ("xfs_trans_read_buf_map") error 5 numblks 8
  [  166.614242] XFS (dm-1): metadata I/O error: block 0x54f2b0 ("xfs_trans_read_buf_map") error 5 numblks 8
  [  166.617307] XFS (dm-1): metadata I/O error: block 0x54f2b0 ("xfs_trans_read_buf_map") error 5 numblks 8
  [  166.651373] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
  [  166.653517] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
  [  166.655545] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
  [  166.657614] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
  [  166.659685] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
  [  166.661731] XFS (dm-1): Corruption detected. Unmount and run xfs_repair
  [  166.663761] XFS (dm-1): Corruption detected. Unmount and run xfs_repair

I used v3.8.2 with the following diff, including both your xfs patch
and my attempt to patch dm-raid1 to return EIO:

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index fa51918..88903e3 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1169,7 +1169,7 @@ static int mirror_map(struct dm_target *ti, struct bio *bio)
 	 */
 	if (!r || (r == -EWOULDBLOCK)) {
                 if (rw == READA)
-			return -EWOULDBLOCK;
+			return -EIO;
 
 		queue_bio(ms, bio, rw);
 		return DM_MAPIO_SUBMITTED;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index fbbb9eb..c961dd4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1024,7 +1024,9 @@ xfs_buf_iodone_work(
 	bool			read = !!(bp->b_flags & XBF_READ);
 
 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
-	if (read && bp->b_ops)
+
+        /* only validate buffers that were read without errors */
+        if (read && bp->b_ops && !bp->b_error && (bp->b_flags & XBF_DONE))
                 bp->b_ops->verify_read(bp);
 
 	if (bp->b_iodone)

So your patch is not sufficient to fix the problem, even if dm returns
-EIO instead of -EAGAIN.  My question is, what is dm supposed to return?

Regards,
MF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
