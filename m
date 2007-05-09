From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Date: Wed, 9 May 2007 16:47:11 +0100
Message-ID: <20070509154711.GC18152@agk.fab.redhat.com>
References: <20070508194845.GC24114@agk.fab.redhat.com>
	<20070508174159.7d78a275.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070508174159.7d78a275.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids

On Tue, May 08, 2007 at 05:41:59PM -0700, Andrew Morton wrote:
> On Tue, 8 May 2007 20:48:45 +0100
> Alasdair G Kergon <agk@redhat.com> wrote:
> > +#define BIO_LIST(bl) \
> > +	struct bio_list bl = BIO_LIST_INIT
 
> BIO_LIST is a strange name for something which initialises storage.
 
Those came by analogy with list.h, with list_head -> bio_list:

  #define LIST_HEAD(name) \
        struct list_head name = LIST_HEAD_INIT(name)

We could use something like INIT_BIO_LIST(bl) for that, but perhaps it would be
more readable always written out in full?
   struct bio_list bl = BIO_LIST_INIT;

Alasdair
-- 
agk@redhat.com
