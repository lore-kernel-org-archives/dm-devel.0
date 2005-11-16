From: "Bartschies, Thomas" <Thomas.Bartschies@cvk.de>
Subject: Devices are reassigned after Link up,
	MP path remains down
Date: Wed, 16 Nov 2005 10:47:50 +0100
Message-ID: <35E1A31585C19A4E8D6CEFFADC2E625E015562EC@CVK014.intra.cvk.de>
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
List-Id: dm-devel.ids


Hi,
our environment is:

Fujitsu-Siemens Primergy RX600 Server, with 2 Emulex LP1050 FC-HBAs
Connected through 2 EMC/McData FC Switches to an EMC Symmetrix DMX800.
Each Patch is connected to one of the two switches. The Switch are
connected
to the DMX through separate FC HAs. Dist is FC4 with a vanilla 2.6.14.2
Kernel
and device-mapper-multipath tools 0.4.6. MP policy is multibus. device
mapper
tools are version 1.01.02.

Now we're testing path down scenarios by pulling the FC cables of the
Emulex
HBAs. All path down situations are correctly recognized. Problems arise
when
we put the cables back in.

Here's are list of actions and results:
1. Cable Pull on first path	-> Path is recognized as down, Service
resumes
2. Cable Back in on first path	-> Path comes up, Devices are assigned
the same
				major/minor numbers by hotplug as
before. Path
				is recognized as up and ready.
3. Cable Pull on second path	-> Path is recognized as down, Service
resumes
4. Cable Back in on second path	-> Path comes up, Devices are assigned
new=20
				minor numbers by hotplug. These new
devices
				are usable. Multipath doesn't recognize
the path as
				ready, because it assumes the devices
for the path
				will come up on the previous major/minor
pairs

After this, only one path remains available to multipath, although the
devices are available.
But only through new device minor numbers. So is there a way we can
prevent the system
from assigning new minor device numbers, if a path comes back up? Has
anyone experienced
the same?

Regards,
--
i. A. Thomas Bartschies=20
IT Systeme

Cornelsen Verlagskontor GmbH & Co. KG
Kammerratsheide 66, 33609 Bielefeld
Telefon 0521.9719-310
Telefax 0521.9719-93310
http://www.cvk.de
