From: John Dorminy <jdorminy@redhat.com>
Subject: Re: dm: introduce DM_GET_TARGET_VERSION
Date: Tue, 17 Sep 2019 11:44:20 -0400
Message-ID: <CAMeeMh_cq=F3JRZQrLbXA8=DkrvWD7qWNrNyBZdLarWWKcZXAQ@mail.gmail.com>
References: <alpine.LRH.2.02.1909160553360.11421@file01.intranet.prod.int.rdu2.redhat.com>
	<20190916180107.GA725@infradead.org>
	<127b8c4e-a6dc-6d5e-caff-fe1a0ca3a5bb@gmail.com>
	<CAMeeMh9t4LBwJn_CPQgFNa_Tyj22fJYHK-4qAnyn0RXm9RzCnw@mail.gmail.com>
	<20190917140632.GA3728@redhat.com>
	<alpine.LRH.2.02.1909171133100.1876@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2773920181459468637=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1909171133100.1876@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, lvm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

--===============2773920181459468637==
Content-Type: multipart/alternative; boundary="000000000000b398290592c198b0"

--000000000000b398290592c198b0
Content-Type: text/plain; charset="UTF-8"

Makes sense, sorry I missed that detail.

Might it be better to just extend 'dmsetup targets' to take an optional
target-name parameter? When I saw this change, I thought 'dmsetup targets
<name>' surely worked already for the purpose, and was somewhat surprised
when experiment disagreed. Then list_versions() has much the same code
change as in this change, there's a little change in validate_params(), and
it seems less surprising (to me) to extend the existing
target-information-printing dmsetup command than to add another one.

--000000000000b398290592c198b0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Makes sense, sorry I missed that detail.<br><br></div=
>Might it be better to just extend &#39;dmsetup targets&#39; to take an opt=
ional target-name parameter? When I saw this change, I thought &#39;dmsetup=
 targets &lt;name&gt;&#39; surely worked already for the purpose, and was s=
omewhat surprised when experiment disagreed. Then list_versions() has much =
the same code change as in this change, there&#39;s a little change in vali=
date_params(), and it seems less surprising (to me) to extend the existing =
target-information-printing dmsetup command than to add another one.<br><br=
><br></div>

--000000000000b398290592c198b0--


--===============2773920181459468637==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2773920181459468637==--
