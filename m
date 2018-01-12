From: Julian Andres Klode <julian.klode@canonical.com>
Subject: Re: multipath-tools 0.7.4 failure to remove device
Date: Fri, 12 Jan 2018 22:47:00 +0100
Message-ID: <20180112214700.ljxlypo5nar6oh3m@jak-x230>
References: <20180112083833.apsybil4ux4d2y32@jak-x230>
	<1515789339.3409.33.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1515789339.3409.33.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Device-mapper development mailing list <dm-devel@redhat.com>, Guan Junxiong <guanjunxiong@huawei.com>
List-Id: dm-devel.ids

On Fri, Jan 12, 2018 at 09:35:39PM +0100, Martin Wilck wrote:
> On Fri, 2018-01-12 at 09:38 +0100, Julian Andres Klode wrote:
> > 
> > and then we get I/O error on the device and it's rendered unusable.
> > It's
> > also crashing in uev_pathfail_check() occassionally because
> > find_path_by_devt()
> > returns NULL, so I applied the following patch to at least continue,
> > but that's
> > obviously wrong - We get an udev event for a device which does not
> > exist in /dev
> > (but it should)?
> 
> Adding Guan, as the pathfail check is from his code.
> 
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1090,6 +1090,11 @@ uev_pathfail_check(struct uevent *uev, s
> >  	lock(&vecs->lock);
> >  	pthread_testcancel();
> >  	pp = find_path_by_devt(vecs->pathvec, devt);
> > +	if (!pp) {
> > +		condlog(3, "%s: Cannot find path by dm path %s",
> > uev->kernel, devt);
> > +		FREE(devt);
> > +		goto out;
> > +	}
> >  	r = io_err_stat_handle_pathfail(pp);
> >  	lock_cleanup_pop(vecs->lock);
> 
> You need to cleanup the lock in the error path. I'd pefer checking
> for a NULL path argument in io_err_stat_handle_pathfail(). See
> attachment.

Oh, silly me. Yes, you're right, and your patch fixes the issue. 

> 
> I'm assuming that you are not using the "marginal path" logic. In
> general I don't like the fact that PATH_FAILED events are handled at
> all in multipathd if this logic is inactive; that code path is only
> needed for this purpose. But that's just a side note.

I don't know actually, I'm just updating the package :) I can say that
the tests were run with default configuration, normally we run with
DEFAULT_FIND_MULTIPATHS but that does not work yet with 0.7.4 - no
dm-0 device seems to get created in this test case (some systems without
multipath were broken 2.5 years ago just by installing it because it
took over non-multipath devices, hence the option was enabled; might
not even be needed anymore).

I'll collect some more data on Monday.

-- 
debian developer - deb.li/jak | jak-linux.org - free software dev
ubuntu core developer                              i speak de, en
