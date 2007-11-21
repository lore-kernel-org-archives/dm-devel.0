From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Bug in dm-stripe.c driver
Date: Wed, 21 Nov 2007 19:39:32 +0000
Message-ID: <20071121193932.GM22843@agk.fab.redhat.com>
References: <D44F48C7D79D2943A073C8FA0F49A3CC019BA3E9@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC019BA3E9@orsmsx418.amr.corp.intel.com>
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

On Wed, Nov 21, 2007 at 11:15:52AM -0800, Wood, Brian J wrote:
> /***** Here's the problem spot *****/ 
>        struct stripe stripe[0];
 
That one must remain the last element in the struct.
Add any new fields above it.

Alasdair
-- 
agk@redhat.com
