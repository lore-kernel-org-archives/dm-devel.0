From: Sanjana <sanjana.linux@gmail.com>
Subject: Re: creating two device mapper files for an underline
	blockdevice
Date: Wed, 2 Nov 2011 18:02:30 +0530
Message-ID: <CABMcfaNsdpnoMktJb67MgSvXa6_7FmXFAk_dkahpUPFCa+0Gwg@mail.gmail.com>
References: <CABMcfaMVsagfFdtg+f1eYR501wWSMbxsEAHTYD_5MTF1bABu0A@mail.gmail.com>
	<4EAFAE7A.7060000@redhat.com>
	<CABMcfaOiMfbz_amLkoSJ-zhRKCGCEhc1Em29NV5-02LiOPJYcQ@mail.gmail.com>
	<CABMcfaM6BuB=5r1Exq-PxuCLDifX7Qfuuq9ZXpF9QNXRbxvupA@mail.gmail.com>
	<4EB0F7EF.603@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1539299101452342868=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EB0F7EF.603@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1539299101452342868==
Content-Type: multipart/alternative; boundary=20cf307ca38466eaef04b0bfaaae

--20cf307ca38466eaef04b0bfaaae
Content-Type: text/plain; charset=ISO-8859-1

Thanks Milan,

That clears my confusion.. need to read more doc... :)

--sanjana

On Wed, Nov 2, 2011 at 1:27 PM, Milan Broz <mbroz@redhat.com> wrote:

> On 11/01/2011 06:10 PM, Sanjana Shari wrote:
> > Using the remaining of first half of the same blockdevice /dev/loop0.
> > This seems to work. So I ma confused here how the mapping works..
>
> There is no magic for linear mapping.
> Imagine you have this mapping table
>
> 0 8 linear /dev/sdb 1000
> 8 8 linear /dev/sdc 500
>
> It means you created 16 sectors device consisting of two segments.
>
> First half (sectors 0-7) is mapped to /dev/sdb starting at sector 10000.
> (IOW sectors 0-7 of newly mapped device is mapped to sectors 10000-10007
> of /dev/sdb)
>
> Second half (sectors 8-15) is mapped to /dev/sdc starting at sector 500.
>
> See dmsetup man page, where linear mapping is described.
> Just do not confuse source and destination device offset.
>
> Milan
>

--20cf307ca38466eaef04b0bfaaae
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks Milan,<br><br>That clears my confusion.. need to read more doc... :)=
<br><br>--sanjana<br><br><div class=3D"gmail_quote">On Wed, Nov 2, 2011 at =
1:27 PM, Milan Broz <span dir=3D"ltr">&lt;<a href=3D"mailto:mbroz@redhat.co=
m">mbroz@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex;"><div class=3D"im">On 11/01/2011 06:10 PM, S=
anjana Shari wrote:<br>
&gt; Using the remaining of first half of the same blockdevice /dev/loop0.<=
br>
&gt; This seems to work. So I ma confused here how the mapping works..<br>
<br>
</div>There is no magic for linear mapping.<br>
Imagine you have this mapping table<br>
<br>
0 8 linear /dev/sdb 1000<br>
8 8 linear /dev/sdc 500<br>
<br>
It means you created 16 sectors device consisting of two segments.<br>
<br>
First half (sectors 0-7) is mapped to /dev/sdb starting at sector 10000.<br=
>
(IOW sectors 0-7 of newly mapped device is mapped to sectors 10000-10007 of=
 /dev/sdb)<br>
<br>
Second half (sectors 8-15) is mapped to /dev/sdc starting at sector 500.<br=
>
<br>
See dmsetup man page, where linear mapping is described.<br>
Just do not confuse source and destination device offset.<br>
<font color=3D"#888888"><br>
Milan<br>
</font></blockquote></div><br><br clear=3D"all"><br><br><br>

--20cf307ca38466eaef04b0bfaaae--


--===============1539299101452342868==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1539299101452342868==--
