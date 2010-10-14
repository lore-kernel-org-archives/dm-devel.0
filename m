From: Santosh Sarangi <santosh.sarangi1@gmail.com>
Subject: ioctl HDIO_GETGEO to device mapper devpath
Date: Thu, 14 Oct 2010 15:10:44 +0530
Message-ID: <AANLkTikBJzQM7gPPo-Wj1-2cfUqzUDa31W9gw=zZGwO4@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7278560454498568092=="
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

--===============7278560454498568092==
Content-Type: multipart/alternative; boundary=0015174c103804acd604929081c5

--0015174c103804acd604929081c5
Content-Type: text/plain; charset=ISO-8859-1

Hi,
I have a linux  mapper device on the host, I would like to get the start
offset.
I get this by the following ioctl . Although the call succeeds but it sets
the hd_geometry_rec to "0"

I checked through gdb , the ioctl call suceeds ,but sets all the field of
hd_geometry to "0"

(gdb) p hd_geometry_rec
$2 = {heads = 0 '\0', sectors = 0 '\0', cylinders = 0, start = 0}

The device configuration
===================
[root@localh trunk]# uname -a
Linux localh 2.6.18-164.el5 #1 SMP Tue Aug 18 15:51:48 EDT 2009 x86_64
x86_64 x86_64 GNU/Linux

[root@localh trunk]# fdisk -l /dev/mapper/mpath4

Disk /dev/mapper/mpath4: 523 MB, 523960320 bytes
255 heads, 63 sectors/track, 63 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

              Device Boot      Start         End      Blocks   Id  System
/dev/mapper/mpath4p1               1          10       80293+  83  Linux
/dev/mapper/mpath4p2              11          20       80325   83  Linux
/dev/mapper/mpath4p3              21          30       80325   83  Linux
/dev/mapper/mpath4p4              31          38       64260   83  Linux
[root@localh trunk]#

The Source code
============
   struct hd_geometry   hd_geometry_rec;
   unsigned int offset;

  //  Here p_ppdevname is  /dev/mapper/mpath4p4
  if ((fd = open(p_ppdevname, O_RDONLY | O_NONBLOCK)) < 0)
    {
      //Error
    }




         if ((sts = ioctl(fd, HDIO_GETGEO, &hd_geometry_rec)) < 0)
           {

            // Error
           }
         else
           {
               offset = (unsigned int) hd_geometry_rec.start;
           }


-- 
With best regards,
Santosh.

--0015174c103804acd604929081c5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<div>I have a linux =A0mapper device on the host, I would like to get th=
e start offset.</div><div>I get this by the following ioctl . Although the =
call succeeds but it sets the hd_geometry_rec to &quot;0&quot;</div><div><b=
r>
</div><div>I checked through gdb , the ioctl call suceeds ,but sets all the=
 field of hd_geometry to &quot;0&quot;</div><div><br></div><div><div>(gdb) =
p hd_geometry_rec</div><div>$2 =3D {heads =3D 0 &#39;\0&#39;, sectors =3D 0=
 &#39;\0&#39;, cylinders =3D 0, start =3D 0}</div>
</div><div><br></div><div>The device configuration</div><div>=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</div><div><div>[root@localh t=
runk]# uname -a</div><div>Linux localh 2.6.18-164.el5 #1 SMP Tue Aug 18 15:=
51:48 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux</div>
</div><div><br></div><div><div>[root@localh trunk]# fdisk -l /dev/mapper/mp=
ath4</div><div><br></div><div>Disk /dev/mapper/mpath4: 523 MB, 523960320 by=
tes</div><div>255 heads, 63 sectors/track, 63 cylinders</div><div>Units =3D=
 cylinders of 16065 * 512 =3D 8225280 bytes</div>
<div><br></div><div>=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0Device Boot =A0 =A0 =A0St=
art =A0 =A0 =A0 =A0 End =A0 =A0 =A0Blocks =A0 Id =A0System</div><div>/dev/m=
apper/mpath4p1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0 =A010 =A0 =A0 =
=A0 80293+ =A083 =A0Linux</div><div>/dev/mapper/mpath4p2 =A0 =A0 =A0 =A0 =
=A0 =A0 =A011 =A0 =A0 =A0 =A0 =A020 =A0 =A0 =A0 80325 =A0 83 =A0Linux</div>
<div>/dev/mapper/mpath4p3 =A0 =A0 =A0 =A0 =A0 =A0 =A021 =A0 =A0 =A0 =A0 =A0=
30 =A0 =A0 =A0 80325 =A0 83 =A0Linux</div><div>/dev/mapper/mpath4p4 =A0 =A0=
 =A0 =A0 =A0 =A0 =A031 =A0 =A0 =A0 =A0 =A038 =A0 =A0 =A0 64260 =A0 83 =A0Li=
nux</div><div>[root@localh trunk]#</div></div><div><br></div><div>
The Source code</div><div>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</div><div>=
=A0=A0 struct hd_geometry =A0 hd_geometry_rec;</div><div>=A0=A0 unsigned in=
t=A0offset;</div><div><br></div><div>=A0=A0// =A0Here p_ppdevname is =A0/de=
v/mapper/mpath4p4</div><div><div>=A0=A0if ((fd =3D open(p_ppdevname, O_RDON=
LY | O_NONBLOCK)) &lt; 0)</div>
<div>=A0=A0 =A0{</div><div>=A0=A0 =A0 =A0//Error</div><div>=A0=A0 =A0}</div=
></div><div><br></div><div><br></div><div>=A0=A0=A0</div><div><br></div><di=
v>=A0=A0 =A0 =A0 =A0 if ((sts =3D ioctl(fd, HDIO_GETGEO, &amp;hd_geometry_r=
ec)) &lt; 0)</div><div>=A0=A0 =A0 =A0 =A0 =A0 {</div>
<div><br></div><div>=A0=A0 =A0 =A0 =A0 =A0 =A0// Error</div><div>=A0=A0 =A0=
 =A0 =A0 =A0 }</div><div>=A0=A0=A0 =A0 =A0 =A0else</div><div>=A0=A0 =A0 =A0=
 =A0 =A0 {</div><div>=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D (unsigned in=
t) hd_geometry_rec.start;</div><div>=A0=A0 =A0 =A0 =A0 =A0 }</div><div>=A0<=
br clear=3D"all">
<br>-- <br>With best regards,<br>Santosh.<br>
</div>

--0015174c103804acd604929081c5--


--===============7278560454498568092==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7278560454498568092==--
