From: Marko Huttunen <marko@codito.se>
Subject: XFS getting EAGAIN from block device
Date: Tue, 7 Jun 2011 22:44:14 +0200
Message-ID: <BANLkTinc-zSEY5uQ-8i__KzWPp24Q-yB+w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7640980743610944278=="
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

--===============7640980743610944278==
Content-Type: multipart/alternative; boundary=20cf3054a29d6e2c5f04a52548a1

--20cf3054a29d6e2c5f04a52548a1
Content-Type: text/plain; charset=ISO-8859-1

Hello,

After upgrading Ubuntu from 10.10 to 11.04 I started getting error messages
in my syslog when accessing one of my xfs partitions. It is not the root
partition.

The helpful team on IRC (#xfs on irc.freenode.net) says that what I want to
do is figure out why I'm getting -EAGAIN from the block device.

The error message I get when accessing the filesystem (through nautilus, or
in a terminal) is:

<snip>
Jun  7 18:08:14 picard kernel: [ 2602.542458] I/O error in filesystem
("dm-4") meta-data dev dm-4 block 0x41c6dc18       ("xfs_trans_read_buf")
error 11 buf count 4096
Jun  7 18:08:14 picard kernel: [ 2602.548673] I/O error in filesystem
("dm-4") meta-data dev dm-4 block 0x41c23898       ("xfs_trans_read_buf")
error 11 buf count 4096
Jun  7 18:08:14 picard kernel: [ 2602.553135] I/O error in filesystem
("dm-4") meta-data dev dm-4 block 0x41c133a8       ("xfs_trans_read_buf")
error 11 buf count 4096
</snip>
... and so on.

The helpful team on IRC supplied me with a patch to understand the error
message alittle better.

Filename: hch_patch
<snip>
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1264,6 +1264,9 @@ xfs_buf_bio_end_io(
unsigned int            blocksize = bp->b_target->bt_bsize;
struct bio_vec          *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;

+       if (error && error != -EIO && error != -EOPNOTSUPP)
+               printk("XFS: got error %d in %s\n", error, __func__);
+
xfs_buf_ioerror(bp, -error);

if (!error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
</snip>

After fetching a new kernel source, unmounting my xfs partition, applying
the patch (running: "patch -p1 < hch_patch" in /usr/src/linux-2.6.38) and
making a new module (running: "make -C /lib/modules/`uname -r`/build
M=`pwd`/fs/xfs" in /usr/src/linux-2.6.38), removing the old module (running:
"rmmod xfs.ko") and then insmoding the new (running: "insmod xfs.ko") I get
the following error message:

<snip>
Jun  7 20:25:21 picard kernel: [10821.778982] XFS: got error -11 in
xfs_buf_bio_end_io
Jun  7 20:25:21 picard kernel: [10821.780263] I/O error in filesystem
("dm-4") meta-data dev dm-4 block 0x41c6dc18       ("xfs_trans_read_buf")
error 11 buf count 4096XFS: got error -11 in xfs_buf_bio_end_io
Jun  7 20:25:21 picard kernel: [10821.781403] I/O error in filesystem
("dm-4") meta-data dev dm-4 block 0x41c23898       ("xfs_trans_read_buf")
error 11 buf count 4096XFS: got error -11 in xfs_buf_bio_end_io
Jun  7 20:25:21 picard kernel: [10821.796254] I/O error in filesystem
("dm-4") meta-data dev dm-4 block 0x41c133a8       ("xfs_trans_read_buf")
error 11 buf count 4096XFS: got error -11 in xfs_buf_bio_end_io
</snip>
... and so on.

After a while when for example extracting a zip archive I get the following
error messages:

<snip>
Jun  7 20:28:38 picard kernel: [11018.263647] XFS: got error -11 in
xfs_buf_bio_end_io
Jun  7 20:28:38 picard kernel: [11018.263842] XFS: got error -11 in
xfs_buf_bio_end_io
Jun  7 20:28:41 picard kernel: [11021.399311] XFS: got error -11 in
xfs_buf_bio_end_io
Jun  7 20:28:41 picard kernel: [11021.435716] I/O error in filesystem
("dm-4") meta-data dev dm-4 block 0x3a53bbf0       ("xfs_trans_read_buf")
error 11 buf count 4096
Jun  7 20:28:41 picard kernel: [11021.435724] xfs_force_shutdown(dm-4,0x1)
called from line 3894 of file /usr/src/linux-2.6.38/fs/xfs/xfs_bmap.c.
 Return address = 0xffffffffa0fa34a2
Jun  7 20:28:41 picard kernel: [11021.580677] Filesystem dm-4: I/O Error
Detected.  Shutting down filesystem: dm-4
Jun  7 20:28:42 picard kernel: [11021.580683] Please umount the filesystem,
and rectify the problem(s)
Jun  7 20:29:12 picard kernel: [11023.043494] Filesystem dm-4:
xfs_log_force: error 5 returned.
Jun  7 20:29:42 picard kernel: [11053.015272] Filesystem dm-4:
xfs_log_force: error 5 returned.
</snip>
... and so on

Accessing the device is slower than before the upgrade to 11.04, and it is
not without errors that I can access the device.

$ uname -r
Linux picard 2.6.38-8-generic #42-Ubuntu SMP Mon Apr 11 03:31:24 UTC 2011
x86_64 x86_64 x86_64 GNU/Linux


HW specs:
The XFS partition is run on a HW Raid on 2 x 1TB WD Black Caviar.
Motherboard is an ASUS Sabertooth P67 with Intel Sandy Bridge i5-2500K CPU @
3.30GHz.


Do you guys know what might be wrong, how I or you or we can solve this?


Regards,

Marko

--20cf3054a29d6e2c5f04a52548a1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,<div><br></div><div>After upgrading Ubuntu from 10.10 to 11.04 I star=
ted getting error messages in my syslog when accessing one of my xfs partit=
ions. It is not the root partition.</div><div><br></div><div>The helpful te=
am on IRC (#xfs on <a href=3D"http://irc.freenode.net">irc.freenode.net</a>=
) says that what I want to do is figure out why I&#39;m getting -EAGAIN fro=
m the block device.</div>
<div><br></div><div>The error message I get when accessing the filesystem (=
through nautilus, or in a terminal) is:</div><div><br></div><div>&lt;snip&g=
t;</div><div><div>Jun =A07 18:08:14 picard kernel: [ 2602.542458] I/O error=
 in filesystem (&quot;dm-4&quot;) meta-data dev dm-4 block 0x41c6dc18 =A0 =
=A0 =A0 (&quot;xfs_trans_read_buf&quot;) error 11 buf count 4096</div>
<div>Jun =A07 18:08:14 picard kernel: [ 2602.548673] I/O error in filesyste=
m (&quot;dm-4&quot;) meta-data dev dm-4 block 0x41c23898 =A0 =A0 =A0 (&quot=
;xfs_trans_read_buf&quot;) error 11 buf count 4096</div><div>Jun =A07 18:08=
:14 picard kernel: [ 2602.553135] I/O error in filesystem (&quot;dm-4&quot;=
) meta-data dev dm-4 block 0x41c133a8 =A0 =A0 =A0 (&quot;xfs_trans_read_buf=
&quot;) error 11 buf count 4096</div>
</div><div>&lt;/snip&gt;</div><div>... and so on.</div><div><br></div><div>=
The helpful team on IRC supplied me with a patch to understand the error me=
ssage alittle better.</div><div><br></div><div>Filename: hch_patch</div>
<div>&lt;snip&gt;</div><div><div>--- a/fs/xfs/linux-2.6/xfs_buf.c</div><div=
>+++ b/fs/xfs/linux-2.6/xfs_buf.c</div><div>@@ -1264,6 +1264,9 @@ xfs_buf_b=
io_end_io(</div><div><span class=3D"Apple-tab-span" style=3D"white-space:pr=
e">	</span>unsigned int =A0 =A0 =A0 =A0 =A0 =A0blocksize =3D bp-&gt;b_targe=
t-&gt;bt_bsize;</div>
<div><span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struc=
t bio_vec =A0 =A0 =A0 =A0 =A0*bvec =3D bio-&gt;bi_io_vec + bio-&gt;bi_vcnt =
- 1;</div><div><br></div><div>+ =A0 =A0 =A0 if (error &amp;&amp; error !=3D=
 -EIO &amp;&amp; error !=3D -EOPNOTSUPP)</div>
<div>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(&quot;XFS: got error %d in %s\n&q=
uot;, error, __func__);</div><div>+</div><div><span class=3D"Apple-tab-span=
" style=3D"white-space:pre">	</span>xfs_buf_ioerror(bp, -error);</div><div>=
<br></div><div>
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if (!error=
 &amp;&amp; xfs_buf_is_vmapped(bp) &amp;&amp; (bp-&gt;b_flags &amp; XBF_REA=
D))</div></div><div>&lt;/snip&gt;</div><div><br></div><div>After fetching a=
 new kernel source, unmounting my xfs partition, applying the patch (runnin=
g: &quot;patch -p1 &lt; hch_patch&quot; in /usr/src/linux-2.6.38) and makin=
g a new module (running: &quot;make -C /lib/modules/`uname -r`/build M=3D`p=
wd`/fs/xfs&quot; in /usr/src/linux-2.6.38), removing the old module (runnin=
g: &quot;rmmod xfs.ko&quot;) and then insmoding the new (running: &quot;ins=
mod xfs.ko&quot;) I get the following error message:</div>
<div><br></div><div>&lt;snip&gt;</div><div><div>Jun =A07 20:25:21 picard ke=
rnel: [10821.778982] XFS: got error -11 in xfs_buf_bio_end_io</div><div>Jun=
 =A07 20:25:21 picard kernel: [10821.780263] I/O error in filesystem (&quot=
;dm-4&quot;) meta-data dev dm-4 block 0x41c6dc18 =A0 =A0 =A0 (&quot;xfs_tra=
ns_read_buf&quot;) error 11 buf count 4096XFS: got error -11 in xfs_buf_bio=
_end_io</div>
<div>Jun =A07 20:25:21 picard kernel: [10821.781403] I/O error in filesyste=
m (&quot;dm-4&quot;) meta-data dev dm-4 block 0x41c23898 =A0 =A0 =A0 (&quot=
;xfs_trans_read_buf&quot;) error 11 buf count 4096XFS: got error -11 in xfs=
_buf_bio_end_io</div>
<div>Jun =A07 20:25:21 picard kernel: [10821.796254] I/O error in filesyste=
m (&quot;dm-4&quot;) meta-data dev dm-4 block 0x41c133a8 =A0 =A0 =A0 (&quot=
;xfs_trans_read_buf&quot;) error 11 buf count 4096XFS: got error -11 in xfs=
_buf_bio_end_io</div>
</div><div>&lt;/snip&gt;</div><div>... and so on.</div><div><br></div><div>=
After a while when for example extracting a zip archive I get the following=
 error messages:</div><div><br></div><div>&lt;snip&gt;</div><div><div>Jun =
=A07 20:28:38 picard kernel: [11018.263647] XFS: got error -11 in xfs_buf_b=
io_end_io</div>
<div>Jun =A07 20:28:38 picard kernel: [11018.263842] XFS: got error -11 in =
xfs_buf_bio_end_io</div><div>Jun =A07 20:28:41 picard kernel: [11021.399311=
] XFS: got error -11 in xfs_buf_bio_end_io</div><div>Jun =A07 20:28:41 pica=
rd kernel: [11021.435716] I/O error in filesystem (&quot;dm-4&quot;) meta-d=
ata dev dm-4 block 0x3a53bbf0 =A0 =A0 =A0 (&quot;xfs_trans_read_buf&quot;) =
error 11 buf count 4096</div>
<div>Jun =A07 20:28:41 picard kernel: [11021.435724] xfs_force_shutdown(dm-=
4,0x1) called from line 3894 of file /usr/src/linux-2.6.38/fs/xfs/xfs_bmap.=
c. =A0Return address =3D 0xffffffffa0fa34a2</div><div>Jun =A07 20:28:41 pic=
ard kernel: [11021.580677] Filesystem dm-4: I/O Error Detected. =A0Shutting=
 down filesystem: dm-4</div>
<div>Jun =A07 20:28:42 picard kernel: [11021.580683] Please umount the file=
system, and rectify the problem(s)</div><div>Jun =A07 20:29:12 picard kerne=
l: [11023.043494] Filesystem dm-4: xfs_log_force: error 5 returned.</div><d=
iv>
Jun =A07 20:29:42 picard kernel: [11053.015272] Filesystem dm-4: xfs_log_fo=
rce: error 5 returned.</div></div><div>&lt;/snip&gt;</div><div>... and so o=
n</div><div><br></div><div>Accessing the device is slower than before the u=
pgrade to 11.04, and it is not without errors that I can access the device.=
</div>
<div><div><br></div><div>$ uname -r</div><div>Linux picard 2.6.38-8-generic=
 #42-Ubuntu SMP Mon Apr 11 03:31:24 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux=
</div></div><div><br></div><div><br></div><div><meta http-equiv=3D"content-=
type" content=3D"text/html; charset=3Dutf-8"><div>
HW specs:</div><div>The XFS partition is run on a HW Raid on 2 x 1TB WD Bla=
ck Caviar. Motherboard is an ASUS Sabertooth P67 with=A0Intel Sandy Bridge =
i5-2500K CPU @ 3.30GHz.</div></div><div><br></div><div><br></div><div>Do yo=
u guys know what might be wrong, how I or you or we can solve this?</div>
<div><br></div><div><br></div><div>Regards,</div><div><br></div><div>Marko<=
/div>

--20cf3054a29d6e2c5f04a52548a1--


--===============7640980743610944278==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7640980743610944278==--
