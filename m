From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm writecache: SB remove seq_count
Date: Wed, 8 Jan 2020 08:54:00 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2001021144450.18253@file01.intranet.prod.int.rdu2.redhat.com>
References: <598c7c64-9b11-3407-2060-8d43b1ef1241@petasan.org>
	<d76f7245-034c-f225-00fe-f33c5e9abf1a@petasan.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185206533-718882174-1577985305=:18253"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d76f7245-034c-f225-00fe-f33c5e9abf1a@petasan.org>
Content-ID: <alpine.LRH.2.02.2001021312320.25908@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Maged Mokhtar <mmokhtar@petasan.org>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185206533-718882174-1577985305=:18253
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-ID: <alpine.LRH.2.02.2001021312321.25908@file01.intranet.prod.int.rdu2.redhat.com>
Content-Transfer-Encoding: quoted-printable

Hi


On Thu, 2 Jan 2020, Maged Mokhtar wrote:

> Any feedback on this patch please.

This will definitely not work for persistent memory - it could corrupt=20
data if a crash happens. The CPU can flush data in arbitrary order and it=
=20
may happen that the seq count is flushed before the pertaining data.

As for SSD mode - we could avoid updating the refcount in the superblock,=
=20
but it wouldn't be much helpful.

I.e. normally, commit is done this way:
1. submit data writes
2. submit metadata writes
3. flush disk cache
4. submit the write of superblock with increased seq_count
5. flush disk cache

If we wanted to avoid writing the seq_count, we would need to change it=20
to:
1. submit data writes
2. flush disk cache
3. submit metadata writes
4. flush disk cache

- i.e. it sill needs two disk cache flushes per one commit request - and=20
it is not much better than the existing solution.

Mikulas

> On 06/12/2019 21:03, Maged Mokhtar wrote:
> > Removes seq_count from super block. Currently the super block gets writ=
ten
> > in each commit to update the seq_count which is just used when the targ=
et is
> > restarted/resumed. This extra iop has a performance impact on small blo=
ck
> > size writes which do FUA/sync on every request. A 4k sync write current=
ly
> > requires 3 write ops: submitted data, metadata + super block seq_count
> > update, removal of seq_count update reduces required write ops to 2.
> >=20
> > Rebuild of seq_count at start/resumption can be done quickly by looping
> > through memory entry metadata within the resume() function.
> >=20
> > Signed-off-by: Maged Mokhtar <mmokhtar@petasan.org>
> > ---
> >  =A0drivers/md/dm-writecache.c |=A0=A0 56 ++++++++++++++++++++++++++---=
------
> >  =A01 file changed, 42 insertions(+), 14 deletions(-)
> >=20
> > --- a/drivers/md/dm-writecache.c=A0=A0=A0 2019-12-06 03:07:53.000000000=
 -0800
> > +++ b/drivers/md/dm-writecache.c=A0=A0=A0 2019-12-06 09:25:45.000000000=
 -0800
> > @@ -52,7 +52,8 @@ do {=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 \
> >  =A0#endif
> >=20
> >  =A0#define MEMORY_SUPERBLOCK_MAGIC=A0=A0=A0=A0=A0=A0=A0 0x23489321
> > -#define MEMORY_SUPERBLOCK_VERSION=A0=A0=A0 1
> > +#define MEMORY_SUPERBLOCK_VERSION_1=A0=A0=A0 1
> > +#define MEMORY_SUPERBLOCK_VERSION_2=A0=A0=A0 2
> >=20
> >  =A0struct wc_memory_entry {
> >  =A0=A0=A0=A0 __le64 original_sector;
> > @@ -67,7 +68,6 @@ struct wc_memory_superblock {
> >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le32 block_size;
> >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le32 pad;
> >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le64 n_blocks;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le64 seq_count;
> >  =A0=A0=A0=A0=A0=A0=A0=A0 };
> >  =A0=A0=A0=A0=A0=A0=A0=A0 __le64 padding[8];
> >  =A0=A0=A0=A0 };
> > @@ -380,6 +380,41 @@ static uint64_t read_seq_count(struct dm
> >  =A0#endif
> >  =A0}
> >=20
> > +static uint64_t read_last_seq_count(struct dm_writecache *wc)
> > +{
> > +=A0=A0=A0 size_t b;
> > +=A0=A0=A0 uint64_t last_seq_count =3D 0;
> > +=A0=A0=A0 uint64_t seq_count;
> > +=A0=A0=A0 __le64 empty =3D cpu_to_le64(-1);
> > +
> > +=A0=A0=A0 if (WC_MODE_PMEM(wc)) {
> > +=A0=A0=A0=A0=A0=A0=A0 struct wc_memory_entry wme;
> > +=A0=A0=A0=A0=A0=A0=A0 for (b =3D 0; b < wc->n_blocks; b++) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 BUG_ON(memcpy_mcsafe(&wme, &sb(wc)->=
entries[b],
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(struct wc_memory_=
entry)));
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (wme.seq_count !=3D empty) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 seq_count =3D le64_to_cp=
u(wme.seq_count);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (last_seq_count < seq=
_count)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 last_seq_cou=
nt =3D seq_count;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> > +=A0=A0=A0=A0=A0=A0=A0 }
> > +=A0=A0=A0 }
> > +=A0=A0=A0 else {
> > +=A0=A0=A0=A0=A0=A0=A0 struct wc_memory_entry *p =3D &sb(wc)->entries[0=
];
> > +=A0=A0=A0=A0=A0=A0=A0 b =3D wc->n_blocks;
> > +=A0=A0=A0=A0=A0=A0=A0 while (0 < b) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (p->seq_count !=3D empty) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 seq_count =3D le64_to_cp=
u(p->seq_count);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (last_seq_count < seq=
_count)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 last_seq_cou=
nt =3D seq_count;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p++;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 b--;
> > +=A0=A0=A0=A0=A0=A0=A0 }
> > +=A0=A0=A0 }
> > +=A0=A0=A0 return last_seq_count;
> > +}
> > +
> >  =A0static void clear_seq_count(struct dm_writecache *wc, struct wc_ent=
ry *e)
> >  =A0{
> >  =A0#ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
> > @@ -730,8 +765,6 @@ static void writecache_flush(struct dm_w
> >  =A0=A0=A0=A0=A0=A0=A0=A0 writecache_wait_for_ios(wc, WRITE);
> >=20
> >  =A0=A0=A0=A0 wc->seq_count++;
> > -=A0=A0=A0 pmem_assign(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
> > -=A0=A0=A0 writecache_flush_region(wc, &sb(wc)->seq_count, sizeof
> > sb(wc)->seq_count);
> >  =A0=A0=A0=A0 writecache_commit_flushed(wc);
> >=20
> >  =A0=A0=A0=A0 wc->overwrote_committed =3D false;
> > @@ -876,7 +909,6 @@ static void writecache_resume(struct dm_
> >  =A0=A0=A0=A0 struct dm_writecache *wc =3D ti->private;
> >  =A0=A0=A0=A0 size_t b;
> >  =A0=A0=A0=A0 bool need_flush =3D false;
> > -=A0=A0=A0 __le64 sb_seq_count;
> >  =A0=A0=A0=A0 int r;
> >=20
> >  =A0=A0=A0=A0 wc_lock(wc);
> > @@ -894,12 +926,7 @@ static void writecache_resume(struct dm_
> >  =A0=A0=A0=A0 }
> >  =A0=A0=A0=A0 wc->freelist_size =3D 0;
> >=20
> > -=A0=A0=A0 r =3D memcpy_mcsafe(&sb_seq_count, &sb(wc)->seq_count, sizeo=
f(uint64_t));
> > -=A0=A0=A0 if (r) {
> > -=A0=A0=A0=A0=A0=A0=A0 writecache_error(wc, r, "hardware memory error w=
hen reading
> > superblock: %d", r);
> > -=A0=A0=A0=A0=A0=A0=A0 sb_seq_count =3D cpu_to_le64(0);
> > -=A0=A0=A0 }
> > -=A0=A0=A0 wc->seq_count =3D le64_to_cpu(sb_seq_count);
> > +=A0=A0=A0 wc->seq_count =3D read_last_seq_count(wc) + 1;
> >=20
> >  =A0#ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
> >  =A0=A0=A0=A0 for (b =3D 0; b < wc->n_blocks; b++) {
> > @@ -1757,10 +1784,9 @@ static int init_memory(struct dm_writeca
> >=20
> >  =A0=A0=A0=A0 for (b =3D 0; b < ARRAY_SIZE(sb(wc)->padding); b++)
> >  =A0=A0=A0=A0=A0=A0=A0=A0 pmem_assign(sb(wc)->padding[b], cpu_to_le64(0=
));
> > -=A0=A0=A0 pmem_assign(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_V=
ERSION));
> > +=A0=A0=A0 pmem_assign(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_V=
ERSION_2));
> >  =A0=A0=A0=A0 pmem_assign(sb(wc)->block_size, cpu_to_le32(wc->block_siz=
e));
> >  =A0=A0=A0=A0 pmem_assign(sb(wc)->n_blocks, cpu_to_le64(wc->n_blocks));
> > -=A0=A0=A0 pmem_assign(sb(wc)->seq_count, cpu_to_le64(0));
> >=20
> >  =A0=A0=A0=A0 for (b =3D 0; b < wc->n_blocks; b++)
> >  =A0=A0=A0=A0=A0=A0=A0=A0 write_original_sector_seq_count(wc, &wc->entr=
ies[b], -1, -1);
> > @@ -2159,11 +2185,13 @@ invalid_optional:
> >  =A0=A0=A0=A0=A0=A0=A0=A0 goto bad;
> >  =A0=A0=A0=A0 }
> >=20
> > -=A0=A0=A0 if (le32_to_cpu(s.version) !=3D MEMORY_SUPERBLOCK_VERSION) {
> > +=A0=A0=A0 if (le32_to_cpu(s.version) !=3D MEMORY_SUPERBLOCK_VERSION_1 =
&&
> > +=A0=A0=A0=A0=A0=A0=A0 le32_to_cpu(s.version) !=3D MEMORY_SUPERBLOCK_VE=
RSION_2) {
> >  =A0=A0=A0=A0=A0=A0=A0=A0 ti->error =3D "Invalid version in the superbl=
ock";
> >  =A0=A0=A0=A0=A0=A0=A0=A0 r =3D -EINVAL;
> >  =A0=A0=A0=A0=A0=A0=A0=A0 goto bad;
> >  =A0=A0=A0=A0 }
> > +=A0=A0=A0 pmem_assign(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_V=
ERSION_2));
> >=20
> >  =A0=A0=A0=A0 if (le32_to_cpu(s.block_size) !=3D wc->block_size) {
> >  =A0=A0=A0=A0=A0=A0=A0=A0 ti->error =3D "Block size does not match supe=
rblock";
>=20
> --=20
> Maged Mokhtar
> CEO PetaSAN
> 4 Emad El Deen Kamel
> Cairo 11371, Egypt
> www.petasan.org
> +201006979931
> skype: maged.mokhtar
> 
--185206533-718882174-1577985305=:18253
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--185206533-718882174-1577985305=:18253--
