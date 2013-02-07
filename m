From: thornber@redhat.com
Subject: Re: [PATCH 5/8] [dm-thin] Fix a race condition between
 discard bios and ordinary bios.
Date: Thu, 7 Feb 2013 11:20:23 +0000
Message-ID: <20130207112023.GA4237@raspberrypi>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-6-git-send-email-ejt@redhat.com>
	<20130124023503.GG30267@agk-dp.fab.redhat.com>
	<20130124132259.GA6658@raspberrypi>
	<Pine.LNX.4.64.1302051904120.30143@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1302051904120.30143@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 05, 2013 at 07:11:37PM -0500, Mikulas Patocka wrote:
> On Thu, 24 Jan 2013, thornber@redhat.com wrote:
> > I haven't hit any stack size issues.  But the cell structures are 60
> > bytes each and putting two of them on the stack seems wasteful.  I
> > don't have enough knowledge to say this will be ok for all
> > architectures and so took the safe option.
> 
> I think it's better to put the structures on the stack (it is not that 
> much, the stack has 8k, so 120 bytes is 1/68 of the stack) and remove the 
> spinlock.

ok, will change.  Thanks for looking at this Mikulas.

- Joe
