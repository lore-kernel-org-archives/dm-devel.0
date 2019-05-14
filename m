From: Doug Anderson <dianders@chromium.org>
Subject: Re: Problems caused by dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues
Date: Tue, 14 May 2019 15:12:48 -0700
Message-ID: <CAD=FV=VTn7OKOG03YDTjzDPJMYD7ar+HdswHb=VUHm_yp=8vMg@mail.gmail.com>
References: <CAD=FV=VOAjgdrvkK8YKPP-8zqwPpo39rA43JH2BCeYLB0UkgAQ@mail.gmail.com>
 <20190513171519.GA26166@redhat.com> <CAD=FV=X7GDNoJVvRgBTDoVkf9UYA69B-rTY2G3888w=9iS=RtQ@mail.gmail.com>
 <20190514172938.GA31835@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190514172938.GA31835@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tim Murray <timmurray@google.com>, Guenter Roeck <groeck@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Vito Caputo <vcaputo@pengaru.com>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

Hi,

On Tue, May 14, 2019 at 10:29 AM Mike Snitzer <snitzer@redhat.com> wrote:

> > tl;dr: High priority (even without CPU_INTENSIVE) definitely causes
> > interference with my high priority work starving it for > 8 ms, but
> > dm-crypt isn't unique here--loopback devices also have problems.
>
> Well I read it all ;)
>
> I don't have a commit 37a186225a0c, the original commit in querstion is
> a1b89132dc4 right?

commit 37a186225a0c ("platform/chrome: cros_ec_spi: Transfer messages
at high priority") is only really relevant to my particular test case
of using cros_ec to reproduce the problem.


> But I think we need a deeper understanding from workqueue maintainers on
> what the right way forward is here.  I cc'd Tejun in my previous reply
> but IIRC he no longer looks after the workqueue code.
>
> I think it'd be good for you to work with the original author of commit
> a1b89132dc4 (Tim, on cc) to see if you can reach consensus on what works
> for both of your requirements.

Basically what I decided in the end was that the workqueue code didn't
offer enough flexibility in terms of priorities.  To get realtime
priority I needed to fallback to using kthread_create_worker() to
create my worker.  Presumably if you want something nicer than the
"min_nice" priority you get with the high priority workqueue flag then
you'd have to do something similar (but moving in the opposite
direction).


> Given 7 above, if your new "cros_ec at realtime" series fixes it.. ship
> it?

Yeah, that's the plan.  Right now I have
<https://lkml.kernel.org/r/20190514183935.143463-2-dianders@chromium.org>
but Guenter pointed out some embarrassing bugs in my patch so I'll
post up a v4 tomorrow.  I pointed to a Chrome OS review that has a
preview of my v4 if you for some reason can't wait.  That can be found
at <https://crrev.com/c/1612165>.


-Doug
