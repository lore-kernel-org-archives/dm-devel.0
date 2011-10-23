From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Bisected: Massive memory leak in dm-snapshot in 3.1
	development introduced
Date: Sun, 23 Oct 2011 21:19:00 +0100
Message-ID: <20111023201900.GA13890@agk-dp.fab.redhat.com>
References: <20111023112140.37fd8b3d@xenia.leun.net> <CA+55aFzfFpnEc+Eerdi9SfMw4o17ONfYCHksJkD1O6AS5U2DoQ@mail.gmail.com> <20111023134449.GA13703@agk-dp.fab.redhat.com> <20111023163042.4a93936c@xenia.leun.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111023163042.4a93936c@xenia.leun.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Michael Leun <ml@newton.leun.net>
Cc: Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Sun, Oct 23, 2011 at 04:30:42PM +0200, Michael Leun wrote:
> On Sun, 23 Oct 2011 14:44:49 +0100
> Alasdair G Kergon <agk@redhat.com> wrote:
> > Michael - can you test if this solves the problem?

OK, let's go with this patch then.

Linus, you can pull it from here:

  http://people.redhat.com/agk/git/linux-dm for-linus

Alasdair G Kergon (1):
      dm kcopyd: fix job_pool leak

 drivers/md/dm-kcopyd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
