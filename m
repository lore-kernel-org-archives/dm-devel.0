From: Ankur Srivastava <asrivastava014@gmail.com>
Subject: : Multipath Setup for NVMe over Fabric
Date: Wed, 12 Apr 2017 14:50:16 +0530
Message-ID: <CAJvSebsHo-+kroUZj3_8D710uxZci9O3KPC1fb3CVp+xPrvUjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4557679816134112625=="
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

--===============4557679816134112625==
Content-Type: multipart/alternative; boundary=94eb2c092546710360054cf4b7e3

--94eb2c092546710360054cf4b7e3
Content-Type: text/plain; charset=UTF-8

Hi All,

I am working on NVMe over fabric and want to experiment the Multipathing
support for the same.

Setup Info:
RHEL 7.2 with Kernel 4.9.3


[root@localhost ~]# nvme list
Node             SN                   Model
          Namespace Usage                      Format           FW Rev
---------------- --------------------
---------------------------------------- ---------
-------------------------- ---------------- --------
/dev/nvme0n1     30501b622ed15184     Linux
   10        268.44  GB / 268.44  GB    512   B +  0 B   4.9.3
/dev/nvme1n1     ef730272d9be107c      Linux
     10        268.44  GB / 268.44  GB    512   B +  0 B   4.9.3


[root@localhost ~]# ps ax | grep multipath
1272 ?        SLl    0:00 /sbin/multipathd


I have connected my Initiator to both the ports of Ethernet Adapter(Target)
to get 2 IO Paths, from the above data "/dev/nvme0n1" is path 1 and
"/dev/nvme1n1" is path 2 for the same namespace.

Note: I am using Null Block device on the Target Side.

But still the multipath is showing an error ie no path to Host for All the
NVMe Drives mapped on the Initiator. Does multipathd supports NVMe over
Fabric ??
Or what I am missing from configuration side ??

Thanks in advance!!


BR~
Ankur

--94eb2c092546710360054cf4b7e3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi All,=C2=A0<div><br></div><div>I am working on NVMe over=
 fabric and want to experiment the Multipathing support for the same.</div>=
<div><br></div><div>Setup Info:</div><div>RHEL 7.2 with Kernel 4.9.3</div><=
div><br></div><div><br></div><div><div>[root@localhost ~]# nvme list</div><=
div>Node =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 SN =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Model =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Namespace Usage =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Format =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FW Rev</div><div>---------------- ---------=
----------- ---------------------------------------- --------- ------------=
-------------- ---------------- --------</div><div>/dev/nvme0n1 =C2=A0 =C2=
=A0 30501b622ed15184 =C2=A0 =C2=A0 Linux =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A010 =C2=A0 =C2=A0 =C2=A0 =C2=A0268.44 =C2=A0GB / 268.44 =C2=
=A0GB =C2=A0 =C2=A0512 =C2=A0 B + =C2=A00 B =C2=A0 4.9.3</div><div>/dev/nvm=
e1n1 =C2=A0 =C2=A0 ef730272d9be107c =C2=A0 =C2=A0 =C2=A0Linux =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A010 =C2=A0 =C2=A0 =C2=A0 =C2=A0268.44 =
=C2=A0GB / 268.44 =C2=A0GB =C2=A0 =C2=A0512 =C2=A0 B + =C2=A00 B =C2=A0 4.9=
.3</div></div><div><br></div><div><div><br></div><div>[root@localhost ~]# p=
s ax | grep multipath</div><div>1272 ? =C2=A0 =C2=A0 =C2=A0 =C2=A0SLl =C2=
=A0 =C2=A00:00 /sbin/multipathd</div></div><div><br></div><div><br></div><d=
iv>I have connected my Initiator to both the ports of Ethernet Adapter(Targ=
et) to get 2 IO Paths, from the above data &quot;/dev/nvme0n1&quot; is path=
 1 and &quot;/dev/nvme1n1&quot; is path 2 for the same namespace.</div><div=
><br></div><div>Note: I am using Null Block device on the Target Side.</div=
><div><br></div><div>But still the multipath is showing an error ie no path=
 to Host for All the NVMe Drives mapped on the Initiator. Does multipathd s=
upports NVMe over Fabric ??</div><div>Or what I am missing from configurati=
on side ??</div><div><br></div><div>Thanks in advance!!</div><div><br></div=
><div><br></div><div>BR~</div><div>Ankur</div><div><br></div><div><br></div=
><div><br></div><div><br></div><div><br></div></div>

--94eb2c092546710360054cf4b7e3--


--===============4557679816134112625==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4557679816134112625==--
