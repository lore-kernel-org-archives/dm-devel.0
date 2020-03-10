From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: Fix for dm-thin pool resizing
Date: Mon, 9 Mar 2020 23:39:49 -0700
Message-ID: <CAN-y+E+A+hNTF_v84N_gxM8MM1FiMZLbAQW4pZ=k-rHTAMZCnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0171832888234930347=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============0171832888234930347==
Content-Type: multipart/alternative; boundary="00000000000084563e05a07a6331"

--00000000000084563e05a07a6331
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Expanding the data device consumes metadata space. Right now the data
device is currently resized *before* the metadata device is. This creates a
situation where you can reload the pool with a much larger metadata device
and a larger data device, but it will fail the pool by running out of
metadata space trying to expand the data device.

I've been able to fix this by simply changing around the order that things
are checked. Rather than checking data device first, which might itself
require too much metadata to expand, just check the metadata device first
and expand that (allowing for the subsequent data device expansion).

static int pool_preresume(struct dm_target *ti)
{
    int r;
    bool need_commit;
    struct pool_c *pt =3D ti->private;
    struct pool *pool =3D pt->pool;

    /*
     * Take control of the pool object.
     */
    r =3D bind_control_target(pool, ti);
    if (r)
        return r;

    r =3D maybe_resize_metadata_dev(ti, &need_commit);
    if (r)
        return r;

    if(need_commit) (void) commit(pool);

    r =3D maybe_resize_data_dev(ti, &need_commit);
    if (r)
        return r;

    if(need_commit) (void) commit(pool);

    return 0;
}


Thanks for your hard work!
- Drew

--00000000000084563e05a07a6331
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Expanding the data device consumes metadata space. Ri=
ght now the data device is currently resized <i>before</i>=C2=A0the metadat=
a device is. This creates a situation where you can reload the pool with a =
much larger metadata device and a larger data device, but it will fail the =
pool by running out of metadata space trying to expand the data device.<br>=
<br></div><div>I&#39;ve been able to fix this by simply changing around the=
 order that things are checked. Rather than checking data device first, whi=
ch might itself require too much metadata to expand, just check the metadat=
a device first and expand that (allowing for the subsequent data device exp=
ansion).<br><br>static int pool_preresume(struct dm_target *ti)<br>{<br>=C2=
=A0 =C2=A0 int r;<br>=C2=A0 =C2=A0 bool need_commit;<br>=C2=A0 =C2=A0 struc=
t pool_c *pt =3D ti-&gt;private;<br>=C2=A0 =C2=A0 struct pool *pool =3D pt-=
&gt;pool;<br><br>=C2=A0 =C2=A0 /*<br>=C2=A0 =C2=A0 =C2=A0* Take control of =
the pool object.<br>=C2=A0 =C2=A0 =C2=A0*/<br>=C2=A0 =C2=A0 r =3D bind_cont=
rol_target(pool, ti);<br>=C2=A0 =C2=A0 if (r)<br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return r;<br><br>=C2=A0 =C2=A0 r =3D maybe_resize_metadata_dev(ti, &amp=
;need_commit);<br>=C2=A0 =C2=A0 if (r)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 retur=
n r;<br><br>=C2=A0 =C2=A0 if(need_commit) (void) commit(pool);<br><br>=C2=
=A0 =C2=A0 r =3D maybe_resize_data_dev(ti, &amp;need_commit);<br>=C2=A0 =C2=
=A0 if (r)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br><br>=C2=A0 =C2=A0 if=
(need_commit) (void) commit(pool);<br><br>=C2=A0 =C2=A0 return 0;<br>}<br><=
br><br>Thanks for your hard work!</div><div>- Drew</div></div>

--00000000000084563e05a07a6331--

--===============0171832888234930347==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0171832888234930347==--
