From: Andreas Herrmann <aherrmann@suse.com>
Subject: dm-cache performance behaviour
Date: Tue, 5 Apr 2016 09:12:53 +0200
Message-ID: <20160405071253.GB27444@suselix.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
To: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi,

I've recently looked at performance behaviour of dm-cache and bcache.
I've repeatedly observed very low performance with dm-cache in
different tests. (Similar tests with bcache showed no such oddities.)

To rule out user errors that might have caused this, I shortly describe
what I've done and observed.

- tested kernel version: 4.5.0

- backing device: 1.5 TB spinning drive

- caching device: 128 GB SSD (used for metadata and cache and size
  of metadata part calculated based on
  https://www.redhat.com/archives/dm-devel/2012-December/msg00046.html)

- my test procedure consisted of a sequence of tests performing fio
  runs with different data sets, fio randread performance (bandwidth
  and IOPS) were compared, fio was invoked using something like

  fio --directory=/cached-device --rw=randread --name=fio-1 \
    --size=50G --group_reporting --ioengine=libaio \
    --direct=1 --iodepth=1 --runtime=40 --numjobs=1

  I've iterated over 10 runs for each of numjobs=1,2,3 and varied the
  name parameter to operate with different data sets.

  This procedure implied that with 3 jobs the underlying data set for
  the test consisted of 3 files with 50G each which exceeds the size
  of the caching device.

- Between some tests I've tried to empty the cache. For dm-cache I did
  this by unmounting the "compound" cache device, switching to cleaner
  target, zeroing metadata part of the caching device, recreating
  caching device and finally recreating the compound cache device
  (during this procedure I kept the backing device unmodified).

  I used dmsetup status to check for success of this operation
  (checking for #used_cache_blocks).
  If there is an easier way to do this please let me know -- If it's
  documented I've missed it.

- dm-cache parameters:
  * cache_mode: writeback
  * block size: 512 sectors
  * migration_threshold 2048 (default)

I've observed two oddities:

  (1) Only fio tests with the first data set created (and thus
  initially occupying the cache) showed decent performance
  results. Subsequent fio tests with another data set showed poor
  performance. I think this indicates that SMQ policy does not
  properly promote/demote data to/from caching device in my tests.

  (2) I've seen results where performance was actually below "native"
  (w/o caching) performance of the backing device. I think that this
  should not happen. If a data access falls back to the backing device
  due to a cache miss I would have expected to see almost the
  performance of the backing device. Maybe this points to a
  performance issue in SMQ -- spending too much time in policy code
  before falling back to the backing device.

I've tried to figure out what actually happened in SMQ code in these
cases - but eventually dismissed this. Next I want to check whether
there might be a flaw in my test setup/dm-cache configuration.

My understanding is that there are just two tunables for SMQ. Cache
block size (in sectors) and migration_threshold. So far I've sticked
to the defaults or to what I've found documented elsewhere. Are there
any recommendations for these values depending on the caching/backing
device sizes etc.?


Thanks,

Andreas

PS: Too keep this email short I'll put more details of my test
    procedure and a list of results in a follow-up mail to this one.
