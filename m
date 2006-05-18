From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: dm-multipath has great throughput but we'd like more!
Date: Thu, 18 May 2006 02:25:13 -0500
Message-ID: <d2c2bb37e4e03a0daa7ee7e5803174cd@redhat.com>
References: <1147935929.27006.57.camel@baggage>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1147935929.27006.57.camel@baggage>
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
List-Id: dm-devel.ids

The system bus isn't a limiting factor is it?  64-bit PCI-X will get 
8.5 GB/s (plenty), but 32-bit PCI 33MHz got 133MB/s.

Can your disks sustain that much bandwidth? 10 striped drives might get 
better than 200MB/s if done right, I suppose.

Don't the switches run at 2 Gbits/s?  2 Gbits/s / 10 (throw in 2 bits 
for protocol) ~= 200MB/s.

Could be a bunch of reasons...

  brassow

On May 18, 2006, at 2:05 AM, Bob Gautier wrote:

> Yesterday my client was testing of multipath load balancing and 
> failover
> on a system running ext3 on a logical volume which comprises about ten
> SAN LUNs all reached using multipath in multibus mode over two QL2340
> HBAs.
>
> On the one hand, the client is very impressed: running bonnie++
> (inspired by Ronan's GFS v VxFS example) we get just over 200Mbyte/s
> over the two HBAs, and when we pull a link we get about 120MByte/s.
>
> The throughput and failover response times are better than the client
> has ever seen, but we're wondering why we are not seeing higher
> throughput per-HBA -- the QL2340 datasheet says it should manage
> 200Mbyte/s and all switches etc. run at 2GBps.
>
> Any ideas?
>
> Bob Gautier
> +44 7921 700996
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
