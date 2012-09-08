From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] reworked dm-switch target
Date: Sat, 8 Sep 2012 12:35:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1209081219070.13731@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1208151832280.8587@file.rdu.redhat.com>
	<20120816070955.GA32526@agk-dp.fab.redhat.com>
	<C3B343EE19BD2940B6AEC40C9BE99426094C0C@AUSX10MPS302.AMER.DELL.COM>
	<Pine.LNX.4.64.1208201429110.18279@file.rdu.redhat.com>
	<20120821163329.GA21395@freewill.lab.equallogic.com>
	<Pine.LNX.4.64.1208212026500.1653@file.rdu.redhat.com>
	<20120824181444.GC27819@freewill.lab.equallogic.com>
	<Pine.LNX.4.64.1208292038560.17228@file.rdu.redhat.com>
	<20120907195851.GA30209@freewill.lab.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120907195851.GA30209@freewill.lab.equallogic.com>
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

Hi

On Fri, 7 Sep 2012, Jim Ramsay wrote:

> On Wed, Aug 29, 2012 at 08:51:06PM -0400, Mikulas Patocka wrote:
> > Basically, the worst performance brake is the spinlock in your code, 
> > otherwise there is not much difference. vmalloc doesn't slow it down 
> > (actually it was slightly faster with vmalloc than with kmalloc).
> 
> Thanks very much for your performance testing.  I've completed my
> testing too, and my results agree with yours.  When running against our
> actual iSCSI storage solution, the IO performance for this vmalloc-based
> code is equivalent to the 2-step kmalloc code.
> 
> I also did a side-by-side comparison of uploading 1048576 page table
> entries.  The netlink code averaged out to 0.0026s, and the DM message
> code averaged out to 0.042s.  As expected, the message code is slower,
> but well within reasonable performance expectations.
> 
> I am attaching below an updated version of your 'dm-switch.c' file,
> based on your latest post in
> http://www.redhat.com/archives/dm-devel/2012-August/msg00224.html that
> makes the following changes:
> 
>  1. Support for FLUSH and DISCARD operations by implementing
>     target_type.iterate_devices and handling (bio->bi_rw & REQ_FLUSH) in
>     switch_map.  Sends DISCARD to one path, FLUSH to each path.
> 
>  2. Send IOCTLs to the device who owns sector 0, instead of
>     pctx->dev_list[0]
> 
>  3. Copyright notice update in header, plus adding myself to
>     MODULE_AUTHOR
> 
> (Question: Would you prefer these as a patch series against your dm-switch.c
> instead?)

You don't have to send it as a patch, I can trivially create the patch on 
my own.

Your changes are ok, it could be included in the kernel.

Regarding flushes ... could you please explain how write-back caching 
works in your design?

Is there some write-back cache in the host adapter?

Is there some write-back cache in the individual storage nodes? (i.e. does 
the node signal end of I/O before it finishes writing data to the disk) 

How does the node deal with write-back cache in the disk? Does the node 
turn on write back cache in the disk? Does the node send SYNCHRONIZE CACHE 
commands to the disk automatically? Or does it send SYNCHRONIZE CACHE 
commands only when flush is received over the network?

I'd like to know these things to better understand the behavior of the 
flush request.


Another thing - please resend your code with "Signed-off-by". Read the 
meaning of "Signed-off-by" in Documentation/SubmittingPatches, agree to 
the terms and append "Signed-off-by: Jim Ramsay <jim_ramsay@dell.com>" to 
the code. It is a legal requirement, so that you certify that the code is 
under the open source license and that you have the right to distribute 
the code.

Mikulas
