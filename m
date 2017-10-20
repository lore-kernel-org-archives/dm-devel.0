From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 1/4] bcache: convert cached_dev.count from atomic_t to
 refcount_t
Date: Fri, 20 Oct 2017 11:39:42 -0700
Message-ID: <8bd05fae-d41f-24e7-4e58-bf07d9a09a99@lyle.org>
References: <1508485059-21881-1-git-send-email-elena.reshetova@intel.com>
 <1508485059-21881-2-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508485059-21881-2-git-send-email-elena.reshetova@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Elena Reshetova <elena.reshetova@intel.com>, dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, kent.overstreet@gmail.com, koverstreet@google.com, ejt@redhat.comg, snitzer@redhat.com, shli@kernel.org, agk@redhat.com, peterz@infradead.org, keescook@chromium.org
List-Id: dm-devel.ids

On 10/20/2017 12:37 AM, Elena Reshetova wrote:
> atomic_t variables are currently used to implement reference
> counters with the following properties:
>  - counter is initialized to 1 using atomic_set()
>  - a resource is freed upon counter reaching zero
>  - once counter reaches zero, its further
>    increments aren't allowed
>  - counter schema uses basic atomic operations
>    (set, inc, inc_not_zero, dec_and_test, etc.)
> 
> Such atomic variables should be converted to a newly provided
> refcount_t type and API that prevents accidental counter overflows
> and underflows. This is important since overflows and underflows
> can lead to use-after-free situation and be exploitable.
> 
> The variable cached_dev.count is used as pure reference counter.
> Convert it to refcount_t and fix up the operations.
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: David Windsor <dwindsor@gmail.com>
> Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>

Reviewed-by: Michael Lyle <mlyle@lyle.org>

Thanks for this-- I'm including it in my tree for possible inclusion in
4.15 (I've already sent my main chunk of changes upwards).

Mike
