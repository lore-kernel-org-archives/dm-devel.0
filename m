From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [2.6.23 PATCH 07/18] dm io: fix panic on large
	request
Date: Tue, 17 Jul 2007 12:39:41 -0400
Message-ID: <469CF0CD.6060006@ce.jp.nec.com>
References: <20070711205846.GY24114@agk.fab.redhat.com>
	<469CC11B.2020103@trash.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <469CC11B.2020103@trash.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Patrick McHardy <kaber@trash.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi,

Patrick McHardy wrote:
> Alasdair G Kergon wrote:
>> From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
>>
>> bio_alloc_bioset() will return NULL if 'num_vecs' is too large.
>> Use bio_get_nr_vecs() to get estimation of maximum number.
>>
>> Signed-off-by: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
>> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
>>
>> ---
>>  drivers/md/dm-io.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletion(-)
> 
> 
> This patch reproducibly oopses my box:

Thanks for the report.
But I'm not sure how the patch is related to the oops.

The stack trace shows the oops occurred in dm-crypt,
which doesn't use the part of the code modified by the patch
(dm-io).

Are you using other dm modules such as dm-multipath, dm-mirror
or dm-snapshot?
If so, can you take the output of 'dmsetup table' and 'dmsetup ls'?

Do you have a reliable way to reproduce the oops which I can try?

> 
> [  126.754204] BUG: unable to handle kernel NULL pointer dereference at
> virtual address 00000000
> [  126.754326]  printing eip:
> [  126.754369] c0141a67
> [  126.754420] *pde = 00000000
> [  126.754465] Oops: 0000 [#1]
> [  126.754507] PREEMPT
> [  126.754585] Modules linked in: [...]
> 
> 
> [  126.758372] CPU:    0
> [  126.758373] EIP:    0060:[<c0141a67>]    Not tainted VLI
> [  126.758374] EFLAGS: 00010282   (2.6.22 #1)
> [  126.758511] EIP is at mempool_free+0xe/0xc0
> [  126.758558] eax: d39e65d0   ebx: 00000000   ecx: df2b9898   edx: 00000000
> [  126.758605] esi: 00000000   edi: d39e65d0   ebp: d487d6d0   esp: df79fec0
> [  126.758652] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
> [  126.758699] Process kcryptd/0 (pid: 3218, ti=df79f000 task=df2b9640
> task.ti=df79f000)
> [  126.758747] Stack: 00000000 00000000 d3835f80 00000000 e08b0923
> e08a5f69 00000200 e0ad1080
> [  126.759093]        dfb5ab40 d3835f80 e08b08c0 00000000 e08a5fb7
> c01804d8 00000000 00000200
> [  126.759439]        c520bc00 00000c00 d0b77438 d5754b00 df79ff5c
> e08a515e d0b77444 d5754b00
> [  126.759858] Call Trace:
> [  126.759965]  [<e08b0923>] clone_endio+0x63/0xc0 [dm_mod]
> [  126.760066]  [<e08a5f69>] crypt_convert+0x131/0x17f [dm_crypt]
> [  126.760168]  [<e08b08c0>] clone_endio+0x0/0xc0 [dm_mod]
> [  126.760264]  [<e08a5fb7>] kcryptd_do_work+0x0/0x30f [dm_crypt]
> [  126.760349]  [<c01804d8>] bio_endio+0x33/0x5d
> [  126.760462]  [<e08a515e>] dec_pending+0x28/0x39 [dm_crypt]
> [  126.760558]  [<e08a61e6>] kcryptd_do_work+0x22f/0x30f [dm_crypt]
> [  126.760669]  [<c0112182>] update_stats_wait_end+0x7f/0xb2
> [  126.760801]  [<e08a5fb7>] kcryptd_do_work+0x0/0x30f [dm_crypt]
> [  126.760888]  [<c012700e>] run_workqueue+0x84/0x179
> [  126.760990]  [<c0127292>] worker_thread+0x0/0xf0
> [  126.761074]  [<c012732f>] worker_thread+0x9d/0xf0
> [  126.761160]  [<c012a360>] autoremove_wake_function+0x0/0x37
> [  126.761256]  [<c0127292>] worker_thread+0x0/0xf0
> [  126.761334]  [<c012a15c>] kthread+0x52/0x58
> [  126.761411]  [<c012a10a>] kthread+0x0/0x58
> [  126.761496]  [<c0104983>] kernel_thread_helper+0x7/0x14
> [  126.761598]  =======================
> [  126.761717] Code: 1c 00 89 f6 eb a9 b8 88 13 00 00 e8 b4 56 1c 00 8d
> 74 26 00 eb d5 31 db e9 11 ff ff ff 57 56 53 83 ec 04 89 c7 89 d6 85 c0
> 74 55 <8b> 02 39 42 04 7d 46 9c 58 90 8d b4 26 00 00 00 00 89 c3 fa 90
> [  126.763964] EIP: [<c0141a67>] mempool_free+0xe/0xc0 SS:ESP 0068:df79fec0
> 

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
