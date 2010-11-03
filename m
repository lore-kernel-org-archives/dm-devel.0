From: Andi Kleen <andi@firstfloor.org>
Subject: Re: cmwq and dm-crypt devices?
Date: Wed, 3 Nov 2010 12:51:44 +0100
Message-ID: <20101103115144.GA18935@basil.fritz.box>
References: <1271958538-11193-1-git-send-email-san@google.com>
	<4BD08F78.4000701@redhat.com>
	<q2q236ccac1004221108y276b7e27x2a30e8a1eef77b03@mail.gmail.com>
	<4BD099DB.2020108@redhat.com>
	<s2p236ccac1004221242z4b0a8f68pbf7887e741a56af1@mail.gmail.com>
	<x2h236ccac1004271358o90a80b6bi1b4099865abc81e8@mail.gmail.com>
	<20101102220207.GD23680@redhat.com> <4CD12F6E.8040501@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4CD12F6E.8040501@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: Christophe Saout <christophe@saout.de>, Mike Snitzer <snitzer@redhat.com>, Brian Swetland <swetland@google.com>, San Mehat <san@google.com>, device-mapper development <dm-devel@redhat.com>, andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

> 
> > 2) scale up the number of workqueue threads used for a single dm-crypt
> >    device so that a device can realize per-cpu concurrency (to address
> >    Andi's scalability concerns: https://patchwork.kernel.org/patch/244031/)

They are already addressed in my patchkit and the patches seem to be used
by more and more users. It's just you guys who are behind.

> > 
> >    [the desired locality is currently missing due to dm-crypt's current
> >     use of WQ_UNBOUND; so it is clear the way the workqueues are created
> >     will be important]
> 
> I don't know enough about dm-crypt workload to tell whether per-cpu
> affinity would be better or not, but it's really a simple matter of

CPU affinity and an own thread makes sense for the crypto helper
because it uses up a lot of CPU time.

For the IO helper you probably still want CPU affinity, but it 
can be concurrency managed.

-andi
