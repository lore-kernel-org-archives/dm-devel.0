From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 76/80] libmultipath: select_action(): force
 udev reload for uninitialized maps
Date: Wed, 05 Aug 2020 22:54:15 +0200
Message-ID: <6b9ca2954255216cb78b76bd63b1086fdaeefd7e.camel@suse.com>
References: <20200709110330.9917-1-mwilck@suse.com>
	<20200709110330.9917-3-mwilck@suse.com>
	<20200720034455.GA11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200720034455.GA11089@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, 2020-07-19 at 22:44 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 09, 2020 at 01:03:26PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > If we are in the reconfigure() code path, and we encounter maps to
> > be reloaded, we usually set the DM_SUBSYSTEM_UDEV_FLAG0 flag to
> > tell
> > udev not to repeat device detection steps above the multipath
> > layer.
> > However, if the map was previously uninitialized, we have to force
> > udev to reload.
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  libmultipath/configure.c | 61 ++++++++++++++++++++++++----------
> > ------
> >  1 file changed, 37 insertions(+), 24 deletions(-)
> > 
> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index 2509053..efb5808 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -660,6 +660,32 @@ sysfs_set_max_sectors_kb(struct multipath
> > *mpp, int is_reload)
> >  	return err;
> >  }
> >  
> > +static void
> > +select_reload_action(struct multipath *mpp, const char *reason)
> > +{
> > +	struct udev_device *mpp_ud;
> > +	const char *env;
> > +
> > +	/*
> > +	 * MPATH_DEVICE_READY != 1 can mean two things:
> > +	 *  (a) no usable paths
> > +	 *  (b) device was never fully processed (e.g. udev killed)
> > +	 * If we are in this code path (startup or forced reconfigure),
> > +	 * (b) can mean that upper layers like kpartx have never been
> > +	 * run for this map. Thus force udev reload.
> > +	 */
> > +
> 
> This looks like it wants multipath to check if there are valid
> devices
> before setting force reload.  But looking at the udev rules, I'm
> pretty
> sure it's safe. If we have no valid paths, then we will have
> 
> ENV{DM_NOSCAN}="1 and ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
> 
> which means it doesn't matter that force_udev_reload will cause
> 
> ENV{DM_ACTIVATION}="1" and ENV{MPATH_UNCHANGED}=""
> 
> It does get sort of confusing with the number of udev properties that
> can
> effect things.  So nothing really needs to get done for this to be
> correct, but perhaps this code should only set force reload is there
> are
> valid paths, just to be clear.

Will do. Full ack wrt the confusing udev rules (patches welcome :D)

Note btw that multipathd triggers a synthetic change event in
reconfigure if no changes were applied; but that code is hardly ever
executed because we normally set queue_if_no_path, and during startup
multipathd will never encounter a queueing map.

Martin
