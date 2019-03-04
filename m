From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: x86 VM Boot hang with latest linux-next
Date: Mon, 4 Mar 2019 18:02:46 -0500
Message-ID: <20190304230246.GC20327@redhat.com>
References: <CAKgT0UeMqmojVrNV1i-DdY18EBwbJ_4zVTUggAWas5D5yeU1PQ@mail.gmail.com>
 <20190303034847.GA8699@redhat.com>
 <CAKgT0Ue9+wSL60Bj0drkgVQwem=mh_eTrFMda+inX4=qBgi3dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKgT0Ue9+wSL60Bj0drkgVQwem=mh_eTrFMda+inX4=qBgi3dA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Mar 03 2019 at 12:06pm -0500,
Alexander Duyck <alexander.duyck@gmail.com> wrote:

> Thanks. The behavior of it has me wondering if we are looking at
> something like an uninitialized data issue or something like that
> since as I mentioned I don't see this occur on every boot, just on
> most of them. So every now and then I can boot up the VM without any
> issues, but most of the time it will boot and then get stuck waiting
> on jobs that take forever.

The commit in question (1efa3bb79d3 "dm: must allocate dm_noclone for
stacked noclone devices") conditionally allocates the 'struct
dm_noclone' and I can only infer that the change is causing a negative
side-effect in virtualized environments (both x86_64 and s390).

I haven't been able to reproduce on x86_64 kvm with virtio-scsi on
fedora 25 though.  Will try fedora 29 shortly, and also try virtio-blk.

Could you please provide your guest's .config (even if just off-list)?
Also, what kernel are you running on the host?

Thanks,
Mike
