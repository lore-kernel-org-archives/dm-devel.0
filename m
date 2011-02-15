From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
	read-write for read-only mappings
Date: Tue, 15 Feb 2011 15:46:25 +0000
Message-ID: <20110215154625.GG5825@agk-dp.fab.redhat.com>
References: <4D5A6EF4.3030905@redhat.com> <20110215124629.GF5825@agk-dp.fab.redhat.com> <20110215152033.GK3160@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110215152033.GK3160@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 15, 2011 at 04:20:33PM +0100, Tejun Heo wrote:
> Hmmm... but -EACCES is the correct one here.  The device node itself
> is rejecting RW access.  There's no FS which is enforcing RO.

Exactly:)  If the filesystem permissions were what was blocking this
(say r--) then I'd agree with EACCES.  Interpret those man pages in the
context of 'pathname refers to a block device not a file'.
 
If it's EACCES, I just need to gain more privilege/capabilities and then
repeat the system call and it could succeed.

But EROFS tells me however much extra privilege I get it's going to make
no difference.

That's why I'm arguing EACCES is not a good error to return and EROFS is
more appropriate.

Alasdair
