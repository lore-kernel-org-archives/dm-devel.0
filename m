From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: Possible bug in mirror target
Date: Mon, 4 Feb 2019 17:47:20 -0700
Message-ID: <CAN-y+EKdQnRWck4B3Ms0ZGHqEL4+V+xPb-G3vhPy+Qe0DMO0oA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0390950059329611733=="
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

--===============0390950059329611733==
Content-Type: multipart/alternative; boundary="0000000000004b7a2305811af4ce"

--0000000000004b7a2305811af4ce
Content-Type: text/plain; charset="UTF-8"

Hi,

I'm assuming all user space code is expected to use the handle_errors
feature, so this isn't that big of a deal. I'm also using 4.19.13, which I
think is more recent than the latest update to dm-raid1.c

That said, there may be a bug that causes the entire mirror to crash if
there is an error on the first leg of the mirror, but not on the 2nd leg.

Works fine if you do cause IO errors on the 2nd leg:

root@kernel-dev:~# dmsetup create zerodev --table "0 1073741824 zero"
root@kernel-dev:~# dmsetup create errordev --table "0 1073741824 error"


root@kernel-dev:~# dmsetup create mirror-table --table "0 1073741824 mirror
core 2 524288 nosync 2 /dev/mapper/zerodev 0 /dev/mapper/errordev 0 0"
root@kernel-dev:~# dd if=/dev/zero of=/dev/mapper/mirror-table bs=512
count=1
1+0 records in
1+0 records out
512 bytes copied, 0.000417845 s, 1.2 MB/s
root@kernel-dev:~# dd if=/dev/zero of=/dev/mapper/mirror-table bs=512
count=1
1+0 records in
1+0 records out
512 bytes copied, 0.00036228 s, 1.4 MB/s
root@kernel-dev:~# dmsetup status mirror-table
0 1073741824 mirror 2 253:1 253:2 2047/2048 1 AD 1 core
root@kernel-dev:~# dmsetup remove mirror-table


The whole mirror fails if you do the error device on the first leg:

root@kernel-dev:~# dmsetup create mirror-table --table "0 1073741824 mirror
core 2 524288 nosync 2 /dev/mapper/errordev 0 /dev/mapper/zerodev 0 0"
root@kernel-dev:~# dd if=/dev/zero of=/dev/mapper/mirror-table bs=512
count=1
1+0 records in
1+0 records out
512 bytes copied, 0.000274188 s, 1.9 MB/s
root@kernel-dev:~# dd if=/dev/zero of=/dev/mapper/mirror-table bs=512
count=1
dd: error writing '/dev/mapper/mirror-table': Input/output error
1+0 records in
0+0 records out
0 bytes copied, 0.000857634 s, 0.0 kB/s

root@kernel-dev:~# dmsetup status mirror-table
0 1073741824 mirror 2 253:2 253:1 2047/2048 1 DA 1 core

dmesg would be:

[ 1935.876401] device-mapper: raid1: Mirror read failed from 253:2. Trying
alternative device.
[ 1939.091919] device-mapper: raid1: Mirror read failed.

Thanks for your time!

--0000000000004b7a2305811af4ce
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div di=
r=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr">Hi,<div><br></div><div><div>I&#=
39;m assuming all user space code is expected to use the handle_errors feat=
ure, so this isn&#39;t that big of a deal. I&#39;m also using 4.19.13, whic=
h I think is more recent than the latest update to=C2=A0dm-raid1.c</div></d=
iv><div><br></div><div>That said, there may be a bug that causes the entire=
 mirror to crash if there is an error on the first leg of the mirror, but n=
ot on the 2nd leg.</div><div><br></div><div>Works fine if you do cause IO e=
rrors on the 2nd leg:</div><div><br></div><div><div>root@kernel-dev:~# dmse=
tup create zerodev --table &quot;0 1073741824 zero&quot;</div><div>root@ker=
nel-dev:~# dmsetup create errordev --table &quot;0 1073741824 error&quot;</=
div><div><br></div><div><br></div><div><div>root@kernel-dev:~# dmsetup crea=
te mirror-table --table &quot;0 1073741824 mirror core 2 524288 nosync 2 /d=
ev/mapper/zerodev 0 /dev/mapper/errordev 0 0&quot;</div><div>root@kernel-de=
v:~# dd if=3D/dev/zero of=3D/dev/mapper/mirror-table bs=3D512 count=3D1</di=
v><div>1+0 records in</div><div>1+0 records out</div><div>512 bytes copied,=
 0.000417845 s, 1.2 MB/s</div><div>root@kernel-dev:~# dd if=3D/dev/zero of=
=3D/dev/mapper/mirror-table bs=3D512 count=3D1</div><div>1+0 records in</di=
v><div>1+0 records out</div><div>512 bytes copied, 0.00036228 s, 1.4 MB/s</=
div></div><div>root@kernel-dev:~# dmsetup status mirror-table</div><div>0 1=
073741824 mirror 2 253:1 253:2 2047/2048 1 AD 1 core</div><div>root@kernel-=
dev:~# dmsetup remove mirror-table<br></div><div><br></div><div><br></div><=
div>The whole mirror fails if you do the error device on the first leg:<br>=
</div><div><br></div><div>root@kernel-dev:~# dmsetup create mirror-table --=
table &quot;0 1073741824 mirror core 2 524288 nosync 2 /dev/mapper/errordev=
 0 /dev/mapper/zerodev 0 0&quot;</div><div>root@kernel-dev:~# dd if=3D/dev/=
zero of=3D/dev/mapper/mirror-table bs=3D512 count=3D1</div><div>1+0 records=
 in</div><div>1+0 records out</div><div>512 bytes copied, 0.000274188 s, 1.=
9 MB/s</div><div>root@kernel-dev:~# dd if=3D/dev/zero of=3D/dev/mapper/mirr=
or-table bs=3D512 count=3D1</div><div>dd: error writing &#39;/dev/mapper/mi=
rror-table&#39;: Input/output error</div><div>1+0 records in</div><div>0+0 =
records out</div><div>0 bytes copied, 0.000857634 s, 0.0 kB/s</div></div><d=
iv><br></div><div><div>root@kernel-dev:~# dmsetup status mirror-table</div>=
<div>0 1073741824 mirror 2 253:2 253:1 2047/2048 1 DA 1 core</div></div><di=
v><br>dmesg would be:<br><br><div>[ 1935.876401] device-mapper: raid1: Mirr=
or read failed from 253:2. Trying alternative device.</div><div>[ 1939.0919=
19] device-mapper: raid1: Mirror read failed.</div></div><div><br></div><di=
v>Thanks for your time!</div><div><br></div></div></div></div></div></div><=
/div></div>

--0000000000004b7a2305811af4ce--


--===============0390950059329611733==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0390950059329611733==--
