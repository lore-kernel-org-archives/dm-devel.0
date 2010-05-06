From: Busby <chaimvy@gmail.com>
Subject: dm_suspend will take too long?
Date: Thu, 6 May 2010 12:08:07 +0800
Message-ID: <p2xb8091bb41005052108vc7f9a590u31962f64c7b75004@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4652066193891198658=="
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
List-Id: dm-devel.ids

--===============4652066193891198658==
Content-Type: multipart/alternative; boundary=000e0cd2d8a0109efd0485e517f1

--000e0cd2d8a0109efd0485e517f1
Content-Type: text/plain; charset=ISO-8859-1

Hi All,
        I use "dd if=/dev/zero of=/dev/vg00/lv00 bs=1K"  to make big IO on
the origin LV. then I use lvcreate to create a snapshot on it (lv00). it
will suspend till the 'dd' ends.
       I read the source code and find the 'dm_suspend' function will call
"lock_fs", then find all of them hang at  "sync_blockdev(struct block_device
*bdev)" function, because the function call  "__filemap_fdatawrite(mapping,
WB_SYNC_ALL);" later.
      I don't want the lvcreate snapshot take so long, suspend the origin lv
is needed?And the WB_SYNC_ALL will cause update dirty pages slower than
'dd'  write data.
      sync_blockdev will wait on any mapping it seems. can dm_suspend do not
wait for it?
      My kernel version:2.6.29. LVM2.02.63.
      Thanks.

Best regards,
Busby

--000e0cd2d8a0109efd0485e517f1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi All,</div>
<div>=A0=A0=A0=A0=A0=A0=A0 I use &quot;dd if=3D/dev/zero of=3D/dev/vg00/lv0=
0 bs=3D1K&quot;=A0 to make big IO on the origin LV. then I use lvcreate to =
create a snapshot on it (lv00). it will suspend till the &#39;dd&#39; ends.=
</div>
<div>=A0=A0=A0=A0=A0=A0 I read the source code and=A0find the &#39;dm_suspe=
nd&#39; function will call &quot;lock_fs&quot;,=A0then find all of them=A0h=
ang at =A0&quot;sync_blockdev(struct block_device *bdev)&quot; function, be=
cause the function call =A0&quot;__filemap_fdatawrite(mapping, <font color=
=3D"#ff0000">WB_SYNC_ALL</font>);&quot; later.</div>

<div>=A0=A0=A0=A0=A0 I don&#39;t want the lvcreate snapshot take so long, s=
uspend the origin lv is needed?And the <font color=3D"#ff0000">WB_SYNC_ALL =
</font><font color=3D"#000000">will cause=A0update dirty=A0pages=A0slower t=
han &#39;dd&#39;=A0=A0write data.</font></div>

<div>=A0=A0=A0=A0=A0=A0sync_blockdev will wait on any mapping it seems. can=
 dm_suspend do not wait for it?</div>
<div>=A0=A0=A0=A0 =A0My kernel version:2.6.29. LVM2.02.63.</div>
<div>=A0=A0=A0=A0=A0 Thanks.</div>
<div>=A0</div>
<div>Best regards,</div>
<div>Busby</div>
<div>=A0</div>

--000e0cd2d8a0109efd0485e517f1--


--===============4652066193891198658==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4652066193891198658==--
