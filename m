From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: sg_persist triggers block kernel event ???
Date: Sun, 4 May 2014 20:01:31 +0200
Message-ID: <CABr-Gneq4MabcPWYNCU9Mz_fRnLPoetc93RRp7qi=xuw8H1LgQ@mail.gmail.com>
References: <CABr-GnczryXtOkip_0L+0ztU2RcJ5izbucgs0GHo3DX7OFAMtg@mail.gmail.com>
	<CABr-GneD2JwJ5YHx9n5C42zeiivF5gg0hcg_mab1EuwucfOp0Q@mail.gmail.com>
	<536670DF.2040605@suse.de> <5366778D.90109@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7689330110922928109=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5366778D.90109@redhat.com>
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

--===============7689330110922928109==
Content-Type: multipart/alternative; boundary=20cf303bfebefeabed04f896cdd6

--20cf303bfebefeabed04f896cdd6
Content-Type: text/plain; charset=UTF-8

Indeed, I'd rather let udev do its work on legitimate device changes.
Problem is, this change event caused by sg_persist prin commands in not
legitimate : no device change can be caused by interrogating the disk pr
status.

Doug informed me newer kernels accept prin commands inside a open-ro=>close
sequence, which I now verified by testing with the patch I sent ... but
older kernels do not. My patch is thus not backward compatible as-is.

Any advice on how to treat this backward-compatibility issue ?

For information, here's a more recent version of the patch I sent to Doug
earlier to address not-Linux platform behaviour stability :

--- sg_persist.c.orig 2014-05-04 01:10:01.987981956 +0200
+++ sg_persist.c 2014-05-04 08:41:29.482017943 +0200
@@ -1029,6 +1029,8 @@
     struct sg_simple_inquiry_resp inq_resp;
     const char * cp;
     struct opts_t opts;
+    int omode = 0;
+    const char *omode_desc = "rw";

     memset(&opts, 0, sizeof(opts));
     opts.prin = 1;
@@ -1292,10 +1294,17 @@
         sg_cmds_close_device(sg_fd);
     }

-    if ((sg_fd = sg_cmds_open_device(device_name, 0 /* rw */,
+#ifdef SG_LIB_LINUX
+    if (opts.prin) {
+        omode = 1;
+        omode_desc = "ro";
+    }
+#endif
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



On Sun, May 4, 2014 at 7:23 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:

> Dne 4.5.2014 18:54, Hannes Reinecke napsal(a):
>
>  On 05/04/2014 01:34 AM, Christophe Varoqui wrote:
>>
>>> It seems sg_persist is doing an "open rw => close" for --in commands,
>>> causing a kernel change-event.
>>>
>> Yep.
>>
>> Look for 'watch' in the udev rules, that's precisely what it's doing.
>>
>> (Bloody annoying if you ask me. Generally I recommend to remove that thing
>> from the rules).
>>
>
> When watch rule is disabled/removed in  udev rules - your udev db becomes
> invalid when i.e. you run  command like  'mkfs' - since the udev db will
> not be updated to list information about newly formatted filesystem.
>
> Of course there are many cases where disabling  watch rule makes sense
> (i.e. you export lots of disks to virtual guests) - but unless you are
> familiar with udev and you know what you are doing - think twice before
> disabling.
>
> Zdenek
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--20cf303bfebefeabed04f896cdd6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Indeed, I&#39;d rather let udev do its work on legitimate =
device changes. Problem is, this change event caused by sg_persist prin com=
mands in not legitimate : no device change can be caused by interrogating t=
he disk pr status.<div>
<br></div><div>Doug informed me newer kernels accept prin commands inside a=
 open-ro=3D&gt;close sequence, which I now verified by testing with the pat=
ch I sent ... but older kernels do not. My patch is thus not backward compa=
tible as-is.</div>
<div><br></div><div>Any advice on how to treat this backward-compatibility =
issue ?</div><div><br></div><div>For information, here&#39;s a more recent =
version of the patch I sent to Doug earlier to address not-Linux platform b=
ehaviour stability :</div>
<div><br></div><div><div style=3D"font-family:arial,sans-serif;font-size:19=
.428571701049805px">--- sg_persist.c.orig<span style=3D"white-space:pre-wra=
p">	</span>2014-05-04 01:10:01.987981956 +0200</div><div style=3D"font-fami=
ly:arial,sans-serif;font-size:19.428571701049805px">
+++ sg_persist.c<span style=3D"white-space:pre-wrap">	</span>2014-05-04 08:=
41:29.482017943 +0200</div><div class=3D"im" style=3D"font-family:arial,san=
s-serif;font-size:19.428571701049805px"><div>@@ -1029,6 +1029,8 @@</div><di=
v>
=C2=A0 =C2=A0 =C2=A0struct sg_simple_inquiry_resp inq_resp;</div><div>=C2=
=A0 =C2=A0 =C2=A0const char * cp;</div><div>=C2=A0 =C2=A0 =C2=A0struct opts=
_t opts;</div><div>+ =C2=A0 =C2=A0int omode =3D 0;</div></div><div style=3D=
"font-family:arial,sans-serif;font-size:19.428571701049805px">
+ =C2=A0 =C2=A0const char *omode_desc =3D &quot;rw&quot;;</div><div class=
=3D"im" style=3D"font-family:arial,sans-serif;font-size:19.428571701049805p=
x"><div>=C2=A0</div><div>=C2=A0 =C2=A0 =C2=A0memset(&amp;opts, 0, sizeof(op=
ts));</div><div>=C2=A0 =C2=A0 =C2=A0opts.prin =3D 1;</div>
</div><div style=3D"font-family:arial,sans-serif;font-size:19.4285717010498=
05px">@@ -1292,10 +1294,17 @@</div><div class=3D"im" style=3D"font-family:a=
rial,sans-serif;font-size:19.428571701049805px"><div>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0sg_cmds_close_device(sg_fd);</div>
<div>=C2=A0 =C2=A0 =C2=A0}</div><div>=C2=A0</div><div>- =C2=A0 =C2=A0if ((s=
g_fd =3D sg_cmds_open_device(device_name, 0 /* rw */,</div></div><div style=
=3D"font-family:arial,sans-serif;font-size:19.428571701049805px">+#ifdef SG=
_LIB_LINUX</div><div class=3D"im" style=3D"font-family:arial,sans-serif;fon=
t-size:19.428571701049805px">
<div>+ =C2=A0 =C2=A0if (opts.prin) {</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=
=A0omode =3D 1;</div><div>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0omode_desc =3D &quot=
;ro&quot;;</div><div>+ =C2=A0 =C2=A0}</div></div><div style=3D"font-family:=
arial,sans-serif;font-size:19.428571701049805px">+#endif</div><div class=3D=
"im" style=3D"font-family:arial,sans-serif;font-size:19.428571701049805px">
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
<div>=C2=A0 =C2=A0 =C2=A0}</div></div></div><div><br></div><div>Regards,</d=
iv><div>Christophe Varoqui</div><div><a href=3D"http://www.opensvc.com">www=
.opensvc.com</a></div><div><br></div></div><div class=3D"gmail_extra"><br><=
br><div class=3D"gmail_quote">
On Sun, May 4, 2014 at 7:23 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&=
gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
Dne 4.5.2014 18:54, Hannes Reinecke napsal(a):<div class=3D""><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On 05/04/2014 01:34 AM, Christophe Varoqui wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
It seems sg_persist is doing an &quot;open rw =3D&gt; close&quot; for --in =
commands,<br>
causing a kernel change-event.<br>
</blockquote>
Yep.<br>
<br>
Look for &#39;watch&#39; in the udev rules, that&#39;s precisely what it&#3=
9;s doing.<br>
<br>
(Bloody annoying if you ask me. Generally I recommend to remove that thing<=
br>
from the rules).<br>
</blockquote>
<br></div>
When watch rule is disabled/removed in =C2=A0udev rules - your udev db beco=
mes invalid when i.e. you run =C2=A0command like =C2=A0&#39;mkfs&#39; - sin=
ce the udev db will not be updated to list information about newly formatte=
d filesystem.<br>

<br>
Of course there are many cases where disabling =C2=A0watch rule makes sense=
<br>
(i.e. you export lots of disks to virtual guests) - but unless you are<br>
familiar with udev and you know what you are doing - think twice before dis=
abling.<br>
<br>
Zdenek<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/<u></u>mailman/listinfo/dm-devel</a><br>
</blockquote></div><br></div>

--20cf303bfebefeabed04f896cdd6--


--===============7689330110922928109==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7689330110922928109==--
