From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
Date: Fri, 29 Apr 2011 01:56:46 +0200
Message-ID: <BANLkTinK3jZmKewkbtmOn54cRXhszh_5sQ@mail.gmail.com>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
 <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com> <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
 <201104172135.40189.arnd@arndb.de> <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
 <20110426131132.GG878@htj.dyndns.org> <BANLkTin71zQH2qDNiwPp6vQppy3YWhbj2A@mail.gmail.com>
 <20110428103036.GB10721@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110428103036.GB10721@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Apr 28, 2011 at 12:30, Tejun Heo <tj@kernel.org> wrote:
> Does your kernel have preemption enabled?

CONFIG_PREEMPT is not set

> If not, does the following patch fix the problem?

Yep, looks good so far (at least in my virtualized test environment):
2.6.39-rc4 with your patch applied survived 100 suspend/resume cycles
w/o locking up.

Just out of curiosity: Was this a new issue in 2.6.39-rc4 ord could
this fix be backported to 2.6.38?

Thanks,
Thilo
