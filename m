From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
	read-write for read-only mappings
Date: Mon, 14 Feb 2011 14:39:04 +0000
Message-ID: <20110214143904.GB5825@agk-dp.fab.redhat.com>
References: <4D573BBB.6090200@redhat.com> <1297594735-5593-1-git-send-email-tm@tao.ma> <4D57E67E.1030707@redhat.com> <4D57F357.6060708@tao.ma> <4D580A8B.5050508@redhat.com> <20110214103026.GA18742@htj.dyndns.org> <4D591664.6090203@redhat.com> <4D592AD1.6020500@redhat.com> <20110214140940.GM18742@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110214140940.GM18742@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 14, 2011 at 03:09:40PM +0100, Tejun Heo wrote:
> But if the underlying device is marked ro, dm shouldn't update it at
> all.  The device should be opened ro and ro policy should be enforced.

Indeed, but dm isn't tracking this today because it didn't need to up-to
now.

I can think of a few scenarios where dm can have the underlying device open
read-write when it only needs read-only.   (E.g. we track and cater for
read-only->read-write transitions but not the opposite and don't propagate
changes through the stack.)

We'll do an audit...
 
Alasdair
