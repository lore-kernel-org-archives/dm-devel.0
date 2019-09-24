From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: sched: make struct task_struct::state 32-bit
Date: Tue, 24 Sep 2019 10:07:54 +0200
Message-ID: <af969579-116c-fba7-fd32-15a876ac0445@web.de>
References: <a43fe392-bd6a-71f5-8611-c6b764ba56c3@arm.com>
 <7e3e784c-e8e6-f9ba-490f-ec3bf956d96b@web.de>
 <0c4dcb91-4830-0013-b8c6-64b9e1ce47d4@arm.com>
 <32d65b15-1855-e7eb-e9c4-81560fab62ea@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <32d65b15-1855-e7eb-e9c4-81560fab62ea@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Valentin Schneider <valentin.schneider@arm.com>, Alexey Dobriyan <adobriyan@gmail.com>, dm-devel@redhat.com, linux-block@vger.kernel.org, rcu@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

> // FIXME: current not recognized as task_struct*, fixhack with regexp
> identifier current =3D~ "^current$";

Would you really like to use a regular expression for finding a single wor=
d?


> identifier state_var;
> position pos;
> @@
>
> (
>   p->state & state_var@pos
> |
>   current->state & state_var@pos
> |

I see further opportunities to make such a SmPL disjunction more succinct.

*
( ( \( p \| current \) ) -> state & state_var@pos
|
=E2=80=A6

* How do you think about to work with a SmPL constraint
  for a metavariable with the type =E2=80=9Cbinary operator=E2=80=9D?


>   set_current_state(state_var@pos)
> |
>   set_special_state(state_var@pos)

| \( set_current_state \| set_special_state \) (state_var@pos)


> |
>   signal_pending_state(state_var@pos, p)
> |
>   signal_pending_state(state_var@pos, current)

| signal_pending_state(state_var@pos, \( p \| current \) )


Regards,
Markus
