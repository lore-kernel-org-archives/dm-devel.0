From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: dm-crypt userland key patch
Date: Fri, 15 Apr 2005 23:48:09 +0200
Message-ID: <62b0912f05041514485f38f872@mail.gmail.com>
References: <ac71172a05041310417117dd09@mail.gmail.com>
	<20050413235852.45bd2500@emotpin>
	<62b0912f05041400135426a80e@mail.gmail.com>
	<20050414141459.6d521f67@emotpin>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050414141459.6d521f67@emotpin>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bjorn Andersson <bjorn.andersson@silversmedjan.se>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Bjorn Andersson wrote:
> > > Patch to the dm-crypt module so that it hides the crypto-key from
> > > userland. (dmsetup table)
> >
> > Does it also overwrite the key in memory when unloading dm-crypt, mak=
e
> > sure that the memory is pinned so the key doesn't leak to swap, unloa=
d
> > the key before a 'hibernate', and that sort of stuff?
>
> No, this does only report a key of zeros when the status is requested.
>=20
> The unloading thing is no problem to fix, but how should the
> 'hibernate' thing work? When you resume after a 'hibernate' you probabl=
y
> expect that the device is there, especially if it's on the root
> partition. But I clearly see your point.

*Scratches head*, I'd expect the default to be "doing the safe thing",
eg. picking up on hibernation and nuking the key (disabling any crypto
devices).  If there's a lean no-hassles user interface to get the
password entered and the devices up again when the machine is resumed,
I'd imagine most users to be happy about it, especially when they're
told that it's done to protect their encrypted data?

There might be a few people annoyed by it?  Or there might even be
some obscure technical reason why you'd want your keys to survive
hibernation..  For those cases there could be an option to disable
"hibernation protection" or what not.

Dunno, IANA expert :-o.
