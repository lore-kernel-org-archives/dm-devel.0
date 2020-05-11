From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCHv5 00/14] dm-zoned: metadata version 2
Date: Mon, 11 May 2020 10:55:41 +0000
Message-ID: <BY5PR04MB6900C76141ABD428F42C1840E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200508090332.40716-1-hare@suse.de>
	<BY5PR04MB6900138C0F78196D0F81BF07E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Cc: Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/05/11 11:46, Damien Le Moal wrote:
> Mike,
> 
> I am still seeing the warning:
> 
> [ 1827.839756] device-mapper: table: 253:1: adding target device sdj caused an
> alignment inconsistency: physical_block_size=4096, logical_block_size=4096,
> alignment_offset=0, start=0
> [ 1827.856738] device-mapper: table: 253:1: adding target device sdj caused an
> alignment inconsistency: physical_block_size=4096, logical_block_size=4096,
> alignment_offset=0, start=0
> [ 1827.874031] device-mapper: table: 253:1: adding target device sdj caused an
> alignment inconsistency: physical_block_size=4096, logical_block_size=4096,
> alignment_offset=0, start=0
> [ 1827.891086] device-mapper: table: 253:1: adding target device sdj caused an
> alignment inconsistency: physical_block_size=4096, logical_block_size=4096,
> alignment_offset=0, start=0
> 
> when mixing 512B sector and 4KB sector devices. Investigating now.


OK. Figured that one out: the 500GB SSD I am using for the regular device is
976773168 512B sectors capacity, that is, not a multiple of the 256MB zone size,
and not even a multiple of 4K. This causes the creation of a 12MB runt zone of
24624 sectors, which is ignored. But the start sector of the second device in
the dm-table remains 976773168, so not aligned on 4K. This causes
bdev_stack_limits to return an error and the above messages to be printed.

So I think we need to completely ignore the eventual "runt" zone of the regular
device so that everything aligns correctly. This will need changes in both
dmzadm and dm-zoned.

Hannes, I can hack something on top of your series. Or can you resend with that
fixed ?




-- 
Damien Le Moal
Western Digital Research
