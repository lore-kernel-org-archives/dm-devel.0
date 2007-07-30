From: Hannes Reinecke <hare@suse.de>
Subject: Re: Designing a new prio_callout
Date: Mon, 30 Jul 2007 08:31:01 +0200
Message-ID: <46AD85A5.1060609@suse.de>
References: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>	<46A735E1.4070206@suse.de>
	<d61540a40707290903q359cc7c8g52f07627b4b9fba7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d61540a40707290903q359cc7c8g52f07627b4b9fba7@mail.gmail.com>
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

Ethan John wrote:
> Thanks for the heads-up about ALUA. We're looking into it.
>=20
> What is the purpose of the custom mpio_prio_* applications that ship
> with open-iscsi if not to handle multipathing?
>=20
It is. mpath_prio_* are the priority callouts for multipathing.
They determine the layout of the multipath map.
Theory is that mpath_prio_* will return the priority for a
given path in relation to the entire multipath layout.

If used with 'group_by_prio' all paths with the same
priority will be grouped into one multipath group, and
the group with the highest priority will become active.

When all paths in a group fail, the group with the next
highest priority will become active. Additionally some
failover command (as determined by the hardware handler)
may be send to the target.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
