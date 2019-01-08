From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 1/1] dm: add dust target
Date: Tue, 8 Jan 2019 11:36:00 -0600
Message-ID: <20190108173600.GO11315@octiron.msp.redhat.com>
References: <1546889483-6341-1-git-send-email-bgurney@redhat.com>
	<1546889483-6341-2-git-send-email-bgurney@redhat.com>
	<20190108001049.GM11315@octiron.msp.redhat.com>
	<CAHhmqcSLxihW3L+w=MZ22Z9pbU13MLD7Bn6YQey-u1soFp-KJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHhmqcSLxihW3L+w=MZ22Z9pbU13MLD7Bn6YQey-u1soFp-KJw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bryan Gurney <bgurney@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, John Dorminy <jdorminy@redhat.com>, Joe Shimkus <jshimkus@redhat.com>, dm-devel@redhat.com, tjaskiew@redhat.com, John Pittman <jpittman@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 08, 2019 at 10:30:32AM -0500, Bryan Gurney wrote:
> On Mon, Jan 7, 2019 at 7:10 PM Benjamin Marzinski <bmarzins@redhat.com> wrote:
> >
> > On Mon, Jan 07, 2019 at 02:31:23PM -0500, Bryan Gurney wrote:
> > > +
> > > +static int dust_add_block(struct dust_device *dd, unsigned long long block)
> > > +{
> > > +     struct badblock *bblock;
> > > +     unsigned long flags;
> > > +
> > > +     spin_lock_irqsave(&dd->dust_lock, flags);
> > > +     bblock = dust_rb_search(&dd->badblocklist, block * dd->sect_per_block);
> > > +
> > > +     if (bblock != NULL) {
> > > +             if (!dd->quiet_mode)
> > > +                     DMERR("addbadblock: block %llu already in badblocklist",
> > > +                           block);
> > > +             spin_unlock_irqrestore(&dd->dust_lock, flags);
> > > +             return -EINVAL;
> > > +     }
> > > +
> > > +     bblock = kmalloc(sizeof(*bblock), GFP_KERNEL);
> >
> > You can't do a GFP_KERNEL allocation while holding a spinlock.  I think
> > it would be better to assume that the user was correctly adding a new
> > block, do the allocation, and then just call dust_rb_insert() under the
> > spinlock. dust_rb_insert() will return false if the block is already
> > inserted
> 
> Ah, okay.  I'll be spinning a v2 of this patch.  (I need to make some
> updates to the dm-dust.txt documentation file as well, so those
> updates will be in there.)
> 
> After reading through your description of the timeline, I created this
> revision of dust_add_block() (which compiles, and seems to work
> properly in my test module):
> 
> static int dust_add_block(struct dust_device *dd, unsigned long long block)
> {
>     struct badblock *bblock;
>     unsigned long flags;
> 
>     bblock = kmalloc(sizeof(*bblock), GFP_KERNEL);
>     if (bblock == NULL) {
>         if (!dd-&gt;quiet_mode)
>             DMERR("addbadblock: badblock allocation failed");
>         return -ENOMEM;
>     }
> 
>     spin_lock_irqsave(&amp;dd-&gt;dust_lock, flags);
>     bblock-&gt;bb = block * dd-&gt;sect_per_block;
>     if (!dust_rb_insert(&amp;dd-&gt;badblocklist, bblock)) {
>         if (!dd-&gt;quiet_mode)
>             DMERR("addbadblock: block %llu already in badblocklist",
>                   block);
>         spin_unlock_irqrestore(&amp;dd-&gt;dust_lock, flags);
>         kfree(bblock);
>         return -EINVAL;
>     }
> 
>     dd-&gt;badblock_count++;
>     if (!dd-&gt;quiet_mode)
>         DMINFO("addbadblock: badblock added at block %llu", block);
>     spin_unlock_irqrestore(&amp;dd-&gt;dust_lock, flags);
>     return 0;
> }
> 
> Test results:
> 
> # dmsetup message dust1 0 addbadblock 60
> kernel: device-mapper: dust: addbadblock: badblock added at block 60
> # dmsetup message dust1 0 addbadblock 60
> kernel: device-mapper: dust: addbadblock: block 60 already in badblocklist
> # dmsetup message dust1 0 addbadblock 60
> kernel: device-mapper: dust: addbadblock: block 60 already in badblocklist
> 
> The kmalloc() is before the spinlock, and if the block is already in
> the rbtree, it unlocks, and frees the unused "bblock".  Does this look
> good?
> 

Yep. That looks fine (other than your ">" and "&" characters getting
lost in translation)

-Ben
