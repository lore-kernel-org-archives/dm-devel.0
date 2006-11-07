From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not mutex
Date: Wed, 8 Nov 2006 00:05:49 +0100
Message-ID: <200611080005.50070.rjw@sisk.pl>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <20061107122837.54828e24.akpm@osdl.org> <45510C73.7060408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753810AbWKGXIM@vger.kernel.org>
In-Reply-To: <45510C73.7060408@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Ingo Molnar <mingo@elte.hu>, Srinivasa DS <srinivasa@in.ibm.com>
List-Id: dm-devel.ids

On Tuesday, 7 November 2006 23:45, Eric Sandeen wrote:
> Andrew Morton wrote:
> 
> >> --- linux-2.6.19-rc4.orig/fs/buffer.c	2006-11-07 17:06:20.000000000 +0000
> >> +++ linux-2.6.19-rc4/fs/buffer.c	2006-11-07 17:26:04.000000000 +0000
> >> @@ -188,7 +188,9 @@ struct super_block *freeze_bdev(struct b
> >>  {
> >>  	struct super_block *sb;
> >>  
> >> -	mutex_lock(&bdev->bd_mount_mutex);
> >> +	if (down_trylock(&bdev->bd_mount_sem))
> >> +		return -EBUSY;
> >> +
> > 
> > This is a functional change which isn't described in the changelog.  What's
> > happening here?
> 
> Only allow one bdev-freezer in at a time, rather than queueing them up?

But freeze_bdev() is supposed to return the result of get_super(bdev)
_unconditionally_.  Moreover, in its current form freeze_bdev() _cannot_
_fail_, so I don't see how this change doesn't break any existing code.

For example freeze_filesystems() (recently added to -mm) will be broken
if the down_trylock() is unsuccessful.

Greetings,
Rafael


-- 
You never change things by fighting the existing reality.
		R. Buckminster Fuller
