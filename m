From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: dm-cache bug when using the cleaner?
Date: Tue, 5 Mar 2013 21:35:09 -0800
Message-ID: <20130306053509.GA6528@blackbox.djwong.org>
References: <20130305014048.GD5347@blackbox.djwong.org>
	<20130305165248.GA4239@raspberrypi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130305165248.GA4239@raspberrypi>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 05, 2013 at 04:52:49PM +0000, thornber@redhat.com wrote:
> Hi Darrick,
> 
> You're using it correctly and have found a bug, thanks!  This patch fixes it:
> 
>   https://github.com/jthornber/linux-2.6/commit/6bbc70ab77ab828f1fecd8a3f4776b344eedef24

Seems to fix my problem, thank you!

--D

> This is the test scenario I use (tweaked to catch your issue).
> 
>   def wait_for_all_clean(cache)
>     cache.event_tracker.wait(cache) do |cache|
>       status = CacheStatus.new(cache)
>       STDERR.puts "#{status.nr_dirty} dirty blocks"
>       status.nr_dirty == 0
>     end
>   end
> 
>   def test_cleaner_policy
>     with_standard_cache(:format => true) do |cache|
>       git_prepare(cache, :ext4)
> 
>       cache.pause do
>         table = cache.active_table
>         table.targets[0].args[5] = 'cleaner'
>         cache.load(table)
>       end
> 
>       wait_for_all_clean(cache)
> 
>       cache.pause do
>         table = cache.active_table
>         table.targets[0].args[5] = 'mq'
>         cache.load(table)
>       end
> 
>       status = CacheStatus.new(cache)
>       assert_equal(0, status.nr_dirty)
>     end
> 
>     # We should be able to use the origin directly now                                                                       
>     with_standard_linear do |origin|
>       fs = FS::file_system(:ext4, origin)
>       fs.with_mount('./kernel_builds', :discard => true) do
>         # triggers fsck                                                                                                      
>       end
>     end
>   end
