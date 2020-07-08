From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: dm: use noio when sending kobject event
Date: Wed, 08 Jul 2020 15:37:07 -0400
Message-ID: <87v9ixer30.fsf@collabora.com>
References: <alpine.LRH.2.02.2007081222500.4103@file01.intranet.prod.int.rdu2.redhat.com>
	<873661g8wq.fsf@collabora.com> <20200708173356.GA8116@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200708173356.GA8116@redhat.com> (Mike Snitzer's message of
	"Wed, 8 Jul 2020 13:33:56 -0400")
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Khazhismel Kumykov <khazhy@google.com>
List-Id: dm-devel.ids

Mike Snitzer <snitzer@redhat.com> writes:

> On Wed, Jul 08 2020 at  2:26pm -0400,
> Gabriel Krisman Bertazi <krisman@collabora.com> wrote:
>
>> If I understand it correctly, considering the deadlock you shared, this
>> doesn't solve the entire issue. For instance, kobject_uevent_env on the
>> GFP_NOIO thread waits on uevent_sock_mutex, and another thread with
>> GFP_IO holding the mutex might have triggered the shrinker from inside
>> kobject_uevent_net_broadcast.  I believe 7e7cd796f277 ("scsi: iscsi: Fix
>> deadlock on recovery path during GFP_IO reclaim") solved the one you
>> shared and other similar cases for iSCSI in a different way.
>
> I staged a different fix, from Mikulas, for 5.9 that is meant to address
> the original report, please see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.9&id=e5bfe9baf23dca211f4b794b651e871032c427ec
>
> I'd appreciate it if you could try this commit to se if it fixes the
> original issue you reported.

I reverted 7e7cd796f277 and cherry-picked e5bfe9baf23dc on my tree.
After a few iterations, I could see the conditions that formerly
triggered the deadlock happening, but this patch successfully allowed
the reclaim to succeed and the iscsi recovery thread to run.

My reproducer is a bit artificial, as I wrote it only from only the
problem description provided by google.  They were hitting this in
production and might have a better final word on the fix, though I know
they don't have a simple way to reproduce it.

>> That said, I think this patch is an improvement as we shouldn't be using
>> GFP_IO in this path to begin with, so please add:
>> 
>> Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
>
> FYI, whilee I do appreciate your Reviewed-by I already staged this for
> 5.8 so I'd rather not rebase to add your Reviewed-by, see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.8&id=6958c1c640af8c3f40fa8a2eee3b5b905d95b677

No worries.  Actually, thank you guys for helping with this issue.

-- 
Gabriel Krisman Bertazi
