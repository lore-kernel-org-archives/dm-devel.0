From: Stefan Ring <stefanrin@gmail.com>
Subject: Re: Significantly dropped dm-cache performance in 4.13
	compared to 4.11
Date: Fri, 15 Dec 2017 17:03:28 +0100
Message-ID: <CAAxjCEzF_Kpiw4hPzH8OFWA5SRshrtmLUOzJ2YXo8M8FnQbfhg@mail.gmail.com>
References: <CAAxjCExHqssZ8vuCC19_NP1io=StFAYk48nqDfudhjD-PyLZCg@mail.gmail.com>
	<20171107144157.6yng4owvmmcm33qj@reti>
	<CAAxjCEy5yc7G1iBznLFCwEVWgkijSUD29oZwHsD5b2+zyA94ig@mail.gmail.com>
	<CAAxjCEwaGHCG1qEKfUJrHkhvL9HU9qs362tmy2O-ib3wSY-0bg@mail.gmail.com>
	<20171113190111.GE32510@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171113190111.GE32510@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 13, 2017 at 8:01 PM, Mike Snitzer <snitzer@redhat.com> wrote:
>
> But feel free to remove the cache for now.  Should be as simple as:
> lvconvert --uncache VG/CacheLV

I did a --splitcache yesterday and ran a scrub again, which completed
in 3h. More than the ~2h of the cached version in 4.11, but
significantly less than the ~4.5h of the 4.13 cached variant. The data
on this volume has not changed much since last month, so the scrub
times should be very comparable, give or take a few minutes.
