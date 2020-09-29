From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 19/23] multipathd: move cleanup_{prio,
 checkers, foreign} to libmultipath_exit
Date: Tue, 29 Sep 2020 12:50:55 -0500
Message-ID: <20200929175055.GS3384@octiron.msp.redhat.com>
References: <20200924134054.14632-1-mwilck@suse.com>
	<20200924134054.14632-20-mwilck@suse.com>
	<20200928202624.GP3384@octiron.msp.redhat.com>
	<3ebea94ffd3be1a24c1f3a3159a337a7e878ce99.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3ebea94ffd3be1a24c1f3a3159a337a7e878ce99.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.com>
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Sep 29, 2020 at 11:31:06AM +0200, Martin Wilck wrote:
> On Mon, 2020-09-28 at 15:26 -0500, Benjamin Marzinski wrote:
> > On Thu, Sep 24, 2020 at 03:40:50PM +0200, mwilck@suse.com wrote:
> > > 
> > >  /*
> > >   * We don't support re-initialization after
> > > @@ -65,6 +66,9 @@ int libmultipath_init(void)
> > >  static void _libmultipath_exit(void)
> > >  {
> > >  	libmultipath_exit_called = true;
> > > +	cleanup_foreign();
> > 
> > I don't really feel too strongly about this, but it seems to me that
> > there is a difference between the checkers and prioritizers, which
> > it seems like most users of libmultipath would want, and the foreign
> > code, which doesn't seem that way. libmpathpersist, for instance,
> > will use the checkers and prioritizers, but not the foreign code.
> > On the other hand, if the caller isn't using the foreign code,
> > then grabbing the lock and checking the foreign pointer shouldn't
> > take much time.
> 
> It would just be a few cycles. I want callers to have to worry about
> cleanup as little as possible. All else is error-prone IMO, and
> although I agree that the foreign functions are less important than
> checkers and prio, I thought it made sense to treat all our "plug-ins"
> the same way.
> 
> Ideally I'd like to do checker/prio/foreign initialization completely
> lazily too, in the sense that callers don't need to worry about calling
> init_checkers() etc., either. But this series had to stop at some
> point.
> 
> Either way, it's not a big issue, so please tell me if you feel
> strongly enough about it to ask me to revert the change.

I already ACKed this bug in my reply to:

[PATCH 00/23] libmultipath: improve cleanup on exit

https://www.redhat.com/archives/dm-devel/2020-September/msg00635.html

Sorry for the confusion.
-Ben
 
> Regards,
> Martin
> 
