From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] IO scheduler based IO controller V6
Date: Wed, 8 Jul 2009 21:58:42 -0400
Message-ID: <20090709015842.GA29117@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<20090708035621.GB3215@balbir.in.ibm.com>
	<20090708134114.GA24048@redhat.com>
	<20090708143925.GE3215@balbir.in.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090708143925.GE3215@balbir.in.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: paolo.valente@unimore.it, dhaval@linux.vnet.ibm.com, snitzer@redhat.com, fernando@oss.ntt.co.jp, jmoyer@redhat.com, linux-kernel@vger.kernel.org, fchecconi@gmail.com, dm-devel@redhat.com, jens.axboe@oracle.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, agk@redhat.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Wed, Jul 08, 2009 at 08:09:25PM +0530, Balbir Singh wrote:
> * Vivek Goyal <vgoyal@redhat.com> [2009-07-08 09:41:14]:
> 
> > On Wed, Jul 08, 2009 at 09:26:21AM +0530, Balbir Singh wrote:
> > > * Vivek Goyal <vgoyal@redhat.com> [2009-07-02 16:01:32]:
> > > 
> > > > 
> > > > Hi All,
> > > > 
> > > > Here is the V6 of the IO controller patches generated on top of 2.6.31-rc1.
> > > > 
> > > > Previous versions of the patches was posted here.
> > > > 
> > > > (V1) http://lkml.org/lkml/2009/3/11/486
> > > > (V2) http://lkml.org/lkml/2009/5/5/275
> > > > (V3) http://lkml.org/lkml/2009/5/26/472
> > > > (V4) http://lkml.org/lkml/2009/6/8/580
> > > > (V5) http://lkml.org/lkml/2009/6/19/279
> > > > 
> > > > This patchset is still work in progress but I want to keep on getting the
> > > > snapshot of my tree out at regular intervals to get the feedback hence V6.
> > > >
> > > 
> > > Hi, Vivek,
> > > 
> > > I was able to compile and boot a 2.6.31-rc1 kernel with this patchset.
> > > I have a request could you fold up all patches and make one
> > > consolidated patch available somewhere (makes it easier to test), may
> > > be a git tree?
> > > 
> > 
> > Thanks for trying it out balbir. Ok, for ease of patching and testing, I 
> > will also maintain a consolidated patch. For V6 you can download the patch
> > from here.
> > 
> > http://people.redhat.com/~vgoyal/io-controller/io-scheduler-based-io-controller-v6.patch
> >
> 
> Thanks, this will definitely help me get more testing done!
>  
> > > I did some quick tests with some io benchmarks and found in a simple
> > > scenario that the scheduler worked as expected, except that it took
> > > very long. I'll investigate further and revert back.
> > 
> > Thanks. I will wait for details.
> >
> 
> I'll try and send something out by Friday, but for now I am not even
> very sure if it is a real problem. I ran iozone on two groups with 500
> and 1000 as weights on the same parition and set fairness to 1 in
> sysfs for the partition. I used a record size of 4 (default) and tried
> to run it on a file size of 1G.
> 

Hi Balbir,

Trying iozone might be a good idea for analyzing the performance impact
of io controller patches but it might not be the best thing to test
fairness.

The biggest reason being that IO controller provides fairness only if
there is constant contention between the groups. If one group goes away
for sometime, other gets to use the disk full. Now while running above
benchmark, there are numerous occasions where disk is not contended for
and we don't see fairness numbers in user space.

I would recommend trying out fio or small tests to begin with which
can create continuously backlogged queues at the disk to see how 
accurate the io-controller is.

> BTW, I don't see anything about weights being multiple of an expected
> figure documented anywhere. I tried weights of 1024 (similar to the
> scheduler and got shouted back at :) ). Does the documentation patch
> specify the expected range for weights? 
> 

Weight range is 1-1000. I will update documentation to reflect this.
Thanks for pointing it out.

Vivek
