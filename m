From: Mike Snitzer <snitzer@redhat.com>
Subject: targeting dm-crypt cpu scalability changes for 3.20 still [was: Re:
 [git pull] device mapper changes for 3.16]
Date: Mon, 16 Feb 2015 16:01:43 -0500
Message-ID: <20150216210142.GA22223@redhat.com>
References: <20140612141337.GB27768@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140612141337.GB27768@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Ondrej Kozina <okozina@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 12 2014 at 10:13am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Hi Linus,
> 
> This pull request is later than I'd have liked because I was waiting for
> some performance data to help finally justify sending the long-standing
> dm-crypt cpu scalability improvements upstream.  Unfortunately we came
> up short, so those dm-crypt changes will continue to wait, but it seems
> we're not far off.

I'm sharing this because I recently saw you use dm-crypt with Fedora on
your workstation.

Just wanted to let you know that these same dm-crypt changes are staged
in for-next (like they were for months).  But now with the added ability
to use feature flags to disable the new changes that proved to hurt some
workloads.  If curious, feel free to see the topmost 7 commits here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.20

Those who are cc'd are involved with validating these dm-crypt changes
against the new 3.20 baseline.

If all goes as expected I'll have another 3.20 merge pull request for
you by the end of the week (with context for where impressive
performance improvements have been seen).

Mike
