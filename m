From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] dm: add topology support
Date: Fri, 05 Jun 2009 00:33:01 -0400
Message-ID: <yq17hzrl2pu.fsf@sermon.lab.mkp.net>
References: <1244059149-14279-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1244059149-14279-1-git-send-email-snitzer@redhat.com> (Mike
	Snitzer's message of "Wed, 3 Jun 2009 15:59:09 -0400")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, agk@redhat.com, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike,

+	if (blk_stack_limits(&ti->limits, &q->limits, 0) < 0)
+		DMWARN("%s: target device %s is misaligned",
+		       dm_device_name(ti->table->md), bdevname(bdev, b));

I did some testing tonight.  You're always passing offset 0 into the
stacking function so things are not working right.  This argument should
contain the offset to the first (data) sector.  So you want something
like get_start_sect(bdev) << 9 for the stacking to do its magic.

-- 
Martin K. Petersen	Oracle Linux Engineering
