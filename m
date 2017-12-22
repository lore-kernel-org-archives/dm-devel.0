From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH 0/5] block, nvme, dm: allow DM multipath to use
 NVMe's error handler
Date: Fri, 22 Dec 2017 13:02:37 -0500
Message-ID: <20171222180237.GB31792@redhat.com>
References: <20171219210546.65928-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171219210546.65928-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: hch@lst.de, axboe@kernel.dk
Cc: emilne@redhat.com, james.smart@broadcom.com, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, dm-devel@redhat.com, hare@suse.de, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

On Tue, Dec 19 2017 at  4:05pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> These patches enable DM multipath to work well on NVMe over Fabrics
> devices.  Currently that implies CONFIG_NVME_MULTIPATH is _not_ set.
> 
> But follow-on work will be to make it so that native NVMe multipath
> and DM multipath can be made to co-exist (e.g. blacklisting certain
> NVMe devices from being consumed by native NVMe multipath?)
> 
> Patch 1 updates block core to formalize a recent construct that
> Christoph embeedded into NVMe core (and native NVMe multipath):
> callback into a bio-based driver from the blk-mq driver's .complete
> hook to blk_steal_bios() a request's bios.
> 
> Patch 2 switches NVMe over to using the block infrastructure
> established by Patch 1.
> 
> Patch 3 moves the nvme_req_needs_failover() from NVMe multipath to
> core.  Which allow sstacked devices (like DM multipath) to make use of
> NVMe's enhanced error handling.
> 
> Patch 4 updates DM multipath to also make use of the block
> infrastructure established by Patch 1.
> 
> Patch 5 can be largely ignored.. but it illustrates that Patch 1 - 4
> enable DM multipath to avoid extra DM endio callbacks.
> 
> These patches have been developed ontop of numerous DM changes I've
> staged for 4.16, see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.16
> (which happens to include these 5 patches at the end, purely for
> interim linux-next coverage purposes as these changes land in the
> appropriate maintainer tree).
> 
> I've updated the "mptest" DM multipath testsuite to provide NVMe test
> coverage (using NVMe fcloop), see: https://github.com/snitm/mptest
> 
> The tree I've been testing includes all of 'dm-4.16' and all but one
> of the commits from 'nvme-4.16', see:
> https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=dm-4.16_nvme-4.16
> (I've let James Smart know that commit a0b69cc8 causes "nvme connect"
> to not work on my fcloop testbed).
> 
> Jens, provided review is favorable, I'd very much appreciate it you'd
> pick up patches 1 - 3 for 4.16.

BTW, Christoph if you're open to picking up patches 1 - 3 into
'nvme-4.16' that works too.  I just figured since there is a block core
dependency Jens would want to take them direct.

Thanks,
Mike
