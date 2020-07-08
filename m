From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: use noio when sending kobject event
Date: Wed, 8 Jul 2020 13:33:56 -0400
Message-ID: <20200708173356.GA8116@redhat.com>
References: <alpine.LRH.2.02.2007081222500.4103@file01.intranet.prod.int.rdu2.redhat.com>
	<873661g8wq.fsf@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <873661g8wq.fsf@collabora.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: Tahsin Erdogan <tahsin@google.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Khazhismel Kumykov <khazhy@google.com>
List-Id: dm-devel.ids

On Wed, Jul 08 2020 at  2:26pm -0400,
Gabriel Krisman Bertazi <krisman@collabora.com> wrote:

> Mikulas Patocka <mpatocka@redhat.com> writes:
> 
> > kobject_uevent may allocate memory and it may be called while there are dm
> > devices suspended. The allocation may recurse into a suspended device,
> > causing a deadlock. We must set the noio flag when sending a uevent.
> 
> If I understand it correctly, considering the deadlock you shared, this
> doesn't solve the entire issue. For instance, kobject_uevent_env on the
> GFP_NOIO thread waits on uevent_sock_mutex, and another thread with
> GFP_IO holding the mutex might have triggered the shrinker from inside
> kobject_uevent_net_broadcast.  I believe 7e7cd796f277 ("scsi: iscsi: Fix
> deadlock on recovery path during GFP_IO reclaim") solved the one you
> shared and other similar cases for iSCSI in a different way.

I staged a different fix, from Mikulas, for 5.9 that is meant to address
the original report, please see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.9&id=e5bfe9baf23dca211f4b794b651e871032c427ec

I'd appreciate it if you could try this commit to se if it fixes the
original issue you reported.

> I know this is similar to the log I shared on an earlier patch. Are you
> able to reproduce the deadlock with the above patch applied?

Mikulas seized on the fact that the backtrace shows the uevent upcall
to have occurred while suspending.  I know he didn't reproduce your
issue.

> That said, I think this patch is an improvement as we shouldn't be using
> GFP_IO in this path to begin with, so please add:
> 
> Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>

FYI, whilee I do appreciate your Reviewed-by I already staged this for
5.8 so I'd rather not rebase to add your Reviewed-by, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.8&id=6958c1c640af8c3f40fa8a2eee3b5b905d95b677

Thanks,
Mike
