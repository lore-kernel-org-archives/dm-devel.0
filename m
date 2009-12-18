From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 16:11:50 +0100
Message-ID: <200912181611.50871.bzolnier@gmail.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <24653.1261110557@localhost> <m3my1g1hmr.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754512AbZLRPNb@vger.kernel.org>
In-Reply-To: <m3my1g1hmr.fsf@intrepid.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Valdis.Kletnieks@vt.edu, Mikulas Patocka <mpatocka@redhat.com>, Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Friday 18 December 2009 03:28:12 pm Krzysztof Halasa wrote:
> Valdis.Kletnieks@vt.edu writes:
> 
> > Yeah, but I respectfully submit that if the regexp '^\t{6}' matches a non-
> > continuation line, it's probably in its rights to whinge.
> 
> Yes, but don't make it a hard error, only a suggestion that something is
> probably really wrong.
> 
> > fs/reisersfs/do_balan.c, lines 460-477 (note: 3 leading tabs elided)
> >
> > 				leaf_paste_entries(&bi,
> > 						   n +
> > 						   item_pos
> > 						   -
> > 						   ret_val,
> > 						   l_pos_in_item,
> > 						   1,
> > 						   (struct
> > 						    reiserfs_de_head
> > 						    *)
> > 						   body,
> > 						   body
> > 						   +
> > 						   DEH_SIZE,
> > 						   tb->
> > 						   insert_size
> > 						   [0]
> > 				    );
> >
> > Yes, that used to be 24 more columns to the right.  Gaak.
> 
> Precisely. It's a clear show of the damage hard rules like that do.

It is not a hard rule and the above damage was done in 2005 when some
random developer (Linus Torvalds?  Is this even a real name? ;-) decided
to mindlessly pass do_balan.c file through Lindent script and later
didn't finish the task of cleaning the code properly (see commit bd4c625
for details).

We didn't even have checkpatch.pl back then (it was added in 2007).

> I can't even tell how the code should be fixed and if the simple merging
> would do, since I can't really imagine how it would look like :-)

The old code [ no tabs removed ]:

-                           leaf_paste_entries (bi.bi_bh, n + item_pos - ret_val, l_pos_in_item, 1,
-                                               (struct reiserfs_de_head *)body,
-                                               body + DEH_SIZE, tb->insert_size[0]
-                               );

--
Bartlomiej Zolnierkiewicz
