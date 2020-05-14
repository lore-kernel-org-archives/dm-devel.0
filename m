From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCHv5 00/14] dm-zoned: metadata version 2
Date: Thu, 14 May 2020 02:22:04 +0000
Message-ID: <BY5PR04MB6900D391965BBADE58692DB1E7BC0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200508090332.40716-1-hare@suse.de>
	<BY5PR04MB6900138C0F78196D0F81BF07E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
	<BY5PR04MB6900C76141ABD428F42C1840E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
	<2553e593-795d-6aed-f983-e990a283e2ff@suse.de>
	<BY5PR04MB6900C84D00585D3560D4C51AE7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
	<BY5PR04MB690020AE68E7A20EA8BFED0DE7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
	<BY5PR04MB690002ABF208B084607B6971E7BF0@BY5PR04MB6900.namprd04.prod.outlook.com>
	<yq13683z7sj.fsf@oracle.com>
	<BY5PR04MB6900B82F4BEE1B13B239D93EE7BC0@BY5PR04MB6900.namprd04.prod.outlook.com>
	<yq1h7wjxnph.fsf@oracle.com>
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
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2020/05/14 11:20, Martin K. Petersen wrote:
> 
> Damien,
> 
>> Indeed. It is an NVMe M.2 consumer grade SSD. Nothing fancy. If you
>> look at nvme/host/core.c nvme_update_disk_info(), you will see that
>> io_opt is set to the block size... This is probably abusing this
>> limit. So I guess the most elegant fix may be to have nvme stop doing
>> that ?
> 
> Yeah, I'd prefer for io_opt to only be set if the device actually
> reports NOWS.

Sent a patch :)

> 
> The purpose of io_min is to be the preferred lower I/O size
> boundary. One should not submit I/Os smaller than this.
> 
> And io_opt is the preferred upper boundary for I/Os. One should not
> issue I/Os larger than this value. Setting io_opt to the logical block
> size kind of defeats that intent.
> 
> That said, we should probably handle the case where the pbs gets scaled
> up but io_opt doesn't more gracefully.

Yes. Will look at that too.

Thanks !

> 


-- 
Damien Le Moal
Western Digital Research
