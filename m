From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 3/7] scsi_dh: add generic SPC-3 alua handler
Date: Fri, 16 May 2008 11:37:57 -0700
Message-ID: <1210963077.21974.334.camel@chandra-ubuntu>
References: <20080514144319.543D910B5DF@craiglockhart-ipmi.suse.de>
	 <1210819780.21974.264.camel@chandra-ubuntu>  <482BF09E.2070905@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <482BF09E.2070905@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "jens.axboe" <jens.axboe@oracle.com>
List-Id: dm-devel.ids

It is a question to Jens :) 

On Thu, 2008-05-15 at 10:13 +0200, Hannes Reinecke wrote:
> Chandra Seetharaman wrote:
> > I do not know the functionality of this module. So, my comments are only
> > related to code.
> > 
> > blk_request_rq() frees up the request before it returns (in
> > blk_end_sync_rq()). So, there is no need for blk_put_request().
> > 
> Indeed. But this opens up another question:
> 
> By the time blk_execute_rq() returns, the request is already
> put back onto the queue.
> That means that I shouldn't access rq->errors any more, as
> the request might have been reused already.
> But blk_execute_rq() returns -EIO for any error, making it
> impossible to signal a proper error here.
> So how do I get the contents of rq->errors safely?
> 
> Cheers,
> 
> Hannes

