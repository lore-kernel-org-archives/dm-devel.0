From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Fri, 25 May 2007 11:11:03 -0400
Message-ID: <4656FC87.6030901@cfl.rr.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Neil Brown wrote:
> There is no guarantee that a device can support BIO_RW_BARRIER - it is
> always possible that a request will fail with EOPNOTSUPP.

Why is it not the job of the block layer to translate for broken devices 
and send them a flush/write/flush?

>    These devices would find it very hard to support BIO_RW_BARRIER.
>    Doing this would require keeping track of all in-flight requests
>    (which some, possibly all, of the above don't) and then:

The device mapper keeps track of in flight requests already.  When 
switching tables it has to hold new requests and wait for in flight 
requests to complete before switching to the new table.  When it gets a 
barrier request it just needs to do the same thing, only not switch 
tables.

>    I think the best approach for this class of devices is to return
>    -EOPNOSUP.  If the filesystem does the wait (which they all do
>    already) and the blkdev_issue_flush (which is easy to add), they
>    don't need to support BIO_RW_BARRIER.

Why?  The personalities should just pass the BARRIER flag down to each 
underlying device, and the dm common code should wait for all in flight 
io to complete before sending the barrier to the personality.

> For devices that don't support QUEUE_ORDERED_TAG (i.e. commands sent to
> the controller can be tagged as barriers), SCSI will use the
> SYNCHRONIZE_CACHE command to flush the cache after the barrier
> request (a bit like the filesystem calling blkdev_issue_flush, but at

Don't you have to flush the cache BEFORE the barrier to ensure that 
previous IO is committed first, THEN the barrier write?
