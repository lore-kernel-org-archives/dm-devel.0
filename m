From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] dm thin: optimize away writing all zeroes to
 unprovisioned blocks
Date: Fri, 05 Dec 2014 10:27:56 -0700
Message-ID: <5481EB1C.4000202@kernel.dk>
References: <alpine.DEB.2.00.1409301121470.26721@ware.dreamhost.com>
	<alpine.DEB.2.02.1412032237010.12556@ware.dreamhost.com>
	<alpine.DEB.2.02.1412032318290.29609@ware.dreamhost.com>
	<20141204153358.GA19315@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141204153358.GA19315@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Eric Wheeler <ewheeler@ewheeler.net>
Cc: dm-devel@redhat.com, ejt@redhat.com, LVM2 development <lvm-devel@redhat.com>
List-Id: dm-devel.ids

On 12/04/2014 08:33 AM, Mike Snitzer wrote:
>
> Here is a revised patch that is more like I'd expect to land upstream.
> Jens are you OK with us adding bio_is_zero_filled to block/bio.c?  If so
> should I split it out as a separate patch for you to pick up or just
> carry it as part of the patch that lands in linux-dm.git?

Yeah I'm fine with adding that helper. I do wonder what the performance 
impact is on this for dm. Have you tried a (worst case) test of writing 
blocks that are zero filled, but with the last byte not being a zero?

-- 
Jens Axboe
