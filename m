From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
Date: Thu, 05 Jul 2007 21:28:17 +0900
Message-ID: <468CE3E1.3000503@gmail.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070530093503.GA15559@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070530093503.GA15559@kernel.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

Hello, Jens.

Jens Axboe wrote:
> On Mon, May 28 2007, Neil Brown wrote:
>> I think the implementation priorities here are:
>>
>> 1/ implement a zero-length BIO_RW_BARRIER option.
>> 2/ Use it (or otherwise) to make all dm and md modules handle
>>    barriers (and loop?).
>> 3/ Devise and implement appropriate fall-backs with-in the block layer
>>    so that  -EOPNOTSUP is never returned.
>> 4/ Remove unneeded cruft from filesystems (and elsewhere).
> 
> This is the start of 1/ above. It's very lightly tested, it's verified
> to DTRT here at least and not crash :-)
> 
> It gets rid of the ->issue_flush_fn() queue callback, all the driver
> knowledge resides in ->prepare_flush_fn() anyways. blkdev_issue_flush()
> then just reuses the empty-bio approach to queue an empty barrier, this
> should work equally well for stacked and non-stacked devices.
> 
> While this patch isn't complete yet, it's clearly the right direction to
> go.

Finally took a brief look. :-) I think the sequencing for zero-length
barrier can be better done by pre-setting QUEUE_ORDSEQ_BAR in
start_ordered() rather than short circuiting the request after it's
issued.  What do you think?

Thanks.

-- 
tejun
