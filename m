From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
Date: Thu, 28 Apr 2011 01:51:34 +0200
Message-ID: <BANLkTin71zQH2qDNiwPp6vQppy3YWhbj2A@mail.gmail.com>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
 <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com> <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
 <201104172135.40189.arnd@arndb.de> <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
 <20110426131132.GG878@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110426131132.GG878@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Apr 26, 2011 at 15:11, Tejun Heo <tj@kernel.org> wrote:
> Hello, sorry about the delay. =C2=A0Was on the road and then sick.

No problem. Thanks for getting back to me.

>> In the meantime I also figured out that 2.6.39-rc3 seems to fix the
>> issue (there have been some work queue changes, so this is somewhat
>> sensible)
>
> Hmmm... that's a big demotivator. =C2=A0:-)

Well, I get your point. ;-) Maybe this fact can help as a motivator: I
ran some further tests and while -rc3 seems to be ok (and survived 100
suspend/resume cycles), the issue strangely seems to be back with -rc4
(the softlockup call stack that I can see is identical to the photos
below; the lockup happened after only two cycles).

> Before I go ahead and try that, do you happen to have softlockup dump=
?
> ie. stack traces of the stuck tasks? =C2=A0I can't find the original
> posting.

Sure:

=46rom <BANLkTi=3Dn4jLsjOYCd0L3hYb30sgPmdv_WA@mail.gmail.com>:
> Unfortunately, the output via a serial console becomes garbled after
> "Entering mem sleep", so I went for patching dumpstack_64.c and a
> couple of other source files to reduce the verbosity. I hope not to
> have stripped any essential information. The result is available in
> these pictures:
>   https://secure.tgbyte.de/dropbox/IeZalo4t-1.jpg
>   https://secure.tgbyte.de/dropbox/IeZalo4t-2.jpg
>
> For both traces, the printed error message reads: "BUG: soft lockup -
> CPU#3 stuck for 67s! [kblockd:28]"

Thanks,
Thilo
