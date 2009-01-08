From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: merging dm-ioband into Linux
Date: Thu, 8 Jan 2009 12:05:09 -0600
Message-ID: <09F68804-691D-4E75-ABFC-9E1CE86FB98A@redhat.com>
References: <20090105.225124.193700534.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/mixed; boundary="===============2101011274=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090105.225124.193700534.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


--===============2101011274==
Content-Type: multipart/alternative; boundary=Apple-Mail-4--272360424


--Apple-Mail-4--272360424
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Perhaps it will help people to know that there is a good write-up  
about how it all works at the end of the patch found at:
http://people.valinux.co.jp/~ryov/dm-ioband/patches/dm-ioband-1.7.0.patch

It seem interesting to me.  (I'm still reading through the description  
and haven't started looking at the code.)

Regarding:
+                ioband_device_id
+
+                          The ID number for an ioband device. The  
same ID
+                        must be set among the ioband devices that  
share the
+                        same bandwidth, which means they work on the  
same
+                        physical disk.
... but it doesn't have to be the same physical disk, right?  It could  
be a group if disks if you felt the need to do something like that,  
right?  (You could treat a JBOD as one unit.)  Otherwise, you could  
probably eliminate this field.
brassow
On Jan 5, 2009, at 7:51 AM, Ryo Tsuruta wrote:

> Hi Alasdair,
>
> I know you are very very busy, but could you do me a favor and
> respond to my email?
>
> - Have you already looked over the patch?
> - What do you think about it?
> - Would you consider merging the dm-ioband patch into Linux?
> - What else do I need to do it?
>
> Any comments, suggestions or whatever will be grately appreciated.
>
> Thanks,
> Ryo Tsuruta
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--Apple-Mail-4--272360424
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; ">Perhaps it will help people to =
know that there is a good write-up about how it all works at the end of =
the patch found at:<div><a =
href=3D"http://people.valinux.co.jp/~ryov/dm-ioband/patches/dm-ioband-1.7.=
0.patch">http://people.valinux.co.jp/~ryov/dm-ioband/patches/dm-ioband-1.7=
.0.patch</a></div><div><br></div><div>It seem interesting to me. =
&nbsp;(I'm still reading through the description and haven't started =
looking at the =
code.)</div><div><br></div><div>Regarding:</div><div><span =
class=3D"Apple-style-span" style=3D"font-family: Times; font-size: 16px; =
"><pre style=3D"word-wrap: break-word; white-space: pre-wrap; "><font =
class=3D"Apple-style-span" face=3D"Courier" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">+                =
ioband_device_id
+
+                          The ID number for an ioband device. The same =
ID
+                        must be set among the ioband devices that share =
the
+                        same bandwidth, which means they work on the =
same
+                        physical disk.<span class=3D"Apple-style-span" =
style=3D"font-family: Helvetica; white-space: normal; =
"></span></span></font></pre><pre style=3D"word-wrap: break-word; =
white-space: pre-wrap; "><font class=3D"Apple-style-span" =
face=3D"Helvetica" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px; white-space: normal;">... but it doesn't have =
to be the same physical disk, right? &nbsp;It could be a group if disks =
if you felt the need to do something like that, right? &nbsp;(You could =
treat a JBOD as one unit.) &nbsp;Otherwise, you could probably eliminate =
this field.</span></font></pre><pre style=3D"word-wrap: break-word; =
"><font class=3D"Apple-style-span" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px; white-space: =
normal;"> </span></font></pre><pre style=3D"word-wrap: break-word; =
white-space: pre-wrap; "><font class=3D"Apple-style-span" face=3D"Courier"=
 size=3D"3"><span class=3D"Apple-style-span" style=3D"font-size: =
12px;"><span class=3D"Apple-style-span" style=3D"font-family: Helvetica; =
white-space: normal; ">brassow</span></span></font></pre><pre =
style=3D"word-wrap: break-word; white-space: pre-wrap; "><span =
class=3D"Apple-style-span" style=3D"font-family: Helvetica; font-size: =
12px; white-space: normal; ">On Jan 5, 2009, at 7:51 AM, Ryo Tsuruta =
wrote:</span></pre></span><div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><div>Hi =
Alasdair,<br><br>I know you are very very busy, but could you do me a =
favor and<br>respond to my email?<br><br>- Have you already looked over =
the patch?<br>- What do you think about it?<br>- Would you consider =
merging the dm-ioband patch into Linux?<br>- What else do I need to do =
it?<br><br>Any comments, suggestions or whatever will be grately =
appreciated.<br><br>Thanks,<br>Ryo Tsuruta<br><br>--<br>dm-devel mailing =
list<br><a =
href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>https://www=
.redhat.com/mailman/listinfo/dm-devel<br></div></blockquote></div><br></di=
v></body></html>=

--Apple-Mail-4--272360424--


--===============2101011274==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2101011274==--
