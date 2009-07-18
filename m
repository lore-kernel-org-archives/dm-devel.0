From: Andreas Dilger <adilger@sun.com>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Date: Sat, 18 Jul 2009 10:32:19 -0400
Message-ID: <20090718143219.GL4231@webber.adilger.int>
References: <19041.4714.686158.130252@notabene.brown>
 <20090718043155.GI4231@webber.adilger.int> <871voewm6y.fsf@basil.nowhere.org>
 <20090718065213.GK4231@webber.adilger.int>
 <20090718074811.GA2682@basil.fritz.box> <20090718134946.GA25546@mit.edu>
 <20090718142156.GC2682@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-disposition: inline
In-reply-to: <20090718142156.GC2682@basil.fritz.box>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Theodore Tso <tytso@mit.edu>, device-mapper development <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Jul 18, 2009  16:21 +0200, Andi Kleen wrote:
> > We don't have to rewrite fsck; most of the framework for supporting an
> > run-length-conding for compressed bitmaps is already in patches that
> > add > 32-bit block numbers to e2fsprogs; we've just been more focused
> > on getting 64-bit block numbers support merged than implementing
> > compressed bitmaps, but it's only one file that would need to be
> > added, and we might be able to steal the compressed bitmap support
> > from xfsprogs --- which does this already.
> 
> There are regular reports of xfs_repair failing on 32bit,
> even on volumes far smaller than 16TB.

It's a good thing we have ext4 then :-).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

