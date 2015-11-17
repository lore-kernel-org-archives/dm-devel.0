From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Tue, 17 Nov 2015 20:12:31 +0100
Message-ID: <CAFLxGvx1UqJOhM3wqAGqT+TrkapeP1zkmg0a1K=DjySePx4mEA@mail.gmail.com>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
	<20151117170556.GV22011@ZenIV.linux.org.uk>
	<20151117172551.GA108807@ubuntu-hedt>
	<20151117175506.GW22011@ZenIV.linux.org.uk>
	<20151117183444.GB108807@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20151117183444.GB108807@ubuntu-hedt>
Sender: linux-bcache-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Octavian Purdila <octavian.purdila@intel.com>
List-Id: dm-devel.ids

On Tue, Nov 17, 2015 at 7:34 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Tue, Nov 17, 2015 at 05:55:06PM +0000, Al Viro wrote:
>> On Tue, Nov 17, 2015 at 11:25:51AM -0600, Seth Forshee wrote:
>>
>> > Shortly after that I plan to follow with support for ext4. I've been
>> > fuzzing ext4 for a while now and it has held up well, and I'm currently
>> > working on hand-crafted attacks. Ted has commented privately (to others,
>> > not to me personally) that he will fix bugs for such attacks, though I
>> > haven't seen any public comments to that effect.
>>
>> _Static_ attacks, or change-image-under-mounted-fs attacks?
>
> Right now only static attacks, change-image-under-mounted-fs attacks
> will be next.

Do we *really* need to enable unprivileged mounting of kernel filesystems?
What about just enabling fuse and implement ext4 and friends as fuse
filesystems?
Using the approaching Linux Kernel Libary[1] this is easy.

[1] https://lkml.org/lkml/2015/11/3/706
-- 
Thanks,
//richard
