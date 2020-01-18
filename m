From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC PATCH 0/2] Create CAAM HW key in linux keyring and use in
 dmcrypt
Date: Sat, 18 Jan 2020 09:51:04 -0800
Message-ID: <1579369864.3421.16.camel@HansenPartnership.com>
References: <1551456599-10603-1-git-send-email-franck.lenormand@nxp.com>
         <11177.1551893395@warthog.procyon.org.uk>
         <AM6PR04MB54473C2D30DDD7CDC8522DF9924C0@AM6PR04MB5447.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AM6PR04MB54473C2D30DDD7CDC8522DF9924C0@AM6PR04MB5447.eurprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Franck Lenormand <franck.lenormand@nxp.com>, David Howells <dhowells@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>, Horia Geanta <horia.geanta@nxp.com>, Silvano Di Ninno <silvano.dininno@nxp.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jmorris@namei.org" <jmorris@namei.org>, "serge@hallyn.com" <serge@hallyn.com>
List-Id: dm-devel.ids

On Thu, 2019-03-07 at 13:17 +0000, Franck Lenormand wrote:
> > -----Original Message-----
> > From: David Howells <dhowells@redhat.com>
> > Sent: Wednesday, March 6, 2019 6:30 PM
> > To: Franck Lenormand <franck.lenormand@nxp.com>
> > Cc: dhowells@redhat.com; linux-kernel@vger.kernel.org; linux-
> > security-
> > module@vger.kernel.org; keyrings@vger.kernel.org; Horia Geanta
> > <horia.geanta@nxp.com>; Silvano Di Ninno <silvano.dininno@nxp.com>;
> > agk@redhat.com; snitzer@redhat.com; dm-devel@redhat.com;
> > jmorris@namei.org; serge@hallyn.com
> > Subject: Re: [RFC PATCH 0/2] Create CAAM HW key in linux keyring
> > and use in
> > dmcrypt
> > 
> > Franck LENORMAND <franck.lenormand@nxp.com> wrote:
> > 
> > > The capacity to generate or load keys already available in the
> > > Linux
> > > key retention service does not allows to exploit CAAM
> > > capabilities
> > > hence we need to create a new key_type. The new key type
> > > "caam_tk"
> > 
> > allows to:
> > >  - Create a black key from random
> > >  - Create a black key from a red key
> > >  - Load a black blob to retrieve the black key
> > 
> > Is it possible that this could be done through an existing key
> > type, such as the
> > asymmetric, trusted or encrypted key typed?
> > 
> > David
> 
> Hello David,
> 
> I didn't know about asymmetric key type so I looked it up, from my
> observation, it would not be possible to use it for the caam_tk as
> we must perform operations on the data provided.
> The name " asymmetric " is also misleading for the use we would have.
> 
> The trusted and encrypted does not provides the necessary
> callbacks to do what we would need or require huge modifications.
> 
> I would like, for this series to focus on the change related to
> dm-crypt. In effect, it is currently not possible to pass a key
> from the asymmetric key type to it.

What you're performing are all bog standard key wrapping operations
which is why we're asking the question: do we have to expose any of
this to the user?  Can this whole thing not be encapsulated in such a
way that the kernel automatically selects the best key
escrow/accelerator technology on boot and uses it (if there are > 1
there would have to be an interface for the user to choose).  We make
all the accelerator device key formats distinguishable so the kernel
can figure out on load what is supposed to be handling them.  That way
the user never need worry about naming the actual key handler at all,
it would all be taken care of under the covers.

The one key type per escrow/accelerator has us all going ... "aren't
there hundreds of these on the market?"  which would seem to be a huge
usability explosion because a user will likely only have one, but they
have to figure out the type instructions for that one.  I really think
a better way is to have a more generic key type that's capable of
interfacing to the wrap/unwrap and crypto functions in such a way that
the end user doesn't have to know which they're using: most platforms
only have one thing installed, so you use that thing.

James
