From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH] sched: make struct task_struct::state 32-bit
Date: Tue, 3 Sep 2019 22:51:30 +0100
Message-ID: <92ead22e-0580-c720-1a29-7db79d76f7d7@arm.com>
References: <20190902210558.GA23013@avx2>
 <d8ad0be1-4ed7-df74-d415-2b1c9a44bac7@arm.com> <20190903181920.GA22358@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190903181920.GA22358@avx2>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, aarcange@redhat.com
List-Id: dm-devel.ids

On 03/09/2019 19:19, Alexey Dobriyan wrote:
> On Tue, Sep 03, 2019 at 06:29:06PM +0100, Valentin Schneider wrote:
>> On 02/09/2019 22:05, Alexey Dobriyan wrote:
>>> 32-bit accesses are shorter than 64-bit accesses on x86_64.
>>> Nothing uses 64-bitness of ->state.
> 
>> It looks like you missed a few places. There's a long prev_state in
>> sched/core.c::finish_task_switch() for instance.
>>
>> I suppose that's where coccinelle oughta help but I'm really not fluent
>> in that. Is there a way to make it match p.state accesses with p task_struct?
>> And if so, can we make it change the type of the variable being read from
>> / written to?
> 
> Coccinelle is interesting: basic
> 
> 	- foo
> 	+ bar
> 
> doesn't find "foo" in function arguments.
> 
> I'm scared of coccinelle.> 

So am I, but I'm even more scared of having no other way of verifying this
than doing it "by hand". It's nothing critical here - just some variables
that will remain long instead of being int, but I'd like to have some way to
verify the change. A coccinelle script would be great, even if it misses
some places, I can at least have some trust in it.

If I have to verify the whole tree by hand, even with grep/ag, I don't trust
I'll do it right.


I gave Coccinelle a try, I think I got something for in-function variables:

---
@state_var@
struct task_struct *p;
identifier prev_state;
@@
prev_state = p->state

@@
identifier state_var.prev_state;
@@
- long prev_state;
+ int prev_state;
---

I tried something for function parameters, which seems to be feasible
according to [1], but couldn't get it to work (yet). Here's what I have
so far:

---
@func_param@
identifier func;
identifier p;
identifier state;
identifier mask;
@@

func(struct task_struct *p, const struct cpumask *mask, long state)
{
...
}

@@
identifier func_param.func;
identifier func_param.state;
expression E1;
expression E2;
@@

func(E1,
- long state,
+ int state,
E2)
---

(it should match against kernel/kthread.c::__kthread_bind_mask() but it
complains about me not knowing how to write coccinelle patches).

With a mix of these we might get somewhere...

[1]: http://coccinelle.lip6.fr/docs/main_grammar016.html

>> How did you come up with this changeset, did you pickaxe for some regexp?
> 
> No, manually, backtracking up to the call chain.
> Maybe I missed a few places.
> 
