From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: sg_persist triggers block kernel event ???
Date: Sun, 4 May 2014 01:34:20 +0200
Message-ID: <CABr-GneD2JwJ5YHx9n5C42zeiivF5gg0hcg_mab1EuwucfOp0Q@mail.gmail.com>
References: <CABr-GnczryXtOkip_0L+0ztU2RcJ5izbucgs0GHo3DX7OFAMtg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5971613966515418614=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GnczryXtOkip_0L+0ztU2RcJ5izbucgs0GHo3DX7OFAMtg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, dgilbert@interlog.com
List-Id: dm-devel.ids

--===============5971613966515418614==
Content-Type: multipart/alternative; boundary=047d7b10d0e35daec804f8875630

--047d7b10d0e35daec804f8875630
Content-Type: text/plain; charset=UTF-8

It seems sg_persist is doing an "open rw => close" for --in commands,
causing a kernel change-event.
I can not verify at the moment if the following patch would work ...
comments ?

--- sg_persist.c.orig 2014-05-04 01:10:01.987981956 +0200
+++ sg_persist.c 2014-05-04 01:15:34.880008000 +0200
@@ -1029,6 +1029,8 @@
     struct sg_simple_inquiry_resp inq_resp;
     const char * cp;
     struct opts_t opts;
+    int omode = 0;
+    const char *omode_desc = NULL;

     memset(&opts, 0, sizeof(opts));
     opts.prin = 1;
@@ -1292,10 +1294,18 @@
         sg_cmds_close_device(sg_fd);
     }

-    if ((sg_fd = sg_cmds_open_device(device_name, 0 /* rw */,
+    if (opts.prin) {
+        omode = 1;
+        omode_desc = "ro";
+    } else {
+        omode = 0;
+        omode_desc = "rw";
+    }
+
+    if ((sg_fd = sg_cmds_open_device(device_name, omode,
                                      opts.verbose)) < 0) {
-        pr2serr("sg_persist: error opening file (rw): %s: %s\n",
device_name,
-                safe_strerror(-sg_fd));
+        pr2serr("sg_persist: error opening file (%s): %s: %s\n",
omode_desc,
+                device_name, safe_strerror(-sg_fd));
         return SG_LIB_FILE_ERROR;
     }

Regards,
Christophe Varoqui
www.opensvc.com


On Sat, May 3, 2014 at 10:12 PM, Christophe Varoqui <
christophe.varoqui@opensvc.com> wrote:

> Hi list,
>
> I observe this on a debian 7.5 server with a udevadm monitor running in
> the background :
>
> # sg_persist -n -k /dev/sdbh
>   PR generation=0x0, there are NO registered reservation keys
>
> KERNEL[448809.342461] change
> /devices/pci0000:20/0000:20:02.2/0000:24:00.0/host0/rport-0:0-3/target0:0:1/0:0:1:12/block/sdbh
> (block)
> ACTION=change
> DEVNAME=/dev/sdbh
>
> DEVPATH=/devices/pci0000:20/0000:20:02.2/0000:24:00.0/host0/rport-0:0-3/target0:0:1/0:0:1:12/block/sdbh
> DEVTYPE=disk
> MAJOR=67
> MINOR=176
> SEQNUM=261605
> SUBSYSTEM=block
>
> Every sg_persist command, with any options, trigger events.
>
> On this server with more than 200 scsi devices, each receiving one
> read-key and one read-reservation every 10 minutes, this triggers quite a
> eavy load caused by 2 udev triggers :
>
> 1/ multipath -v0 $devpath
> 2/ udisks-lvm-pv-export $pv_uuid
>
>
> Question is, is it normal for a "--in" sg_persist command to trigger a
> change event on the scsi device ? If not, what we can do about it ?
>
> Best regards,
> Christophe Varoqui
> www.opensvc.com
>
>

--047d7b10d0e35daec804f8875630
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">It seems sg_persist is doing an &quot;open rw =3D&gt; clos=
e&quot; for --in commands, causing a kernel change-event.<div>I can not ver=
ify at the moment if the following patch would work ... comments ?</div><di=
v>
<br></div><div><div>--- sg_persist.c.orig<span class=3D"" style=3D"white-sp=
ace:pre">	</span>2014-05-04 01:10:01.987981956 +0200<br></div><div>+++ sg_p=
ersist.c<span class=3D"" style=3D"white-space:pre">	</span>2014-05-04 01:15=
:34.880008000 +0200</div>
<div>@@ -1029,6 +1029,8 @@</div><div>=C2=A0 =C2=A0 =C2=A0struct sg_simple_i=
nquiry_resp inq_resp;</div><div>=C2=A0 =C2=A0 =C2=A0const char * cp;</div><=
div>=C2=A0 =C2=A0 =C2=A0struct opts_t opts;</div><div>+ =C2=A0 =C2=A0int om=
ode =3D 0;</div><div>+ =C2=A0 =C2=A0const char *omode_desc =3D NULL;</div>
<div>=C2=A0</div><div>=C2=A0 =C2=A0 =C2=A0memset(&amp;opts, 0, sizeof(opts)=
);</div><div>=C2=A0 =C2=A0 =C2=A0opts.prin =3D 1;</div><div>@@ -1292,10 +12=
94,18 @@</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_cmds_close_device(s=
g_fd);</div><div>=C2=A0 =C2=A0 =C2=A0}</div><div>=C2=A0</div><div>- =C2=A0 =
=C2=A0if ((sg_fd =3D sg_cmds_open_device(device_name, 0 /* rw */,</div>
<div>+ =C2=A0 =C2=A0if (opts.prin) {</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=
=A0omode =3D 1;</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0omode_desc =3D &quot=
;ro&quot;;</div><div>+ =C2=A0 =C2=A0} else {</div><div>+ =C2=A0 =C2=A0 =C2=
=A0 =C2=A0omode =3D 0;</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0omode_desc =
=3D &quot;rw&quot;;</div><div>+ =C2=A0 =C2=A0}</div>
<div>+</div><div>+ =C2=A0 =C2=A0if ((sg_fd =3D sg_cmds_open_device(device_n=
ame, omode,</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 opts.verbose)) &lt; 0) {</div><div>- =C2=A0 =C2=A0 =C2=A0 =C2=A0pr2s=
err(&quot;sg_persist: error opening file (rw): %s: %s\n&quot;, device_name,=
</div>
<div>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0safe_strerror=
(-sg_fd));</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0pr2serr(&quot;sg_persist:=
 error opening file (%s): %s: %s\n&quot;, omode_desc,</div><div>+ =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0device_name, safe_strerror(=
-sg_fd));</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return SG_LIB_FILE_ER=
ROR;</div>
<div>=C2=A0 =C2=A0 =C2=A0}</div><div>=C2=A0</div></div><div>Regards,</div><=
div>Christophe Varoqui</div><div><a href=3D"http://www.opensvc.com">www.ope=
nsvc.com</a></div></div><div class=3D"gmail_extra"><br><br><div class=3D"gm=
ail_quote">On Sat, May 3, 2014 at 10:12 PM, Christophe Varoqui <span dir=3D=
"ltr">&lt;<a href=3D"mailto:christophe.varoqui@opensvc.com" target=3D"_blan=
k">christophe.varoqui@opensvc.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">Hi list,<div><br></div><div=
>I observe this on a debian 7.5 server with a udevadm monitor running in th=
e background :</div>
<div><br></div><div><div># sg_persist -n -k /dev/sdbh</div><div>=C2=A0 PR g=
eneration=3D0x0, there are NO registered reservation keys</div>
<div><br></div><div>KERNEL[448809.342461] change =C2=A0 /devices/pci0000:20=
/0000:20:02.2/0000:24:00.0/host0/rport-0:0-3/target0:0:1/0:0:1:12/block/sdb=
h (block)</div><div>ACTION=3Dchange</div><div>DEVNAME=3D/dev/sdbh</div><div=
>DEVPATH=3D/devices/pci0000:20/0000:20:02.2/0000:24:00.0/host0/rport-0:0-3/=
target0:0:1/0:0:1:12/block/sdbh</div>

<div>DEVTYPE=3Ddisk</div><div>MAJOR=3D67</div><div>MINOR=3D176</div><div>SE=
QNUM=3D261605</div><div>SUBSYSTEM=3Dblock</div></div><div><br></div><div>Ev=
ery sg_persist command, with any options, trigger events.</div><div><br></d=
iv><div>

On this server with more than 200 scsi devices, each receiving one read-key=
 and one read-reservation every 10 minutes, this triggers quite a eavy load=
 caused by 2 udev triggers :</div><div><br></div><div>1/ multipath -v0 $dev=
path</div>

<div>2/=C2=A0udisks-lvm-pv-export $pv_uuid</div><div><br></div><div><br></d=
iv><div>Question is, is it normal for a &quot;--in&quot; sg_persist command=
 to trigger a change event on the scsi device ? If not, what we can do abou=
t it ?</div>

<div><br></div><div>Best regards,</div><div>Christophe Varoqui</div><div><a=
 href=3D"http://www.opensvc.com" target=3D"_blank">www.opensvc.com</a></div=
><div><br></div></div>
</blockquote></div><br></div>

--047d7b10d0e35daec804f8875630--


--===============5971613966515418614==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5971613966515418614==--
