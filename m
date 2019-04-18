From: Shaun Tancheff <shaun@tancheff.com>
Subject: Re: [PATCH] dm-zoned: Fix zone report handling
Date: Thu, 18 Apr 2019 07:32:35 -0500
Message-ID: <CAJ48U8VehF-fxTMYLzUY_jQf4gdukA8EoKZ1iRnbfv9nn+keyQ@mail.gmail.com>
References: <20190418090307.1098-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1596851737129193744=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190418090307.1098-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: dm-devel <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

--===============1596851737129193744==
Content-Type: multipart/alternative; boundary="0000000000000a72420586cd33d1"

--0000000000000a72420586cd33d1
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 18, 2019 at 4:04 AM Damien Le Moal <damien.lemoal@wdc.com>
wrote:

> The function blkdev_report_zones() returns success even if no zone
> information is reported (empty report). Empty zone reports can only
> happen if the report start sector passed exceeds the device capacity.
> The conditions for this to happen are either a bug in the caller code,
> or, a change in the device that forced the low level driver to change
> the device capacity to a value that is lower than the report start
> sector. This situation includes a failed disk revalidation resulting in
> the disk capacity being changed to 0.
>
> If this change happens while dm-zoned is in its initialization phase
> executing dmz_init_zones(), this function may enter an infinite loop
> and hang the system. To avoid this, add a check to disallow empty zone
> reports and bail out early. Also fix the function dmz_update_zone() to
> make sure that the report for the requested zone was correctly obtained.
>
> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/md/dm-zoned-metadata.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/md/dm-zoned-metadata.c
> b/drivers/md/dm-zoned-metadata.c
> index fa68336560c3..d8334cd45d7c 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1169,6 +1169,9 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
>                         goto out;
>                 }
>
> +               if (!nr_blkz)
> +                       break;
> +
>                 /* Process report */
>                 for (i = 0; i < nr_blkz; i++) {
>                         ret = dmz_init_zone(zmd, zone, &blkz[i]);
> @@ -1204,6 +1207,8 @@ static int dmz_update_zone(struct dmz_metadata *zmd,
> struct dm_zone *zone)
>         /* Get zone information from disk */
>         ret = blkdev_report_zones(zmd->dev->bdev, dmz_start_sect(zmd,
> zone),
>                                   &blkz, &nr_blkz, GFP_NOIO);
> +       if (!nr_blkz)
> +               ret = -EIO;
>         if (ret) {
>                 dmz_dev_err(zmd->dev, "Get zone %u report failed",
>                             dmz_id(zmd, zone));
>

Reviewed-by: Shaun Tancheff <shaun@tancheff.com>


> --
> 2.20.1
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--0000000000000a72420586cd33d1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Thu, Apr 18, 2019 at 4:04 AM Damie=
n Le Moal &lt;<a href=3D"mailto:damien.lemoal@wdc.com">damien.lemoal@wdc.co=
m</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin=
:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"=
>The function blkdev_report_zones() returns success even if no zone<br>
information is reported (empty report). Empty zone reports can only<br>
happen if the report start sector passed exceeds the device capacity.<br>
The conditions for this to happen are either a bug in the caller code,<br>
or, a change in the device that forced the low level driver to change<br>
the device capacity to a value that is lower than the report start<br>
sector. This situation includes a failed disk revalidation resulting in<br>
the disk capacity being changed to 0.<br>
<br>
If this change happens while dm-zoned is in its initialization phase<br>
executing dmz_init_zones(), this function may enter an infinite loop<br>
and hang the system. To avoid this, add a check to disallow empty zone<br>
reports and bail out early. Also fix the function dmz_update_zone() to<br>
make sure that the report for the requested zone was correctly obtained.<br=
>
<br>
Fixes: 3b1a94c88b79 (&quot;dm zoned: drive-managed zoned block device targe=
t&quot;)<br>
Cc: <a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">stable@vger=
.kernel.org</a><br>
Signed-off-by: Damien Le Moal &lt;<a href=3D"mailto:damien.lemoal@wdc.com" =
target=3D"_blank">damien.lemoal@wdc.com</a>&gt;<br>
---<br>
=C2=A0drivers/md/dm-zoned-metadata.c | 5 +++++<br>
=C2=A01 file changed, 5 insertions(+)<br>
<br>
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.=
c<br>
index fa68336560c3..d8334cd45d7c 100644<br>
--- a/drivers/md/dm-zoned-metadata.c<br>
+++ b/drivers/md/dm-zoned-metadata.c<br>
@@ -1169,6 +1169,9 @@ static int dmz_init_zones(struct dmz_metadata *zmd)<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!nr_blkz)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Process report *=
/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &lt=
; nr_blkz; i++) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ret =3D dmz_init_zone(zmd, zone, &amp;blkz[i]);<br>
@@ -1204,6 +1207,8 @@ static int dmz_update_zone(struct dmz_metadata *zmd, =
struct dm_zone *zone)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Get zone information from disk */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D blkdev_report_zones(zmd-&gt;dev-&gt;bde=
v, dmz_start_sect(zmd, zone),<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;blkz, &amp;nr_blkz, GFP_=
NOIO);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!nr_blkz)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EIO;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dmz_dev_err(zmd-&gt=
;dev, &quot;Get zone %u report failed&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 dmz_id(zmd, zone));<br></blockquote><div><br></div=
><div>Reviewed-by: Shaun Tancheff &lt;<a href=3D"mailto:shaun@tancheff.com"=
>shaun@tancheff.com</a>&gt;</div><div>=C2=A0</div><blockquote class=3D"gmai=
l_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,20=
4,204);padding-left:1ex">
-- <br>
2.20.1<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</blockquote></div></div>

--0000000000000a72420586cd33d1--


--===============1596851737129193744==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1596851737129193744==--
