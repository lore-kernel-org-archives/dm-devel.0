From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
Date: Sun, 17 Apr 2011 23:53:42 +0200
Message-ID: <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
 <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com> <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
 <201104172135.40189.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201104172135.40189.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Apr 17, 2011 at 21:35, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 14 April 2011, Thilo-Alexander Ginkel wrote:
>> All right... I verified all my bisect tests and actually found yet
>> another bug. After correcting that one (and verifying the correctnes=
s
>> of the other tests), git bisect actually came up with a commit, whic=
h
>> makes some more sense:
>>
>> | e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c is the first bad commit
>> | commit e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c
>> | Author: Tejun Heo <tj@kernel.org>
>> | Date: =C2=A0 Tue Jun 29 10:07:14 2010 +0200
>> |
>> | =C2=A0 =C2=A0 workqueue: implement concurrency managed dynamic wor=
ker pool
>
> Is it possible to make it work by reverting this patch in 2.6.38?

Unfortunately, that's not that easy to test as the reverted patch does
not apply cleanly against 2.6.38 (23 failed hunks) and I am not sure
whether I want to revert it manually ;-).

>> The good news is that I am able to reproduce the issue within a KVM
>> virtual machine, so I am able to test for the soft lockup (which
>> somewhat looks like a race condition during worker / CPU shutdown) i=
n
>> a mostly automated fashion. Unfortunately, that also means that this
>> issue is all but hardware specific, i.e., it most probably affects a=
ll
>> SMP systems (with a varying probability depending on the number of
>> CPUs).
>>
>> Adding some further details about my configuration (which I replicat=
ed
>> in the VM):
>> - lvm running on top of
>> - dmcrypt (luks) running on top of
>> - md raid1
>>
>> If anyone is interested in getting hold of this VM for further tests=
,
>> let me know and I'll try to figure out how to get it (2*8 GB, barely
>> compressible due to dmcrypt) to its recipient.
>
> Adding dm-devel to Cc, in case the problem is somewhere in there.

In the meantime I also figured out that 2.6.39-rc3 seems to fix the
issue (there have been some work queue changes, so this is somewhat
sensible) and that raid1 seems to be sufficient to trigger the issue.
Now one could try to figure out what actually fixed it, but if that
means another bisect series I am not too keen to perform that
exercise. ;-) If someone else feels inclined to do so, my test
environment is available for download, though:
  https://secure.tgbyte.de/dropbox/lockup-test.tar.bz2 (~ 700 MB)

Boot using:
  kvm -hda LockupTestRaid-1.qcow2 -hdb LockupTestRaid-2.qcow2 -smp 8
-m 1024 -curses

To run the test, log in as root / test and run:
  /root/suspend-test

Regards,
Thilo
