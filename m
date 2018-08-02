From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC] [PATCH 0/1] Introduce emergency raid0 stop for
	mounted arrays
Date: Thu, 02 Aug 2018 11:51:35 +1000
Message-ID: <87tvodpmc8.fsf@notabene.neil.brown.name>
References: <20180801145608.19880-1-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8698904288438877936=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180801145608.19880-1-gpiccoli@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-raid@vger.kernel.org, shli@kernel.org
Cc: kernel@gpiccoli.net, gpiccoli@canonical.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, jay.vosburgh@canonical.com
List-Id: dm-devel.ids

--===============8698904288438877936==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

On Wed, Aug 01 2018, Guilherme G. Piccoli wrote:

> Currently the md driver completely relies in the userspace to stop an
> array in case of some failure. There's an interesting case for raid0: if
> we remove a raid0 member, like PCI hot(un)plugging an NVMe device, and
> the raid0 array is _mounted_, mdadm cannot stop the array, since the tool
> tries to open the block device (to perform the ioctl) with O_EXCL flag.
>
> So, in this case the array is still alive - users may write to this
> "broken-yet-alive" array and unless they check the kernel log or some
> other monitor tool, everything will seem fine and the writes are completed
> with no errors. Being more precise, direct writes will not work, but since
> usually writes are done in a regular form, i.e., backed by the page
> cache, the most common scenario is an user being able to regularly write
> to a broken raid0, and get all their data corrupted.
>
> PROPOSAL:
> The idea proposed here to fix this behavior is mimic other block devices:
> if one have a filesystem mounted in a block device on top of an NVMe or
> SCSI disk and the disk gets removed, writes are prevented, errors are
> observed and it's obvious something is wrong. Same goes for USB sticks,
> which are sometimes even removed physically from the machine without
> getting their filesystem unmounted before.
>
> We believe right now the md driver is not behaving properly for raid0
> arrays (it is handling these errors for other levels though). The approach
> took for raid-0 is basically an emergency removal procedure, in which I/O
> is blocked from the device, the regular clean-up happens and the associate
> disk is deleted. It went to extensive testing, as detailed below.
>
> Not all are roses, we have some caveats that need to be resolved.
> Feedback is _much appreciated_.

If you have hard drive and some sectors or track stop working, I think
you would still expect IO to the other sectors or tracks to keep
working.

For this reason, the behaviour of md/raid0 is to continue to serve IO to
working devices, and only fail IO to failed/missing devices.

It seems reasonable that you might want a different behaviour, but I
think that should be optional.  i.e. you would need to explicitly set a
"one-out-all-out" flag on the array.  I'm not sure if this should cause
reads to fail, but it seems quite reasonable that it would cause all
writes to fail.

I would only change the kernel to recognise the flag and refuse any
writes after any error has been seen.
I would use udev/mdadm to detect a device removal and to mark the
relevant component device as missing.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAltiY6cACgkQOeye3VZi
gbllpg//Uo2juv8crEDjznKeaBZwRfDIOzQB/A9+l6ZQZ7m8yYeiec5w2P5XgFmT
rtg6wJ1ugwyA3G+jUrNvdavvXFVQpoqM8GVH1r6YcXkjIxhvZeHE15JNWJUdBlb+
j43MaIuAY38ZLUhAw+cnFfCH5wo8nP634sx4/KgPcm5fyaWJoMRt5B5mSrYy9kj3
COdGnlZc+ulwomzVVeeMQdBh12TD2LBbtxbk7xV68PaZXPHW2VUr8taIB2AyhpDW
3LW2GA2HkMcaXFDaW7baYVQjJf6mDfkC6qPFljMGv49jBTQqOvH6PmHrAZVg7ysh
PqGaqPyH2TJzE/THAHV0t1zC9r5ycWTVpkJLyAw4kmy8QZA9yiqOAZyxXvveVoQX
NtvclnM4EFHoe5vKDpewEBKO7a/XjLKvMA22kJX9Csv8c4Ue9PCXpSxFGevLMdWq
/sx/Y8Omdbn5FCAEE1y0Fcj1GfPZR59x/VKYe8QxlcBPeX8T24kVI6oz4drrdTaU
qseZKB5TewTw8IzVICUzOu/lwPBMgH6ItwTd9vxe0LwYttIZYNXTFAF3P307REbi
79hKc/D2IWnS1AP6DLMAQPutYTI3ebzIAFPBAP7LkjN4oC5hFxN8Ku3DRKFaJopO
V1rk2J+kZkA7wHIj2ZHfcXXaIRWdcHyJUEvv2LGOXNXKtCuJjx4=
=QkMt
-----END PGP SIGNATURE-----
--=-=-=--


--===============8698904288438877936==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8698904288438877936==--
