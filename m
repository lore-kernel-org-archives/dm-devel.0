From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-verity: Fix biovecs hash calculation regression
Date: Mon, 14 Apr 2014 17:11:20 -0400
Message-ID: <20140414211119.GA24873@redhat.com>
References: <1397505750-18783-1-git-send-email-gmazyland@gmail.com>
	<alpine.LRH.2.02.1404141629040.22418@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1404141629040.22418@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, kmo@daterainc.com, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Mon, Apr 14 2014 at  4:29pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Mon, 14 Apr 2014, Milan Broz wrote:
> 
> > The commit
> >   003b5c5719f159f4f4bf97511c4702a0638313dd
> >   block: Convert drivers to immutable biovecs
> > 
> > incorrectly converted biovec iteration in dm-verity to always
> > calculate hash from full biovec, while the function need
> > to calculate hash only from part of it (up to "todo"
> > calculated value).
> > 
> > This patch fixes the issue by limiting hash input to only
> > really requested data size.
> > 
> > The problem is easily reproducible using cryptsetup
> > regression test for veritysetup (verity-compat-test).
> > 
> > (Patch should be applied also to 3.14 stable.)
> > 
> > Signed-off-by: Milan Broz <gmazyland@gmail.com>
> 
> Acked-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org	# 3.14

I'll pick this up to include in 3.15 fixes that I'll be sending to Linus.
