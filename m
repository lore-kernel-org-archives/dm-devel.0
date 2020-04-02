From: John Dorminy <jdorminy@redhat.com>
Subject: Re: [PATCH 3/4] dm-zoned: V2 metadata handling
Date: Thu, 2 Apr 2020 10:53:26 -0400
Message-ID: <CAMeeMh82FSZm4+i2+1f89P542=3HZR6S8--yP88ZiEjYSxUveA@mail.gmail.com>
References: <20200327071459.67796-1-hare@suse.de>
	<20200327071459.67796-4-hare@suse.de>
	<93a26ed9-6f6e-2a4d-38d3-3fb76fa91e70@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7801092428175613009=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <93a26ed9-6f6e-2a4d-38d3-3fb76fa91e70@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bob Liu <bob.liu@oracle.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

--===============7801092428175613009==
Content-Type: multipart/alternative; boundary="0000000000003bc99505a24ff7e0"

--0000000000003bc99505a24ff7e0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm worried about hardcoding uuid members as u8[16].

May I ask why you're not using uuid_t to define it in the on-disk
structure? It would save the casting of the uuid members to (uuid_t *)
every time you use a uuid.h function.

Possibly it is customary to use only raw datatypes on disk rather than
opaque types like uuid_t, I'm not sure. But in that case, perhaps using the
named constant UUID_SIZE instead of 16 would make the meaning clearer?

Thanks!

--0000000000003bc99505a24ff7e0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">I&#39;m worried about hardcoding uuid mem=
bers as u8[16].<br><br>May I ask why you&#39;re not using uuid_t to define =
it in the on-disk structure? It would save the casting of the uuid members =
to (uuid_t *) every time you use a uuid.h function.<br><br>Possibly it is c=
ustomary to use only raw datatypes on disk rather than opaque types like uu=
id_t, I&#39;m not sure. But in that case, perhaps using the named constant =
UUID_SIZE instead of 16 would make the meaning clearer?<br><br></div><div>T=
hanks!<br></div></div>

--0000000000003bc99505a24ff7e0--

--===============7801092428175613009==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7801092428175613009==--
