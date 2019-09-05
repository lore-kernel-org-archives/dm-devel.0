From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: sched: make struct task_struct::state 32-bit
Date: Thu, 5 Sep 2019 17:51:45 +0200
Message-ID: <7e3e784c-e8e6-f9ba-490f-ec3bf956d96b@web.de>
References: <a43fe392-bd6a-71f5-8611-c6b764ba56c3@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a43fe392-bd6a-71f5-8611-c6b764ba56c3@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Valentin Schneider <valentin.schneider@arm.com>, Alexey Dobriyan <adobriyan@gmail.com>, dm-devel@redhat.com, linux-block@vger.kernel.org, rcu@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>
List-Id: dm-devel.ids

> @funcmatch@
> identifier func;
> identifier p;
> identifier state_var;
> @@
>
>   func(..., struct task_struct *p, ...
> -      , long state_var
> +      , int state_var
>        ,...)
> {
> 	...
> }
=E2=80=A6
> Which seems to be doing roughly what I want.

Can a transformation approach like the following work also
for your software?

@replacement@

identifier func, p, state_var;

@@

 func(...,
      struct task_struct *p,
      ...
,
-     long
+     int
      state_var
,
      ...)

 {

 ...

 }



Regards,
Markus
