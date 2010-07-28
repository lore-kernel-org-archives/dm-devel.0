From: Jonathan Barber <jonathan.barber@gmail.com>
Subject: Re: [OT] How to associate pci id with wwpn for an hba
Date: Wed, 28 Jul 2010 12:26:22 +0100
Message-ID: <AANLkTinfMy-G2Cd7GCBt3yUtV13TOMANp1Od-PBykbZd@mail.gmail.com>
References: <AANLkTik17u5GBF_SBB25-qptP9cqjQFqgG4D+k-zc9a9@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTik17u5GBF_SBB25-qptP9cqjQFqgG4D+k-zc9a9@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, gianluca.cecchi@gmail.com
List-Id: dm-devel.ids

On 28 July 2010 09:45, Gianluca Cecchi <gianluca.cecchi@gmail.com> wrote:
> Hello,
> yesterday I had a problem where a server with 2 Qlogic HBA detected only 2
> of the 4 paths it should see.
> Each HBA is connected to a different fc switch.
> Each FC switch is connected to the 2 controllers of an IBM DS6800 storage
> array.
> So that in general each disk is seen by 4 paths.
> System is rh el 5.5 x86_64
> Something like this for each mpath device normally:
>
> mpath1 (3600507630efe0b0c0000000000000601) dm-8 IBM,1750500
> [size=3D15G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]
> \_ round-robin 0 [prio=3D0][active]
> =A0\_ 1:0:3:2=A0 sdao 66:128 [active][undef]
> =A0\_ 2:0:3:2=A0 sdaq 66:160 [active][undef]
> \_ round-robin 0 [prio=3D0][enabled]
> =A0\_ 1:0:2:2=A0 sdd=A0 8:48=A0=A0 [active][undef]
> =A0\_ 2:0:2:2=A0 sdp=A0 8:240=A0 [active][undef]
>
> Yesterday one server was able to see only 2 paths for each mpath device.
> I had something like this:
> mpath1 (3600507630efe0b0c0000000000000601) dm-8 IBM,1750500
> [size=3D15G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]
> \_ round-robin 0 [prio=3D0][active]
> =A0\_ 1:0:3:2=A0 sdao 66:128 [active][undef]
> \_ round-robin 0 [prio=3D0][enabled]
> =A0\_ 1:0:2:2=A0 sdd=A0 8:48=A0=A0 [active][undef]
>
> I had some problems to identify PCI ID <--> WWPN <--> disk devices
> associations so that I could give the correct wwpn involved in the problem
> to the SAN guys for analysis and resolution.

[snip]

> Could I directly say from point a) that the hostx involved is host2 as
> "multipath -l" only shows 1:x:y:z devices?
> And so that problematic wpn was 0x21000024ff288e05?
> Anyway, how to associate hostx with pci id?

# lspci | grep QLogic
0d:00.0 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to
PCI Express HBA (rev 03)
0d:00.1 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to
PCI Express HBA (rev 03)

# ls -l /sys/class/fc_host/host?/device
lrwxrwxrwx 1 root root 0 Jul 28 11:54 /sys/class/fc_host/host1/device
-> ../../../devices/pci0000:00/0000:00:06.0/0000:0b:00.0/0000:0c:09.0/0000:=
0d:00.1/host1
lrwxrwxrwx 1 root root 0 Jul 28 11:55 /sys/class/fc_host/host0/device
-> ../../../devices/pci0000:00/0000:00:06.0/0000:0b:00.0/0000:0c:09.0/0000:=
0d:00.0/host0

(note the 0d:00.0 and 0d:00.1 PCI ID in the symlink targets)

And I believe:
# ls -l /sys/block/*/device

will show you the relationship between the block device and the FC
port you were looking for in d).

I would interpret your missing block devices as being each of your
target HBA seeing only one of the storage controllers, and not both -
but check the output of "ls -l /sys/block/{sdao,sdd}/device" to make
sure.

HTH.

>
> Thanks in advance,
> Gianluca

-- =

Jonathan Barber <jonathan.barber@gmail.com>
