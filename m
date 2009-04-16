From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Re: dm-ioband: Test results.
Date: Thu, 16 Apr 2009 09:32:30 -0400
Message-ID: <20090416133230.GA8896@redhat.com>
References: <20090413144626.GF18007@redhat.com>
	<20090414.183022.71120459.ryov@valinux.co.jp>
	<20090415170415.GE15067@redhat.com>
	<20090416.215630.183034963.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090416.215630.183034963.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: vivek.goyal2008@gmail.com, Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Nauman Rafique <nauman@google.com>, agk@redhat.com, Balbir Singh <balbir@linux.vnet.ibm.com>
List-Id: dm-devel.ids

On Thu, Apr 16, 2009 at 09:56:30PM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> > How does your ioband setup looks like. Have you created at least one more
> > competing ioband device? Because I think only in that case you have got
> > this ad-hoc logic of waiting for the group which has not finished the
> > tokens yet and you will end up buffering the bio in a FIFO.
> 
> I created two ioband devices and ran the dd commands only on the first
> device.

Ok. So please do let me know how to debug it further. At the moment I 
think it is a problem with dm-ioband and most likely either coming
from buffering of bios in single queue or due to delays introduced
because of waiting mechanism to let slowest process catch up.

I have looked at that code 2-3 times but never understood it fully. Will
give it a try again. I think code quality there needs to be improved.

> 
> > Do let me know if you think there is something wrong with my
> > configuration.
> 
> >From a quick look at your configuration, there seems to be no problem.
> 
> > Can you also send bio-cgroup patches which apply to 2.6.30-rc1 so that
> > I can do testing for async writes.
> 
> I've just posted the patches to related mailing lists. Please try it.

Which mailing list you have posted to. I am assuming you did it to
dm-devel list. Please keep all the postings to both lkml and dm-devel
list for sometime while we are discussing the fundamental issues which
are also of concern from generic IO controller point of view and not
limited to dm only.

> 
> > Why have you split the regular patch and bio-cgroup patch? Do you want
> > to address only reads and sync writes?
> 
> For the first step, my goal is to merge dm-ioband into device-mapper,
> and bio-cgroup is not necessary for all situations such as bandwidth
> control on a per partition basis.

IIUC, bio-cgroup is necessary to account for async writes otherwise writes
will be accounted to submitting task. Andrew Morton clearly mentioned
in one of the mails that writes have been our biggest problem and he
wants to see a clear solution for handling async writes. So please don't
split up both the patches and keep these together.

So if you are not accounting for async writes, what kind of usage you have
got in mind? Any practical work load will have both reads and writes
going. So if a customer creates even two groups say A and B and both are
having async writes also going, what kind of gurantees will you offer
to these guys?

IOW, with just sync bio handling as your first step, what kind of usage
scenario you are covering?

Secondly, per partition control sounds bit excessive. Why per disk 
control is not sufficient? That's where the real contention for resources
is. And even if you really want equivalent of per partition contorl one
should be able to achive it with to level of cgroup hierarchy.

			root
		      /    \
		   sda1G   sda2g

So if there are two partitions in a disk, just create two groups and put
the processes doing IO to partition sda1 in group sda1G and processes
doing IO to partition sda2 in sda2g and assign the weights to the groups
the way you want to the IO to be distributed between these two partitions.

But in the end, I think doing per partition control is excessive. If
you really want that kind of isolation, then from storage array carve
out another device/logical unit and create a separate device and do
IO on that.		

Thanks
Vivek

> 
> I'll also try to do more test and report you back.
> 

> Thank you for your help,
> Ryo Tsuruta
