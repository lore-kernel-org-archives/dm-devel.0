From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-mp: revalidate paths with zero size prior
	to use
Date: Tue, 9 Jan 2007 15:01:40 +0000
Message-ID: <20070109150140.GV21980@agk.surrey.redhat.com>
References: <20070108225938.GB3966@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070108225938.GB3966@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Anderson <andmike@us.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 08, 2007 at 02:59:38PM -0800, Mike Anderson wrote:
> Revalidate zero size path prior to using.

Are new checks also needed for non-multipath configurations too now?

Alasdair
-- 
agk@redhat.com
