From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not mutex
Date: Thu, 9 Nov 2006 16:52:33 +0100
Message-ID: <200611091652.34649.rjw@sisk.pl>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <200611081310.19100.rjw@sisk.pl> <20061108180921.GA7708@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1424081AbWKIPy6@vger.kernel.org>
In-Reply-To: <20061108180921.GA7708@ucw.cz>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Alasdair G Kergon <agk@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Nigel Cunningham <nigel@suspend2.net>, David Chinner <dgc@sgi.com>
List-Id: dm-devel.ids

Hi,

On Wednesday, 8 November 2006 19:09, Pavel Machek wrote:
> Hi!
> 
> > > swsusp-freeze-filesystems-during-suspend-rev-2.patch
> > > 
> > > I think you need to give more thought to device-mapper
> > > interactions here.  If an underlying device is suspended
> > > by device-mapper without freezing the filesystem (the
> > > normal state) and you issue a freeze_bdev on a device
> > > above it, the freeze_bdev may never return if it attempts
> > > any synchronous I/O (as it should).
> > 
> > Well, it looks like the interactions with dm add quite a bit of
> > complexity here.
> 
> What about just fixing xfs (thou shall not write to disk when kernel
> threads are frozen), and getting rid of blockdev freezing?

Well, first I must admit you were absolutely right being suspicious with
respect to this stuff.

OTOH I have no idea _how_ we can tell xfs that the processes have been
frozen.  Should we introduce a global flag for that or something?

Rafael


-- 
You never change things by fighting the existing reality.
		R. Buckminster Fuller
