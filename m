From: Dave Chinner <david@fromorbit.com>
Subject: Re: V4.16+ kernel warning when running xfs/006
Date: Thu, 5 Apr 2018 10:06:26 +1000
Message-ID: <20180405000625.GC23861@dastard>
References: <20180404231246.GA12299@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180404231246.GA12299@ming.t460p>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: dm-devel.ids

On Thu, Apr 05, 2018 at 07:12:52AM +0800, Ming Lei wrote:
> Hi,
> 
> The following warning is triggered when running xfs/006 with
> v4.16+(the latest linus tree):
> 
> 
> [ 4406.277765] run fstests xfs/006 at 2018-04-04 19:18:32
> [ 4408.437679] XFS (dm-0): Mounting V5 Filesystem
> [ 4408.457115] XFS (dm-0): Ending clean mount
> [ 4430.340609] ------------[ cut here ]------------
> [ 4430.341255] DEBUG_LOCKS_WARN_ON(sem->owner != get_current())

Every filesystem is currently throwing these warnings - it's
the filesystem freeze code that is throwing them. The code is
perfectly OK, just the debug code doesn't understand that.

See https://marc.info/?l=linux-fsdevel&m=152285269706656&w=2

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
