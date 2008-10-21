From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [git pull] Additional device-mapper patches for 2.6.28
Date: Tue, 21 Oct 2008 10:31:40 -0700
Message-ID: <20081021173140.GA25302@kroah.com>
References: <20081021165901.GO5098@agk.fab.redhat.com> <20081021170436.GA25030@kroah.com> <Pine.LNX.4.64.0810211311320.13319@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755043AbYJUSLE@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810211311320.13319@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <mauelshagen@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Milan Broz <mbroz@redhat.com>, Kazuo Ito <ito.kazuo@oss.ntt.co.jp>, "Martin K. Petersen" <martin.petersen@oracle.com>, stable@kernel.org
List-Id: dm-devel.ids

On Tue, Oct 21, 2008 at 01:12:49PM -0400, Mikulas Patocka wrote:
> 
> 
> On Tue, 21 Oct 2008, Greg KH wrote:
> 
> > On Tue, Oct 21, 2008 at 05:59:01PM +0100, Alasdair G Kergon wrote:
> > > Please pull from:
> > > 
> > >   master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git
> > >  
> > > to get the following additional device-mapper patches for 2.6.28:
> > 
> > Hm, as you copied stable@kernel.org, does that mean that some of these
> > are applicable to -stable releases?
> > 
> > thanks,
> > 
> > greg k-h
> 
> That "fix primary_pe race" should be considered for -stable.

After it goes into Linus's tree, can you send it to stable@kernel.org
with the git commit id?

thanks,

greg k-h
