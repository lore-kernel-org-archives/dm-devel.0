From: Arthur Bergman <sky@nanisky.com>
Subject: xen on multipath
Date: Sun, 30 Jan 2005 22:23:07 +0000
Message-ID: <844EF835-730D-11D9-8EBB-000A95A2734C@nanisky.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: multipart/mixed; boundary="===============0786187931=="
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


--===============0786187931==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg=pgp-sha1; boundary="Apple-Mail-20--32431233"


--Apple-Mail-20--32431233
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII; format=flowed

Very cool, the 2.6.10-udm1 patch applies cleanly on the xen modified 
linux tree.

xenone-sky:~# uname -a
Linux xenone-sky 2.6.10-xenU #1 Sun Jan 30 11:29:00 GMT 2005 i686 
GNU/Linux
xenone-sky:~# mount
/dev/hda1 on / type ext3 (rw,errors=remount-ro)

xenone:/etc/xen# uname -a
Linux xenone 2.6.10-xen0xen0multipath #4 Sun Jan 30 14:38:14 GMT 2005 
i686 GNU/Linux
xenone:/etc/xen# xm list
Name              Id  Mem(MB)  CPU  State  Time(s)  Console
Domain-0           0      123    0  r----    114.5
sky                4      127    1  -b---      6.5    9604
xenone:/etc/xen# xm vbd-list 4
(vbd (idx 0) (vdev 769) (device 64769) (mode w) (dev hda1) (uname 
phy:xen-a/xen-sky) (node xen-a/xen-sky) (index 0))
xenone:/etc/xen# lvscan
   ACTIVE            '/dev/xen-a/xen-sky' [10.00 GB] inherit
xenone:/etc/xen# pvscan
   PV /dev/No   VG xen-a   lvm2 [20.00 GB / 10.00 GB free]
xenone:/etc# multipath -S -v 3 3600507680183001b0800000000000029
create: 3600507680183001b0800000000000029
[size=20 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
   \_ 0:0:0:0 sda  8:0     [ready ]
   \_ 0:0:2:0 sdc  8:32    [ready ]
   \_ 1:0:2:0 sdg  8:96    [ready ]
   \_ 1:0:3:0 sdh  8:112   [ready ]
\_ round-robin 0
   \_ 0:0:1:0 sdb  8:16    [ready ]
   \_ 0:0:3:0 sdd  8:48    [ready ]
   \_ 1:0:0:0 sde  8:64    [ready ]
   \_ 1:0:1:0 sdf  8:80    [ready ]


Woooo.... so the linux inside xen as no idea it is being multipathed, 
the hypervisor does all the good work.

Now going to try and migrate a xen node from one multipath hypervisor 
to another, and after that, try and get the xen box itself boot of the 
SAN :-)

Keep up the good work.

Cheers
Arthur

-----
CTO @ Fotango Ltd
+447834716919
http://www.fotango.com/

--Apple-Mail-20--32431233
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)

iD8DBQFB/V5b3rfT7xAQCIQRAn7DAJ9azYdc4o236e3O5abzN6F1qBUHnACfXOCP
xwC8/uUFX17rzZLaOXyvGug=
=7O6X
-----END PGP SIGNATURE-----

--Apple-Mail-20--32431233--


--===============0786187931==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============0786187931==--
