From: Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCH 0/2] boot to a mapped device
Date: Fri, 19 Oct 2018 13:27:55 -0300
Message-ID: <90071912-047f-fb7b-3372-32cca9f2de06@collabora.com>
References: <cover.1537936397.git.helen.koike@collabora.com>
 <CAFLxGvzCDOTR4stPmp1TTLkQ39x3e8MQuL=AR754abKc5skhpA@mail.gmail.com>
 <20180927142328.GA4074@redhat.com>
 <CAGXu5j+Y5e_oTZVCAHa48XgVcvEKGnVW_74oXZOUyLnfYPAjAg@mail.gmail.com>
 <20180927183141.GA4921@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927183141.GA4921@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Kees Cook <keescook@chromium.org>
Cc: Richard Weinberger <richard.weinberger@gmail.com>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Will Drewry <wad@chromium.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-lvm@redhat.com, kernel@collabora.com
List-Id: dm-devel.ids

Hi all,

Sorry the delay of my reply.

On 9/27/18 3:31 PM, Mike Snitzer wrote:
> On Thu, Sep 27 2018 at 12:36pm -0400,
> Kees Cook <keescook@chromium.org> wrote:
> 
>> On Thu, Sep 27, 2018 at 7:23 AM, Mike Snitzer <snitzer@redhat.com> wrote:
>>> On Wed, Sep 26 2018 at  3:16am -0400,
>>> Richard Weinberger <richard.weinberger@gmail.com> wrote:
>>>
>>>> Helen,
>>>>
>>>> On Wed, Sep 26, 2018 at 7:01 AM Helen Koike <helen.koike@collabora.com> wrote:
>>>>>
>>>>> This series is reviving an old patchwork.
>>>>> Booting from a mapped device requires an initramfs. This series is
>>>>> allows for device-mapper targets to be configured at boot time for
>>>>> use early in the boot process (as the root device or otherwise).
>>>>
>>>> What is the reason for this patch series?
>>>> Setting up non-trivial root filesystems/storage always requires an
>>>> initramfs, there is nothing
>>>> wrong about this.
>>>
>>> Exactly.  If phones or whatever would benefit from this patchset then
>>> say as much.
>>
>> I think some of the context for the series was lost in commit logs,
>> but yes, both Android and Chrome OS do not use initramfs. The only
>> thing that was needed to do this was being able to configure dm
>> devices on the kernel command line, so the overhead of a full
>> initramfs was seen as a boot time liability, a boot image size
>> liability (e.g. Chrome OS has a limited amount of storage available
>> for the boot image that is covered by the static root of trust
>> signature), and a complexity risk: everything that is needed for boot
>> could be specified on the kernel command line, so better to avoid the
>> whole initramfs dance.
>>
>> So, instead, this plumbs the dm commands directly instead of bringing
>> up a full userspace and performing ioctls.

Sorry about the missing context, I should've added the change log and
worked a bit more in the cover letter with a more verbose explanation on
the reasons for this patch.

Just for reference (I'll describe better the changes in the next version):

v5: https://www.redhat.com/archives/dm-devel/2016-February/msg00112.html
v6: https://www.redhat.com/archives/dm-devel/2017-April/msg00316.html
v7: http://lkml.iu.edu/hypermail/linux/kernel/1705.2/02657.html
v8: https://www.redhat.com/archives/linux-lvm/2017-May/msg00055.html

>>
>>> I will not accept this patchset at this time.
>>>
>>>>> Example, the following could be added in the boot parameters.
>>>>> dm="lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" root=/dev/dm-0
>>>>
>>>> Hmmm, the new dm= parameter is anything but easy to get right.
>>>
>>> No, it isn't.. exposes way too much potential for users hanging
>>> themselves.
>>
>> IIRC, the changes in syntax were suggested back when I was trying to
>> drive this series:
>> https://www.redhat.com/archives/dm-devel/2016-February/msg00199.html
>>
>> And it matches the "concise" format in dmsetup:
>> https://sourceware.org/git/?p=lvm2.git;a=commit;h=827be01758ec5adb7b9d5ea75b658092adc65534

Exactly, this is the "concise" format from dmsetup, it also makes it
easier for users to copy and paste from "dmsetup --concise", which
doesn't mean this format is ideal, but imho keeping it consistent with
dmsetup is a good thing, please let me know if you have any other ideas.

>>
>> What do you feel are next steps?
> 
> There is quite a lot of init/ code, to handle parsing the concise DM
> format, that is being proposed for inclusion.  I question why that
> DM-specific code would be located in init/

The main reason was that, taking "md=" and "raid=" as a reference, its
command line arguments are parsed in init/do_mounts_md.c, I could move
the parsing logic to drivers/md/* but I was wondering if it wouldn't be
better to be consistent with init/do_mounts_md.c, what do you think?

> 
> There also needs to be a careful comparison done between the proposed
> init/ code to support consise DM format and the userspace lvm2
> equivalent (e.g. lvm2.git commit 827be0175)

Yes, I am taking a deeper look into the lvm2 parsing code, and actually
we can use almost the same logic for parsing, which seems better because
lvm2 is already using it, we already have some validation/review and it
also seems cleaner.
I'll update this in the next version.

> 
> That aside, the DM targets that are allowed to be supported by this dm=
> commandline boot interface must be constrained (there are serious risks
> in allowing activation of certain DM targets without first using
> userspace tools to check the validity of associated metadata, as is done
> by the DM thin and cache targets).  Also, all targets supported must be
> upstream.  "linear", "verity" and "bootcache" DM targets are referenced
> in Documentation, "bootcache" must be a Google target.  I'm not aware of
> it.
> 
> Mike
> 

I see, I can add this constraint and I'll clean up the documentation for
the next version.


Thank you all for your comments and reviews, I am working on the next
version of this patch series taking yours comments into consideration
and cleaning up several parts of the code and documentation.

Please let me know if you have any other concerns.

Thanks
Helen
