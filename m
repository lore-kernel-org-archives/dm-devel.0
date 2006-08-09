From: "Matthias Rudolph" <Matthias.Rudolph@hds.com>
Subject: Re: Bug in multipath detecting devices
Date: Wed, 9 Aug 2006 14:58:55 +0100
Message-ID: <C67364BD62907640A033D1F4094CA7B7050F801C@UKSPKEVS101.corp.hds.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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
Cc: jgibson@spscommerce.com
List-Id: dm-devel.ids

Hi Jeff,

in Oracle Clusterware, RAC and ASM you have to use RAW devices - as you
mentioned. In Linux you have to bind the SCSI block devices to a RAW
device.

In RedHat:
# vi /etc/sysconfig/rawdevices
/dev/raw/raw1 /dev/disk/by-name/1HITACHI_D60085320025
/dev/raw/raw2 /dev/disk/by-name/1HITACHI_D60085320018

In Suse:
# vi /etc/raw
raw1:disk/by-name/1HITACHI_D60085320025
raw2:disk/by-name/1HITACHI_D60085320018

After restarting the RAW subsystem you only work with /dev/raw/raw.*.
The mapper device name is fixed and depends on the storage type, serial
number and storage internal lun number. With the binding also the RAW
device names are fixed. In Oracle ASM you enter /dev/raw/raw.* and the
complete path is binded.

If you use the Oracle ASMlib (easy to install) you do not need to bind
the RAW devices.
Example:

# multipath -ll
1HITACHI_D60H02610121
[size=3D1 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [prio=3D1][active]
 \_ 1:0:1:1 sdj  8:144  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:1:1 sdan 66:112 [active][ready]

# /etc/init.d/oracleasm createdisk DISK1
/dev/disk/by-name/1HITACHI_D60H02660121
Marking disk "/dev/disk/by-name/1HITACHI_D60H02660121" as an ASM disk:
done

# /etc/init.d/oracleasm listdisks
DISK1

# /etc/init.d/oracleasm querydisk DISK1
Disk "DISK1" is a valid ASM disk on device [253, 6]

SHUTDOWN the server
Exchange the LUN number with another LUN for an different scanning
sequence.
BOOT the server
Now other major and minor numbers are used:

# multipath -l
1HITACHI_D60H02610121
[size=3D1 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 1:0:1:0 sdi  8:128  [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:1:0 sdam 66:96  [active][ready]

# /etc/init.d/oracleasm listdisks
DISK1

# /etc/init.d/oracleasm querydisk DISK1
Disk "DISK1" is a valid ASM disk on device [8, 32]

# /etc/init.d/oracleasm querydisk
/dev/disk/by-name/1HITACHI_D60H02660121
Disk "/dev/disk/by-name/1HITACHI_D60H02660121" is marked an ASM disk
with the label "DISK1"

No problem for ASM to find the correct disk.

Regards, Matthias
