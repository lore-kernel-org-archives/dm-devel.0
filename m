From: Franck Lenormand <franck.lenormand@nxp.com>
Subject: RE: [RFC PATCH 0/2] Create CAAM HW key in linux keyring and use in
 dmcrypt
Date: Thu, 7 Mar 2019 13:17:48 +0000
Message-ID: <AM6PR04MB54473C2D30DDD7CDC8522DF9924C0@AM6PR04MB5447.eurprd04.prod.outlook.com>
References: <1551456599-10603-1-git-send-email-franck.lenormand@nxp.com>
 <11177.1551893395@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <11177.1551893395@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>, Horia Geanta <horia.geanta@nxp.com>, Silvano Di Ninno <silvano.dininno@nxp.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jmorris@namei.org" <jmorris@namei.org>, "serge@hallyn.com" <serge@hallyn.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: David Howells <dhowells@redhat.com>
> Sent: Wednesday, March 6, 2019 6:30 PM
> To: Franck Lenormand <franck.lenormand@nxp.com>
> Cc: dhowells@redhat.com; linux-kernel@vger.kernel.org; linux-security-
> module@vger.kernel.org; keyrings@vger.kernel.org; Horia Geanta
> <horia.geanta@nxp.com>; Silvano Di Ninno <silvano.dininno@nxp.com>;
> agk@redhat.com; snitzer@redhat.com; dm-devel@redhat.com;
> jmorris@namei.org; serge@hallyn.com
> Subject: Re: [RFC PATCH 0/2] Create CAAM HW key in linux keyring and use =
in
> dmcrypt
>=20
> Franck LENORMAND <franck.lenormand@nxp.com> wrote:
>=20
> > The capacity to generate or load keys already available in the Linux
> > key retention service does not allows to exploit CAAM capabilities
> > hence we need to create a new key_type. The new key type "caam_tk"
> allows to:
> >  - Create a black key from random
> >  - Create a black key from a red key
> >  - Load a black blob to retrieve the black key
>=20
> Is it possible that this could be done through an existing key type, such=
 as the
> asymmetric, trusted or encrypted key typed?
>=20
> David

Hello David,

I didn't know about asymmetric key type so I looked it up, from my
observation, it would not be possible to use it for the caam_tk as
we must perform operations on the data provided.
The name " asymmetric " is also misleading for the use we would have.

The trusted and encrypted does not provides the necessary
callbacks to do what we would need or require huge modifications.

I would like, for this series to focus on the change related to
dm-crypt. In effect, it is currently not possible to pass a key
from the asymmetric key type to it.

Franck
