From: Luca Berra <bluca@comedia.it>
Subject: Re: dm-multipath has great throughput but we'd like more!
Date: Thu, 18 May 2006 09:59:40 +0200
Message-ID: <20060518075940.GF26035@percy.comedia.it>
References: <1147935929.27006.57.camel@baggage>
	<d2c2bb37e4e03a0daa7ee7e5803174cd@redhat.com>
	<1147938254.27006.65.camel@baggage>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, May 18, 2006 at 08:44:14AM +0100, Bob Gautier wrote:
>The card is a 64-bit PCI-X, so I don't think the bus is the bottleneck,
>and anyway the vendor specifies a maximum throughput of 200Mbyte/s per
>card.
>
>The disk array does not appear to be the bottleneck because we get
>200Mbyte/s when we use *two* HBAs in load-balanced mode.
>
>The question is really about why we only see O(100Mbyte/s) with one HBA
>when we can achieve O(200MByte/s) with two cards, given that one card
>should be able to achieve that throughput.
>
>I don't think the method of producing the traffic (bonnie++ or something
>else) should be relevant but if it were that would be very interesting
>for the benchmark authors!
>
>The storage is an HDS 9980 (I think?)
i am not an expert with Hitachi storages,
anyway
does each hba map to a different controller on the storage?
do you have some statistics on disk usage from the storage side?

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
