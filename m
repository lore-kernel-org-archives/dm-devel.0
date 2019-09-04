From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 1/1] dm: add clone target
Date: Wed, 4 Sep 2019 11:01:14 -0400
Message-ID: <20190904150114.GA18180@redhat.com>
References: <20190709141522.29606-1-ntsironis@arrikto.com>
	<20190709141522.29606-2-ntsironis@arrikto.com>
	<20190829161929.GA34247@lobo>
	<d33e472f-1413-d311-5659-94d2709b3fe1@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d33e472f-1413-d311-5659-94d2709b3fe1@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: vkoukis@arrikto.com, dm-devel@redhat.com, agk@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

On Sat, Aug 31 2019 at  5:55am -0400,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> On 8/29/19 7:19 PM, Mike Snitzer wrote:
> > On Tue, Jul 09 2019 at 10:15am -0400,
> > Nikos Tsironis <ntsironis@arrikto.com> wrote:
> > 
> >> Add the dm-clone target, which allows cloning of arbitrary block
> >> devices.
> >>
> >> dm-clone produces a one-to-one copy of an existing, read-only device
> >> (origin) into a writable device (clone): It presents a virtual block
> >> device which makes all data appear immediately, and redirects reads and
> >> writes accordingly.
> >>
> >> The main use case of dm-clone is to clone a potentially remote,
> >> high-latency, read-only, archival-type block device into a writable,
> >> fast, primary-type device for fast, low-latency I/O. The cloned device
> >> is visible/mountable immediately and the copy of the origin device to
> >> the clone device happens in the background, in parallel with user I/O.
> >>
> >> When the cloning completes, the dm-clone table can be removed altogether
> >> and be replaced, e.g., by a linear table, mapping directly to the clone
> >> device.
> >>
> >> For further information and examples of how to use dm-clone, please read
> >> Documentation/device-mapper/dm-clone.rst
> >>
> >> Suggested-by: Vangelis Koukis <vkoukis@arrikto.com>
> >> Co-developed-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
> >> Signed-off-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
> >> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
> >> ---
> >>  Documentation/device-mapper/dm-clone.rst |  334 +++++
> >>  drivers/md/Kconfig                       |   13 +
> >>  drivers/md/Makefile                      |    2 +
> >>  drivers/md/dm-clone-metadata.c           |  991 +++++++++++++
> >>  drivers/md/dm-clone-metadata.h           |  158 +++
> >>  drivers/md/dm-clone-target.c             | 2244 ++++++++++++++++++++++++++++++
> >>  6 files changed, 3742 insertions(+)
> >>  create mode 100644 Documentation/device-mapper/dm-clone.rst
> >>  create mode 100644 drivers/md/dm-clone-metadata.c
> >>  create mode 100644 drivers/md/dm-clone-metadata.h
> >>  create mode 100644 drivers/md/dm-clone-target.c
> >>
> >> diff --git a/Documentation/device-mapper/dm-clone.rst b/Documentation/device-mapper/dm-clone.rst
> >> new file mode 100644
> >> index 000000000000..948b7ce31ce3
> >> --- /dev/null
> >> +++ b/Documentation/device-mapper/dm-clone.rst
> >> @@ -0,0 +1,334 @@
> >> +.. SPDX-License-Identifier: GPL-2.0-only
> >> +
> >> +========
> >> +dm-clone
> >> +========
> >> +
> >> +Introduction
> >> +============
> >> +
> >> +dm-clone is a device mapper target which produces a one-to-one copy of an
> >> +existing, read-only device (origin) into a writable device (clone): It presents
> >> +a virtual block device which makes all data appear immediately, and redirects
> >> +reads and writes accordingly.
> >> +
> >> +The main use case of dm-clone is to clone a potentially remote, high-latency,
> >> +read-only, archival-type block device into a writable, fast, primary-type device
> >> +for fast, low-latency I/O. The cloned device is visible/mountable immediately
> >> +and the copy of the origin device to the clone device happens in the background,
> >> +in parallel with user I/O.
> >> +
> >> +For example, one could restore an application backup from a read-only copy,
> >> +accessible through a network storage protocol (NBD, Fibre Channel, iSCSI, AoE,
> >> +etc.), into a local SSD or NVMe device, and start using the device immediately,
> >> +without waiting for the restore to complete.
> >> +
> >> +When the cloning completes, the dm-clone table can be removed altogether and be
> >> +replaced, e.g., by a linear table, mapping directly to the clone device.
> >> +
> >> +The dm-clone target reuses the metadata library used by the thin-provisioning
> >> +target.
> >> +
> >> +Glossary
> >> +========
> >> +
> >> +   Region
> >> +     A fixed sized block. The unit of hydration.
> >> +
> >> +   Hydration
> >> +     The process of filling a region of the clone device with data from the same
> >> +     region of the origin device, i.e., copying the region from the origin to
> >> +     the clone device.
> >> +
> >> +Once a region gets hydrated we redirect all I/O regarding it to the clone
> >> +device.
> > 
> > There is a lot of awkward jargon that you're mixing into this target.
> > 
> > Why "region" and not "block"?  I can let "region" go but please be
> > consistent (don't fall back to calling a region a block anywhere).
> > 
> 
> I used the term "region" to avoid confusion with a device's
> logical/physical block size. A "region" is the unit of copying from the
> source to the destination device. dm-raid, also, uses the term "region".
> 
> But you are right that I should be consistent and never fall back to
> calling it a block. I will fix this in v2.
> 
> > Why "hydration"?  Just needed to call it _something_?  I can let it go
> > as long as it is a construct internal to the target's implementation.  I
> > see no point making consumers of this target, that copies data from a
> > source to destination, have to call something "hydration".
> > 
> 
> Hydration refers to the process of filling an object, a region in the
> case of dm-clone, with data from a data source, which is the source
> device in our case.
> 
> Please see the below links for a more detailed definition of the term:
> 
> https://stackoverflow.com/questions/6991135/what-does-it-mean-to-hydrate-an-object/20787106#20787106
> https://www.snaplogic.com/glossary/data-hydration
> 
> I think the term "hydration" is fit to what dm-clone is doing, but if
> you insist I can change it to "background copying" both in the user
> facing documentation and internally.

OK, hydration it is... ;)

> Please let me know what you think.
> 
> > And while we're at it why "origin" device instead of "source"?
> > Why "clone" device instead of "dest" or "destination"?
> > 
> 
> You are right. The terms "source" and "destination" are better and less
> confusing than "origin" and "clone". I will rename both of these to
> "source" and "destination" in v2.
> 
> > I can give the target name "dm-clone" a pass.. but dm-copy is less
> > opaque IMHO.. I could go either way on those.
> > 
> 
> I think the term "clone" describes the functionality of the target
> better than the term "copy". Even if we disable the background copying,
> the target exposes a "clone" of the source device, which can be used for
> I/O right away, even if no regions have been cloned/copied to the
> destination device yet.
> 
> Moreover, the term "clone" describes better the intended use case of the
> target, i.e., to clone a read-only snapshot to a writable block device.

Sure, I'm fine with clone.. not a big deal really.

> >> +Background Hydration
> >> +--------------------
> >> +
> >> +dm-clone copies continuously from the origin to the clone device, until all of
> >> +the device has been copied.
> >> +
> >> +Copying data from the origin to the clone device uses bandwidth. The user can
> >> +set a throttle to prevent more than a certain amount of copying occurring at any
> >> +one time. Moreover, dm-clone takes into account user I/O traffic going to the
> >> +devices and pauses the background hydration when there is I/O in-flight.
> >> +
> >> +A message `hydration_threshold <#sectors>` can be used to set the maximum number
> >> +of sectors being copied, the default being 2048 sectors (1MB).
> > 
> > Think this should really be expressed in multiples of a region, e.g.:
> > copy_threshold <# regions> (or clone_threshold)
> > 
> 
> Ack, I will fix it in v2.
> 
> >> +dm-clone employs dm-kcopyd for copying portions of the origin device to the
> >> +clone device. By default, we issue copy requests of size equal to the region
> >> +size. A message `hydration_block_size <#sectors>` can be used to tune the size
> >> +of these copy requests. Increasing the hydration block size results in dm-clone
> >> +trying to batch together contiguous regions, so we copy the data in blocks of
> >> +this size.
> > 
> > It is awkward to have 'hydration_block_size' vs target ctr
> > provided "region size".  copy_batch_size <# regions>?  (or
> > clone_batch_size)?
> > 
> 
> You are right, I will fix this also in v2.
> 
> > Please take care of the external facing documentation to not use
> > "hydration".  Of all the naming I dislike it the most.. sorry.
> > 
> > Also, please fold the following patch in before making any edits to the
> > .c files for v2.
> > 
> 
> Yes, of course. Thank you for the patch.

I look forward to your v2, thanks.

Mike
