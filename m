From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch v3]DM: dm-insitu-comp: a compressed DM target
	for SSD
Date: Mon, 10 Mar 2014 09:52:56 -0400
Message-ID: <20140310135256.GA28665@redhat.com>
References: <20140218101304.GA24889@kernel.org>
	<20140307075733.GB21790@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140307075733.GB21790@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shaohua Li <shli@kernel.org>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 07 2014 at  2:57am -0500,
Shaohua Li <shli@kernel.org> wrote:

> ping!

Hi,

I intend to get dm-insitu-comp reviewed for 3.15.  Sorry I haven't
gotten back with you before now, been busy tending to 3.14-rc issues.

I took a quick first pass over your code a couple weeks ago.  Looks to
be in great shape relative to coding conventions and the more DM
specific conventions.  Clearly demonstrates you have a good command of
DM concepts and quirks.

But one thing that would really help get dm-insitu-comp into 3.15 is to
show that the code is working as you'd expect.  To that end, it'd be
great if you'd be willing to add dm-insitu-comp support to the
device-mapper-test-suite, see:
https://github.com/jthornber/device-mapper-test-suite

I recently added barebones/simple dm-crypt support, see:
https://github.com/jthornber/device-mapper-test-suite/commit/c865bcd4e48228e18626d94327fb2485cf9ec9a1

But It may be that activation/test code for the other targets (e.g. thin
or cache) are more useful examples to follow for implemnting
dm-insitu-comp stack activation, see:
https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/pool-stack.rb
https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/cache_stack.rb

All said, implementing dm-insitu-comp support for dmts (including some
tests that establish it is working as intended) isn't a hard requirement
for getting the target upstream but it would _really_ help.

Mike
