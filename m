From: Christoph Hellwig <hch@lst.de>
Subject: Re: Kernel v4.1-rc1 + MQ dm-multipath + MQ SRP oops
Date: Wed, 29 Apr 2015 15:24:03 +0200
Message-ID: <20150429132403.GB3876@lst.de>
References: <553F7474.70905@sandisk.com> <20150428135258.GA16267@redhat.com>
	<20150428215456.GA18306@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150428215456.GA18306@redhat.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Tue, Apr 28, 2015 at 05:54:57PM -0400, Mike Snitzer wrote:
> Turns out that after running hch's script, with multipathd having setup
> an mpath device ontop of tcm_loop, if I just do:
> 
> tcm_loop --unload
> 
> (tcm_loop appears to allow me to remove the devices out from underneath dm-multipath)

That has nothing to do with tcm_loop.  SCSI devices can get unregistered
any time, and we use refcountin to ensure the structures stay in place
forever.

See my reply to Bart for what I suspect is the real issue.
