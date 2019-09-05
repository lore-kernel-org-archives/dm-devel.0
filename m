From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: sched: make struct task_struct::state 32-bit
Date: Thu, 5 Sep 2019 17:52:32 +0100
Message-ID: <0c4dcb91-4830-0013-b8c6-64b9e1ce47d4@arm.com>
References: <a43fe392-bd6a-71f5-8611-c6b764ba56c3@arm.com>
 <7e3e784c-e8e6-f9ba-490f-ec3bf956d96b@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7e3e784c-e8e6-f9ba-490f-ec3bf956d96b@web.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Markus Elfring <Markus.Elfring@web.de>, Alexey Dobriyan <adobriyan@gmail.com>, dm-devel@redhat.com, linux-block@vger.kernel.org, rcu@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>
List-Id: dm-devel.ids



On 05/09/2019 16:51, Markus Elfring wrote:
> Can a transformation approach like the following work also
> for your software?
> 
> @replacement@
> 
> identifier func, p, state_var;
> 
> @@
> 
>  func(...,
>       struct task_struct *p,
>       ...
> ,
> -     long
> +     int
>       state_var
> ,
>       ...)
> 
>  {
> 
>  ...
> 
>  }
> 
> 

I actually got rid of the task_struct* parameter and now just match
against task_struct.p accesses in the function body, which has the
added bonus of not caring about the order of the parameters.

Still not there yet but making progress in the background, hope it's
passable entertainment to see me struggle my way there :)

> 
> Regards,
> Markus
> 
