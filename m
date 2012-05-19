From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 12/13] Make generic_make_request handle
	arbitrarily large bios
Date: Sat, 19 May 2012 01:59:32 +0100
Message-ID: <20120519005932.GM29330@agk-dp.fab.redhat.com>
References: <cover.1337308722.git.koverstreet@google.com> <1114e7019b0055fc09a54b59b36398d5c54f5e32.1337308722.git.koverstreet@google.com> <20120518175216.GL19388@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120518175216.GL19388@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: koverstreet@google.com, axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Fri, May 18, 2012 at 10:52:16AM -0700, Tejun Heo wrote:
> Does this by any chance allow killing ->merge_bvec_fn()?

merge_bvec also has an impact on efficiency.

Why create a too-large bio in the first place if it's only going to have to
get split up again?

If a change like this goes in, the various trade-offs should be re-examined.

Alasdair
