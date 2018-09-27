From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/2] boot to a mapped device
Date: Thu, 27 Sep 2018 14:31:41 -0400
Message-ID: <20180927183141.GA4921@redhat.com>
References: <cover.1537936397.git.helen.koike@collabora.com>
 <CAFLxGvzCDOTR4stPmp1TTLkQ39x3e8MQuL=AR754abKc5skhpA@mail.gmail.com>
 <20180927142328.GA4074@redhat.com>
 <CAGXu5j+Y5e_oTZVCAHa48XgVcvEKGnVW_74oXZOUyLnfYPAjAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+Y5e_oTZVCAHa48XgVcvEKGnVW_74oXZOUyLnfYPAjAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Richard Weinberger <richard.weinberger@gmail.com>, helen.koike@collabora.com, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Will Drewry <wad@chromium.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-lvm@redhat.com, kernel@collabora.com
List-Id: dm-devel.ids

On Thu, Sep 27 2018 at 12:36pm -0400,
Kees Cook <keescook@chromium.org> wrote:

> On Thu, Sep 27, 2018 at 7:23 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> > On Wed, Sep 26 2018 at  3:16am -0400,
> > Richard Weinberger <richard.weinberger@gmail.com> wrote:
> >
> >> Helen,
> >>
> >> On Wed, Sep 26, 2018 at 7:01 AM Helen Koike <helen.koike@collabora.com> wrote:
> >> >
> >> > This series is reviving an old patchwork.
> >> > Booting from a mapped device requires an initramfs. This series is
> >> > allows for device-mapper targets to be configured at boot time for
> >> > use early in the boot process (as the root device or otherwise).
> >>
> >> What is the reason for this patch series?
> >> Setting up non-trivial root filesystems/storage always requires an
> >> initramfs, there is nothing
> >> wrong about this.
> >
> > Exactly.  If phones or whatever would benefit from this patchset then
> > say as much.
> 
> I think some of the context for the series was lost in commit logs,
> but yes, both Android and Chrome OS do not use initramfs. The only
> thing that was needed to do this was being able to configure dm
> devices on the kernel command line, so the overhead of a full
> initramfs was seen as a boot time liability, a boot image size
> liability (e.g. Chrome OS has a limited amount of storage available
> for the boot image that is covered by the static root of trust
> signature), and a complexity risk: everything that is needed for boot
> could be specified on the kernel command line, so better to avoid the
> whole initramfs dance.
> 
> So, instead, this plumbs the dm commands directly instead of bringing
> up a full userspace and performing ioctls.
> 
> > I will not accept this patchset at this time.
> >
> >> > Example, the following could be added in the boot parameters.
> >> > dm="lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" root=/dev/dm-0
> >>
> >> Hmmm, the new dm= parameter is anything but easy to get right.
> >
> > No, it isn't.. exposes way too much potential for users hanging
> > themselves.
> 
> IIRC, the changes in syntax were suggested back when I was trying to
> drive this series:
> https://www.redhat.com/archives/dm-devel/2016-February/msg00199.html
> 
> And it matches the "concise" format in dmsetup:
> https://sourceware.org/git/?p=lvm2.git;a=commit;h=827be01758ec5adb7b9d5ea75b658092adc65534
> 
> What do you feel are next steps?

There is quite a lot of init/ code, to handle parsing the concise DM
format, that is being proposed for inclusion.  I question why that
DM-specific code would be located in init/

There also needs to be a careful comparison done between the proposed
init/ code to support consise DM format and the userspace lvm2
equivalent (e.g. lvm2.git commit 827be0175)

That aside, the DM targets that are allowed to be supported by this dm=
commandline boot interface must be constrained (there are serious risks
in allowing activation of certain DM targets without first using
userspace tools to check the validity of associated metadata, as is done
by the DM thin and cache targets).  Also, all targets supported must be
upstream.  "linear", "verity" and "bootcache" DM targets are referenced
in Documentation, "bootcache" must be a Google target.  I'm not aware of
it.

Mike
