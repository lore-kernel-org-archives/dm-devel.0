From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] reworked dm-switch target
Date: Tue, 11 Sep 2012 13:13:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1209111309070.11273@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1208151832280.8587@file.rdu.redhat.com>
	<20120816070955.GA32526@agk-dp.fab.redhat.com>
	<C3B343EE19BD2940B6AEC40C9BE99426094C0C@AUSX10MPS302.AMER.DELL.COM>
	<Pine.LNX.4.64.1208201429110.18279@file.rdu.redhat.com>
	<20120821163329.GA21395@freewill.lab.equallogic.com>
	<Pine.LNX.4.64.1208212026500.1653@file.rdu.redhat.com>
	<20120824181444.GC27819@freewill.lab.equallogic.com>
	<Pine.LNX.4.64.1208292038560.17228@file.rdu.redhat.com>
	<20120907195851.GA30209@freewill.lab.equallogic.com>
	<Pine.LNX.4.64.1209081219070.13731@file.rdu.redhat.com>
	<20120911130702.GA12315@freewill.lab.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120911130702.GA12315@freewill.lab.equallogic.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jim Ramsay <jim_ramsay@dell.com>
Cc: dm-devel@redhat.com, Jason_Shamberger@dell.com, agk@redhat.com, Kevin_OKelley@dell.com
List-Id: dm-devel.ids



On Tue, 11 Sep 2012, Jim Ramsay wrote:

> 
> On Sat, Sep 08, 2012 at 12:35:22PM -0400, Mikulas Patocka wrote:
> > Your changes are ok, it could be included in the kernel.
> > 
> > Regarding flushes ... could you please explain how write-back caching 
> > works in your design?
> 
> We are not actually using write-back caching in our design at all, but
> assumed that for a general-purpose DM device like dm-switch, some
> underlying storage may rely on REQ_FLUSH to ensure proper data
> synchronization, so the switch should do the right thing when required.
> The code is modeled on dm-stripe.

So you don't need to process REQ_FLUSH at all. REQ_FLUSH doesn't impose 
any request synchronization, it only flushes the hardware cache - and 
there is no cache. I would remove REQ_FLUSH support if it has no use.

dm-switch is used directly on host adapters (or maybe dm-mpath that is 
connected on host adapters), there is no intermediate layer that would 
need REQ_FLUSH.

Mikulas

> > Is there some write-back cache in the host adapter?
> 
> No, there is not at this time.
> 
> > Is there some write-back cache in the individual storage nodes? (i.e. does 
> > the node signal end of I/O before it finishes writing data to the disk) 
> 
> No, there is not at this time.  The iSCSI-backed SD devices we are
> ultimately using do not advertise any write-back cache ('sdparm
> --get=WCE' returns 0).
> 
> > Another thing - please resend your code with "Signed-off-by". Read the 
> > meaning of "Signed-off-by" in Documentation/SubmittingPatches, agree to 
> > the terms and append "Signed-off-by: Jim Ramsay <jim_ramsay@dell.com>" to 
> > the code. It is a legal requirement, so that you certify that the code is 
> > under the open source license and that you have the right to distribute 
> > the code.
> 
> Will do shortly.  Thanks!
> 
> -- 
> Jim Ramsay
> 
