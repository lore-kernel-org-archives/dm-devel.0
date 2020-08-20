From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: fixing 4.14-stable's broken DM cache writethrough support [was:
 Re: [(resend) PATCH v3: {linux-4.14.y} ] dm cache: submit writethrough
 writes in parallel to origin and cache]
Date: Thu, 20 Aug 2020 10:18:01 +0200
Message-ID: <20200820081801.GH4049659@kroah.com>
References: <8CFF8DA9-C105-461C-8F5A-DA2BF448A135@oracle.com>
 <20200804124735.GA219143@kroah.com>
 <20200804182037.GA15453@redhat.com>
 <20200805143242.GC2154236@kroah.com>
 <20200805193409.GA21824@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200805193409.GA21824@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: John Donnelly <john.p.donnelly@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Aug 05, 2020 at 03:34:09PM -0400, Mike Snitzer wrote:
> On Wed, Aug 05 2020 at 10:32am -0400,
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Tue, Aug 04, 2020 at 02:20:38PM -0400, Mike Snitzer wrote:
> > > On Tue, Aug 04 2020 at  8:47am -0400,
> > > Greg KH <gregkh@linuxfoundation.org> wrote:
> > > 
> > > > On Tue, Aug 04, 2020 at 07:33:05AM -0500, John Donnelly wrote:
> > > > > From: Mike Snitzer <snitzer@redhat.com>
> > > > > 
> > > > > Discontinue issuing writethrough write IO in series to the origin and
> > > > > then cache.
> > > > > 
> > > > > Use bio_clone_fast() to create a new origin clone bio that will be
> > > > > mapped to the origin device and then bio_chain() it to the bio that gets
> > > > > remapped to the cache device.  The origin clone bio does _not_ have a
> > > > > copy of the per_bio_data -- as such check_if_tick_bio_needed() will not
> > > > > be called.
> > > > > 
> > > > > The cache bio (parent bio) will not complete until the origin bio has
> > > > > completed -- this fulfills bio_clone_fast()'s requirements as well as
> > > > > the requirement to not complete the original IO until the write IO has
> > > > > completed to both the origin and cache device.
> > > > > 
> > > > > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > > > > 
> > > > > (cherry picked from commit 2df3bae9a6543e90042291707b8db0cbfbae9ee9)
> > > > > 
> > > > > Fixes: 4ec34f2196d125ff781170ddc6c3058c08ec5e73 (dm bio record:
> > > > > save/restore bi_end_io and bi_integrity )
> > > > > 
> > > > > 4ec34f21 introduced a mkfs.ext4 hang on a LVM device that has been
> > > > > modified with lvconvert --cachemode=writethrough.
> > > > > 
> > > > > CC:stable@vger.kernel.org for 4.14.y
> > > > > 
> > > > > Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
> > > > > Reviewed-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
> > > > > 
> > > > > conflicts:
> > > > > 	drivers/md/dm-cache-target.c. -  Corrected usage of
> > > > > 	writethrough_mode(&cache->feature) that was caught by
> > > > > 	compiler, and removed unused static functions : writethrough_endio(),
> > > > > 	defer_writethrough_bio(), wake_deferred_writethrough_worker()
> > > > > 	that generated warnings.
> > > > 
> > > > What is this "conflicts nonsense"?  You don't see that in any other
> > > > kernel patch changelog, do you?
> > > > 
> > > > > ---
> > > > > drivers/md/dm-cache-target.c | 92 ++++++++++++++++++--------------------------
> > > > > 1 file changed, 37 insertions(+), 55 deletions(-)
> > > > 
> > > > Please fix your email client up, it's totally broken and this does not
> > > > work at all and is getting frustrating from my side here.
> > > > 
> > > > Try sending emails to yourself and see if you can apply the patches, as
> > > > the one you sent here does not work, again:
> > > 
> > > John's inability to submit a patch that can apply aside: I do not like
> > > how this patch header is constructed (yet attributed "From" me).  It is
> > > devoid of detail as it relates to stable@.
> > > 
> > > Greg, please don't apply the v4 of this patch either.  I'll craft a
> > > proper stable@ patch that explains the reason for change and why we're
> > > left having to resolve conflicts in stable@.
> > > 
> > > But first I need to focus on sending DM changes to Linus for v5.9 merge.
> > 
> > Ok, no worries, I'll drop all of these from my review queue and wait for
> > something from you sometime in the future.
> 
> Hey Greg,
> 
> SO I've looked this required 4.14 stable@ backport over. Because 4.14
> already has these commits (to fix a dm integrity issue):
> 1b17159e52b dm bio record: save/restore bi_end_io and bi_integrity
> 248aa2645aa dm integrity: use dm_bio_record and dm_bio_restore
> 
> DM-cache's 4.14 writethrough mode got broken because its implementation
> (ab)used dm_hook_bio+dm_bio_record and predates 4.15's switch to using
> bio_chain() via commit 2df3bae9a654.  Without commit 2df3bae9a654 the
> dm_hook_bio+dm_bio_record changes from commit 1b17159e52b break
> dm-cache's writethrough support.
> 
> So 4.14-stable now needs these 3 upstream 4.15 commits:
> 8e3c3827776f dm cache: pass cache structure to mode functions
> 2df3bae9a654 dm cache: submit writethrough writes in parallel to origin and cache
> 9958f1d9a04e dm cache: remove all obsolete writethrough-specific code
> 
> Applying those commits to v4.14.190 with:
> git cherry-pick -x 8e3c3827776f^..9958f1d9a04e
> 
> results in a kernel that successfully builds and should fix
> 4.14-stable's broken dm-cache writethrough support.
> 
> Are you ok with queueing up applying these 3 upstream commits to
> 4.14-stable or do you need me to send a patchset?

This is good enough, now all queued up, thanks!

greg k-h
