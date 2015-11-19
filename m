From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Thu, 19 Nov 2015 15:49:00 +0100
Message-ID: <564DE15C.3050207@nod.at>
References: <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk> <564B79B1.3040207@gmail.com>
 <20151117191606.GC108807@ubuntu-hedt> <564B941A.2070601@gmail.com>
 <20151117213255.GE108807@ubuntu-hedt> <564C6DD4.6090308@gmail.com>
 <20151118142238.GB134139@ubuntu-hedt>
 <20151118145818.GC22011@ZenIV.linux.org.uk>
 <20151118150512.GE134139@ubuntu-hedt>
 <20151118151335.GD22011@ZenIV.linux.org.uk>
 <CAFLxGvwwhXqVM71m1kEDTZk_YTKGtbJ3gWoXw3wRgcwDiC38Bg@mail.gmail.com>
 <alpine.LRH.2.20.1511191845510.10804@namei.org> <564D7FF6.50408@nod.at>
 <1447943873.2240617.444348369.7F817E6C@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1447943873.2240617.444348369.7F817E6C@webmail.messagingengine.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Colin Walters <walters@verbum.org>, James Morris <jmorris@namei.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Seth Forshee <seth.forshee@canonical.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, "Richard W.M. Jones" <rjones@redhat.com>
List-Id: dm-devel.ids

Am 19.11.2015 um 15:37 schrieb Colin Walters:
> On Thu, Nov 19, 2015, at 02:53 AM, Richard Weinberger wrote:
> 
>> Erm, I don't want this in the kernel. That's why I've proposed the lklfuse approach.
> 
> I already said this before but just to repeat, since I'm confused:
> 
> How would "lklfuse" be different from http://libguestfs.org/
> which we at Red Hat (and a number of other organizations)
> use quite widely now for build systems, debugging etc.

Currently libguestfs has a rather huge overhead because it
boots a full virtual machine and hence a lot of communication
is needed.
With LKL you can use Linux as Library and link it to fuse.
AFAIK Richard added already a LKL backend to libguestfs. :-)

> In the end it's just running the kernel in KVM with a custom protocol,
> with support for non-filesystem things like "install a bootloader",
> and it already supports FUSE.
> 
> I'm pretty firmly with Al here - the attack surface increase here
> is too great, and we'd likely turn this off if it even did make it
> into the kernel.

Agreed. This is why I'm promoting the fuse solution.

Thanks,
//richard
