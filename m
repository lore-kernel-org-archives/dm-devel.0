From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: Bcache upstreaming
Date: Fri, 1 Feb 2013 11:39:44 +0100
Message-ID: <20130201103944.GM8837@soda.linbit>
References: <20130131012627.GF12631@moria.home.lan>
	<20130131012747.GG12631@moria.home.lan>
	<20130131014835.GH12631@moria.home.lan>
	<20130131190249.GA12786@redhat.com>
	<CAC7rs0u_aJS5BsJ0E7wH98z2VxXr=SK1z8yL0-m0Pc85ncJNHg@mail.gmail.com>
	<20130131221711.GA13540@redhat.com>
	<CAC7rs0ue6YgqrX9Nc18GdnVtJd558F6W=BZiMXZdRqig3s7sBA@mail.gmail.com>
	<20130131230800.GB13540@redhat.com>
	<20130201003311.GJ12631@moria.home.lan>
	<20130201033810.GA14867@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130201033810.GA14867@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 31, 2013 at 10:38:11PM -0500, Mike Snitzer wrote:
> On Thu, Jan 31 2013 at  7:33pm -0500,
> Kent Overstreet <koverstreet@google.com> wrote:
> 
> > On Thu, Jan 31, 2013 at 06:08:00PM -0500, Mike Snitzer wrote:
> > > On Thu, Jan 31 2013 at  5:25pm -0500,
> > > Kent Overstreet <kent.overstreet@gmail.com> wrote:
> > > 
> > > > On Thu, Jan 31, 2013 at 2:17 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> > > > > Ah, yeah I had a typo in my script.  When I fixed it I get a BUG (with
> > > > > your latest bcache code) when I try to mkfs.xfs /dev/bcache0:
> > > > 
> > > > Heh, that's the dev branch - you don't want to be running the dev
> > > > branch, there's a lot of buggy crap in there and it almost definitely
> > > > corrupts data. Testing branch should be good, though.
> > > 
> > > OK, I'll pick up changes from -testing until directed elsewhere.
> > > 
> > > BTW, here are couple things I've noticed with bcache:
> > > 
> > > - The log messages seem to have an extra newline at the end.
> > 
> > How are you seeing that/which log messages? I hadn't noticed that
> > myself (do they not get printed somehow?)
> 
> I'm just seeing extra newlines (empty lines), e.g.:
> bcache: run_cache_set() invalidating existing data
> 
> bcache: bch_cached_dev_attach() Caching dm-4 as bcache1 on set 5c0ba0d0-df36-4684-acc5-45f5b4683788
> 
> bcache: register_cache() registered cache device dm-3
> 
> EXT4-fs (bcache1): mounted filesystem with ordered data mode. Opts: discard
> 
> > > - bcache doesn't appear to be establishing proper holders on the devices
> > >   it uses for the backing and cache devices.
> > >   - lsblk doesn't show any associations with bcache devices.
> > 
> > How's that created - what function am I looking for?
> 
> bd_link_disk_holder and bd_unlink_disk_holder

Upstream says:
 * bd_link_disk_holder - create symlinks between holding disk and slave bdev
 * @bdev: the claimed slave bdev
 * @disk: the holding disk
 *
 * DON'T USE THIS UNLESS YOU'RE ALREADY USING IT.
...

 ?

> > >   - the fio utility isn't able to get any stats for the bcache device or
> > >     the devices bcache uses.
> > 
> > I'd been meaning to fix that, never got around to figuring out how those
> > stats are generated. Function/file you can point me to?
> 
> I think you'll get the stats for via genhd (add_disk) -- the stats are
> the 'disk_stats dkstats' member of the genhd's hd_struct.  But as of
> now you'll notice that /sys/block/bcacheX/stat only ever contains 0s.
> 
> part_stat_inc, part_stat_add are the low-level methods for driving the
> counters up.  But I'm not sure why bcache isn't getting these stats  --
> disk stats are something we get for free with DM devices so I haven't
> really had to dig into these mechanics in detail.

dm core does that for you.
for other block devices, you'll have to do that yourself.

My understanding is that you need to do,
in your make_request, where "disk" is your own struct gendisk*:
        const int rw = bio_data_dir(bio);
        int cpu;
        cpu = part_stat_lock();
        part_round_stats(cpu, &disk->part0);
        part_stat_inc(cpu, &disk->part0, ios[rw]);
        part_stat_add(cpu, &disk->part0, sectors[rw], bio_sectors(bio));
        part_inc_in_flight(&disk->part0, rw);
        part_stat_unlock();

and on completion,
(you would need to track the "start time" jiffies somewhere):
	int rw = bio_data_dir(bio);
        unsigned long duration = jiffies - start_time;
        int cpu;
        cpu = part_stat_lock();
        part_stat_add(cpu, &disk->part0, ticks[rw], duration);
        part_round_stats(cpu, &disk->part0);
        part_dec_in_flight(&disk->part0, rw);
        part_stat_unlock();


Cheers,

	Lars Ellenberg
