From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: how to refresh LV to apply fstrim online
Date: Thu, 20 Oct 2016 10:52:22 +0200
Message-ID: <CAG2kNCwwDEeY0jHMvD6JxVb2WFHncY3pRM_Cy=QvAgJxaoa5MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3255375393442460507=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3255375393442460507==
Content-Type: multipart/alternative; boundary=001a114000e84eb271053f480b9a

--001a114000e84eb271053f480b9a
Content-Type: text/plain; charset=UTF-8

Hello,
I have a cluster in RH EL 6.5 (I also have a case open fwiw...) where I'm
using HA-LVM.
I made an upgrade of the storage array Netappp -> Netapp.
I was able to do it online without service disruption using pvmove.
As a side effect the destination storage array reports the target LUN as
100% used due to the pvmove operation itself and how it works.
The LUN is now thin provisioned but it was not when pvmove was executed,
and running fstrim on the fs gives error

[root@dbatest1 ~]# fstrim /ALM/rdoffline
fstrim: /ALM/rdoffline: FITRIM ioctl failed: Operation not supported
[root@dbatest1 ~]#

The fs is on an LV with its PV on a multipath device

[root@dbatest1 ~]# df -h /ALM/rdoffline
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/VG_ALMTEST_RDOF-LV_ALMTEST_RDOF
                       50G  1.9G   45G   4% /ALM/rdoffline

[root@dbatest1 ~]# pvs|grep VG_ALMTEST_RDOF
  /dev/mapper/3600a098038303769752b495147377858 VG_ALMTEST_RDOF lvm2 a--
 50.00g    0
[root@dbatest1 ~]#

[root@dbatest1 ~]# multipath -l
/dev/mapper/3600a098038303769752b495147377858
3600a098038303769752b495147377858 dm-40 NETAPP,LUN C-Mode
size=50G features='4 queue_if_no_path pg_init_retries 50
retain_attached_hw_handle' hwhandler='1 alua' wp=rw
`-+- policy='round-robin 0' prio=0 status=active
  |- 7:0:5:14 sddt 71:176  active undef running
  `- 8:0:5:14 sdef 128:112 active undef running
[root@dbatest1 ~]#

At storage array level the LUN appears as 100% used even if it is almost
empty
I found a way to do the fstrim and reclaim space at storage array level,
but only giving downtime, with this sequence of steps:

1) rescan single paths of the multipath device
[root@dbatest1 ~]# for dev in sddt sdef; do echo "1" >
/sys/block/${dev}/device/rescan; done

2) restart multipathd daemon
[root@dbatest1 ~]# service multipathd restart
ok
Stopping multipathd daemon:                                [  OK  ]
Starting multipathd daemon:                                [  OK  ]
[root@dbatest1 ~]#

3) disable/enable the cluster service that contains the fs resource where I
operated 1) and 2)
[root@dbatest1 ~]# clusvcadm -d ALMTEST
Local machine disabling service:ALMTEST...Success

[root@dbatest1 ~]# clusvcadm -e ALMTEST
Local machine trying to enable service:ALMTEST...Success
service:ALMTEST is now running on icldbatest1
[root@dbatest1 ~]#

4) now fstrim works ok
 [root@dbatest1 ~]# fstrim /ALM/rdoffline
[root@dbatest1 ~]#
(it takes about 10-20 seconds, depending on the work it has to do..)

It seems each of the 3 steps is necessary. If I don't execute one of them,
I keep getting the error.

Is there a way to refresh the LVM part, without disabling the service, that
corresponds to without deactivating/activating the LV?

I tried the --refresh option but it didn't work.

Thanks in advance,
Gianluca

--001a114000e84eb271053f480b9a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div>I have a cluster in RH EL 6.5 (I also have a ca=
se open fwiw...) where I&#39;m using HA-LVM.</div><div>I made an upgrade of=
 the storage array Netappp -&gt; Netapp.</div><div>I was able to do it onli=
ne without service disruption using pvmove.</div><div>As a side effect the =
destination storage array reports the target LUN as 100% used due to the pv=
move operation itself and how it works.</div><div>The LUN is now thin provi=
sioned but it was not when pvmove was executed, and running fstrim on the f=
s gives error</div><div><br></div><div><div>[root@dbatest1 ~]# fstrim /ALM/=
rdoffline</div><div>fstrim: /ALM/rdoffline: FITRIM ioctl failed: Operation =
not supported</div><div>[root@dbatest1 ~]#=C2=A0</div></div><div><br></div>=
<div>The fs is on an LV with its PV on a multipath device</div><div><br></d=
iv><div><div>[root@dbatest1 ~]# df -h /ALM/rdoffline</div><div>Filesystem =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Size =C2=A0Used Avail Use% Mounted=
 on</div><div>/dev/mapper/VG_ALMTEST_RDOF-LV_ALMTEST_RDOF</div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A050G =C2=A01.9G =C2=A0 45G =C2=A0 4% /ALM/rdoffline</div><div><br></div><=
div>[root@dbatest1 ~]# pvs|grep VG_ALMTEST_RDOF</div><div>=C2=A0 /dev/mappe=
r/3600a098038303769752b495147377858 VG_ALMTEST_RDOF lvm2 a-- =C2=A0 =C2=A05=
0.00g =C2=A0 =C2=A00=C2=A0</div><div>[root@dbatest1 ~]#</div></div><div><br=
></div><div><div>[root@dbatest1 ~]# multipath -l /dev/mapper/3600a098038303=
769752b495147377858</div><div>3600a098038303769752b495147377858 dm-40 NETAP=
P,LUN C-Mode</div><div>size=3D50G features=3D&#39;4 queue_if_no_path pg_ini=
t_retries 50 retain_attached_hw_handle&#39; hwhandler=3D&#39;1 alua&#39; wp=
=3Drw</div><div>`-+- policy=3D&#39;round-robin 0&#39; prio=3D0 status=3Dact=
ive</div><div>=C2=A0 |- 7:0:5:14 sddt 71:176 =C2=A0active undef running</di=
v><div>=C2=A0 `- 8:0:5:14 sdef 128:112 active undef running</div><div>[root=
@dbatest1 ~]#=C2=A0</div></div><div><br></div><div>At storage array level t=
he LUN appears as 100% used even if it is almost empty</div><div>I found a =
way to do the fstrim and reclaim space at storage array level, but only giv=
ing downtime, with this sequence of steps:</div><div><br></div><div><div>1)=
 rescan single paths of the multipath device</div><div>[root@dbatest1 ~]# f=
or dev in sddt sdef; do echo &quot;1&quot; &gt; /sys/block/${dev}/device/re=
scan; done<br></div><div><br></div><div>2) restart multipathd daemon</div><=
div><div>[root@dbatest1 ~]# service multipathd restart</div><div>ok</div><d=
iv>Stopping multipathd daemon: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ =C2=
=A0OK =C2=A0]</div><div>Starting multipathd daemon: =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0[ =C2=A0OK =C2=A0]</div><div>[root@dbatest1 ~]#=C2=A0</div=
></div><div><br></div><div>3) disable/enable the cluster service that conta=
ins the fs resource where I operated 1) and 2)</div><div><div>[root@dbatest=
1 ~]# clusvcadm -d ALMTEST</div><div>Local machine disabling service:ALMTES=
T...Success</div><div><br></div><div>[root@dbatest1 ~]# clusvcadm -e ALMTES=
T</div><div>Local machine trying to enable service:ALMTEST...Success</div><=
div>service:ALMTEST is now running on icldbatest1</div><div>[root@dbatest1 =
~]#=C2=A0</div></div><div><br></div><div>4) now fstrim works ok</div><div>=
=C2=A0[root@dbatest1 ~]# fstrim /ALM/rdoffline</div><div>[root@dbatest1 ~]#=
=C2=A0<br></div></div><div>(it takes about 10-20 seconds, depending on the =
work it has to do..)</div><div><br></div><div>It seems each of the 3 steps =
is necessary. If I don&#39;t execute one of them, I keep getting the error.=
</div><div><br></div><div>Is there a way to refresh the LVM part, without d=
isabling the service, that corresponds to without deactivating/activating t=
he LV?</div><div><br></div><div>I tried the --refresh option but it didn&#3=
9;t work.</div><div><br></div><div>Thanks in advance,</div><div>Gianluca</d=
iv></div>

--001a114000e84eb271053f480b9a--


--===============3255375393442460507==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3255375393442460507==--
