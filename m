From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 07/12] multipathd: ignore failed wwid
	recheck
Date: Tue, 19 Mar 2019 12:13:53 -0500
Message-ID: <20190319171353.GG13295@octiron.msp.redhat.com>
References: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
	<1552086725-18476-8-git-send-email-bmarzins@redhat.com>
	<17d16e1ae0b183405707a719eb661e33ae7b05ec.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <17d16e1ae0b183405707a719eb661e33ae7b05ec.camel@suse.com>
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

On Fri, Mar 15, 2019 at 12:48:49PM +0100, Martin Wilck wrote:
> On Fri, 2019-03-08 at 17:12 -0600, Benjamin Marzinski wrote:
> > If disable_changed_wwids is set, when multipathd gets a change event
> > on
> > a path, it verifies that the wwid hasn't changed in
> > uev_update_path().
> > If get_uid() failed, uev_update_path treated this as a wwid change to
> > 0.
> > This could cause paths to suddenly be dropped due to an issue with
> > getting the wwid.  Even if get_uid() failed because the path was
> > down,
> > it no change uevent happend when it later became active, multipathd
> > would continue to ignore the path. Also, scsi_uid_fallback() clears
> > the
> > failure return if it doesn't attempt to fallback, causing get_uid()
> > to return success, when it actually failed.
> > =

> > Multipathd should neither set nor clear wwid_changed if get_uid()
> > returned failure. Also, scsi_uid_fallback() should retain the old
> > return
> > value if it doesn't attempt to fallback.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/discovery.c | 6 +++---
> >  multipathd/main.c        | 6 ++++--
> >  2 files changed, 7 insertions(+), 5 deletions(-)
> > =

> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index 729bcb9..b08cb2d 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -1755,9 +1755,9 @@ get_vpd_uid(struct path * pp)
> >  }
> >  =

> >  static ssize_t scsi_uid_fallback(struct path *pp, int path_state,
> > -			     const char **origin)
> > +			     const char **origin, ssize_t old_len)
> >  {
> > -	ssize_t len =3D 0;
> > +	ssize_t len =3D old_len;
> >  	int retrigger;
> >  	struct config *conf;
> =

> Please don't call this variable "old_len" but "errcode" or the like. If
> this is called, "old_len" is always negative (indicating a previous
> error) or 0 (indicating previous attempts returned an empty WWID, which
> is also likely an error).

Sure.
 =

> Otherwise, ACK. But you revert most of this later in 12/12; I think the
> two should be merged (except for the scsi_uid_fallback part, maybe).

See my reply to your "New approach at handling changed WWIDs" patches.
Something like this patch is still my preferred solution, for reasons I
explain there.

-Ben

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
