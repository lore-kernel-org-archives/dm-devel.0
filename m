From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-crypt: limit the number of allocated pages
Date: Mon, 11 Sep 2017 19:57:56 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1709111952270.31898@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1708132240130.18210@file01.intranet.prod.int.rdu2.redhat.com>
	<CAGnHSEm2Jz35Em6h-a8ofXr9ApgBKJq5mOCG9ZtN4+FuRxj8Aw@mail.gmail.com>
	<alpine.LRH.2.02.1708142007510.24994@file01.intranet.prod.int.rdu2.redhat.com>
	<CAGnHSEnrTnvrkNdYJodSL51VUA+=FemdXEMnQ30rVwjCOHMoYA@mail.gmail.com>
	<alpine.LRH.2.02.1708191318110.2380@file01.intranet.prod.int.rdu2.redhat.com>
	<CAGnHSEnDFc+XJDj9LtHjxJy+vSYS7HNK=F=nUH7tzsWPQozCeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAGnHSEnDFc+XJDj9LtHjxJy+vSYS7HNK=F=nUH7tzsWPQozCeA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tom Yan <tom.ty89@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com, hch@lst.de, Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Fri, 25 Aug 2017, Tom Yan wrote:

> On 20 August 2017 at 01:34, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > If you issue a single ioctl that takes extreme amount of time - the kernel
> > warns about being blocked for extreme amount of time - what else should it
> > do?
> >
> 
> But as I said, it does NOT warn about being blocked if the ioctl is
> issued for a SCSI device (i.e. blkdiscard -z /dev/sdX), so why the
> warning occurs / cannot be avoided in the case of a dm(-crypt)
> container?

The SCSI disk blocks in the make_request_fn routine, dm-crypt accepts the 
requests without blocking there. If you set high nr_requests value for the 
SCSI disk, it would not block and the same warning would occur.

> One thing I can see is, when blkdiscard -z is running on a dm-crypt
> container, iostat list it with a big avgqu-sz (not to be mixed up with
> avgrq-sz), starting from ~40000 (the underlying device is a 37G

There is large nubmer of requests in flight, so it reports large number of 
requests in flight. This isn't problem. The disk has 37G, average request 
size is 1024kB, 37G/1024k=37888.

Mikulas

> partition), gradually dropping to 0 (when the job is finished) with a
> step of ~40; all other items are 0 for the container (except %util,
> also 100% for most of the time). While for the underlying device, no
> matter if it is written to through a dm-crypt container, its lines
> stays at something like these:
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdb               0.00     0.00    0.00   85.00     0.00 43520.00
> 1024.00   144.71 1664.89    0.00 1664.89  11.76 100.00
> sdb               0.00     0.00    0.00   86.00     0.00 44032.00
> 1024.00   142.34 1694.70    0.00 1694.70  11.63 100.00
> 
