From: Steve Lord <lord@xfs.org>
Subject: Re: dm-multipath has great throughput but we'd like more!
Date: Thu, 18 May 2006 15:28:09 -0500
Message-ID: <446CD8D9.2010106@xfs.org>
References: <1147935929.27006.57.camel@baggage>	<d2c2bb37e4e03a0daa7ee7e5803174cd@redhat.com>
	<1147938254.27006.65.camel@baggage>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1147938254.27006.65.camel@baggage>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: rgautier@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: consult-list@redhat.com
List-Id: dm-devel.ids


Provided you have things cabled right and you have 2 HBA ports going either
into a switch, or into the controllers of the raid (raid probably has 4
ports), then the theoretical bandwidth is closer to 400 Mbytes/sec. Pretty sure
any reasonable Hitachi raid will sustain close to that. Using other software and
raid hardware I can generally sustain 375 Mbytes/sec from 2 qlogic hba ports in
a  fairly old dell server box, and that is going through 3 switches in the
middle.

You need to have sustained I/O which is directed at both sides of the
raid though. Not sure about the HDS 9980, but I think that is an
active/active raid, which means each controller can access each lun
in parallel. You really need to be striping your I/O across the luns
and controllers though. You can pull tricks to measure the fabric
capacity vs the storage bandwidth by using the raid's cache. Ensure you
have caching enabled in the raid, and have a file which is laid out
across multiple luns. Read a file which is a large percentage of the
cache size using o_direct (lmdd can be built with direct I/O support).
Then run the read again, if you did it right, you just eliminated the
spindles from the I/O.

Not sure about the hitachi raid again, but a lun would generally
belong to a controller on the raid, and there are usually two
controllers. Make sure that when you build the volume you stripe
luns so that they alternate between controllers. Then you need to
make sure that your I/Os are large enough to hit multiple disks
at once. There are lots of tricks to tuning this type of setup.

The problem with the load balancing in dm-multipath is that it is not
really load balancing, it is round robin, on a per lun basis I think,
it has no global picture of how much other load is currently going
to each HBA or controller port. The best you can do is drop the value
of rr_min_io in the /etc/multipath.conf file to a small value, try
something like 1 or 2.

Steve


Bob Gautier wrote:
> On Thu, 2006-05-18 at 02:25 -0500, Jonathan E Brassow wrote:
>> The system bus isn't a limiting factor is it?  64-bit PCI-X will get 
>> 8.5 GB/s (plenty), but 32-bit PCI 33MHz got 133MB/s.
>>
>> Can your disks sustain that much bandwidth? 10 striped drives might get 
>> better than 200MB/s if done right, I suppose.
>>
>> Don't the switches run at 2 Gbits/s?  2 Gbits/s / 10 (throw in 2 bits 
>> for protocol) ~= 200MB/s.
>>
> 
> Thanks for the fast responses:
> 
> The card is a 64-bit PCI-X, so I don't think the bus is the bottleneck,
> and anyway the vendor specifies a maximum throughput of 200Mbyte/s per
> card.
> 
> The disk array does not appear to be the bottleneck because we get
> 200Mbyte/s when we use *two* HBAs in load-balanced mode.
> 
> The question is really about why we only see O(100Mbyte/s) with one HBA
> when we can achieve O(200MByte/s) with two cards, given that one card
> should be able to achieve that throughput.
> 
> I don't think the method of producing the traffic (bonnie++ or something
> else) should be relevant but if it were that would be very interesting
> for the benchmark authors!
> 
> The storage is an HDS 9980 (I think?)
> 
>> Could be a bunch of reasons...
>>
>>   brassow
>>
>> On May 18, 2006, at 2:05 AM, Bob Gautier wrote:
>>
>>> Yesterday my client was testing of multipath load balancing and 
>>> failover
>>> on a system running ext3 on a logical volume which comprises about ten
>>> SAN LUNs all reached using multipath in multibus mode over two QL2340
>>> HBAs.
>>>
>>> On the one hand, the client is very impressed: running bonnie++
>>> (inspired by Ronan's GFS v VxFS example) we get just over 200Mbyte/s
>>> over the two HBAs, and when we pull a link we get about 120MByte/s.
>>>
>>> The throughput and failover response times are better than the client
>>> has ever seen, but we're wondering why we are not seeing higher
>>> throughput per-HBA -- the QL2340 datasheet says it should manage
>>> 200Mbyte/s and all switches etc. run at 2GBps.
>>>
>>> Any ideas?
>>>
>>> Bob Gautier
>>> +44 7921 700996
>>>
