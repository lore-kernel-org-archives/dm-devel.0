From: "lilofile" <lilofile@aliyun.com>
Subject: =?utf-8?q?dm-thin?=
Date: Tue, 21 Oct 2014 09:36:27 +0800
Message-ID: <20b42a29-27ce-4395-9cd9-843f2acfcab2@aliyun.com>
References: <alpine.LRH.2.02.1410131113450.3569@file01.intranet.prod.int.rdu2.redhat.com>	<20141013162026.GA4631@redhat.com>,
	alpine.LRH.2.02.1410131643100.11699@file01.intranet.prod.int.rdu2.redhat.com,
	9ac8b012-7ca4-4a21-9d75-024820083b4c@aliyun.com
Reply-To: lilofile <lilofile@aliyun.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: 9ac8b012-7ca4-4a21-9d75-024820083b4c@aliyun.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, lilofile <lilofile@aliyun.com>
Cc: Ondrej Kozina <okozina@redhat.com>, axboe <axboe@kernel.dk>, dm-devel <dm-devel@redhat.com>, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

In dm-thin.c,
/*
 * The block size of the device holding pool data must be
 * between 64KB and 1GB.
 */
#define DATA_DEV_BLOCK_SIZE_MIN_SECTORS (64 * 1024 >> SECTOR_SHIFT)
#define DATA_DEV_BLOCK_SIZE_MAX_SECTORS (1024 * 1024 * 1024 >> SECTOR_SHIFT)

why the block size must be between 64KB and 1GB, can I change  the value of DATA_DEV_BLOCK_SIZE_MIN_SECTORS? what effect  if the value of DATA_DEV_BLOCK_SIZE_MIN_SECTORS<128?
