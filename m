From: Neil Brown <neilb@suse.de>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
Date: Thu, 31 May 2007 10:22:58 +1000
Message-ID: <18014.5474.664638.694584@notabene.brown>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<465C8625.1010001@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from Phillip Susi on Tuesday May 29
Sender: linux-fsdevel-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Tuesday May 29, psusi@cfl.rr.com wrote:
> Neil Brown wrote:
> >  md/dm modules could keep count of requests as has been suggested
> >  (though that would be a fairly big change for raid0 as it currently
> >  doesn't know when a request completes - bi_endio goes directly to the
> >  filesystem). 
> 
> Are you sure?  I believe that dm handles bi_endio because it waits for 
> all in progress bio to complete before switching tables.

I was taking about md/raid0, not dm-stripe.
md/raid0 (and md/linear) currently never know that a request has
completed.

NeilBrown
