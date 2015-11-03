From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: How big should raid metadata device be?
Date: Tue, 3 Nov 2015 02:01:19 +0100
Message-ID: <5638075F.90602@redhat.com>
References: <5637BFBF.3010603@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5637BFBF.3010603@redhat.com>
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



On 11/02/2015 08:55 PM, Andy Grover wrote:
> Hi all,
>
> In looking at md-raid one question I had was exactly how large does 
> the metadata device need to be in comparison to the data device? It 
> contains a padded-to-4Kbyte sized raid metadata struct, and then also 
> a write intent bitmap that is sized based upon the number of stripes, 
> with 16 bits per stripe.

There is no direct relationship between stripes and bitmap size, because the
bitmap holds a bit per region.

I'm restricting this to metadata kept by dm-raid (neither md/md raid1 
clustered or md with external metadata),
because you seem to utilize that:

the metadata contains a 4KiB padded struct to describe the array (the 
raid superblock) at offset 0
followed by 4KiB for the bitmap header. After those 2, a bit per region 
(i.e. blocks / region_size) is allocated.

Say, for 64KiB region size and 1TiB raid1 set size (1TiB*Bit / 64 KiB = 
16777216 Bit; 16777216 Bit / (8 Bit/Byte) / (1024 Byte/KiB) = 2048 KiB:

4KiB superblock
4KiB bitmap header
2048 KiB bitmap
-------------------------
2056KiB total

>
> Is it correct to say the minimum size of the metadata device should be:
>
> 4096 + (2 * stripe_count)
>
> bytes?
>
> Thanks -- Andy
>
> p.s. LVM2 allocates 1 extent (default 4MiB) for the raid meta device. 
> But it's not clear if given a large enough raid dev, and configured 
> with a much smaller extent size than the default, if one extent might 
> not be enough.

It is actually very clear that in case of small lvm2 extent and raid 
region size,
one extent is easily not big enough.
That's why I am developing dynamic raid metadata allocation for lvm2.

Heinz

>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
