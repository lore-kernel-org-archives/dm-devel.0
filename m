From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath: better check for daemon mode.
Date: Fri, 30 Sep 2011 10:08:52 -0500
Message-ID: <20110930150852.GI24133@ether.msp.redhat.com>
References: <20110725184752.GL15149@ether.msp.redhat.com>
	<20110901024632.GB11793@ether.msp.redhat.com>
	<20110929033812.GZ24133@ether.msp.redhat.com>
	<1317362307.9057.7.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1317362307.9057.7.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 30, 2011 at 07:58:27AM +0200, Christophe Varoqui wrote:
> On mer., 2011-09-28 at 22:38 -0500, Benjamin Marzinski wrote:
> > On Wed, Aug 31, 2011 at 09:46:32PM -0500, Benjamin Marzinski wrote:
> > > Christophe, would it be possible to get this merged?
> > 
> > Is there some objection to merging this?  It's not just a cosmetic
> > change.  For multipath devices added via ev_add_map(), disassemble_map()
> > will be called before the waiter thread is started, and this check will
> > allow any unknown paths in the device to be stored.  However, paths
> > added this way never get properly setup like they do when they are added
> > via ev_add_path(), or at configuration time.
> > 
> > So say you had a multipath device, "mpatha", which should include the
> > path "sda", except that the path was mistakenly blacklisted. If you
> > unblacklist the path and then run multipath, without first reconfiguring
> > multipathd, it will segfault, since it adds sda, but never initializes
> > all the necessary information.
> > 
> > We could solve this problem by making sure that paths added through
> > disassemble_map() go through the same initialization code that paths
> > added through ev_add_path(), but I don't see the necessity. If
> > multipathd isn't monitoring a path, it's either because that path was
> > blacklisted, or because that path was manually removed.  While it's
> > possible to create a multipath device using blacklisted paths via
> > dmsetup, multipathd still shouldn't be monitoring those paths.  The same
> > goes with paths that were manually removed via the multipathd command
> > line interface.
> > 
> > And if, for some reason, multipathd wasn't monitoring a path it should
> > be, the best thing to do is to reconfigure multipathd.  Code that
> > watched multipath.conf and automatically reconfigured multipathd when it
> > changed would be a nice addition though.
> > 
> 
> The multipath daemon should not segfault for sure. I agree the
> blacklisted paths can be left unmonitored even if they are part of
> configured multipath.
> 
> But I wouldn't do the multipath.conf changes auto loading. Admins tend
> to consider for granted daemons configuration files can be changed
> without impact on the running daemon.

Fine with me.  Nobody's ever asked me for this. But we occassionaly get
bug reports that end up being caused by admins forgetting or not knowing
to reconfigure multipathd after they change the config file.

-Ben
 
> Regards,
> cvaroqui
>  
> > Thanks,
> > -Ben
> > 
> > > Thanks,
> > > -Ben
> > > 
> > > On Mon, Jul 25, 2011 at 01:47:52PM -0500, Benjamin Marzinski wrote:
> > > > Switching to conf->daemon to check if we are in daemon mode.
> > > > 
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > ---
> > > >  libmultipath/dmparser.c |    3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > Index: multipath-tools-110713/libmultipath/dmparser.c
> > > > ===================================================================
> > > > --- multipath-tools-110713.orig/libmultipath/dmparser.c
> > > > +++ multipath-tools-110713/libmultipath/dmparser.c
> > > > @@ -13,6 +13,7 @@
> > > >  #include "structs.h"
> > > >  #include "util.h"
> > > >  #include "debug.h"
> > > > +#include "config.h"
> > > >  
> > > >  #define WORD_SIZE 64
> > > >  
> > > > @@ -330,7 +331,7 @@ disassemble_map (vector pathvec, char * 
> > > >  				strncpy(pp->dev_t, word, BLK_DEV_SIZE);
> > > >  
> > > >  				/* Only call this in multipath client mode */
> > > > -				if (!mpp->waiter && store_path(pathvec, pp))
> > > > +				if (!conf->daemon && store_path(pathvec, pp))
> > > >  					goto out1;
> > > >  			}
> > > >  			FREE(word);
> > > > 
> > > > --
> > > > dm-devel mailing list
> > > > dm-devel@redhat.com
> > > > https://www.redhat.com/mailman/listinfo/dm-devel
> > > 
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://www.redhat.com/mailman/listinfo/dm-devel
> 
