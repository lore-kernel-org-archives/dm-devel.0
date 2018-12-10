From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v4 0/7] per-cpu in_flight counters for
	bio-based drivers
Date: Mon, 10 Dec 2018 08:35:24 -0700
Message-ID: <2dc7bd99-200b-6239-f604-c071c2de55a1@kernel.dk>
References: <20181206164122.2166-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181206164122.2166-1-snitzer@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 6, 2018 at 9:41 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> Hey,
>
> This v4 addresses the compile issues on various archs when CONFIG_SMP
> isn't set (by introducing appropriate wrappers in genhd.h)
>
> Testing with this v4 I was unable to reproduce the issue you reported
> where iostat always reports 0 for avgqu-sz -- but please let me know
> if you still see problems like that.

Looks good to me, and also passes my testing. Dropped the mq special
cases and used this in general, also works fine. I was hoping we could
get rid of the tag iteration with this, but that still seems to be more
efficient for blk-mq. But at least we're better off for stacked devices
with this.

-- 
Jens Axboe
