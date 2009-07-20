From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Failed path will not be recovered when
	disabling/enabling remote port
Date: Mon, 20 Jul 2009 12:46:54 -0400
Message-ID: <20090720164654.GA22977@mars.virtualiron.com>
References: <4A4C998F.7010602@linux.vnet.ibm.com> <4A4C9D92.1020808@suse.de>
	<20090702130619.GA21821@mars.virtualiron.com>
	<4A4CB349.2050601@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A4CB349.2050601@suse.de>
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

> > Could also be a race condition that is present in SLES10 + RHEL5
> > kernels. Where the SysFS directories are created (and the udev event =
it
> > sent out), but the kernel hasn't populated the SysFS directories. So
> > when multipathd tries to read them it finds no pertient information a=
nd
> > shoves it off to the 'orphan' state.
> >=20
> Really? With SLES10? Have you actually observed this?

With SLES10 SP2 to be exact. It wasn't an issue with SLES10 since the
initial patch was there. The equipment I used to test this was an
AX150FC with failed batteries (so no cache writes) and with a failed
controller so it would run extra slow.

> We're running multipath _after_ udev has processed the event.

Right, the one where the SysFS directory is created. Then multipatd
reads the data. I remember posting it here and mentioning that this
problem exists on SLES10SP2 and RHEL5 but not on the upstream kernels.

> And udev already waited for sysfs, so we should be safe there.

Not so. The udev gets the SCSI uevent creation, creates the /dev/sdX, and
so. But the kernel hasn't yet fully populated the SysFS entries (so
/sys/block/sdX/device/vendor does exist, but has no data in it).
>=20
> It might be applicable to mainline multipath-tools, but

It really depends on how the SysFS directories are populated and how
slow the SCSI target is.

> the SLES10 one ... I'd be surprised.
>=20
> Well, reasonably surprised. multipath keeps on throwing
> an amazing number of issues still.
>=20
> Do you have more information here?

Here is the patch along with a detailed description.

The "multipath-tools-add-wait" patch is a backport/write of the
wait_for_file routine used in the sysfs_get_[vendor|model|rev]
macros. The SLES10 SP2 back-ported a lot of the upstream features
of multipath, and one of those was getting rid of this function.
I haven't yet found out the reason why it was deleted - looks
as if a mistake as the upstream kernel _should_ cause the same
set of problems with multipath.
[update: Upstream kernel has this fixed]

The reason a wait is necessary is due to the way the kernel
sends the event. When a SCSI device is added the SCSI subsystem
pursues this path:

_sysfs_add_sdev:
	calls device_add ...
 	[ '/devices/platform/host16/session6/target16:0:0/16:0:0:17'] uevent
		bus_attach_device
			bus_for_each_drv
				driver_probe_device
					sd_probe
 					['/class/scsi_disk/16:0:0:17' ] uevent
						add_disk
 						['/block/sdai'] [ Here multipath starts its job ]

	calls class_device_add ...
		[ '/class/scsi_device/16:0:0:17' ] uevent
		sg_add:
			[ '/class/scsi_generic/sg35' ] uevent


	done with device_add, and now we add the  attributes:
	--> scsi_sysfs_sdev_attrs[i].vendor, model, rev <-- THIS is the
problem.

[Multipathd at the 'block/sdai' event has started analyzing the data, and
it reads the SysFS, but the 'vendor', 'model' have no data so multipathd
discards them an orphans the devices. That data gets to be there once
'device_add' is finished.]


There are four uevents sent from the kernel in the creation of
a SysFS representation of the device. After the last event, the
SysFs entries for vendor,model, rev are populated. Which can
lead to a race condition when multipath investigates the
the new block device and finds it can't read the vendor. This
patch adds the wait_for_file routine which adds some wait
time.


diff -uNrp multipath-tools-0.4.7.orig/libmultipath/discovery.c multipath-=
tools-0.4.7/libmultipath/discovery.c
--- multipath-tools-0.4.7.orig/libmultipath/discovery.c	2008-09-25 14:02:=
28.000000000 -0400
+++ multipath-tools-0.4.7/libmultipath/discovery.c	2008-09-25 19:07:50.00=
0000000 -0400
@@ -125,11 +125,54 @@ path_discovery (vector pathvec, struct c
 	return r;
 }
=20
+
+/*
+ * the daemon can race udev upon path add,
+ * not multipath(8), ran by udev
+ */
+#if DAEMON
+#define WAIT_MAX_SECONDS 5
+#define WAIT_LOOP_PER_SECOND 5
+
+static int
+wait_for_file (char * filename)
+{
+	int loop;
+	struct stat stats;
+=09
+	loop =3D WAIT_MAX_SECONDS * WAIT_LOOP_PER_SECOND;
+=09
+	while (--loop) {
+		if (stat(filename, &stats) =3D=3D 0)
+			return 0;
+
+		if (errno !=3D ENOENT)
+			return 1;
+
+		usleep(1000 * 1000 / WAIT_LOOP_PER_SECOND);
+	}
+	return 1;
+}
+#else
+static int
+wait_for_file (char * filename)
+{
+	return 0;
+}
+#endif
+
 #define declare_sysfs_get_str(fname) \
 extern int \
 sysfs_get_##fname (struct sysfs_device * dev, char * buff, size_t len) \
 { \
 	char *attr; \
+	char attr_path[SYSFS_PATH_SIZE]; \
+\
+	if (safe_sprintf(attr_path, "%s/%s/%s", sysfs_path, dev->devpath, #fnam=
e)) \
+		return 1; \
+\
+	if (wait_for_file(attr_path)) \
+		return 1; \
 \
 	attr =3D sysfs_attr_get_value(dev->devpath, #fname); \
 	if (!attr) \
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
