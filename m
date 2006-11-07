From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not
	mutex
Date: Tue, 7 Nov 2006 23:34:20 +0000
Message-ID: <20061107233420.GC30653@agk.surrey.redhat.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<170fa0d20611071218t3c145ef9i5413e432597d78a5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <170fa0d20611071218t3c145ef9i5413e432597d78a5@mail.gmail.com>
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
Cc: Andrew Morton <akpm@osdl.org>, Srinivasa DS <srinivasa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>, Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Nov 07, 2006 at 03:18:08PM -0500, Mike Snitzer wrote:
> Srinivasa's description of the patch just speaks to how freeze_bdev
> and thaw_bdev are used by DM but completely skips justification for
> switching from mutex to semaphore.  Why is it beneficial and/or
> necessary to use a semaphore instead of a mutex here?

This used to be a semaphore; someone changed it to a mutex; we started
getting device-mapper bug reports from people because the usage breaks the
stated semantics for a mutex; this patch puts things back while we consider
if there's a better way of doing things.
 
Alasdair
-- 
agk@redhat.com
