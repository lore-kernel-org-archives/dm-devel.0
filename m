From: David Binderman <dcb314@hotmail.com>
Subject: linux-4.4-rc5 bug report ?
Date: Mon, 14 Dec 2015 12:22:44 +0000
Message-ID: <DUB128-W85E2287516BB8B636D5C119CED0@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
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
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello there,

[linux-4.4-rc5/drivers/md/persistent-data/dm-space-map-metadata.c:160]: (st=
yle) Variable 'bop' is assigned a value that is never used.

=A0=A0=A0 bop =3D brb->bops + brb->begin;
=A0=A0=A0 brb->begin =3D brb_next(brb, brb->begin);

=A0=A0=A0 return 0;

Suggest either use the variable in some way, or delete it.

Regards

David Binderman
 		 	   		  =
