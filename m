From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] [LSF/MM TOPIC] block: extend generic biosets to allow per-device frontpad
Date: Fri, 02 Feb 2018 17:19:33 +1100
Message-ID: <87zi4r29sa.fsf@notabene.neil.brown.name>
References: <20180129213300.GC5744@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180129213300.GC5744@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain

On Mon, Jan 29 2018, Mike Snitzer wrote:

> I'd like to enable bio-based DM to _not_ need to clone bios.  But to do
> so each bio-based DM target's required per-bio-data would need to be
> provided by upper layer biosets (as opposed to the bioset DM currently
> creates).
>
> So my thinking is that all system-level biosets (e.g. fs_bio_set,
> blkdev_dio_pool) would redirect to a device specific variant bioset IFF
> the underlying device advertises the need for a specific per-bio-data
> payload to be provided.
>
> I know this _could_ become a rathole but I'd like to avoid reverting DM
> back to the days of having to worry about managing mempools for the
> purpose of per-io allocations.  I've grown spoiled by the performance
> and elegance that comes with having the bio and per-bio-data allocated
> from the same bioset.
>
> Thoughts?

md/raid0 remaps each bio and passes it directly down to one of several
devices.
I think your scheme would mean that it would need to clone each bio to
make sure it is from the correctly sized pool.

I suspect it could be made to work though.

1/ have a way for the driver receiving a bio to discover how much
   frontpad was allocated.
2/ require drivers to accept bios with any size of frontpad, but a
   fast-path is taken if it is already big enough.
3/ allow a block device to advertise it's preferred frontpad.
4/ make sure your config-change-notification mechanism can communicate
   changes to this number.
5/ gather statistics on what percentage of bios have a too-small
   frontpad.

Then start modifying places that allocate bios to use the hint,
and when benchmarks show the percentage is high - use it to encourage
other people to allocate better bios.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlp0AvUACgkQOeye3VZi
gblURBAAjE+opJaOYrWK32UPF2U6QAH3mwOd6zpqv4cCsnCkjtgywdJ2fD8pSsYa
8YlzNNvrKTT8KWrZ1RyNNTSOUhlJgjq3aIQ98kSANgBYVhCzWhYjNSwktEQGT7YJ
UXUqecflKftpokV/D3ISdGhiz64ZVKOmPQTizsLNVzFUilEVP3CvKu0fqzw+CcZW
pxR9dFS/drBHNVckTBzj/9chc4+3vm88ybR73at81Gr27BwPWaqjnu5tS2WlVNzX
xno8STBbtOOfbtjkSAwesDwWbcqQyj8YAi3iQabKMHRf9NEWZtsa56iJg23YPuSH
8D617hU86PZWw302rzibB8AkZenp4pqgOXJCH6xresV9ZYFvSyaJi/oaVe9+a0vO
mdna+6e9/dWjai22mRpp0/xmpWcdRxH9cK+fy0sPq9QmU5nnHfnrNo9K8G2fK/bE
rk6tSh51rqNa+GEZHRXYtgQOhpUUQtwwYbE8xebD0WG25U16/BnowLQb0jDrhqdF
I/OaxAiEOC95tvqGE2Br1YdmHnvvJF7eAEiXh/0OTNyW1S/nqWnHQ5PTlG35iaLG
ltL4g5iTu6dWswb092x5+By5NeFJBcMI0n0ejc3Sqw9/xcs5QRKVvGN4/1EoSdp/
JIOQVgNhc+iSUmLU3ucoWKYfOq+GG+kIMdNlwFMhkDuK/ZhFFEA=
=weO7
-----END PGP SIGNATURE-----
--=-=-=--
