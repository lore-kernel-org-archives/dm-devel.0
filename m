From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/2] Introduce the request handling for
	dm-crypt
Date: Wed, 2 Dec 2015 19:56:57 +0000
Message-ID: <20151202195657.GB11127@agk-dp.fab.redhat.com>
References: <cover.1447233227.git.baolin.wang@linaro.org> <20151111181813.GD12236@redhat.com> <CAMz4kuKNAkFG4-f6TU1HRxgkAn+YX-D_tTQAWio-A_np3brr+A@mail.gmail.com> <20151112100422.GM12392@sirena.org.uk> <5644AFA2.6040201@kernel.dk> <20151113115144.GR12392@sirena.org.uk> <CAMz4kuLTuY5CpTfW4Gijesy1Pp9PxbWj076XeoV24Hj3EydifQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMz4kuLTuY5CpTfW4Gijesy1Pp9PxbWj076XeoV24Hj3EydifQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Jens Axboe <axboe@kernel.dk>, keith.busch@intel.com, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Mike Snitzer <snitzer@redhat.com>, neilb@suse.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, "Garg, Dinesh" <dineshg@quicinc.com>, tj@kernel.org, bart.vanassche@sandisk.com, jmoyer@redhat.com, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 02, 2015 at 08:46:54PM +0800, Baolin Wang wrote:
> These are the benchmarks for request based dm-crypt. Please check it.
 
Now please put request-based dm-crypt completely to one side and focus
just on the existing bio-based code.  Why is it slower and what can be
adjusted to improve this?

People aren't going to take a request-based solution seriously until
you can explain in full detail *why* bio-based is slower AND why it's
impossible to improve its performance.

> For request based things, some sequential bios/requests can merged
> into one request to expand the IO size to be a big block handled by
> hardware engine at one time. 

Bio-based also merges I/O so that does not provide justification.
Investigate in much more detail the actual merging and scheduling
involved in the cases you need to optimise.  See if blktrace gives you
any clues, or add your own instrumentation.  You could even look at some
of the patches we've had in the list archives for optimising bio-based
crypt in different situations.

Alasdair
