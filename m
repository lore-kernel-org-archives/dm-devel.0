From: Tejun Heo <tj@kernel.org>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
Date: Thu, 28 Apr 2011 12:30:36 +0200
Message-ID: <20110428103036.GB10721@htj.dyndns.org>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
 <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com>
 <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
 <201104172135.40189.arnd@arndb.de>
 <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
 <20110426131132.GG878@htj.dyndns.org>
 <BANLkTin71zQH2qDNiwPp6vQppy3YWhbj2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTin71zQH2qDNiwPp6vQppy3YWhbj2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thilo-Alexander Ginkel <thilo@ginkel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

On Thu, Apr 28, 2011 at 01:51:34AM +0200, Thilo-Alexander Ginkel wrote:
> Well, I get your point. ;-) Maybe this fact can help as a motivator: =
I
> ran some further tests and while -rc3 seems to be ok (and survived 10=
0
> suspend/resume cycles), the issue strangely seems to be back with -rc=
4
> (the softlockup call stack that I can see is identical to the photos
> below; the lockup happened after only two cycles).
>=20
> > Before I go ahead and try that, do you happen to have softlockup du=
mp?
> > ie. stack traces of the stuck tasks? =A0I can't find the original
> > posting.
>=20
> Sure:
>=20
> From <BANLkTi=3Dn4jLsjOYCd0L3hYb30sgPmdv_WA@mail.gmail.com>:
> > Unfortunately, the output via a serial console becomes garbled afte=
r
> > "Entering mem sleep", so I went for patching dumpstack_64.c and a
> > couple of other source files to reduce the verbosity. I hope not to
> > have stripped any essential information. The result is available in
> > these pictures:
> >   https://secure.tgbyte.de/dropbox/IeZalo4t-1.jpg
> >   https://secure.tgbyte.de/dropbox/IeZalo4t-2.jpg
> >
> > For both traces, the printed error message reads: "BUG: soft lockup=
 -
> > CPU#3 stuck for 67s! [kblockd:28]"

Does your kernel have preemption enabled?  If not, does the following
patch fix the problem?

Thanks.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 04ef830..08c7334 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1293,6 +1293,7 @@ __acquires(&gcwq->lock)
=20
 		/* CPU has come up inbetween, retry migration */
 		cpu_relax();
+		cond_resched();
 	}
 }
