From: Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
 read-write for read-only mappings
Date: Wed, 16 Feb 2011 09:39:51 +0100
Message-ID: <20110216083951.GC19830@htj.dyndns.org>
References: <4D5A6EF4.3030905@redhat.com>
 <20110215124629.GF5825@agk-dp.fab.redhat.com>
 <20110215152033.GK3160@htj.dyndns.org>
 <20110215154625.GG5825@agk-dp.fab.redhat.com>
 <20110215155018.GM3160@htj.dyndns.org>
 <4D5AA45C.7050600@redhat.com>
 <20110215161228.GN3160@htj.dyndns.org>
 <4D5AAB8F.50901@redhat.com>
 <20110215164128.GQ3160@htj.dyndns.org>
 <4D5AB0C5.9030304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5AB0C5.9030304@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 15, 2011 at 05:58:45PM +0100, Milan Broz wrote:
> # blockdev --setrw /dev/sd[bcde]
> # mdadm -A /dev/md0 /dev/sd[bcde]
> mdadm: /dev/md0 has been started with 4 drives.
> # mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
> # blockdev --setro /dev/sd[bcde]
> # mdadm -A /dev/md0 /dev/sd[bcde]
> mdadm: cannot re-read metadata from /dev/sdb - aborting
> 
> Works on 2.6.36.

Isn't failing to assemble rw array from ro devices the expected
behavior?  I think I'd want that to fail.  Neil, what do you think?

-- 
tejun
