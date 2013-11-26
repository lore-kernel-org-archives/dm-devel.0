From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Revert "raid5: make release_stripe lockless" because it
 causes test regression
Date: Tue, 26 Nov 2013 11:10:03 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1311261109390.2705@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1311221502360.28281@file01.intranet.prod.int.rdu2.redhat.com> <20131125110528.046b861e@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131125110528.046b861e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, Zdenek Kabelac <zkabelac@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids



On Mon, 25 Nov 2013, NeilBrown wrote:

> On Fri, 22 Nov 2013 15:07:08 -0500 (EST) Mikulas Patocka
> <mpatocka@redhat.com> wrote:
> 
> > Revert 773ca82fa1ee58dd1bf88b6a5ca385ec83a2cac6 and
> > d265d9dc1d25a69affc21ae9fe5004b9d09c10ef.
> > 
> > The lvm testsuite (from 
> > ftp://sources.redhat.com/pub/lvm2/LVM2.2.02.104.tgz) fails with unkillable 
> > lvm and dmsetup processes on kernel 3.12. The testsuite passes on 3.11. 
> > Bisect shows that the failure is caused by patch 
> > 773ca82fa1ee58dd1bf88b6a5ca385ec83a2cac6. When I revert this patch on 3.12 
> > kernel, the testsuite finishes and there are no unkillable processes.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@kernel.org	# 3.12
> 
> I certainly don't plan to revert these patches unless we fail to understand
> and fix the problem.
> 
> Does commit ad4068de49862b083ac2a15bc50689bb30ce3e44 fix the problem?
> 
> Thanks,
> NeilBrown

Yes. This patch, applied to 3.12, fixes it.

Mikulas
