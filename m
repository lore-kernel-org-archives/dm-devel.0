From: Hannes Reinecke <hare@suse.de>
Subject: Re: Designing a new prio_callout
Date: Fri, 10 Aug 2007 17:07:00 +0200
Message-ID: <46BC7F14.80302@suse.de>
References: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>	<46A735E1.4070206@suse.de>	<d61540a40707290903q359cc7c8g52f07627b4b9fba7@mail.gmail.com>	<46AD85A5.1060609@suse.de>
	<d61540a40708091055u725fa5e4wa182ac1d778323be@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d61540a40708091055u725fa5e4wa182ac1d778323be@mail.gmail.com>
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
> Is it possible to manually set the priority of a path after a connectio=
n has
> been established?
>=20
> Since we're doing failover-only (only 1 active path at a time), it woul=
d be
> nice to tell users that they can manually reset priority after a failur=
e.
> For example, in a configuration with two paths, where one is active and=
 the
> other is passive for two differeent volumes, a failure of one path will
> result in all traffic going through the one remaining path. After the s=
econd
> path comes back up, all traffic will still be written to the first path
> (paths are not rebalanced after a failure).
>=20
Not necessarily. There is the keyword 'failback', which can be set to=20
IMMEDIATE, causing all paths to fail back to the original path once it
comes back.

And as you don't actually need to send any commands for facilitate
the failover I doubt you'd need to develop your own hardware handler.

The existing tweaks should be enough, I think.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
