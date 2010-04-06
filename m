From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/7] some shared snapshot readability
	improvements
Date: Tue, 6 Apr 2010 08:15:33 -1000
Message-ID: <w2h170fa0d21004061115y4960bca9x7778e6da04df8252@mail.gmail.com>
References: <1270185478-8870-1-git-send-email-snitzer@redhat.com>
	<Pine.LNX.4.64.1004060221080.23668@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1004060221080.23668@hs20-bc2-1.build.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

Using 's' for something other than snapshot is confusing.  'ps' is
better than 'p' as it builds on other snapshot code that established
the use of 'ps' for a persistent store.  And using 'dm' for
dm_multisnap is just awkward.

Figured it best to make all variables consistent across the codebase.
If there were accessor functions these renames wouldn't be so
wide-spread but I can easily see why accessors weren't ever
introduced.

I believe the new names and consistency to be better.  If you think
it's a problem to make these edits then feel free to ignore them.

Mike

On Mon, Apr 5, 2010 at 8:26 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> Hi
>
> Is it needed to just rename variables?
>
> It doesn't add readability, the new variable names are no more readable
> than the old ones --- chaning "s" and "p" to "ps" and "dm" to "s" doesn't
> seem to make anything but confusion.
>
> Mikulas
>
> On Fri, 2 Apr 2010, Mike Snitzer wrote:
>
>> Quite a lot of churn but I think it is for the better in the end.
>>
>> (I developed these changes on Wednesday but just got around to getting
>> them sent out now)
>>
>> Mike Snitzer (7):
>> =A0 document low hanging fruit to help improve code readability
>> =A0 Improve name used for "persistent store" in 'struct dm_multisnap'
>> =A0 Avoid exception store being confused with snapshot 's'
>> =A0 Avoid struct members with the name 'dm'
>> =A0 rename snapid members to use 'snapid' names
>> =A0 move individual dm_multisnap 'flags' values
>> =A0 Removed remaining 'struct dm_exception_store' FIXMEs.
>>
>> =A0drivers/md/dm-multisnap-alloc.c =A0 =A0 =A0 =A0 =A0| =A0271 +++++++++=
---------
>> =A0drivers/md/dm-multisnap-blocks.c =A0 =A0 =A0 =A0 | =A0118 ++++----
>> =A0drivers/md/dm-multisnap-btree.c =A0 =A0 =A0 =A0 =A0| =A0330 +++++++++=
++-----------
>> =A0drivers/md/dm-multisnap-commit.c =A0 =A0 =A0 =A0 | =A0140 +++++-----
>> =A0drivers/md/dm-multisnap-daniel.c =A0 =A0 =A0 =A0 | =A0 32 +-
>> =A0drivers/md/dm-multisnap-delete.c =A0 =A0 =A0 =A0 | =A0 70 +++---
>> =A0drivers/md/dm-multisnap-freelist.c =A0 =A0 =A0 | =A0 96 ++++----
>> =A0drivers/md/dm-multisnap-io.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0148 +++++--=
---
>> =A0drivers/md/dm-multisnap-mikulas-struct.h | =A0 =A08 +-
>> =A0drivers/md/dm-multisnap-mikulas.c =A0 =A0 =A0 =A0| =A0441 +++++++++++=
++++---------------
>> =A0drivers/md/dm-multisnap-mikulas.h =A0 =A0 =A0 =A0| =A0110 ++++----
>> =A0drivers/md/dm-multisnap-private.h =A0 =A0 =A0 =A0| =A0 =A08 +-
>> =A0drivers/md/dm-multisnap-snaps.c =A0 =A0 =A0 =A0 =A0| =A0234 ++++++++-=
-------
>> =A0drivers/md/dm-multisnap.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 72 +++=
---
>> =A0drivers/md/dm-multisnap.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 38 ++--
>> =A015 files changed, 1060 insertions(+), 1056 deletions(-)
>>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
