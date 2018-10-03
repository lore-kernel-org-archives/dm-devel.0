From: Thanos Makatos <thanos.makatos@sunlight.io>
Subject: extracting thin mappings in real time
Date: Wed, 3 Oct 2018 13:40:22 +0100
Message-ID: <CA+fs2JN0evmnJP2yZT144bUOdxaxUydchXrZmLmFVy4F20yfAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4771469181499273703=="
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
Cc: thornber@redhat.com
List-Id: dm-devel.ids

--===============4771469181499273703==
Content-Type: multipart/alternative; boundary="00000000000022534e05775258aa"

--00000000000022534e05775258aa
Content-Type: text/plain; charset="UTF-8"

I have a kernel module that sits on top of a thin device mapper target that
receives block I/O requests and re-submits then to the thin target. I would
like to implement the following functionality: whenever I receive a write
completion from the thin target (assuming that it's the first time a block
written to) I would like to extract the newly-established mapping of that
virtual block.

I know that I can do this using thin_dump, however this involves:
(1) spawning a process
(2) reserving/releasing a metadata snapshot, and
(3) dumping _all_ the mappings.

In other words, it's far to heavyweight for my performance requirements.

Ideally I would like to be able to obtain the mapping in kernel space. I
had a look at thin_dump and from what I understand it directly reads the
B-tree from the disk? Is there some kernel function that already does this?
E.g. given a thin LBA return the physical block address.

Also, regarding having to have reserved a metadata snapshot, is this
necessary for obtaining mappings? Aren't mappings immutable once established
?

-- 
Thanos Makatos

--00000000000022534e05775258aa
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I have a kernel module that sits on top of a thin device m=
apper target that receives block I/O requests and re-submits then to the th=
in target. I would like to implement the following functionality: whenever =
I receive a write completion from the thin target (assuming that it&#39;s t=
he first time a block written to) I would like to extract the newly-establi=
shed mapping of that virtual block.<div><br></div><div>I know that I can do=
 this using thin_dump, however this involves:</div><div>(1) spawning a proc=
ess</div><div>(2) reserving/releasing a=C2=A0<span id=3D"gmail-m_8004591443=
944844714:29k.18">metadata</span>=C2=A0snapshot, and</div><div>(3) dumping =
_all_ the mappings.</div><div><br></div><div>In other words, it&#39;s far t=
o heavyweight for my=C2=A0<span id=3D"gmail-m_8004591443944844714:29k.19">p=
erformance</span>=C2=A0requirements.</div><div><br></div><div>Ideally I wou=
ld like to be able to obtain the mapping in kernel space. I had a look at t=
hin_dump and from what I=C2=A0<span id=3D"gmail-m_8004591443944844714:29k.2=
0">understand</span>=C2=A0it directly reads the B-tree from the disk? Is th=
ere some kernel function that already does this? E.g. given a thin=C2=A0<sp=
an id=3D"gmail-m_8004591443944844714:29k.21">LBA</span>=C2=A0return the phy=
sical block address.</div><div><br></div><div>Also, regarding having to hav=
e reserved a=C2=A0<span id=3D"gmail-m_8004591443944844714:29k.22">metadata<=
/span>=C2=A0snapshot, is this necessary for obtaining mappings? Aren&#39;t =
mappings immutable once e<span id=3D"gmail-m_8004591443944844714:29k.23">st=
ablished</span>?<br clear=3D"all"><div><br></div>--=C2=A0<br><div dir=3D"lt=
r" class=3D"gmail-m_8004591443944844714gmail_signature"><span id=3D"gmail-m=
_8004591443944844714:29k.24">Thanos</span>=C2=A0<span id=3D"gmail-m_8004591=
443944844714:29k.25">Makatos</span><br></div></div></div>

--00000000000022534e05775258aa--


--===============4771469181499273703==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4771469181499273703==--
