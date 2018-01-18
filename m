From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Thu, 18 Jan 2018 17:35:54 -0500
Message-ID: <1516314954.24506.6.camel@redhat.com>
References: <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
         <20180118170353.GB19734@redhat.com> <1516296056.2676.23.camel@wdc.com>
         <20180118183039.GA20121@redhat.com> <1516301278.2676.35.camel@wdc.com>
         <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
         <20180118204856.GA31679@redhat.com> <1516309128.2676.38.camel@wdc.com>
         <20180118212327.GB31679@redhat.com> <1516311554.2676.50.camel@wdc.com>
         <20180118220132.GA20860@redhat.com> <1516313920.24506.4.camel@redhat.com>
         <1516314239.2676.79.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1516314239.2676.79.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Thu, 2018-01-18 at 22:24 +0000, Bart Van Assche wrote:
> On Thu, 2018-01-18 at 17:18 -0500, Laurence Oberman wrote:
> > OK, I ran 5 at once of 5 separate mount points.
> > I am using 4k block sizes
> > Its solid consistent for me. No stalls no gaps.
> 
> Hi Laurence,
> 
> That's great news and thank you for having shared this information
> but I think
> it should be mentioned that you have been running my tree in which
> some recent
> block and dm patches were reverted
> (https://github.com/bvanassche/linux/tree/block-scsi-for-next)
> 
> > 
> > [global]
> > name=02-mq
> > filename=fio-output-02-mq.txt
> > rw=randwrite
> > verify=md5
> > ;rwmixread=60
> > ;rwmixwrite=40
> > bs=4K
> > ;direct=1
> > ;numjobs=4
> > ;time_based=1
> > runtime=120
> > 
> > [file1]
> > size=3G
> > ioengine=libaio
> > iodepth=16
> > 
> > I watch I/O and I see it ramp up but fio still runs and it kind of
> > shuts down.
> 
> In test "file1" I see an I/O size of 3G. Does that mean that the
> patch that
> should fix the sgl_alloc() issue is working?
> 
> Thanks,
> 
> Bart.

Hello Bart Thank you.

OK, so booting into Mike tree now and then hopefully I get the lockups.
Can you give me some idea of what to look for.
I assume I/O just stops.

I want to get this happening in-house so we have an avenue to fix this.
Following getting the stall I will attend to the slg patch test for the
SRPT side.

Please note I am not running latest SRPT right now as you know.

Regards
Back later with results
