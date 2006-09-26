From: The MoonSeeker <themoonseeker@gmail.com>
Subject: Problem when creating snashots
Date: Tue, 26 Sep 2006 17:08:50 +0200
Message-ID: <77299A0E-4C81-4820-97BF-FB15B1A96FD6@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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

I'd like to create many snaphot of an image but I've got when I =20
attemp to create the 32th snapshot :

root@B03:/diplome# lvcreate -s -L150M -n 232 /dev/openvz/vps-core
   Rounding up size to full physical extent 152.00 MB
   device-mapper: reload ioctl failed: Ne peut allouer de la m=E9moire
   Failed to suspend origin vps-core

I don't understand the error..

This what I get when scaning the LVM :

root@B03-PC:/diplome# lvscan
   ACTIVE   Original '/dev/openvz/vps-core' [200.00 MB] inherit
   ACTIVE            '/dev/openvz/232' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/201' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/202' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/203' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/204' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/205' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/206' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/207' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/208' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/209' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/210' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/211' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/212' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/213' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/214' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/215' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/216' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/217' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/218' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/219' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/220' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/221' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/222' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/223' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/224' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/225' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/226' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/227' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/228' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/229' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/230' [152.00 MB] inherit
   ACTIVE   Snapshot '/dev/openvz/231' [152.00 MB] inherit

What can I do? Is it some limitation when snapshoting?

Info :

root@B03:/diplome# uname -r
2.6.16-026test014

Thank you
