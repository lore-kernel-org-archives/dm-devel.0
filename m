From: "Singh, Santosh (STSD)" <santosh.singh3@hp.com>
Subject: Re:Next set of device-mapper  patches
Date: Thu, 15 Jun 2006 20:22:02 +0530
Message-ID: <3EC60E80D9AA7C4E910ACC9DA2003AC305FEAEFA@BGEEXC02.asiapacific.cpqcorp.net>
References: <20060610160024.36F82733FA@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20060610160024.36F82733FA@hormel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: "P S, Suresh (STSD)" <suresh.pathamadai@hp.com>
List-Id: dm-devel.ids

Hi,

  I am applying the device mapper ioctl patches(as mentioned in the mail
below) in  order as given in the "series" file on linux-2.6.16.16. I
think the patch is not being applied ,since it prompts many times e.g

patching file arch/alpha/kernel/smp.c
Reversed (or previously applied) patch detected!  Assume -R? [n]

After applying the patches, I tried to build the kernel but it fail with
the error.

arch/i386/kernel/ptrace.c: In function `do_syscall_trace':
arch/i386/kernel/ptrace.c:675: warning: passing arg 1 of
`audit_syscall_exit' makes pointer from integer without a cast
arch/i386/kernel/ptrace.c:675: error: too few arguments to function
`audit_syscall_exit'
arch/i386/kernel/ptrace.c:724: warning: passing arg 1 of
`audit_syscall_entry' makes pointer from integer without a cast
arch/i386/kernel/ptrace.c:724: error: too few arguments to function
`audit_syscall_entry'
arch/i386/kernel/ptrace.c:730: warning: passing arg 1 of
`audit_syscall_exit' makes pointer from integer without a cast
arch/i386/kernel/ptrace.c:730: error: too few arguments to function
`audit_syscall_exit'
make[1]: *** [arch/i386/kernel/ptrace.o] Error 1
make: *** [arch/i386/kernel] Error 2

Whether any one has tried this ioctl patches provided by Alasdair or
used the "quilt" to apply all the patches to linux kernel.


TIA
Santosh


Date: Fri, 9 Jun 2006 22:22:34 +0100
From: Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] Next set of device-mapper patches
To: dm-devel@redhat.com
Message-ID: <20060609212234.GF7606@agk.surrey.redhat.com>
Content-Type: text/plain; charset=3Dus-ascii

I'm preparing the next set of minor patches to go upstream and would
appreciate comments and testing.  They're built on top of the patches
currently in -mm.

dm-support-ioctls-on-mapped-devices.patch
    Mechanics to support ioctls on certain devices.

dm-linear-support-ioctls.patch
    ioctl support for the linear target

dm-mpath-support-ioctls.patch
    ioctl support for the multipath target

dm-export-blkdev_driver_ioctl.patch
    Export another function to avoid calling some code twice.

dm-mirror-log-sector-size-fix.patch
dm-mirror-log-refactor-context.patch
    Make mirror log work regardless of hard sector size.

dm-table-split_args-handle-no-input.patch
    Trivial extension to table_split_args.

dm-consolidate-creation-functions.patch
    Merge dm_create and dm_create_with_minor.

dm-exports.patch
    Make various dm functions available to modules officially.

dm-create-error-table.patch
    Add a library function for modules to use.

dm-prevent-removal-if-open.patch
    Reinstate earlier dm behaviour so open devices can't be removed.

These patches are all at:
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
based on 2.6.17-rc6.  (Apply in the order shown in the series file,
or use 'quilt' directly.)


If there are any further small patches I've missed (and aren't yet in
the
editing directory) please remind me of them!  Once these are out of the
way, I'll get onto meatier things like adding netlink & the enhancements
to
snapshot, multipath & raid*.

Alasdair
--
agk@redhat.com
