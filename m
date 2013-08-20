From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] Revert "Revert "math64: New div64_u64_rem helper""
Date: Tue, 20 Aug 2013 10:09:10 +0200
Message-ID: <20130820080910.GA11072@gmail.com>
References: <1376078164-23147-1-git-send-email-snitzer@redhat.com>
 <20130820070045.GA1665@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130820070045.GA1665@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>
List-Id: dm-devel.ids


* Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> On Fri, Aug 09, 2013 at 03:56:03PM -0400, Mike Snitzer wrote:
> > This reverts commit f3002134158092178be81339ec5a22ff80e6c308.
> > 
> > div64_u64_rem was removed because there were no other users.
> > 
> > But Device Mapper's I/O statistics support has a need for
> > div64_u64_rem; reintroduce this helper.
> 
> This slows down div64_u64 operation, especially on 32-bit 
> systems.
> 
> Since dm statistic code is possibly not performance 
> critical perhaps you could use something like below 
> instead to calculate remainder:
> 
> res = div64_u64(a, b);
> rem = a - b*res;

Or introduce a separately named helper without touching the 
existing methods.

Thanks,

	Ingo
