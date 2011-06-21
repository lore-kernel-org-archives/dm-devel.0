From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: Don't install merge function if
	not	needed
Date: Tue, 21 Jun 2011 23:23:58 +0100
Message-ID: <20110621222358.GM19996@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1106211604110.22545@hs20-bc2-1.build.redhat.com>
	<20110621202424.GK19996@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110621202424.GK19996@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 21, 2011 at 09:24:24PM +0100, Alasdair G Kergon wrote:
> If you are still seeing a problem with md in this respect, please could
> you post the details for us to discuss?
 
We've discussed this on IRC and indeed we think stacking of dm over md is still
broken with respect to reconfigurations while bios are being submitted.
Possible long-term solutions may involve changing the way the dm map
functions work (dealing with the overlap with the merge fns) and moving the
responsibility for splitting back into the core block layer, rather than
relying on dm and md to each deal with it.

Alasdair
