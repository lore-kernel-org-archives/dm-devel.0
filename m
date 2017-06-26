From: Eric Ren <zren@suse.com>
Subject: Re: [PATCH] dm mirror: fix crash caused by NULL-pointer
 dereference
Date: Mon, 26 Jun 2017 21:47:43 +0800
Message-ID: <a2d51150-c820-57b8-f1d1-c39c7576929b@suse.com>
References: <20170626090848.21585-1-zren@suse.com>
	<7ba503ae-ab87-493a-264c-3b42f8418c34@redhat.com>
	<3291473d-1eec-89a7-c3a1-d49c82df500c@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3291473d-1eec-89a7-c3a1-d49c82df500c@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@redhat.com
Cc: jtang@suse.com, snitzer@redhat.com, neilb@suse.com, agk@redhat.com
List-Id: dm-devel.ids

Hi,

On 06/26/2017 06:55 PM, Eric Ren wrote:
> Hi Zdenek,
>
>
> On 06/26/2017 05:46 PM, Zdenek Kabelac wrote:
>> Dne 26.6.2017 v 11:08 Eric Ren napsal(a):
>>>
>> [... snip...]
>>
>> Hi
>>
>> Which kernel version is this ?
>>
>> I'd thought we've already fixed this BZ for old mirrors:
>> https://bugzilla.redhat.com/show_bug.cgi?id=1382382
>>
>> There similar BZ for md-raid based mirrors (--type raid1)
>> https://bugzilla.redhat.com/show_bug.cgi?id=1416099
> My base kernel version is 4.4.68, but with this 2 latest fixes applied:
>
> """
> Revert "dm mirror: use all available legs on multiple failures"
> dm io: fix duplicate bio completion due to missing ref count

I have a confusion about this "dm io..." fix. The fix itself is good.

Without it, a mkfs.ext4 on a mirrored dev whose primary mirror dev
has failed, will crash the kernel with the discard operation from mkfs.ext4.
However, mkfs.ext4 can succeed on a healthy mirrored device. This
is the thing I don't understand, because no matter the mirrored device is
good or not, there's always a duplicate bio completion before having this
this fix, thus write_callback() will be called twice, crashing will 
occur on the
second write_callback():
"""
static void write_callback(unsigned long error, void *context)
{
         unsigned i;
         struct bio *bio = (struct bio *) context;
         struct mirror_set *ms;
         int should_wake = 0;
         unsigned long flags;

         ms = bio_get_m(bio)->ms;        ====> NULL pointer at the 
duplicate completion
         bio_set_m(bio, NULL);
"""

If no this fix, I expected the DISCARD IO would always crash the kernel, 
but it's not true when
the mirrored device is good. Hope someone happen to know the reason can 
give some hints ;-P

Regards,
Eric

> """
>
> Yes, I've been working on dm-mirror crash issue for couple days,
> but only see this fixes above when I rebased to send my fixes out, hah.
>
> But, with this 2 fixes, the producer can still crash the kernel. 
> Anyway, I can
> test with upstream kernel again ;-P
>
> Regards,
> Eric
>
>>
>>
>> Regards
>>
>> Zdenej
>>
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
