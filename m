From: Daniel Olops <daniel@olops.eti.br>
Subject: Re: Online disk size change and Linux
Date: Wed, 20 Jan 2010 16:46:58 -0200
Message-ID: <2c46f67e1001201046x56f5e3d0l2ba8b7b18aba6e1d@mail.gmail.com>
References: <2c46f67e1001190742l13ebdc1fs95aa6d545332bcc1@mail.gmail.com>
	<20100119200852.GG2861@reaktio.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1785412713320429937=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100119200852.GG2861@reaktio.net>
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

--===============1785412713320429937==
Content-Type: multipart/alternative; boundary=001636c5b90ae7ccf7047d9d02f2

--001636c5b90ae7ccf7047d9d02f2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

The first link Mike sent did the trick. BTW, great docs, I'll read it later=
.

Thanks for all for helping!

Regards,

Daniel

On Tue, Jan 19, 2010 at 6:08 PM, Pasi K=E4rkk=E4inen <pasik@iki.fi> wrote:

> On Tue, Jan 19, 2010 at 01:42:37PM -0200, Daniel Olops wrote:
> >    Sorry if this is off-topic... but if anyone could help, it'd be good=
.
> >
> >    Is Linux (more specifically Red Hat EL 5.4) able to recognize _disk_
> size
> >    changes online? We have some HP servers with QLogic HBAs connected t=
o
> an
> >    EVA 4000 Storage, with multipathing properly set up. These disks can
> be
> >    resized online, but only after a reboot that RHEL recognizes the
> change.
> >    I've been trying to find any information about it, but to no avail.
> >
>
> I've done iSCSI LUN online resizing using Equallogic storage arrays.
>
> See: http://pasik.reaktio.net/rhel5-online-iscsi-resize-test.txt
>
> -- Pasi
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001636c5b90ae7ccf7047d9d02f2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

The first link Mike sent did the trick. BTW, great docs, I&#39;ll read it l=
ater.<br><br>Thanks for all for helping!<br><br>Regards,<br><br>Daniel<br><=
br><div class=3D"gmail_quote">On Tue, Jan 19, 2010 at 6:08 PM, Pasi K=E4rkk=
=E4inen <span dir=3D"ltr">&lt;<a href=3D"mailto:pasik@iki.fi">pasik@iki.fi<=
/a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class=3D"im"=
>On Tue, Jan 19, 2010 at 01:42:37PM -0200, Daniel Olops wrote:<br>
</div><div><div></div><div class=3D"h5">&gt; =A0 =A0Sorry if this is off-to=
pic... but if anyone could help, it&#39;d be good.<br>
&gt;<br>
&gt; =A0 =A0Is Linux (more specifically Red Hat EL 5.4) able to recognize _=
disk_ size<br>
&gt; =A0 =A0changes online? We have some HP servers with QLogic HBAs connec=
ted to an<br>
&gt; =A0 =A0EVA 4000 Storage, with multipathing properly set up. These disk=
s can be<br>
&gt; =A0 =A0resized online, but only after a reboot that RHEL recognizes th=
e change.<br>
&gt; =A0 =A0I&#39;ve been trying to find any information about it, but to n=
o avail.<br>
&gt;<br>
<br>
</div></div>I&#39;ve done iSCSI LUN online resizing using Equallogic storag=
e arrays.<br>
<br>
See: <a href=3D"http://pasik.reaktio.net/rhel5-online-iscsi-resize-test.txt=
" target=3D"_blank">http://pasik.reaktio.net/rhel5-online-iscsi-resize-test=
.txt</a><br>
<font color=3D"#888888"><br>
-- Pasi<br>
</font><div><div></div><div class=3D"h5"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br>

--001636c5b90ae7ccf7047d9d02f2--


--===============1785412713320429937==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1785412713320429937==--
