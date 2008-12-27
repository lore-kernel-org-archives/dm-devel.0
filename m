From: Andreas Dilger <adilger@sun.com>
Subject: Re: jbd2 inside a device mapper module
Date: Sat, 27 Dec 2008 13:01:27 -0700
Message-ID: <20081227200127.GX5000@webber.adilger.int>
References: <20081224211038.GT4127@blitiri.com.ar>
 <20081224234915.GA23723@mit.edu> <20081225143535.GA4127@blitiri.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ext4-owner@vger.kernel.org>
In-reply-to: <20081225143535.GA4127@blitiri.com.ar>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
To: Alberto Bertogli <albertito@blitiri.com.ar>, Alex Zhuravlev <Alex.Zhuravlev@sun.com>
Cc: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Dec 25, 2008  12:35 -0200, Alberto Bertogli wrote:
> On Wed, Dec 24, 2008 at 06:49:15PM -0500, Theodore Tso wrote:
> > I have no idea why you would need to do manual __breads().  No doubt
> > I'm missing some context here.   
> 
> I'm writing (just for fun and learning purposes) a device mapper module
> that stores checksums on writes and verifies them on reads. The
> integrity metadata (currently just the checksum) is interleaved in the
> backing device: one sector holding the integrity metadata for the
> following 64 data sectors.

Alex and I discussed implementing checksums for ext4 using an external
device like this, and he might have some more design information for
you.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

