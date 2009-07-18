From: Andi Kleen <andi@firstfloor.org>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Date: Sat, 18 Jul 2009 08:16:05 +0200
Message-ID: <871voewm6y.fsf@basil.nowhere.org>
References: <19041.4714.686158.130252@notabene.brown>
	<20090718043155.GI4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090718043155.GI4231@webber.adilger.int> (Andreas Dilger's message of "Sat, 18 Jul 2009 00:31:55 -0400")
Sender: linux-fsdevel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Andreas Dilger <adilger@sun.com> writes:
>
> I think the point is that for those people who want to use > 16TB
> devices on 32-bit platforms (e.g. embedded/appliance systems) the
> choice is between "completely non-functional" and "uses a bit more
> memory per page", and the answer is pretty obvious.

It's not just more memory per page, but also worse code all over the
VM. long long 32bit code is generally rather bad, especially on
register constrained x86.

But I think the fsck problem is a show stopper here anyways.
Enabling a setup that cannot handle IO errors wouldn't 
be really a good idea.

In fact this problem already hits before 16TB on 32bit.

Unless people rewrite fsck to use /dev/shm >4GB swapping
(or perhaps use JFS which iirc had a way to use the file system
itself as fsck scratch space)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
