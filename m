From: Hannes Reinecke <hare@suse.de>
Subject: Re: simple question... to tough to answer?
Date: Fri, 16 May 2008 13:19:13 +0200
Message-ID: <482D6DB1.5080709@suse.de>
References: <7BC3A7DB53028743B733D298244A8C626E3A0D@sjcpexch02.citrite.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7BC3A7DB53028743B733D298244A8C626E3A0D@sjcpexch02.citrite.net>
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

Hi Wim,

Wim Colgate wrote:
> Hi,
>=20
> I=E2=80=99m not quite sure why no one in the community hasn=E2=80=99t b=
een able to=20
> answer my questions.
>=20
> Simply (re)stated:
>=20
> 1) Are there hooks for dm/multipath events to notify software?
>=20
Yes. There is the general dm_event mechanism (which I wouldn't recommend)
or with newer kernels you'll get netlink events from multipath for any
path-related events.

> 2) does path down/up fire up udev rules?
>=20
Not as such. As stated above we should be sending out netlink events for
path up/down events, but to my knowledge no-one is taking advantage
of them. Certainly not udev in its default setting nor multipath.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
