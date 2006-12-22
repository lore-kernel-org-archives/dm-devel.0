From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: Re: [RFC PATCH 2/8] rqbased-dm: add block layer hook
Date: Fri, 22 Dec 2006 14:55:32 -0500 (EST)
Message-ID: <20061222.145532.104028283.k-ueda@ct.jp.nec.com>
References: <20061221074947.GC17199@kernel.dk>
	<20061221.172246.21934588.k-ueda@ct.jp.nec.com>
	<458B86D4.3000107@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <458B86D4.3000107@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, mchristi@redhat.com, jens.axboe@oracle.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Mike,

On Fri, 22 Dec 2006 01:18:44 -0600, Mike Christie <michaelc@cs.wisc.edu> wrote:
> > In addition to the suggested approach, what do you think about
> > adding a new flag to req->cmd_flags which lets the end_io() handler
> > not to return bio to upper layer?
> > It will be useful for multipathing and can be done even within
> > the current __end_that_request_first().
> > For example,
> > 
> > static int __end_that_request_first()
> > {
> > 	.....
> > 	error = 0;
> > 	if (end_io_error(uptodate))
> > 		error = !uptodate ? -EIO : uptodate;
> > 	.....
> > 	if (error && (req->cmd_flags & "NEW_FLAG"))
> > 		return 0; /* Tell the driver to call end_that_request_last() */
> > 
> > 	total_types = bio_nbytes = 0;
> > 	while ((bio = req->bio) != NULL) {
> > 		..... /* process of finishing bios */
> > 	}
> > 	.....
> > }
> > 
> 
> Who would call end_that_request_first with the new flag set? The scsi
> layer or multipath layer?

Multipath layer sets the new flag.
SCSI layer of an underlying device calls __end_that_request_first()
for a cloned request.  And original bios which were issued to a dm
device will be completed through the cloned request when no error
occurs on the clone.  When an error occurs, the completion process of
the bios are skipped.

Thanks,
Kiyoshi Ueda
