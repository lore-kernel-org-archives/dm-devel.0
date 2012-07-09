From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: Re: [PATCH] DM MULTIPATH: Allow dm to send
	larger	request if underlying device set to larger max_sectors value
Date: Mon, 9 Jul 2012 12:34:08 +0000
Message-ID: <F200AD42A082BC4088B232D13A916A8907E5DEE3@SACEXCMBX02-PRD.hq.netapp.com>
References: <F200AD42A082BC4088B232D13A916A8907E5DD64@SACEXCMBX02-PRD.hq.netapp.com>
	<20120709010132.GA29375@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120709010132.GA29375@agk-dp.fab.redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "Moger,
	Babu" <Babu.Moger@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>
List-Id: dm-devel.ids

Hi Alasdair,

On July 09, 2012 6:32 AM, Alasdair Wrote:
>
>Why is this separate from dm_set_device_limits?
Ideally it should have been taken care in dm_set_device_limits but to find 
minimum of max_sectors value among physical paths in dm_set_device_limits  seems tricky. 
I will look into it to use dm_set_device_limits.

>Why is this not handled by blk-settings.c?
blk_stack_limits do compare max_sectors between dm & physical path and minimum 
between two values is then set to max_sectors of dm. But if underlying paths 
are set with higher value, dm's max_sectors will be always set to default being 
minimum. Rather objective is to set minimum of max_sectors among underlying paths but 
not exceeding dm's max_hw_max_sectors

>Should max_sectors be preserved across a table reload?
Intentions is to set max_sectors to maximum capable when dm device is created. Even if 
we reset max_sectors_kb from sysfs, restart of multipathd would again reset it to default. 
Not sure if I answered your question.



Thanks,
Vijay
