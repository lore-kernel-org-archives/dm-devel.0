From: Tejun Heo <tj@kernel.org>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
Date: Tue, 26 Apr 2011 15:11:32 +0200
Message-ID: <20110426131132.GG878@htj.dyndns.org>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
 <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com>
 <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
 <201104172135.40189.arnd@arndb.de>
 <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thilo-Alexander Ginkel <thilo@ginkel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello, sorry about the delay.  Was on the road and then sick.

On Sun, Apr 17, 2011 at 11:53:42PM +0200, Thilo-Alexander Ginkel wrote:
> >> | e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c is the first bad commit
> >> | commit e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c
> >> | Author: Tejun Heo <tj@kernel.org>
> >> | Date: =A0 Tue Jun 29 10:07:14 2010 +0200
> >> |
> >> | =A0 =A0 workqueue: implement concurrency managed dynamic worker =
pool
> >
> > Is it possible to make it work by reverting this patch in 2.6.38?
>=20
> Unfortunately, that's not that easy to test as the reverted patch doe=
s
> not apply cleanly against 2.6.38 (23 failed hunks) and I am not sure
> whether I want to revert it manually ;-).

Yeap, reverting that one would be a major effort at this point.
Hmmm... assuming all the workqueue usages were correct, the change
shouldn't have introduced such bug.  All forward progress guarantees
remain the same in that all workqueues are automatically given a
rescuer thread.  That said, there have been some number of bug fixes
and cases where single rescuer guarantee wasn't enough (which was
dangerous before the change too but was less likely to trigger).

> >> If anyone is interested in getting hold of this VM for further tes=
ts,
> >> let me know and I'll try to figure out how to get it (2*8 GB, bare=
ly
> >> compressible due to dmcrypt) to its recipient.
> >
> > Adding dm-devel to Cc, in case the problem is somewhere in there.
>=20
> In the meantime I also figured out that 2.6.39-rc3 seems to fix the
> issue (there have been some work queue changes, so this is somewhat
> sensible)

Hmmm... that's a big demotivator.  :-)

> and that raid1 seems to be sufficient to trigger the issue.
> Now one could try to figure out what actually fixed it, but if that
> means another bisect series I am not too keen to perform that
> exercise. ;-) If someone else feels inclined to do so, my test
> environment is available for download, though:
>   https://secure.tgbyte.de/dropbox/lockup-test.tar.bz2 (~ 700 MB)
>=20
> Boot using:
>   kvm -hda LockupTestRaid-1.qcow2 -hdb LockupTestRaid-2.qcow2 -smp 8
> -m 1024 -curses
>=20
> To run the test, log in as root / test and run:
>   /root/suspend-test

Before I go ahead and try that, do you happen to have softlockup dump?
ie. stack traces of the stuck tasks?  I can't find the original
posting.

Thank you.

--=20
tejun
