From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: noflush resizing (0/3)
Date: Thu, 25 Oct 2007 15:48:33 +0100
Message-ID: <20071025144833.GN10006@agk.fab.redhat.com>
References: <471FB83D.4060307@ce.jp.nec.com>
	<20071025012456.GK10006@agk.fab.redhat.com>
	<4720A59A.8060001@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4720A59A.8060001@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Oct 25, 2007 at 10:18:02AM -0400, Jun'ichi Nomura wrote:
> There is no guarantee that the I/O flowing through the device again.
> The table might need be replaced again, but to do that, the resume
> should have been completed to let the userspace know it.

Then the first attempt to set the size could be made to fail
(because it could not get the lock immediately) and the
size could be set after the second resume instead.

- Setting the size would lag behind the actual size the dm table was
supporting, but (given the usage cases discussed) this would not matter.

> bdget() in noflush suspend has a possibility of stall.

So we cannot avoid fixing that: we require immediate return
with failure instead of waiting.

> OTOH, calling bdget() and i_size_write() outside of the lock
> can cause race with other table swapping and may result in setting
> wrong device size.

If the size setting is removed from the lock, then it becomes
"set the inode size to match the current size of the table" and
races would not matter - each "set size" attempt would set it
to the instantaneous live table size, not a cached value that
could be out-of-date.

Alasdair
-- 
agk@redhat.com
