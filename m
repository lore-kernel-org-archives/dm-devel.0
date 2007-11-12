From: Hannes Reinecke <hare@suse.de>
Subject: Re: Problem with ALUA Handler
Date: Mon, 12 Nov 2007 08:18:59 +0100
Message-ID: <4737FE63.6020803@suse.de>
References: <110b17190711081232p41664102tfc0f3dea861d322a@mail.gmail.com>	<47340EB2.5090109@suse.de>
	<110b17190711091148t4c59ccfxfd59ab6298c10cc0@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <110b17190711091148t4c59ccfxfd59ab6298c10cc0@mail.gmail.com>
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

Pradipmaya Maharana wrote:
> Thanks Hannes.
>=20
> Actually I could get it to work after making some changes;
> In the function prepare_req(), I replaced
>=20
> //rq->cmd_flags |=3D REQ_FAILFAST | REQ_NOMERGE;
> 	rq->flags |=3D REQ_FAILFAST | REQ_NOMERGE;
>=20
> with following:
>=20
> rq->flags |=3D REQ_BLOCK_PC | REQ_SPECIAL | REQ_QUIET;
>=20
> This worked for me.
>=20

Errm. Which version you're compiling against?
The hardware handler is done against scsi-misc; by the
looks of it you're compiling against some older version
(2.6.19? 2.6.16?)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
