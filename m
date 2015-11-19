From: Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Thu, 19 Nov 2015 18:19:10 +0200
Message-ID: <CAE1zot+G=SohXzuV6Gs7APdCo5pu9xLwE38kZKNUuWRnSh++BA@mail.gmail.com>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
	<20151117170556.GV22011@ZenIV.linux.org.uk>
	<20151117172551.GA108807@ubuntu-hedt>
	<20151117175506.GW22011@ZenIV.linux.org.uk>
	<20151117183444.GB108807@ubuntu-hedt>
	<CAFLxGvx1UqJOhM3wqAGqT+TrkapeP1zkmg0a1K=DjySePx4mEA@mail.gmail.com>
	<20151117192141.GD108807@ubuntu-hedt>
	<CAE1zotLNq1v_ZegT9LyFsTiHWQnOAow+KKQFFvOYKUyRWPjfGA@mail.gmail.com>
	<564B8A20.9090607@nod.at>
	<CAE1zotJRp3=G2Vdud7kVbkToKe2YsTF3gXUnLCNzKV6F0oumdg@mail.gmail.com>
	<20151119152347.GA45540@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20151119152347.GA45540@ubuntu-hedt>
Sender: linux-bcache-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Thu, Nov 19, 2015 at 5:23 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Wed, Nov 18, 2015 at 12:00:17AM +0200, Octavian Purdila wrote:
>> On Tue, Nov 17, 2015 at 10:12 PM, Richard Weinberger <richard@nod.at> wrote:
>> > Am 17.11.2015 um 20:25 schrieb Octavian Purdila:
>> >> On Tue, Nov 17, 2015 at 9:21 PM, Seth Forshee
>> >> <seth.forshee@canonical.com> wrote:
>> >>>
>> >>> On Tue, Nov 17, 2015 at 08:12:31PM +0100, Richard Weinberger wrote:
>> >>>> On Tue, Nov 17, 2015 at 7:34 PM, Seth Forshee
>> >>>> <seth.forshee@canonical.com> wrote:
>> >>>>> On Tue, Nov 17, 2015 at 05:55:06PM +0000, Al Viro wrote:
>> >>>>>> On Tue, Nov 17, 2015 at 11:25:51AM -0600, Seth Forshee wrote:
>> >>>>>>
>> >>>>>>> Shortly after that I plan to follow with support for ext4. I've been
>> >>>>>>> fuzzing ext4 for a while now and it has held up well, and I'm currently
>> >>>>>>> working on hand-crafted attacks. Ted has commented privately (to others,
>> >>>>>>> not to me personally) that he will fix bugs for such attacks, though I
>> >>>>>>> haven't seen any public comments to that effect.
>> >>>>>>
>> >>>>>> _Static_ attacks, or change-image-under-mounted-fs attacks?
>> >>>>>
>> >>>>> Right now only static attacks, change-image-under-mounted-fs attacks
>> >>>>> will be next.
>> >>>>
>> >>>> Do we *really* need to enable unprivileged mounting of kernel filesystems?
>> >>>> What about just enabling fuse and implement ext4 and friends as fuse
>> >>>> filesystems?
>> >>>> Using the approaching Linux Kernel Libary[1] this is easy.
>> >>>
>> >>> I haven't looked at this project, but I'm guessing that programs must be
>> >>> written specifically to make use of it? I.e. you can't just use the
>> >>> mount syscall, and thus all existing software still doesn't work?
>> >>>
>> >>
>> >> The projects includes a lklfuse program that uses fuse to mount a
>> >> fileystem image.
>> >
>> > Cool. I gave it a try.
>> > It seems to work fine, but only if I run it in foreground (using -d)
>> > otherwise fuse blocks every filesystem request.
>> >
>>
>> Now it should work in the background as well, thanks for reporting the issue.
>

Hi Seth,

> I'm playing with lklfuse now, it's surprisingly easy to get up and
> running. I did have a few problems though that I thought you'd like to
> know about.
>

Great, thanks for giving it a try and reporting the issues.

> Unfortunately I still can't run it in background mode, I get a segfault.

I got it to reproduce as well now. Not sure why how it worked before,
probably a race condition between lkl initialization and fuse calls.

> It's working fine on light workloads, but I'm having issues when I start
> trying to stress it. In a couple runs of the stress-ng filesystem
> stressors I saw both stress-ng and lklfuse get stuck in uninterruptible
> sleep during the first run, and during the second I got some OOM errors
> in lklfuse followed by I/O errors and eventually a journal error that
> cause the filesystem to go read-only.
>
> The command I used for the first run was:
>
>  stress-ng --class filesystem --all 0
>

I will reproduce it and take a look.

> And for the second:
>
>  stress-ng --class filesystem --seq 0 -v -t 60
>
> There really wasn't anything interesting in the lklfuse output for the
> first run, but for the second run I pasted the output here:
> http://paste.ubuntu.com/13346993/

lklfuse allocates a fixed 100MB to the kernel and this is probably not
enough. For the short term I can add a parameter to lklfuse that
allows the user to specify the amount of memory to allocate to lkl. A
better fix would probably be to dynamically adjust the memory size of
lkl. I am thinking of using the ballon virtio driver or the memory
hotplug infrastructure. Any other suggestions?

I created a couple of issues in github [1] that you can track if you
want - I want to avoid spamming the list with reporting progress on
them.

[1] https://github.com/lkl/linux/issues
