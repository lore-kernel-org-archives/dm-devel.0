From: Vladimir Smolensky <arizal@gmail.com>
Subject: Re: dm-cache fs corruption
Date: Wed, 22 Jan 2014 03:04:28 +0200
Message-ID: <CALwk7=zoUDOnszedL-Wxf-Bdfw0qmH2XF6TBdn6akjnjdP=LLw@mail.gmail.com>
References: <CALwk7=z+Xc8Xrcw5jo8DtKwT9KS2gQMumtaHTws0w4+VDs2NwQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8903802208925924458=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CALwk7=z+Xc8Xrcw5jo8DtKwT9KS2gQMumtaHTws0w4+VDs2NwQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8903802208925924458==
Content-Type: multipart/alternative; boundary=001a1136a478ea750d04f084b487

--001a1136a478ea750d04f084b487
Content-Type: text/plain; charset=ISO-8859-1

Okay, update on the problem.

Tested with
Linux v-5-231-d1862-150 3.13.0-rc8 #1 SMP Fri Jan 17 17:55:34 GMT 2014
x86_64 Intel(R) Xeon(R) CPU E5620 @ 2.40GHz GenuineIntel GNU/Linux


dm-cache breaks when cache gets full, again

dmesg:

Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589304] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589310] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589312] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589315] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589317] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589319] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589322] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589324] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589326] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589328] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589331] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589333] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589335] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589337] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589339] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589342] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589344] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589346] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589349] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589351] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589353] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589355] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589357] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589360] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589362] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589364] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589366] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589368] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589371] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589373] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589375] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589377] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589448] XFS (dm-0):
metadata I/O error: block 0x2aeb4ee40 ("xfs_trans_read_buf_map") error 117
numblks 16
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589455] XFS (dm-0):
xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590202] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590206] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590209] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590212] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590214] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590216] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590218] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590221] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590223] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590225] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590227] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590229] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590232] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590234] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590236] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590238] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590241] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590243] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590245] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590248] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590250] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590252] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590254] XFS (dm-0):
Corruption detected. Unmount and run xfs_repair

and so on... it just repeats the same

 blockdev --report
RO    RA   SSZ   BSZ   StartSec            Size   Device
rw   256   512  4096          0     26843414528   /dev/sda
rw   256   512  4096       2048      4094689280   /dev/sda1
rw   256   512  4096    7999488     22479372288   /dev/sda2
rw  2048   512  4096          0  20973392756736   /dev/sdb
rw  2048   512  4096       2048  20973390659584   /dev/sdb1
rw  2048   512  4096          0   2397799710720   /dev/sdc
rw  2048   512  4096       2048      1023410176   /dev/sdc1
rw  2048   512  4096    2000896   2396774203392   /dev/sdc2
rw  2048   512   512          0  20973390659584   /dev/dm-0


 dmsetup table
storage: 0 40963653632 cache 8:33 8:34 8:17 8192 1 writeback default 0

dmsetup status
storage: 0 40963653632 cache 1152/249856 86805905 9729090 1164931 47563307
0 525209 525209 0 1 writeback 2 migration_threshold 10000000 4
random_threshold 4 sequential_threshold 10000000


Cache size ~2.2T, origin ~20TB

If you need more specific info, please tell  me what.

reagrds.





On Wed, Nov 13, 2013 at 12:24 PM, Vladimir Smolensky <arizal@gmail.com>wrote:

> Hello,
> I've been testing dm-cache for use with static web content.
> It appears that, when using big cache ~3TB(+20TB origin dev) dm-cache
> device corrupts the filesystem after block eviction starts to happen.
> If I set smaller cache size - single 480GB ssd(again with 20TB origin
> dev), the dm-cache dev works just fine.
>
>
> dmesg error:
>
> XFS (dm-0): Corruption detected. Unmount and run xfs_repair
> XFS (dm-0): metadata I/O error: block 0x3d4f534e0
> ("xfs_trans_read_buf_map") error 117 numblks 16
> XFS (dm-0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
> XFS (dm-0): Corruption detected. Unmount and run xfs_repair
> XFS (dm-0): Corruption detected. Unmount and run xfs_repair
>
>
> ext4 also got broken.
>
>
> Tested with 3.10.11-gentoo, fedora 19- kernel 3.11.something, xfs, ext4,
> writeback and writethrough modes.
>
>
>
> regards,
> Vladimir Smolensky
>

--001a1136a478ea750d04f084b487
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Okay, update on the problem.<br><br></div>T=
ested with <br>Linux v-5-231-d1862-150 3.13.0-rc8 #1 SMP Fri Jan 17 17:55:3=
4 GMT 2014 x86_64 Intel(R) Xeon(R) CPU E5620 @ 2.40GHz GenuineIntel GNU/Lin=
ux<br>
<br><br></div>dm-cache breaks when cache gets full, again<br><br></div><div=
>dmesg:<br><br>Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589304] XF=
S (dm-0): Corruption detected. Unmount and run xfs_repair<br>Jan 22 00:34:5=
5 v-5-231-d1862-150 kernel: [362737.589310] XFS (dm-0): Corruption detected=
. Unmount and run xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589312] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589315] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589317] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589319] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589322] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589324] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589326] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589328] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589331] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589333] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589335] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589337] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589339] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589342] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589344] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589346] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589349] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589351] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589353] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589355] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589357] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589360] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589362] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589364] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589366] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589368] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589371] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589373] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589375] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.589377] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589448] XFS (dm-0): metad=
ata I/O error: block 0x2aeb4ee40 (&quot;xfs_trans_read_buf_map&quot;) error=
 117 numblks 16<br>Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.589455=
] XFS (dm-0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590202] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.590206] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590209] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.590212] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590214] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.590216] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590218] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.590221] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590223] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.590225] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590227] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.590229] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590232] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.590234] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590236] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.590238] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590241] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.590243] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590245] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.590248] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590250] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br>Jan 22 00:34:55 v-5-231-d1862=
-150 kernel: [362737.590252] XFS (dm-0): Corruption detected. Unmount and r=
un xfs_repair<br>
Jan 22 00:34:55 v-5-231-d1862-150 kernel: [362737.590254] XFS (dm-0): Corru=
ption detected. Unmount and run xfs_repair<br><br></div><div>and so on... i=
t just repeats the same<br><br>=A0blockdev --report<br>RO=A0=A0=A0 RA=A0=A0=
 SSZ=A0=A0 BSZ=A0=A0 StartSec=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0=A0 D=
evice<br>
rw=A0=A0 256=A0=A0 512=A0 4096=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0 268=
43414528=A0=A0 /dev/sda<br>rw=A0=A0 256=A0=A0 512=A0 4096=A0=A0=A0=A0=A0=A0=
 2048=A0=A0=A0=A0=A0 4094689280=A0=A0 /dev/sda1<br>rw=A0=A0 256=A0=A0 512=
=A0 4096=A0=A0=A0 7999488=A0=A0=A0=A0 22479372288=A0=A0 /dev/sda2<br>rw=A0 =
2048=A0=A0 512=A0 4096=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0 20973392756736=A0=A0=
 /dev/sdb<br>
rw=A0 2048=A0=A0 512=A0 4096=A0=A0=A0=A0=A0=A0 2048=A0 20973390659584=A0=A0=
 /dev/sdb1<br>rw=A0 2048=A0=A0 512=A0 4096=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=
=A0 2397799710720=A0=A0 /dev/sdc<br>rw=A0 2048=A0=A0 512=A0 4096=A0=A0=A0=
=A0=A0=A0 2048=A0=A0=A0=A0=A0 1023410176=A0=A0 /dev/sdc1<br>rw=A0 2048=A0=
=A0 512=A0 4096=A0=A0=A0 2000896=A0=A0 2396774203392=A0=A0 /dev/sdc2<br>
rw=A0 2048=A0=A0 512=A0=A0 512=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0 209733906595=
84=A0=A0 /dev/dm-0<br><br><br>=A0dmsetup table<br>storage: 0 40963653632 ca=
che 8:33 8:34 8:17 8192 1 writeback default 0<br><br>dmsetup status<br>stor=
age: 0 40963653632 cache 1152/249856 86805905 9729090 1164931 47563307 0 52=
5209 525209 0 1 writeback 2 migration_threshold 10000000 4 random_threshold=
 4 sequential_threshold 10000000<br>
<br><br></div><div>Cache size ~2.2T, origin ~20TB<br><br></div><div>If you =
need more specific info, please tell=A0 me what.<br><br></div><div>reagrds.=
<br><br></div><div><div><br><br></div></div></div><div class=3D"gmail_extra=
">
<br><br><div class=3D"gmail_quote">On Wed, Nov 13, 2013 at 12:24 PM, Vladim=
ir Smolensky <span dir=3D"ltr">&lt;<a href=3D"mailto:arizal@gmail.com" targ=
et=3D"_blank">arizal@gmail.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div dir=3D"ltr"><div><div><div><div>Hello,<br></div>I&#39;ve been testing =
dm-cache for use with static web content.<br></div>It appears that, when us=
ing big cache ~3TB(+20TB origin dev) dm-cache device corrupts the filesyste=
m after block eviction starts to happen.<br>

</div>If I set smaller cache size - single 480GB ssd(again with 20TB origin=
 dev), the dm-cache dev works just fine.<br><br><br></div>dmesg error:<br><=
br>XFS (dm-0): Corruption detected. Unmount and run xfs_repair<br>XFS (dm-0=
): metadata I/O error: block 0x3d4f534e0 (&quot;xfs_trans_read_buf_map&quot=
;) error 117 numblks 16<br>


XFS (dm-0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.<br>XFS=
 (dm-0): Corruption detected. Unmount and run xfs_repair<br>XFS (dm-0): Cor=
ruption detected. Unmount and run xfs_repair<br><div><br><br></div><div>

ext4 also got broken.<br></div><div><br><br></div><div>Tested with 3.10.11-=
gentoo, fedora 19- kernel 3.11.something, xfs, ext4, writeback and writethr=
ough modes.<br><br><br></div><div><br>regards,<br></div><div>Vladimir Smole=
nsky<br>

</div></div>
</blockquote></div><br></div>

--001a1136a478ea750d04f084b487--


--===============8903802208925924458==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8903802208925924458==--
