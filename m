From: Dave Wysochanski <dwysocha@redhat.com>
Subject: Re: dm_ioctl: Only send a change uevent when a resume
 ioctl changes the device.
Date: Tue, 26 Jan 2010 13:57:00 -0500
Message-ID: <1264532220.2572.8.camel@f10-node1>
References: <1264528570-10498-1-git-send-email-dwysocha@redhat.com>
	<20100126180929.GA17190@redhat.com> <1264531714.2572.6.camel@f10-node1>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1264531714.2572.6.camel@f10-node1>
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
List-Id: dm-devel.ids

On Tue, 2010-01-26 at 13:48 -0500, Dave Wysochanski wrote:
> On Tue, 2010-01-26 at 13:09 -0500, Mike Snitzer wrote:
> > On Tue, Jan 26 2010 at 12:56pm -0500,
> > Dave Wysochanski <dwysocha@redhat.com> wrote:
> > 
> > > Resume ioctls may result in no changes to the device and thus they
> > > should not generate change uevents.  For example, if a device is
> > > not suspended when a resume ioctl occurs, we should not send a
> > > uevent.
> > > 
> > > Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
> > > ---
> > >  drivers/md/dm-ioctl.c |   12 ++++++++----
> > >  1 files changed, 8 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> > > index 1d66932..0c1cf53 100644
> > > --- a/drivers/md/dm-ioctl.c
> > > +++ b/drivers/md/dm-ioctl.c
> > > @@ -851,6 +851,7 @@ static int do_suspend(struct dm_ioctl *param)
> > >  
> > >  static int do_resume(struct dm_ioctl *param)
> > >  {
> > > +	int send_uevent = 0;
> > >  	int r = 0;
> > >  	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
> > >  	struct hash_cell *hc;
> > > @@ -895,18 +896,21 @@ static int do_resume(struct dm_ioctl *param)
> > >  			set_disk_ro(dm_disk(md), 0);
> > >  		else
> > >  			set_disk_ro(dm_disk(md), 1);
> > > +		send_uevent = 1;
> > >  	}
> > > -
> > > -	if (dm_suspended_md(md))
> > > +	if (dm_suspended_md(md)) {
> > >  		r = dm_resume(md);
> > > +		send_uevent = 1;
> > > +	}
> > >  
> > >  	if (old_map)
> > >  		dm_table_destroy(old_map);
> > >  
> > > -	if (!r) {
> > > +	if (send_uevent)
> > >  		dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr);
> > > +
> > > +	if (!r)
> > >  		r = __dev_status(md, param);
> > > -	}
> > >  
> > >  	dm_put(md);
> > >  	return r;
> > 
> > Seems you're sending the uevent even if resume failed.  Is that intended?
> > 
> > Also, can dm_kobject_uevent() come before dm_table_destroy()?
> > 
> > If so this would be a bit simpler:
> > 
> > diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> > index 1d66932..e3cf568 100644
> > --- a/drivers/md/dm-ioctl.c
> > +++ b/drivers/md/dm-ioctl.c
> > @@ -897,16 +897,17 @@ static int do_resume(struct dm_ioctl *param)
> >  			set_disk_ro(dm_disk(md), 1);
> >  	}
> >  
> > -	if (dm_suspended_md(md))
> > +	if (dm_suspended_md(md)) {
> >  		r = dm_resume(md);
> > +		if (!r)
> > +			dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr);
> > +	}
> >  
> >  	if (old_map)
> >  		dm_table_destroy(old_map);
> >  
> > -	if (!r) {
> > -		dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr);
> > +	if (!r)
> >  		r = __dev_status(md, param);
> > -	}
> >  
> >  	dm_put(md);
> >  	return r;
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
> Nice simplification Mike, as discussed on IRC.
> 
> Ack.
> 

Actually, the more I think about it I am not sure about sending the
uevent in the case where dm_resume() fails.  Seems like we should send
it since the map could have changed - depends on whether we went through
that 'if (new_map)' block.
