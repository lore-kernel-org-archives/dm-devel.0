From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [RFC PATCH] fstests: Check if a fs can survive
 random (emulated) power loss
Date: Thu, 1 Mar 2018 19:48:59 +0800
Message-ID: <0abab816-a2a4-82bf-e43e-37535f1228a8@gmx.com>
References: <20180301053821.18718-1-wqu@suse.com>
	<CAOQ4uxgUm-YnFG=M6YaMKqAvr+CewerL3d4S2V6WSwKKu13ebA@mail.gmail.com>
	<ed8aec54-8b90-61cd-74c2-e8a1556849f6@gmx.com>
	<CAOQ4uxhy7iU71dB9aTFx+aeMowNoi0QMVT2GDUM81R_CTZxxsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3539770600295386135=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAOQ4uxhy7iU71dB9aTFx+aeMowNoi0QMVT2GDUM81R_CTZxxsA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Amir Goldstein <amir73il@gmail.com>
Cc: dm-devel@redhat.com, fstests <fstests@vger.kernel.org>, Qu Wenruo <wqu@suse.com>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============3539770600295386135==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="Y9Jgnd9gWtIV0NySRodybwCrnStACtCa8"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Y9Jgnd9gWtIV0NySRodybwCrnStACtCa8
Content-Type: multipart/mixed; boundary="hJfxcjimY5zu3NaeblJVDl5FBh7hWfjB0";
	protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>, fstests <fstests@vger.kernel.org>,
	dm-devel@redhat.com
Message-ID: <0abab816-a2a4-82bf-e43e-37535f1228a8@gmx.com>
Subject: Re: [RFC PATCH] fstests: Check if a fs can survive random (emulated)
	power loss
References: <20180301053821.18718-1-wqu@suse.com>
	<CAOQ4uxgUm-YnFG=M6YaMKqAvr+CewerL3d4S2V6WSwKKu13ebA@mail.gmail.com>
	<ed8aec54-8b90-61cd-74c2-e8a1556849f6@gmx.com>
	<CAOQ4uxhy7iU71dB9aTFx+aeMowNoi0QMVT2GDUM81R_CTZxxsA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhy7iU71dB9aTFx+aeMowNoi0QMVT2GDUM81R_CTZxxsA@mail.gmail.com>

--hJfxcjimY5zu3NaeblJVDl5FBh7hWfjB0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8801=E6=97=A5 19:15, Amir Goldstein wrote:
> On Thu, Mar 1, 2018 at 11:25 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8801=E6=97=A5 16:39, Amir Goldstein wrote:
>>> On Thu, Mar 1, 2018 at 7:38 AM, Qu Wenruo <wqu@suse.com> wrote:
>>>> This test case is originally designed to expose unexpected corruptio=
n
>>>> for btrfs, where there are several reports about btrfs serious metad=
ata
>>>> corruption after power loss.
>>>>
>>>> The test case itself will trigger heavy fsstress for the fs, and use=

>>>> dm-flakey to emulate power loss by dropping all later writes.
>>>
>>> So you are re-posting the test with dm-flakey or converting it to
>>> dm-log-writes??
>>
>> Working on the scripts to allow us to do --find and then replay.
>>
>> Since for xfs and ext4, their fsck would report false alerts just for
>> dirty journal.
>>
>> I'm adding new macro to locate next flush and replay to it, then mount=

>> it RW before we call fsck.
>>
>> Or do we have options for those fscks to skip dirty journal?
>>
>=20
> No, you are much better off doing mount/umount before fsck.
> Even though e2fsck can replay a journal, it does that much slower
> then the kernel does.
>=20
> But why do you need to teach --find to find next flush?
> You could use a helper script to run every fua with --fsck --check fua.=

> Granted, for fstests context, I agree that --find next fua may look
> nicer, so I have no objection to this implementation.

The point is, in my opinion fua is not the worst case we need to test.
Only flush could leads us to the worst case we really need to test.

In btrfs' case, if we finished flush, but without fua, we have a super
block points to all old trees, but all new trees are already written to
disk.

In that flush entry, we could reach to the worst case scenario to verify
all btrfs tricks are working all together to get a completely sane btrfs
(even all data should be correct).

This should also apply to journal based filesystems (if I understand the
journal thing correctly), even when all journals written but superblock
not updated, we should be completely fine.
(Although for journal, we may need to reach fua entry instead of flush?)

And the other reason why we need to find next flush/fua manually is,
mount will write new data, and we need to replay all the sequence until
next flush/fua.


And finally the reason about why need manually mount is, we need to
workaround e2fsck/xfs_repair, so that they won't report dirty journal as
error. If we have extra options to disable such behavior, I'm completely
OK with current --check flush/fua --fsck method.
(BTW, for my btrfs testing, --check flush --fsck is completely good
enough, to exposed possible free space cache related problems)

Thanks,
Qu

>=20
> Thanks,
> Amir.
>=20


--hJfxcjimY5zu3NaeblJVDl5FBh7hWfjB0--

--Y9Jgnd9gWtIV0NySRodybwCrnStACtCa8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqX6KsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjEoQf+LUYIiHp804+keC/Z2M4PpW60
KM09szcT8nnVmWgIRK1ukKadm5w8F0neqTMkLRdOQVVQ5NynBvBLM5D6PUiGkckD
tBBHyE6Fv+7f/lgX5aJvY7SPRKZP5ze5uzhRBr0Qpe1y5kd3BYYbb9beL7xEI6cs
blxeP9OisUbMyg5HFusugXMcucjTa8Y0btztL1mcVcS7QPeO9emEnllQCBI8apLy
yKjwd5MWKvSQbnaLQDheJdWqTCfTuPUEL+Pla4vAOYE+kcCf6fMgUZP6bByQbcMQ
P+nfy3dQC33+iWpG55qG7haDf+IOMwPC215NX430EVAeU7Q4eTqbVfbexd4ibQ==
=Vjqi
-----END PGP SIGNATURE-----

--Y9Jgnd9gWtIV0NySRodybwCrnStACtCa8--


--===============3539770600295386135==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3539770600295386135==--
