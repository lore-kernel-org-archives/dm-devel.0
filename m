From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH][RFC] dm: Do not open log and cow device read-write for
 read-only mappings
Date: Mon, 14 Feb 2011 15:09:40 +0100
Message-ID: <20110214140940.GM18742@htj.dyndns.org>
References: <4D573BBB.6090200@redhat.com>
 <1297594735-5593-1-git-send-email-tm@tao.ma>
 <4D57E67E.1030707@redhat.com>
 <4D57F357.6060708@tao.ma>
 <4D580A8B.5050508@redhat.com>
 <20110214103026.GA18742@htj.dyndns.org>
 <4D591664.6090203@redhat.com>
 <4D592AD1.6020500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D592AD1.6020500@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

On Mon, Feb 14, 2011 at 02:14:57PM +0100, Milan Broz wrote:
> > But it doesn't fix the read-only snapshot issue and I guess there will be
> > the same problem with read-only MD code too.
> > (so the 2) issue here https://lkml.org/lkml/2011/2/12/209).

So, the problem is caused by dm opening members rw even for ro
devices, right?

> I am not sure if this is complete fix... note that:
> - what happens during mirror resync and read-only log?
> - for COW, it there situation we need to update header in read-oly mode? (invalidated snap?)

But if the underlying device is marked ro, dm shouldn't update it at
all.  The device should be opened ro and ro policy should be enforced.

Thanks.

-- 
tejun
