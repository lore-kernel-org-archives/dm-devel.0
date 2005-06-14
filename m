From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] HP SW support take 3
Date: Tue, 14 Jun 2005 08:29:03 +0200
Message-ID: <20050614062903.GA32479@averon.dyndns.org>
References: <1118614380.5318.11.camel@mina>
	<20050613131012.GE28625@averon.dyndns.org>
	<42AE220F.4090104@cs.wisc.edu> <42AE23BB.9040706@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <42AE23BB.9040706@cs.wisc.edu>
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

On Mon, Jun 13, 2005 at 07:24:27PM -0500, Mike Christie wrote:
> Mike Christie wrote:
> >Christophe Varoqui wrote:
> >
> >>I confirm a robust behaviour now with take 3.
> >>Here is a take 4 that move to an appropriate "best effort mode", ie 
> >>always return success.
> >>
> >>The point is, whenever DM start submitting io the an asleep controler, 
> >>precede with a START command. If it fails ... too bad, the consecutive 
> >>io will fail and DM will try another PG. Had to do that because take 3 
> >>interprets an error where the controler switch have correctly happened.
> >>
> >
> >ok so is it if the controller is already failed over and we send the 
> >START command, rq->errors had some value so I ended up failing the 
> >operation, right? Let me send a patch that will dump the sense and 
> >rq->errors info out so we can see if there is some nice ASC/ASCQ value 
> >that will tell us this occured like with the LSI boxes.
> 
> oh wait, when I reread this I guess you are saying that I was always 
> gettting a rq->error value when I send a START_STOP and it succeeds?
> 
Here is a "sg_start -s 1" output that successfully activated the controler driving sdc :

[root@s64p17bibrn ~]# sg_start -s 1 /dev/sdc
sync_cache: scsi status: Check Condition
Current, Sense key: Not Ready
[valid=0] Info fld=0x9000000, Additional sense: Logical unit not ready, initializing cmd. required
Raw sense data (in hex):
  70 00 02 09 00 00 00 0a 00 00 00 00 04 02 00 93 01 00
plus...: Driver_status=0x08 (DRIVER_SENSE,SUGGEST_OK)
start_stop: scsi status: Check Condition
Current, Sense key: Not Ready
[valid=0] Info fld=0x9000000, Additional sense: Logical unit not ready, initializing cmd. required
Raw sense data (in hex):
  70 00 02 09 00 00 00 0a 00 00 00 00 04 02 00 93 01 00
plus...: Driver_status=0x08 (DRIVER_SENSE,SUGGEST_OK)

Note subsequent sg_start don't spit any output, the controler is already activated :

[root@s64p17bibrn ~]# sg_start -s 1 /dev/sdc
[root@s64p17bibrn ~]#

Reactivating the first controler outs same sense as before :

[root@s64p17bibrn ~]# sg_start -s 1 /dev/sda
sync_cache: scsi status: Check Condition
Current, Sense key: Not Ready
[valid=0] Info fld=0x9000000, Additional sense: Logical unit not ready, initializing cmd. required
Raw sense data (in hex):
  70 00 02 09 00 00 00 0a 00 00 00 00 04 02 00 93 01 00
plus...: Driver_status=0x08 (DRIVER_SENSE,SUGGEST_OK)
start_stop: scsi status: Check Condition
Current, Sense key: Not Ready
[valid=0] Info fld=0x9000000, Additional sense: Logical unit not ready, initializing cmd. required
Raw sense data (in hex):
  70 00 02 09 00 00 00 0a 00 00 00 00 04 02 00 93 01 00
plus...: Driver_status=0x08 (DRIVER_SENSE,SUGGEST_OK)



Hope it clarifies a bit.
Let me know if I can provide more.

I'm surprised HP guys don't join the party.
Decoding the sense would be easier for them.
Lacking they knowledge, I went for the best effort mode, though I agree it would be better to decode the sense.

Regards,
cvaroqui
