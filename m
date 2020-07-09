From: mwilck@suse.com
Subject: [PATCH 00/54] multipath-tools series part IV: identify
	paths by dev_t
Date: Thu,  9 Jul 2020 12:36:11 +0200
Message-ID: <20200709103623.8302-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

This is part IV of a larger patch series for multipath-tools I've been preparing.
It's based on the previously submitted part III.

The full series will also be available here:
https://github.com/mwilck/multipath-tools/tree/ups/submit-2007

There are tags in that repo for each part of the series.
This part is tagged "submit-200709-4".

The dominant idea of the patches in this subseries is to move away from
the device node name as the main path identifier towards the dev_t aka
major/minor number. This is motivated by the fact that dev_t is used by the
kernel device mapper for referring to devices, both maps and paths.
If searching a device by dev_t fails, it's basically certain not to exist.
DM calls with major/minor number may even succeed if the respective devnode
has not been created yet. dev_t also works better for devices that aren't
fully initialized yet. Of course we still track the device name, but mostly
for log messages and user-directed output.

In short, using dev_t as primary identifier makes our code more robust.

The subseries also contains some unrelated fixes for functions I worked on
while making these changes.

Regards,
Martin

Martin Wilck (12):
  libmultipath: adopt_paths(): use find_path_by_devt()
  libmultipath: adopt_paths(): don't bail out on single path failure
  libmultipath: path_discover(): use find_path_by_devt()
  libmultipath: path_discover(): always set DI_BLACKLIST
  libmultipath: get_refwwid(): use find_path_by_devt()
  libmultipath: get_refwwid(): call get_multipath_config() only once
  libmultipath: get_refwwid(): get rid of "check" label
  libmultipath: get_refwwid(): use symbolic return values
  libmultipath: get_refwwid(): use switch statement
  libmultipath: constify get_mpe_wwid()
  multipath: call strchop() on command line argument
  libmultipath: get_refwwid(): skip strchop(), and constify dev
    parameter

 libmultipath/config.c      |   2 +-
 libmultipath/config.h      |   2 +-
 libmultipath/configure.c   | 200 +++++++++++++------------------------
 libmultipath/configure.h   |   2 +-
 libmultipath/discovery.c   |  32 +++---
 libmultipath/structs_vec.c |  14 ++-
 multipath/main.c           |   2 +
 7 files changed, 94 insertions(+), 160 deletions(-)

-- 
2.26.2
