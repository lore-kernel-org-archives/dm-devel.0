From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device
 DM devices
Date: Tue, 19 Feb 2008 10:58:31 +0300
Message-ID: <47BA8C27.6020108@msgid.tls.msk.ru>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru> <20080218221644.GN155407@sgi.com> <20080219071948.GA244758@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755071AbYBSH7D@vger.kernel.org>
In-Reply-To: <20080219071948.GA244758@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Ric Wheeler <ric@emc.com>, device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Jeremy Higdon wrote:
[]
> I'll put it even more strongly.  My experience is that disabling write
> cache plus disabling barriers is often much faster than enabling both
> barriers and write cache enabled, when doing metadata intensive
> operations, as long as you have a drive that is good at CTQ/NCQ.

Now, and it's VERY interesting at least for me (and is off-topic in
this thread) -- which drive(s) are good at NCQ?  I tried numerous SATA
(NCQ is about sata, right? :) drives, but NCQ either does nothing in
terms of performance or hurts.  Yesterday we ordered another drive
from Hitachi (their "raid edition" thing), -- will try it tomorrow,
but I've no hope here as it's some 5th or 6th model/brand already.

(Ol'good SCSI drives, even 10 years old, shows large difference when
TCQ is enabled...)

Thanks!
