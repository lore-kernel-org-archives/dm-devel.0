From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 00/10] dm: zoned block device support
Date: Fri, 26 May 2017 12:19:54 -0400
Message-ID: <20170526161954.GC18223@redhat.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
	<20170516200356.GA17063@redhat.com>
	<20170517185434.GC21862@redhat.com>
	<22BA92ED-D53B-4206-9DF3-BDFBB6F3E1DB@hgst.com>
	<20170526021211.GA33284@redhat.com>
	<7e0a0545-ee54-e367-5ea4-8b30e03cc10d@wdc.com>
	<20170526142740.GA34211@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170526142740.GA34211@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, May 26 2017 at 10:27am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, May 26 2017 at  5:10am -0400,
> Damien Le Moal <damien.lemoal@wdc.com> wrote:
> 
> > That said, the patch below looks very good, much cleaner than what I had
> > done. Let me test it and I will report back.
> 
> OK, please apply this incremental patch that adds in zone_sectors
> validation, thanks:

I fixed that patch up and staged all your preliminary zoned block device
work into linux-dm.git's 'for-4.13/dm' (and also staged in linux-next).

Please retest against 'for-4.13/dm' and send any incremental fixes you'd
like folded in (implied is 'for-4.13/dm' can be rebased):
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-4.13/dm

FYI, I'll be focusing on reviewing/staging your dm-zoned patch next week
(Tues-Thurs).

Thanks,
Mike
