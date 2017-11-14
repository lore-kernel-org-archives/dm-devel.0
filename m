From: Stefan Ring <stefanrin@gmail.com>
Subject: Re: Significantly dropped dm-cache performance in 4.13
	compared to 4.11
Date: Tue, 14 Nov 2017 15:53:40 +0100
Message-ID: <CAAxjCExB=PaDrAxqdi-=pRRraPZyq7Wu5WX==hGv7or=ZDx7Jg@mail.gmail.com>
References: <CAAxjCExHqssZ8vuCC19_NP1io=StFAYk48nqDfudhjD-PyLZCg@mail.gmail.com>
	<20171107144157.6yng4owvmmcm33qj@reti>
	<CAAxjCEy5yc7G1iBznLFCwEVWgkijSUD29oZwHsD5b2+zyA94ig@mail.gmail.com>
	<CAAxjCEwaGHCG1qEKfUJrHkhvL9HU9qs362tmy2O-ib3wSY-0bg@mail.gmail.com>
	<20171113190111.GE32510@redhat.com>
	<20171114110046.6lmv34rqngs6pjwf@reti>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171114110046.6lmv34rqngs6pjwf@reti>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Tue, Nov 14, 2017 at 12:00 PM, Joe Thornber <thornber@redhat.com> wrote:
>
> I'm not sure what's going on here.  Would you mind sending me the
> metadata please?  Either a cache_dump of it, or a copy of the metadata
> dev?

I'd like to create a cache dump, but I'm not very experienced with
this stuff. I do:

$ cache_dump /dev/vg_zfs/lv_zfsdisk |less
syscall 'open' failed: Device or resource busy
Note: you cannot run this tool with these options on live metadata.

Which is what I feared/expected. However, after doing

$ lvchange -an vg_zfs/lv_zfsdisk

the device disappears, and I cannot run cache_dump on it as well. So
how do I make it not live, while still visible?
