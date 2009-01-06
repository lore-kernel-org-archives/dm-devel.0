From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [git pull] device-mapper patches for 2.6.29
Date: Tue, 6 Jan 2009 03:14:11 +0000
Message-ID: <20090106031411.GB3512@agk.fab.redhat.com>
References: <20081010125159.GK5098@agk.fab.redhat.com>
	<20090105191824.GP5098@agk.fab.redhat.com>
	<alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Cheng Renquan <crquan@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 05, 2009 at 06:51:00PM -0800, Linus Torvalds wrote:
> On Mon, 5 Jan 2009, Alasdair G Kergon wrote:
> > Please pull from:
> >   master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git
> > to get the following device-mapper patches for 2.6.29:
> Oh no, this is totally broken, and doesn't compile even with my fairly=20
> minimal install:
>   drivers/md/dm-target.c: In function =E2=80=98dm_unregister_target=E2=80=
=99:
>   drivers/md/dm-target.c:106: error: implicit declaration of function =E2=
=80=98module_refcount=E2=80=99
=20
Missing an ifdef:-(  Sorry about that.  Better drop those two patches for=
 now
then.

Please pull from:
    =20
  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git
    =20
to get the following device-mapper patches for 2.6.29:

Alasdair G Kergon (2):
      dm mpath: move trigger_event to system workqueue
      dm snapshot: split out exception store implementations

Andi Kleen (1):
      dm: support barriers on simple devices

Jonathan Brassow (4):
      dm raid1: fix error count
      dm snapshot: separate out exception store interface
      dm snapshot: rename struct exception_store
      dm snapshot: extend exception store functions

Kiyoshi Ueda (2):
      dm request: add caches
      dm request: extend target interface

Mikulas Patocka (4):
      dm table: drop reference at unbind
      dm snapshot: change yield to msleep
      dm: consolidate target deregistration error handling
      dm table: rework reference counting

Milan Broz (4):
      dm log: move region_size validation
      dm log: ensure log bitmap fits on log device
      dm ioctl: allow dm_copy_name_and_uuid to return only one field
      dm: add name and uuid to sysfs

Takahiro Yasui (2):
      dm log: fix dm_io_client leak on error paths
      dm log: avoid reinitialising io_req on every operation

 drivers/md/Makefile             |    5 +-
 drivers/md/dm-crypt.c           |    6 +-
 drivers/md/dm-delay.c           |    6 +-
 drivers/md/dm-exception-store.c |  749 +--------------------------------=
------
 drivers/md/dm-exception-store.h |  148 ++++++++
 drivers/md/dm-ioctl.c           |   16 +-
 drivers/md/dm-linear.c          |    6 +-
 drivers/md/dm-log.c             |   40 ++-
 drivers/md/dm-mpath.c           |   14 +-
 drivers/md/dm-raid1.c           |   24 +-
 drivers/md/dm-snap-persistent.c |  704 +++++++++++++++++++++++++++++++++=
+++
 drivers/md/dm-snap-transient.c  |   98 +++++
 drivers/md/dm-snap.c            |   48 ++-
 drivers/md/dm-snap.h            |  129 +-------
 drivers/md/dm-stripe.c          |    4 +-
 drivers/md/dm-sysfs.c           |   99 +++++
 drivers/md/dm-table.c           |   47 +++-
 drivers/md/dm-target.c          |   15 +-
 drivers/md/dm-zero.c            |    5 +-
 drivers/md/dm.c                 |  101 ++++--
 drivers/md/dm.h                 |   10 +
 include/linux/device-mapper.h   |   28 ++-
 22 files changed, 1319 insertions(+), 983 deletions(-)
 create mode 100644 drivers/md/dm-exception-store.h
 create mode 100644 drivers/md/dm-snap-persistent.c
 create mode 100644 drivers/md/dm-snap-transient.c
 create mode 100644 drivers/md/dm-sysfs.c

Alasdair
--=20
agk@redhat.com
