From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Fri, 10 Jun 2011 18:13:30 +0200
Message-ID: <20110610161330.GH22211@barkeeper1-xen.linbit>
References: <Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
	<20110603110111.GA4969@ubuntu>
	<Pine.LNX.4.64.1106071321300.8279@hs20-bc2-1.build.redhat.com>
	<20110609094746.GA3152@ubuntu>
	<Pine.LNX.4.64.1106091136510.7642@hs20-bc2-1.build.redhat.com>
	<20110610084424.GA3672@ubuntu>
	<20110610092834.GB22211@barkeeper1-xen.linbit>
	<20110610101446.GB10144@ubuntu>
	<Pine.LNX.4.64.1106100937430.32120@hs20-bc2-1.build.redhat.com>
	<20110610134759.GA10908@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110610134759.GA10908@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 10, 2011 at 02:48:00PM +0100, Joe Thornber wrote:
> On Fri, Jun 10, 2011 at 09:41:50AM -0400, Mikulas Patocka wrote:
> > This works if the data is directly on the partition, but it won't work on 
> > the device mapper (if MD is on the device mapper, it won't work too).
> > 
> > The device mapper has no function to tell where the bio is finally 
> > remapped, so you can't read disk statistics for that particular disk.
> 
> ok, thx

Right, you do not know which phyical device the IO may end up on,
if it passes through several stacking layers.

But even if that would be desirable in the long term,
it may not be necessary right now? [*]

Jobs on one mapping would not notice that the same physical device may
be busy via some other mapping.

But at least it would notice user (ok, non-kcopyd) IO on the same source
or destination mapping(s), which is a big improvement already, compared
with completely ignoring what is going on?

struct kcopyd_job {
   ...
   struct dm_io_region source;
   struct dm_io_region dests[...];
   ...
}

struct dm_io_region {
   struct block_device *bdev;
   ...
}

struct block_device {
   ...
   struct gendisk *bd_disk;
   ...
}

struct gendisk {
   ...
   struct hd_struct part0;   <--- there live the stats.
   ...
}

[*]
/me wildly handwaving
That could be solved, if we want to.
Add to block_device_operations:
   struct gendisk * (*get_lower_level_gendisk)(struct gendisk*);


struct gendisk *appropriate_function_name(struct gendisk *d)
{
	while (d->fops->get_lower_level_gendisk)
		d = d->fops->get_lower_level_gendisk(d);
	return d;
}

Then have some convenience functions part_stat_read_lowest_level(...).

May have come up before, probably was rejected because of uglyness?

  ;-)


	Lars
