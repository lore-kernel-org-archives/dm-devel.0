From: CoolCold <coolthecold@gmail.com>
Subject: Re: [PATCH 0 of 5] MD: prepare RAID10 for inclusion in
	dm-raid.c
Date: Fri, 6 Jul 2012 12:40:51 +0400
Message-ID: <CAGqmV7osZiY+Bv5vn0gtQ_1-j9KnS8dJxoZKm6WJHYaoDrtTBw@mail.gmail.com>
References: <1340700259.19015.10.camel@f16>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0092073247416085092=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1340700259.19015.10.camel@f16>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

--===============0092073247416085092==
Content-Type: multipart/alternative; boundary=bcaec54ee6eabf3d5c04c425387f

--bcaec54ee6eabf3d5c04c425387f
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jun 26, 2012 at 12:44 PM, Jonathan Brassow <jbrassow@redhat.com>wrote:

> Neil,
>
> Here's a couple patches that are necessary for MD before I can add
> RAID10 to the list of supported personalities through dm-raid.c:
>         1) md-raid10-rename-mirror_info.patch
>         2) md-raid1-rename-mirror_info.patch
>         3) md-move-IO_BLOCKED-to-md_h.patch
>         4) md-export-md_raid10_congested.patch
>
> I'll send the patch that enables raid10 as a separate patch that depends
> on this patch set and a couple of DM patches.
>
> Can you explain a bit more detailed for me, what is this about? I.e. from
my point of view dm-raid and md-raid and fully separated but looks like I'm
wrong and missing something.


>  brassow
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Best regards,
[COOLCOLD-RIPN]

--bcaec54ee6eabf3d5c04c425387f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Tue, Jun 26, 2012 at 12:44 PM, Jonath=
an Brassow <span dir=3D"ltr">&lt;<a href=3D"mailto:jbrassow@redhat.com" tar=
get=3D"_blank">jbrassow@redhat.com</a>&gt;</span> wrote:<br><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex">
Neil,<br>
<br>
Here&#39;s a couple patches that are necessary for MD before I can add<br>
RAID10 to the list of supported personalities through dm-raid.c:<br>
=A0 =A0 =A0 =A0 1) md-raid10-rename-mirror_info.patch<br>
=A0 =A0 =A0 =A0 2) md-raid1-rename-mirror_info.patch<br>
=A0 =A0 =A0 =A0 3) md-move-IO_BLOCKED-to-md_h.patch<br>
=A0 =A0 =A0 =A0 4) md-export-md_raid10_congested.patch<br>
<br>
I&#39;ll send the patch that enables raid10 as a separate patch that depend=
s<br>
on this patch set and a couple of DM patches.<br>
<br></blockquote><div>Can you explain a bit more detailed for me, what is t=
his about? I.e. from my point of view dm-raid and md-raid and fully separat=
ed but looks like I&#39;m wrong and missing something.<br>=A0</div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px=
 solid rgb(204,204,204);padding-left:1ex">

=A0brassow<br>
<br>
<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-raid&q=
uot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordomo-info.=
html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><br>
</blockquote></div><br><br clear=3D"all"><br>-- <br>Best regards,<br>[COOLC=
OLD-RIPN] <br>

--bcaec54ee6eabf3d5c04c425387f--


--===============0092073247416085092==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0092073247416085092==--
