From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH v4 1/1] add display of map information in
 JSON format
Date: Sat, 21 May 2016 09:34:23 +0800
Message-ID: <20160521013423.GB3862@redhat.com>
References: <1463592394-18974-1-git-send-email-tgill@redhat.com>
	<1463592394-18974-2-git-send-email-tgill@redhat.com>
	<20160519135032.GA969@redhat.com> <573F6C8B.8080008@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3543372912857074321=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <573F6C8B.8080008@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Todd Gill <tgill@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============3543372912857074321==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 20, 2016 at 03:59:07PM -0400, Todd Gill wrote:
>=20
> Hi Gris,
>=20
> On 05/19/2016 09:50 AM, Gris Ge wrote:
> > On Wed, May 18, 2016 at 01:26:34PM -0400, Todd Gill wrote:
> >>
> >> v4:
> >>
> >> removed space in major_version and minor_version keys.
> > Hi Todd,
> >=20
> > Few things:
> >     * Please provide path group id from 'pgindex' of struct path.
>=20
> The paths are contained inside the groups they belong.  Why do we need
> the 'pgindex'?
>=20
The pgindex could be used for switching active path group, so I
would like to see that property show in 'path_group' object.
Yes. The pgindex is the index of 'path_groups' array.
But I prefer it been show explicitly as 'pg_id' in 'path_group'
section.
> >=20
> >     * Replace key name 'host adapter' with 'host_adapter'.
>=20
> I followed what is displayed via 'multipathd show wildcards'.  You
> are thinking there should not be spaces in keys?  Valid JSON does
> allow spaces in keys.  I thought it was best to be consistent with
> the description of the wild card.
>=20
We are defining the API, why should API be consistent with
CLI output which is inconsistent on naming scheme? Now we got:
    total_q_time
    dm-st
    host WWNN

> >     * Remove output properties as many as you can, only expose
> >       those with clear user case and good definition.
> >       For API, it's easy to add but hard to remove or change.
> >       For example: IMHO, we don't need to expose
> >       hcil, next_check, size, serial right now,
>=20
> These values are already available via the format specifiers for
> output.  I think we are already committed to them.
>=20
Again. Why API sync with CLI output?
For example, each path are having the identical 'size' and 'serial',
why duplicate the information?

IMHO, exposing all properties used by 'multipath -ll' is sufficient
for initial patch. We could always add more properties when needed or
user requested.
> >=20
> >     * Performance concern. I am getting bad performance(25 seconds
> >       while previous 'raw format' way only take 1.5 seconds) on 10k
> >       disks. I am still investigating which part slow things down.
> >=20
>=20
> There are performance problems with systems that have a large number
> of maps (3k+).  But they are not related to the JSON changes.  The
> JSON displays in less time than "show maps topology".
>=20
> I think if we want to address the performance/scale issues - we
> should do it with a separate patch set.
OK.
>=20
> Thanks,
> Todd

--=20
Gris Ge

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXP7sfAAoJEGzN5Y/kHij/DXkP/326LyCz7SnkUhGwx2FmDo6D
uQepdQPeBETJYp10BQJSdWpj+tGmWXKQ+YWjW4HPhgB43UNUZKEjkQhmIUc4SZkG
/DKPGGTHC/GYka4t1MLV237US1JG3qJgnOrtKUSCZh7UIoJiY191oJlb3tPkPRqt
kauMsNOTDWrupPOQ9SeIbqL8t03DzdC7GGgM0PmMxHFnSj6wSe89m0PetKhohe3R
yPaMCShGdapVFHaAFNLqvgoiuHilLzkm51+YGUzDCWoc4ixAJ5dITyUV41oiQ474
ZXU4WqhPmjbxkhe+yFrcCz88wdZ5PLngXsxBPazyzVscjI9wmnk94uKKgTdYXxLh
I1+nBQfMCS2YAUQ3qjHedTTh3OcDqpUobVLf4HmRJiKug6f6Z4nKOL2muUAG0ewp
TBP6dhb0NFq6N2Tjlnv7xThYvWmu154aRuQMAm3RLqpN9nk7nh0W7XnpzscHxY2g
06D1atdwujMeIFVgbniD+bRaY/E0gQQ1voJu1XYhkxd5kyovGYSJlXOnCNNLHsQt
ABBxiJCNMnxm9Ck5+T7lNv6pHi5ljnC3e0NVD3GH/Ilhtguso6r208ZY0+tcI4jm
UTQe+hVLHOBJiy8jMgJV5vb1/9QaRibFKi/knyUC0DAaiHkNgbV3ReTD4nM7U3J7
ofZkkX8eiVdo3dF+d+RN
=yh+c
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--


--===============3543372912857074321==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3543372912857074321==--
