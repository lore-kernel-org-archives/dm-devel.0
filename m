From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 4/5] dm mpath: add 'default_hw_handler'
	feature
Date: Wed, 9 May 2012 15:17:08 -0400
Message-ID: <20120509191708.GA26785@redhat.com>
References: <1336514167-15393-1-git-send-email-snitzer@redhat.com>
	<1336514167-15393-5-git-send-email-snitzer@redhat.com>
	<77471C95FAFD844C8CA02DD4F4C5FE2B05D2D0@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B05D2D0@SACEXCMBX02-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Moger, Babu" <Babu.Moger@netapp.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, May 09 2012 at  2:10pm -0400,
Moger, Babu <Babu.Moger@netapp.com> wrote:

> Mike,
> 
> > -----Original Message-----
> > From: Mike Snitzer [mailto:snitzer@redhat.com]
> > Sent: Tuesday, May 08, 2012 4:56 PM
> > To: dm-devel@redhat.com
> > Cc: agk@redhat.com; hare@suse.de; Moger, Babu; sekharan@us.ibm.com;
> > Mike Snitzer
> > Subject: [PATCH v2 4/5] dm mpath: add 'default_hw_handler' feature
> > 
> > From: Hannes Reinecke <hare@suse.de>
> > 
> > When specifying the feature 'default_hw_handler' multipath will be use
> > the currently attached hardware handler instead of trying to attach the
> > one specified during table load.  If no hardware handler is attached the
> > specified hardware handler will be used.
> 
> I am trying to test these patches right now.  What is the expectation from
> Multipath tools for this to work correctly.  Do I have to pass following 
> Parameters?
> 
> hardware_handler "1 alua"  
> features "1 default_hw_handler"

Yes.
  
> It appears to me that the first line will forcibly load the alua handler even if
> the default handler is different. 

Are you saying that based on testing or based on code review?

> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index c351607..0fc6849 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -585,9 +587,18 @@ static struct pgpath *parse_path(struct dm_arg_set
> > *as, struct path_selector *ps
> >  		goto bad;
> >  	}
> > 
> > -	if (m->hw_handler_name) {
> > -		struct request_queue *q = bdev_get_queue(p->path.dev-
> > >bdev);
> > +	if (m->use_default_hw_handler || m->hw_handler_name)
> > +		q = bdev_get_queue(p->path.dev->bdev);
> > +
> > +	if (m->use_default_hw_handler) {
> > +		const char *attached_handler_name = scsi_dh_attached_handler_name(q);
> > +		if (attached_handler_name) {
> > +			kfree(m->hw_handler_name);
> > +			m->hw_handler_name = kstrdup(attached_handler_name, GFP_KERNEL);
> > +		}
> > +	}
> > 
> > +	if (m->hw_handler_name) {
> >  		r = scsi_dh_attach(q, m->hw_handler_name);
> >  		if (r == -EBUSY) {
> >  			/*

The above hunk is what will cause the currently attached device handler
to be used.  But if a device handler is _not_ attached then we fallback
to using the provided 'hardware_handler'.

So are you testing this patch with a device handler having already been
attached?

Mike
