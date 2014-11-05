From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Wed, 5 Nov 2014 07:43:55 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
References: <20141028134012.GA25229@redhat.com>
	<20141028141749.GD25229@redhat.com>
	<20141028143742.GE25229@redhat.com>
	<20141028171003.GG25229@redhat.com>
	<20141028224753.GA29288@redhat.com>
	<20141028232638.GB29288@redhat.com>
	<20141029002125.GC29288@redhat.com>
	<20141029012256.GF29288@redhat.com>
	<alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141105011619.GA11411@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, "Bryn M. Reeves" <breeves@redhat.com>, ejt@redhat.com, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Tue, 4 Nov 2014, Mike Snitzer wrote:

> > > Hi
> > >
> > > As I said on irc - it is not correct to take a mutex from one syscall and
> > > drop the mutex from another syscall.
> > 
> > I didn't modify that aspect of dm_internal_suspend+resume.  I only extended
> > the interface to other targets via export.
> > 
> > > I hope Joe can use the bio prison to block bios while the pool is
> > > suspended.
> > 
> > We'll see.
> 
> Joe said today: "bio-prison thing isn't going to work, since we need the
> worker thread to complete as part of the [thin-pool] suspend".

If you block bios coming into the prison in pool's presuspend method 
(similar to this patch 
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.19&id=2d616 
), the worker thread is still active, so it should process bios.

You can for example set the flag in the prison meaning that the prison is 
suspended and then call dm_internal_suspend immediatelly followed by 
dm_internal_resume - that will clear in-progress bios and prevent new bios 
from coming in (and we don't need to change dm_internal_suspend and 
dm_internal_resume to become so big).

> And the following patch fixes the locking issue you raised:

... it complicates the generic code even more than before.

Mikulas
