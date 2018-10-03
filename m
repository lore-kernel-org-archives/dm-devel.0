From: Thanos Makatos <thanos.makatos@sunlight.io>
Subject: Re: extracting thin mappings in real time
Date: Wed, 3 Oct 2018 15:13:36 +0100
Message-ID: <CA+fs2JN0FHg_ZGawUACWbJPfCpna1fi7PAMzDem2viNZ-zSthQ@mail.gmail.com>
References: <CA+fs2JN0evmnJP2yZT144bUOdxaxUydchXrZmLmFVy4F20yfAA@mail.gmail.com>
	<20181003130333.GA20800@reti>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1038032922056413791=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181003130333.GA20800@reti>
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

--===============1038032922056413791==
Content-Type: multipart/alternative; boundary="0000000000008f7423057753a588"

--0000000000008f7423057753a588
Content-Type: text/plain; charset="UTF-8"

> Could you say more about why you want to do this?
>

So that I can directly read the data block without having to pass through
dm-thin, e.g. there might be a more direct datapath to the physical block
device.

Mappings don't change if you're not using snapshots.  If you are, then any
> write
> to a shared block will trigger a copy on write operation, and subsequently
> a new
> mapping.

So for backups etc. I made the metadata snapshot available, which gives you
> a
> view of all the metadata frozen at a point in time.  If you're using the
> metadata
> snap you still need to guarantee the mappings for the devices that you're
> interested
> in are not changing.  eg, instead of backing up a live thin, take a
> snapshot of the thin
> and back this up instead.
>

For now I can guarantee that these mappings don't change (no snapshots,
backups, etc), so it's safe to extract the mapping(s) without having
acquired the meradata snapshot, correct? If this is the case, then how can
I extract individual mappins? (Either from kernel space or from user
space.) Are there specific dm-thin kernel functions I should start looking
at?

--0000000000008f7423057753a588
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_quote"><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex">Could you say more about why you want to do this?<br></blockquote><div>=
<br></div><div>So that I can directly read the data block without having to=
 pass through dm-thin, e.g. there might be a more direct datapath to the ph=
ysical block device.</div><div><br></div><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Map=
pings don&#39;t change if you&#39;re not using snapshots.=C2=A0 If you are,=
 then any write<br>
to a shared block will trigger a copy on write operation, and subsequently =
a new<br>
mapping.</blockquote><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex">So for backups etc. I m=
ade the metadata snapshot available, which gives you a<br>
view of all the metadata frozen at a point in time.=C2=A0 If you&#39;re usi=
ng the metadata<br>
snap you still need to guarantee the mappings for the devices that you&#39;=
re interested<br>
in are not changing.=C2=A0 eg, instead of backing up a live thin, take a sn=
apshot of the thin<br>
and back this up instead.<br></blockquote><div><br></div><div>For now I can=
 guarantee that these mappings don&#39;t change (no snapshots, backups, etc=
), so it&#39;s safe to extract the mapping(s) without having acquired the m=
eradata snapshot, correct? If this is the case, then how can I extract indi=
vidual mappins? (Either from kernel space or from user space.) Are there sp=
ecific dm-thin kernel functions I should start looking at?</div></div></div=
>

--0000000000008f7423057753a588--


--===============1038032922056413791==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1038032922056413791==--
