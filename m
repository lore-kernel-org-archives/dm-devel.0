From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: multipathd.init
Date: Mon, 4 Apr 2005 21:52:27 +0100
Message-ID: <20050404205227.GA14307@agk.surrey.redhat.com>
References: <20050401204048.GI14307@agk.surrey.redhat.com>
	<1112389744.8118.26.camel@zezette>
	<20050401211902.GL14307@agk.surrey.redhat.com>
	<1112390705.8118.34.camel@zezette>
	<1112521418.8118.49.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1112521418.8118.49.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, Apr 03, 2005 at 11:43:37AM +0200, christophe varoqui wrote:
> Would it ease your packaging work if I put this init script as
> multipathd/multipathd.init.redhat ?
 
Yes - that's the line I've been taking with other packages,
including multiple init scripts and letting people choose
the one they need.

Alasdair
-- 
agk@redhat.com
