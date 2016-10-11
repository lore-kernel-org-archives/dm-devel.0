From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/9] Additional checks for strace DM ioctl decoder test
Date: Wed, 12 Oct 2016 01:38:03 +0300
Message-ID: <20161011223803.GA30714@obsidian>
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

Aside from additional checks themselves, this patchset also contains two
notable changes:
 * Fix for the previous patchset - misplaced comma printing ("dm: Fix comma
   printing for the case when dm_target_msg structure is inaccessible").
 * Update of printstr_ex call, which enables proper handling of
   QUOTE_0_TERMINATED user style (it prints cropped string without ellipsis
   otherwise).

Eugene Syromyatnikov (9):
  util: Add support for QUOTE_0_TERMINATED in user_style to
    ptrintstr_ex
  tests: Add check for printing of overlength strings to ioctl_dm test
  tests: Add check for presence of HAVE_LINUX_DM_IOCTL_H macro
    definition to ioctl_dm test
  tests/ioctl_dm: whitespace
  dm: Fix comma printing for the case when dm_target_msg structure is
    inaccessible
  tests/ioctl_dm: overly long string printing checks
  tests: Some additional checks for ioctl_dm test
  tests: Add ioctl_dm to .gitignore
  tests: Add checks for abbreviated DM ioctl output

 dm.c                  |    4 +-
 tests/.gitignore      |    2 +
 tests/Makefile.am     |    2 +
 tests/ioctl_dm-v.c    |    2 +
 tests/ioctl_dm-v.test |   12 +
 tests/ioctl_dm.c      |  653 +++++++++++++++++++++++++++++++++++++++++++++++--
 tests/ioctl_dm.test   |    2 +-
 util.c                |   18 +-
 8 files changed, 674 insertions(+), 21 deletions(-)
 create mode 100644 tests/ioctl_dm-v.c
 create mode 100755 tests/ioctl_dm-v.test

-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
