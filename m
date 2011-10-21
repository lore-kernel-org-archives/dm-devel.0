From: Joe Thornber <thornber@redhat.com>
Subject: Re: Semaphore bug in dm-thin
Date: Fri, 21 Oct 2011 10:28:00 +0100
Message-ID: <20111021092800.GB4393@ubuntu>
References: <Pine.LNX.4.64.1110201451490.5318@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110201451490.5318@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Thanks Mikulas, Good analysis.  Looking at this now.

On Thu, Oct 20, 2011 at 02:59:12PM -0400, Mikulas Patocka wrote:
> Hi Joe
> 
> Zdenek recently got a lockdep warning in dm-thin. See this: 
> http://pastebin.test.redhat.com/65346
> 
> I looked at the warning and realized that it is not a false alarm, but a 
> real bug.
> 
> Lockdep warns about dependency &md->io_lock -> &md->map_lock, but io_lock 
> is a semaphore and map_lock is a spinlock, so such lock ordering should be 
> always allowed (you can't take them in reverse order, because you can't 
> take a semaphore while holding a spinlock).
> 
> Looking deeper in the warning, it complains that there is an exeisting 
> dependency chain &md->map_lock --> &pmd->root_lock --> &md->io_lock
> 
> Here, map_lock is a spinlock and root_lock is a semaphore, this order of 
> taking locks is obviously wrong.
> 
> Cutting relevant part of the backtrace, we see:
> 41. [ 3836.656384] -> #1 (&pmd->root_lock){+++++.}:
> 42. [ 3836.656384]        [<ffffffff81090740>] lock_acquire+0x90/0x1f0
> 43. [ 3836.656384]        [<ffffffff814ac1ce>] down_read+0x3e/0x86
> 44. [ 3836.656384]        [<ffffffffa02aaafe>]
>     dm_pool_get_data_dev_size+0x2e/0x60 [dm_thin_pool]
> 45. [ 3836.656384]        [<ffffffffa02a615b>]
>     thin_iterate_devices+0x3b/0x80 [dm_thin_pool]
> 46. [ 3836.656384]        [<ffffffffa006b2bf>]
>     dm_table_supports_flush+0x5f/0x90 [dm_mod]
> 47. [ 3836.656384]        [<ffffffffa006d2ec>]
>     dm_table_set_restrictions+0x9c/0x180 [dm_mod]
> 48. [ 3836.656384]        [<ffffffffa006a88a>] dm_swap_table+0x1da/0x2e0
>     [dm_mod]
> 49. [ 3836.656384]        [<ffffffffa00701db>] dev_suspend+0x11b/0x260
>     [dm_mod]
> 50. [ 3836.656384]        [<ffffffffa007089a>] ctl_ioctl+0x15a/0x2c0
>     [dm_mod]
> 
> dm_swap_table calls __bind (which is not shown because it is inlined), 
> __bind takes a spinlock &md->map_lock and calls dm_table_set_restrictions, 
> from there, the code goes to thin_iterate_devices and it tries to take a 
> semaphore &pmd->root_lock.
> 
> So there is a clear bug, dm-thin is taking a semaphore while spinlock 
> &md->map_lock is held.
> 
> Mikulas
