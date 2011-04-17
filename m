From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
Date: Sun, 17 Apr 2011 21:35:40 +0200
Message-ID: <201104172135.40189.arnd@arndb.de>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com> <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com> <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thilo-Alexander Ginkel <thilo@ginkel.com>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thursday 14 April 2011, Thilo-Alexander Ginkel wrote:
> All right... I verified all my bisect tests and actually found yet
> another bug. After correcting that one (and verifying the correctness
> of the other tests), git bisect actually came up with a commit, which
> makes some more sense:
> 
> | e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c is the first bad commit
> | commit e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c
> | Author: Tejun Heo <tj@kernel.org>
> | Date:   Tue Jun 29 10:07:14 2010 +0200
> |
> |     workqueue: implement concurrency managed dynamic worker pool

Is it possible to make it work by reverting this patch in 2.6.38?

> The good news is that I am able to reproduce the issue within a KVM
> virtual machine, so I am able to test for the soft lockup (which
> somewhat looks like a race condition during worker / CPU shutdown) in
> a mostly automated fashion. Unfortunately, that also means that this
> issue is all but hardware specific, i.e., it most probably affects all
> SMP systems (with a varying probability depending on the number of
> CPUs).
> 
> Adding some further details about my configuration (which I replicated
> in the VM):
> - lvm running on top of
> - dmcrypt (luks) running on top of
> - md raid1
> 
> If anyone is interested in getting hold of this VM for further tests,
> let me know and I'll try to figure out how to get it (2*8 GB, barely
> compressible due to dmcrypt) to its recipient.

Adding dm-devel to Cc, in case the problem is somewhere in there.

	Arnd
