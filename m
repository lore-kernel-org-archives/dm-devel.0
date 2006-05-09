From: Erez Zilber <erezz@voltaire.com>
Subject: Re: Running open-iscsi with device mapper hangs
Date: Tue, 09 May 2006 17:14:19 +0300
Message-ID: <4460A3BB.9010703@voltaire.com>
References: <4460A074.6030805@voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4460A074.6030805@voltaire.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: open-iscsi@googlegroups.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Erez Zilber wrote:

>Hi,
>
>I'm trying to run open-iscsi with the multipath tool. I was able to=20
>create a scenario in which the initiator machine hangs:
>
>My initiator runs on a SLES 10 beta 8 machine. The db contains 2 targets=
:
>iscsiadm -m node
>[83347a] 192.168.10.106:3260,1 iqn.2005-12.com.voltaire.206000C0FF07C1D1
>[030479] 192.168.10.105:3260,1 iqn.2005-12.com.voltaire.206000C0FF07C1D1
>
>Loading the dm modules:
>
>salt:~ # modprobe dm-mod; modprobe dm-multipath
>
>I start the initiator:
>
>salt:~ # /etc/init.d/open-iscsi start
>Starting iSCSI initiator service: done
>Logging into iqn.2005-12.com.voltaire.206000C0FF07C1D1: done
>Logging into iqn.2005-12.com.voltaire.206000C0FF07C1D1: done
>
>salt:~ # sg_map -i -x
>/dev/sg0 0 0 0 0 0 /dev/sda DotHill SANnet II FC 411I
>/dev/sg1 1 0 0 0 0 /dev/sdb DotHill SANnet II FC 411I
>
>Now, I start the multipath daemon:
>
>salt:~ # ls /dev/mapper/
>control
>salt:~ # multipathd
>salt:~ # ls /dev/mapper/
>control mpath0
>salt:~ # multipath -l
>mpath0 (3600c0ff00000000007c1d121c397f503)
>[size=3D10 GB][features=3D0][hwhandler=3D0]
>\_ round-robin 0 [prio=3D0][active]
>\_ 0:0:0:0 sda 8:0 [active][undef]
>\_ round-robin 0 [prio=3D0][enabled]
>\_ 1:0:0:0 sdb 8:16 [active][undef]
>
>Running some traffic:
>
>salt:~ # dd if=3D/dev/mapper/mpath0 of=3D/dev/null count=3D500000
>500000+0 records in
>500000+0 records out
>256000000 bytes (256 MB) copied, 9.54608 seconds, 26.8 MB/s
>
>Now, I disconnect (unplug the cable) the target which is represented by=20
>/dev/sda and run another dd command:
>
>salt:~ # dd if=3D/dev/mapper/mpath0 of=3D/dev/null count=3D500000
>500000+0 records in
>500000+0 records out
>256000000 bytes (256 MB) copied, 199.601 seconds, 1.3 MB/s
>
>Now, the 1st priority group has failed:
>
>salt:~ # multipath -l
>mpath0 (3600c0ff00000000007c1d121c397f503)
>[size=3D10 GB][features=3D0][hwhandler=3D0]
>\_ round-robin 0 [prio=3D0][enabled]
>\_ 0:0:0:0 sda 8:0 [failed][faulty]
>\_ round-robin 0 [prio=3D0][active]
>\_ 1:0:0:0 sdb 8:16 [active][undef]
>
>I reconnect the target and it's back to life:
>
>salt:~ # multipath -l
>mpath0 (3600c0ff00000000007c1d121c397f503)
>[size=3D10 GB][features=3D0][hwhandler=3D0]
>\_ round-robin 0 [prio=3D0][enabled]
>\_ 0:0:0:0 sda 8:0 [active][undef]
>\_ round-robin 0 [prio=3D0][active]
>\_ 1:0:0:0 sdb 8:16 [active][undef]
>
>I stop the initiator and the machine hangs:
>
>salt:~ # /etc/init.d/open-iscsi stop
>Logging out from iqn.2005-12.com.voltaire.206000C0FF07C1D1: done
>Logging out from iqn.2005-12.com.voltaire.206000C0FF07C1D1: (now the=20
>machine is dead)
>
>I know that the device mapper was tested in the past. Was this scenario=20
>tested? Is anyone able to reproduce this behavior? I was able to=20
>reproduce it 5 times in a row.
>
>Thanks
> =20
>
BTW - a very similar test without the device mapper works ok. I've=20
disconnected /dev/sda, tried running a dd command using /dev/sda, then I=20
reconnected /dev/sda and the command completed. When I stopped the=20
initiator, the machine didn't hang.

Erez

--=20

____________________________________________________________

Erez Zilber   |  972-9-971-7689

Software Engineer, Storage Team

Voltaire =96 _The Grid Backbone_

 __

 www.voltaire.com <http://www.voltaire.com/>

=20
