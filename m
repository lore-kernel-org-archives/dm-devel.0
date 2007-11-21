From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: Bug in dm-stripe.c driver
Date: Wed, 21 Nov 2007 19:42:14 +0000
Message-ID: <20071121194214.GN22843@agk.fab.redhat.com>
References: <D44F48C7D79D2943A073C8FA0F49A3CC019BA3E9@orsmsx418.amr.corp.intel.com>
	<20071121193932.GM22843@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20071121193932.GM22843@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Wood, Brian J" <brian.j.wood@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Healey,  Douglas D" <douglas.d.healey@intel.com>, "Ciechanowski,  Ed" <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

On Wed, Nov 21, 2007 at 07:39:32PM +0000, Alasdair G Kergon wrote:
> On Wed, Nov 21, 2007 at 11:15:52AM -0800, Wood, Brian J wrote:
> > /***** Here's the problem spot *****/ 
> >        struct stripe stripe[0];
>  
> That one must remain the last element in the struct.
> Add any new fields above it.
 
Here's how the real size is calculated before it's allocated:

static inline struct stripe_c *alloc_context(unsigned int stripes)
{
        size_t len;

        if (array_too_big(sizeof(struct stripe_c), sizeof(struct stripe),
                          stripes))
                return NULL;

        len = sizeof(struct stripe_c) + (sizeof(struct stripe) * stripes);

        return kmalloc(len, GFP_KERNEL);
}


Alasdair
-- 
agk@redhat.com
