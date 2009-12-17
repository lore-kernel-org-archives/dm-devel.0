From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 07:37:41 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com> <alpine.LFD.2.00.0912170713390.17868@localhost.localdomain> <200912171618.32882.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965197AbZLQPia@vger.kernel.org>
In-Reply-To: <200912171618.32882.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids



On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
> 
> Examples? :)

They're typically things like this:

-			ret = sscanf (buf, "0x%lx - 0x%lx", &start_addr, &end_addr);
+			ret = sscanf(buf, "0x%lx - 0x%lx", &start_addr,
+				&end_addr);

ie a line-break that is just annoying and makes the code harder to read 
rather than easier. 

			Linus
