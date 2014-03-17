From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache: dm-3.14-fixes-4
Date: Mon, 17 Mar 2014 10:01:17 -0400
Message-ID: <20140317140117.GA7539@redhat.com>
References: <CAPi_w4w8+A=ZPANQRJDzcQWCaxj-aOJbbOePWVjsx8r7pxeWrg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAPi_w4w8+A=ZPANQRJDzcQWCaxj-aOJbbOePWVjsx8r7pxeWrg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "George ." <george@ucdn.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 17 2014 at  9:43am -0400,
George . <george@ucdn.com> wrote:

> Hi,
> 
> In dm-3.14-fixes-4, there is a description that :
> 
> - fix corruption with >2TB fast device due to truncation bug
> But looking at the diffidence I can't find anything related to such bug.

Commit 8b9d96666529 ("dm cache: fix truncation bug when copying a block
to/from >2TB fast device") follows the same pattern as commit e0d849fad7
("dm cache: fix truncation bug when mapping I/O to >2TB fast device").
Which is that from_cblock() only returns a 32bit value, so any 64bit
math operation must use a type that can accomodate 64bit.  That is why
an intermediate sector_t value is now used in both commits.

> I'm asking this, because we are trying to use dm-cache on machine with 2.4
> TB SDD cache and after I took following fix:
> 
> dm-3.14-fixes-1
> dm cache: fix truncation bug when mapping I/O to >2TB fast device
> dm-3.14-fixes-1<http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/tag/?id=dm-3.14-fixes-1>
> 
> our cached device got corrupted again.

Commit e0d849fad7 wouldn't have been the cause.  If you didn't also
apply 8b9d96666529 then you could have hit that one.

> My question is: is there another truncation bug discovered?

Yeah, both the above referenced commits (commit 8b9d96666529 being the
most recent).
 
> I've back ported  dm-3.14-fixes-1 to 3.11.10 kernel, because when we tested
> v3.14-rc5<http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/tag/?id=v3.14-rc5>
> -
> cached device was corrupted after ~15 minutes and seems to be more
> unstable.

OK, well upstream dm-cache saw very little change for 3.14.  Just a
handful of bug fixes.  So you're likely hitting an outstanding bug that
we've yet to fix.  One issue that is being actively pursued is the
thought that discards could be contributing to corruption.  Heinz will
have an update on this line of discovery soon.
