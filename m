From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [dm-devel] [PATCH 21/24] dm-dirty-log: allow log size to be
 different from target size.
Date: Thu, 03 Jun 2010 02:53:37 +0200
Message-ID: <1275526417.30896.62.camel@o>
References: <20100601094414.565.3638.stgit@notabene.brown>
	 <20100601095620.565.10070.stgit@notabene.brown>
	 <1275490641.30896.40.camel@o>  <20100603101018.6b56df8e@notabene.brown>
Reply-To: heinzm@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100603101018.6b56df8e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Thu, 2010-06-03 at 10:10 +1000, Neil Brown wrote:
> [Insert obligatory grumble about Reply-to headers inserted by
>  mail-list software.  Adding linux-raid back to the cc list...]
> 
> On Wed, 02 Jun 2010 16:57:21 +0200
> Heinz Mauelshagen <heinzm@redhat.com> wrote:
> 
> > Neil,
> > 
> > I had a first review through your patch series, which look mostly good
> > to me.
> > 
> > I've got 2 points so far before I go for tests and further review:
> > 
> > o there's actually no need to change the dm-dirty-log interface in an
> >   incompatible way to allow for what's needed (see patch attached on top
> >   of your series) which we can't do in RHEL/SUSE/... anyway.
> 
> Yes I know.  I saw that work-around in your original patch.
> However this patch set isn't aimed at RHEL or SLES, it is aimed upstream.
> And when we do things upstream we do them *right*.
> If we then want to backport them to RHEL/SLES which require ABI
> compatibility, then little hacks like the one you show (i.e. lying about the
> size of the target when creating the log) may be perfectly appropriate.

Ok, we're in agreement then WRT ABI/API compatibility requirements in
distribution main releases as opposed to flexibility in upstream.

> 
> > 
> >   Notwithstanding, we need a discussion on dm-devel to justify if we
> >   should change the API upstream in order to avoid such workaround as in
> >   my attached patched.
> 
> Certainly it is appropriate to discuss this API change - that is why I
> highlighted it in my introduction to the patch set.  Do you have an opinion
> on it?
> 

I'd like to avoid it altogether in order to avoid multiple code bases
wherever possible.

> 
> > 
> > o any reason you limit the dm-dirty-log type to 'core' ?
> 
> That is only in the earlier part of the patch set.  md/raid5 can work without
> a dirty log at all.  When it does, it's behaviour is completely analogous to
> working with a 'core' dirty log.  So to get the raid5 part working without
> needing to worry about the dirty-log stuff, I told md/raid5 not to use a
> dirty log, and pretended it was using a 'core' log.

Yes, I meanwhile saw it. Overlooked it initially.

> 
> Then in later patches after I had enabled md/bitmap to work with dm-log, I
> switched dm-raid45 over to use a real dm-log and removed the restriction to
> only using a core log.
> So this is really just an artefact of the order in which I developed the
> code.  I could go back and re-arrange it so the dm-log integration comes
> first, then I wouldn't need this intermediate stage which only supports
> 'core'.

No need to; nicely illustrates the development history.

Heinz

> 
> Thanks,
> NeilBrown
> 
> 
> > 
> > Heinz
> > 
> > On Tue, 2010-06-01 at 19:56 +1000, NeilBrown wrote:
> > > With RAID1, the dirty log covers the size of the target - the number
> > > of bits is the target size divided by the region size.
> > > 
> > > For RAID5 and similar the dirty log needs to cover the parity blocks,
> > > so it is best to base the dirty log size on the size of the component
> > > devices rather than the size of the array.
> > > 
> > > So when creating a dirty log, allow the log_size to be specified
> > > separately from the target, and in raid1, set it to the target length.
> > > 
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > ---
> > >  drivers/md/dm-log-userspace-base.c |   11 +++++++----
> > >  drivers/md/dm-log.c                |   18 +++++++++++-------
> > >  drivers/md/dm-raid1.c              |    4 ++--
> > >  include/linux/dm-dirty-log.h       |    3 ++-
> > >  4 files changed, 22 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
> > > index 1ed0094..935a49b 100644
> > > --- a/drivers/md/dm-log-userspace-base.c
> > > +++ b/drivers/md/dm-log-userspace-base.c
> > > @@ -94,7 +94,7 @@ retry:
> > <SNIP>
> > 
> > 
> >  drivers/md/dm-log.c          |   18 +++++++-----------
> >  drivers/md/dm-raid1.c        |    4 ++--
> >  drivers/md/dm-raid456.c      |    8 +++++---
> >  include/linux/dm-dirty-log.h |    3 +--
> >  4 files changed, 15 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
> > index a232c14..5a08be0 100644
> > --- a/drivers/md/dm-log.c
> > +++ b/drivers/md/dm-log.c
> > @@ -146,7 +146,6 @@ EXPORT_SYMBOL(dm_dirty_log_type_unregister);
> >  
> >  struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
> >  			struct dm_target *ti,
> > -			sector_t log_size,
> >  			int (*flush_callback_fn)(struct dm_target *ti),
> >  			unsigned int argc, char **argv)
> >  {
> > @@ -165,7 +164,7 @@ struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
> >  
> >  	log->flush_callback_fn = flush_callback_fn;
> >  	log->type = type;
> > -	if (type->ctr(log, ti, log_size, argc, argv)) {
> > +	if (type->ctr(log, ti, argc, argv)) {
> >  		kfree(log);
> >  		put_type(type);
> >  		return NULL;
> > @@ -336,9 +335,9 @@ static int read_header(struct log_c *log)
> >  	return 0;
> >  }
> >  
> > -static int _check_region_size(sector_t log_size, uint32_t region_size)
> > +static int _check_region_size(struct dm_target *ti, uint32_t region_size)
> >  {
> > -	if (region_size < 2 || region_size > log_size)
> > +	if (region_size < 2 || region_size > ti->len)
> >  		return 0;
> >  
> >  	if (!is_power_of_2(region_size))
> > @@ -354,7 +353,6 @@ static int _check_region_size(sector_t log_size, uint32_t region_size)
> >   *--------------------------------------------------------------*/
> >  #define BYTE_SHIFT 3
> >  static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
> > -			      sector_t log_size,
> >  			      unsigned int argc, char **argv,
> >  			      struct dm_dev *dev)
> >  {
> > @@ -384,12 +382,12 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
> >  	}
> >  
> >  	if (sscanf(argv[0], "%u", &region_size) != 1 ||
> > -	    !_check_region_size(log_size, region_size)) {
> > +	    !_check_region_size(ti, region_size)) {
> >  		DMWARN("invalid region size %s", argv[0]);
> >  		return -EINVAL;
> >  	}
> >  
> > -	region_count = dm_sector_div_up(log_size, region_size);
> > +	region_count = dm_sector_div_up(ti->len, region_size);
> >  
> >  	lc = kmalloc(sizeof(*lc), GFP_KERNEL);
> >  	if (!lc) {
> > @@ -509,10 +507,9 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
> >  }
> >  
> >  static int core_ctr(struct dm_dirty_log *log, struct dm_target *ti,
> > -		    sector_t log_size,
> >  		    unsigned int argc, char **argv)
> >  {
> > -	return create_log_context(log, ti, log_size, argc, argv, NULL);
> > +	return create_log_context(log, ti, argc, argv, NULL);
> >  }
> >  
> >  static void destroy_log_context(struct log_c *lc)
> > @@ -536,7 +533,6 @@ static void core_dtr(struct dm_dirty_log *log)
> >   * argv contains log_device region_size followed optionally by [no]sync
> >   *--------------------------------------------------------------*/
> >  static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
> > -		    sector_t log_size,
> >  		    unsigned int argc, char **argv)
> >  {
> >  	int r;
> > @@ -551,7 +547,7 @@ static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
> >  	if (r)
> >  		return r;
> >  
> > -	r = create_log_context(log, ti, log_size, argc - 1, argv + 1, dev);
> > +	r = create_log_context(log, ti, argc - 1, argv + 1, dev);
> >  	if (r) {
> >  		dm_put_device(ti, dev);
> >  		return r;
> > diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
> > index ea732fc..ddda531 100644
> > --- a/drivers/md/dm-raid1.c
> > +++ b/drivers/md/dm-raid1.c
> > @@ -968,8 +968,8 @@ static struct dm_dirty_log *create_dirty_log(struct dm_target *ti,
> >  		return NULL;
> >  	}
> >  
> > -	dl = dm_dirty_log_create(argv[0], ti, ti->len, mirror_flush,
> > -				 param_count, argv + 2);
> > +	dl = dm_dirty_log_create(argv[0], ti, mirror_flush, param_count,
> > +				 argv + 2);
> >  	if (!dl) {
> >  		ti->error = "Error creating mirror dirty log";
> >  		return NULL;
> > diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
> > index 3dcbc4a..33d2be8 100644
> > --- a/drivers/md/dm-raid456.c
> > +++ b/drivers/md/dm-raid456.c
> > @@ -192,7 +192,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
> >  	int recovery = 1;
> >  	long raid_devs;
> >  	long rebuildA, rebuildB;
> > -	sector_t sectors_per_dev, chunks;
> > +	sector_t sectors_per_dev, chunks, ti_len_sav;
> >  	struct raid_set *rs = NULL;
> >  	int in_sync, i;
> >  	struct dm_dirty_log *log = NULL;
> > @@ -281,8 +281,10 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
> >  	if (sector_div(chunks, chunk_size))
> >  		goto err;
> >  
> > -	log = dm_dirty_log_create(log_argv[0], ti, sectors_per_dev,
> > -				  NULL, log_cnt, log_argv+2);
> > +	ti_len_sav = ti->len;
> > +	ti->len = sectors_per_dev;
> > +	log = dm_dirty_log_create(log_argv[0], ti, NULL, log_cnt, log_argv+2);
> > +	ti->len = ti_len_sav;
> >  	err = "Error creating dirty log";
> >  	if (!log)
> >  		goto err;
> > diff --git a/include/linux/dm-dirty-log.h b/include/linux/dm-dirty-log.h
> > index 641419f..7084503 100644
> > --- a/include/linux/dm-dirty-log.h
> > +++ b/include/linux/dm-dirty-log.h
> > @@ -33,7 +33,6 @@ struct dm_dirty_log_type {
> >  	struct list_head list;
> >  
> >  	int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
> > -		   sector_t log_size,
> >  		   unsigned argc, char **argv);
> >  	void (*dtr)(struct dm_dirty_log *log);
> >  
> > @@ -138,7 +137,7 @@ int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type);
> >   * type->constructor/destructor() directly.
> >   */
> >  struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
> > -			struct dm_target *ti, sector_t log_size,
> > +			struct dm_target *ti,
> >  			int (*flush_callback_fn)(struct dm_target *ti),
> >  			unsigned argc, char **argv);
> >  void dm_dirty_log_destroy(struct dm_dirty_log *log);
> > 
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 


