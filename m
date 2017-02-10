From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 1/1] dm-zoned: Zoned block device target
Date: Fri, 10 Feb 2017 10:24:59 +0900
Message-ID: <e6e86f98-c9d4-c797-8dc1-f7dccd30fafe@wdc.com>
References: <20170209041849.30964-1-damien.lemoal@wdc.com>
	<d2353e66-183c-1f71-7a64-52e4b862bc17@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d2353e66-183c-1f71-7a64-52e4b862bc17@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Hannes,

On 2/10/17 01:07, Hannes Reinecke wrote:
>> +/*
>> + * CRC32
>> + */
>> +static u32 dmz_sb_crc32(u32 crc, const void *buf, size_t length)
>> +{
>> +	unsigned char *p = (unsigned char *)buf;
>> +	int i;
>> +
>> +#define CRCPOLY_LE 0xedb88320
>> +
>> +	while (length--) {
>> +		crc ^= *p++;
>> +		for (i = 0; i < 8; i++)
>> +			crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
>> +	}
>> +
>> +	return crc;
>> +}
>> +
> Why do you insist on your own CRC32 implementations?
> Don't we have enough already?

Indeed. I will change this to use existing kernel API.

> Have you looked at using dm-kcopyd for doing the reclaim?
> What's inhibiting you from using it?

I did look at it, and I did like it very much. It would be much more
simple to use than open coding everything like I did. But the problem is
that while the read part is fine, the write part is not. The reason is
that most of the time, the zone being reclaimed is badly fragmented
(valid blocks all over the place in the zone). Reading those valid
blocks with kcopyd is fine, but when moving them to the target zone, the
overall write sequence MUST be sequential, which means that
blkdev_issue_zeroout calls must be inserted between non sequential
regions (the indirection system is per zone, not per block, so the
relative offsets of the blocks read in the zone being reclaimed must be
preserved in the destination zone).

I could modify kcopyd_copy to do this zeroout insertion of course. In
fact, I think that would be the better approach. But I think that can be
done later, once/if Mike accepts dm-zoned. Or I could re-submit dm-zoned
together with a patch for kcopyd_copy.

Mike,
Any advice on which approach is best/more acceptable for you ?

Thanks !

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
