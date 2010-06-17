From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: 2.6.35 causes deadlock when snapshotting root lv
Date: Thu, 17 Jun 2010 12:27:47 -0400
Message-ID: <20100617162747.GA21336@redhat.com>
References: <4C1A2839.5010407@cfl.rr.com>
 <20100617142731.GA10071@redhat.com>
 <4C1A4A74.9070105@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C1A4A74.9070105@cfl.rr.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jun 17 2010 at 12:16pm -0400,
Phillip Susi <psusi@cfl.rr.com> wrote:

> On 6/17/2010 10:27 AM, Mike Snitzer wrote:
> > Which filesystem are you using?  Which 2.6.35-rc?
> 
> ext4, rc1, 2, and 3.
> 
> > There haven't been _any_ changes to DM for 2.6.35 (some DM fixes may get
> > pushed to Linus once Alasdair gets back from traveling).
> 
> I just finished combing through the git log myself and was getting
> concerned that I couldn't find any dm changes.  At least now I know that
> I couldn't find them because they aren't there.
> 
> > So what this means is that the VFS (or ext4) freeze changes introduced
> > in 2.6.35 are the likely culprit:
> > 
> > http://git.kernel.org/linus/18e9e5104fcd9a9
> > http://git.kernel.org/linus/6b0310fbf087ad6
> 
> Yes, these do look suspicious.  I'll test reverting them tonight.

OK, I'd suggest reverting the VFS change (18e9e5104fcd9a9) first.
