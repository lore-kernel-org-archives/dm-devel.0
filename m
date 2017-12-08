From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 04/12] libmultipath: cleanup features
	handling code
Date: Fri, 8 Dec 2017 15:12:07 -0600
Message-ID: <20171208211207.GC5638@octiron.msp.redhat.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
	<1512672546-12785-5-git-send-email-bmarzins@redhat.com>
	<1512746692.11972.67.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1512746692.11972.67.camel@suse.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 08, 2017 at 04:24:52PM +0100, Martin Wilck wrote:
> On Thu, 2017-12-07 at 12:48 -0600, Benjamin Marzinski wrote:
> =

> > retain_attached_hw_handler was never getting updated before, so
> > the output when you created a map was incorrect.
> =

> While I've already ACKed your patch, I don't understand what you mean
> here. Before your patch, "retain_attached_hw_handler" was set from
> config options and correctly copied to the features string in
> assemble_map, no?
> =


It is correctly copied to the features string you send to the kernel. It
was not copied to the multipath object that the multipath program is
dealing with.  So if you run "multipath" and it creates the device, what
is prints out as the device it created will not include
"retain_attached_hw_handler", even if it did send that feature to the
kernel.  If you run "multipath -l" afterwards, you will see that the
device does have "retain_attached_hw_handler" set.  This doesn't happen
with queue_if_no_path because of the add_feature() call in the code
below.  That goes through and adds "queue_if_no_path" back to the
features string of the multipath object that multipath will using to
print its output on creation.  Of course, none of that matters on newer
kernels anyway, because we will remove "retain_attached_hw_handler" from
the features line, since that behaviour is automatic now.

> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index 0dfa250..7ca84b8 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -1060,21 +1062,6 @@ int coalesce_paths (struct vectors * vecs,
> > vector newmp, char * refwwid,
> >  				remove_feature(&mpp->features,
> >  					       "queue_if_no_path");
> >  		}
> > -		else if (mpp->no_path_retry !=3D NO_PATH_RETRY_UNDEF)
> > {
> > -			if (mpp->no_path_retry =3D=3D
> > NO_PATH_RETRY_FAIL) {
> > -				condlog(3, "%s: unset
> > queue_if_no_path feature",
> > -					mpp->alias);
> > -				if (!dm_queue_if_no_path(mpp->alias, =

> > 0))
> > -					remove_feature(&mpp-
> > >features,
> > -						       "queue_if_no_
> > path");
> > -			} else {
> > -				condlog(3, "%s: set queue_if_no_path
> > feature",
> > -					mpp->alias);
> > -				if (!dm_queue_if_no_path(mpp->alias, =

> > 1))
> > -					add_feature(&mpp->features,
> > -						    "queue_if_no_pat
> > h");
> > -			}
> > -		}
> =

> AFAICS we could also get rid of the calls to dm_queue_if_no_path() in =

> reload_map(), right?

Oops. I meant to remove it there as well. Good catch. I'll send a
follow-up patch.

-Ben

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
