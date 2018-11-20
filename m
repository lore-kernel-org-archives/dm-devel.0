From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: RFC: REQ_PRIO use
Date: Tue, 20 Nov 2018 06:07:48 +0000
Message-ID: <BN3PR0401MB1640F33FA8F3FFF251DF8266E7D90@BN3PR0401MB1640.namprd04.prod.outlook.com>
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
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

include/linux/blk_types.h states that REQ_PRIO intended use is to boost a
request priority in cfq:

__REQ_PRIO,             /* boost priority in cfq */

REQ_PRIO is used by different file systems (ext4, btrfs, f2fs, gfs2, erofs) and
a couple of dm drivers (bcache and dm-zoned), but nobody actually acts on the
flag being set, certainly not cfq since this scheduler is now gone in 4.21.

I think this mandates some cleanups. I can see 2 options:
1) Have bfq act on this flag
2) Remove it entirely and replace its use with explicit setting of BIOs priority
values, either directly through the struct bio bi_ioprio field or indirectly
through setting the issuer task contecxt iopriority or eventually by adding a
bi_ionice field to struct bio. For instance, ext4 sets its journald task context
I/O priority, which result in all BIOs issued by that task to get an explicit
I/O priority value.

If option (2) is the preferred choice, looking at the current use of REQ_PRIO,
removing this flag does not seem difficult at all. In this case, changes by the
current users to explicitly set BIO I/O priorities can be done later with
different patches.

Comments, thoughts ?

Best regards.

-- 
Damien Le Moal
Western Digital Research
