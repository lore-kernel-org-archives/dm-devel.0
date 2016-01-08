From: NeilBrown <neilb@suse.com>
Subject: Re: WANTED new maintainer for Linux/md (and mdadm)
Date: Fri, 08 Jan 2016 13:38:24 +1100
Message-ID: <8760z4aj8f.fsf@notabene.neil.brown.name>
References: <87k2o849j5.fsf@notabene.neil.brown.name> <20160104182402.GA1541@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160104182402.GA1541@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "J. Bruce Fields" <bfields@fieldses.org>, Phil Turmel <philip@turmel.org>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain

On Tue, Jan 05 2016, Shaohua Li wrote:

>
> Hi Neil,
>
> Thanks for all the efforts! We will definitely miss you and fortunately you
> won't completely quit from MD :). I'm very interested in helping maintain MD. I
> have been working on MD for several years. My employer (facebook) supports me,
> so I have time being a maintainer too.

Hi Shaohua,
 as you are one of the more active developers of MD at the moment, this
 probably affects you more than many others and your willingness to
 contribute more is certainly welcome.

 The first question is where do you send your patches to get the
 appropriate review and upstream acceptance.  Alasdair or Mike (DM),
 Jens (Block), Andrew Morton (anything) and Linus (everything) are all
 defensible choices for upstreaming (I've submitted through Andrew in
 the past, but through Linus exclusively once I figured out git).  That
 is really something you and they would need to negotiate though.

 I plan to submit a pull request to Linus for the 4.5 merge window
 and then stop queuing patches.  I will still review your journaling
 patches but will likely reply with "Reviewed-by" rather than "applied,
 thanks".
 My intention is to only look at other patches if they already have an
 independent "Reviewed-by", but it remains to be seen how strongly I
 stick to that intention.

 If you have specific questions about anything (md internals, git
 work-flows, whatever) do feel free to ask.
 I am trying to write some comprehensive documentation on the internals
 of MD - though it is slow going.  Once that is mostly done I'll make it
 available and it should at least serve as a good structure in which to
 place answers to further questions.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWjyEgAAoJEDnsnt1WYoG5qMwQAJ7KgnYkWnd0ikzV6KCGo/bq
uUavtpz+BEHAfUDQXFGepplmuryndnOBqcHHomqV8HNxxYZlA4v9xOKbXtucvLuD
fYkVBxdnGKPyGz0RN1vRgIG0pIpPyX7o/Ztcz1AKxHpVxyNH7+oByBlSKjm48lUV
4ntm6NgIQ1hXVip5ZsxtJ6EsHv3TUpmaiaoGHcvDskIvXCX+qgXUIg5TUivI0Lhy
1uxINIsDIpbaf3NTOV66m51xLBUyAvLwT+QzNZcejGkVXbmvT5JgjC0tbcVr7Pax
s61JGnO2jMQ3AoBeXLdowtx502EhnwzdacvNfYpkLDhqqOood6equimKep5JvY8w
3l9yfSslHgRmTSiRHvdBheu81sg64UjONXlkVji6nE/qDa76so7yJuuXdlN9n2V0
7pgyLEWk9AZTpkGjcpUodWiKQC0EErLHa52/x05NlF+NQE7UvGA5W6qUxbVeeQMJ
XD32VwQd2GrU/Ab7SX7P/ITyfjdSR2ThWfi+8HKYIIl7nkXFDhvH8QmQI2hVRhZ6
bTRkoUOOYbrScRsKu9H5cboLMitDrKpkhLFrAueYqxdVDiPKekBal+0cqz+M2xG6
5JfpXBSh2unHf4A3wYhtEPya7rSDB/3+WgL6ZRnb4z/Z/4q8/JmHnOFpnectEhvW
dSfogg6q9fqKlaLeUsJL
=9Ih7
-----END PGP SIGNATURE-----
--=-=-=--
