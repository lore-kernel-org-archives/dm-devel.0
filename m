From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] device-mapper update for 2.6.25
Date: Thu, 7 Feb 2008 19:04:47 -0800
Message-ID: <20080207190447.b4dcfe0c.akpm@linux-foundation.org>
References: <20080208024532.GC24157@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932950AbYBHDIA@vger.kernel.org>
In-Reply-To: <20080208024532.GC24157@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Brian Wood <brian.j.wood@intel.com>, Daniel Walker <dwalker@mvista.com>, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Brassow <jbrassow@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>, Paul Jimenez <pj@place.org>, "Robert P. J. Day" <rpjday@crashcourse.ca>, Vasily Averin <vvs@sw.ru>, dm-devel@redhat.com, linux-kernel@vger.kernel.orgMilan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, 8 Feb 2008 02:45:32 +0000 Alasdair G Kergon <agk@redhat.com> wrote:

>       dm: move deferred bio flushing to workqueue

To my unpracticed eye this one looks fairly fundamental.  Unfortunately the
changelog:

  Add a single-thread workqueue for each mapped device and move flushing
  of the lists of pushback and deferred bios to this new workqueue.

tells us nothing of the reasons for this change.  (It should have done so!)

It _looks_ pretty unscalable.  Perhaps these deferred BIOs don't happen
very often?
