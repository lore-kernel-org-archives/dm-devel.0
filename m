From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Revert "dm mpath: remove unnecessary NVMe branching
 in favor of scsi_dh checks"
Date: Tue, 13 Mar 2018 17:41:56 -0400
Message-ID: <20180313214156.GA4325@redhat.com>
References: <20180312202808.3556-1-bart.vanassche@wdc.com>
	<20180312212314.GA30763@redhat.com>
	<1520890358.3469.68.camel@wdc.com>
	<20180313012346.GA31673@redhat.com>
	<1520959432.2638.17.camel@wdc.com>
	<20180313170210.GD2785@redhat.com>
	<20180313170721.GA3262@redhat.com>
	<1520961057.2638.22.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1520961057.2638.22.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 13 2018 at  1:10pm -0400,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Tue, 2018-03-13 at 13:07 -0400, Mike Snitzer wrote:
> > Just a thought: Maybe dm-4.16 (rc4 based) is missing a blk-mq fix?
> > 
> > Might be worth cherry-picking the 2 topmost commits from dm-4.16 into
> > the linus-based (rc5) tree you reported the original issue against?
> > 
> > (looking at jens' rc5 block pull request, it seems unlikely but...)
> 
> Hello Mike,
> 
> Even if that would be the case, that can't have been the cause of what I
> reported. Before I run any dm tests I merge the block layer, SCSI and RDMA
> changes that are scheduled for the next kernel version into the dm tree.

Well I've rebased dm-4.16 ontop of v4.15-rc5.  If you udate to latest
dm-4.16 and look at the following diff it is pretty clear that these
changes will not compromise dm-mpath's "mq" mode (which you're using):

git diff 8d47e65948ddea4398892946d9e50778a316b397^..e8f74a0f00113d74ac18d6de13096f9e2f95618a -- drivers/md/dm-mpath.c

I see no reason why you'd hit hangs with requests lingering on the requeue_list
