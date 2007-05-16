From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: BUG in kcryptd?
Date: Wed, 16 May 2007 22:39:47 +0100
Message-ID: <20070516213946.GS6509@agk.fab.redhat.com>
References: <464B1F2B.3030009@xs4all.nl>
	<Pine.LNX.4.61.0705161751020.9570@yvahk01.tjqt.qr>
	<20070516112947.faf95c22.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070516112947.faf95c22.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Engelhardt <jengelh@linux01.gwdg.de>, Udo van den Heuvel <udovdh@xs4all.nl>
Cc: Andrew Morton <akpm@osdl.org>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, May 16, 2007 at 11:29:47AM -0700, Andrew Morton wrote:
> On Wed, 16 May 2007 17:52:09 +0200 (MEST)
> Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> > On May 16 2007 17:11, Udo van den Heuvel wrote:
> > >While opening an encrypted partition and trying to fsck it:
> > Yeah, somewhere is a bug in it, I also get an oops with
> > kcryptd in 2.6.20 on sparc64 after a few minutes (though,
> > it's a NULL dereference there).
> guys, please do try to copy the appropriate mailing list on bug reports,
> thanks.
 
Please test against 2.6.22-rc1 which includes relevant patches like
dm-crypt-fix-call-to-clone_init.patch

Alasdair
-- 
agk@redhat.com
