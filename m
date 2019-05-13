From: Doug Anderson <dianders@chromium.org>
Subject: Problems caused by dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues
Date: Mon, 13 May 2019 09:18:23 -0700
Message-ID: <CAD=FV=VOAjgdrvkK8YKPP-8zqwPpo39rA43JH2BCeYLB0UkgAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tim Murray <timmurray@google.com>, Mike Snitzer <snitzer@redhat.com>, Guenter Roeck <groeck@chromium.org>
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>, Vito Caputo <vcaputo@pengaru.com>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I wanted to jump on the bandwagon of people reporting problems with
commit a1b89132dc4f ("dm crypt: use WQ_HIGHPRI for the IO and crypt
workqueues").

Specifically I've been tracking down communication errors when talking
to our Embedded Controller (EC) over SPI.  I found that communication
errors happened _much_ more frequently on newer kernels than older
ones.  Using ftrace I managed to track the problem down to the dm
crypt patch.  ...and, indeed, reverting that patch gets rid of the
vast majority of my errors.

If you want to see the ftrace of my high priority worker getting
blocked for 7.5 ms, you can see:

https://bugs.chromium.org/p/chromium/issues/attachmentText?aid=392715


In my case I'm looking at solving my problems by bumping the CrOS EC
transfers fully up to real time priority.  ...but given that there are
other reports of problems with the dm-crypt priority (notably I found
https://bugzilla.kernel.org/show_bug.cgi?id=199857) maybe we should
also come up with a different solution for dm-crypt?


Thanks!

-Doug
