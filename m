From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [patch] dm thin: check kmalloc in
	dm_deferred_set_create()
Date: Tue, 2 Oct 2012 13:58:08 +0100
Message-ID: <20121002125807.GB27325@agk-dp.fab.redhat.com>
References: <20121002114649.GA1413@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121002114649.GA1413@elgon.mountain>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, kernel-janitors@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 02, 2012 at 02:46:49PM +0300, Dan Carpenter wrote:
> We can simply return NULL here.  The callers already handle that.
 
Folded into dm-thin-prepare-to-separate-bio_prison-code.patch in
linux-next, thanks.

Alasdair

