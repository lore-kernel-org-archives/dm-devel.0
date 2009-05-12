From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] i/o errors with dm-over-md-raid0
Date: Tue, 12 May 2009 12:30:38 +0100
Message-ID: <20090512113037.GA3966@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.0905111226120.1438@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905111226120.1438@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, May 11, 2009 at 12:35:34PM -0400, Mikulas Patocka wrote:
> +	 * If the target doesn't support merge method and some of the devices

Do you think we should add merge methods to more of our targets?
It looks like we've only done linear and crypt so far.

Alasdair
