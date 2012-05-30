From: Zhi Yong Wu <zwu.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Bcache v13 00/16]
Date: Wed, 30 May 2012 16:54:37 +0800
Message-ID: <CAEH94LgZOkAKLOtX5pE0FQevVpEKe=zBEvojzXbX4dMkUyj2OA@mail.gmail.com>
References: <cover.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 10, 2012 at 11:07 AM, Kent Overstreet
<koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> bcache: a cache for arbitrary block devices using an SSD.
>
> Short overview:
> Bcache does both writethrough and writeback caching. It presents itse=
lf as a
> new block device, a bit like say md. You can cache an arbitrary numbe=
r of
> block devices with a single cache device, and attach and detach thing=
s at
> runtime - it's quite flexible.
>
> It's very fast. It uses a b+ tree for the index, along with a journal=
 to
> coalesce index updates, and a bunch of other cool tricks like auxilia=
ry binary
> search trees with software floating point keys for searching within b=
tree
> nodes.
>
> Bcache is solid, production ready code. There are still bugs being fo=
und that
> affect specific configurations, but there haven't been any major issu=
es found
> in awhile - it's well past time I started working on getting it into =
mainline.
>
> It's a lot of code - I tried to split it out so that it'd make some s=
ort of
> sense for reviewing. Let me know if there's anything else I can do to=
 make
This feature is so interesting; Do you have one clean public git tree
about this patchset? So that i can pull it to play with it.

> review easier.
>
> TODO/known issues:
>
> __up_write() needs to be exported for bcache to compile as a module -=
 it's
> used for bypassing lockdep when traversing the btree during garbage
> collection. If someone else knows a better solution, please let me kn=
ow.
>
> The userspace interface is going to change before it goes in. The gen=
eral
> consensus at LSF was that we don't want yet another interface for
> probing/managing block devices, and dm exists so we may as well use t=
hat. I
> don't think anyone's started on that yet, though.
>
> Documentation needs to be updated. That's being actively worked on, t=
hough.
>
> Kent Overstreet (16):
> =A0Only clone bio vecs that are in use
> =A0Bio pool freeing
> =A0Revert "rw_semaphore: remove up/down_read_non_owner"
> =A0Fix ratelimit macro to compile in c99 mode
> =A0Export get_random_int()
> =A0Export blk_fill_rwbs()
> =A0Closures
> =A0bcache: Documentation, and changes to generic code
> =A0Bcache: generic utility code
> =A0bcache: Superblock/initialization/sysfs code
> =A0bcache: Core btree code
> =A0bcache: Bset code (lookups within a btree node)
> =A0bcache: Journalling
> =A0bcache: Request, io and allocation code
> =A0bcache: Writeback
> =A0bcache: Debug and tracing code
>
> =A0Documentation/ABI/testing/sysfs-block-bcache | =A0156 ++
> =A0Documentation/bcache.txt =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=
 =A0255 +++
> =A0block/blk-core.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 | =A0 =A02 +-
> =A0drivers/block/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0| =A0 =A02 +
> =A0drivers/block/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 | =A0 =A01 +
> =A0drivers/block/bcache/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
 42 +
> =A0drivers/block/bcache/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
 =A08 +
> =A0drivers/block/bcache/alloc.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
591 +++++++
> =A0drivers/block/bcache/bcache.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
839 ++++++++++
> =A0drivers/block/bcache/bset.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| 1=
149 +++++++++++++
> =A0drivers/block/bcache/bset.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
218 +++
> =A0drivers/block/bcache/btree.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | 224=
9 ++++++++++++++++++++++++++
> =A0drivers/block/bcache/btree.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
272 ++++
> =A0drivers/block/bcache/debug.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
574 +++++++
> =A0drivers/block/bcache/debug.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
 53 +
> =A0drivers/block/bcache/io.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=
 =A0198 +++
> =A0drivers/block/bcache/journal.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A072=
2 +++++++++
> =A0drivers/block/bcache/journal.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A011=
3 ++
> =A0drivers/block/bcache/request.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 | 1470 =
+++++++++++++++++
> =A0drivers/block/bcache/request.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 5=
8 +
> =A0drivers/block/bcache/stats.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
243 +++
> =A0drivers/block/bcache/stats.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
 58 +
> =A0drivers/block/bcache/super.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | 200=
0 +++++++++++++++++++++++
> =A0drivers/block/bcache/sysfs.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
802 +++++++++
> =A0drivers/block/bcache/sysfs.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
 99 ++
> =A0drivers/block/bcache/trace.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
 26 +
> =A0drivers/block/bcache/util.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
572 +++++++
> =A0drivers/block/bcache/util.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
657 ++++++++
> =A0drivers/block/bcache/writeback.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0518 =
++++++
> =A0drivers/block/rbd.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0| =A0 =A02 +-
> =A0drivers/char/random.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0| =A0 =A01 +
> =A0drivers/md/dm.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0| =A0 27 +-
> =A0drivers/md/md.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0| =A0 =A03 +-
> =A0fs/bio.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 | =A0 55 +-
> =A0include/linux/bio.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0| =A0 =A07 +-
> =A0include/linux/blk_types.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=
 =A0 =A02 +
> =A0include/linux/cgroup_subsys.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
 =A06 +
> =A0include/linux/closure.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
| =A0614 +++++++
> =A0include/linux/ratelimit.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=
 =A0 =A02 +-
> =A0include/linux/rwsem.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0| =A0 10 +
> =A0include/linux/sched.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0| =A0 =A04 +
> =A0include/trace/events/bcache.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
257 +++
> =A0kernel/fork.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0| =A0 =A04 +
> =A0kernel/rwsem.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | =A0 16 +
> =A0kernel/trace/blktrace.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
| =A0 =A01 +
> =A0lib/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0| =A0 =A03 +
> =A0lib/Kconfig.debug =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0| =A0 =A09 +
> =A0lib/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | =A0 =A02 +
> =A0lib/closure.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0| =A0363 +++++
> =A049 files changed, 15288 insertions(+), 47 deletions(-)
> =A0create mode 100644 Documentation/ABI/testing/sysfs-block-bcache
> =A0create mode 100644 Documentation/bcache.txt
> =A0create mode 100644 drivers/block/bcache/Kconfig
> =A0create mode 100644 drivers/block/bcache/Makefile
> =A0create mode 100644 drivers/block/bcache/alloc.c
> =A0create mode 100644 drivers/block/bcache/bcache.h
> =A0create mode 100644 drivers/block/bcache/bset.c
> =A0create mode 100644 drivers/block/bcache/bset.h
> =A0create mode 100644 drivers/block/bcache/btree.c
> =A0create mode 100644 drivers/block/bcache/btree.h
> =A0create mode 100644 drivers/block/bcache/debug.c
> =A0create mode 100644 drivers/block/bcache/debug.h
> =A0create mode 100644 drivers/block/bcache/io.c
> =A0create mode 100644 drivers/block/bcache/journal.c
> =A0create mode 100644 drivers/block/bcache/journal.h
> =A0create mode 100644 drivers/block/bcache/request.c
> =A0create mode 100644 drivers/block/bcache/request.h
> =A0create mode 100644 drivers/block/bcache/stats.c
> =A0create mode 100644 drivers/block/bcache/stats.h
> =A0create mode 100644 drivers/block/bcache/super.c
> =A0create mode 100644 drivers/block/bcache/sysfs.c
> =A0create mode 100644 drivers/block/bcache/sysfs.h
> =A0create mode 100644 drivers/block/bcache/trace.c
> =A0create mode 100644 drivers/block/bcache/util.c
> =A0create mode 100644 drivers/block/bcache/util.h
> =A0create mode 100644 drivers/block/bcache/writeback.c
> =A0create mode 100644 include/linux/closure.h
> =A0create mode 100644 include/trace/events/bcache.h
> =A0create mode 100644 lib/closure.c
>
> --
> 1.7.9.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/



--=20
Regards,

Zhi Yong Wu
