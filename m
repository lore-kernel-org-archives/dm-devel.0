From: Hannes Reinecke <hare@suse.de>
Subject: Re: Problem with ALUA Handler
Date: Fri, 09 Nov 2007 08:39:30 +0100
Message-ID: <47340EB2.5090109@suse.de>
References: <110b17190711081232p41664102tfc0f3dea861d322a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <110b17190711081232p41664102tfc0f3dea861d322a@mail.gmail.com>
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
> Hi,
>=20
> I tried compiling ALUA handler code from Hannes Reincke
> (https://www.redhat.com/archives/dm-devel/2007-October/msg00033.html)
> on kernel 2.6.18 and with few modifications it did fine.
>=20
> I was even able to load it, but it fails for the std inquiry and hence
> does not do anything further. It returns error that the controller
> does not support TPGS.
>=20
This is preliminary code only. I've done a rework of the ALUA handler
and will post the updated code here shortly.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
