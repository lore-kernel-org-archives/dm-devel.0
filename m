From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/2] dm-ioband: I/O bandwidth controller
	v1.10.0: Source code and patch
Date: Tue, 20 Jan 2009 14:52:08 +0000
Message-ID: <20090120145208.GE9859@agk.fab.redhat.com>
References: <20090120.141022.193708059.ryov@valinux.co.jp>
	<20090120.141114.226778416.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090120.141114.226778416.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jan 20, 2009 at 02:11:14PM +0900, Ryo Tsuruta wrote:
> This patch is the dm-ioband version 1.10.0 release.
 
drivers/md/dm-ioband-ctl.c:194:2: warning: context problem in 'suspend_ioband_device': '_spin_unlock_irqrestore' expected different c
ontext
drivers/md/dm-ioband-ctl.c:194:2:    context 'lock': wanted >= 1, got 0
drivers/md/dm-ioband-ctl.c:608:3: warning: context problem in 'prevent_burst_bios': '_spin_unlock_irq' expected different context
drivers/md/dm-ioband-ctl.c:608:3:    context 'lock': wanted >= 1, got 0


Last time we had something like that, it was straightforward to restructure the
functions to avoid it - see if you can manage that here too.

Alasdair
