From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 3/3] dm-multipath: 'default_hw_handler'
 feature
Date: Tue, 08 May 2012 16:12:51 -0500
Message-ID: <1336511571.1118.84.camel@chandra-lucid.austin.ibm.com>
References: <1336486687-31535-1-git-send-email-hare@suse.de>
	<1336486687-31535-2-git-send-email-hare@suse.de>
	<1336486687-31535-3-git-send-email-hare@suse.de>
	<1336486687-31535-4-git-send-email-hare@suse.de>
	<20120508144653.GF8383@redhat.com>  <4FA95822.2040701@suse.de>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4FA95822.2040701@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Babu Moger <babu.moger@netapp.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

I concur with the idea of combining both patches. 

Chandra
On Tue, 2012-05-08 at 19:30 +0200, Hannes Reinecke wrote:
> On 05/08/2012 04:46 PM, Mike Snitzer wrote:
> > On Tue, May 08 2012 at 10:18am -0400,
> > Hannes Reinecke<hare@suse.de>  wrote:
> >
> >> This patch introduces a 'default_hw_handler' feature for
> >> dm-mpath. When specifying the feature 'default_hw_handler'
> >> dm-multipath will be using the currently attached hardware
> >> handler instead of trying to re-attach with the one
> >> specified during table creation.
> >> If no hardware handler is attached the specified hardware
> >> handler will be used.
> >>
> >> Signed-off-by: Hannes Reinecke<hare@suse.de>
> >> ---
> >>   drivers/md/dm-mpath.c |   25 ++++++++++++++++++++++---
> >>   1 files changed, 22 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> >> index 6d3f2a8..c1ef41d 100644
> >> --- a/drivers/md/dm-mpath.c
> >> +++ b/drivers/md/dm-mpath.c
> >> @@ -57,6 +57,7 @@ struct priority_group {
> >>   };
> >>
> >>   #define FEATURE_NO_PARTITIONS 1
> >> +#define FEATURE_DEFAULT_HW_HANDLER 2
> >>
> >>   /* Multipath context */
> >>   struct multipath {
> >> @@ -589,14 +590,24 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
> >>
> >>   	if (m->hw_handler_name) {
> >>   		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
> >> +		const char *hw_handler_name = m->hw_handler_name;
> >>
> >> -		r = scsi_dh_attach(q, m->hw_handler_name);
> >> +		if (m->features&  FEATURE_DEFAULT_HW_HANDLER)
> >> +			hw_handler_name = NULL;
> >> +
> >> +		r = scsi_dh_attach(q, hw_handler_name);
> >>   		if (r == -EBUSY) {
> >>   			/*
> >>   			 * Already attached to different hw_handler,
> >>   			 * try to reattach with correct one.
> >>   			 */
> >>   			scsi_dh_detach(q);
> >> +			r = scsi_dh_attach(q, hw_handler_name);
> >> +		} else if (r == -EINVAL) {
> >> +			/*
> >> +			 * No hardware handler attached, use
> >> +			 * the specified one.
> >> +			 */
> >>   			r = scsi_dh_attach(q, m->hw_handler_name);
> >>   		}
> >
> > I like what you've done with the 'default_hw_handler' feature.  But
> > you're not establishing m->hw_handler_name.  As such the rest of the
> > dm-mpath.c code that keys off of m->hw_handler_name (e.g. reinstate_path,
> > pg_init_done, free_pgpaths) will not work.
> >
> Ah. True.
> 
> > Would you be OK with a hybrid of both our approaches?  Use your
> > 'default_hw_handler' feature and, rather than pass a NULL name to
> > scsi_dh_attach, use scsi_dh_attached_handler_name like I provided?
> >
> Yes, sure. That sounds like the best approach here.
> 
> I'm not _that_ keen on my 'NULL' hw handler name approach, so your idea
> of having a function for that looks like a better idea.
> 
> > (I don't see a problem with altering m->hw_handler_name to reflect the
> > scsi_dh that is used by the path.. Babu agreed with this too).
> >
> Yep.
> 
> > I'd be happy to merge our dm-mpath patches and attribute authorship to
> > you.
> >
> Oh, cool.
> Please do.
> 
> Cheers,
> 
> Hannes
