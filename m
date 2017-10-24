From: Jens Axboe <axboe@kernel.dk>
Subject: Re: md: Convert timers to use timer_setup()
Date: Tue, 24 Oct 2017 12:18:31 -0600
Message-ID: <2bc9aabb-4ee5-c176-13be-a540a2fa8c62@kernel.dk>
References: <20171017000148.GA102867@beast>
 <390e7ce2-fda1-ad11-6c96-0ea44615c845@lyle.org>
 <CAGXu5jLQVmS_7wA3z3W8590d-adNHMNY5yp5WsiSx3EiwTsfRQ@mail.gmail.com>
 <D294B3CB-45BC-49B2-A9DD-AB0A01CCB444@kernel.dk>
 <20171024181555.GA22647@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20171024181555.GA22647@redhat.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@fb.com>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 10/24/2017 12:15 PM, Mike Snitzer wrote:
> On Wed, Oct 18 2017 at 11:12pm -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>>
>>> On Oct 18, 2017, at 9:06 PM, Kees Cook <keescook@chromium.org> wrote:
>>>
>>>> On Mon, Oct 16, 2017 at 8:06 PM, Michael Lyle <mlyle@lyle.org> wrote:
>>>>> On 10/16/2017 05:01 PM, Kees Cook wrote:
>>>>> In preparation for unconditionally passing the struct timer_list pointer to
>>>>> all timer callbacks, switch to using the new timer_setup() and from_timer()
>>>>> to pass the timer pointer explicitly.
>>>>>
>>>>> Cc: Kent Overstreet <kent.overstreet@gmail.com>
>>>>> Cc: Shaohua Li <shli@kernel.org>
>>>>> Cc: Alasdair Kergon <agk@redhat.com>
>>>>> Cc: Mike Snitzer <snitzer@redhat.com>
>>>>> Cc: dm-devel@redhat.com
>>>>> Cc: linux-bcache@vger.kernel.org
>>>>> Cc: linux-raid@vger.kernel.org
>>>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>>>
>>>> This looks good to me-- I'm fine with Jens or someone else picking this
>>>> up directly, or would take a bcache-specific one to apply to my tree.
>>>>
>>>> Reviewed-by: Michael Lyle <mlyle@lyle.org>
>>>
>>> Jens, can you pick this up, or would you prefer I split it up?
> 
> Jens, would you be OK picking it up from patchwork?  If so, see:
> https://patchwork.kernel.org/patch/10010303/
> 
> You can add mine too:
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Done, thanks all.

-- 
Jens Axboe
