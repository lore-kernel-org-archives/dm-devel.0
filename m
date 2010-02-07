From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: compat_ioctl: ignore RAID_VERSION ioctl
Date: Sun, 7 Feb 2010 11:03:37 +0100
Message-ID: <201002071103.37276.rjw@sisk.pl>
References: <20100130205353.GA3168@redhat.com> <201001302302.10574.arnd@arndb.de> <20100207092407.GA19684@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100207092407.GA19684@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, neilb@suse.de, linux-raid@vger.kernel.org, dm-devel@redhat.com, maan@systemlinux.org
List-Id: dm-devel.ids

On Sunday 07 February 2010, Michael S. Tsirkin wrote:
> On Sat, Jan 30, 2010 at 11:02:10PM +0100, Arnd Bergmann wrote:
> > md ioctls are now handled by the md driver itself, but mdadm
> > may call RAID_VERSION on other devices as well. Mark the command
> > as IGNORE_IOCTL so this fails silently rather than printing
> > an annoying message.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> The patch does not seem to be there in -rc7.
> Since this is fixes a regression, should this go into 2.6.33?

I guess it should.

Do you have a link to the original report or has it been sent privately?

Rafael
