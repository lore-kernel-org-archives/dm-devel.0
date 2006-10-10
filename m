From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC] Reverting "bd_mount_mutex" to "bd_mount_sem"
Date: Tue, 10 Oct 2006 17:19:05 +0200
Message-ID: <1160493546.3000.303.camel@laptopd505.fenrus.org>
References: <451A78DF.1060901@in.ibm.com> <20060927135705.GA30311@elte.hu>
	<4526C184.7070507@sandeen.net>  <452BB67E.7000700@in.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <452BB67E.7000700@in.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-lvm@redhat.com, Ingo Molnar <mingo@elte.hu>, agk@redhat.com
List-Id: dm-devel.ids

On Tue, 2006-10-10 at 20:34 +0530, Srinivasa Ds wrote:
> Eric Sandeen wrote:
> > Ingo Molnar wrote:
> >   
> >> * Srinivasa Ds <srinivasa@in.ibm.com> wrote:
> >>
> >>     
> >>>   On debugging I found out that,"dmsetup suspend <device name>" calls 
> >>> "freeze_bdev()",which locks "bd_mount_mutex" to make sure that no new 
> >>> mounts happen on bdev until thaw_bdev() is called.
> >>>   This "thaw_bdev()" is getting called when we resume the device 
> >>> through "dmsetup resume <device-name>".
> >>>   Hence we have 2 processes,one of which locks 
> >>> "bd_mount_mutex"(dmsetup suspend) and Another(dmsetup resume) unlocks 
> >>> it.
> >>>       
> >> hm, to me this seems quite a fragile construct - even if the 
> >> mutex-debugging warning is worked around by reverting to a semaphore.
> >>
> >> 	Ingo
> >>     
> >
> > Ingo, what do you feel is fragile about this?  It seems like this is a
> > reasonable way to go, except that maybe a down_trylock would be good if
> > a 2nd process tries to freeze while it's already frozen...
> >
> > Thanks,
> >
> > -Eric
> >   
> Ingo, As per the discussion resending the patch with down_trylock.

Hi,

I still think that effectively exporting this semaphore to userspace is
a big design mistake; but at least it can't be a mutex for this reason
so the patch is sane in that regard...

Greetings,
   Arjan van de Ven
