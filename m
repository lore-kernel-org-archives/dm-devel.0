From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] dm: dm-cache fails to write the cache device in
	writethrough mode
Date: Sat, 23 Mar 2013 21:13:08 +0000
Message-ID: <20130323211308.GC30269@agk-dp.fab.redhat.com>
References: <20130322201151.GB5357@blackbox.djwong.org> <20130322223425.GA5638@redhat.com> <20130322231600.GD5357@blackbox.djwong.org> <20130323032715.GA7692@redhat.com> <20130323051549.GE5357@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130323051549.GE5357@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Joe Thornber <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 22, 2013 at 10:15:49PM -0700, Darrick J. Wong wrote:
> Interesting ... if I set up this:
> # echo "0 67108864 linear /dev/sda 0" | dmsetup create origin
> And then repeat the test, but using /dev/mapper/origin as the origin instead
> of /dev/sda, the problem goes away.
 
So that looks like an easy and correct workaround for now.

Alasdair
