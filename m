From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Thu, 19 Nov 2015 09:23:47 -0600
Message-ID: <20151119152347.GA45540@ubuntu-hedt>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE1zotJRp3=G2Vdud7kVbkToKe2YsTF3gXUnLCNzKV6F0oumdg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Wed, Nov 18, 2015 at 12:00:17AM +0200, Octavian Purdila wrote:
> On Tue, Nov 17, 2015 at 10:12 PM, Richard Weinberger <richard@nod.at> wrote:
> > Am 17.11.2015 um 20:25 schrieb Octavian Purdila:
> >> On Tue, Nov 17, 2015 at 9:21 PM, Seth Forshee
> >> <seth.forshee@canonical.com> wrote:
> >>>
> >>> On Tue, Nov 17, 2015 at 08:12:31PM +0100, Richard Weinberger wrote:
> >>>> On Tue, Nov 17, 2015 at 7:34 PM, Seth Forshee
> >>>> <seth.forshee@canonical.com> wrote:
> >>>>> On Tue, Nov 17, 2015 at 05:55:06PM +0000, Al Viro wrote:
> >>>>>> On Tue, Nov 17, 2015 at 11:25:51AM -0600, Seth Forshee wrote:
> >>>>>>
> >>>>>>> Shortly after that I plan to follow with support for ext4. I've been
> >>>>>>> fuzzing ext4 for a while now and it has held up well, and I'm currently
> >>>>>>> working on hand-crafted attacks. Ted has commented privately (to others,
> >>>>>>> not to me personally) that he will fix bugs for such attacks, though I
> >>>>>>> haven't seen any public comments to that effect.
> >>>>>>
> >>>>>> _Static_ attacks, or change-image-under-mounted-fs attacks?
> >>>>>
> >>>>> Right now only static attacks, change-image-under-mounted-fs attacks
> >>>>> will be next.
> >>>>
> >>>> Do we *really* need to enable unprivileged mounting of kernel filesystems?
> >>>> What about just enabling fuse and implement ext4 and friends as fuse
> >>>> filesystems?
> >>>> Using the approaching Linux Kernel Libary[1] this is easy.
> >>>
> >>> I haven't looked at this project, but I'm guessing that programs must be
> >>> written specifically to make use of it? I.e. you can't just use the
> >>> mount syscall, and thus all existing software still doesn't work?
> >>>
> >>
> >> The projects includes a lklfuse program that uses fuse to mount a
> >> fileystem image.
> >
> > Cool. I gave it a try.
> > It seems to work fine, but only if I run it in foreground (using -d)
> > otherwise fuse blocks every filesystem request.
> >
> 
> Now it should work in the background as well, thanks for reporting the issue.

I'm playing with lklfuse now, it's surprisingly easy to get up and
running. I did have a few problems though that I thought you'd like to
know about.

Unfortunately I still can't run it in background mode, I get a segfault.

It's working fine on light workloads, but I'm having issues when I start
trying to stress it. In a couple runs of the stress-ng filesystem
stressors I saw both stress-ng and lklfuse get stuck in uninterruptible
sleep during the first run, and during the second I got some OOM errors
in lklfuse followed by I/O errors and eventually a journal error that
cause the filesystem to go read-only.

The command I used for the first run was:

 stress-ng --class filesystem --all 0

And for the second:

 stress-ng --class filesystem --seq 0 -v -t 60

There really wasn't anything interesting in the lklfuse output for the
first run, but for the second run I pasted the output here:
http://paste.ubuntu.com/13346993/

I still need to compare this to other fuse filesystems since I haven't
tried this kind of stress test on any others.
