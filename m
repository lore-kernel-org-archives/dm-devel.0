From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] dm: dm-cache fails to write the cache device in
	writethrough mode
Date: Sat, 23 Mar 2013 03:48:03 +0000
Message-ID: <20130323034803.GB30269@agk-dp.fab.redhat.com>
References: <20130322201151.GB5357@blackbox.djwong.org> <20130322223425.GA5638@redhat.com> <20130322231600.GD5357@blackbox.djwong.org> <20130323032715.GA7692@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130323032715.GA7692@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 22, 2013 at 11:27:16PM -0400, Mike Snitzer wrote:
> So the big difference is the thinp-test-suite uses intermediate linear
> DM layers above the slower sd device (spindle/data) -- whereas in your
> setup the origin device is direct to sd (8:0).
 
I would think the difference is because DM issues (edited) copies of
incoming bios to the layers underneath, so changes don't propagate back
up.

Darrick: if you retest with a dm linear device, does the problem go
away?

Alasdair
