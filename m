From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Re: [PATCH] dm-mpath-rdac: don't stomp on a
	request's transfer bit.
Date: Fri, 20 Jul 2007 18:25:51 -0700
Message-ID: <1184981151.5146.88.camel@linuxchandra>
References: <4696D6CB.6050504@csupomona.edu>
	<1184292400.5146.45.camel@linuxchandra>
	<20070713023743.GA5350@us.ibm.com>
	<20070717210706.GA2277@plap.qlogic.org>
	<46A13FB3.2070704@csupomona.edu>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46A13FB3.2070704@csupomona.edu>
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
List-Id: dm-devel.ids

Hi Brian,

trying to test it out now before i send an ack. Will do so as soon as I
verify it.

regards,

chandra
On Fri, 2007-07-20 at 16:05 -0700, Brian De Wolf wrote:
> Andrew Vasquez wrote:
> > Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > ---
> > 
> > 	On Thu, 12 Jul 2007, Mike Anderson wrote:
> > 
> > 	> Copying this mail to linux-scsi and Ccing Andrew Vasquez to possibly
> > 	> provide input on the Qlogic behavior.
> > 	...
> > 
> > 	> > > Jul 12 17:11:15 jimbo kernel: qla2xxx 0000:02:01.1: ISP System Error - mbx1=0h
> > 	> > > mbx2=8012h mbx3=8002h.
> > 	> > > Jul 12 17:11:15 jimbo kernel: qla2xxx 0000:02:01.1: Firmware has been previously
> > 	> > > dumped (ffffc2000171d000) -- ignoring request...
> > 	> > > Jul 12 17:11:16 jimbo kernel: qla2xxx 0000:02:01.1: Performing ISP error
> > 	> > > recovery - ha= ffff81007e85c530.
> > 
> > 	So what's happening here is the firmware is detecting a Xfer-ready
> > 	from the storage when in fact the data-direction for a mode-select
> > 	should be a write (DATA_OUT).
> > 
> > 	The following patch fixes the problem (typo).  Verified by Brian, as
> > 	well.
> > 
> > diff --git a/drivers/md/dm-mpath-rdac.c b/drivers/md/dm-mpath-rdac.c
> > index 8b776b8..16b1613 100644
> > --- a/drivers/md/dm-mpath-rdac.c
> > +++ b/drivers/md/dm-mpath-rdac.c
> > @@ -292,7 +292,7 @@ static struct request *get_rdac_req(struct rdac_handler *h,
> >  	rq->end_io_data = h;
> >  	rq->timeout = h->timeout;
> >  	rq->cmd_type = REQ_TYPE_BLOCK_PC;
> > -	rq->cmd_flags = REQ_FAILFAST | REQ_NOMERGE;
> > +	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
> >  	return rq;
> >  }
> >  
> > 
> 
> Is this patch going to be adopted into the official linux kernel?  I only see
> the big dm-mpath-rdac patch, but I don't think that one works properly without
> this one.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
