From: Jens Axboe <axboe@kernel.dk>
Subject: Re: limits->max_sectors is getting set to 0,
 why/where? [was: Re: dm: kernel oops by divide error on v4.16+]
Date: Mon, 9 Apr 2018 18:31:22 -0600
Message-ID: <19ce840a-2466-2af0-394c-eb19c4c10ee4@kernel.dk>
References: <20180408040005.GA19128@ming.t460p>
	<20180409155120.GA10990@redhat.com> <20180409183836.GA11256@redhat.com>
	<db4499d6-05b8-73f3-76d0-a91af91430b0@kernel.dk>
	<70f1d349-f091-19a2-9ec6-978ac1e7dda0@kernel.dk>
	<78732cb7-3666-e1b0-e6d3-2a3409a0d4ca@kernel.dk>
	<CAGXu5j+81yUffU4=7h4goQYx_pWwvv6wtwrLy4sx6H=AGmK3ZQ@mail.gmail.com>
	<ddc93069-1ccd-d867-6c8d-6fd429bc2080@kernel.dk>
	<20180409222716.GA6450@ming.t460p>
	<911ff78b-5b60-e05c-de88-8077d502290a@kernel.dk>
	<CA+55aFyRyL0WbEvXKSdRyFnYW6KKYr0vartCeK3pkkcLeV3mMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+55aFyRyL0WbEvXKSdRyFnYW6KKYr0vartCeK3pkkcLeV3mMA@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>, linux-block <linux-block@vger.kernel.org>, Chris Mason <clm@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 4/9/18 5:54 PM, Linus Torvalds wrote:
> On Mon, Apr 9, 2018 at 3:32 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> The resulting min/max and friends would have been trivial to test, but
>> clearly they weren't.
> 
> Well, the min/max macros themselves actually were tested in user space by me.
> 
> It was the interaction with the unrelated "min_not_zero()" that wasn't ;)
> 
> It's easy in hind-sight to say "that's not at all unrelated", but
> within the context of doing min/max, it was.

I guess we should just be thankful that it didn't cause bigger issues
than an oops.

-- 
Jens Axboe
