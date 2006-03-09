From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: [RFC] Hot Reconfiguration of dmraid Arrays
Date: Thu, 9 Mar 2006 10:59:26 +0100
Message-ID: <20060309095926.GA3214@redhat.com>
References: <1141862468.17279.44.camel@localhost.localdomain>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1141862468.17279.44.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>, device-mapper development <dm-devel@redhat.com>
Cc: Mike Anderson <andmike@us.ibm.com>, ataraid-list <ataraid-list@redhat.com>, Chris McDermott <lcm@us.ibm.com>
List-Id: dm-devel.ids

On Wed, Mar 08, 2006 at 04:01:08PM -0800, Darrick J. Wong wrote:
> Hi everybody,
> 
> I've been working on a method to add hot array reconfiguration support
> to dmraid so that we can do things like add spares to an array, replace
> failed drives, modify arrays, etc without needing to reboot the system
> to access the BIOS configuration utility.  The complicated problem here
> is that we can't just reload the table of the dm device in question;
> dmraid also has to make sure that the new metadata descriptors make it
> out to disk.  This proposal requires the creation of two functions for
> each dmraid format handler: (1) to check a raid_set for correctness

You mean the existing dmraid_format check() function with more
per metadata format handler flesh in ?

> (2) to make the requisite metadata changes and write them to the
> fakeraid drive.

Should be done via the defined write function of the dmraid_format interface.

> 
> Currently, dmraid constructs a series of raid_set structures that
> describe various attributes of the dm device and point to other
> raid_sets or raid_dev structures representing the underlying devices.
> Since these raid_sets are referenced from a lib_context, we can think of
> the current dmraid configuration as a tree, with raid devices as the
> leaf nodes and raid sets as the internal nodes.
> 
> To modify the configuration, make a deep copy of the tree and modify the
> copy as desired.  This could come from something like
> "dmraid /dev/mapper/asr_raid1 add /dev/sda1" or I/O events via dmeventd.
> Either way, we end up with a "before" tree and an "after" tree, denoted
> by T0 and T1, respectively.
> 
> Each raid_set should be modified to point to the dmraid_format that
> created it, because the next step would be to traverse the tree and
> ensure that the resulting raid sets still make sense.  There are some
> checks that could be done at the dmraid level (like not mixing disks
> from different fakeraid controllers in one array) and
> controller-specific checks that can be done via function (1) in the
> dmraid_format structure.  If any of the validation functions return an
> error, we can abandon the reconfiguration attempt.  Up to this point, we
> have not made any modifications to the running system.
> 
> Next, we change the dm tables and on-disk metadata as follows:
> - For each raid set in T0 and not in T1,
>   - Deconfigure the dm device.
>   - If the array is being destroyed (as opposed to going offline),
>     - Erase the metadata on all the drives.
> - For each raid set that changed between T0 and T1,
>   - Suspend the dm device.
>   - Call function (2) in the dmraid_format descriptor to have
>     the on-disk metadata updated.
>   - Generate a new dm table and reload the dm device's table.
>   - Resume the device.

We should resequence this and think about atomic updates too:

o preload mapping for T1 so that we're sure not to suffer from OOM
o in case we change a given mapping:
  save T0 so that we can back out of an in-place update
  (question is, where this is going to be stored in case we
   only have 1 ATARAID set)
  - else -
  avoid saving altogehter
o update in-place metadata by calling (2) multiple times
o in case we fail, back out (and restore old metadata in case we weren't
  creating an array from scratch)
o in case we succeed updating, activate (for new array) or switch to mapping T1
o if exists, destroy mapping for T0

> - For each raid set in T1 and not in T0,
>   - If the array is being created from scratch,
>     - Call function (2) in the dmraid_format descriptor to
>       have the on-disk metadata created.
>   - Generate a dm table and create a new dm device with this table.
> 
> Now we're done, so we can update the lib_context structure with the new
> configuration tree and destroy the old tree.
> 
> Does this seem like a reasonable way to do this?

Yes. Please keep in mind to implement as much as possible in generic lib
areas rather than in specific metadata format handlers, so that we can reuse
the code in other handlers.

Heinz

> 
> --D



> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Cluster and Storage Development                   56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
