From: Rodrigo Nascimento <nascimento.rp@gmail.com>
Subject: DM-MP, Xen 5.0.0 and NetApp
Date: Wed, 1 Apr 2009 11:31:07 -0300
Message-ID: <af7b4eb20904010731v5596112dy783c8c9ad05f558d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1025891791=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1025891791==
Content-Type: multipart/alternative; boundary=00151751149a965b2904667f2aac

--00151751149a965b2904667f2aac
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi All,

I'm having problems to put the Multipathing tools to work correctly with
NetApp Cluster Solution.

I have a xenpool with 3 machines the multipathing are enabled on them, the
HBA are Qlogic, two FAS3140 controllers in Cluster. I created a lun to be a
storage repository (SR), the lun is visible and was recognized on the 3
machines, but when we say to the XenServer to build a SR with this Lun, all
I/O operations arrive to the FAS3140 by the non-optimized path.

*XenServer multipath.conf*

defaults {
        user_friendly_names no
}
devices {
        device {
                vendor                  "NETAPP"
                product                 "LUN"
                path_grouping_policy    group_by_prio
                getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
                prio_callout            "/sbin/mpath_prio_netapp /dev/%n"
                features                "1 queue_if_no_path"
                path_checker            directio
                failback                immediate
        }
}

We made two tests, one with prio_callout as /sbin/mpath_prio_alua and other
with prio_callout as /sbin/mpath_prio_netapp, both returns the same results.

*Lun Stats from the Storage Controller*

 Read Write Other QFull   Read  Write Average   Queue     Partner  Lun
  Ops   Ops   Ops           kB     kB Latency  Length   Ops     kB
    0     0     0     0      0      0    0.00    0.00     0      0
/vol/vol_cmprh01/cmprh01_disk01.lun
---
    0     0     0     0      0      0    0.00    0.00     0      0
/vol/vol_cmprh01/cmprh01_disk01.lun
---
    0     0     0     0      0      0    0.00    0.00     0      0
/vol/vol_cmprh01/cmprh01_disk01.lun
---
   10     0    41     0      5      0    0.37    5.04    23      3
/vol/vol_cmprh01/cmprh01_disk01.lun
---
    0     0     0     0      0      0    0.00    0.00     0      0
/vol/vol_cmprh01/cmprh01_disk01.lun
---
    0     0     0     0      0      0    0.00    0.00     0      0
/vol/vol_cmprh01/cmprh01_disk01.lun
---
    0     0     0     0      0      0    0.00    0.00     0      0
/vol/vol_cmprh01/cmprh01_disk01.lun
---
    0     0     0     0      0      0    0.00    0.00     0      0
/vol/vol_cmprh01/cmprh01_disk01.lun
---
    7     0    10     0      3      0    0.52    5.01     5      1
/vol/vol_cmprh01/cmprh01_disk01.lun
---
    7     0    11     0     28      0    0.44    0.08     6     12
/vol/vol_cmprh01/cmprh01_disk01.lun
---
    0     0     0     0      0      0    0.00    0.00     0      0
/vol/vol_cmprh01/cmprh01_disk01.lun

When we have an I/O operation, more than 50% arrives to the storage
controller by the Partner interface.

*igroup configuration*

NETAPP314001> igroup show -v
    xenpool_ntap01 (FCP):
        OS Type: linux
        Member: 50:01:43:80:03:b9:36:f8 (logged in on: vtic, 0c, 0a)
        Member: 50:01:43:80:03:b9:36:fa (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:b9:36:d8 (logged in on: 0c, 0a, vtic)
        Member: 50:01:43:80:03:b9:36:da (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:b9:36:d4 (logged in on: 0c, 0a, vtic)
        Member: 50:01:43:80:03:b9:36:d6 (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:b9:37:54 (logged in on: 0c, 0a, vtic)
        Member: 50:01:43:80:03:b9:37:56 (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:b9:37:58 (logged in on: 0c, 0a, vtic)
        Member: 50:01:43:80:03:b9:37:5a (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:b9:37:10 (logged in on: 0c, 0a, vtic)
        Member: 50:01:43:80:03:b9:37:12 (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:b9:37:20 (logged in on: 0c, 0a, vtic)
        Member: 50:01:43:80:03:b9:37:22 (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:b9:37:0c (logged in on: vtic, 0c, 0a)
        Member: 50:01:43:80:03:b9:37:0e (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:b9:79:b8 (logged in on: 0c, 0a, vtic)
        Member: 50:01:43:80:03:b9:79:ba (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:b9:35:54 (logged in on: vtic, 0c, 0a)
        Member: 50:01:43:80:03:b9:35:56 (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:ba:0c:c8 (logged in on: vtic, 0c, 0a)
        Member: 50:01:43:80:03:ba:0c:ca (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:b9:35:50 (logged in on: 0c, 0a, vtic)
        Member: 50:01:43:80:03:b9:35:52 (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:ba:0c:d0 (logged in on: vtic, 0c, 0a)
        Member: 50:01:43:80:03:ba:0c:d2 (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:b9:79:5c (logged in on: 0c, 0a, vtic)
        Member: 50:01:43:80:03:b9:79:5e (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:ba:0c:dc (logged in on: 0c, 0a, vtic)
        Member: 50:01:43:80:03:ba:0c:de (logged in on: 0d, 0b, vtic)
        Member: 50:01:43:80:03:b9:35:28 (logged in on: vtic, 0c, 0a)
        Member: 50:01:43:80:03:b9:35:2a (logged in on: 0d, 0b, vtic)
        ALUA: Yes

The ALUA was configured at the igroup.

We made another test putting a Windows machine with NetApp DSM(Multipathing
software) and everything works fine.

Anyone could help me?

Rgds,

-- 
Rodrigo Nascimento

--00151751149a965b2904667f2aac
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div><font face=3D"verdana,sans-serif">Hi All,</font></div>
<div><font face=3D"verdana,sans-serif"></font>=A0</div>
<div><font face=3D"verdana,sans-serif">I&#39;m having problems to put the M=
ultipathing tools to work correctly with NetApp Cluster Solution.</font></d=
iv>
<div><font face=3D"verdana,sans-serif"></font>=A0</div>
<div><font face=3D"verdana,sans-serif">I have a xenpool with 3 machines the=
 multipathing are enabled on them, the HBA are Qlogic, two FAS3140 controll=
ers in Cluster. I created a lun to be a storage repository (SR), the lun is=
 visible and was recognized on the 3 machines, but when we say to the XenSe=
rver to build a SR with this Lun, all I/O operations arrive to the FAS3140=
=A0by the non-optimized path.</font></div>

<div><font face=3D"verdana,sans-serif"></font>=A0</div>
<div><font face=3D"verdana,sans-serif"><strong>XenServer multipath.conf</st=
rong></font></div>
<div><font face=3D"verdana,sans-serif"></font>=A0</div>
<div><font face=3D"courier new,monospace">defaults {<br>=A0=A0=A0=A0=A0=A0=
=A0 user_friendly_names no<br>}<br></font></div>
<div><font face=3D"courier new,monospace">devices {</font></div>
<div><font face=3D"courier new,monospace">=A0=A0=A0=A0=A0=A0=A0 device {<br=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vendor=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &quot;NETAPP&quot;<br>=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 product=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 &quot;LUN&quot;<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pat=
h_grouping_policy=A0=A0=A0 group_by_prio<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 getuid_callout=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 &quot;/sbin/scsi_id -g -u -s /block/%n&quot;<br>=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 prio_callout=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 &quot;/sbin/mpath_prio_netapp /dev/%n&quot;<br>=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 features=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 &quot;1 queue_if_no_path&quot;<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_checker=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 directio<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 failback=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 immediate<br>=A0=
=A0=A0=A0=A0=A0=A0 }</font></div>
<div><font face=3D"courier new,monospace">}</font></div>
<div>=A0</div>
<div><font face=3D"verdana,sans-serif">We made two tests, one with prio_cal=
lout as /sbin/mpath_prio_alua and other with prio_callout as /sbin/mpath_pr=
io_netapp, both returns the same results.</font></div>
<div>=A0</div>
<div><font face=3D"verdana,sans-serif"><strong>Lun Stats from the Storage C=
ontroller</strong></font></div>
<div><font face=3D"Verdana"></font>=A0</div>
<div><font face=3D"verdana,sans-serif"><font face=3D"courier new,monospace"=
>=A0Read Write Other QFull=A0=A0 Read=A0 Write Average=A0=A0 Queue=A0=A0=A0=
=A0 Partner=A0 Lun<br>=A0 Ops=A0=A0 Ops=A0=A0 Ops=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 kB=A0=A0=A0=A0 kB Latency=A0 Length=A0=A0 Ops=A0=A0=A0=A0 kB<br>=A0=
=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0 0=A0=A0=A0 0.00=A0=A0=A0 0.00=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0 /vol=
/vol_cmprh01/cmprh01_disk01.lun<br>
---<br>=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
 0=A0=A0=A0=A0=A0 0=A0=A0=A0 0.00=A0=A0=A0 0.00=A0=A0=A0=A0 0=A0=A0=A0=A0=
=A0 0 /vol/vol_cmprh01/cmprh01_disk01.lun<br>---<br>=A0=A0=A0 0=A0=A0=A0=A0=
 0=A0=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0=A0=A0=A0 0=
.00=A0=A0=A0 0.00=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0 /vol/vol_cmprh01/cmprh01_d=
isk01.lun<br>
---<br>=A0=A0 10=A0=A0=A0=A0 0=A0=A0=A0 41=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 5=
=A0=A0=A0=A0=A0 0=A0=A0=A0 0.37=A0=A0=A0 5.04=A0=A0=A0 23=A0=A0=A0=A0=A0 3 =
/vol/vol_cmprh01/cmprh01_disk01.lun<br>---<br>=A0=A0=A0 0=A0=A0=A0=A0 0=A0=
=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0=A0=A0=A0 0.00=
=A0=A0=A0 0.00=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0 /vol/vol_cmprh01/cmprh01_disk=
01.lun<br>
---<br>=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
 0=A0=A0=A0=A0=A0 0=A0=A0=A0 0.00=A0=A0=A0 0.00=A0=A0=A0=A0 0=A0=A0=A0=A0=
=A0 0 /vol/vol_cmprh01/cmprh01_disk01.lun<br>---<br>=A0=A0=A0 0=A0=A0=A0=A0=
 0=A0=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0=A0=A0=A0 0=
.00=A0=A0=A0 0.00=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0 /vol/vol_cmprh01/cmprh01_d=
isk01.lun<br>
---<br>=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=
 0=A0=A0=A0=A0=A0 0=A0=A0=A0 0.00=A0=A0=A0 0.00=A0=A0=A0=A0 0=A0=A0=A0=A0=
=A0 0 /vol/vol_cmprh01/cmprh01_disk01.lun<br>---<br>=A0=A0=A0 7=A0=A0=A0=A0=
 0=A0=A0=A0 10=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 0=A0=A0=A0 0.5=
2=A0=A0=A0 5.01=A0=A0=A0=A0 5=A0=A0=A0=A0=A0 1 /vol/vol_cmprh01/cmprh01_dis=
k01.lun<br>
---<br>=A0=A0=A0 7=A0=A0=A0=A0 0=A0=A0=A0 11=A0=A0=A0=A0 0=A0=A0=A0=A0 28=
=A0=A0=A0=A0=A0 0=A0=A0=A0 0.44=A0=A0=A0 0.08=A0=A0=A0=A0 6=A0=A0=A0=A0 12 =
/vol/vol_cmprh01/cmprh01_disk01.lun<br>---<br>=A0=A0=A0 0=A0=A0=A0=A0 0=A0=
=A0=A0=A0 0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0=A0=A0=A0 0.00=
=A0=A0=A0 0.00=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 0 /vol/vol_cmprh01/cmprh01_disk=
01.lun</font><br>
</font></div>
<div><font face=3D"verdana,sans-serif"></font>=A0</div>
<div><font face=3D"Verdana">When we have an I/O operation, more than 50% ar=
rives to the storage controller by the Partner interface.</font></div>
<div><font face=3D"Verdana"></font>=A0</div>
<div><font face=3D"verdana,sans-serif"><strong>igroup configuration</strong=
></font></div>
<div><font face=3D"Verdana"></font>=A0</div>
<div><font face=3D"courier new,monospace">NETAPP314001&gt; igroup show -v<b=
r>=A0=A0=A0 xenpool_ntap01 (FCP):<br>=A0=A0=A0=A0=A0=A0=A0 OS Type: linux<b=
r>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:36:f8 (logged in on: vtic=
, 0c, 0a)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:36:fa (logged =
in on: 0d, 0b, vtic)<br>
=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:36:d8 (logged in on: 0c, 0a=
, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:36:da (logged in=
 on: 0d, 0b, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:36:d4=
 (logged in on: 0c, 0a, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:=
03:b9:36:d6 (logged in on: 0d, 0b, vtic)<br>
=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:37:54 (logged in on: 0c, 0a=
, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:37:56 (logged in=
 on: 0d, 0b, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:37:58=
 (logged in on: 0c, 0a, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:=
03:b9:37:5a (logged in on: 0d, 0b, vtic)<br>
=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:37:10 (logged in on: 0c, 0a=
, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:37:12 (logged in=
 on: 0d, 0b, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:37:20=
 (logged in on: 0c, 0a, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:=
03:b9:37:22 (logged in on: 0d, 0b, vtic)<br>
=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:37:0c (logged in on: vtic, =
0c, 0a)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:37:0e (logged in=
 on: 0d, 0b, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:79:b8=
 (logged in on: 0c, 0a, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:=
03:b9:79:ba (logged in on: 0d, 0b, vtic)<br>
=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:35:54 (logged in on: vtic, =
0c, 0a)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:35:56 (logged in=
 on: 0d, 0b, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:ba:0c:c8=
 (logged in on: vtic, 0c, 0a)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:=
03:ba:0c:ca (logged in on: 0d, 0b, vtic)<br>
=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:35:50 (logged in on: 0c, 0a=
, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:35:52 (logged in=
 on: 0d, 0b, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:ba:0c:d0=
 (logged in on: vtic, 0c, 0a)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:=
03:ba:0c:d2 (logged in on: 0d, 0b, vtic)<br>
=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:79:5c (logged in on: 0c, 0a=
, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:79:5e (logged in=
 on: 0d, 0b, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:ba:0c:dc=
 (logged in on: 0c, 0a, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:=
03:ba:0c:de (logged in on: 0d, 0b, vtic)<br>
=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:35:28 (logged in on: vtic, =
0c, 0a)<br>=A0=A0=A0=A0=A0=A0=A0 Member: 50:01:43:80:03:b9:35:2a (logged in=
 on: 0d, 0b, vtic)<br>=A0=A0=A0=A0=A0=A0=A0 ALUA: Yes</font></div>
<div><font face=3D"verdana,sans-serif"></font>=A0</div>
<div><font face=3D"verdana,sans-serif">The ALUA was configured at the igrou=
p.</font></div>
<div><font face=3D"verdana,sans-serif"></font>=A0</div>
<div><font face=3D"verdana,sans-serif">We made another test putting a Windo=
ws machine with NetApp DSM(Multipathing software) and everything works fine=
.</font></div>
<div><font face=3D"Verdana"></font>=A0</div>
<div><font face=3D"Verdana">Anyone could help me?</font></div>
<div><font face=3D"Verdana"></font>=A0</div>
<div><font face=3D"Verdana">Rgds,</font></div>
<div><font face=3D"verdana,sans-serif"></font>=A0</div>
<div><font face=3D"verdana,sans-serif"><font face=3D"verdana,sans-serif">--=
 <br></font>Rodrigo Nascimento<br></font></div>

--00151751149a965b2904667f2aac--


--===============1025891791==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1025891791==--
