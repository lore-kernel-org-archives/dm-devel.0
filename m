From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] block: Move non-rotational flag to queue limits
Date: Tue, 31 May 2011 10:28:01 -0400
Message-ID: <yq1d3izx7v2.fsf@sermon.lab.mkp.net>
References: <4DDEA689.2090004@fusionio.com>
	<1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
	<1306464169-4291-3-git-send-email-martin.petersen@oracle.com>
	<20110527130248.GA17219@redhat.com>
	<yq1k4d7zk56.fsf@sermon.lab.mkp.net> <4DE4E9A6.8060006@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DE4E9A6.8060006@fusionio.com> (Jens Axboe's message of "Tue, 31
	May 2011 15:14:14 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "msb@chromium.org" <msb@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:

Jens> On 2011-05-31 04:19, Martin K. Petersen wrote:
>> - queue_flag_set_unlocked(QUEUE_FLAG_NONROT, disk->queue);
>> + blk_queue_non_rotational(queue);

Jens> I don't like this part of the change. Before it was immediately
Jens> apparently that we were setting this flag, know you have no idea
Jens> what it does. Please make that blk_queue_set_non_rotational().

I was just trying to mimic the rest of the topology calls.

How about:

  blk_queue_rotational(q, BLK_QUEUE_ROTATIONAL|BLK_QUEUE_NON_ROTATIONAL)

Doing it that way would make the code clearer a few places too, I
think...

-- 
Martin K. Petersen	Oracle Linux Engineering
