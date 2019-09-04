From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH] sched: make struct task_struct::state 32-bit
Date: Wed, 4 Sep 2019 13:07:18 +0100
Message-ID: <a43fe392-bd6a-71f5-8611-c6b764ba56c3@arm.com>
References: <20190902210558.GA23013@avx2>
 <d8ad0be1-4ed7-df74-d415-2b1c9a44bac7@arm.com> <20190903181920.GA22358@avx2>
 <92ead22e-0580-c720-1a29-7db79d76f7d7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <92ead22e-0580-c720-1a29-7db79d76f7d7@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, aarcange@redhat.com
List-Id: dm-devel.ids

On 03/09/2019 22:51, Valentin Schneider wrote:
[...]
> I tried something for function parameters, which seems to be feasible
> according to [1], but couldn't get it to work (yet). Here's what I have
> so far:
> 
[...]

So now I have this:

---
@funcmatch@
identifier func;
identifier p;
identifier state_var;
@@

  func(..., struct task_struct *p, ...
-      , long state_var
+      , int state_var
       ,...)
{
	...
}
---

Which seems to be doing roughly what I want. I probably need another
version to cover functions with reverse parameter order, and also need
to make it match functions that assign state_var to p->state (or pass it
down to another function that might do it).

Baby steps...
