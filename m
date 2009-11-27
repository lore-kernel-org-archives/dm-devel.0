From: "Janec, Jozef" <jozef.janec@hp.com>
Subject: dm-multipath and multipathd verbose mode or debug mode
Date: Fri, 27 Nov 2009 13:18:43 +0000
Message-ID: <A510D7CF8900D246979209B696F496F66531A09494@GVW1088EXB.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids


Hello All,

I have some issues on my server. And I need get more information from mul=
tupath and device mapper about all operation . Is possible enable some de=
bug mode?

I have one vg with two EVA luns, and 4 luns on this VG

Is possible that the multipath cam mix the ids?

For example:=20
PV1 =3D LUN1
PV2 =3D LUN2

PV1 =3D MPATHA =3D LUN2
PV2 =3D MPATHB =3D LUN1

The problem is when I have multipath enabled lvm can see lvols from those=
 two luns but the fs on the luns don't exists and when the multipath is d=
isabled the fs on the lvols is ok?

Or when the boot.multipath is started the FS is mounted without problem
But when the server is done with booting (after the multipatd daemon) the=
 fs is not more accesible. Is possible that multipathd daemon cad so some=
thing what will mix some information that the fs is not available after t=
his  for os? Can activate the paths across?

Best regards

Jozef
