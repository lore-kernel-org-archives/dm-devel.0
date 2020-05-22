From: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] block: Improve io_opt limit stacking
Date: Fri, 22 May 2020 07:14:47 -0700
Message-ID: <20200522141447.GB3423299@dhcp-10-100-145-180.wdl.wdc.com>
References: <20200514065819.1113949-1-damien.lemoal@wdc.com>
 <BY5PR04MB6900144BD2729172EBF5DF2EE7B40@BY5PR04MB6900.namprd04.prod.outlook.com>
 <yq1lflkp0b9.fsf@ca-mkp.ca.oracle.com>
 <yq1ftbsp06e.fsf@ca-mkp.ca.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1ftbsp06e.fsf@ca-mkp.ca.oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, May 22, 2020 at 09:36:18AM -0400, Martin K. Petersen wrote:
> 
> >>> +	if (t->io_opt & (t->physical_block_size - 1))
> >>> +		t->io_opt = lcm(t->io_opt, t->physical_block_size);
> >
> >> Any comment on this patch ?  Note: the patch the patch "nvme: Fix
> >> io_opt limit setting" is already queued for 5.8.
> >
> > Setting io_opt to the physical block size is not correct.
> 
> Oh, missed the lcm(). But I'm still concerned about twiddling io_opt to
> a value different than the one reported by an underlying device.
>
> Setting io_opt to something that's less than a full stripe width in a
> RAID, for instance, doesn't produce the expected result. So I think I'd
> prefer not to set io_opt at all if it isn't consistent across all the
> stacked devices.

We already modify the stacked io_opt value if the two request_queues
report different io_opt's. If, however, only one reports an io_opt value,
and it happens to not align with the other's physical block size, the
code currently rejects stacking those devices. Damien's patch should
just set a larger io_opt value that aligns with both, so if one io_opt
is a RAID stripe size, the stacked result will be multiple stripes.

I think that makes sense, but please do let us know if you think such
mismatched devices just shouldn't stack.
