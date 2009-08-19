From: Guilherme Moro <guilherme.moro@gmail.com>
Subject: Chunk size, mask and shift
Date: Wed, 19 Aug 2009 11:58:48 -0300
Message-ID: <59a2a3420908190758r3fed0190w41a9e7ceb65d01a5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0211008861=="
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

--===============0211008861==
Content-Type: multipart/alternative; boundary=0016362848ee57038b04717fdf0e

--0016362848ee57038b04717fdf0e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

hello,

Im trying to understand the dm-snapshot target, but Im not sure how it uses
the size, mask and shift of the chunks, not sure if I understand it
correctly.

Can anyone give an overall idea of why they are initialized this way

store->chunk_size = chunk_size_ulong;
store->chunk_mask = chunk_size_ulong - 1;
store->chunk_shift = ffs(chunk_size_ulong) - 1;

and why use this to translate sector to chunks

static inline chunk_t sector_to_chunk(struct dm_exception_store *store,
                      sector_t sector)
{
    return (sector & ~store->chunk_mask) >> store->chunk_shift;
}

thanks,

Guilherme Moro

--0016362848ee57038b04717fdf0e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

hello,<br><br>Im trying to understand the dm-snapshot target, but Im not su=
re how it uses the size, mask and shift of the chunks, not sure if I unders=
tand it correctly.<br><br>Can anyone give an overall idea of why they are i=
nitialized this way <br>
<br>store-&gt;chunk_size =3D chunk_size_ulong;<br>store-&gt;chunk_mask =3D =
chunk_size_ulong - 1;<br>store-&gt;chunk_shift =3D ffs(chunk_size_ulong) - =
1;<br><br>and why use this to translate sector to chunks <br><br>static inl=
ine chunk_t sector_to_chunk(struct dm_exception_store *store,<br>
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0=A0 sector_t sector)<br=
>{<br>=A0=A0=A0 return (sector &amp; ~store-&gt;chunk_mask) &gt;&gt; store-=
&gt;chunk_shift;<br>}<br><br>thanks,<br><br>Guilherme Moro<br>

--0016362848ee57038b04717fdf0e--


--===============0211008861==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0211008861==--
