From: "Brian Long" <briandlong@gmail.com>
Subject: Re: [RHEL 4 U2] Recommended blacklist for Sun X4200, V40z
Date: Wed, 5 Apr 2006 22:25:36 -0400
Message-ID: <1c59d60b0604051925y20520e17k676c1e21ca7cdc58@mail.gmail.com>
References: <1c59d60b0603290740p7831d874h840add20cc5abab3@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1358689635=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1c59d60b0603290740p7831d874h840add20cc5abab3@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============1358689635==
Content-Type: multipart/alternative;
	boundary="----=_Part_8033_21664155.1144290336145"

------=_Part_8033_21664155.1144290336145
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 3/29/06, Brian Long <briandlong@gmail.com> wrote:
>
> I'm running RHEL 4 U2 (device-mapper-multipath-0.4.5-6.0.RHEL4).  I have =
a
> multipath.conf which uses the compiled-in blacklist.  I also have
> specified device entries specific to certain EMC arrays in use (see attac=
hed
> multipath.conf ).  The majority of our hosts are HP Proliant with cciss
> local disks and they are blacklisted appropriately.  When I use the same
> multipath.conf on a Sun V40z or X4200, multipathing is not working and I
> believe it's because the internal disk (LSI Logic / MPT Fusion RAID) is n=
ot
> blacklisted (see attached multipath-v3.out for details).
>
> Is there a recommended blacklist entry for these hosts?  Can I blacklist
> by vendor ID instead of device?
>

I could not get multipath working properly on these hosts until I set up a
vendor-based blacklist in /etc/scis_id.conf.  I blacklisted vendor=3DLSILOG=
IC
and multipath works well for the SAN devices.

/Brian/

------=_Part_8033_21664155.1144290336145
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<br><br><div><span class=3D"gmail_quote">On 3/29/06, <b class=3D"gmail_send=
ername">Brian Long</b> &lt;<a href=3D"mailto:briandlong@gmail.com">briandlo=
ng@gmail.com</a>&gt; wrote:</span><blockquote class=3D"gmail_quote" style=
=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; p=
adding-left: 1ex;">
<div style=3D"direction: ltr;">I'm running RHEL 4 U2 (device-mapper-multipa=
th-0.4.5-6.0.RHEL4).&nbsp; I have a multipath.conf which uses the compiled-=
in blacklist.&nbsp; I also have specified device entries specific to certai=
n EMC arrays in use (see attached=20
multipath.conf
).&nbsp; The majority of our hosts are HP Proliant with cciss local disks a=
nd they are blacklisted appropriately.&nbsp; When I use the same multipath.=
conf on a Sun V40z or X4200, multipathing is not working and I believe it's=
 because the internal disk (LSI Logic / MPT Fusion RAID) is not blacklisted=
 (see attached=20
multipath-v3.out for details).<br><br>Is there a recommended blacklist entr=
y for these hosts?&nbsp; Can I blacklist by vendor ID instead of device?</d=
iv></blockquote><div><br>I could not get multipath working properly on thes=
e hosts until I set up a vendor-based blacklist in /etc/scis_id.conf.&nbsp;=
 I blacklisted vendor=3DLSILOGIC and multipath works well for the SAN devic=
es.
<br></div><br>/Brian/<br></div><br>

------=_Part_8033_21664155.1144290336145--


--===============1358689635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1358689635==--
