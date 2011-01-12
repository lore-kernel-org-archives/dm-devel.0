From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for January 12 (dm-crypt)
Date: Wed, 12 Jan 2011 10:01:21 -0800
Message-ID: <20110112100121.ba610465.randy.dunlap@oracle.com>
References: <20110112141822.c29314c4.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20110112141822.c29314c4.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, 12 Jan 2011 14:18:22 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Reminder: do not add any v2.6.39 material to your linux-next included
> trees until after v2.6.38-rc1 is released.
> 
> Changes since 20110111:


When CONFIG_LBDAF is not enabled (build on i386):
(sector_t is 32 bits)

drivers/md/dm-crypt.c:568: warning:right shift count >= width of type

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
