From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-thin: Fix multiple bugs with reference
	management
Date: Mon, 12 Sep 2011 18:08:18 +0100
Message-ID: <20110912170817.GA26619@ubuntu>
References: <Pine.LNX.4.64.1109121125480.10597@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1109121125480.10597@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Sep 12, 2011 at 12:03:31PM -0400, Mikulas Patocka wrote:
> Hi
> 
> This is a major cleanup+bugfix of reference count management. Test it with 
> your testsuite.

Right, we've got 2 patches here really.

The first replaces a spinlock with a mutex and lifts it to remove a
couple of race conditions.  All good, I've prefixed the functions that
should be called with this lock held with '__' as usual.

The second moves registration to the constructor and destructor rather
than suspend/resume.  I know you were asking about this earlier, and I
think this was a hang over from when the pool and target objects were
the same thing, and we couldn't have two targets registered at once
when reloading a table.  Your change is clearly simpler.

All tests pass.  Merged and pushed.

Thanks,

- Joe
