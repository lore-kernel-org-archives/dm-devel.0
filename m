From: "Nath, Varun" <varun.nath@amd.com>
Subject: RE: Need Help
Date: Thu, 17 Jan 2008 15:10:09 -0600
Message-ID: <EEBC5C82F965344199BFA3E6047FE13302E8FA@SAUSEXMB2.amd.com>
References: <EEBC5C82F965344199BFA3E6047FE13302E8F5@SAUSEXMB2.amd.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <EEBC5C82F965344199BFA3E6047FE13302E8F5@SAUSEXMB2.amd.com>
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

This is what is happening as soon as the system comes up.=20

There are no multipathing devices created. Once I run the multipath
command only then the /dev/mpath/mpath# devices get created. It looks
like I am missing some thing when the system boots up. The system has
the multipathd start up script in /etc/rc3.d.=20

Any suggestions?

[root@x ~]# cd /dev/mpath
-bash: cd: /dev/mpath: No such file or directory
[root@x ~]# cd /dev/mapper
[root@x mapper]# ls
control  oracle-app  oracle-redo1  oracle-redo2  os-home  os-opt  os-tmp
os-usr  os-var
[root@x mapper]# multipath
create: mpath4 (3600508b40010541d00009000065a0000)
[size=3D10 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [prio=3D100]
 \_ 1:0:1:1 sde 8:64  [ready]
 \_ 2:0:1:1 sdi 8:128 [ready]
\_ round-robin 0 [prio=3D20]
 \_ 1:0:0:1 sdc 8:32  [ready]
 \_ 2:0:0:1 sdg 8:96  [ready]

create: mpath5 (3600508b40010541d00009000065d0000)
[size=3D90 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [prio=3D100]
 \_ 1:0:0:2 sdd 8:48  [ready]
 \_ 2:0:0:2 sdh 8:112 [ready]
\_ round-robin 0 [prio=3D20]
 \_ 1:0:1:2 sdf 8:80  [ready]
 \_ 2:0:1:2 sdj 8:144 [ready]

[root@x mapper]# ls
control  mpath4  mpath5  oracle-app  oracle-redo1  oracle-redo2  os-home
os-opt  os-tmp  os-usr  os-var
[root@x mapper]#

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Nath, Varun
Sent: Thursday, January 17, 2008 2:46 PM
To: device-mapper development
Subject: RE: [dm-devel] Need Help

I am also getting these errors when I try to access those LUNs

Jan 17 14:39:29 x kernel: device-mapper: dm-multipath: error getting
device
Jan 17 14:39:29 x kernel: device-mapper: error adding target to table

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Nath, Varun
Sent: Thursday, January 17, 2008 2:39 PM
To: device-mapper development
Subject: RE: [dm-devel] Need Help

[root@x init.d]# /etc/init.d/multipathd status
multipathd (pid 4563) is running...
[root@x init.d]# /etc/init.d/multipath status
-bash: /etc/init.d/multipath: No such file or directory
[root@x init.d]# /etc/init.d/ multipath status
-bash: /etc/init.d/: is a directory
[root@x init.d]#

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of malahal@us.ibm.com
Sent: Thursday, January 17, 2008 2:36 PM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Need Help

Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> Run the following:
>=20
> # chkconfig multipathd on
> # /etc/init.d/ multipath status

The second command actually is "/etc/init.d/multipathd status"
to get the status of the given rc script (multipathd in this case)

--Malahal.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel





--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel





--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
