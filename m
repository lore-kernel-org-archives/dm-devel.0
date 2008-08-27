From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: linux-next: Tree for August 27
Date: Wed, 27 Aug 2008 21:45:20 +0200
Message-ID: <200808272145.20627.bzolnier@gmail.com>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <200808271206.48370.bzolnier@gmail.com> <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com>
Content-Disposition: inline
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wednesday 27 August 2008, Bartlomiej Zolnierkiewicz wrote:
> On Wed, Aug 27, 2008 at 12:06 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> >
> > Hi,
> >
> > On Wednesday 27 August 2008, Stephen Rothwell wrote:
> >> Hi all,
> >>
> >> Changes since next-20080826:
> >
> > it fails to build here with:
> >
> > arch/x86/kernel/cpu/addon_cpuid_features.c: In function 'detect_extended_topology':
> > arch/x86/kernel/cpu/addon_cpuid_features.c:119: error: 'struct cpuinfo_x86' hasno member named 'cpu_core_id'
> > arch/x86/kernel/cpu/addon_cpuid_features.c:121: error: 'struct cpuinfo_x86' hasno member named 'phys_proc_id'
> > arch/x86/kernel/cpu/addon_cpuid_features.c:130: error: 'struct cpuinfo_x86' hasno member named 'phys_proc_id'
> > arch/x86/kernel/cpu/addon_cpuid_features.c:133: error: 'struct cpuinfo_x86' hasno member named 'cpu_core_id'
> > make[2]: *** [arch/x86/kernel/cpu/addon_cpuid_features.o] Error 1
> > make[1]: *** [arch/x86/kernel/cpu] Error 2
> > make: *** [arch/x86/kernel] Error 2
> 
> which is most likely already fixed in x86 tree by
> 
> http://lkml.org/lkml/2008/8/27/34

Confirmed.

However now I'm getting device-mapper errors on 'cryptsetup create':

dmesg:
...
device-mapper: core: bdget failed in dm_suspend
device-mapper: ioctl: device doesn't appear to be in the dev hash table.
...

cryptsetup:
...
Command failed: device-mapper: resume ioctl failed: Invalid argument
...

next-20080826 is fine

BTW it also seems that certain people need some encouragement
to fix the nasty warning first reported by Randy two weeks ago
(http://lkml.org/lkml/2008/8/14/207) and later addressed by
Rusty (http://lkml.org/lkml/2008/8/16/40) (the solution is said
to be fragile but there doesn't seem to be any better one on
the horizon so...)
