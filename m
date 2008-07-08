From: Evan C Hildebran <evan.hildebran@louisville.edu>
Subject: Help Please
Date: Tue, 8 Jul 2008 10:35:34 -0400
Message-ID: <487342EB.D84E.0052.0@gwise.louisville.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Dear Redhat,

  I keep getting the following errors when my server boots up and the dev=
ice-mapper will not map the alias defined in the multipath.conf file. Wha=
t is causing this to happen and how do I fix it?


Jul  8 09:54:04 phpvm1 multipathd: cannot open /sbin/dasd_id : No such fi=
le or directory
Jul  8 09:54:04 phpvm1 multipathd: [copy.c] cannot open /sbin/dasd_id
Jul  8 09:54:04 phpvm1 multipathd: cannot copy /sbin/dasd_id in ramfs : N=
o such file or directory

Jul  8 09:54:19 phpvm1 kernel: device-mapper: uevent: version 1.0.3
Jul  8 09:54:19 phpvm1 kernel: device-mapper: ioctl: 4.11.5-ioctl (2007-1=
2-12) initialised: dm-devel@redhat.com
Jul  8 09:54:19 phpvm1 kernel: device-mapper: multipath: version 1.0.5 lo=
aded
Jul  8 09:54:19 phpvm1 kernel: device-mapper: multipath round-robin: vers=
ion 1.0.0 loaded
Jul  8 09:54:19 phpvm1 kernel: device-mapper: table: 253:0: multipath: er=
ror getting device
Jul  8 09:54:19 phpvm1 kernel: device-mapper: ioctl: error adding target =
to table
Jul  8 09:54:20 phpvm1 kernel: device-mapper: table: 253:1: multipath: er=
ror getting device
Jul  8 09:54:20 phpvm1 kernel: device-mapper: ioctl: error adding target =
to table


Thank you,



Evan C. Hildebran
Systems Programmer IV
HEAT Administrator
Information Technology
University of Louisville
evan.hildebran@louisville.edu
