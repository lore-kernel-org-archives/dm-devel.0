From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: dm-loop and kernel 3.x
Date: Wed, 08 Aug 2012 17:00:00 +0100
Message-ID: <50228D00.1020209@redhat.com>
References: <FB767254-0A6B-42BF-92C7-0527F5329F84@dattobackup.com>
	<50227BC3.3050002@redhat.com>
	<A8EC03E5-16E1-439E-8283-3740CBF2080C@dattobackup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <A8EC03E5-16E1-439E-8283-3740CBF2080C@dattobackup.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Matt Coleman <mcoleman@dattobackup.com>
Cc: device-mapper development <dm-devel@redhat.com>, breeves@redhat.com
List-Id: dm-devel.ids

On 08/08/2012 04:34 PM, Matt Coleman wrote:
> I was looking to remove the limit on maximum number of loop devices.
> I wasn't aware that had changed. Was the limit entirely lifted, or is
> there a new higher limit? When did that change occur (which kernel version)?

2007 - v2.6.21-3222-g7328508. Devices are now allocated dynamically as
required. The initial support was in this commit:

commit 73285082745045bcd64333c1fbaa88f8490f2626
Author: Ken Chen <kenchen@google.com>
Date:   Tue May 8 00:28:20 2007 -0700

  remove artificial software max_loop limit

  Remove artificial maximum 256 loop device that can be created due to a
  legacy device number limit.  Searching through lkml archive, there are
  several instances where users complained about the artificial limit
  that the loop driver impose.  There is no reason to have such limit.

  This patch rid the limit entirely and make loop device and associated
  block queue instantiation on demand.  With on-demand instantiation,
  it also gives the benefit of not wasting memory if these devices are
  not in use (compare to current implementation that always create 8
  loop devices), a net improvement in both areas.  This version is both
  tested with creation of large number of loop devices and is
  compatible with existing losetup/mount user land tools.

  There are a number of people who worked on this and provided valuable
  suggestions, in no particular order, by:

  Jens Axboe
  Jan Engelhardt
  Christoph Hellwig
  Thomas M

  Signed-off-by: Ken Chen <kenchen@google.com>
  Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
  Cc: Christoph Hellwig <hch@lst.de>
  Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
  Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

There are several fixes that landed later (78f4bb3 and a1c15c5) that are
important if using partitionable loop devices. Those all went into
2.6.39 so any 3.x kernel should be a reasonable choice.

Regards,
Bryn.
