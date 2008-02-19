From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device DM devices
Date: Tue, 19 Feb 2008 10:43:48 +0100
Message-ID: <20080219094348.GE6485@one.firstfloor.org>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru> <20080218221644.GN155407@sgi.com> <20080219025643.GD4066@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763254AbYBSJn6@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080219025643.GD4066@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>, Michael Tokarev <mjt@tls.msk.ru>, Ric Wheeler <ric@emc.com>, device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, linux-kern
List-Id: dm-devel.ids

> My complaint about having to support them within dm when more than one
> device is involved is because any efficiencies disappear: you can't send
> further I/O to any one device until all the other devices have completed
> their barrier (or else later I/O to that device could overtake the
> barrier on another device).  And then I argue that it would be better

I was wondering: would it help DM to have the concept of a "barrier window"
As in "this barrier is only affective for this group of requests"
With such a concept DM would need to stall only inside the groups
and possible even issue such barrier groups in parallel, couldn't it?

I'm sure you guys all have thought far more about barriers than
I ever did; if that idea came up before why was it dismissed?

-Andi
