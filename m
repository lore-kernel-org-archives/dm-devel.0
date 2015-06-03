From: Abelardo Ricart III <aricart@memnix.com>
Subject: Re: Regression: Disk corruption with dm-crypt and
	kernels >= 4.0
Date: Tue, 02 Jun 2015 22:21:10 -0400
Message-ID: <1433298070.5798.1.camel@memnix.com>
References: <1430455027.7012.32.camel@memnix.com>
	<20150501211703.GA15030@redhat.com>
	<1430519090.5537.4.camel@memnix.com>
	<1430523735.5352.1.camel@memnix.com>
	<20150515150442.GB35834@hank.reardencode.com>
	<1431959798.19977.4.camel@memnix.com>
	<alpine.LRH.2.02.1506021345310.22804@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1506021345310.22804@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Brandon Smith <freedom@reardencode.com>, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, 2015-06-02 at 13:51 -0400, Mikulas Patocka wrote:
> 
> On Mon, 18 May 2015, Abelardo Ricart III wrote:
> 
> > On Fri, 2015-05-15 at 08:04 -0700, Brandon Smith wrote:
> > > On 2015-05-01 (Fri) at 19:42:15 -0400, Abelardo Ricart III wrote:
> > > > > > The patchset in question was tested quite heavily so this is a
> > > > > > surprising report.  I'm noticing you are opting in to dm-crypt 
> discard
> > > > > > support.  Have you tested without discards enabled?
> > > > > 
> > > > > I've disabled discards universally and rebuilt a vanilla kernel. After 
> 
> > > > > running
> > > > > my heavy read-write-sync scripts, everything seems to be working fine 
> now. 
> > > > > I
> > > > > suppose this could be something that used to fail silently before, but 
> now
> > > > > produces bad behavior? I seem to remember having something in my 
> message 
> > > > > log
> > > > > about "discards not supported on this device" when running with it 
> enabled
> > > > > before.
> > > > 
> > > > Forgive me, but I spoke too soon. The corruption and libata errors are 
> still
> > > > there, as was evidenced when I went to reboot and got treated to an eye 
> full 
> > > > of
> > > > "read-only filesystem" and ata errors.
> > > > 
> > > > So no, disabling discards unfortunately did nothing to help.
> > > 
> > > I've been experiencing the same problem.  Vanilla 4.0 series kernels,
> > > dm-crypt, with/or without discards, on a ThinkPad X1 Carbon with a
> > > LiteOn LGT-256M6G SSD.   
> > > 
> > > After some of googling around, I found some chatter relating to changes
> > > in NCQ on SSDs in 4.0.   Been running w/o NCQ for a full kernel build so
> > > far without issue.  Perhaps there's been some change in the interaction
> > > between dm-crypt and NCQ?
> > > 
> > > Abelardo, can you try w/o NCQ and see if that helps your situation?
> > > 
> > > Best,
> > > 
> > > --Brandon
> > 
> > I've been running with NCQ disabled and been stress testing for awhile and 
> the
> > issue is indeed gone. Thanks for the workaround!
> > 
> > So it seems the issue is somehow related to the combination of NCQ, dm
> -crypt,
> > and possibly (some?) SSDs.
> 
> Hi
> 
> I suspect that this is a bug in kernel NCQ processing or in SSD firmware 
> and recent dm-crypt changes made the bug show up.
> 
> I suggest this:
> 
> If you have some test that reliably reproduces the bug, please do this: 
> take kernel 3.19 or 3.18 and apply dm-crypt parallelization patches 
> (commits f3396c58fd8442850e759843457d78b6ec3a9589, 
> cf2f1abfbd0dba701f7f16ef619e4d2485de3366, 
> 7145c241a1bf2841952c3e297c4080b357b3e52d, 
> 94f5e0243c48aa01441c987743dc468e2d6eaca2, 
> dc2676210c425ee8e5cb1bec5bc84d004ddf4179, 
> 0f5d8e6ee758f7023e4353cca75d785b2d4f6abe, 
> b3c5fd3052492f1b8d060799d4f18be5a5438add) on it. If the bug doesn't show 
> up with the older kernel and dm-crypt parallelization patches, use git 
> bisect to find out which patch broken NCQ. When you test a kernel with 
> bisect, apply the above mentioned patches to it.
> 
> Mikulas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Alright, I'll try this next and report back soon.
