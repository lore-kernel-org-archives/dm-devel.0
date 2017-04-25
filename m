From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 3/3] Add options to multipathd to turn off
 queueing
Date: Tue, 25 Apr 2017 13:03:59 -0500
Message-ID: <20170425180359.GU19236@octiron.msp.redhat.com>
References: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
	<1236883093-2989-4-git-send-email-bmarzins@redhat.com>
	<f99991a6-a2a5-e8fb-17b8-ff9f6a51a515@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <f99991a6-a2a5-e8fb-17b8-ff9f6a51a515@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Apr 25, 2017 at 03:38:38PM +0200, Xose Vazquez Perez wrote:
> On 03/12/2009 07:38 PM, Benjamin Marzinski wrote:
>          ^^^^ Old patch.
> 
> > Even when the last path of a multipath device is deleted, it can't be
> > removed until all the queued IO is flushed. For devices that have
> > no_path_retry set to queue, this doesn't automatically happen.
> > 
> > This patch adds a "flush_on_last_del" config file option, that causes the
> > multipath device to automatically turn off queueing when the last path is
> > deleted.  It also adds the "disablequeueing" and "restorequeueing"
> > multipathd cli commands.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > [...]
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index 43611ff..c1bc591 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -279,6 +279,10 @@ select_prio (struct path * pp)
> >  extern int
> >  select_no_path_retry(struct multipath *mp)
> >  {
> > +	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS) {
> > +		condlog(0, "flush_on_last_del in progress");
>                             ^^^^
> If flush is done per LUN, it should be added a prefix(WWID or alias).

Yep. I can send a patch for this.

Thanks.
-Ben

> 
> > +		mp->no_path_retry = NO_PATH_RETRY_FAIL;
> > +	}
> >  	if (mp->mpe && mp->mpe->no_path_retry != NO_PATH_RETRY_UNDEF) {
> >  		mp->no_path_retry = mp->mpe->no_path_retry;
> >  		condlog(3, "%s: no_path_retry = %i (multipath setting)",
> > @@ -368,3 +372,31 @@ select_pg_timeout(struct multipath *mp)
> >  	condlog(3, "pg_timeout = NONE (internal default)");
> >  	return 0;
> >  }
> Thank you.
