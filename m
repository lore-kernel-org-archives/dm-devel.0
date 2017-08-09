From: Jens Axboe <axboe@kernel.dk>
Subject: Re: integrity regression fixes for 4.13-rc
Date: Wed, 9 Aug 2017 09:59:56 -0600
Message-ID: <52b6068c-9f13-020a-1a3f-f4ecfebd92fd@kernel.dk>
References: <20170809154727.2085-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170809154727.2085-1-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: mpatocka@redhat.com, gmazyland@gmail.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/09/2017 09:47 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series fixes regressions in the integrity handling update in 4.13-rc.
> 
> The first one was sent earlier by Milan and while both Martin and I aren't
> exactly happy about the way dm uses the integrity code to cause this
> regression this minimal fix gets us back to the status quo.
> 
> The second one makes sure that we only verify the DIF checksums on the
> lowest layer where we attach the integrity information.

Thanks, I was waiting on these. Applied for 4.13. I did just ship off
a pull request, but I'll get this in for the next -rc.

-- 
Jens Axboe
