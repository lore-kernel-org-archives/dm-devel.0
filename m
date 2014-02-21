From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH for-dm-3.14-fixes 6/8] dm thin: fix
 pool_preresume resize with heavy IO races
Date: Fri, 21 Feb 2014 14:27:07 +0000
Message-ID: <20140221142706.GE13298@debian>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
	<1392951365-9829-7-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1392951365-9829-7-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

NACK.

On Thu, Feb 20, 2014 at 09:56:03PM -0500, Mike Snitzer wrote:
> Before, when a pool is being resized, on resume the pool's mode was
> being immediately set to PM_WRITE and the process_* methods would be set
> to the normal writable operations.  These were established before
> pool_resume() was able to actually resize either the metadata or data
> device and resulted in the resize failing.  This failure occurred due to
> the thin device calling wake_worker() which kicked do_worker() during
> pool_preresume() -- which caused calls to the writable process_* methods
> to occur during the resize.

The bug is the worker should not be able to be woken until
pool_preresume has completed.  A simple check in wake_worker() should
fix this.

> Now, the pool is forced to stay in read-only mode if it was already in
> read-only mode.  This prevents bouncing the pool's mode and associated
> process_* methods and consistently keeps read-only processing in place
> until the resize(s) complete.  To achieve this the pool can now be in a
> PM_READ_ONLY state but the metadata's is !read_only -- so as to allow
> the commit() the follows the resize to take place.  Differentiate
> between commit_metadata_superblock() and commit() since different
> negative checks apply (but factor out a common __commit that each
> calls).

Too complicated.
