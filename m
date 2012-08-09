From: Wesley Miaw <wmiaw@netflix.com>
Subject: Re: [dm-devel] [PATCH v2 2/2] dm: verity support data device offset
 (Linux 3.4.7)
Date: Thu, 9 Aug 2012 17:09:35 +0000
Message-ID: <FF8AA703-9B2B-46B4-9637-8A7FCF92BC78@netflix.com>
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com>
 <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com>
 <5022CC99.30103@redhat.com>
 <AD722D70-2E9C-4B2D-BE48-B94E2268C3DD@netflix.com>
 <5022D29B.9000402@redhat.com>
 <C8AA8C7B-505E-49E8-AE47-C24843E74543@netflix.com>
 <50235A25.6010705@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="Apple-Mail=_140D9E51-76C0-43C6-8922-88E514F61E58";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50235A25.6010705@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, "msb@google.com" <msb@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?Windows-1252?Q?Will_Drewry=99?= <w@google.com>
List-Id: dm-devel.ids

--Apple-Mail=_140D9E51-76C0-43C6-8922-88E514F61E58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=windows-1252

On Aug 8, 2012, at 11:35 PM, Milan Broz wrote:

> On 08/09/2012 02:40 AM, Wesley Miaw wrote:
>> 
>> 
>> This isn't as polished because I pretty much just added support to do
>> what I needed. I'm not sure if the LKML is the right place to post,
>> so let me know if I should send this somewhere else.
> 
> This is libcryptsetup userspace so better list for this is dmcrypt
> mailing list (and/or cc me, I will handle these changes anyway).

I will continue this thread on the dm-crypt mailing list.

Thanks,
--
Wesley Miaw
--Apple-Mail=_140D9E51-76C0-43C6-8922-88E514F61E58
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)

iQEcBAEBAgAGBQJQI+7PAAoJELoPFVk1ivvR4kcH/3UgTH2viOzBYo2VoJdBmefi
NKgW4HCCE0+8D5mxouhdy/0Zt6rtkWcWXyZo6VjLMxNwytis4Y3Yg2m4FfmqwkJG
xjQ50iJZ7t4qSEEOVvzeSrrECceNEbellDYFWH+V+7N3G09XE40SGNQsHFeJnzQz
fnzjkrx8yNC6xXuVLttZU0sYLvCTBWxcPkVdInb+DNgUUJ9tyIGx36n+4RSgYyl0
ft9VplC1oiAlAX8J2ob/lvvS2ehKXWOnqk770ocGR9/ktibSlMO+dkvo14IZDQqc
dF/lDKbtXljBhlUh8ekIjX29O0lXCgRv9LM1Hnb3ajyd3pdkRD5/SxK6dxahTHQ=
=eXHf
-----END PGP SIGNATURE-----

--Apple-Mail=_140D9E51-76C0-43C6-8922-88E514F61E58--
