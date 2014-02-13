From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm: make dm_table_alloc_md_mempools static
Date: Thu, 13 Feb 2014 14:19:39 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1402131419030.32204@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1402131343110.22991@file01.intranet.prod.int.rdu2.redhat.com>
	<20140213191600.GA10586@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140213191600.GA10586@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 13 Feb 2014, Mike Snitzer wrote:

> On Thu, Feb 13 2014 at  1:43pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Make the function dm_table_alloc_md_mempools static because it is not
> > called from another module.
> 
> Doesn't the same apply to dm_table_free_md_mempools?

No, it is called from dm.c and defined in dm-table.c

Mikulas
