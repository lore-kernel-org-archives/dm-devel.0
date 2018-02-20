From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 00/20] "Foreign" NVMe support for
	multipath-tools
Date: Tue, 20 Feb 2018 14:26:38 +0100
Message-ID: <20180220132658.22295-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hello Christophe,

This patch series adds limited support for "foreign" multipath devices
to multipath and multipathd, and implements the respective API for
"native" NVMe multipath devices. The implementation is done using
a shared library approach similar to checkers, so other non-dm multipath
implementations could hook into this API easily.

"Limited support" means here that multipath and multipathd are able
to print information about "foreign" multipath maps with the commands
"multipath -l[l]", "multipathd show topology", "multipathd show maps", and
"multipathd show paths", and that multipathd checks the devices in the
checker loop and prints log messages if something interesting is detected.
No support for other functionality such real health monitoring or
administration is currently planned, although it might be be doable
by extending the code from this patch set.

Sample output from multipathd with this patch set:

multipathd show topology
sys0:NQN:subsysname (uuid.96926ba3-b207-437c-902c-4a4df6538c3f) [nvme] nvme0n1 NVMe,Linux,4.15.0-r
size=2097152 features='n/a' hwhandler='n/a' wp=rw
`-+- policy='n/a' prio=n/a status=n/a
  |- 0:1:1 nvme0c1n1 0:0 n/a n/a live
  |- 0:2:1 nvme0c2n1 0:0 n/a n/a live
  |- 0:3:1 nvme0c3n1 0:0 n/a n/a live
  `- 0:4:1 nvme0c4n1 0:0 n/a n/a live

The first part of the set (01/20-09/20) consists only of cleanup patches, improving the
usage of "const" qualifiers in the part of the code I've been working with.
(I'm routinely trying to do at least some cleanup work when I look more deeply
into parts of the code). These patches don't change functionality. 10/20 and
11/20 are two minor helpers for the patches that follow.

Patch 12/20 and 15/20 represent the actual new APIs. Patch 13, 14 change the
libmultipath printing code to work with the strongly simplified "generic"
multipath API from patch 12/20. This allows to provide foreign library code
without replicating the complex data structures libmultipath is using
internally, and yet use libmultipath's native printing code for displaying
map and path properties.

Patch 15/20 defines the actual API for "foreign" libraries. It is built on
top of the "generic" API which defines the data structures with which objects
like multipath maps and paths are described.

Patch 17/20 and 20/20 provide the implementation of NVMe native multipath
support using these APIs. Patch 18/20 and 19/20 contain the necessary changes
to multipath and multipathd to call into the new APIs.

The patch set is based on the previous multipath-tools patches I
sent to dm-devel:
 - "[PATCH v2 00/20] Various multipath-tools fixes" ff.
 - "[PATCH 0/7] multipath-tools: uevent processing fixes and unit tests" ff.
   (7/7 replaced by "[PATCH v2] multipathd: ignore uevents for non-mpath
   devices")
 - "[PATCH 1/3] multipath.rules: handle NVME devices" ff.
 - "[PATCH] libmultipath: increase path product_id/rev field size for NVMe"

To try and reduce confusion, the full series is available here:
https://github.com/openSUSE/multipath-tools/tree/upstream-queue

Reviews and comments are of course welcome.

Best Regards,
Martin

Martin Wilck (20):
  multipath(d)/Makefile: add explicit dependency on libraries
  libmultipath: remove unused "stdout helpers"
  libmultipath: get rid of selector "hack" in print.c
  libmultipath: parser: use call-by-value for "snprint" methods
  libmultipath: don't update path groups when printing
  libmultipath/print: use "const" where appropriate
  libmultipath: use "const" in devmapper code
  libmultipath: fix compiler warnings for -Wcast-qual
  multipath-tools: Makefile.inc: use -Werror=cast-qual
  libmultipath: add vector_free_const()
  libmultipath: add vector_convert()
  libmultipath: "generic multipath" interface
  libmultipath: print: convert API to generic data type
  libmultipath: print: use generic API for get_x_layout()
  libmultipath: API for foreign multipath handling
  libmultipath/print: add "%G - foreign" wildcard
  libmultipath/foreign: nvme foreign library
  multipath: use foreign API
  multipathd: use foreign API
  libmultipath: foreign/nvme: implement path display

 Makefile                      |   1 +
 Makefile.inc                  |   1 +
 kpartx/devmapper.c            |   3 +-
 libmpathcmd/mpath_cmd.c       |   2 +-
 libmultipath/Makefile         |   2 +-
 libmultipath/checkers/rbd.c   |   4 +-
 libmultipath/configure.c      |   1 +
 libmultipath/configure.h      |   1 -
 libmultipath/devmapper.c      |  35 +-
 libmultipath/devmapper.h      |  16 +-
 libmultipath/dict.c           | 206 ++++++------
 libmultipath/discovery.c      |  22 +-
 libmultipath/discovery.h      |   6 +-
 libmultipath/dm-generic.c     |  70 ++++
 libmultipath/dm-generic.h     |  41 +++
 libmultipath/dmparser.c       |   2 +-
 libmultipath/foreign.c        | 471 ++++++++++++++++++++++++++
 libmultipath/foreign.h        | 322 ++++++++++++++++++
 libmultipath/foreign/Makefile |  30 ++
 libmultipath/foreign/nvme.c   | 756 ++++++++++++++++++++++++++++++++++++++++++
 libmultipath/generic.c        |  41 +++
 libmultipath/generic.h        | 136 ++++++++
 libmultipath/list.h           |   6 +-
 libmultipath/memory.h         |   8 +-
 libmultipath/parser.c         |   9 +-
 libmultipath/parser.h         |  12 +-
 libmultipath/pgpolicies.c     |  11 +-
 libmultipath/print.c          | 397 +++++++++++++---------
 libmultipath/print.h          |  81 +++--
 libmultipath/structs.c        |  16 +-
 libmultipath/structs.h        |   9 +-
 libmultipath/uevent.c         |   6 +-
 libmultipath/util.c           |   6 +-
 libmultipath/vector.h         |  30 ++
 multipath/Makefile            |   2 +-
 multipath/main.c              |  14 +
 multipathd/Makefile           |   2 +-
 multipathd/cli_handlers.c     |  40 ++-
 multipathd/main.c             |  53 ++-
 39 files changed, 2500 insertions(+), 371 deletions(-)
 create mode 100644 libmultipath/dm-generic.c
 create mode 100644 libmultipath/dm-generic.h
 create mode 100644 libmultipath/foreign.c
 create mode 100644 libmultipath/foreign.h
 create mode 100644 libmultipath/foreign/Makefile
 create mode 100644 libmultipath/foreign/nvme.c
 create mode 100644 libmultipath/generic.c
 create mode 100644 libmultipath/generic.h

-- 
2.16.1
