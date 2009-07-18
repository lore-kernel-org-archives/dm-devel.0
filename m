From: Theodore Tso <tytso@mit.edu>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Date: Sat, 18 Jul 2009 09:49:46 -0400
Message-ID: <20090718134946.GA25546@mit.edu>
References: <19041.4714.686158.130252@notabene.brown> <20090718043155.GI4231@webber.adilger.int> <871voewm6y.fsf@basil.nowhere.org> <20090718065213.GK4231@webber.adilger.int> <20090718074811.GA2682@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752038AbZGRNuF@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090718074811.GA2682@basil.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Dilger <adilger@sun.com>, device-mapper development <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Jul 18, 2009 at 09:48:11AM +0200, Andi Kleen wrote:
> 
> > Also, for filesystems like btrfs or ZFS the checking can be done
> > online and incrementally without storing a full representation of
> > the state in memory.
> 
> You could, but I suspect it would be cheaper to just use a
> 64bit system than to rewrite fsck. 64bit is available
> for a lot of embedded setups these days too.

We don't have to rewrite fsck; most of the framework for supporting an
run-length-conding for compressed bitmaps is already in patches that
add > 32-bit block numbers to e2fsprogs; we've just been more focused
on getting 64-bit block numbers support merged than implementing
compressed bitmaps, but it's only one file that would need to be
added, and we might be able to steal the compressed bitmap support
from xfsprogs --- which does this already.

						- Ted
