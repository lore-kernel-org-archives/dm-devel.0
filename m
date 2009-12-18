From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 14:55:34 +0100
Message-ID: <200912181455.34664.bzolnier@gmail.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<200912171618.32882.bzolnier@gmail.com>
	<alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Friday 18 December 2009 02:04:37 pm Jiri Kosina wrote:
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

I see but the above code is an utter crap anyway.

Firstly what kind of a function parameter is that:

   le_ih_k_offset(ih) + (tb->lbytes << (is_indirect_le_ih(ih) ? tb->tb_sb->s_blocksize_bits - UNFM_P_SHIFT : 0))

?

[ BTW 'tb->tb_sb->s_blocksize_bits - UNFM_P_SHIFT' construct is used five
  times in balance_leaf() and is a likely candidate for helper / macro. ]

More importantly the whole balance_leaf() function is almost 1400 LOC (!)
big and impossible to read: code for handling particular 'switch' blocks
should be factored out into separate functions etc.

The point I was making is that the once we remove the limit we don't have
other tool to _automatically_ point suspicious code areas (yes, I would
also prefer intelligent static code checker over dumb limit but it simply
not here as things are today and dumb limit works surprisingly well most
of the time -- please note how that the structural problem with the code
example given is immediately visible with the current limit).

> Generally, don't look at this function after having a good lunch you want 
> to keep. You have been warned.

No worries, I visit dark places (ide, staging, ..) and come back alive.. ;)

--
Bartlomiej Zolnierkiewicz
