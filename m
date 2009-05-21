From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that checks
	data integrity
Date: Thu, 21 May 2009 16:17:04 -0300
Message-ID: <20090521191704.GX1376@blitiri.com.ar>
References: <20090521161317.GU1376@blitiri.com.ar> <87f94c370905211117y13758f72i2ea113c9c6771061@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87f94c370905211117y13758f72i2ea113c9c6771061@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

On Thu, May 21, 2009 at 02:17:58PM -0400, Greg Freemyer wrote:
> On Thu, May 21, 2009 at 12:13 PM, Alberto Bertogli
> <albertito@blitiri.com.ar> wrote:
> > I'm writing this device mapper target that stores checksums on writes and
> > verifies them on reads.
> 
> I have not looked at your patch, but does this tie into the integrity
> logic that was added to mainline a few months ago?

At the moment it has no relation, but making dm-csum devices register with the
bio integrity extensions is on my to-do list, and the on-disk format already
reserves 32 bits for every 512-byte sector for tagging purposes.

Thanks,
		Alberto

