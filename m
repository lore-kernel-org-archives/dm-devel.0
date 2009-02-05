From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: Multipath setup and rdac questions
Date: Thu, 5 Feb 2009 09:37:47 -0800
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4663975E3@cosmail01.lsi.com>
References: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>
	<498B00B3.5020402@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <498B00B3.5020402@redhat.com>
Content-Language: en-US
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


Like Bryn said, you cannot have both MPP and device mapper together. MPP =
will be the first one to load. So it will claim all the devices.

I have modified your multipath.conf file. Please try this one below.=20

devices {
  device {
                vendor                  "DELL"
                product                 "MD3000i"
                product_blacklist       "Universal Xport"
                features                "1 queue_if_no_path"
                path_grouping_policy    group_by_prio
		    prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
		    getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
                hardware_handler        "1 rdac"
                path_checker            rdac
                prio                    "rdac"
                failback                immediate
        }
}

Make sure you have mpath_prio_rdac and scsi_id in sbin directories.

Thanks
Babu Moger=20

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On=
 Behalf Of Bryn M. Reeves
Sent: Thursday, February 05, 2009 9:08 AM
To: device-mapper development
Subject: Re: [dm-devel] Multipath setup and rdac questions

Christian R=F8snes wrote:
> Hi
>=20
> I have got a couple of MD3000i with dual controllers, and two M600e
> blades connected two both of them.
>=20
> I've setup multipath, and would appreciate if someone could tell me
> whether the setup described below looks correct, or if you'd do it
> any other way. The reason I'm asking, is that I cannot see any=20
> reference to 'rdac hardware handler' when I do "multipath -ll".
>=20
> However, when I change the module controller ownership one of the
> LUNs (while copying files to that particular LUN), the failover
> seems to work - the gilr copying continues after the controller
> switch.
>=20
> I also see these messages in /var/log/messages when I change the
> module controller ownership:
>=20
> 494 [RAIDarray.mpp]MD3000i_A:0:1:0 Cmnd-failed try alt ctrl 1.
> vcmnd SN 351494 pdev H2:C0:T0:L0 0x05/0x94/0x01 0x08000002
> mpp_status:1

Don't know where this is coming form. Do you have IBM's MPP
multipathing driver installed? If you are using device-mapper
multipath and multipath tools (the rest of your mail suggests this is
your intention) you should not load the MPP modules.

> Q1: What could be the reason that I'm not using the rdac hwhandler
> ? (see output from "multipath -ll" below)

Your vendor/product details don't seem to match what the array is
reporting.

> Q2: Is using rdac for this kind of setup preferred ?

Yes. It's required for proper failover if you're using device-mapper
multipathing.

> Q3: I've created a GPFS filesystem using the /dev/dm-0, /dev/dm-1,
> etc device. Is it OK to use the dm-x devices ? I see that there are
> other alternatives such as /dev/mapper/mpath<x>.

I always recommend using the /dev/mapper/* entries. These are
guaranteed to exist when the device is created (unlike the
udev-managed symlinks sometimes found in /dev/mpath) and are more
meaningful than the "dm-N" names which are really an internal
device-mapper name for the device.

> However, /dev/mapper/mpath<x> is not visible in /proc/partitions=20
> (see below), but the dm-<x> devices are - and the GPFS filesystem
> complains it cannot see the devices in /proc/partitions.

It's not meant to be - you'll only see the dm-N names here. That's
what udev refers to as the "kernel name" for the device. The entries
in /dev/mapper are aliases that are intended to be more
useful/meaningful to administrators. Internally they are the same device.

> Q4: Does my setup described here look OK ?

See comments below.


> The blades are running:
>=20
> SLES 10 SP2 (x86-64)
>=20
>> From the MD3000i Dell Resource CD the following rpm was
>> installed:
>=20
> linuxrdac-09.03.0C06.0030-1dkms

No idea what this contains.

> The following modules are running on my blades:
>=20
> # lsmod | egrep 'rdac|mpp|multi' dm_rdac                24832  0=20
> dm_multipath           42640  3  dm_rdac,dm_round_robin dm_mod
> 80528  26 dm_multipath

These are the modules needed for device-mapper multipathing.

> mppVhba               145120  24 mppUpper              127436  1
> mppVhba

These are the IBM MPP modules. You should not load these if using
device-mapper for multipathing. If you want to use MPP instead, refer
to the IBM documentation.

> device { vendor DELL product "PERC|Universal" }

Shouldn't be required as you seem to have blacklisted these devices by
device node.

> devices { device { vendor                  "DELL" product
> "MD3000i"

These don't match the vendor/product details in the multipath output
below.

You should check what the MD3000i reports in sysfs. E.g. for an EMC
clariion device I see:

# cat /sys/block/sdj/device/vendor
DGC
# cat /sys/block/sdj/device/model
RAID 5

And the corresponding entry in multipath.conf is:

                vendor                  "DGC"
                product                 "*"

I suspect from the output below that you want:

                vendor                  "DELL"
                product                 "DELL,MD Virtual Disk"

But check in sysfs.

> multipaths { mulitpath { device { vendor DELL product MD3000i } } }
>=20
This block does not define anything.

> After changing the multipath.conf I did:
>=20
> multipath -F service multipathd restart
>=20
> Now, if I've do:
>=20
> # multipath -ll mpathe (36002219000918b4c00005b6c497e6632) dm-4
> DELL,MD Virtual Disk [size=3D5.5T][features=3D0][hwhandler=3D0] \_
> round-robin 0 [prio=3D1][active] \_ 9:0:0:1  sdi 8:128
> [active][ready]

Your settings are being ignored, probably because of a vendor/product
mismatch.

Regards,
Bryn.


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
