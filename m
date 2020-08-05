From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 46/54] libmultipath: path_discover(): always
 set DI_BLACKLIST
Date: Wed, 05 Aug 2020 15:39:30 +0200
Message-ID: <96142934e52fa9af642b3912a8b5851e76e53d7a.camel@suse.com>
References: <20200709103623.8302-1-mwilck@suse.com>
	<20200709103623.8302-5-mwilck@suse.com>
	<20200717222108.GS11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200717222108.GS11089@octiron.msp.redhat.com>
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

On Fri, 2020-07-17 at 17:21 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 09, 2020 at 12:36:15PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > Since 65e1845 ("multipath: call store_pathinfo with DI_BLACKLIST"),
> > we
> > use DI_BLACKLIST for new paths. There's no reason why we shouldn't
> > do the
> > same with paths which are (unexpectedly) already in pathvec. As
> > argued
> > for 65e1845, this might save some unnecessary work for paths which
> > are
> > blacklisted anyway.
> 
> It seems to me like either we should assume that if we added the path
> to
> pathvec, it's valid, or we should check, and if it's blacklisted,
> remove
> it. Just leaving it on pathvec without all of the pathinfo work done
> doesn't make much sense to me. Am I missing something here?

TL;DR: let's skip this patch for now.

path_discover() is only called from path_discovery(). path_discovery()
is called from 

 1 configure() (multipathd), with an empty pathvec
 2 configure() (multipath), with a pathvec possibly pre-populated by
get_refwwid()
 3 check_valid_path(), with pathvec pre-populated with the path to be
checked

For 1) my patch obviously makes no difference. In case 2) get_refwwid()
sets DI_BLACKLIST anyway (except for CMD_REMOVE_WWID, in which case
path_discovery() is not called). In case 3), DI_BLACKLIST
has already been used by is_path_valid() (the only exception being the
"is already multipathed" case, in which path_discovery() is not
called).

So, this patch makes no difference in practice - all callers make sure
that the pathvec is pre-populated only with non-blacklisted paths.

The reason I wrote this patch was because I wanted to use consistent
flags in path_discover() - it was non-obvious to me why we treated
existing and new paths differently. The side effect was a very small
speed-up. 

But your argument above is valid. 

To me it would come as a surprise if path_discovery() removed paths;
that's the kind of side effect I'd like to minimize in our code. Thus,
path_discover() should rely on the caller wrt the pre-populated paths,
and not use DI_BLACKLIST on them.

For now, I'll replace this patch with a comment explaining why we use
different flags in the two pathinfo() calls. 

In the future, we may want to change path_discovery() such that it only
works on an empty pathvec. IMO that would be cleaner, and require only
minimal changes to callers.

Thanks,
Martin


> -Ben
>  
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  libmultipath/discovery.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index 5f4ebf0..caabfef 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -137,7 +137,7 @@ path_discover (vector pathvec, struct config *
> > conf,
> >  				      udevice, flag | DI_BLACKLIST,
> >  				      NULL);
> >  	else
> > -		return pathinfo(pp, conf, flag);
> > +		return pathinfo(pp, conf, flag | DI_BLACKLIST);
> >  }
> >  
> >  static void cleanup_udev_enumerate_ptr(void *arg)
> > -- 
> > 2.26.2
