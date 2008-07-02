From: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 2/6] drivers/md: remove null pointer dereference
Date: Wed, 2 Jul 2008 13:51:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807021351270.4854@ask.diku.dk>
References: <Pine.LNX.4.64.0805121537100.3694@ask.diku.dk>
	<20080702105434.GF22522@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080702105434.GF22522@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, 2 Jul 2008, Alasdair G Kergon wrote:

> On Mon, May 12, 2008 at 03:37:31PM +0200, Julia Lawall wrote:
> > If pgpath->pg->ps.type is NULL, it is not possible to access its name
> > field.  So I have simply modified the error message to drop the printing of
> > the name field.
> > 
> > This problem was found using the following semantic match
> > (http://www.emn.fr/x-info/coccinelle/)
>  
> > --- a/drivers/md/dm-mpath.c	2008-04-16 13:27:57.000000000 +0200
> > +++ b/drivers/md/dm-mpath.c	2008-05-12 09:19:35.000000000 +0200
> > @@ -884,8 +884,7 @@ static int reinstate_path(struct pgpath 
> >  		goto out;
> >  
> >  	if (!pgpath->pg->ps.type) {
> > -		DMWARN("Reinstate path not supported by path selector %s",
> > -		       pgpath->pg->ps.type->name);
> > +		DMWARN("Reinstate path not supported by path selector");
> >  		r = -EINVAL;
> >  		goto out;
> >  	}
>  
> Thanks for reporting this.
> 
> A more-sophisticated checker might discover that the test can never fail
> - see parse_path_selector() - and so the real problem here is that it is
> the wrong test.
> 
> The next line is:
> 	r = pgpath->pg->ps.type->reinstate_path(&pgpath->pg->ps, &pgpath->path);
> and the error message makes it clear that the intent was to ensure that
> the reinstate_path method exists before attempting to use it.
> 
> IOW
> 	if (!pgpath->pg->ps.type->reinstate_path) {

Thanks for the suggestions.

In looking at it a little bit, it seems that ps.type is initialized in the
function stored in the ctr field of the target_type structure and this
function is called in the function stored in the message field of the same
structure.  The function in the message structure seems to be only called
from the function target_message in dm-ioctl.c, but I don't see the
relation to an invocation of the ctr field.  Is that guaranteed to be
invoked earlier?

julia
