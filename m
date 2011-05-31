From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 2/3] block: Move non-rotational flag to queue limits
Date: Tue, 31 May 2011 15:14:14 +0200
Message-ID: <4DE4E9A6.8060006@fusionio.com>
References: <4DDEA689.2090004@fusionio.com>	<1306464169-4291-1-git-send-email-martin.petersen@oracle.com>	<1306464169-4291-3-git-send-email-martin.petersen@oracle.com>	<20110527130248.GA17219@redhat.com> <yq1k4d7zk56.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1k4d7zk56.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, "msb@chromium.org" <msb@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2011-05-31 04:19, Martin K. Petersen wrote:
> -               queue_flag_set_unlocked(QUEUE_FLAG_NONROT, disk->queue);
> +               blk_queue_non_rotational(queue);

I don't like this part of the change. Before it was immediately
apparently that we were setting this flag, know you have no idea what it
does. Please make that blk_queue_set_non_rotational().

Otherwise looks fine.

-- 
Jens Axboe
