From: Milan Broz <mbroz@redhat.com>
Subject: Re: Linux 2.6.36-rc7
Date: Thu, 07 Oct 2010 22:13:00 +0200
Message-ID: <4CAE29CC.8030702@redhat.com>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	<4CAE1F47.3050105@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CAE1F47.3050105@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, just.for.lkml@googlemail.com, hch@infradead.org, herbert@gondor.hengli.com.au, Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On 10/07/2010 09:28 PM, Tejun Heo wrote:

> I'm afraid there is a possibly workqueue related deadlock under high
> memory pressure.  It happens on dm-crypt + md raid1 configuration.
> I'm not yet sure whether this is caused by workqueue failing to kick
> rescuers under memory pressure or the shared workqueue is making an
> already existing problem more visible and in the process of setting up
> an environment to reproduce the problem.
> 
>  http://thread.gmane.org/gmane.comp.file-systems.xfs.general/34922/focus=1044784

Yes, XFS is very good to show up problems in dm-crypt:)

But there was no change in dm-crypt which can itself cause such problem,
planned workqueue changes are not in 2.6.36 yet.
Code is basically the same for the last few releases.

So it seems that workqueue processing really changed here under memory pressure.

Milan

p.s.
Anyway, if you are able to reproduce it and you think that there is problem
in per-device dm-crypt workqueue, there are patches from Andi for shared
per-cpu workqueue, maybe it can help here. (But this is really not RC material.)

Unfortunately not yet in dm-devel tree, but I have them here ready for review:
http://mbroz.fedorapeople.org/dm-crypt/2.6.36-devel/
(all 4 patches must be applied, I hope Alasdair will put them in dm quilt soon.)
