From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Re: [PATCH v2] dm: add topology support
Date: Wed, 10 Jun 2009 13:58:45 -0400
Message-ID: <yq1ocsw55t6.fsf@sermon.lab.mkp.net>
References: <1244524492-2292-1-git-send-email-snitzer@redhat.com>
	<yq1ski860ok.fsf@sermon.lab.mkp.net>
	<20090610140028.GD25088@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090610140028.GD25088@redhat.com> (Mike Snitzer's message of
	"Wed, 10 Jun 2009 10:00:29 -0400")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> So the question: is _not_ using the blk_queue_*() setters
Mike> perfectly fine?  Given that DM has always _not_ used them the
Mike> quick answer is "seems fine".

Mike> But I need to dig a bit more to understand if the additional logic
Mike> in the blk_queue_*() setters is something DM shouldn't be
Mike> circumventing.

The original intent was that drivers like DM and MD would seed their
limits using the blk_queue* calls before adding any component devices.
blk_stack_limits() would then scale accordingly for every new device
added.

Is there any reason in particular that this approach wouldn't work for
DM?  I.e. set defaults ahead of time instead of doing it upon table
completion using check_for_valid_limits()?

-- 
Martin K. Petersen	Oracle Linux Engineering
