From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Thu, 19 Nov 2015 15:17:33 +0000
Message-ID: <20151119151733.GV29330@redhat.com>
References: <564C6DD4.6090308@gmail.com>
 <20151118142238.GB134139@ubuntu-hedt>
 <20151118145818.GC22011@ZenIV.linux.org.uk>
 <20151118150512.GE134139@ubuntu-hedt>
 <20151118151335.GD22011@ZenIV.linux.org.uk>
 <CAFLxGvwwhXqVM71m1kEDTZk_YTKGtbJ3gWoXw3wRgcwDiC38Bg@mail.gmail.com>
 <alpine.LRH.2.20.1511191845510.10804@namei.org>
 <564D7FF6.50408@nod.at>
 <1447943873.2240617.444348369.7F817E6C@webmail.messagingengine.com>
 <564DE15C.3050207@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564DE15C.3050207@nod.at>
Sender: linux-bcache-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: Colin Walters <walters@verbum.org>, James Morris <jmorris@namei.org>, Al Viro <viro@zeniv.linux.org.uk>, Seth Forshee <seth.forshee@canonical.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Thu, Nov 19, 2015 at 03:49:00PM +0100, Richard Weinberger wrote:
> Am 19.11.2015 um 15:37 schrieb Colin Walters:
> > On Thu, Nov 19, 2015, at 02:53 AM, Richard Weinberger wrote:
> > 
> >> Erm, I don't want this in the kernel. That's why I've proposed the lklfuse approach.
> > 
> > I already said this before but just to repeat, since I'm confused:
> > 
> > How would "lklfuse" be different from http://libguestfs.org/
> > which we at Red Hat (and a number of other organizations)
> > use quite widely now for build systems, debugging etc.
> 
> Currently libguestfs has a rather huge overhead because it
> boots a full virtual machine and hence a lot of communication
> is needed.
> With LKL you can use Linux as Library and link it to fuse.
> AFAIK Richard added already a LKL backend to libguestfs. :-)

Right.  For the longer story, see:

https://rwmj.wordpress.com/2015/11/07/linux-kernel-library-backend-for-libguestfs/#content

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
