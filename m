From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 5/7] Fix set_no_path_retry() regression
Date: Thu, 8 Feb 2018 12:31:45 -0600
Message-ID: <20180208183145.GS14513@octiron.msp.redhat.com>
References: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
	<1518043787-7066-6-git-send-email-bmarzins@redhat.com>
	<1518081705.15245.50.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1518081705.15245.50.camel@suse.com>
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

On Thu, Feb 08, 2018 at 10:21:45AM +0100, Martin Wilck wrote:
> Hi Ben,
> =

> On Wed, 2018-02-07 at 16:49 -0600, Benjamin Marzinski wrote:
> > commit 0f850db7fceb6b2bf4968f3831efd250c17c6138 "multipathd: clean up
> > set_no_path_retry" has a bug in it. It made set_no_path_retry
> > never reset mpp->retry_ticks, even if the device was in recovery
> > mode,
> > and there were valid paths. This meant that adding new paths didn't
> > remove a device from recovery mode, and queueing could get disabled,
> > even while there were valid paths. This patch fixes that.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/structs_vec.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > =

> > diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> > index fbab61f..0de2221 100644
> > --- a/libmultipath/structs_vec.c
> > +++ b/libmultipath/structs_vec.c
> > @@ -343,9 +343,10 @@ static void set_no_path_retry(struct multipath
> > *mpp)
> >  			dm_queue_if_no_path(mpp->alias, 1);
> >  		break;
> >  	default:
> > -		if (mpp->nr_active > 0)
> > +		if (mpp->nr_active > 0) {
> > +			mpp->retry_tick =3D 0;
> >  			dm_queue_if_no_path(mpp->alias, 1);
> > -		else if (is_queueing && mpp->retry_tick =3D=3D 0)
> > +		} else if (is_queueing && mpp->retry_tick =3D=3D 0)
> >  			enter_recovery_mode(mpp);
> >  		break;
> >  	}
> =

> Please explain why it's sufficient to do this in the "default" case
> only. Before 0f850db7, set_no_path_retry() reset retry_tick for any
> value of no_path_retry.

before 0f850db7, set_no_path_retry() was doing this wrong.  it was
resetting the timeout whenever __setup_multipath() was called with
reset, even if there were no usable paths.  This could keep devices from
disabling queueing like they were supposed to, since retry_count_tick()
would ignore them if retry_tick was 0.

But, to go throught the current options: It makes no sense to reset
retry_tick if not_path_retry is set to NO_PATH_RETRY_UNDEF,
NO_PATH_RETRY_FAIL or NO_PATH_RETRY_QUEUE, because we never go into
recovery move... Well, actually that's not true. I just noticed a bug in
cli_restore_queueing() and cli_restore_all_queueing(), where we can go
into recovery mode if we are set to NO_PATH_RETRY_QUEUE. This isn't
actually a problem, since that sets retry_ticks to a negative number,
which means it will get ignored and we will never actually stop
queueing. But that obivously incorrect case aside, we should never be in
recovery mode in the first place unless no_path_retry is set to a
positive number.

The remaining cases where retry_tick was set before 0f850db7 and isn't
now are in the default case when there are no valid paths. In that case,
if we aren't in recovery mode, we should go into it (that's what the
"else if" code does), which means setting the retry_tick to something
other than 0.  If we have already timed out of recovery mode and queuing
is disabled, mpp->retry_tick already is 0. Finally, if we are currently
in recovery mode, and retry_tick isn't 0, then we should leave it alone.
Otherwise we are simply resetting the no_path_retry timer, when we still
don't have any paths, which is one of the bugs the original code was
supposed to fix, like I mentioned above.

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
