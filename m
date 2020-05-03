From: Dongyang Zhan <zdyzztq@gmail.com>
Subject: Possible null pointer dereference in __rh_alloc()
Date: Sun, 3 May 2020 15:02:21 +0800
Message-ID: <CAFSR4cuCx-wGOAVPUPh8+V4FqDP2Nvac0OeQL6onG89JnZTpyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0781338931935313827=="
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
To: Alasdair Kergon <agk@redhat.com>, "M: Mike Snitzer" <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0781338931935313827==
Content-Type: multipart/alternative; boundary="0000000000009b4a7505a4b8ff7a"

--0000000000009b4a7505a4b8ff7a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I am a security researcher, my name is Dongyang Zhan. I found a
potential bug in

/drivers/md/dm-region-hash.c in Linux 4.10.17. I hope you can help me
to confirm it.


__rh_alloc() in /drivers/md/dm-region-hash.c mishandles the memory
allocation failures of nreg.

Source code:

struct dm_region *reg, *nreg;

nreg =3D mempool_alloc(rh->region_pool, GFP_ATOMIC);
if (unlikely(!nreg))
=09=09nreg =3D kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);

nreg->state =3D rh->log->type->in_sync(rh->log, region, 1) ?
=09=09DM_RH_CLEAN : DM_RH_NOSYNC;

If the statement (nreg =3D kmalloc(sizeof(*nreg), GFP_NOIO |
__GFP_NOFAIL);) fails,
dereferencing this pointer (nreg->state) will cause null pointer dereferenc=
e.

--0000000000009b4a7505a4b8ff7a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><pre id=3D"gmail-m_-4853843472690211139gmail-m_-8476412448=
39025803gmail-m_4091962907303224627gmail-m_-7092909529653893599gmail-m_-855=
8348290116643165gmail-m_-7810375000073948968gmail-comment_text_0" style=3D"=
white-space:pre-wrap;font-size:medium;width:50em;color:rgb(0,0,0)">Hi,</pre=
><pre id=3D"gmail-m_-4853843472690211139gmail-m_-847641244839025803gmail-m_=
4091962907303224627gmail-m_-7092909529653893599gmail-m_-8558348290116643165=
gmail-m_-7810375000073948968gmail-comment_text_0" style=3D"white-space:pre-=
wrap;font-size:medium;width:50em;color:rgb(0,0,0)">I am a security research=
er, my name is Dongyang Zhan. I found a potential bug in </pre><pre id=3D"g=
mail-m_-4853843472690211139gmail-m_-847641244839025803gmail-m_4091962907303=
224627gmail-m_-7092909529653893599gmail-m_-8558348290116643165gmail-m_-7810=
375000073948968gmail-comment_text_0" style=3D"white-space:pre-wrap;font-siz=
e:medium;width:50em;color:rgb(0,0,0)"><span style=3D"font-family:Arial,Helv=
etica,sans-serif">/drivers/md/dm-region-hash.c</span> in Linux 4.10.17. I h=
ope you can help me to confirm it. </pre><pre id=3D"gmail-m_-48538434726902=
11139gmail-m_-847641244839025803gmail-m_4091962907303224627gmail-m_-7092909=
529653893599gmail-m_-8558348290116643165gmail-m_-7810375000073948968gmail-c=
omment_text_0" style=3D"white-space:pre-wrap;font-size:medium;width:50em;co=
lor:rgb(0,0,0)"><span style=3D"font-family:Arial,Helvetica,sans-serif"><br>=
</span></pre><pre id=3D"gmail-m_-4853843472690211139gmail-m_-84764124483902=
5803gmail-m_4091962907303224627gmail-m_-7092909529653893599gmail-m_-8558348=
290116643165gmail-m_-7810375000073948968gmail-comment_text_0" style=3D"whit=
e-space:pre-wrap;font-size:medium;width:50em;color:rgb(0,0,0)"><span style=
=3D"font-family:Arial,Helvetica,sans-serif">__rh_alloc() in /drivers/md/dm-=
region-hash.c mishandles the memory allocation failures of nreg. </span><br=
></pre><pre id=3D"gmail-m_-4853843472690211139gmail-m_-847641244839025803gm=
ail-m_4091962907303224627gmail-m_-7092909529653893599gmail-m_-8558348290116=
643165gmail-m_-7810375000073948968gmail-comment_text_0" style=3D"white-spac=
e:pre-wrap;font-size:medium;width:50em;color:rgb(0,0,0)"><pre class=3D"gmai=
l-bz_comment_text" id=3D"gmail-comment_text_0" style=3D"width:50em;white-sp=
ace:pre-wrap">Source code:

struct dm_region *reg, *nreg;

nreg =3D mempool_alloc(rh-&gt;region_pool, GFP_ATOMIC);
if (unlikely(!nreg))
=09=09nreg =3D kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);

nreg-&gt;state =3D rh-&gt;log-&gt;type-&gt;in_sync(rh-&gt;log, region, 1) ?
=09=09DM_RH_CLEAN : DM_RH_NOSYNC;

If the statement (nreg =3D kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);=
) fails,
dereferencing this pointer (nreg-&gt;state) will cause null pointer derefer=
ence.</pre>

</pre></div>

--0000000000009b4a7505a4b8ff7a--

--===============0781338931935313827==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0781338931935313827==--
