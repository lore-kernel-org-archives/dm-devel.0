From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Thu, 07 Jan 2010 12:15:00 -0500
Message-ID: <yq1hbqxsup7.fsf@sermon.lab.mkp.net>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
	<20100105182735.GC6042@agk-dp.fab.redhat.com>
	<yq1637gt1hi.fsf@sermon.lab.mkp.net>
	<20100106025731.GA16154@redhat.com>
	<yq11vi3ud84.fsf@sermon.lab.mkp.net>
	<20100106041050.GA21438@redhat.com>
	<yq1wrzvswaa.fsf@sermon.lab.mkp.net>
	<20100106051605.GB21438@redhat.com>
	<yq1pr5nsk3z.fsf@sermon.lab.mkp.net>
	<20100106132508.GA3589@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100106132508.GA3589@redhat.com> (Mike Snitzer's message of
	"Wed, 6 Jan 2010 08:25:08 -0500")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> However, there are other subsystems that need to stack without an
>> associated block_device.  So instead of changing blk_stack_limits I
>> propose we use the wrapper below.

Mike> Yes, looks like osdblk.c's use of blk_queue_stack_limits()

DM also does a stacking pass without a bdev (dm_calculate_queue_limits),
although I think you can avoid that by getting rid of ti_limits
altogether and just stack limits.

I couldn't figure out why the alignment_offset for a misaligned DM
device was zero, despite being -1 after stacking had completed.  I
finally spotted this in dm_table_set_restrictions():

        limits->alignment_offset = 0;
        limits->misaligned = 0;

So after all the stacking function's hard work you set the alignment to
0 and clear the misaligned flag.  Why?

-- 
Martin K. Petersen	Oracle Linux Engineering
