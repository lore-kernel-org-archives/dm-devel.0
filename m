From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: multipathd.init
Date: Fri, 1 Apr 2005 22:19:02 +0100
Message-ID: <20050401211902.GL14307@agk.surrey.redhat.com>
References: <20050401204048.GI14307@agk.surrey.redhat.com>
	<1112389744.8118.26.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1112389744.8118.26.camel@zezette>
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

On Fri, Apr 01, 2005 at 11:09:04PM +0200, christophe varoqui wrote:
> Do we really want to do complicated things to close that window ? I
> would guess not.
 
In other words, if the paths can't survive the window between initrd 
running and init scripts completing, the machine doesn't deserve to boot.

And if you want the daemon in single-user mode, you can start it by hand.

Fair point.

So is there ever a requirement to run the daemon while /var is read-only?

Alasdair
-- 
agk@redhat.com
