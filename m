From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: dm-mon fails to load raid1 target
Date: Tue, 1 Feb 2005 09:41:30 +0100
Message-ID: <62b0912f0502010041135adea8@mail.gmail.com>
References: <62b0912f05013009209d8d8f0@mail.gmail.com>
	<200501310747.10552.kevcorry@us.ibm.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <200501310747.10552.kevcorry@us.ibm.com>
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
Cc: gerte@nieuwenborg.nl
List-Id: dm-devel.ids

Kevin Corry wrote:
> Molle Bestefich wrote:
>> I can't get dm_mon to load the raid1 target.
> 
> Do you mean "dm_mod", which is the core of the DM driver?

Yes :-).

>> The syslog says (timestamps removed):
>> [...]
> 
> This means a user-space program tried to load a device-table for a target-type
> that doesn't exist or couldn't be loaded.
> 
>> I'm booting with a Gentoo CD [gen2dmraid 0.99 - kernel: 2.6.9, driver
>> 4.1.0, library 1.00.17-ioctl].
>>
>> The /lib/modules/.../raid1.ko file is present.
> 
> That is the module for MD/Software-RAID RAID-1, not the Device-Mapper
> mirroring module. They are completely different drivers that just happen to
> be in the same directory in the kernel source and module trees.

Ack.  Thank you for clearing that up.

I've never been able to install a working copy of Linux on my PC, so I
don't know squat.

Linux cannot use the disks on my ATARAID controller, even though it
says on the box that the controller supports Linux.  Using the
proprietary driver, I can't recompile the kernel with eg. appropriate
sound card drivers and the open source ATARAID driver isn't up-to-date
with the metadata format.

I'm trying again now that DM and DMRAID has arrived, but (as is
probably apparent), I haven't got a clue what I'm doing :-)

>> Any hints on what is going wrong / what I am doing wrong?
> 
> The Device-Mapper mirroring target is called "dm-mirror". Check your kernel
> configuration and make sure you have CONFIG_DM_MIRROR set to "y" or "m". If
> necessary, you may need to rebuild your kernel to enable it. Once it's
> enabled, run "dmsetup targets" and look for a "mirror" entry. If you've
> compiled DM mirroring as a module, try "modprobe dm-mirror", and then run
> "dmsetup targets" again.

Gerte, is there somehow that I can persuade you to build a new LiveCD
with dm-mirror support?

I would like to do it myself, but am a bit stuck since no Linux distro
will install on my PC :-/..

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
