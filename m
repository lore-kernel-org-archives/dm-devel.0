From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] [PATCH 4/7] scsi_dh: add EMC Clariion device handler
Date: Wed, 16 Apr 2008 16:59:44 -0700
Message-ID: <1208390384.1025.40.camel@chandra-ubuntu>
References: <20080416011818.19580.41106.sendpatchset@chandra-ubuntu>
	 <20080416011842.19580.92056.sendpatchset@chandra-ubuntu>
	 <4806294C.9090703@cs.wisc.edu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <4806294C.9090703@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: andmike@us.ibm.com, linux-scsi@vger.kernel.org, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, jens.axboe@oracle.com, agk@redhat.com
List-Id: dm-devel.ids


On Wed, 2008-04-16 at 11:29 -0500, Mike Christie wrote:
> Chandra Seetharaman wrote:
> > +
> > +static int send_cmd(struct scsi_device *sdev, int cmd)
> > +{
> > +	struct request *rq = get_req(sdev, cmd);
> > +
> > +	if (!rq)
> > +		return SCSI_DH_RES_TEMP_UNAVAIL;
> > +
> > +	return blk_execute_rq(sdev->request_queue, NULL, rq, 1);
> > +}
> > +
> 
> My only concerns are:
> 
> 1. EMC and HP need to send a command to every device to transition them. 
> Because we do blk_execute_rq from the dm multipath workqueue we can now 
> only failover/failback for a couple devices at a time.
> 

> I am not sure if this is a big deal, because this the error handler path 
> so it is going to be slower than the normal path. But it seems like 

Yes. But...

pg_init() due to failover/failback will be sent only when I/O is
sent/resent to a multipath device, isn't it ? and we don't expect I/Os
to be sent to all the devices at the same time (all the time), do we ?

So, as you pointed, is it a big deal ? :)

BTW, As you know, it was originally coded that way(patchset posted on
Jan 23, 2008) and later changed as per James comments (through you) that
the code was overusing blk_execute_rq_nowait().
 
> customers are really picky about failover times and want them as fast as 
> possible. If they have a couple hundred devices doing a couple at a time 
> might be something that users see as a regression from the old code. I 
> am not sure though. I just do not want the bugzillas when they come to 
> work :)
> 
> 2. EMC guys did you test the short vs long tress pass stuff? Do we need 
> to add some code to handle the case where we send a short one, but we 
> needed to send a long one. Is there some sense error or some inquiry 
> data we can base this off of?
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

