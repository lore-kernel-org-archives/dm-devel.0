From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement
 LSM (IPE)
Date: Sun, 02 Aug 2020 09:43:26 -0700
Message-ID: <1596386606.4087.20.camel@HansenPartnership.com>
References: <20200728213614.586312-1-deven.desai@linux.microsoft.com>
         <20200802115545.GA1162@bug> <20200802140300.GA2975990@sasha-vm>
         <20200802143143.GB20261@amd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MrVpu3P/x22sFTzai/hX"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200802143143.GB20261@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Cc: snitzer@redhat.com, Deven Bowers <deven.desai@linux.microsoft.com>, zohar@linux.ibm.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, paul@paul-moore.com, mdsakib@microsoft.com, jmorris@namei.org, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, jannh@google.com, linux-block@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, corbet@lwn.net, linux-kernel@vger.kernel.org, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, jaskarankhurana@linux.microsoft.com
List-Id: dm-devel.ids


--=-MrVpu3P/x22sFTzai/hX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2020-08-02 at 16:31 +0200, Pavel Machek wrote:
> On Sun 2020-08-02 10:03:00, Sasha Levin wrote:
> > On Sun, Aug 02, 2020 at 01:55:45PM +0200, Pavel Machek wrote:
> > > Hi!
> > >=20
> > > > IPE is a Linux Security Module which allows for a configurable
> > > > policy to enforce integrity requirements on the whole system.
> > > > It attempts to solve the issue of Code Integrity: that any code
> > > > being executed (or files being read), are identical to the
> > > > version that was built by a trusted source.
> > >=20
> > > How is that different from security/integrity/ima?
> >=20
> > Maybe if you would have read the cover letter all the way down to
> > the 5th paragraph which explains how IPE is different from IMA we
> > could avoided this mail exchange...
>=20
> "
> IPE differs from other LSMs which provide integrity checking (for
> instance,
> IMA), as it has no dependency on the filesystem metadata itself. The
> attributes that IPE checks are deterministic properties that exist
> solely
> in the kernel. Additionally, IPE provides no additional mechanisms of
> verifying these files (e.g. IMA Signatures) - all of the attributes
> of
> verifying files are existing features within the kernel, such as
> dm-verity
> or fsverity.
> "
>=20
> That is not really helpful.

I think what the above is trying to to is to expose is an IMA
limitation that the new LSM fixes.  I think what it meant to say is
that IMA uses xattrs to store the signature data which is the "metadata
dependency".  However, it overlooks the fact that IMA can use appended
signatures as well, which have no metadata dependency, so I'm not sure
I've helped you understand why this is different from IMA.

Perhaps a more convincing argument is that IMA hooks into various
filesystem "gates" to perform integrity checks (file read and file
execute being the most obvious).  This LSM wants additional gates
within device mapper itself that IMA currently doesn't hook into.

Perhaps the big question is: If we used the existing IMA appended
signature for detached signatures (effectively becoming the
"properties" referred to in the cover letter) and hooked IMA into
device mapper using additional policy terms, would that satisfy all the
requirements this new LSM has?

James

--=-MrVpu3P/x22sFTzai/hX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iHUEABMIAB0WIQTnYEDbdso9F2cI+arnQslM7pishQUCXybtLgAKCRDnQslM7pis
hWimAP9T9I/4sBSeBrGI7NqoyKwG2H+cwtXr/XrBRxwSXraDUgD/TFHreLGqN12U
JeJ3dF9i/fLU2fxGJpJrexE3/T8J3AQ=
=Q5Lc
-----END PGP SIGNATURE-----

--=-MrVpu3P/x22sFTzai/hX--
