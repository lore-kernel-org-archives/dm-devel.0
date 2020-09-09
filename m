From: Joe Perches <joe@perches.com>
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
Date: Wed, 09 Sep 2020 15:47:24 -0700
Message-ID: <b3d6f71aea87f4bb88554f1a3fdaee0b2feb158c.camel@perches.com>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
 <20200909223602.GJ87483@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <20200909223602.GJ87483@ziepe.ca>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-wireless@vger.kernel.org, linux-fbdev@vger.kernel.org, oss-drivers@netronome.com, nouveau@lists.freedesktop.org, alsa-devel <alsa-devel@alsa-project.org>, dri-devel@lists.freedesktop.org, linux-mips@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org, sparclinux@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-rtc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, dccp@vger.kernel.org, linux-rdma@vger.kernel.org, linux-atm-general@lists.sourceforge.net, linux-afs@lists.infradead.org, coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org, linux-serial@vger.kernel.org, linux-input@vger.kernel.org, linux-mmc@vger.kernel.org, Kees Cook <kees.cook@canonical.com>, linux-media@vger.kernel.org, linux-pm@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-sctp@vger.kernel.
List-Id: dm-devel.ids

On Wed, 2020-09-09 at 19:36 -0300, Jason Gunthorpe wrote:
> On Wed, Sep 09, 2020 at 01:06:39PM -0700, Joe Perches wrote:
> > fallthrough to a separate case/default label break; isn't very readable.
> > 
> > Convert pseudo-keyword fallthrough; statements to a simple break; when
> > the next label is case or default and the only statement in the next
> > label block is break;
> > 
> > Found using:
> > 
> > $ grep-2.5.4 -rP --include=*.[ch] -n "fallthrough;(\s*(case\s+\w+|default)\s*:\s*){1,7}break;" *
> > 
> > Miscellanea:
> > 
> > o Move or coalesce a couple label blocks above a default: block.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> > 
> > Compiled allyesconfig x86-64 only.
> > A few files for other arches were not compiled.
> 
> IB part looks OK, I prefer it like this
> 
> You could do the same for continue as well, I saw a few of those..

I saw some continue uses as well but wasn't sure
and didn't look to see if the switch/case with
continue was in a for/while loop.
