From: Lars Marowsky-Bree <lmb@suse.de>
Subject: latest multipath-tools from git breaks EMC CX
Date: Thu, 2 Jun 2005 22:46:30 +0200
Message-ID: <20050602204630.GK22633@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
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

More specifically, it fails to detect the vendor correctly, and uses the
most basic internal defaults:

...
=3D=3D=3D=3D=3D path sdz =3D=3D=3D=3D=3D
bus =3D 0
dev_t =3D 65:144
size =3D 280278656
path checker =3D readsector0 (internal default)
#
# all paths :
#
#:#:#:# sdaa 65:160  []
#:#:#:# sdab 65:176  []
#:#:#:# sdac 65:192  []
#:#:#:# sdad 65:208  []
#:#:#:# sdae 65:224  []
#:#:#:# sdaf 65:240  []
#:#:#:# sdag 66:0    []
#:#:#:# sdah 66:16   []
#:#:#:# sdai 66:32   []
#:#:#:# sdaj 66:48   []

...
params =3D 0 0 4 2 round-robin 0 1 1 65:240 1000 round-robin 0 1 1 66:224=
 1000 round-robin 0 1 1 8:16 1000 round-robin 0 1 1 65
:0 1000=20
status =3D 1 0 0 4 2 E 0 1 0 65:240 F 1 A 0 1 0 66:224 A 0 E 0 1 0 8:16 F=
 1 E 0 1 0 65:0 A 0=20
3600601607cf30e00174589a37a31d911
[size=3D127 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [enabled]
  \_ #:#:#:# sdaf 65:240  [failed]
\_ round-robin 0 [active][best]
  \_ #:#:#:# sdau 66:224  [active]
\_ round-robin 0 [enabled]
  \_ #:#:#:# sdb  8:16    [failed]
\_ round-robin 0 [enabled]
  \_ #:#:#:# sdq  65:0    [active]

...

Just what the heck is going on there? ;-)

I don't get any more output than that, sorry.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
