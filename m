From: Erez Zilber <erezz@voltaire.com>
Subject: Setting up a multipath device
Date: Thu, 04 May 2006 17:08:41 +0300
Message-ID: <445A0AE9.20907@voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
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

I'm new to device mapper and trying to set a multipath target:

I'm connected to the same LUN over iSCSI in 2 paths:

Here's the output of sg_map:
sg_map -i -x
/dev/sg0 3 0 0 0 0 /dev/sda DotHill SANnet II FC 411I
/dev/sg1 4 0 0 0 0 /dev/sdb DotHill SANnet II FC 411I

I ran the following command:
multipath 2 round-robin 1 0 /dev/sda round-robin 1 0 /dev/sdb

If I understand correctly, the 1st priority group contains /dev/sda. The=20
2nd priority group contains /dev/sdb. If /dev/sda fails, traffic should=20
automatically move to /dev/sdb. Is that right?

Here's the out put of multipath -l:

3600c0ff00000000007c1d121c397f503
[size=3D10 GB][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
\_ 3:0:0:0 sda 8:0 [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
\_ 4:0:0:0 sdb 8:16 [active][undef]

What does 8:0 & 8:16 mean? What is 3600c0ff00000000007c1d121c397f503?

Now, assuming that what I did so far is ok, how do I use the multipath=20
device? Do I use /dev/sda (or /dev/sdb)?

Thanks in advance
--=20

____________________________________________________________

Erez Zilber | 972-9-971-7689

Software Engineer, Storage Team

Voltaire =96 _The Grid Backbone_

__

www.voltaire.com <http://www.voltaire.com/>
