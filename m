From: Richard Davies <richard@arachsys.com>
Subject: Queuing of dm-raid1 resyncs to the same underlying block
	devices
Date: Sat, 26 Sep 2015 16:49:02 +0100
Message-ID: <20150926154902.GA2964@alpha.arachsys.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

Does dm-raid queue resyncs of multiple dm-raid1 arrays, if the underlying
block devices are the same?

Linux md has this feature, e.g.:

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath]
md1 : active raid1 sda2[2] sdb2[1]
      943202240 blocks [2/1] [_U]
      [====>................]  recovery = 21.9% (207167744/943202240)
      finish=20290.8min speed=603K/sec
      bitmap: 1/8 pages [4KB], 65536KB chunk

md0 : active raid1 sda1[2] sdb1[1]
      67108736 blocks [2/1] [_U]
        resync=DELAYED
      bitmap: 1/1 pages [4KB], 65536KB chunk


After some time investigating, I can't find it in dm-raid.

Please can someone tell me if this is implemented or not?

If it is implemented, where should I look to see it happening?

Thanks,

Richard.
