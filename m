From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 14:04:37 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com>
	<alpine.LFD.2.00.0912170713390.17868@localhost.localdomain>
	<200912171618.32882.bzolnier@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200912171618.32882.bzolnier@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:

> > > I like this patch, this is actually what I wanted to do.
> > 
> > I have nothing against a switch, but it had better default to off.
> > 
> > The whole 80-char limit is insane. It results in insane "fixes". Just 
> > about every time somebody "improves" a patch due to the warning, the 
> > result is worse than the original patch.
> 
> Examples? :)

balance_leaf() in fs/reiserfs/do_balan.c

Example picked totally at random:

	set_le_ih_k_offset(ih,
			   le_ih_k_offset(ih) +
			   (tb->
			    lbytes <<
			    (is_indirect_le_ih
			     (ih) ? tb->tb_sb->
			     s_blocksize_bits -
			     UNFM_P_SHIFT :
			     0)));

See how everything is nicely aligned to 80 cols?


Generally, don't look at this function after having a good lunch you want 
to keep. You have been warned.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
