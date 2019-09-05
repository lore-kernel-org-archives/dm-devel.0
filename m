From: jianchao wang <jianchao.wan9@gmail.com>
Subject: Why does dm-thin pool metadata space map use 4K page to
	carry index ?
Date: Thu, 5 Sep 2019 14:43:28 +0800
Message-ID: <CAC-DDmMQu38J6kCirxK=axwEguEpaN+H1JJVPbUsyqtxcx5KEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4593842141826827868=="
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
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============4593842141826827868==
Content-Type: multipart/alternative; boundary="0000000000004736ac0591c8a4c0"

--0000000000004736ac0591c8a4c0
Content-Type: text/plain; charset="UTF-8"

Hi

As the code,

The metadata space map use following structure which locates on a 4K page
on disk
to carry the disk_index_entry.

The on-disk format of metadata spacemap

The metadata space's bitmap root is a
#define MAX_METADATA_BITMAPS 255
struct disk_metadata_index {
    __le32 csum;
    __le32 padding;
    __le64 blocknr;

    struct disk_index_entry index[MAX_METADATA_BITMAPS];
} __packed;

It will be read in when open the pool
sm_ll_open_metadata
  -> set ll callbacks
  -> ll->open_index
metadata_ll_open
---
    r = dm_tm_read_lock(ll->tm, ll->bitmap_root,
                &index_validator, &block);
    if (r)
        return r;

    memcpy(&ll->mi_le, dm_block_data(block), sizeof(ll->mi_le));
    dm_tm_unlock(ll->tm, block);

---
The size of struct disk_metadata_index is 4096.
The disk_index_entry's size is 8 bytes

4096 * 8 / 2 = 16K    blocks per page

metadata block = 4K

256 * 16K * 4K = 16G

Then it have a 6G limit on metadata blocks size.

But why does it use this 4K page instead of btree as the disk sm ?

The brb mechanism seem be able to avoid the nested block allocation
when do COW on the metadata sm btree.

Would anyone please help to tell why does it use this 4K page instead of a
btree ?


Thanks in advance
Jianchao

--0000000000004736ac0591c8a4c0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi<br><br>As the code,<br><br>The metadata space map use f=
ollowing structure which locates on a 4K page on disk<br>to carry the disk_=
index_entry.<br><br>The on-disk format of metadata spacemap<br><br>The meta=
data space&#39;s bitmap root is a<br>#define MAX_METADATA_BITMAPS 255<br>st=
ruct disk_metadata_index {<br>=C2=A0 =C2=A0 __le32 csum;<br>=C2=A0 =C2=A0 _=
_le32 padding;<br>=C2=A0 =C2=A0 __le64 blocknr;<br><br>=C2=A0 =C2=A0 struct=
 disk_index_entry index[MAX_METADATA_BITMAPS];<br>} __packed;<br><br>It wil=
l be read in when open the pool<br>sm_ll_open_metadata<br>=C2=A0 -&gt; set =
ll callbacks<br>=C2=A0 -&gt; ll-&gt;open_index<br>metadata_ll_open<br>---<b=
r>=C2=A0 =C2=A0 r =3D dm_tm_read_lock(ll-&gt;tm, ll-&gt;bitmap_root,<br>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;index_validator, =
&amp;block);<br>=C2=A0 =C2=A0 if (r)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 return =
r;<br><br>=C2=A0 =C2=A0 memcpy(&amp;ll-&gt;mi_le, dm_block_data(block), siz=
eof(ll-&gt;mi_le));<br>=C2=A0 =C2=A0 dm_tm_unlock(ll-&gt;tm, block);<br><br=
>---<br>The size of struct disk_metadata_index is 4096.<br>The disk_index_e=
ntry&#39;s size is 8 bytes<br><br>4096 * 8 / 2 =3D 16K =C2=A0 =C2=A0blocks =
per page<br><br>metadata block =3D 4K<br><br>256 * 16K * 4K =3D 16G<br><br>=
Then it have a 6G limit on metadata blocks size.<br><br>But why does it use=
 this 4K page instead of btree as the disk sm ?<br><br>The brb mechanism se=
em be able to avoid the nested block allocation<br>when do COW on the metad=
ata sm btree.<br><br>Would anyone please help to tell why does it use this =
4K page instead of a btree ?<br><br>=C2=A0<br>Thanks in advance<br>Jianchao=
<br><br><br></div>

--0000000000004736ac0591c8a4c0--


--===============4593842141826827868==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4593842141826827868==--
