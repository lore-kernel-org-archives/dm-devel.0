From: Maged Mokhtar <mmokhtar@petasan.org>
Subject: Re: [PATCH] dm writecache: SB remove seq_count
Date: Mon, 13 Jan 2020 22:02:52 +0200
Message-ID: <a858b409-d3d5-b439-5f15-563fb5316d2a@petasan.org>
References: <598c7c64-9b11-3407-2060-8d43b1ef1241@petasan.org>
	<d76f7245-034c-f225-00fe-f33c5e9abf1a@petasan.org>
	<alpine.LRH.2.02.2001021144450.18253@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2001021144450.18253@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
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
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids



> Hi
>=20
>=20
> On Thu, 2 Jan 2020, Maged Mokhtar wrote:
>=20
>> Any feedback on this patch please.
>=20
> This will definitely not work for persistent memory - it could corrupt
> data if a crash happens. The CPU can flush data in arbitrary order and it
> may happen that the seq count is flushed before the pertaining data.
>=20
> As for SSD mode - we could avoid updating the refcount in the superblock,
> but it wouldn't be much helpful.
>=20
> I.e. normally, commit is done this way:
> 1. submit data writes
> 2. submit metadata writes
> 3. flush disk cache
> 4. submit the write of superblock with increased seq_count
> 5. flush disk cache
>=20
> If we wanted to avoid writing the seq_count, we would need to change it
> to:
> 1. submit data writes
> 2. flush disk cache
> 3. submit metadata writes
> 4. flush disk cache
>=20
> - i.e. it sill needs two disk cache flushes per one commit request - and
> it is not much better than the existing solution.
>=20
> Mikulas
>=20


Hi Mikulas,

I appreciate your review. For SSD mode, I see the advantages of SB=20
writes for handling crash recovery and agree with what you say. Note=20
however that after a crash a proper client should not assume the data is=20
valid on a device, only at the point it last issued a successful flush=20
should the data be consistent, after this it should not assume so. A=20
filesystem/db should handle journals/transaction at a higher level than=20
the device. But again anything we can do on the device/target to make=20
things more consistent, the better, so i agree there.

There is also limit to what the current crash recovery code can do, as i=20
understand it if you have metadata already committed, their seq count is=20
not incremented for new io on the same blocks, the crash recovery code=20
will therefore not detect or recover cases where new data is written to=20
existing 4k blocks at the time of crash, some blocks will end up with=20
new data, others will not. Again this is my understanding so i could be=20
wrong.

I think if crash consistency needs to be enhanced, it should take into=20
account that most consumer/non-enterprise SSDs do not offer power loss=20
protection. For many such devices power loss can corrupt data that is=20
already written as they commit data in larger chunks via a=20
read/modify/erase/write cycle. It is particularly bad for metadata as it=20
could affect many data blocks. Maybe it could be good to have metadata=20
writes via transactions or journaling, dm-cache and thin provisioning do=20
something like this i think.

i also think your suggestion of:
 > If we wanted to avoid writing the seq_count, we would need to change it
 > to:
 > 1. submit data writes
 > 2. flush disk cache
 > 3. submit metadata writes
 > 4. flush disk cache

could be better in terms of prolonging SSD lifetime, as currently the=20
superblock gets much higher write frequency.

/Maged




>> On 06/12/2019 21:03, Maged Mokhtar wrote:
>>> Removes seq_count from super block. Currently the super block gets writ=
ten
>>> in each commit to update the seq_count which is just used when the targ=
et is
>>> restarted/resumed. This extra iop has a performance impact on small blo=
ck
>>> size writes which do FUA/sync on every request. A 4k sync write current=
ly
>>> requires 3 write ops: submitted data, metadata + super block seq_count
>>> update, removal of seq_count update reduces required write ops to 2.
>>>
>>> Rebuild of seq_count at start/resumption can be done quickly by looping
>>> through memory entry metadata within the resume() function.
>>>
>>> Signed-off-by: Maged Mokhtar <mmokhtar@petasan.org>
>>> ---
>>>   =A0drivers/md/dm-writecache.c |=A0=A0 56 ++++++++++++++++++++++++++--=
-------
>>>   =A01 file changed, 42 insertions(+), 14 deletions(-)
>>>
>>> --- a/drivers/md/dm-writecache.c=A0=A0=A0 2019-12-06 03:07:53.000000000=
 -0800
>>> +++ b/drivers/md/dm-writecache.c=A0=A0=A0 2019-12-06 09:25:45.000000000=
 -0800
>>> @@ -52,7 +52,8 @@ do {=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 \
>>>   =A0#endif
>>>
>>>   =A0#define MEMORY_SUPERBLOCK_MAGIC=A0=A0=A0=A0=A0=A0=A0 0x23489321
>>> -#define MEMORY_SUPERBLOCK_VERSION=A0=A0=A0 1
>>> +#define MEMORY_SUPERBLOCK_VERSION_1=A0=A0=A0 1
>>> +#define MEMORY_SUPERBLOCK_VERSION_2=A0=A0=A0 2
>>>
>>>   =A0struct wc_memory_entry {
>>>   =A0=A0=A0=A0 __le64 original_sector;
>>> @@ -67,7 +68,6 @@ struct wc_memory_superblock {
>>>   =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le32 block_size;
>>>   =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le32 pad;
>>>   =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le64 n_blocks;
>>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le64 seq_count;
>>>   =A0=A0=A0=A0=A0=A0=A0=A0 };
>>>   =A0=A0=A0=A0=A0=A0=A0=A0 __le64 padding[8];
>>>   =A0=A0=A0=A0 };
>>> @@ -380,6 +380,41 @@ static uint64_t read_seq_count(struct dm
>>>   =A0#endif
>>>   =A0}
>>>
>>> +static uint64_t read_last_seq_count(struct dm_writecache *wc)
>>> +{
>>> +=A0=A0=A0 size_t b;
>>> +=A0=A0=A0 uint64_t last_seq_count =3D 0;
>>> +=A0=A0=A0 uint64_t seq_count;
>>> +=A0=A0=A0 __le64 empty =3D cpu_to_le64(-1);
>>> +
>>> +=A0=A0=A0 if (WC_MODE_PMEM(wc)) {
>>> +=A0=A0=A0=A0=A0=A0=A0 struct wc_memory_entry wme;
>>> +=A0=A0=A0=A0=A0=A0=A0 for (b =3D 0; b < wc->n_blocks; b++) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 BUG_ON(memcpy_mcsafe(&wme, &sb(wc)->=
entries[b],
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(struct wc_memory_=
entry)));
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (wme.seq_count !=3D empty) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 seq_count =3D le64_to_cp=
u(wme.seq_count);
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (last_seq_count < seq=
_count)
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 last_seq_cou=
nt =3D seq_count;
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>>> +=A0=A0=A0=A0=A0=A0=A0 }
>>> +=A0=A0=A0 }
>>> +=A0=A0=A0 else {
>>> +=A0=A0=A0=A0=A0=A0=A0 struct wc_memory_entry *p =3D &sb(wc)->entries[0=
];
>>> +=A0=A0=A0=A0=A0=A0=A0 b =3D wc->n_blocks;
>>> +=A0=A0=A0=A0=A0=A0=A0 while (0 < b) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (p->seq_count !=3D empty) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 seq_count =3D le64_to_cp=
u(p->seq_count);
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (last_seq_count < seq=
_count)
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 last_seq_cou=
nt =3D seq_count;
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p++;
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 b--;
>>> +=A0=A0=A0=A0=A0=A0=A0 }
>>> +=A0=A0=A0 }
>>> +=A0=A0=A0 return last_seq_count;
>>> +}
>>> +
>>>   =A0static void clear_seq_count(struct dm_writecache *wc, struct wc_en=
try *e)
>>>   =A0{
>>>   =A0#ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
>>> @@ -730,8 +765,6 @@ static void writecache_flush(struct dm_w
>>>   =A0=A0=A0=A0=A0=A0=A0=A0 writecache_wait_for_ios(wc, WRITE);
>>>
>>>   =A0=A0=A0=A0 wc->seq_count++;
>>> -=A0=A0=A0 pmem_assign(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
>>> -=A0=A0=A0 writecache_flush_region(wc, &sb(wc)->seq_count, sizeof
>>> sb(wc)->seq_count);
>>>   =A0=A0=A0=A0 writecache_commit_flushed(wc);
>>>
>>>   =A0=A0=A0=A0 wc->overwrote_committed =3D false;
>>> @@ -876,7 +909,6 @@ static void writecache_resume(struct dm_
>>>   =A0=A0=A0=A0 struct dm_writecache *wc =3D ti->private;
>>>   =A0=A0=A0=A0 size_t b;
>>>   =A0=A0=A0=A0 bool need_flush =3D false;
>>> -=A0=A0=A0 __le64 sb_seq_count;
>>>   =A0=A0=A0=A0 int r;
>>>
>>>   =A0=A0=A0=A0 wc_lock(wc);
>>> @@ -894,12 +926,7 @@ static void writecache_resume(struct dm_
>>>   =A0=A0=A0=A0 }
>>>   =A0=A0=A0=A0 wc->freelist_size =3D 0;
>>>
>>> -=A0=A0=A0 r =3D memcpy_mcsafe(&sb_seq_count, &sb(wc)->seq_count, sizeo=
f(uint64_t));
>>> -=A0=A0=A0 if (r) {
>>> -=A0=A0=A0=A0=A0=A0=A0 writecache_error(wc, r, "hardware memory error w=
hen reading
>>> superblock: %d", r);
>>> -=A0=A0=A0=A0=A0=A0=A0 sb_seq_count =3D cpu_to_le64(0);
>>> -=A0=A0=A0 }
>>> -=A0=A0=A0 wc->seq_count =3D le64_to_cpu(sb_seq_count);
>>> +=A0=A0=A0 wc->seq_count =3D read_last_seq_count(wc) + 1;
>>>
>>>   =A0#ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
>>>   =A0=A0=A0=A0 for (b =3D 0; b < wc->n_blocks; b++) {
>>> @@ -1757,10 +1784,9 @@ static int init_memory(struct dm_writeca
>>>
>>>   =A0=A0=A0=A0 for (b =3D 0; b < ARRAY_SIZE(sb(wc)->padding); b++)
>>>   =A0=A0=A0=A0=A0=A0=A0=A0 pmem_assign(sb(wc)->padding[b], cpu_to_le64(=
0));
>>> -=A0=A0=A0 pmem_assign(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_V=
ERSION));
>>> +=A0=A0=A0 pmem_assign(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_V=
ERSION_2));
>>>   =A0=A0=A0=A0 pmem_assign(sb(wc)->block_size, cpu_to_le32(wc->block_si=
ze));
>>>   =A0=A0=A0=A0 pmem_assign(sb(wc)->n_blocks, cpu_to_le64(wc->n_blocks))=
;
>>> -=A0=A0=A0 pmem_assign(sb(wc)->seq_count, cpu_to_le64(0));
>>>
>>>   =A0=A0=A0=A0 for (b =3D 0; b < wc->n_blocks; b++)
>>>   =A0=A0=A0=A0=A0=A0=A0=A0 write_original_sector_seq_count(wc, &wc->ent=
ries[b], -1, -1);
>>> @@ -2159,11 +2185,13 @@ invalid_optional:
>>>   =A0=A0=A0=A0=A0=A0=A0=A0 goto bad;
>>>   =A0=A0=A0=A0 }
>>>
>>> -=A0=A0=A0 if (le32_to_cpu(s.version) !=3D MEMORY_SUPERBLOCK_VERSION) {
>>> +=A0=A0=A0 if (le32_to_cpu(s.version) !=3D MEMORY_SUPERBLOCK_VERSION_1 =
&&
>>> +=A0=A0=A0=A0=A0=A0=A0 le32_to_cpu(s.version) !=3D MEMORY_SUPERBLOCK_VE=
RSION_2) {
>>>   =A0=A0=A0=A0=A0=A0=A0=A0 ti->error =3D "Invalid version in the superb=
lock";
>>>   =A0=A0=A0=A0=A0=A0=A0=A0 r =3D -EINVAL;
>>>   =A0=A0=A0=A0=A0=A0=A0=A0 goto bad;
>>>   =A0=A0=A0=A0 }
>>> +=A0=A0=A0 pmem_assign(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_V=
ERSION_2));
>>>
>>>   =A0=A0=A0=A0 if (le32_to_cpu(s.block_size) !=3D wc->block_size) {
>>>   =A0=A0=A0=A0=A0=A0=A0=A0 ti->error =3D "Block size does not match sup=
erblock";
>>
>> --=20
