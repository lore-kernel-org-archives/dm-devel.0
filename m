From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH] sched: make struct task_struct::state 32-bit
Date: Wed, 4 Sep 2019 18:48:49 +0100
Message-ID: <f0328a66-ca9f-974d-3799-e73308fb1d34@arm.com>
References: <20190902210558.GA23013@avx2>
 <d8ad0be1-4ed7-df74-d415-2b1c9a44bac7@arm.com> <20190903181920.GA22358@avx2>
 <92ead22e-0580-c720-1a29-7db79d76f7d7@arm.com>
 <a43fe392-bd6a-71f5-8611-c6b764ba56c3@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a43fe392-bd6a-71f5-8611-c6b764ba56c3@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, aarcange@redhat.com
List-Id: dm-devel.ids

On 04/09/2019 13:07, Valentin Schneider wrote:
> [...]
> Baby steps...


There's something regarding coccinelle disjunctions that just can't grasp,
and this also fails to recognize "current" as being "struct task_struct*".

Once I fix these, it's "just" a matter of finding out how to write a rule
for layered calls (e.g. __kthread_bind() -> __kthread_bind_mask() ->
wait_task_inactive()), and we should be close to having something somewhat
usable.

---
virtual patch
virtual report

@state_access@
identifier func;
struct task_struct *p;
identifier state_var;
position fpos;
position epos;
@@

func(...)@fpos
{
	<...
(
  p->state & state_var@epos
|
  p->state | state_var@epos
|
  p->state < state_var@epos
|
  p->state > state_var@epos
|
  state_var@epos = p->state
// For some reason adding this disjunction gives us more matches, but causes
// some to go away :/
// |
//   p->state == state_var@epos
|
  p->state != state_var@epos
)
	...>
}

@depends on patch@
identifier fn = state_access.func;
identifier state_var = state_access.state_var;
@@

fn(...,
- long state_var
+ int state_var
,...)
{
	...
}

// Should be merged in the above but can't get disjunction to work
@depends on patch@
identifier fn = state_access.func;
identifier state_var = state_access.state_var;
@@

fn(...,
- unsigned long state_var
+ unsigned int state_var
,...)
{
	...
}

// Is it possible to match without semicolons? :/
@depends on patch@
identifier state_var = state_access.state_var;
expression E;
@@

(
- long state_var;
+ int state_var;
|
- long state_var = E;
+ int state_var = E;
)

@script:python depends on report@
fp << state_access.fpos;
ep << state_access.epos;
@@
cocci.print_main("Func at", fp)
cocci.print_main("Expr at", ep)
