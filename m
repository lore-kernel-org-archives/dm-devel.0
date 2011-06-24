From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-kcopyd/dm-snap: Don't read the origin on
	full chunk	write
Date: Fri, 24 Jun 2011 01:51:43 +0100
Message-ID: <20110624005142.GH7497@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1106232021200.12675@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106232021200.12675@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jun 23, 2011 at 08:25:44PM -0400, Mikulas Patocka wrote:
> This is the new patch for optimizing full chunk write. dm-kcopyd provides 
> only callbacks.
 
Yes, I think I prefer this way of doing it as we discussed - it reduces
the kcopyd changes to what is necessary.  (And the complexity involved
in avoiding kcopyd isn't worth it.)

Alasdair
