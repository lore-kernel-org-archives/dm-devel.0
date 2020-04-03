From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/4] dm-zoned: V2 metadata handling
Date: Fri, 3 Apr 2020 05:47:09 +0000
Message-ID: <CO2PR04MB2343FC2FBA8E204A289BBFC4E7C70@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200327071459.67796-1-hare@suse.de>
	<20200327071459.67796-4-hare@suse.de>
	<93a26ed9-6f6e-2a4d-38d3-3fb76fa91e70@oracle.com>
	<CAMeeMh82FSZm4+i2+1f89P542=3HZR6S8--yP88ZiEjYSxUveA@mail.gmail.com>
	<bbebc0d7-2d53-8412-81c2-d36842fc25e9@suse.de>
	<CAMeeMh9JBuOuOi2s0VB6K1KXExUv-kyP2OavRXE==tHJAXbMFg@mail.gmail.com>
	<CAMeeMh8+6ssUyYqiDQL2kWpwPwjPZRQJbLa7bDUL2tYqeUKjOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: John Dorminy <jdorminy@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: Bob Liu <bob.liu@oracle.com>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2020/04/03 5:01, John Dorminy wrote:
> Actually, I take that back. If it is a worry that the internal representation
> will change, it seems also unsafe to be casting the sixteen bytes as a uuid_t
> when copying into them with uuid_copy(). If the internal representation changed
> to add a new field, then there would be a buffer overrun when using uuid_copy().
> If the internal representation changed the order of the bytes, uuid_copy() would
> propagate that to the on-disk structure and yield compatibility issues.
> 
> Perhaps it would be safer to store the UUIDs on disk as a string. Or add to
> uuid.[ch] a function to get the raw bytes in a fixed order suitable for storing
> on disk?

Please have a look at file systems on-disk metadata definition and checks. There
are plenty of examples of how UUIDs are handled. For instance, XFS has in
fs/xfs/libxfs/xfs_format.h:

typedef struct xfs_dsb {
	...
	uuid_t          sb_uuid;        /* user-visible file system unique id */
	...
}

For the on-disk super block UUID and the same for the in-memory version.
And you can see code like:
memcpy(&to->sb_uuid, &from->sb_uuid, sizeof(to->sb_uuid));
uuid_copy(&to->sb_meta_uuid, &from->sb_uuid);

and checks such as:

BUILD_BUG_ON(sizeof(geo->uuid) != sizeof(sbp->sb_uuid));

for some UUID declared with:

unsigned char   uuid[16];       /* unique id of the filesystem  */
(struct xfs_fsop_geom_v1 in fs/xfs/libxfs/xfs_fs.h.

On the other hand, f2fs defines its on-disk and in-memory super block UUID as:

__u8 uuid[16];                  /* 128-bit uuid for volume */

And copies it with:

memcpy(&sb->s_uuid, raw_super->uuid, sizeof(raw_super->uuid));

The general pattern is:
* For UUIDs defined as uuid_t, use uuid_copy() or memcpy()
* For UUIDs defined as an array of bytes or char, use memcpy()
* Add BUILD_BUG_ON() checks when mixing both definitions.

There is no need to go as far as using a string for the UUID.

-- 
Damien Le Moal
Western Digital Research
