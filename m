From: Mai N <thumai9999@yahoo.com>
Subject: DMF_FREEING flag checking
Date: Sun, 9 Mar 2008 21:23:09 -0700 (PDT)
Message-ID: <746615.15795.qm@web31715.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0831356656=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============0831356656==
Content-Type: multipart/alternative; boundary="0-751165797-1205122989=:15795"
Content-Transfer-Encoding: 7bit

--0-751165797-1205122989=:15795
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I think we need to check, in __get_uuid_cell() , DMF_FREEING flag, to cov=
er the race condition that we are trying to get the device while others i=
s freeing (or have freed) it, same check is needed in __get_name_cell()..=
.

I noticed that the latest code does NOT check for this, does anyone know =
the reason for this? Or this is a potential bug?

static struct hash_cell *__get_uuid_cell(const char *str)
{
        + struct mapped_device *md =3D NULL;=20

        list_for_each_entry (hc, _uuid_buckets + h,  uuid_list)
                + md =3D hc->md; =20
                + if ((!strcmp(hc->uuid, str)) &&
                +   (md)  && (!(test_bit(DMF_FREEING, &md->flags)))) {

                - if (!strcmp(hc->uuid, str)) {
                        dm_get(hc->md);
}

Thanks for the information
Mai
      =20
---------------------------------
Looking for last minute shopping deals?  Find them fast with Yahoo! Searc=
h.
--0-751165797-1205122989=:15795
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I think we need to check, in __get_uuid_cell() , DMF_FREEING f=
lag, to cover the race condition that we are trying to get the device whi=
le others is freeing (or have freed) it, same check is needed in __get_na=
me_cell()...<br><br>I noticed that the latest code does NOT check for thi=
s, does anyone know the reason for this? Or this is a potential bug?<br><=
br>static struct hash_cell *__get_uuid_cell(const char *str)<br>{<br>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; + struct mapped_device *md =3D NUL=
L; <br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_for_each_entry=
 (hc, _uuid_buckets + h,  uuid_list)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; + md =3D hc-&gt=
;md;&nbsp; <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; + if ((!strcmp(hc-&gt;uuid, str)) &amp;&=
amp;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; + &nbsp; (md)=20
 &amp;&amp; (!(test_bit(DMF_FREEING, &amp;md-&gt;flags)))) {<br><br>&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - if (!strcmp(hc-&gt;uuid, str)) {<br>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dm_get(hc-&gt;md);<br>}<br><b=
r>Thanks for the information<br>Mai<p>&#32;
      <hr size=3D1>Looking for last minute shopping deals? <a href=3D"htt=
p://us.rd.yahoo.com/evt=3D51734/*http://tools.search.yahoo.com/newsearch/=
category.php?category=3Dshopping">=20
Find them fast with Yahoo! Search.</a>
--0-751165797-1205122989=:15795--


--===============0831356656==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0831356656==--
