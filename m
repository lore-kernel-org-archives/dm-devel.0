From: =?ISO-8859-1?Q?Christian_R=F8snes?= <christian.rosnes@gmail.com>
Subject: Re: Multipath setup and rdac questions
Date: Thu, 5 Feb 2009 20:30:04 +0100
Message-ID: <1a4a774c0902051130p1af492f7mfeaf9e07b1ee680e@mail.gmail.com>
References: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>
	<498B00B3.5020402@redhat.com>
	<1a4a774c0902051048keb6e681g7dbf2643a88a6d9e@mail.gmail.com>
	<1233862146.27254.15.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1483633888=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1233862146.27254.15.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1483633888==
Content-Type: multipart/alternative; boundary=0016e6d647da63f8ba046230ee3d

--0016e6d647da63f8ba046230ee3d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2009 at 8:29 PM, Chandra Seetharaman <sekharan@us.ibm.com>wr=
ote:

>
> On Thu, 2009-02-05 at 19:48 +0100, Christian R=F8snes wrote:
>
> >
> > Is mpp another type of rdac driver than the one in question here ?
>
> Yes, MPP is a standalone out-of-tree driver provided by LSI to support
> the rdac devices.
>
> Now that rdac support is available in mainline and distro, you do not
> need to use them anymore.
>
> MPP driver sits below the SCSI layer and  manages all the
> failover/failback. It takes the MD3000i devices and provides the
> "virtual disk" to the SCSI layer. That is the reason why you do not see
> the MD3000i from user space.
>
> Once you remove the mpp driver and use the multipathy.conf provided by
> Babu, you should see the behavior you expect.
>
>
Ok. I will remove the mpp driver.

Thank you
Christian

--0016e6d647da63f8ba046230ee3d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Thu, Feb 5, 2009 at 8:29 PM, Chandra =
Seetharaman <span dir=3D"ltr">&lt;<a href=3D"mailto:sekharan@us.ibm.com">se=
kharan@us.ibm.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0=
.8ex; padding-left: 1ex;">
<div class=3D"Ih2E3d"><br>
On Thu, 2009-02-05 at 19:48 +0100, Christian R=F8snes wrote:<br>
<br>
&gt;<br>
&gt; Is mpp another type of rdac driver than the one in question here ?<br>
<br>
</div>Yes, MPP is a standalone out-of-tree driver provided by LSI to suppor=
t<br>
the rdac devices.<br>
<br>
Now that rdac support is available in mainline and distro, you do not<br>
need to use them anymore.<br>
<br>
MPP driver sits below the SCSI layer and &nbsp;manages all the<br>
failover/failback. It takes the MD3000i devices and provides the<br>
&quot;virtual disk&quot; to the SCSI layer. That is the reason why you do n=
ot see<br>
the MD3000i from user space.<br>
<br>
Once you remove the mpp driver and use the multipathy.conf provided by<br>
Babu, you should see the behavior you expect.<br><br>
</blockquote></div><br>Ok. I will remove the mpp driver.<br><br>Thank you<b=
r>Christian<br>

--0016e6d647da63f8ba046230ee3d--


--===============1483633888==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1483633888==--
