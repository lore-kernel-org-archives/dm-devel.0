From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] md: Convert timers to use timer_setup()
Date: Wed, 18 Oct 2017 20:06:03 -0700
Message-ID: <CAGXu5jLQVmS_7wA3z3W8590d-adNHMNY5yp5WsiSx3EiwTsfRQ@mail.gmail.com>
References: <20171017000148.GA102867@beast> <390e7ce2-fda1-ad11-6c96-0ea44615c845@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <390e7ce2-fda1-ad11-6c96-0ea44615c845@lyle.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Michael Lyle <mlyle@lyle.org>, Shaohua Li <shli@fb.com>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Oct 16, 2017 at 8:06 PM, Michael Lyle <mlyle@lyle.org> wrote:
> On 10/16/2017 05:01 PM, Kees Cook wrote:
>> In preparation for unconditionally passing the struct timer_list pointer to
>> all timer callbacks, switch to using the new timer_setup() and from_timer()
>> to pass the timer pointer explicitly.
>>
>> Cc: Kent Overstreet <kent.overstreet@gmail.com>
>> Cc: Shaohua Li <shli@kernel.org>
>> Cc: Alasdair Kergon <agk@redhat.com>
>> Cc: Mike Snitzer <snitzer@redhat.com>
>> Cc: dm-devel@redhat.com
>> Cc: linux-bcache@vger.kernel.org
>> Cc: linux-raid@vger.kernel.org
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> This looks good to me-- I'm fine with Jens or someone else picking this
> up directly, or would take a bcache-specific one to apply to my tree.
>
> Reviewed-by: Michael Lyle <mlyle@lyle.org>

Jens, can you pick this up, or would you prefer I split it up?

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
