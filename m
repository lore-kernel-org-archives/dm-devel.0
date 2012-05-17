From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: Add del_timer_sync to mddev_suspend (fix nasty
 panic)
Date: Thu, 17 May 2012 10:50:32 +1000
Message-ID: <20120517105032.007f09c7@notabene.brown>
References: <1337141174.4337.8.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/720N7EvtfXEhCKbscv90.3Y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1337141174.4337.8.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/720N7EvtfXEhCKbscv90.3Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 May 2012 23:06:14 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> I've been seeing some really bad panics take place on dm-raid.c.  I've
> found that it is because the mddev->safemode_timer is firing after the
> mddev structure has been freed.  I've attached a patch to fix the
> problem below, but I have some questions (outlined in the patch header).
> I also have a debugging patch that prints something during each of the
> suspend stages and when md_write_end resets the timer so that you can
> see the problem in action - let me know if you want that patch also.
>=20
>  brassow

Hi Jon,
 thanks for the patch.  It looks simple and can clearly fix a problem
so at this point in the cycle I propose to submit it to Linus as-is, even
though I'm not convinced it is perfect, and you didn't give me a s-o-b line.
See more blow.

>=20
> Use del_timer_sync to remove timer before mddev_suspend finishes.
>=20
> We don't want a timer going off after an mddev_suspend is called.  This is
> especially true with device-mapper, since it can call the destructor func=
tion
> immediately following a suspend.  This results in the removal (kfree) of =
the
> structures upon which the timer depends - resulting in a very ugly panic.
> Therefore, we add a del_timer_sync to mddev_suspend to prevent this.
>=20
> <RFC>
> While this approach works, it seems that 'md_stop_writes' should handle t=
his
> properly.  It calls del_timer_sync already, but then allows writes to /fi=
nish/
> after it is called.  Finishing writes call md_write_end, which resets the=
 timer.
> Why call del_timer_sync at all there?

Because md_stop_writes shouldn't really be called until all incoming write
requests have completed.  md_stop_write is really meant to make sure that
write initiated by md itself have stopped.

However since the recent change to the reboot notifier, md does sometimes
call it while there could be outstanding writes.  In this case it set
safe_mode to 2 which ensures that the timer is never re-activated.

Maybe that is the "right" fix - set safe_mode to 2 inside md_stop_writes.

>=20
> Device-mapper often makes use of the fact that mapping tables can be swap=
ped
> for a particular device.  In these scenarios, it is not uncommon to have =
I/O
> flowing to a device when the following sequence of device-mapper primitiv=
es
> are issued:
> 	- presuspend
> 	- postsuspend
> 	- dtr
> Although I can't seem to find documentation on it, it is my impression th=
at
> once the presuspend is complete, no nominal I/O must be allowed through or
> pending.  IOW, all I/O must be finished processing or queued.  This does =
not
> include driver issued I/O, like the updating of bitmaps - that I/O must be
> completed by the time postsuspend is complete.  (These are unwritten rule=
s,
> I think, and the main suspend rule is the important one: No I/O must be a=
llowed
> to flow or be pending once a suspend returns.)
>=20
> dm-raid.c calls 'md_stop_writes' for the purpose of stopping nominal I/O.
> It is clear that some writes are still allowed to finish-up after this ca=
ll
> is made.  Is this correct behavior?

If you want to stop normal IO, you should either just stop sending IO
requests, or call mddev_suspend which causes all new IO to be queued.

With md, md_stop is not allowed to be called until all normal IO is
complete.  It then calls md_stop_writes to stop md initiated IO.

So md needs the del_timer_sync in md_stop_writes because it never calls
mddev_suspend (except when changing levels).  dm needs it to be in
mddev_suspend as well which is fine for now, but maybe we can clean up bit
for 3.5.

>=20
> dm-raid.c calls 'mddev_suspend' to ensure no I/O (nominal or driver-issue=
d)
> is flowing.  This seems to be working as expected.  However, adding the
> del_timer_sync here allows us to clean up after any finished writes that
> occurred after 'md_stop_writes' - preventing a kernel panic from a possib=
le
> 'dtr' call that may follow.
> </RFC>
>=20
> RFC-by: Jonathan Brassow <jbrassow@redhat.com>

<pet peeve>.
No Signed-off-by: line?  why is that.

"Signed-off-by" *only* means "I certify that I have any necessary right to
submit this patch, and I agree to it being used in the way that all other
code in this project can be used" - only with more words.  See the Develope=
r's
Certificate of Origin 1.1

Refusing to add a Signed-off-by: because you don't think the code is "ready"
yet in some sense is just plain wrong.  I never ever want to even see a pat=
ch
that doesn't have Signed-off-by, because I don't know if I've been given
permission to use it.

Certainly add an 'RFC-by' if you want to say something about the quality of
the patch, but don't for that reason exclude the signed-off-by
</pet peeve>

Thanks,
NeilBrown


> Index: linux-upstream/drivers/md/md.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/md.c
> +++ linux-upstream/drivers/md/md.c
> @@ -391,6 +391,8 @@ void mddev_suspend(struct mddev *mddev)
>  	synchronize_rcu();
>  	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) =3D=3D 0);
>  	mddev->pers->quiesce(mddev, 1);
> +
> +	del_timer_sync(&mddev->safemode_timer);
>  }
>  EXPORT_SYMBOL_GPL(mddev_suspend);
> =20
>=20


--Sig_/720N7EvtfXEhCKbscv90.3Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7RLWDnsnt1WYoG5AQKvihAAvISFpOLjO2Lkx9WPb0pk4CcQXd4hA7dc
ywJSePh3WurISSPY/63qbF0dqsppUR5SKwjFfLwDI01entUbIcAh+rM/cPcVLtBu
oe5YyJxJMC+0WGqkCovoYfmn6FGNpdSdmUirhM1wxHx1rxKGEwC0IspVBMC3rly6
FZiC08yk0dsmFwZ24iDPfBrdc1+lwlnslmyk0uZPgHA9GfS3OsvGcOzu53cFMA18
odjHqOdyEh13KZlIgjlDZoypahLxACftGBPD6xq/60Wu85KJXGHRZeHsnc4x7EUO
mixeHaTEcLEwTPX5YzHueVCCg5KKRKfKvC+XfJRysXBbSvZntzCRvEW46UzWnN2J
hJUtJxpTT+CW+sNWwvEdQEDy05FSfZIGXHjegIfCpB4TEi66MFE+wavhsTlo1grF
2wB0X8FdeQCNLt2Qz+csjpcayElYUIW4I5fLQQBqVNX/Z64J8tlVYk+mn0wmJ+g0
wLp8zBInUa1ZYtsc1bL97IVEkopD8+7pVKokCWVNCnrpP9unCInKBB1tBO+M/Atq
ZkA/HdOYJvFzjC2A0SfoH6BpeEvzxupiS7Zx5sBeY2v05NelAxsdmCYxf6ohsiGO
H2YXtWDHeG/eAmwhQlM8gZHf8rhdvWcMbjP5WxyxOzd9+wArplrG3E2hHdgJ8nC9
UkjRlEo6pzc=
=q2Ou
-----END PGP SIGNATURE-----

--Sig_/720N7EvtfXEhCKbscv90.3Y--
