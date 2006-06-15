From: Tom Wirschell <Tom@Wirschell.nl>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Thu, 15 Jun 2006 23:25:42 +0200
Message-ID: <20060615232542.6b085337@localhost>
References: <20060613235316.7f982af7@localhost>
	<62b0912f0606140419s60c30535pbcc97c30ef99c50d@mail.gmail.com>
	<Pine.LNX.4.63.0606141609310.7019@pingle.local.rsnet>
	<20060614215258.6aa76d0f@localhost>
	<87f94c370606151329y4132e53dgf964a093683435e3@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87f94c370606151329y4132e53dgf964a093683435e3@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 15 Jun 2006, Greg Freemyer wrote:
>=20
> In 2.6.17-mm there is a huge SATA error handler (EH) rewrite.  Is is
> planned to hit the stable Linus kernel with 2.6.18 towards the end of
> the summer, but even then it will only have a few of the actual
> drivers modified to use the EH infrastructure.

Damn. I read about this in the LWN.net Kernel pages for may 17th. I
figured that once it was in, everything would automagically be using it
too (i.e. the drivers wouldn't need to be updated to the new system).
Guess I was a tad na=C3=AFve about that.
I tried 2.6.17-rc5-mm2 and ran into some BUG()s which went away when I
just stuck to 2.6.17-rc5.

> I would repost your problem to the lkml-ide list and see if they think
> that the new EH should help you, and when/if your controller will be
> using the new EH infrastructure.

Looks like a good idea, thanks!
Don't let that keep anybody on this list who might have an explanation
for this be deterred from responding though. :)

> Also, there is a ton of testing going on with the new EH, so if your
> willing to be a guinea pig, I'm sure you will get a lot of support
> from the dev. team and get your specific driver updated ASAP.

I've been sitting on a non-functional array for almost 3 months now.
Don't mind having weird issues a little longer if it means things will
end up working nicely in the end (or I at least get a sensible
explanation for what's wrong, so I know what I must do to fix it).

Kind regards,

Tom Wirschell
