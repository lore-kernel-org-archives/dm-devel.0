From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/5] block: Move integrity kobject to struct
	gendisk
Date: Wed, 16 Sep 2015 13:26:01 -0400
Message-ID: <20150916172601.GA25973@redhat.com>
References: <20150721120102.GB1654@infradead.org>
	<1440103314-31610-1-git-send-email-martin.petersen@oracle.com>
	<1440103314-31610-2-git-send-email-martin.petersen@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1440103314-31610-2-git-send-email-martin.petersen@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Matthew Wilcox <willy@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: dm-devel.ids

On Thu, Aug 20 2015 at  4:41pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> The integrity kobject purely exists to support the integrity
> subdirectory in sysfs and doesn't really have anything to do with the
> blk_integrity data structure. Move the kobject to struct gendisk where
> it belongs.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Sagi Grimberg <sagig@mellanox.com>

[I understand both Martin and Keith are on vacation but I'm putting the
time to this now with the understanding that a proper exchange may be
delayed.]

Thinking about this series further: I don't really agree with it.
Maybe in the end the benefit of embedding in gendisk outweighs the
complexity of dynamic allocation... but I need to see it for myself.

Christoph, if you _know_ this to be the right way forward I can accept
it but please elaborate further.

What we currently have (before this patchset) has the very real benefit
of not wasting any memory if the block device doesn't have integrity
(DIF/DIX) support.  Especially given how rare bip supporting devices
still are.  Is there reason to expect they won't be so rare in the
future?  Every NVMe and nvdimm device will have integrity support?

This patch moves thes 64 byte 'struct kobject' out into 'struct
gendisk'.  I'm not seeing why (on x86_64 anyway) we'd what to always
allocate an extra 76 bytes (blk_integrity + kobject) for _every_ gendisk
regardless of whether a bip is needed..

76 bytes may not sound like a lot but in the context of DM-mpath that
adds up when you have systems with 1000s of devices with multiple paths
and then a DM mpath device (with its own gendisk) ontop -- 1000 devices
with 4 paths can waste 5000 * 76bytes = ~372K (even 372K isn't much...)

If DM-core could support existing dynamic bip (albeit with more involved
code born out of DM-specific quirks of device stacking and inactive and
active tables) then I have to believe NVMe can too.

As such I'm now going to shift my focus to revisiting what is so hard
for NVMe that it cannot cope with the existing dynamic allocation of
struct blk_integrity.

[If that turns out to be a waste of time (and NVMe/nvdimm/whatever would
be needlessly inconvenienced) then I'll switch back to fixing DM to cope
with this change.  But to be clear the current proposed DM changes
_cannot_ go upstream.]
