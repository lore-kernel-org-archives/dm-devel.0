From: Joe Thornber <thornber@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/2] dmcache: Implement a flush message
Date: Fri, 10 May 2013 11:22:24 +0100
Message-ID: <20130510102224.GF20880@debian>
References: <20130508214845.GA7729@blackbox.djwong.org>
 <20130508220526.GA24132@redhat.com>
 <20130509203616.GA5713@blackbox.djwong.org>
 <20130509204751.GB5712@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130509204751.GB5712@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, May 09, 2013 at 01:47:51PM -0700, Darrick J. Wong wrote:
> Create a new 'flush' message that causes the dmcache to write all of its
> metadata out to disk.  This enables us to ensure that the disk reflects
> whatever's in memory without having to tear down the cache device.  This helps
> me in the case where I have a cached ro fs that I can't umount and therefore
> can't tear down the cache device, but want to save the cache metadata anyway.
> The command syntax is as follows:
> 
> # dmsetup message mycache 0 flush now

Nack.

[Ignoring the ugly 'now' parameter.]

I think you're in danger of hiding the real issue.  Which is if the
target's destructor and post suspend is not being called then, as far
as dm-cache is concerned this is a crash.  Any open transactions will
be lost as it automatically rolls back.

We need to understand more why this is happening.  It's actually
harmless atm for dm-cache, because we're forced to commit before using
a new migration.  But for dm-thin you can lose writes.  Why are you
never tearing down your dm devices?

- Joe
