From: Atom2 <ariel.atom2@web2web.at>
Subject: snapshot-origin freezes system - what am I doing wrong?
Date: Fri, 15 May 2015 12:45:49 +0200
Message-ID: <5555CE5D.3030404@web2web.at>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello list,
I am trying to setup a cow snapshot for a LV that is used as a master 
image for a number of VMs. The idea basically is to be able to update 
the master image even when VMs are up and running; the VMs should then 
still see the old state of the image and only when they are restarted 
they should connect to the new image.
Searching the net seemed to point towards a snapshot-origin/snapshot 
solution - however I am unable to get this to work. Information on the 
net seems to be sparse, so I though I'd ask the experts on the list. 
Here are my steps:

1.) I have a LV in volume group VG named master.ROOT 
(/dev/mapper/VG-master.ROOT), 8GB, formatted as ext4
2.) I create a sparese file: truncate -size=8G /tmp/snapshot
3.) losetup -f /tmp/snapshot --> gives /dev/loop0
4.) dmsetup create mytest.img --table "0 $(blockdev --getsz 
/dev/mapper/VG-master.ROOT) snapshot-origin /dev/mapper/VG-master.ROOT
5.) dmsetup create mytest.img.cow --table "0 $(blockdev --getsz 
/dev/loop0) snapshot /dev/mapper/VG-master.ROOT /dev/loop0 P 8"

So far so good ... however, when I try to mount the origin device by
6.) mount /dev/mapper/mytest.img
the mount call doesn't return and the system gets unresponsive/freezes 
up to a point when OOM-killer is being invoked. Login attempts on the 
console time out and in essence it is only possible to reboot the system 
using magic-sysreq key combinations.

I'd be very much obliged if someone in the know could provide me with 
information what's wrong with this approach.

Many thanks in advance Atom2


P.S. Trying to replicate the setup with a second loop device instead of 
the LV for the master image seems to not suffer from this problem - 
mounting is possible without a hickup. The issue therefore seems to be 
connecte with the LV as the snapshot-origin device, but I have no clue 
how to sort that.
