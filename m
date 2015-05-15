From: Brandon Smith <freedom@reardencode.com>
Subject: Re: Regression: Disk corruption with dm-crypt and kernels >= 4.0
Date: Fri, 15 May 2015 08:04:42 -0700
Message-ID: <20150515150442.GB35834@hank.reardencode.com>
References: <1430455027.7012.32.camel@memnix.com>
 <20150501211703.GA15030@redhat.com>
 <1430519090.5537.4.camel@memnix.com>
 <1430523735.5352.1.camel@memnix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430523735.5352.1.camel@memnix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Abelardo Ricart III <aricart@memnix.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, mpatocka@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 2015-05-01 (Fri) at 19:42:15 -0400, Abelardo Ricart III wrote:
> > > The patchset in question was tested quite heavily so this is a
> > > surprising report.  I'm noticing you are opting in to dm-crypt discard
> > > support.  Have you tested without discards enabled?
> > 
> > I've disabled discards universally and rebuilt a vanilla kernel. After running
> > my heavy read-write-sync scripts, everything seems to be working fine now. I
> > suppose this could be something that used to fail silently before, but now
> > produces bad behavior? I seem to remember having something in my message log
> > about "discards not supported on this device" when running with it enabled
> > before.
> 
> Forgive me, but I spoke too soon. The corruption and libata errors are still
> there, as was evidenced when I went to reboot and got treated to an eye full of
> "read-only filesystem" and ata errors.
> 
> So no, disabling discards unfortunately did nothing to help.

I've been experiencing the same problem.  Vanilla 4.0 series kernels,
dm-crypt, with/or without discards, on a ThinkPad X1 Carbon with a
LiteOn LGT-256M6G SSD.   

After some of googling around, I found some chatter relating to changes
in NCQ on SSDs in 4.0.   Been running w/o NCQ for a full kernel build so
far without issue.  Perhaps there's been some change in the interaction
between dm-crypt and NCQ?

Abelardo, can you try w/o NCQ and see if that helps your situation?

Best,

--Brandon
