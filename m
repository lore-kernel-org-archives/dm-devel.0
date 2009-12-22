From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Tue, 22 Dec 2009 16:10:44 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0912221607180.21496@twin.jikos.cz>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com> <alpine.LFD.2.00.0912170713390.17868@localhost.localdomain> <200912171618.32882.bzolnier@gmail.com>
 <alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz> <20091221063238.GC15721@linux-sh.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751924AbZLVPKt@vger.kernel.org>
In-Reply-To: <20091221063238.GC15721@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Mundt <lethal@linux-sh.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Am?rico Wang <xiyou.wangcong@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 21 Dec 2009, Paul Mundt wrote:

> > Example picked totally at random:
> > 
> > 	set_le_ih_k_offset(ih,
> > 			   le_ih_k_offset(ih) +
> > 			   (tb->
> > 			    lbytes <<
> > 			    (is_indirect_le_ih
> > 			     (ih) ? tb->tb_sb->
> > 			     s_blocksize_bits -
> > 			     UNFM_P_SHIFT :
> > 			     0)));
> > 
> > See how everything is nicely aligned to 80 cols?
> > 
> > 
> > Generally, don't look at this function after having a good lunch you want 
> > to keep. You have been warned.
> > 
> This isn't a valid example, as it wasn't written by a human. This is the
> result of Lindent being run blindly on the file and nothing more.
> 
> Try again.

But having hard rule imposed on everyone to stick with 80-char rule makes 
people to do exactly this kind of things (blindly running indent -l80 and 
believing that it makes the code more readable because it is 
CodingStyle-compliant(tm)).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
