From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Re: DM-Cache Writeback & Direct IO?
Date: Tue, 21 Jul 2015 15:51:21 +0200
Message-ID: <55AE4E59.1040407@evilazrael.de>
References: <559CE76E.6020504@evilazrael.de> <20150708144829.GA5058@rh-vpn>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150708144829.GA5058@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Joe,


Am 08.07.2015 um 16:48 schrieb Joe Thornber:
> Could you try with the latest kernels and the new smq policy please? 

I changed my test a little bit and after warming up and waiting a couple 
of minutes until there was no activity I rerun the same test. Result is 
that the writes are split roughly 2/3 to the caching device and 1/3 to 
the backing device. The backing device is a HDD raid and utilized to 
100%, so it is throttling fio's speed down.

In bcache I could force to write the full IO to the cache by changing 
the congested_*_threshold_us to 0 and it worked quite well to accelerate 
new writes without the need to warm up. It looks like dm-cache can only 
do hotspot acceleration, right?

My test was dm-cache with smq with sde being a fast SSD RAID0 used for 
cache and metadata and sdb used as backing device. This time I used XFS 
the device and ran fio repeatedly on the same file without deleting it. 
So the same HDD blocks should be involved.

The fio command is ./fio --name=test --filename=/mnt/somefile.dat 
--rw=randwrite  --filesize=16G  --bs=64k --ioengine=libaio --direct=1 
--iodepth=1000
The final statistics are
  WRITE: io=16384MB, aggrb=158933KB/s, minb=158933KB/s, maxb=158933KB/s, 
mint=105561msec, maxt=105561msec

Disk stats (read/write):
     dm-2: ios=0/262149, merge=0/0, ticks=0/103875140, 
in_queue=104066916, util=100.00%, aggrios=175/131307, aggrmerge=232/243, 
aggrticks=9982/7629026, aggrin_queue=7638856, aggrutil=100.00%
   sdb: ios=72/88760, merge=132/344, ticks=19276/15245864, 
in_queue=15265104, util=100.00%
   sde: ios=279/173854, merge=333/143, ticks=688/12188, in_queue=12608, 
util=10.03%

The dmcache status is before
dmcache: 0 6442450943 cache 8 8915/4161600 512 114081/2913051 1757 121 
90280078 90791892 0 25373 24692 1 writeback 2 migration_threshold 2048 
smq 0 rw
and after the test
dmcache: 0 6442450943 cache 8 8915/4161600 512 114132/2913051 1757 121 
90453546 90867517 0 25424 36538 1 writeback 2 migration_threshold 2048 
smq 0 rw



Kind regards

Christoph
