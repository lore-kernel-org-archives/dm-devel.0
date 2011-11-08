From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: turning the root volume into a snapshot stalls
	(ioctl hangs)
Date: Tue, 8 Nov 2011 08:21:21 -0500
Message-ID: <20111108132120.GA19817@redhat.com>
References: <201111081257.08114.mailinglisten@hauke-laging.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201111081257.08114.mailinglisten@hauke-laging.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hauke Laging <mailinglisten@hauke-laging.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 08 2011 at  6:57am -0500,
Hauke Laging <mailinglisten@hauke-laging.de> wrote:

> Hello,
> 
> for energy saving purposes I try to buffer disk accesses in RAM by making the 
> mounted (LVM) volume a snapshot and putting the COW device on tmpfs (loop 
> device over a sparse file) so that I can flush the changes later by making the 
> volume a snapshot-merge target. Note: I am NOT trying to make a snapshot of 
> the root volume! (This has obviously been done sucessfully by others.)
> 
> This works for a data volume but the system hangs when trying this with the 
> root volume. The interesting point: The problem seems not to be caused by an 
> access to the root filesystem.
> 
> I have created a chroot environment in a tmpfs volume (and sucessfully done 
> this with a data volume from there). The relevant part of the script (located 
> in the chroot environment, of course) is:
> 
> dmsetup suspend "$cryptodevice_name" || exit 1
> dmsetup load "$cryptodevice_name" --table "0 ${origin_block_count} \
>      snapshot-merge ${origin_major_minor} ${cow_major_minor} P 8" || exit 1
> dmsetup resume "$cryptodevice_name" || exit 1
> 
> The hanging occurs during the "dmsetup load". I hat a look at it by strace. 
> This is what happens with the data volume:
> 
> [...]
> stat("/dev/mapper/control", {st_mode=S_IFCHR|0600, st_rdev=makedev(10, 236), 
> ...}) = 0
> open("/dev/mapper/control", O_RDWR) = 3
> open("/proc/devices", O_RDONLY)   = 4
> fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 
> 0x7f855bec6000
> read(4, "Character devices:\n  1 mem\n  4 /"..., 1024) = 490
> close(4)                          = 0
> munmap(0x7f855bec6000, 4096)      = 0
> ioctl(3, DM_VERSION, 0x6162a0)    = 0
> ioctl(3, DM_TABLE_LOAD, 0x6161f0) = 0
> close(3)                          = 0
> exit_group(0)                     = ?
> [...]
> 
> The same call for the root volume leads to
> [...]
> ioctl(3, DM_TABLE_LOAD, 0x6161f0) =
> (I am not sure about the 0x6161f0)
> The exit code never appears. I do not know whether this is a problem of the 
> ioctl or one of strace. But as the volume has already been suspended at that 
> time I do not see any reason why strace should be affected. The system is not 
> completely dead but no useful actitivy is possible any more.
> 
> Issuing a suspend and a resume immediately afterwards (without the load) does 
> not kill the system. So the problem seems to be about the dmsetup load.

So you're somehow activating the snapshot to be the root volume.  And
then later trying to merge the tmpfs COW into the origin (obviously
before you reboot otherwise you'd lose the tmpfs).  This isn't going to
work with the current snapshot-merge code given the constraints that
both the origin and snapshot must be closed before merge.

Merging a snapshot into a root volume must occur at first activation
(before it is opened for use by the system).

The lvm tools both document and guard against this, from lvconvert(8):
   Merging a snapshot into an origin that cannot be closed, for
   example a root filesystem, is deferred until the next time the origin
   volume is activated.

Mike
