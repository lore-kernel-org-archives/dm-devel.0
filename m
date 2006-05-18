From: Bob Gautier <rgautier@redhat.com>
Subject: dm-multipath has great throughput but we'd like more!
Date: Thu, 18 May 2006 08:05:28 +0100
Message-ID: <1147935929.27006.57.camel@baggage>
Reply-To: rgautier@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: consult-list@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Yesterday my client was testing of multipath load balancing and failover
on a system running ext3 on a logical volume which comprises about ten
SAN LUNs all reached using multipath in multibus mode over two QL2340
HBAs.

On the one hand, the client is very impressed: running bonnie++
(inspired by Ronan's GFS v VxFS example) we get just over 200Mbyte/s
over the two HBAs, and when we pull a link we get about 120MByte/s.

The throughput and failover response times are better than the client
has ever seen, but we're wondering why we are not seeing higher
throughput per-HBA -- the QL2340 datasheet says it should manage
200Mbyte/s and all switches etc. run at 2GBps.

Any ideas?

Bob Gautier
+44 7921 700996
