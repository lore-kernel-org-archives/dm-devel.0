From: Hannes Reinecke <hare@suse.de>
Subject: Re: Failed path will not be recovered
	when	disabling/enabling remote port
Date: Tue, 21 Jul 2009 08:19:53 +0200
Message-ID: <4A655E09.8080707@suse.de>
References: <4A4C998F.7010602@linux.vnet.ibm.com>
	<4A4C9D92.1020808@suse.de>	<20090702130619.GA21821@mars.virtualiron.com>	<4A4CB349.2050601@suse.de>
	<20090720164654.GA22977@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090720164654.GA22977@mars.virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Konrad,

Konrad Rzeszutek wrote:
>>> Could also be a race condition that is present in SLES10 + RHEL5
>>> kernels. Where the SysFS directories are created (and the udev event =
it
>>> sent out), but the kernel hasn't populated the SysFS directories. So
>>> when multipathd tries to read them it finds no pertient information a=
nd
>>> shoves it off to the 'orphan' state.
>>>
>> Really? With SLES10? Have you actually observed this?
>=20
> With SLES10 SP2 to be exact. It wasn't an issue with SLES10 since the
> initial patch was there. The equipment I used to test this was an
> AX150FC with failed batteries (so no cache writes) and with a failed
> controller so it would run extra slow.
>=20
>> We're running multipath _after_ udev has processed the event.
>=20
> Right, the one where the SysFS directory is created. Then multipatd
> reads the data. I remember posting it here and mentioning that this
> problem exists on SLES10SP2 and RHEL5 but not on the upstream kernels.
>=20
>> And udev already waited for sysfs, so we should be safe there.
>=20
> Not so. The udev gets the SCSI uevent creation, creates the /dev/sdX, a=
nd
> so. But the kernel hasn't yet fully populated the SysFS entries (so
> /sys/block/sdX/device/vendor does exist, but has no data in it).
>> It might be applicable to mainline multipath-tools, but
>=20
> It really depends on how the SysFS directories are populated and how
> slow the SCSI target is.
>=20
>> the SLES10 one ... I'd be surprised.
>>
>> Well, reasonably surprised. multipath keeps on throwing
>> an amazing number of issues still.
>>
>> Do you have more information here?
>=20
> Here is the patch along with a detailed description.
>=20
> The "multipath-tools-add-wait" patch is a backport/write of the
> wait_for_file routine used in the sysfs_get_[vendor|model|rev]
> macros. The SLES10 SP2 back-ported a lot of the upstream features
> of multipath, and one of those was getting rid of this function.
> I haven't yet found out the reason why it was deleted - looks
> as if a mistake as the upstream kernel _should_ cause the same
> set of problems with multipath.
> [update: Upstream kernel has this fixed]
>=20
> The reason a wait is necessary is due to the way the kernel
> sends the event. When a SCSI device is added the SCSI subsystem
> pursues this path:
>=20
> _sysfs_add_sdev:
> 	calls device_add ...
>  	[ '/devices/platform/host16/session6/target16:0:0/16:0:0:17'] uevent
> 		bus_attach_device
> 			bus_for_each_drv
> 				driver_probe_device
> 					sd_probe
>  					['/class/scsi_disk/16:0:0:17' ] uevent
> 						add_disk
>  						['/block/sdai'] [ Here multipath starts its job ]
>=20
> 	calls class_device_add ...
> 		[ '/class/scsi_device/16:0:0:17' ] uevent
> 		sg_add:
> 			[ '/class/scsi_generic/sg35' ] uevent
>=20
>=20
> 	done with device_add, and now we add the  attributes:
> 	--> scsi_sysfs_sdev_attrs[i].vendor, model, rev <-- THIS is the
> problem.
>=20
> [Multipathd at the 'block/sdai' event has started analyzing the data, a=
nd
> it reads the SysFS, but the 'vendor', 'model' have no data so multipath=
d
> discards them an orphans the devices. That data gets to be there once
> 'device_add' is finished.]
>=20
Ah. Hmm. Seems you are correct.

I'll have to apply the patch, then.

Fancy opening a bugzilla for it?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
