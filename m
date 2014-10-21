From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm-thin
Date: Tue, 21 Oct 2014 11:32:54 +0200
Message-ID: <54462846.7040502@redhat.com>
References: <alpine.LRH.2.02.1410131113450.3569@file01.intranet.prod.int.rdu2.redhat.com>	<20141013162026.GA4631@redhat.com>,
	alpine.LRH.2.02.1410131643100.11699@file01.intranet.prod.int.rdu2.redhat.com,
	9ac8b012-7ca4-4a21-9d75-024820083b4c@aliyun.com
	<20b42a29-27ce-4395-9cd9-843f2acfcab2@aliyun.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20b42a29-27ce-4395-9cd9-843f2acfcab2@aliyun.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lilofile <lilofile@aliyun.com>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, axboe <axboe@kernel.dk>, Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

Dne 21.10.2014 v 03:36 lilofile napsal(a):
> In dm-thin.c,
> /*
>   * The block size of the device holding pool data must be
>   * between 64KB and 1GB.
>   */
> #define DATA_DEV_BLOCK_SIZE_MIN_SECTORS (64 * 1024 >> SECTOR_SHIFT)
> #define DATA_DEV_BLOCK_SIZE_MAX_SECTORS (1024 * 1024 * 1024 >> SECTOR_SHIFT)
>
> why the block size must be between 64KB and 1GB, can I change  the value of DATA_DEV_BLOCK_SIZE_MIN_SECTORS? what effect  if the value of DATA_DEV_BLOCK_SIZE_MIN_SECTORS<128?


Performance reasons mainly - updating metadata much more frequently is 
lowering the throughput considerable.

The other issue is you would also scale up required metadata size.

Zdenek
