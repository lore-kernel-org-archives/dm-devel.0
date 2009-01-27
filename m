From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-snapshot
Date: Tue, 27 Jan 2009 16:01:33 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0901271601180.3884@hs20-bc2-1.build.redhat.com>
References: <497ECFDA.8000109@onet.eu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <497ECFDA.8000109@onet.eu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sdrb <sdrb@onet.eu>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Upgrade to 2.6.28.* It is already fixed there.

Mikulas

On Tue, 27 Jan 2009, sdrb wrote:

> Hello,
> 
> I've been using snapshots functionality from DM for some time and sometimes I
> encounter following calltrace:
> 
> -------------
> Pid: 26230, comm: kcopyd Not tainted (2.6.27.6 #36)
> EIP: 0060:[<c044d485>] EFLAGS: 00010282 CPU: 1
> EIP is at remove_exception+0x5/0x20
> EAX: ca3b5908 EBX: ca3b5908 ECX: 00200200 EDX: 00100100
> ESI: f7b489f8 EDI: e92ad980 EBP: 00000000 ESP: f29c7ec0
> DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process kcopyd (pid: 26230, ti=f29c6000 task=e8512430 task.ti=f29c6000)
> Stack: c044e03f 0000000d 00000000 c85948c0 00000000 c044f2e7 0009bc30 00000000
>       0000e705 00000000 e8e41288 e92ad980 00000000 c044e0f0 e8e41288 c7800ec8
>       00000000 c0449224 00000000 c7800fb4 00000400 00000000 00000000 f2bdfbb0
> Call Trace:
> [<c044e03f>] pending_complete+0x9f/0x110
> [<c044f2e7>] persistent_commit+0xc7/0x1100x110
> [<c044e0f0>] copy_callback+0x30/0x40
> [<c0449224>] segment_complete+0x154/0x1d0
> [<c0448e55>] run_complete_job+0x45/0x80
> [<c04490d0>] segment_complete+0x0/0x1d0
> [<c0448e10>] run_complete_job+0x0/0x80
> [<c0449014>] process_jobs+0x14/0x70
> [<c0449070>] do_work+0x0/0x40
> [<c0449086>] do_work+0x16/0x40
> [<c013502d>] run_workqueue+0x4d/0xf0
> [<c013514d>] worker_thread+0x7d/0xc0
> [<c01382e0>] autoremove_wake_function+0x0/0x30
> [<c0526583>] __sched_text_start+0x1e3/0x4a0
> [<c01382e0>] autoremove_wake_function+0x0/0x30
> [<c0121a2b>] complete+0x2b/0x40
> [<c01350d0>] worker_thread+0x0/0xc0
> [<c0137db4>] kthread+0x44/0x70
> [<c0137d70>] kthread+0x0/0x70
> [<c0104c57>] kernel_thread_helper+0x7/0x10
> =======================
> Code: 4b 0c e8 cf ff ff ff 8b 56 08 8d 04 c2 8b 10 89 13 89 18 89 5a 04
> 89 43 04 5b 5e c3 8d 76 00 8d bc 27 00 00 00 00 8b 48 04 8b 10 <89> 11
> 89 4a 04 c7 00 00 01 10 00 c7 40 04 00 02 20 00 c3 90 8d
> EIP: [<c044d485>] remove_exception+0x5/0x20 SS:ESP 0068:f29c7ec0
> --------------
> 
> As I see it occurs because kernel tried to access poisoned element list.
> Isn't it because of given element has been deleted from list earlier and
> now kernel is trying to delete it second time? I had similar problems, when
> I deleted (by mistake) element from list which was the "head" of list. In
> other words
> - I had the pointer to the head element of list and I removed this element
> from list, so
> this pointer points to element outside the list. Then I tried to go through
> this list using
> this pointer as a head of list - and then I get similar error. In fact I lost
> contact with this
> list because I didn't change pointer to another element in that list before I
> deleted head element.
> 
> Aren't the both situations (calltrace and mine) similar?
> 
> p.s. It is probably the same problem as in:
> https://www.redhat.com/archives/dm-devel/2008-December/msg00006.html
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
