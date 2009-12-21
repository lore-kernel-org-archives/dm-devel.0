From: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Mon, 21 Dec 2009 15:32:38 +0900
Message-ID: <20091221063238.GC15721@linux-sh.org>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com> <alpine.LFD.2.00.0912170713390.17868@localhost.localdomain> <200912171618.32882.bzolnier@gmail.com> <alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751991AbZLUGcx@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Am?rico Wang <xiyou.wangcong@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Dec 18, 2009 at 02:04:37PM +0100, Jiri Kosina wrote:
> On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
> 
> > > > I like this patch, this is actually what I wanted to do.
> > > 
> > > I have nothing against a switch, but it had better default to off.
> > > 
> > > The whole 80-char limit is insane. It results in insane "fixes". Just 
> > > about every time somebody "improves" a patch due to the warning, the 
> > > result is worse than the original patch.
> > 
> > Examples? :)
> 
> balance_leaf() in fs/reiserfs/do_balan.c
> 
> Example picked totally at random:
> 
> 	set_le_ih_k_offset(ih,
> 			   le_ih_k_offset(ih) +
> 			   (tb->
> 			    lbytes <<
> 			    (is_indirect_le_ih
> 			     (ih) ? tb->tb_sb->
> 			     s_blocksize_bits -
> 			     UNFM_P_SHIFT :
> 			     0)));
> 
> See how everything is nicely aligned to 80 cols?
> 
> 
> Generally, don't look at this function after having a good lunch you want 
> to keep. You have been warned.
> 
This isn't a valid example, as it wasn't written by a human. This is the
result of Lindent being run blindly on the file and nothing more.

Try again.
