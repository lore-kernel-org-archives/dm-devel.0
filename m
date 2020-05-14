From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] dm-zoned: split off random and cache
	zones
Date: Thu, 14 May 2020 08:52:45 +0200
Message-ID: <c38ce648-7ecb-0d7b-ba0e-f35049d5afa4@suse.de>
References: <20200513070729.71461-1-hare@suse.de>
	<20200513070729.71461-3-hare@suse.de>
	<BY5PR04MB6900F36D4228D0FD0216AD61E7BF0@BY5PR04MB6900.namprd04.prod.outlook.com>
	<a95309e9-c0d1-cd9e-4e93-c7fb52667b2d@suse.de>
	<BY5PR04MB6900C924F85EE6007ACFE4C2E7BC0@BY5PR04MB6900.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------629AB1B04195D5DCCCFEE21D"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BY5PR04MB6900C924F85EE6007ACFE4C2E7BC0@BY5PR04MB6900.namprd04.prod.outlook.com>
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
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------629AB1B04195D5DCCCFEE21D
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/14/20 8:45 AM, Damien Le Moal wrote:
> On 2020/05/14 15:41, Hannes Reinecke wrote:
>> On 5/13/20 2:44 PM, Damien Le Moal wrote:
>>> On 2020/05/13 16:07, Hannes Reinecke wrote:
>>>> Instead of emulating zones on the regular disk as random zones
>>>> this patch adds a new 'cache' zone type.
>>>> This allows us to use the random zones on the zoned disk as
>>>> data zones (if cache zones are present), and improves performance
>>>> as the zones on the (slower) zoned disk are then never used
>>>> for caching.
>>>>
>>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>>> ---
>> [ .. ]
>>>> @@ -1830,17 +1861,19 @@ static void dmz_wait_for_reclaim(struct dmz_me=
tadata *zmd, struct dm_zone *zone)
>>>>    }
>>>>   =20
>>>>    /*
>>>> - * Select a random write zone for reclaim.
>>>> + * Select a cache or random write zone for reclaim.
>>>>     */
>>>>    static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_meta=
data *zmd)
>>>>    {
>>>>    =09struct dm_zone *dzone =3D NULL;
>>>>    =09struct dm_zone *zone;
>>>> +=09struct list_head *zone_list =3D &zmd->map_rnd_list;
>>>>   =20
>>>> -=09if (list_empty(&zmd->map_rnd_list))
>>>> -=09=09return ERR_PTR(-EBUSY);
>>>> +=09/* If we have cache zones select from the cache zone list */
>>>> +=09if (zmd->nr_cache)
>>>> +=09=09zone_list =3D &zmd->map_cache_list;
>>>>   =20
>>>> -=09list_for_each_entry(zone, &zmd->map_rnd_list, link) {
>>>> +=09list_for_each_entry(zone, zone_list, link) {
>>>>    =09=09if (dmz_is_buf(zone))
>>>>    =09=09=09dzone =3D zone->bzone;
>>>>    =09=09else
>>>> @@ -1853,15 +1886,21 @@ static struct dm_zone *dmz_get_rnd_zone_for_re=
claim(struct dmz_metadata *zmd)
>>>>    }
>>>>   =20
>>>>    /*
>>>> - * Select a buffered sequential zone for reclaim.
>>>> + * Select a buffered random write or sequential zone for reclaim.
>>>
>>> Random write zoned should never be "buffered", or to be very precise, t=
hey will
>>> be only during the time reclaim moves a cache zone data to a random zon=
e. That
>>> is visible in the dmz_handle_write() change that execute
>>> dmz_handle_direct_write() for cache or buffered zones instead of using
>>> dmz_handle_buffered_write(). So I think this comment can stay as is.
>>>
>>>>     */
>>>>    static struct dm_zone *dmz_get_seq_zone_for_reclaim(struct dmz_meta=
data *zmd)
>>>>    {
>>>>    =09struct dm_zone *zone;
>>>>   =20
>>>> -=09if (list_empty(&zmd->map_seq_list))
>>>> -=09=09return ERR_PTR(-EBUSY);
>>>> -
>>>> +=09if (zmd->nr_cache) {
>>>> +=09=09/* If we have cache zones start with random zones */
>>>> +=09=09list_for_each_entry(zone, &zmd->map_rnd_list, link) {
>>>> +=09=09=09if (!zone->bzone)
>>>> +=09=09=09=09continue;
>>>> +=09=09=09if (dmz_lock_zone_reclaim(zone))
>>>> +=09=09=09=09return zone;
>>>> +=09=09}
>>>> +=09}
>>>
>>> For the reason stated above, I think this change is not necessary eithe=
r.
>>>
>> Ah. Indeed. The above hunk makes us reclaim the random zones, too, which
>> strictly speaking isn't necessary.
>> I'll be dropping it and see how things behave.
>>
>>>>    =09list_for_each_entry(zone, &zmd->map_seq_list, link) {
>>>>    =09=09if (!zone->bzone)
>>>>    =09=09=09continue;
>>>> @@ -1911,6 +1950,7 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz=
_metadata *zmd, unsigned int chu
>>>>    =09unsigned int dzone_id;
>>>>    =09struct dm_zone *dzone =3D NULL;
>>>>    =09int ret =3D 0;
>>>> +=09int alloc_flags =3D zmd->nr_cache ? DMZ_ALLOC_CACHE : DMZ_ALLOC_RN=
D;
>>>>   =20
>>>>    =09dmz_lock_map(zmd);
>>>>    again:
>>>> @@ -1925,7 +1965,7 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz=
_metadata *zmd, unsigned int chu
>>>>    =09=09=09goto out;
>>>>   =20
>>>>    =09=09/* Allocate a random zone */
>>>> -=09=09dzone =3D dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
>>>> +=09=09dzone =3D dmz_alloc_zone(zmd, alloc_flags);
>>>>    =09=09if (!dzone) {
>>>>    =09=09=09if (dmz_dev_is_dying(zmd)) {
>>>>    =09=09=09=09dzone =3D ERR_PTR(-EIO);
>>>> @@ -2018,6 +2058,7 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_=
metadata *zmd,
>>>>    =09=09=09=09     struct dm_zone *dzone)
>>>>    {
>>>>    =09struct dm_zone *bzone;
>>>> +=09int alloc_flags =3D zmd->nr_cache ? DMZ_ALLOC_CACHE : DMZ_ALLOC_RN=
D;
>>>>   =20
>>>>    =09dmz_lock_map(zmd);
>>>>    again:
>>>> @@ -2026,7 +2067,7 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_=
metadata *zmd,
>>>>    =09=09goto out;
>>>>   =20
>>>>    =09/* Allocate a random zone */
>>>> -=09bzone =3D dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
>>>> +=09bzone =3D dmz_alloc_zone(zmd, alloc_flags);
>>>>    =09if (!bzone) {
>>>>    =09=09if (dmz_dev_is_dying(zmd)) {
>>>>    =09=09=09bzone =3D ERR_PTR(-EIO);
>>>> @@ -2043,7 +2084,10 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz=
_metadata *zmd,
>>>>    =09bzone->chunk =3D dzone->chunk;
>>>>    =09bzone->bzone =3D dzone;
>>>>    =09dzone->bzone =3D bzone;
>>>> -=09list_add_tail(&bzone->link, &zmd->map_rnd_list);
>>>> +=09if (alloc_flags =3D=3D DMZ_ALLOC_CACHE)
>>>> +=09=09list_add_tail(&bzone->link, &zmd->map_cache_list);
>>>> +=09else
>>>> +=09=09list_add_tail(&bzone->link, &zmd->map_rnd_list);
>>>>    out:
>>>>    =09dmz_unlock_map(zmd);
>>>>   =20
>>>> @@ -2059,31 +2103,53 @@ struct dm_zone *dmz_alloc_zone(struct dmz_meta=
data *zmd, unsigned long flags)
>>>>    =09struct list_head *list;
>>>>    =09struct dm_zone *zone;
>>>>   =20
>>>> -=09if (flags & DMZ_ALLOC_RND)
>>>> +=09switch (flags) {
>>>> +=09case DMZ_ALLOC_CACHE:
>>>> +=09=09list =3D &zmd->unmap_cache_list;
>>>> +=09=09break;
>>>> +=09case DMZ_ALLOC_RND:
>>>>    =09=09list =3D &zmd->unmap_rnd_list;
>>>> -=09else
>>>> -=09=09list =3D &zmd->unmap_seq_list;
>>>> +=09=09break;
>>>> +=09default:
>>>> +=09=09if (zmd->nr_cache)> +=09=09=09list =3D &zmd->unmap_rnd_list;
>>>> +=09=09else
>>>> +=09=09=09list =3D &zmd->unmap_seq_list;
>>>> +=09=09break;
>>>> +=09}
>>>>    again:
>>>>    =09if (list_empty(list)) {
>>>>    =09=09/*
>>>> -=09=09 * No free zone: if this is for reclaim, allow using the
>>>> -=09=09 * reserved sequential zones.
>>>> +=09=09 * No free zone: return NULL if this is for not reclaim.
>>>
>>> s/for not reclaim/not for reclaim
>>>
>> [ .. ]
>>>
>>> Apart from the nits above, all look good. I am running this right now a=
nd it is
>>> running at SMR drive speed ! Awesome ! Will send a plot once the run is=
 over.
>>>
>> Thanks. I'll be respinning the patch and wil be reposting it.
>=20
> Can you check the reclaim trigger too ? It seems to be starting way too e=
arly,
> well before half of the SSD is used... Was about to rerun some tests and =
debug
> that but since you need to respin the patch...
>=20
Weeelll ... _actually_ I was thinking of going in the other direction;=20
for me reclaim starts too late, resulting in quite a drop in performance...

But that may well be artificial to my setup; guess why the plot is named=20
'dm-zoned-nvdimm' :-)

However, reclaim should be improved. But again, I'd prefer to delegate=20
it to another patchset as this looks like becoming a more complex issue.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6r=
ffer

--------------629AB1B04195D5DCCCFEE21D
Content-Type: image/png;
 name="dm-zoned-nvdimm.png"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dm-zoned-nvdimm.png"

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
--------------629AB1B04195D5DCCCFEE21D
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------629AB1B04195D5DCCCFEE21D--
