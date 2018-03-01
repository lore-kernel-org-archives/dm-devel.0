From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [RFC PATCH] fstests: Check if a fs can survive
 random (emulated) power loss
Date: Thu, 1 Mar 2018 17:25:37 +0800
Message-ID: <ed8aec54-8b90-61cd-74c2-e8a1556849f6@gmx.com>
References: <20180301053821.18718-1-wqu@suse.com>
	<CAOQ4uxgUm-YnFG=M6YaMKqAvr+CewerL3d4S2V6WSwKKu13ebA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1962538689786532650=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAOQ4uxgUm-YnFG=M6YaMKqAvr+CewerL3d4S2V6WSwKKu13ebA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Amir Goldstein <amir73il@gmail.com>, Qu Wenruo <wqu@suse.com>
Cc: dm-devel@redhat.com, fstests <fstests@vger.kernel.org>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============1962538689786532650==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="5xYKpnsQZTmT9TECMVxvVvi1tpmAqPVV6"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5xYKpnsQZTmT9TECMVxvVvi1tpmAqPVV6
Content-Type: multipart/mixed; boundary="WV2cCVP3u0c2RfySAafw2X7sqBEsgG3AF";
	protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Amir Goldstein <amir73il@gmail.com>, Qu Wenruo <wqu@suse.com>
Cc: fstests <fstests@vger.kernel.org>, dm-devel@redhat.com
Message-ID: <ed8aec54-8b90-61cd-74c2-e8a1556849f6@gmx.com>
Subject: Re: [RFC PATCH] fstests: Check if a fs can survive random (emulated)
	power loss
References: <20180301053821.18718-1-wqu@suse.com>
	<CAOQ4uxgUm-YnFG=M6YaMKqAvr+CewerL3d4S2V6WSwKKu13ebA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgUm-YnFG=M6YaMKqAvr+CewerL3d4S2V6WSwKKu13ebA@mail.gmail.com>

--WV2cCVP3u0c2RfySAafw2X7sqBEsgG3AF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8801=E6=97=A5 16:39, Amir Goldstein wrote:
> On Thu, Mar 1, 2018 at 7:38 AM, Qu Wenruo <wqu@suse.com> wrote:
>> This test case is originally designed to expose unexpected corruption
>> for btrfs, where there are several reports about btrfs serious metadat=
a
>> corruption after power loss.
>>
>> The test case itself will trigger heavy fsstress for the fs, and use
>> dm-flakey to emulate power loss by dropping all later writes.
>=20
> So you are re-posting the test with dm-flakey or converting it to
> dm-log-writes??

Working on the scripts to allow us to do --find and then replay.

Since for xfs and ext4, their fsck would report false alerts just for
dirty journal.

I'm adding new macro to locate next flush and replay to it, then mount
it RW before we call fsck.

Or do we have options for those fscks to skip dirty journal?

Thanks,
Qu

>=20
>>
>> For btrfs, it should be completely fine, as long as superblock write
>> (FUA write) finishes atomically, since with metadata CoW, superblock
>> either points to old trees or new tress, the fs should be as atomic as=

>> superblock.
>>
>> For journal based filesystems, each metadata update should be journale=
d,
>> so metadata operation is as atomic as journal updates.
>>
>> It does show that XFS is doing the best work among the tested
>> filesystems (Btrfs, XFS, ext4), no kernel nor xfs_repair problem at al=
l.
>>
>> For btrfs, although btrfs check doesn't report any problem, kernel
>> reports some data checksum error, which is a little unexpected as data=

>> is CoWed by default, which should be as atomic as superblock.
>> (Unfortunately, still not the exact problem I'm chasing for)
>>
>> For EXT4, kernel is fine, but later e2fsck reports problem, which may
>> indicates there is still something to be improved.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  tests/generic/479     | 109 +++++++++++++++++++++++++++++++++++++++++=
+++++++++
>>  tests/generic/479.out |   2 +
>>  tests/generic/group   |   1 +
>>  3 files changed, 112 insertions(+)
>>  create mode 100755 tests/generic/479
>>  create mode 100644 tests/generic/479.out
>>
>> diff --git a/tests/generic/479 b/tests/generic/479
>> new file mode 100755
>> index 00000000..ab530231
>> --- /dev/null
>> +++ b/tests/generic/479
>> @@ -0,0 +1,109 @@
>> +#! /bin/bash
>> +# FS QA Test 479
>> +#
>> +# Test if a filesystem can survive emulated powerloss.
>> +#
>> +# No matter what the solution a filesystem uses (journal or CoW),
>> +# it should survive unexpected powerloss, without major metadata
>> +# corruption.
>> +#
>> +#--------------------------------------------------------------------=
---
>> +# Copyright (c) 2018 SuSE.  All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation=
,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#--------------------------------------------------------------------=
---
>> +#
>> +
>> +seq=3D`basename $0`
>> +seqres=3D$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=3D`pwd`
>> +tmp=3D/tmp/$$
>> +status=3D1       # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +       ps -e | grep fsstress > /dev/null 2>&1
>> +       while [ $? -eq 0 ]; do
>> +               $KILLALL_PROG -KILL fsstress > /dev/null 2>&1
>> +               wait > /dev/null 2>&1
>> +               ps -e | grep fsstress > /dev/null 2>&1
>> +       done
>> +       _unmount_flakey &> /dev/null
>> +       _cleanup_flakey
>> +       cd /
>> +       rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/dmflakey
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs generic
>> +_supported_os Linux
>> +_require_scratch
>> +_require_dm_target flakey
>> +_require_command "$KILLALL_PROG" "killall"
>> +
>> +runtime=3D$(($TIME_FACTOR * 15))
>> +loops=3D$(($LOAD_FACTOR * 4))
>> +
>> +for i in $(seq -w $loops); do
>> +       echo "=3D=3D=3D Loop $i: $(date) =3D=3D=3D" >> $seqres.full
>> +
>> +       _scratch_mkfs >/dev/null 2>&1
>> +       _init_flakey
>> +       _mount_flakey
>> +
>> +       ($FSSTRESS_PROG $FSSTRESS_AVOID -w -d $SCRATCH_MNT -n 1000000 =
\
>> +               -p 100 >> $seqres.full &) > /dev/null 2>&1
>> +
>> +       sleep $runtime
>> +
>> +       # Here we only want to drop all write, don't need to umount th=
e fs
>> +       _load_flakey_table $FLAKEY_DROP_WRITES
>> +
>> +       ps -e | grep fsstress > /dev/null 2>&1
>> +       while [ $? -eq 0 ]; do
>> +               $KILLALL_PROG -KILL fsstress > /dev/null 2>&1
>> +               wait > /dev/null 2>&1
>> +               ps -e | grep fsstress > /dev/null 2>&1
>> +       done
>> +
>> +       _unmount_flakey
>> +       _cleanup_flakey
>> +
>> +       # Mount the fs to do proper log replay for journal based fs
>> +       # so later check won't report annoying dirty log and only
>> +       # report real problem.
>> +       _scratch_mount
>> +       _scratch_unmount
>> +
>> +       _check_scratch_fs
>> +done
>> +
>> +echo "Silence is golden"
>> +
>> +# success, all done
>> +status=3D0
>> +exit
>> diff --git a/tests/generic/479.out b/tests/generic/479.out
>> new file mode 100644
>> index 00000000..290f18b3
>> --- /dev/null
>> +++ b/tests/generic/479.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 479
>> +Silence is golden
>> diff --git a/tests/generic/group b/tests/generic/group
>> index 1e808865..5ce3db1d 100644
>> --- a/tests/generic/group
>> +++ b/tests/generic/group
>> @@ -481,3 +481,4 @@
>>  476 auto rw
>>  477 auto quick exportfs
>>  478 auto quick
>> +479 auto
>=20
> + stress
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--WV2cCVP3u0c2RfySAafw2X7sqBEsgG3AF--

--5xYKpnsQZTmT9TECMVxvVvi1tpmAqPVV6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqXxxEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhLFwgAoX2jkuE9iHfJ2f2W2UCkd6KE
3zDpVt8RvOqf8cMVSrzlQ3mOeJU6fdSlr+IKOfAj3dMHWIzLKUmJ4cY95q2T+gRw
Up1ZfE9/5oAZiNXyNHzaGynSnYCyI/e/yh6VLbGryh6GCUUhjH/owwq2klWNlmCt
N5wllKC8+euwYc66iRbvlADWz7190/bYCMtdd8p1t80OA97VykOfSnnxAwbZRjYO
/WtxFS0jbXpwrEs0WigbNf5acGMQmneuesEbCo9+MOz1+bi88grYbsFes6eIpcMB
IUdbx5UH2BbnSnIpszhh1lq9CI4hIeNuXdNLZFL0qqEfE/pAxluEzaQXKnsgog==
=h1Dh
-----END PGP SIGNATURE-----

--5xYKpnsQZTmT9TECMVxvVvi1tpmAqPVV6--


--===============1962538689786532650==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1962538689786532650==--
