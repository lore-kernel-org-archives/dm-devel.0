From: Pellegrino Prevete <pellegrinoprevete@gmail.com>
Subject: lvmcache volume gets 100% dirty blocks after power loss
 regardless of previous state
Date: Fri, 12 Jul 2019 18:22:03 +0200
Message-ID: <20190712182203.7c1e3591@seagull>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2831425852437896340=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============2831425852437896340==
Content-Type: multipart/signed; boundary="Sig_/exE0nx=jtV4S/_jIL7TUM9y";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/exE0nx=jtV4S/_jIL7TUM9y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi everyone,

I have set up a lvmcache lv (on archlinux) using as fast disk the emmc
of my laptop and as slow one a microsd card inserted in the integrated
slot, following the man instructions.

Its dimensions are 10gb and 41gb respectively and I am using this lv
as /home partition.
I used default options, excluding having set 'writeback' as
cachemode.
=20
After I transferred the data (30gb) I noticed that cache used
blocks and cache dirty blocks were now both above 99.94%.

When after some time I tried to turn off the laptop, the shutdown
procedure, being unable to complete the lv unmounting in the time
frame assigned to the task (4m), simply skipped it and the computer was
forced to shut down.

On next boots I found that when not booting in recovery mode the drive
could not be mounted most of the times.

In general, if I shutted down the system before the dirty blocks
percentage went to 0%, it would become 100% all over again at the next
boot.

So I decided to change cachemode to 'writethrough' and wait for the
cache dirty blocks to be zero to see if doing so would solve the
problem.

To my surprise, it took over 24 hours.

With 0% dirty blocks, the system was obviously booting fine.
Also, having previously switched to 'writethrough', I expected in
general not to have dirty blocks at all anymore.=20

Today I forgot to attach the power cable and the laptop shutted
down because of low power.

After this, booting has become difficult again and dirty blocks are
again 99%.

Also, judging from iostat output writes on the sd card (happening in
the background I believe) are really really slow.

I wanted to know:
- if this behaviour is normal,
- if there is a way to avoid it apart from clean shutting downs at 0%
  dirty blocks,
- why do I have dirty blocks in 'writethrough' mode,
- if there is a way to empty the cache without erasing the whole volume,
- if there is a way to trigger the cleaning process directly with an
  'high' priority.

Cheers,
Pellegrino

--Sig_/exE0nx=jtV4S/_jIL7TUM9y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEErBQraTyBRt4W7kAGmR3ZDmkT6/YFAl0os6sACgkQmR3ZDmkT
6/YrwRAAjwHnwtQL8CUEOSkziQHGQdLxaV/aw2KQpz1cYyPsi2vKclr8otE2FKwj
7VtjIFSk3Sm/BUeIKFp5pPCuAJii+kaku036c9Whmud8osgf64pcO+HL63J29fNC
+SPBzDDBQnKc84nIUor2Pdhz9Pp9VMZ5O+H1myrPZhPojZDAZwpbGSR7MAtYkvrJ
AzOi2VlnmZbOqPr83K8o81FNhtZD2pxqd8HUHqzoFcvUvvQdFykKQfs+6aMXI+Mq
Vxcta5vZoGesR3HkOIVI9QKNoZyTBJCL4OTqzUOKDENqqqOO75sKHtZZkGQPQCtZ
hA8fuqX039BYyE0jUlvXKtfzGY3cSyxinpykpzWWKJe0BiaWcv0Q15uUqC7pDoQB
3uWvfyQV6fUNPhLN2lg7FwOQtDHwM9ijjaB+je7gM9CnQmxOXs81+80dZtve8OxR
EfsRD3846Vp/xGMyLhJCRLyFpWyA8TeqxscYCHYS3nDHFkVDZNmSdf9bpZu8uloB
M8y1nCJc9H+nBxoSguwYjb92Lyx3a+9jkeuosTKfkBQvXWlFANOwjb5e8v5fZ3iD
uJLB2S32RThwdXIG8BfSR222Rabk86tvy+7uHy8UsTEJJkliLTiXX8NjhBRAS8k0
FXuVqYuRw0c76H4EO2ghFKYbt2QaOyrRiKGZGwG3wR/YTywjm7U=
=GSnp
-----END PGP SIGNATURE-----

--Sig_/exE0nx=jtV4S/_jIL7TUM9y--


--===============2831425852437896340==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2831425852437896340==--
