From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 15:28:12 +0100
Message-ID: <m3my1g1hmr.fsf@intrepid.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <24653.1261110557@localhost> (Valdis Kletnieks's message of "Thu,
	17 Dec 2009 23:29:17 -0500")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Paul Mundt <lethal@linux-sh.org>, Mikulas Patocka <mpatocka@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Valdis.Kletnieks@vt.edu writes:

> Yeah, but I respectfully submit that if the regexp '^\t{6}' matches a non-
> continuation line, it's probably in its rights to whinge.

Yes, but don't make it a hard error, only a suggestion that something is
probably really wrong.

> fs/reisersfs/do_balan.c, lines 460-477 (note: 3 leading tabs elided)
>
> 				leaf_paste_entries(&bi,
> 						   n +
> 						   item_pos
> 						   -
> 						   ret_val,
> 						   l_pos_in_item,
> 						   1,
> 						   (struct
> 						    reiserfs_de_head
> 						    *)
> 						   body,
> 						   body
> 						   +
> 						   DEH_SIZE,
> 						   tb->
> 						   insert_size
> 						   [0]
> 				    );
>
> Yes, that used to be 24 more columns to the right.  Gaak.

Precisely. It's a clear show of the damage hard rules like that do.
I can't even tell how the code should be fixed and if the simple merging
would do, since I can't really imagine how it would look like :-)
-- 
Krzysztof Halasa
