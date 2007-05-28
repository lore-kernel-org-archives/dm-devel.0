From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
Date: Mon, 28 May 2007 10:43:49 -0400
Message-ID: <465AEAA5.7000407@tmr.com>
References: <18006.38689.818186.221707@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <18006.38689.818186.221707@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

Neil Brown wrote:
> We can think of there being three types of devices:
>  
> 1/ SAFE.  With a SAFE device, there is no write-behind cache, or if
>           there is it is non-volatile.  Once a write completes it is 
>           completely safe.  Such a device does not require barriers
>           or ->issue_flush_fn, and can respond to them either by a
> 	  no-op or with -EOPNOTSUPP (the former is preferred).
>
> 2/ FLUSHABLE.
>           A FLUSHABLE device may have a volatile write-behind cache.
>           This cache can be flushed with a call to blkdev_issue_flush.
> 	  It may not support barrier requests.
>
> 3/ BARRIER.
> 	  A BARRIER device supports both blkdev_issue_flush and
>           BIO_RW_BARRIER.  Either may be used to synchronise any
> 	  write-behind cache to non-volatile storage (media).
>
> Handling of SAFE and FLUSHABLE devices is essentially the same and can
> work on a BARRIER device.  The BARRIER device has the option of more
> efficient handling.
>   
There are two things I'm not sure you covered.

First, disks which don't support flush but do have a "cache dirty" 
status bit you can poll at times like shutdown. If there are no drivers 
which support these, it can be ignored.

Second, NAS (including nbd?). Is there enough information to handle this 
"really rigt?"

Otherwise looks good as a statement of issues. It seems to me that the 
filesystem should be able to pass the barrier request to the block layer 
and have it taken care of, rather than have code in each f/s to cope 
with odd behavior.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979
