From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-raid1: wake the thread after adding bios to the
	queue
Date: Mon, 20 Jul 2009 09:11:21 -0400
Message-ID: <20090720131121.GA16840@redhat.com>
References: <Pine.LNX.4.64.0907130931550.6498@hs20-bc2-1.build.redhat.com>
	<20090720125246.GB32330@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090720125246.GB32330@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Mon, Jul 20 2009 at  8:52am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Mon, Jul 13, 2009 at 09:33:06AM -0400, Mikulas Patocka wrote:
> > Recent dm-raid1 clustering patch violate this rule.
>  
> Upstream git commit id?

7513c2a761d69d2a93f17146b3563527d3618ba0
