From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 11:43:23 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0912181137140.23738@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost> <m3my1g1hmr.fsf@intrepid.localdomain>
	<7004b08e0912180652p42777da3h70906f2fbdb60a69@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7004b08e0912180652p42777da3h70906f2fbdb60a69@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kevin granade <kevin.granade@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Paul Mundt <lethal@linux-sh.org>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>
List-Id: dm-devel.ids

> Note: I'm not specifically arguing for keeping the 80-column rule, the
> project I work on uses 100 columns, and that's quite workable, but I
> haven't had any problem working with 80 columns as a limit either.  I
> do however think that just removing the limit without replacing it
> with something better is a bad idea.
> 
> -Kevin Granade

But think what happens when someone views that 100-char code on 80-char 
terminal (or for example 94-char, that I used for some times too) --- 
every second line will be wasted with just 20 characters on the left. On 
the other hand, if you have unlimited line length, it will look better on 
80-char terminal.

Mikulas
