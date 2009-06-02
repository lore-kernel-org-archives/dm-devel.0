From: David Strand <dpstrand@gmail.com>
Subject: blk_abort_queue on failed paths?
Date: Tue, 2 Jun 2009 15:55:00 -0700
Message-ID: <448b15030906021555j4e476193kcf69e019992dc592@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

After updating to kernel 2.6.28 I found that when I performed some
cable break testing during device i/o, I would get unwanted device or
host resets. Ultimately I traced it back to this patch:

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=224cb3e981f1b2f9f93dbd49eaef505d17d894c2

The call to blk_abort_queue causes the block layer to call
scsi_times_out for pending i/o, which can (or will) ultimately lead to
device, and/or bus and/or host resets, which of course cause all the
other devices significant disruption.

What was the reason for this change? I searched through my email from
this mailing list and could not find a discussion about it.
