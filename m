From: Eric Ren <zren@suse.com>
Subject: Re: [PATCH] dm mirror: fix crash caused by NULL-pointer
 dereference
Date: Mon, 26 Jun 2017 18:55:00 +0800
Message-ID: <3291473d-1eec-89a7-c3a1-d49c82df500c@suse.com>
References: <20170626090848.21585-1-zren@suse.com>
	<7ba503ae-ab87-493a-264c-3b42f8418c34@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7ba503ae-ab87-493a-264c-3b42f8418c34@redhat.com>
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
Cc: jtang@suse.com, agk@redhat.com, neilb@suse.com, snitzer@redhat.com
List-Id: dm-devel.ids

Hi Zdenek,


On 06/26/2017 05:46 PM, Zdenek Kabelac wrote:
> Dne 26.6.2017 v 11:08 Eric Ren napsal(a):
>>
> [... snip...]
>
> Hi
>
> Which kernel version is this ?
>
> I'd thought we've already fixed this BZ for old mirrors:
> https://bugzilla.redhat.com/show_bug.cgi?id=1382382
>
> There similar BZ for md-raid based mirrors (--type raid1)
> https://bugzilla.redhat.com/show_bug.cgi?id=1416099
My base kernel version is 4.4.68, but with this 2 latest fixes applied:

"""
Revert "dm mirror: use all available legs on multiple failures"
dm io: fix duplicate bio completion due to missing ref count
"""

Yes, I've been working on dm-mirror crash issue for couple days,
but only see this fixes above when I rebased to send my fixes out, hah.

But, with this 2 fixes, the producer can still crash the kernel. Anyway, 
I can
test with upstream kernel again ;-P

Regards,
Eric

>
>
> Regards
>
> Zdenej
>
