From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: ANNOUNCE: consolidated patches for shared snapshots
Date: Mon, 8 Dec 2008 15:19:28 +0900
Message-ID: <20081208151957Z.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.0812072212380.19378@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0812072212380.19378@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: agk@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

On Sun, 7 Dec 2008 22:41:19 -0500 (EST)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> I released new patches for shared snapshots. The functionality is the same 
> as in previous releases, but the two snapshot exception stores, one 
> created by Fujita Tomonori and one by me, are consolidated and common code 
> is shared.
> 
> The patches are at:
> http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/

Thanks,

As I said before, I have no preference about how to integrate new
snapshot implementations into the existing code. I'm happy to follow
the maintainer, Alasdair?


> The patches don't alter existing snapshot implementation, they contain 
> just new files (they alter only Kconfig and Makefile to make the new files 
> compilable).
> 
> The new architecture is as follows:
> 
> The module dm-multisnapshot.ko contains common code for both exception 
> stores. It has basically processing and queuing IOs and attaching 
> snapshots and interfacing with device mapper.

I've not closely looked at your dm-multisnapshot but after a quick
look, I'm not sure about the number of exception I/Os (except for
metadata I/Os) with an origin write.

For example, I create five snapshots and remove the 1 and 3 snapshots
(*1). Now I have 0, 2, 4 snapshots. Then when I update the origin, how
many exception I/Os dm-multisnapshot needs to perform?


(*1) I know dm-multisnapshot doesn't support deleting a snapshot for
now, but I expect that it will support it in the future.
