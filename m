From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Another cache target
Date: Mon, 17 Dec 2012 17:49:51 -0800
Message-ID: <20121218014951.GA4878@blackbox.djwong.org>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<20121213215715.GA19419@redhat.com>
	<20121214011643.GB9845@blackbox.djwong.org>
	<20121214021918.GA29561@redhat.com>
	<20121214023425.GG9453@blackbox.djwong.org>
	<20121214102443.GB3022@raspberrypi>
	<20121214121143.GD3022@raspberrypi>
	<20121214215119.GJ9453@blackbox.djwong.org>
	<20121215082309.GA5330@reti.lambda.co.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20121215082309.GA5330@reti.lambda.co.uk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Sat, Dec 15, 2012 at 08:23:09AM +0000, Joe Thornber wrote:
> On Fri, Dec 14, 2012 at 01:51:19PM -0800, Darrick J. Wong wrote:
> > Yeah, I think I've seen some odd behavior too - on one of my runs, blkid
> > reported that the cache device had the same superblock as the aggregate device.
> > My guess is that block 0 on the exported device got mapped to block 0 of the
> > cache.  I'll see if I can make it happen again, but that brings me to another
> > set of questions.
> 
> This is normal.

Okay, but this is a little scary too:

# blkid
/dev/sda1: UUID="3cec6984-7db1-4b51-988c-19a574d444b3" TYPE="ext4" 
/dev/mapper/cache: UUID="3cec6984-7db1-4b51-988c-19a574d444b3" TYPE="ext4" 
/dev/vda: UUID="0bf9cc39-9ca1-4b4a-b543-774efe5b51cb" TYPE="ext4"

sda1 is the ssd, vda is the origin.  I haven't used the cleaner yet; this is
merely the result of beating on the cache long enough that the superblock gets
flushed out to the origin.

It's not a problem /while/ the cache is mounted because opening sda1 or vda
with O_EXCL (such as when you try to mount) return -EBUSY.  When the cache
isn't mounted, however, there's more of a problem -- any sane filesystem will
notice that sda1 is smaller than the filesystem and refuse to mount, but
there's not a lot preventing erroneous mounts of vda, which will possibly end
in disaster.

I guess I'm simply afraid of accidentally mounting the origin device when it's
dirty, whether it's through overeager boot scripts, or plain old stupidity on
my part. :)

> > First, is there a plan to have userspace tools to set up the cache, provide
> > protective superblocks, etc.?
> 
> Yes, lvm2 will support it soon (hopefully).  Tools like cache_check,
> cache_dump, cache_restore that manipulate the metadata device are
> nearly ready.
> 
> >  As far as I can tell, the slow disk and the fast
> > disk don't have headers to declare the existence of the cache, so blkid and
> > friends can end up seeing things they shouldn't.  How were you planning to keep
> > users from mounting the slow device before the cache comes up?
> 
> We don't label the origin device or ssd in anyway.

<nod> I was rather hoping there'd be a label to avoid all that above blkid
drama. :/

> > Second, if the cache is in WB mode, is there a way to force it to flush the
> > cache contents to disk?  Or does it do that at dmsetup create time?
> 
>   Reload the cache target with the cleaner policy.  Once it's finished
>   writing everything back it'll trigger a dm event that you can catch
>   with 'dmsetup wait'.  Then check the status to double check there
>   are no dirty blocks.  At this point you can ditch the cache and use
>   the origin directly.  See test below.
> 
> 
>   def wait_for_all_clean(cache)
>     cache.event_tracker.wait(cache) do |cache|
>       status = CacheStatus.new(cache)
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
>         table.targets[0].args[6] = 'cleaner'
>         cache.load(table)
>       end
> 
>       wait_for_all_clean(cache)
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

Ahh, nifty.  But how does it work from the command line?

# dmsetup table
cache: 0 67108864 cache 8:2 8:1 254:0 512 1 writeback default 0
# echo '0 67108864 cache /dev/sda2 /dev/sda1 /dev/vda 512 0 cleaner 0' | dmsetup reload cache
# dmsetup table
cache: 0 67108864 cache 8:2 8:1 254:0 512 1 writeback default 0

Is there some trickery to dmsetup that I'm missing here?

--D
