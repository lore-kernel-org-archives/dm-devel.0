From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
Date: Thu, 26 Mar 2009 08:55:34 -0400
Message-ID: <1238072134.5676.12.camel@think.oraclecorp.com>
References: <49C7DD3C.2020401@redhat.com>
	 <Pine.LNX.4.64.0903241000010.29968@hs20-bc2-1.build.redhat.com>
	 <20090324140524.GV27476@kernel.dk>
	 <Pine.LNX.4.64.0903241010490.29968@hs20-bc2-1.build.redhat.com>
	 <20090324143034.GW27476@kernel.dk>
	 <Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com>
	 <20090324150517.GX27476@kernel.dk>
	 <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
	 <20090325152751.GV27476@kernel.dk>
	 <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756895AbZCZM4U@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
List-Id: dm-devel.ids

On Wed, 2009-03-25 at 18:39 -0400, Mikulas Patocka wrote:

> > The error handling is complex, no doubt
> > about that. But the trial barrier test is pretty trivial and even could
> > be easily abstracted out. If a later barrier write fails, then that's
> > really no different than if a normal write fails. Error handling is not
> > easy in that case.
> 
> I had a discussion with Andi about it some times ago. The conclusion was 
> that all the current filesystems handle barriers failing in the middle of 
> the operation without functionality loss, but it makes barriers useless 
> for any performance-sensitive tasks (commits that wouldn't block 
> concurrent activity). Non-blocking commits could only be implemented if 
> barriers don't fail.
> 

If a barrier fails at runtime, the filesystems do fall back to not doing
barriers without real problems.  But, that's because they don't actually
rely on the barriers to decide if an async commit is a good idea.

One exception is reiserfs, which does one wait_on_buffer at a later time
if barriers are on.  But, this isn't an async commit, this is just
moving an unplug.

In general, async commits happen with threads and they aren't related to
barriers.  Barriers don't really give us error handling, and they are at
the very end of a long chain of technical problems around commits that
don't block concurrent activity.

-chris
