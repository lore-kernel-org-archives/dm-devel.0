From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Bisected: Massive memory leak in dm-snapshot in 3.1 development introduced
Date: Sun, 23 Oct 2011 12:52:06 +0300
Message-ID: <CA+55aFzfFpnEc+Eerdi9SfMw4o17ONfYCHksJkD1O6AS5U2DoQ@mail.gmail.com>
References: <20111023112140.37fd8b3d@xenia.leun.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111023112140.37fd8b3d@xenia.leun.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Michael Leun <ml@newton.leun.net>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Making sure that Alasdair sees this too (hopefully he picked up on it
from dm-devel, but best send things directly too)

Mikulas, Alasdair? I see the mempool_free() for the "master job", what
about everything else? Does the dm_kcopyd_prepare_callback() perhaps
need to do a

    job->master_job = job;

or similar?

                   Linus

On Sun, Oct 23, 2011 at 12:21 PM, Michael Leun <ml@newton.leun.net> wrote:
> Hi,
>
> How to reproduce:
>
> lvcreate -L30G -n testsnap vg1 # of course substitute VG as appropriate
> dd if=/dev/zero of=/dev/vg1/testsnap bs=2M # to make things clear
> lvcreate -L15G -s /dev/vg1/test -n testsnap
> dd if=/dev/zero of=/dev/vg1/testsnap bs=2M &
> watch free
>
> I noticed roughly 1GB memory vanishing from free / -/+ buffers/cache
> per 2GB copied.
>
> Bisecting yielded a6e50b409d3f9e0833e69c3c9cca822e8fa4adbb, reverting
> that from git master cures the memory leak
>
> --
> MfG,
>
> Michael Leun
>
>
