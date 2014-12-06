From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHv2 0/4] blk-mq support for dm multipath
Date: Fri, 5 Dec 2014 19:35:18 -0500
Message-ID: <20141206003518.GA1733@redhat.com>
References: <1413589598-17631-1-git-send-email-keith.busch@intel.com>
	<alpine.LNX.2.00.1410281808390.4225@localhost.lm.intel.com>
	<20141028182627.GA28537@redhat.com>
	<20141205232542.GA1274@redhat.com>
	<alpine.LNX.2.00.1412052329050.4225@localhost.lm.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1412052329050.4225@localhost.lm.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Dec 05 2014 at  6:33pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Fri, 5 Dec 2014, Mike Snitzer wrote:
> >Hi Keith,
> >
> >I've found a few issues with your v2.  I've been working through the
> >code and fixing things as I see them.  Please see this branch:
> >https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19-blk-mq
> >
> >My changes build on your v2 baseline.
> >
> >How much testing have you done?  It could be that my changes screwed
> >something up but... I just tried simply creating a normal request-based
> >DM multipath device (using non blk-mq devices) and hit this crash:
> 
> Thanks, Mike. I'll take a look at your fixes next week.
> 
> I only tested on nvme blk-mq. I don't have any SCSI devices to try,
> but I _really_ need to get one if I'm serious about making this work,
> so I'll find something next week as well.

I'll continue review to see if I can sort out why we're getting this crash.

FYI, you don't _need_ real SCSI devices to test dm-multipath.  Easy
enough to just use scsi_debug so long as you have free memory:

 modprobe scsi_debug dev_size_mb=100 num_tgts=1 vpd_use_hostno=0 add_host=4

add_host makes multiple paths
vpd_use_hostno=0 makes sure that all paths will have the same wwid
