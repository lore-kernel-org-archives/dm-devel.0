From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath-tools: add ANA support for NVMe device
Date: Tue, 13 Nov 2018 13:00:09 -0500
Message-ID: <20181113180008.GA12513@redhat.com>
References: <1541657381-7452-1-git-send-email-lijie34@huawei.com>
 <2691abf6733f791fb16b86d96446440e4aaff99f.camel@suse.com>
 <20181112215323.GA7983@redhat.com>
 <20181113161838.GC9827@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181113161838.GC9827@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, hch@lst.de, axboe@kernel.dk
Cc: Martin Wilck <mwilck@suse.com>, lijie <lijie34@huawei.com>, xose.vazquez@gmail.com, linux-nvme@lists.infradead.org, chengjike.cheng@huawei.com, shenhong09@huawei.com, dm-devel@redhat.com, wangzhoumengjian@huawei.com, hare@suse.de, christophe.varoqui@opensvc.com, bmarzins@redhat.com, sschremm@netapp.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Nov 13 2018 at 11:18am -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Mon, Nov 12, 2018 at 04:53:23PM -0500, Mike Snitzer wrote:
> > On Mon, Nov 12 2018 at 11:23am -0500,
> > Martin Wilck <mwilck@suse.com> wrote:
> > 
> > > Hello Lijie,
> > > 
> > > On Thu, 2018-11-08 at 14:09 +0800, lijie wrote:
> > > > Add support for Asynchronous Namespace Access as specified in NVMe
> > > > 1.3
> > > > TP 4004. The states are updated through reading the ANA log page.
> > > > 
> > > > By default, the native nvme multipath takes over the nvme device.
> > > > We can pass a false to the parameter 'multipath' of the nvme-core.ko
> > > > module,when we want to use multipath-tools.
> > > 
> > > Thank you for the patch. It looks quite good to me. I've tested it with
> > > a Linux target and found no problems so far.
> > > 
> > > I have a few questions and comments inline below.
> > > 
> > > I suggest you also have a look at detect_prio(); it seems to make sense
> > > to use the ana prioritizer for NVMe paths automatically if ANA is
> > > supported (with your patch, "detect_prio no" and "prio ana" have to be
> > > configured explicitly). But that can be done in a later patch.
> > 
> > I (and others) think it makes sense to at least triple check with the
> > NVMe developers (now cc'd) to see if we could get agreement on the nvme
> > driver providing the ANA state via sysfs (when modparam
> > nvme_core.multipath=N is set), like Hannes proposed here:
> > http://lists.infradead.org/pipermail/linux-nvme/2018-November/020765.html
> > 
> > Then the userspace multipath-tools ANA support could just read sysfs
> > rather than reinvent harvesting the ANA state via ioctl.
> 
> I'd prefer not duplicating the log page parsing. Maybe nvme's shouldn't
> even be tied to CONFIG_NVME_MULTIPATH so that the 'multipath' param
> isn't even an issue.

I like your instincts, we just need to take them a bit further.

Splitting out the kernel's ANA log page parsing won't buy us much given
it is userspace (multipath-tools) that needs to consume it.  The less
work userspace needs to do (because kernel has already done it) the
better.

If the NVMe driver is made to always track and export the ANA state via
sysfs [1] we'd avoid userspace parsing duplication "for free".  This
should occur regardless of what layer is reacting to the ANA state
changes (be it NVMe's native multipathing or multipath-tools).

ANA and NVMe multipathing really are disjoint, making them tightly
coupled only serves to force NVMe driver provided multipathing _or_
userspace ANA state tracking duplication that really isn't ideal [2].

We need a reasoned answer to the primary question of whether the NVMe
maintainers are willing to cooperate by providing this basic ANA sysfs
export even if nvme_core.multipath=N [1].

Christoph said "No" [3], but offered little _real_ justification for why
this isn't the right thing for NVMe in general -- even when asked the
question gets ignored [4].

The inability to provide proper justification for rejecting a patch
(that already had one co-maintainer's Reviewed-by [5]) _should_ render
that rejection baseless, and the patch applied (especially if there is
contributing subsystem developer interest in maintaining this support
over time, which there is).  At least that is what would happen in a
properly maintained kernel subsystem.

It'd really go a long way if senior Linux NVMe maintainers took steps to
accept reasonable changes.

Mike

[1]: http://lists.infradead.org/pipermail/linux-nvme/2018-November/020765.html
[2]: https://www.redhat.com/archives/dm-devel/2018-November/msg00072.html
[3]: http://lists.infradead.org/pipermail/linux-nvme/2018-November/020815.html
[4]: http://lists.infradead.org/pipermail/linux-nvme/2018-November/020846.html
[5]: http://lists.infradead.org/pipermail/linux-nvme/2018-November/020790.html
