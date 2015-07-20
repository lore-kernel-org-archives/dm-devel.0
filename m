From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: back-ported dm-cache not forwarding read-ahead bios to
	origin
Date: Mon, 20 Jul 2015 17:50:07 +0100
Message-ID: <CAM2wQBv43BGGhe+NHOEAz+usppL6CcR-2m_ratKNKR65GB+XVA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5248636548016075899=="
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
To: device-mapper development <dm-devel@redhat.com>
Cc: ejt@redhat.com, snitzer@redhat.com, Mauelshagen@redhat.com
List-Id: dm-devel.ids

--===============5248636548016075899==
Content-Type: multipart/alternative; boundary=047d7bdca29c87b801051b515470

--047d7bdca29c87b801051b515470
Content-Type: text/plain; charset=UTF-8

I'm working on a back-ported dm-cache version for kernel 2.6.32-431.29.2
(the CentOS 6 patched one) and I'm trying to solve a corruption bug
apparently introduced during the back-port. I can consistently reproduce it
by simply mounting an ext4 file-system that contains some data and running
stat(1) against a specific directory. stat(1) fails with "Input/output
error" and dmesg says:"EXT4-fs error (device dm-8): ext4_lookup: deleted
inode referenced: 29". The file-system is mounted with options
"data=writeback,ro,nodiscard,inode_readahead_blks=1" in order to minimise
noise.

Since I'm using the pass-through mode, my theory is that dm-cache:
(1) forwards the bio to the wrong device, and/or
(2) forwards the bio to the wrong location of the device (e,g, bio length
and/or offset are wrong), and/or
(3) copies the wrong piece of data from a forwarded bio to the original
bio, assuming it copies data in the first place (I don't know much about
the device mapper at this point).

I tried to confirm which of the above 3 could be happening by checking
which bio goes where using btrace(8). Specifically, I ran btrace(8) against
the cache target, the HDD, the SSD data and metadata devices (4 traces in
total). I observed that no bios go to the SSD data and metadata devices, so
this rules out (1). I also observed that read-ahead requests issued to the
cache target don't get forwarded to the HDD. I don't know whether or not
this can be a problem in the first place (can read-ahead bios be ignored?),
let alone identifying this being the problem, but I think it's worth it
ensuring that it really doesn't cause any problems.

Below are the traces when mounting the file-system:

cache target trace:
253,8    7        3    27.218701098 28536  Q   R 2 + 2 [mount]
253,8    7        4    27.218726465 28536  U   N [mount] 0
253,8    7        5    27.222694538 28536  Q   R 0 + 8 [mount]
253,8    7        6    27.222707270 28536  U   N [mount] 0
253,8    7        7    27.226580397 28536  Q   R 8 + 8 [mount]
253,8    7        8    27.226598088 28536  U   N [mount] 0
253,8    7        9    27.229666137 28536  Q  RA 2832 + 8 [mount]
253,8    7       10    27.229677500 28536  Q  RM 2824 + 8 [mount]
253,8    7       11    27.229679348 28536  U   N [mount] 0
253,8    1        2    27.222630997 28198  C   R 2 + 2 [0]
253,8    1        3    27.226560799 28198  C   R 0 + 8 [0]
253,8    1        4    27.229570827 28198  C   R 8 + 8 [0]
253,8    1        5    27.232313463 28198  C  RM 2824 + 8 [0]
253,8    3        1    27.229683980 28291  C  RA 2832 + 8 [0]
253,8    7       12    27.232360573 28536  Q   R 4456448 + 8 [mount]
253,8    7       13    27.232402040 28536  U   N [mount] 0
253,8    6        1    27.243263044 28204  C   R 4456448 + 8 [0]

HDD trace:
253,5    1        3    27.222584291 28198  C   R 2 + 2 [0]
253,5    7        2    27.218685545 28536  U   N [(null)] 0
253,5    7        3    27.222664774 28536  U   N [(null)] 0
253,5    3        1    27.218694575 28291  Q   R 2 + 2 [dm-cache]
253,5    3        2    27.222670216 28291  Q   R 0 + 8 [dm-cache]
253,5    3        3    27.226566647 28291  Q   R 8 + 8 [dm-cache]
253,5    1        4    27.226516192 28198  C   R 0 + 8 [0]
253,5    1        5    27.229526352 28198  C   R 8 + 8 [0]
253,5    1        6    27.232269516 28198  C  RM 2824 + 8 [0]
253,5    7        4    27.226555641 28536  U   N [(null)] 0
253,5    7        5    27.229636877 28536  U   N [(null)] 0
253,5    7        6    27.232331776 28536  A   R 4456448 + 8 <- (253,8)
4456448
253,5    7        7    27.232332898 28536  Q   R 4456448 + 8 [(null)]
253,5    7        8    27.232359557 28536  U   N [(null)] 0
253,5    3        4    27.229649990 28291  Q  RM 2824 + 8 [dm-cache]
253,5    6        1    27.243215063 28204  C   R 4456448 + 8 [0]

The "RA 2832 + 8" request (7th line in the 1st trace) issued to the cache
target gets completed without ever reaching the HDD. Is this OK? I've
started looking at the code but I haven't found yet anything specific to
read-ahead bios.

Regarding my 3rd theory (data getting corrupted by dm-cache after read from
the HDD), is there some relatively easy way to confirm this? E.g. could
btrace tell me when a bio completes the checksum of the bio's data?

Is there something else that could be wrong?

--047d7bdca29c87b801051b515470
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I&#39;m working on a back-ported dm-cache version for kern=
el 2.6.32-431.29.2 (the CentOS 6 patched one) and I&#39;m trying to solve a=
 corruption bug apparently introduced during the back-port. I can consisten=
tly reproduce it by simply mounting an ext4 file-system that contains some =
data and running stat(1) against a specific directory. stat(1) fails with &=
quot;Input/output error&quot; and dmesg says:&quot;EXT4-fs error (device dm=
-8): ext4_lookup: deleted inode referenced: 29&quot;. The file-system is mo=
unted with options &quot;data=3Dwriteback,ro,nodiscard,inode_readahead_blks=
=3D1&quot; in order to minimise noise.<div><br></div><div>Since I&#39;m usi=
ng the pass-through mode, my theory is that dm-cache:</div><div>(1) forward=
s the bio to the wrong device, and/or</div><div>(2) forwards the bio to the=
 wrong location of the device (e,g, bio length and/or offset are wrong), an=
d/or</div><div>(3) copies the wrong piece of data from a forwarded bio to t=
he original bio, assuming it copies data in the first place (I don&#39;t kn=
ow much about the device mapper at this point).</div><div><br></div><div>I =
tried to confirm which of the above 3 could be happening by checking which =
bio goes where using btrace(8). Specifically, I ran btrace(8) against the c=
ache target, the HDD, the SSD data and metadata devices (4 traces in total)=
. I observed that no bios go to the SSD data and metadata devices, so this =
rules out (1). I also observed that read-ahead requests issued to the cache=
 target don&#39;t get forwarded to the HDD. I don&#39;t know whether or not=
 this can be a problem in the first place (can read-ahead bios be ignored?)=
, let alone identifying this being the problem, but I think it&#39;s worth =
it ensuring that it really doesn&#39;t cause any problems.</div><div><br></=
div><div>Below are the traces when mounting the file-system:<br></div><div>=
<br></div><div>cache target trace:</div><div><div>253,8 =C2=A0 =C2=A07 =C2=
=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A027.218701098 28536 =C2=A0Q =C2=A0 R =
2 + 2 [mount]</div><div>253,8 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =
=C2=A0 =C2=A027.218726465 28536 =C2=A0U =C2=A0 N [mount] 0</div><div>253,8 =
=C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A027.222694538 28536=
 =C2=A0Q =C2=A0 R 0 + 8 [mount]</div><div>253,8 =C2=A0 =C2=A07 =C2=A0 =C2=
=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A027.222707270 28536 =C2=A0U =C2=A0 N [mount]=
 0</div><div>253,8 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=
=A027.226580397 28536 =C2=A0Q =C2=A0 R 8 + 8 [mount]</div><div>253,8 =C2=A0=
 =C2=A07 =C2=A0 =C2=A0 =C2=A0 =C2=A08 =C2=A0 =C2=A027.226598088 28536 =C2=
=A0U =C2=A0 N [mount] 0</div><div>253,8 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0=
 =C2=A09 =C2=A0 =C2=A027.229666137 28536 =C2=A0Q =C2=A0RA 2832 + 8 [mount]<=
/div><div>253,8 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0 10 =C2=A0 =C2=A027.2296=
77500 28536 =C2=A0Q =C2=A0RM 2824 + 8 [mount]</div><div>253,8 =C2=A0 =C2=A0=
7 =C2=A0 =C2=A0 =C2=A0 11 =C2=A0 =C2=A027.229679348 28536 =C2=A0U =C2=A0 N =
[mount] 0</div><div>253,8 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=
=A0 =C2=A027.222630997 28198 =C2=A0C =C2=A0 R 2 + 2 [0]</div><div>253,8 =C2=
=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A027.226560799 28198 =
=C2=A0C =C2=A0 R 0 + 8 [0]</div><div>253,8 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=
=A0 =C2=A04 =C2=A0 =C2=A027.229570827 28198 =C2=A0C =C2=A0 R 8 + 8 [0]</div=
><div>253,8 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A027.232=
313463 28198 =C2=A0C =C2=A0RM 2824 + 8 [0]</div><div>253,8 =C2=A0 =C2=A03 =
=C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A027.229683980 28291 =C2=A0C =C2=A0=
RA 2832 + 8 [0]</div><div>253,8 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0 12 =C2=
=A0 =C2=A027.232360573 28536 =C2=A0Q =C2=A0 R 4456448 + 8 [mount]</div><div=
>253,8 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0 13 =C2=A0 =C2=A027.232402040 285=
36 =C2=A0U =C2=A0 N [mount] 0</div><div>253,8 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =
=C2=A0 =C2=A01 =C2=A0 =C2=A027.243263044 28204 =C2=A0C =C2=A0 R 4456448 + 8=
 [0]</div></div><div><br></div><div>HDD trace:</div><div><div>253,5 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A027.222584291 28198 =C2=A0=
C =C2=A0 R 2 + 2 [0]</div><div>253,5 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0 =
=C2=A02 =C2=A0 =C2=A027.218685545 28536 =C2=A0U =C2=A0 N [(null)] 0</div><d=
iv>253,5 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A027.222664=
774 28536 =C2=A0U =C2=A0 N [(null)] 0</div><div>253,5 =C2=A0 =C2=A03 =C2=A0=
 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A027.218694575 28291 =C2=A0Q =C2=A0 R 2 +=
 2 [dm-cache]</div><div>253,5 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =
=C2=A0 =C2=A027.222670216 28291 =C2=A0Q =C2=A0 R 0 + 8 [dm-cache]</div><div=
>253,5 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A027.22656664=
7 28291 =C2=A0Q =C2=A0 R 8 + 8 [dm-cache]</div><div>253,5 =C2=A0 =C2=A01 =
=C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A027.226516192 28198 =C2=A0C =C2=A0=
 R 0 + 8 [0]</div><div>253,5 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =
=C2=A0 =C2=A027.229526352 28198 =C2=A0C =C2=A0 R 8 + 8 [0]</div><div>253,5 =
=C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A027.232269516 28198=
 =C2=A0C =C2=A0RM 2824 + 8 [0]</div><div>253,5 =C2=A0 =C2=A07 =C2=A0 =C2=A0=
 =C2=A0 =C2=A04 =C2=A0 =C2=A027.226555641 28536 =C2=A0U =C2=A0 N [(null)] 0=
</div><div>253,5 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A02=
7.229636877 28536 =C2=A0U =C2=A0 N [(null)] 0</div><div>253,5 =C2=A0 =C2=A0=
7 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A027.232331776 28536 =C2=A0A =C2=
=A0 R 4456448 + 8 &lt;- (253,8) 4456448</div><div>253,5 =C2=A0 =C2=A07 =C2=
=A0 =C2=A0 =C2=A0 =C2=A07 =C2=A0 =C2=A027.232332898 28536 =C2=A0Q =C2=A0 R =
4456448 + 8 [(null)]</div><div>253,5 =C2=A0 =C2=A07 =C2=A0 =C2=A0 =C2=A0 =
=C2=A08 =C2=A0 =C2=A027.232359557 28536 =C2=A0U =C2=A0 N [(null)] 0</div><d=
iv>253,5 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A027.229649=
990 28291 =C2=A0Q =C2=A0RM 2824 + 8 [dm-cache]</div><div>253,5 =C2=A0 =C2=
=A06 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A027.243215063 28204 =C2=A0C =
=C2=A0 R 4456448 + 8 [0]</div></div><div><br></div><div>The &quot;RA 2832 +=
 8&quot; request (7th line in the 1st trace) issued to the cache target get=
s completed without ever reaching the HDD. Is this OK? I&#39;ve started loo=
king at the code but I haven&#39;t found yet anything specific to read-ahea=
d bios.</div><div><br></div><div>Regarding my 3rd theory (data getting corr=
upted by dm-cache after read from the HDD), is there some relatively easy w=
ay to confirm this? E.g. could btrace tell me when a bio completes the chec=
ksum of the bio&#39;s data?</div><div><br></div><div>Is there something els=
e that could be wrong?</div></div>

--047d7bdca29c87b801051b515470--


--===============5248636548016075899==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5248636548016075899==--
