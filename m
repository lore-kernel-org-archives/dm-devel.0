From: Jim Meyering <jim@meyering.net>
Subject: Re: Re: [PATCH 0/3] Fix SMP races in dm-crypt
Date: Wed, 21 Mar 2007 14:32:42 +0100
Message-ID: <87y7lqhgcl.fsf@rho.meyering.net>
References: <200703210806.30499.okir@lst.de>
	<20070321100312.GF27600@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070321100312.GF27600@agk.surrey.redhat.com> (Alasdair
	G. Kergon's message of "Wed, 21 Mar 2007 10:03:12 +0000")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

Alasdair G Kergon <agk@redhat.com> wrote:
> On Wed, Mar 21, 2007 at 08:06:29AM +0100, Olaf Kirch wrote:
>> (I'm resending this, because it seems mailman ate this posting

On a similar note, I sent two patches on Mar 12.
While they did reach the archive, perhaps you haven't seen them?

    https://www.redhat.com/archives/dm-devel/2007-March/msg00010.html
    https://www.redhat.com/archives/dm-devel/2007-March/msg00011.html

2007-03-12  Jim Meyering  <jim@meyering.net>

        * lib/fs/libdevmapper.c (do_suspend): Detect write failure reliably.
        (do_load): Likewise.
        (find_mount_point): Avoid buffer overrun for unusually long inputs.

2007-03-11  Jim Meyering  <meyering@redhat.com>

        * dmsetup/dmsetup.c (_loop_table): Detect close failure.
