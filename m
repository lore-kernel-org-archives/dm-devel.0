From: Teng-Feng Yang <shinrairis@gmail.com>
Subject: Re: Possible bug when releasing metadata snapshot in
	dm-thin
Date: Fri, 28 Nov 2014 15:29:11 +0800
Message-ID: <CAKTMprOza2Ohx2MqhgNfeXRMYH2+Q1Yj+pC7BB6jDw=1wX8Gww@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> On Wed, Nov 19, 2014 at 05:21:52PM +0800, Teng-Feng Yang wrote:
>> Hi all,
>>
>> I accidentally run into this weird situation which looks like a bug to me.
>> This bug can be reproduced every time with the following steps.
>>
>> 1) Create a thin pool and a thin volume.
>> 2) Write some data to this thin volume.
>> 3) Reserve metadata snapshot by sending "reserve_metadata_snap" to pool.
>> 4) Create a snapshot for the thin volume.
>> 5) Release metadata snapshot by sending "release_metadata_snap" to pool
>> 6) Remove both the snapshot and thin volume.
>>
>> After these steps, pool blocks allocated to the thin volume are never
>> returned to the pool. I trace the code of releasing metadata snapshot,
>> and I might find the root cause of this. When reserving metadata
>> snapshot, we will increase the reference count of data mapping root by
>> 1. However, the subsequent changes to the data mapping tree will split
>> the data mapping tree which results in increasing reference counts of
>> all bottom level roots. When releasing metadata snapshot, we simply
>> decrease the reference count of the old data mapping root without
>> propagating these reference count decrements all the way down. IMHO,
>> maybe we should call dm_btree_del() on the old data mapping root
>> instead of dm_sm_dec_refcount().
>
> Yep, that sounds likely.  I'll confirm and post a patch later.
>
> Thanks,
>
> - Joe

Hi Joe,

I think I have found something I would like to share when I try to fix
this issue
by using dm_btree_del() instead of dm_sm_dec_refcount() in releasing metadata
snapshot on my own. However, this leads to pool metadata corruption which
catches me off guard. After we increased the reference count of data
mapping root,
there are two cases which will split the top level tree of the data
mapping btree.

The first case is to take a snapshot of any thin volume, dm-thin will
insert a new
entry to the top level tree. This increases the reference count of the
bottom level
subtree since "tl_info" has implemented its own "inc" function. The other case
which split the top level tree is to insert a new data mapping for any
thin volume.
Since data mapping tree is a two level btree, insert() in dm-btree.c
uses le64_type
as value type to traverse all the levels except the bottom one, it
won't correctly
increase the reference count of the bottom level subtree even if we shadow and
split the ancestor node of the bottom level root node. In this case, if we use
dm_btree_del() to release the metadata snapshot, it will simply delete
the bottom
level btrees which are still shared with the origin metadata.

To fix this, I think maybe we should define as many btree_info
descriptors as the
 level count to make this right. However, I cannot be sure if this
modification will
have any side effect which accidentally mess something up.

Hope this helps.

Dennis
