From: Lukasz Flis <l.flis@cyf-kr.edu.pl>
Subject: [RHEL6.4] dm and multipath performance overhead
Date: Sat, 28 Sep 2013 16:54:17 +0200
Message-ID: <5246ED99.8040206@cyf-kr.edu.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Dear All,

During the performance testing of our new Netapp Engenio storage array
we have observed performance degradation when using multipath dm device.

In the test scenario we use:
 - 1 server with Infiniband QDR adapter
 - 4 RAID6 groups attached via SRP
 - 4 dd processes doing sequential write in parallel (1MB block, 40GB total)

IO scheduler configuration is exactly the same on dm-X devices and sdX
devices.

The results are as follows (4 dd writers):
PEAK: 3.155 GB/s AVG: 3 GB/s when using sdX devices directly
PEAK: 2.58  GB/s AVG: 1.93GB/s when using multipath

To eliminate path switching as potential cause we have raised
rr_min_io_req high enough to keep multipath from switching paths

There has been a lot of tuning of schedulers involved but we were unable
to get max performance with multipath. (3.155 is close to the
theoretical bw limit for QDR adapter on PCIe 2.0 x8 which is 3.2GB/s)

LUN thrashing is also not a cause here.

Environment:
device-mapper-multipath-0.4.9-64.el6.x86_64
kernel-2.6.32-358.18.1.el6.x86_64

Any comments or ideas where to look for potential cause
or any debugging hints are very appreciated.

Best Regards
--
Lukasz Flis
