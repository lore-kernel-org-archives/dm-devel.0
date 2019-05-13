From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Problems caused by dm crypt: use WQ_HIGHPRI for the IO and crypt
 workqueues
Date: Mon, 13 May 2019 13:15:19 -0400
Message-ID: <20190513171519.GA26166@redhat.com>
References: <CAD=FV=VOAjgdrvkK8YKPP-8zqwPpo39rA43JH2BCeYLB0UkgAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAD=FV=VOAjgdrvkK8YKPP-8zqwPpo39rA43JH2BCeYLB0UkgAQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Anderson <dianders@chromium.org>
Cc: Tim Murray <timmurray@google.com>, Guenter Roeck <groeck@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Vito Caputo <vcaputo@pengaru.com>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, tj@kernel.org
List-Id: dm-devel.ids

On Mon, May 13 2019 at 12:18pm -0400,
Doug Anderson <dianders@chromium.org> wrote:

> Hi,
> 
> I wanted to jump on the bandwagon of people reporting problems with
> commit a1b89132dc4f ("dm crypt: use WQ_HIGHPRI for the IO and crypt
> workqueues").
> 
> Specifically I've been tracking down communication errors when talking
> to our Embedded Controller (EC) over SPI.  I found that communication
> errors happened _much_ more frequently on newer kernels than older
> ones.  Using ftrace I managed to track the problem down to the dm
> crypt patch.  ...and, indeed, reverting that patch gets rid of the
> vast majority of my errors.
> 
> If you want to see the ftrace of my high priority worker getting
> blocked for 7.5 ms, you can see:
> 
> https://bugs.chromium.org/p/chromium/issues/attachmentText?aid=392715
> 
> 
> In my case I'm looking at solving my problems by bumping the CrOS EC
> transfers fully up to real time priority.  ...but given that there are
> other reports of problems with the dm-crypt priority (notably I found
> https://bugzilla.kernel.org/show_bug.cgi?id=199857) maybe we should
> also come up with a different solution for dm-crypt?
> 

And chance you can test how behaviour changes if you remove
WQ_CPU_INTENSIVE? e.g.:

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 692cddf3fe2a..c97d5d807311 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2827,8 +2827,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ret = -ENOMEM;
 	cc->io_queue = alloc_workqueue("kcryptd_io/%s",
-				       WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
-				       1, devname);
+				       WQ_HIGHPRI | WQ_MEM_RECLAIM, 1, devname);
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
 		goto bad;
@@ -2836,11 +2835,10 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
 		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
-						  WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
-						  1, devname);
+						  WQ_HIGHPRI | WQ_MEM_RECLAIM, 1, devname);
 	else
 		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
-						  WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
+						  WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_UNBOUND,
 						  num_online_cpus(), devname);
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
