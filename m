From: Kees Cook <keescook@chromium.org>
Subject: Re: limits->max_sectors is getting set to 0,
 why/where? [was: Re: dm: kernel oops by divide error on v4.16+]
Date: Mon, 9 Apr 2018 15:38:00 -0700
Message-ID: <CAGXu5jJD0b15a2yBUEiTT=Kjy2cLTVWCqhsnVZu5aKf-ieyZ+A@mail.gmail.com>
References: <20180408040005.GA19128@ming.t460p>
	<20180409155120.GA10990@redhat.com>
	<20180409183836.GA11256@redhat.com>
	<db4499d6-05b8-73f3-76d0-a91af91430b0@kernel.dk>
	<70f1d349-f091-19a2-9ec6-978ac1e7dda0@kernel.dk>
	<78732cb7-3666-e1b0-e6d3-2a3409a0d4ca@kernel.dk>
	<CAGXu5j+81yUffU4=7h4goQYx_pWwvv6wtwrLy4sx6H=AGmK3ZQ@mail.gmail.com>
	<ddc93069-1ccd-d867-6c8d-6fd429bc2080@kernel.dk>
	<20180409222716.GA6450@ming.t460p>
	<911ff78b-5b60-e05c-de88-8077d502290a@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <911ff78b-5b60-e05c-de88-8077d502290a@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-block@vger.kernel.org, Chris Mason <clm@fb.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Mon, Apr 9, 2018 at 3:32 PM, Jens Axboe <axboe@kernel.dk> wrote:
> That's bad, for sure, but my worry was bigger than an oops or crash,
> we could have had corruption due to this.
>
> The resulting min/max and friends would have been trivial to test, but
> clearly they weren't.

Yeah, that was bad luck and my fault: I tested min(), max(), min_t(),
and max_t(). My assumption was that since the others were built from
them, they'd be fine. Not true in this shadow variable case, though.
:(  We could do something like this, which would have caught it:


diff --git a/init/main.c b/init/main.c
index e4a3160991ea..ce46afc53b8b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -993,10 +993,32 @@ static inline void mark_readonly(void)
 }
 #endif

+static inline void compiletime_sanity_checks(void)
+{
+       /* Sanity-check min()/max() family of macros. */
+       BUILD_BUG_ON(min(5, 50) != 5);
+       BUILD_BUG_ON(max(5, 50) != 50);
+       BUILD_BUG_ON(min_t(int, (size_t)-1 , 50) != -1);
+       BUILD_BUG_ON(max_t(size_t, -1 , 50) != (size_t)-1);
+       BUILD_BUG_ON(min3(-50, 0, 1000) != -50);
+       BUILD_BUG_ON(max3(-50, 0, 1000) != 1000);
+       BUILD_BUG_ON(min_not_zero(0, 20) != 20);
+       BUILD_BUG_ON(min_not_zero(30, 0) != 30);
+       BUILD_BUG_ON(min_not_zero(150, 40) != 40);
+       BUILD_BUG_ON(clamp(20, 1, 7) != 7);
+       BUILD_BUG_ON(clamp(40, 20, 100) != 40);
+       BUILD_BUG_ON(clamp(1, 20, 100) != 20);
+       BUILD_BUG_ON(clamp_t(int, -5, (size_t)-1, 100) != -1);
+       BUILD_BUG_ON(clamp_t(int, -1, (size_t)-5, 100) != -1);
+       BUILD_BUG_ON(clamp_t(size_t, -10, 1, -50) != -50);
+}
+
 static int __ref kernel_init(void *unused)
 {
        int ret;

+       compiletime_sanity_checks();
+
        kernel_init_freeable();
        /* need to finish all async __init code before freeing the memory */
        async_synchronize_full();



-- 
Kees Cook
Pixel Security
