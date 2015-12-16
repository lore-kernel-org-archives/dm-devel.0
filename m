From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] md: fix bug due to nested suspend
Date: Wed, 16 Dec 2015 09:00:51 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512160900160.754@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1511251216100.17579@file01.intranet.prod.int.rdu2.redhat.com>
	<87vb7z9hbm.fsf@notabene.neil.brown.name>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87vb7z9hbm.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@fb.com>, Heinz Mauelshagen <heinzm@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Marian Csontos <mcsontos@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids



On Wed, 16 Dec 2015, NeilBrown wrote:

> On Thu, Nov 26 2015, Mikulas Patocka wrote:
> 
> > The patch c7bfced9a6716ff66c9d61f934bb60af08d4688c committed to 4.4-rc 
> > causes crash in LVM test shell/lvchange-raid.sh. The kernel crashes with 
> > this BUG, the reason is that we attempt to suspend a device that is 
> > already suspended. See also 
> > https://bugzilla.redhat.com/show_bug.cgi?id=1283491
> >
> > This patch fixes the bug by introducing functions mddev_nested_suspend and
> > mddev_nested_resume that can be called when the device is already
> > suspended. The number of calls to mddev_nested_suspend is kept in the
> > variable mddev->suspended.
> 
> Hi,
>  thanks for the report and patch.
> 
> I think I would rather just make mddev_suspend() always nest.
> It is always called under ->reconfig_mutex or some similar guarentee of
> being single-threaded in dm-raid, so we don't need an atomic_t.
> 
> Just
>   mddev_suspend()
> 	if (mddev->suspended++)
>         	return;
>         ...do the suspend.
> 
> and
>   mddev_resume()
>        if (--mddev->suspended)
>        		return;
>        ... to the resume
> 
> Does that seem reasonable to you?

Yes, it seems OK.

Mikulas
