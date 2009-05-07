From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH -next] dm-table: fix printk formats
Date: Thu, 7 May 2009 16:41:56 +0100
Message-ID: <20090507154155.GF1320@agk-dp.fab.redhat.com>
References: <20090506172653.2f1bbedd.sfr@canb.auug.org.au>
	<4A020726.3020009@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A020726.3020009@oracle.com>
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: dm-devel.ids

On Wed, May 06, 2009 at 02:54:46PM -0700, Randy Dunlap wrote:
> Fix printk format warnings:
> drivers/md/dm-table.c:408: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'sector_t'
> drivers/md/dm-table.c:414: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'sector_t'
 
Thanks - I'll fold that into the patch.

Alasdair
