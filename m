From: Doug Anderson <dianders@chromium.org>
Subject: Re: Problems caused by dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues
Date: Tue, 14 May 2019 09:47:10 -0700
Message-ID: <CAD=FV=X7GDNoJVvRgBTDoVkf9UYA69B-rTY2G3888w=9iS=RtQ@mail.gmail.com>
References: <CAD=FV=VOAjgdrvkK8YKPP-8zqwPpo39rA43JH2BCeYLB0UkgAQ@mail.gmail.com>
 <20190513171519.GA26166@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190513171519.GA26166@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tim Murray <timmurray@google.com>, Guenter Roeck <groeck@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Vito Caputo <vcaputo@pengaru.com>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

Hi,

On Mon, May 13, 2019 at 10:15 AM Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, May 13 2019 at 12:18pm -0400,
> Doug Anderson <dianders@chromium.org> wrote:
>
> > Hi,
> >
> > I wanted to jump on the bandwagon of people reporting problems with
> > commit a1b89132dc4f ("dm crypt: use WQ_HIGHPRI for the IO and crypt
> > workqueues").
> >
> > Specifically I've been tracking down communication errors when talking
> > to our Embedded Controller (EC) over SPI.  I found that communication
> > errors happened _much_ more frequently on newer kernels than older
> > ones.  Using ftrace I managed to track the problem down to the dm
> > crypt patch.  ...and, indeed, reverting that patch gets rid of the
> > vast majority of my errors.
> >
> > If you want to see the ftrace of my high priority worker getting
> > blocked for 7.5 ms, you can see:
> >
> > https://bugs.chromium.org/p/chromium/issues/attachmentText?aid=392715
> >
> >
> > In my case I'm looking at solving my problems by bumping the CrOS EC
> > transfers fully up to real time priority.  ...but given that there are
> > other reports of problems with the dm-crypt priority (notably I found
> > https://bugzilla.kernel.org/show_bug.cgi?id=199857) maybe we should
> > also come up with a different solution for dm-crypt?
> >
>
> And chance you can test how behaviour changes if you remove
> WQ_CPU_INTENSIVE? e.g.:
>
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 692cddf3fe2a..c97d5d807311 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2827,8 +2827,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>
>         ret = -ENOMEM;
>         cc->io_queue = alloc_workqueue("kcryptd_io/%s",
> -                                      WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
> -                                      1, devname);
> +                                      WQ_HIGHPRI | WQ_MEM_RECLAIM, 1, devname);
>         if (!cc->io_queue) {
>                 ti->error = "Couldn't create kcryptd io queue";
>                 goto bad;
> @@ -2836,11 +2835,10 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>
>         if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
>                 cc->crypt_queue = alloc_workqueue("kcryptd/%s",
> -                                                 WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
> -                                                 1, devname);
> +                                                 WQ_HIGHPRI | WQ_MEM_RECLAIM, 1, devname);
>         else
>                 cc->crypt_queue = alloc_workqueue("kcryptd/%s",
> -                                                 WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
> +                                                 WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_UNBOUND,
>                                                   num_online_cpus(), devname);
>         if (!cc->crypt_queue) {
>                 ti->error = "Couldn't create kcryptd queue";

It's not totally trivially easy for me to test.  My previous failure
cases were leaving a few devices "idle" over a long period of time.  I
did that on 3 machines last night and didn't see any failures.  Thus
removing "WQ_CPU_INTENSIVE" may have made things better.  Before I say
for sure I'd want to test for longer / redo the test a few times,
since I've seen the problem go away on its own before (just by
timing/luck) and then re-appear.

Do you have a theory about why removing WQ_CPU_INTENSIVE would help?

---

NOTE: in trying to reproduce problems more quickly I actually came up
with a better test case for the problem I was seeing.  I found that I
can reproduce my own problems much better with this test:

  dd if=/dev/zero of=/var/log/foo.txt bs=4M count=512&
  while true; do
    ectool version > /dev/null;
  done

It should be noted that "/var" is on encrypted stateful on my system
so throwing data at it stresses dm-crypt.  It should also be noted
that somehow "/var" also ends up traversing through a loopback device
(this becomes relevant below):


With the above test:

1. With a mainline kernel that has commit 37a186225a0c
("platform/chrome: cros_ec_spi: Transfer messages at high priority"):
I see failures.

2. With a mainline kernel that has commit 37a186225a0c plus removing
WQ_CPU_INTENSIVE in dm-crypt: I still see failures.

3. With a mainline kernel that has commit 37a186225a0c plus removing
high priority (but keeping CPU intensive) in dm-crypt: I still see
failures.

4. With a mainline kernel that has commit 37a186225a0c plus removing
high priority (but keeping CPU intensive) in dm-crypt plus removing
set_user_nice() in loop_prepare_queue(): I get a pass!

5. With a mainline kernel that has commit 37a186225a0c plus removing
set_user_nice() in loop_prepare_queue() plus leaving dm-crypt alone: I
see failures.

6. With a mainline kernel that has commit 37a186225a0c plus removing
set_user_nice() in loop_prepare_queue() plus removing WQ_CPU_INTENSIVE
in dm-crypt: I still see failures

7. With my new "cros_ec at realtime" series and no other patches, I get a pass!


tl;dr: High priority (even without CPU_INTENSIVE) definitely causes
interference with my high priority work starving it for > 8 ms, but
dm-crypt isn't unique here--loopback devices also have problems.


-Doug
