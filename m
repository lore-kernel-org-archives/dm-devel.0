From: Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Date: Fri, 14 Jan 2011 17:20:22 +0100
Message-ID: <20110114162022.GC978@htj.dyndns.org>
References: <20110113131216.GF30719@htj.dyndns.org>
 <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org>
 <4D2F04FF.1070309@redhat.com>
 <20110113141107.GI30719@htj.dyndns.org>
 <4D2F0B6A.6010201@redhat.com>
 <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
 <656A2F9B-4E1C-44AA-80CB-9E3428E26CDE@mit.edu>
 <20110114071858.7eee145c@notabene.brown>
 <20110113204145.GC31800@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110113204145.GC31800@thunk.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>, NeilBrown <neilb@suse.de>, Milan Broz <mbroz@redhat.com>, Karel Zak <kzak@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-no>
List-Id: dm-devel.ids

Hello, Ted, Neil.

On Thu, Jan 13, 2011 at 03:41:45PM -0500, Ted Ts'o wrote:
> On Fri, Jan 14, 2011 at 07:18:58AM +1100, NeilBrown wrote:
> > 
> > open(O_EXCL) will fail on a block device if it is being used by anything else
> > - a filesystem or a dm target or an md array or ....
> > 
> > So if the *only* thing you want is "is this currently an active part of
> > something else", then O_EXCL works since 2.6.0 (I think).
> 
> Unfortunately, that won't distinguish between a currently active file
> system, and a device which is being used by a dm target, which is what
> we want to do.

Hmmm... that's already possible with the existing holders symlinks,
right?  As Kay said in another message, I don't think we can do
anything about the symlinks at this point.  It already has userland
users, so we'll have to maintain them and there's no reason to create
something else for the same functionality.

It's silly that there's no way to tell whether the device is mounted
from a given block device but then again we've been working around it
by reverse mapping it till now so unless there's a new requirement
maybe it's okay as it is now.

Ideally, it would have been nice and more fitting with the whole bd
claim API if we just exported single attribute which identifies the
current holder supplied at the time of claiming (just the kernel
identifier in string), so that we can forward-map the exclusive opener
in general instead of having to reverse-map it for everything other
than md/dm.

Thank you.

-- 
tejun
