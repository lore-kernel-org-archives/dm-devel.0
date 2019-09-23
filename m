From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: sched: make struct task_struct::state 32-bit
Date: Mon, 23 Sep 2019 13:43:41 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1909231340090.2227@hadrien>
References: <a43fe392-bd6a-71f5-8611-c6b764ba56c3@arm.com> <7e3e784c-e8e6-f9ba-490f-ec3bf956d96b@web.de> <0c4dcb91-4830-0013-b8c6-64b9e1ce47d4@arm.com> <32d65b15-1855-e7eb-e9c4-81560fab62ea@arm.com> <alpine.DEB.2.21.1909231228200.2272@hadrien>
 <d529c390-546e-a8a4-f475-c3ee41f97645@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d529c390-546e-a8a4-f475-c3ee41f97645@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Valentin Schneider <valentin.schneider@arm.com>
Cc: Markus Elfring <Markus.Elfring@web.de>, Alexey Dobriyan <adobriyan@gmail.com>, dm-devel@redhat.com, linux-block@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>
List-Id: dm-devel.ids

> >> // FIXME: match functions that do something with state_var underneath?
> >> // How to do recursive rules?
> >
> > You want to look at the definitions of called functions?  Coccinelle
> > doesn't really support that, but there are hackish ways to add that.  How
> > many function calls would you expect have to be unrolled?
> >
>
> I wouldn't expect more than a handful (~5). I suppose this has to do with
> injecting some Python/Ocaml code? I have some examples bookmarked but
> haven't gotten to stare at them long enough.

You can look at iteration.cocci, but it's a bit complex.

You could match definitions of functions that do what you are interested
in, then store the names of these functions in a list (python/ocaml), and
then look for calls to those functions.  Something like

identifier fn : script:ocaml() { in_my_list fn };

> >> // Fixup local variables
> >> @depends on patch && state_access@
> >> identifier state_var = state_access.state_var;
> >> @@
> >> (
> >> - long
> >> + int
> >> |
> >> - unsigned long
> >> + unsigned int
> >> )
> >> state_var;
> >>
> >> // Fixup function parameters
> >> @depends on patch && state_access@
> >> identifier fn;
> >> identifier state_var = state_access.state_var;
> >> @@
> >>
> >> fn(...,
> >> - long state_var
> >> + int state_var
> >> ,...)
> >> {
> >> 	...
> >> }
> >>
> >> // FIXME: find a way to squash that with the above?
> >
> > I think that you can make a disjunction on a function parameter
> >
> > fn(...,
> > (
> > - T1 x1
> > + T2 x2
> > |
> > - T3 x3
> > + T4 x4
> > )
> > , ...) { ... }
> >
>
> My attempt at this gives me "minus: parse error", which is why I went
> with the split.

OK, the split is probably not a major catastrophe...

julia

>
> Something simple like this works:
> ---
> virtual patch
> virtual report
>
> @@
> identifier fn;
> identifier p;
> @@
>
> fn(...,
> - long
> + int
> p
> ,...)
> {
> 	...
> }
> ---
>
> but this doesn't:
> ---
> virtual patch
> virtual report
>
> @@
> identifier fn;
> identifier p;
> @@
>
> fn(...,
> (
> - long p
> + int p
> |
> - unsigned long p
> + unsigned int p
> )
> ,...)
> {
> 	...
> }
> ---
>
> > julia
> >
>
