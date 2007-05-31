From: Neil Brown <neilb@suse.de>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
Date: Thu, 31 May 2007 10:37:31 +1000
Message-ID: <18014.6347.753050.606896@notabene.brown>
References: <18006.38689.818186.221707@notabene.brown>
	<465AEAA5.7000407@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Monday May 28
Sender: linux-fsdevel-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>
List-Id: dm-devel.ids

On Monday May 28, davidsen@tmr.com wrote:
> There are two things I'm not sure you covered.
> 
> First, disks which don't support flush but do have a "cache dirty" 
> status bit you can poll at times like shutdown. If there are no drivers 
> which support these, it can be ignored.

There are really devices like that?  So to implement a flush, you have
to stop sending writes and wait and poll - maybe poll every
millisecond?
That wouldn't be very good for performance....  maybe you just
wouldn't bother with barriers on that sort of device?

Which reminds me:  What is the best way to turn off barriers?
Several filesystems have "-o nobarriers" or "-o barriers=0",
or the inverse.
md/raid currently uses barriers to write metadata, and there is no
way to turn that off.  I'm beginning to wonder if that is best.

Maybe barrier support should be a function of the device.  i.e. the
filesystem or whatever always sends barrier requests where it thinks
it is appropriate, and the block device tries to honour them to the
best of its ability, but if you run
   blockdev --enforce-barriers=no /dev/sda
then you lose some reliability guarantees, but gain some throughput (a
bit like the 'async' export option for nfsd).

> 
> Second, NAS (including nbd?). Is there enough information to handle this 
> "really rigt?"

NAS means lots of things, including NFS and CIFS where this doesn't
apply.
For 'nbd', it is entirely up to the protocol.  If the protocol allows
a barrier flag to be sent to the server, then barriers should just
work.  If it doesn't, then either the server disables write-back
caching, or flushes every request, or you lose all barrier
guarantees. 
For 'iscsi', I guess it works just the same as SCSI...

NeilBrown
