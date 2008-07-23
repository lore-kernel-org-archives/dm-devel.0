From: Hannes Reinecke <hare@suse.de>
Subject: Re: Losing paths
Date: Wed, 23 Jul 2008 08:25:01 +0200
Message-ID: <4886CEBD.5090000@suse.de>
References: <65F9ACC78BD8304BAAEB817634C62D4C060CFB67@AUSMAIL01.americas.ppdi.local>
	<48865AF2.8090000@actcom.co.il>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <48865AF2.8090000@actcom.co.il>
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

Hi Guy,

guy keren wrote:
>=20
> Does the 'tur' checker take into account unit-attention issues (i.e.=20
> when the configuration of a SCSI device changes, the next command comin=
g=20
> from an afected initiator (not necessarily to the same LU) should be=20
> failed with a 'check condition' error and a 'unit attention' sense code=
.
>=20
> if the TUR checker sent a TUR right after the change and before another=
=20
> read/write command was sent - it will be failed, and then the question=20
> is, whether the lower-level driver retries the TUR command, or returns=20
> an error. any idea?
>=20
It does for SLES10 SP2. Upstream not; I'll have to send the
patches one day.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
