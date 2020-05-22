From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: Improve io_opt limit stacking
Date: Fri, 22 May 2020 09:28:36 -0400
Message-ID: <yq1lflkp0b9.fsf@ca-mkp.ca.oracle.com>
References: <20200514065819.1113949-1-damien.lemoal@wdc.com>
        <BY5PR04MB6900144BD2729172EBF5DF2EE7B40@BY5PR04MB6900.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <BY5PR04MB6900144BD2729172EBF5DF2EE7B40@BY5PR04MB6900.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Fri, 22 May 2020 07:27:11 +0000")
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith Busch <kbusch@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids


Damien,

>> +	if (t->io_opt & (t->physical_block_size - 1))
>> +		t->io_opt = lcm(t->io_opt, t->physical_block_size);

> Any comment on this patch ?  Note: the patch the patch "nvme: Fix
> io_opt limit setting" is already queued for 5.8.

Setting io_opt to the physical block size is not correct.

-- 
Martin K. Petersen	Oracle Linux Engineering
