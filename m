From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: release 0.4.4 ?
Date: Wed, 20 Apr 2005 17:06:53 +0100
Message-ID: <20050420160653.GZ9049@agk.surrey.redhat.com>
References: <1113731446.24817.4.camel@zezette>
	<1113953571.24817.97.camel@zezette>
	<20050420133116.GW29071@marowsky-bree.de>
	<1114006824.24817.108.camel@zezette>
	<20050420142637.GA29071@marowsky-bree.de>
	<1114008114.24817.115.camel@zezette>
	<20050420150107.GD29071@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050420150107.GD29071@marowsky-bree.de>
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

On Wed, Apr 20, 2005 at 05:01:07PM +0200, Lars Marowsky-Bree wrote:
> But I think it's pretty obvious that multipath is needed before /var is
> mounted, I think.
 
I would prefer to see the temporary file disappear completely:
as I see things, it was a quick workaround for a problem until
there's time to replace it with a better permanent solution.

Alasdair
-- 
agk@redhat.com
