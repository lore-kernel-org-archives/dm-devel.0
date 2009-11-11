From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/2] Use low pointer bits for dm io region
Date: Wed, 11 Nov 2009 15:04:08 +0000
Message-ID: <20091111150408.GN17055@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.0911102104350.23116@hs20-bc2-1.build.redhat.com>
	<4AFA6717.2060305@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AFA6717.2060305@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 11, 2009 at 04:26:15PM +0900, Kiyoshi Ueda wrote:
> The code is not easily readable for me.

Introducing some macros will probably deal with that.

> Why don't you introduce a new structure in which those two things
> can be stored, and allocate/attach it per bio?

That code didn't want the overhead of managing additional allocations.
 
Alasdair
