From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: expose dm_copy_name_and_uuid()
Date: Fri, 7 Feb 2020 12:33:25 -0500
Message-ID: <20200207173325.GA24010@redhat.com>
References: <20200201005524.23405-1-jdorminy@redhat.com>
	<20200203165402.GA11874@redhat.com>
	<CAMeeMh82tS6TZCLzMwW7Kk+wdnMFW8WXrbe6-vLxaAvBzU1gBw@mail.gmail.com>
	<20200207012432.GA23327@agk-dp.fab.redhat.com>
	<20200207014228.GC23327@agk-dp.fab.redhat.com>
	<CAMeeMh_m2EZsN_W0EzwNz7HsLs75QwTDEVY6UT+4HQkqEX8n8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMeeMh_m2EZsN_W0EzwNz7HsLs75QwTDEVY6UT+4HQkqEX8n8Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: John Dorminy <jdorminy@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 06 2020 at 10:19pm -0500,
John Dorminy <jdorminy@redhat.com> wrote:

> I agree that adding uuid to all messages would be gross bloat, and a
> bad idea to apply everywhere.
> 
> I didn't actually realize that devices could be renamed with dmsetup.
> Thanks for pointing that out...

Also, device names can also be ridiculously long.  I really just don't
think logging the name instead of major:minor is a great idea... but I'm
open to target authors electing to log it _in addition to_
dm_device_name() -- but I wouldn't want to go as far as imposing that
constraint with code...

Or would I? ;)

Create dm_pretty_device_name() that logs: "major:minor (name)" ?

Mike
