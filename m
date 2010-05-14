From: Will Drewry <wad@chromium.org>
Subject: Re: [RFC PATCH] dm: allow a dm-fs-style device to be
	shared via dm-ioctl
Date: Fri, 14 May 2010 09:32:48 -0500
Message-ID: <AANLkTimVP_5s8EMvGBadx9JTI0cLjVBDHAlM_8mFcpNg@mail.gmail.com>
References: <20100514013940.GA3523@z600> <20100514035347.GA20636@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100514035347.GA20636@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

Hi Mike,

On Thu, May 13, 2010 at 10:53 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> Hi Will,
>
> On Thu, May 13 2010 at =A09:39pm -0400,
> Will Drewry <wad@chromium.org> wrote:
>
>> Following on the discussion of booting directly to a device-mapper
>> device, two things were made clear:
>> 1. The ioctl interface's name and uuid are mandatory for udev to work
>> 2. There is a functional gap between the dm(-fs) and dm-ioctl
>>
>> This change adds one function which is used for binding a given mapped
>> device to a name+uuid in the dm-ioctl hash table. =A0In addition, it
>> ensures that public functions are available that allow mapped devices
>> and tables to be created and associated with shared code paths in
>> dm-ioctl:
>> - suspend flags and block integrity registration are now exposed
>> - dm_table_complete() now prepares a table for use completely
>> =A0 (builds the btree; sets the type; allocates md pools)
>
> I have done a preliminary review and have some comments inlined below.

Thanks for the review and comments!

>> Ideally, this lays the groundwork for any kernel code to create fully
>> functional mapped devices, but I'd appreciate feedback on if this
>> approach makes sense/is safe, preferred function names, and if it
>> integrates with the current direction.
>>
>> (I can also pair this with the init code patch if it makes sense to show
>> consumer code.)
>
> It would certainly help follow-on reviews as we take a closer look. =A0For
> the next version of your work I'd recommend sharing all related code in
> a series (e.g.: core DM patch 1/2, init patch 2/2).

Will do - just finishing up integrating comments from Alasdair and wanted
to see if the direction for core DM changes would be reasonable.


>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index 9924ea2..66726d1 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -900,7 +900,7 @@ static int setup_indexes(struct dm_table *t)
>> =A0/*
>> =A0 * Builds the btree to index the map.
>> =A0 */
>> -int dm_table_complete(struct dm_table *t)
>> +int dm_table_build_index(struct dm_table *t)
>> =A0{
>> =A0 =A0 =A0 int r =3D 0;
>> =A0 =A0 =A0 unsigned int leaf_nodes;
>> @@ -919,6 +919,48 @@ int dm_table_complete(struct dm_table *t)
>> =A0 =A0 =A0 return r;
>> =A0}
>>
>> +
>> +/*
>> + * Prepares the table for use by building the indices,
>> + * setting the type, and allocating mempools.
>> + */
>> +int dm_table_complete(struct dm_table *t)
>> +{
>> + =A0 =A0 int r =3D 0;
>> +
>> + =A0 =A0 r =3D dm_table_build_index(t);
>> + =A0 =A0 if (r) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 DMWARN("unable to build btrees");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return r;
>> + =A0 =A0 }
>> + =A0 =A0 r =3D dm_table_set_type(t);
>> + =A0 =A0 if (r) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 DMWARN("unable to set table type");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return r;
>> + =A0 =A0 }
>> + =A0 =A0 r =3D dm_table_alloc_md_mempools(t);
>> + =A0 =A0 if (r)
>> + =A0 =A0 =A0 =A0 =A0 =A0 DMWARN("unable to allocate mempools");
>> +
>> + =A0 =A0 return r;
>> +}
>
> Please have dm_table_set_type() come before dm_table_build_index() to
> preserve the existing call sequence. =A0It is better to check the type
> related constraints before going on to build the indices.

Nice catch! I had meant to preserve the order.

>> +
>> +/*
>> + * Register the mapped device for blk_integrity support if
>> + * the underlying devices support it.
>> + */
>> +int dm_table_prealloc_integrity(struct dm_table *t, struct mapped_devic=
e *md)
>> +{
>> + =A0 =A0 struct list_head *devices =3D dm_table_get_devices(t);
>> + =A0 =A0 struct dm_dev_internal *dd;
>> +
>> + =A0 =A0 list_for_each_entry(dd, devices, list)
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (bdev_get_integrity(dd->dm_dev.bdev))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return blk_integrity_register(=
dm_disk(md), NULL);
>> +
>> + =A0 =A0 return 0;
>> +}
>
> I think we need more justification for why you'd want to expose
> dm_table_prealloc_integrity() as a public interface. =A0Makes DM a bit
> more brittle with unknown gain at the moment. =A0Why not just move the
> dm_table_prealloc_integrity() call to dm_table_complete() -- just before
> dm_table_alloc_md_mempools()?

For some reason I special cased it, but I have no idea why. I'll fold it in
to dm_table_complete().

>
>> =A0static DEFINE_MUTEX(_event_lock);
>> =A0void dm_table_event_callback(struct dm_table *t,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0void (*fn)(void *=
), void *context)
>> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper=
.h
>> index 1381cd9..95fea4c 100644
>> --- a/include/linux/device-mapper.h
>> +++ b/include/linux/device-mapper.h
>> @@ -215,6 +215,18 @@ void dm_set_mdptr(struct mapped_device *md, void *p=
tr);
>> =A0void *dm_get_mdptr(struct mapped_device *md);
>>
>> =A0/*
>> + * Export the device via the ioctl interface
>> + */
>> +int dm_ioctl_export(struct mapped_device *md, const char *name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *uuid);
>> +
>> +/*
>> + * Suspend feature flags
>> + */
>> +#define DM_SUSPEND_LOCKFS_FLAG =A0 =A0 =A0 =A0 =A0 =A0 =A0 (1 << 0)
>> +#define DM_SUSPEND_NOFLUSH_FLAG =A0 =A0 =A0 =A0 =A0 =A0 =A0(1 << 1)
>
> You're missing the matching removal of these flags from drivers/md/dm.h

I'll pull that into the next mail as well once I get the init changes in be=
tter
shape.

Thanks again!
will
