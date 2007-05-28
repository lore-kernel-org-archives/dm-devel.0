From: Neil Brown <neilb@suse.de>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Mon, 28 May 2007 11:30:32 +1000
Message-ID: <18010.12472.209452.148229@notabene.brown>
References: <18006.38689.818186.221707@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Friday May 25
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids


Thanks everyone for your input.  There was some very valuable
observations in the various emails.
I will try to pull most of it together and bring out what seem to be
the important points.


1/ A BIO_RW_BARRIER request should never fail with -EOPNOTSUP.

 This is certainly a very attractive position - it makes the interface
 cleaner and makes life easier for filesystems and other clients of
 the block interface.
 Currently filesystems handle -EOPNOTSUP by
  a/ resubmitting the request without the BARRIER (after waiting for
    earlier requests to complete) and
  b/ possibly printing an error message to the kernel logs.

 The block layer can do both of these just as easily and it does make
 sense to do it there.

 md/dm modules could keep count of requests as has been suggested
 (though that would be a fairly big change for raid0 as it currently
 doesn't know when a request completes - bi_endio goes directly to the
 filesystem). 
 However I think the idea of a zero-length BIO_RW_BARRIER would be a
 good option.  raid0 could send one of these down each device, and
 when they all return, the barrier request can be sent to it's target
 device(s).

 I think this is a worthy goal that we should work towards.

2/ Maybe barriers provide stronger semantics than are required.

 All write requests are synchronised around a barrier write.  This is
 often more than is required and apparently can cause a measurable
 slowdown.

 Also the FUA for the actual commit write might not be needed.  It is
 important for consistency that the preceding writes are in safe
 storage before the commit write, but it is not so important that the
 commit write is immediately safe on storage.  That isn't needed until
 a 'sync' or 'fsync' or similar.

 One possible alternative is:
   - writes can overtake barriers, but barrier cannot overtake writes.
   - flush before the barrier, not after.

 This is considerably weaker, and hence cheaper. But I think it is
 enough for all filesystems (providing it is still an option to call
 blkdev_issue_flush on 'fsync').

 Another alternative would be to tag each bio was being in a
 particular barrier-group.  Then bio's in different groups could
 overtake each other in either direction, but a BARRIER request must
 be totally ordered w.r.t. other requests in the barrier group.
 This would require an extra bio field, and would give the filesystem
 more appearance of control.  I'm not yet sure how much it would
 really help...
 It would allow us to set FUA on all bios with a non-zero
 barrier-group.  That would mean we don't have to flush the entire
 cache, just those blocks that are critical.... but I'm still not sure
 it's a good idea.

 Of course, these weaker rules would only apply inside the elevator.
 Once the request goes to the device we need to work with what the
 device provides, which probably means total-ordering around the
 barrier. 

 I think this requires more discussion before a way forward is clear.

3/ Do we need explicit control of the 'ordered' mode?

  Consider a SCSI device that has NV RAM cache.  mode_sense reports
  that write-back is enabled, so _FUA or _FLUSH will be used.
  But as it is *NV* ram, QUEUE_ORDER_DRAIN is really the best mode.
  But it seems there is no way to query this information.
  Using _FLUSH causes the NVRAM to be flushed to media which is a
  terrible performance problem.
  Setting SYNC_NV doesn't work on the particular device in question.
  We currently tell customers to mount with -o nobarriers, but that
  really feels like the wrong solution.  We should be telling the scsi
  device "don't flush".
  An advantage of 'nobarriers' is it can go in /etc/fstab.  Where
  would you record that a SCSI drive should be set to
  QUEUE_ORDERD_DRAIN ??


I think the implementation priorities here are:

1/ implement a zero-length BIO_RW_BARRIER option.
2/ Use it (or otherwise) to make all dm and md modules handle
   barriers (and loop?).
3/ Devise and implement appropriate fall-backs with-in the block layer
   so that  -EOPNOTSUP is never returned.
4/ Remove unneeded cruft from filesystems (and elsewhere).

Comments?

Thanks,
NeilBrown
