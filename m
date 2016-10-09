From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/21] Some possible additions to the DM ioctl patch for strace
Date: Sun, 9 Oct 2016 16:27:52 +0300
Message-ID: <20161009132752.GA28054@obsidian>
References: <20161005.192828.566127461630656590.yamato@redhat.com>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161005.192828.566127461630656590.yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=strace-devel>
List-Post: <mailto:strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Hello.

I've took the liberty to look at the patch and I'd like to propose some
changes to it. Can you please review them from the DM side of things?
I'm not quite sure I've understood all the specifics of the interface correctly,
it's quite peculiar.

I'm also preparing a patch for the DM ioctl decoder test, but it's not ready
yet.

Eugene Syromyatnikov (21):
  tests/ioctl_dm: Formatting
  dm: whitespace fixes
  tests: Working around bounds check
  dm: Minor output tweaks
  xlat: Add values for dm_flags
  dm: Some future-proofing by means of compile-time DM_VERSION_MAJOR
    check
  dm: Add definitions for ioctl commands not implemented initially
  dm: Use static constants for offset sizes
  dm: Remove char * cast
  dm: use => instead of , for splitting output structure from input
  dm: Compare entering field values with exiting ones
  dm: Add inttypes.h, include reorder
  dm: Move printing of dm_ioctl fields before allocation of extra data
  dm: replace abbrev branching with goto
  dm: Additional data_size/data_start checks
  dm: Add comment regarding intended fall-through in switch statement
  dm: Add data_size and data_offset fields to output
  tests/ioctl_dm: Allow passing size and data_start to init_s
  dm: Add check whether command uses parameters
  dm: Fix printing of version field
  dm: rewrite structure decoding

 dm.c             |  549 ++++++++++++++++++++++++++++++++++++------------------
 tests/ioctl_dm.c |   79 +++++---
 xlat/dm_flags.in |   36 ++--
 3 files changed, 442 insertions(+), 222 deletions(-)

-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
