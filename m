From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Remove unused parameters of dm_get_device
Date: Wed, 10 Feb 2010 12:27:18 +0000
Message-ID: <20100210122718.GD18505@agk-dp.fab.redhat.com>
References: <201002101707.02501.knikanth@novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201002101707.02501.knikanth@novell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@novell.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 10, 2010 at 05:07:02PM +0530, Nikanth Karthikesan wrote:
> Remove unused parameters(start and len) of dm_get_device()
> and fix the callers.
 
Originally our plan was to place the reservations on ranges within
the devices.  Then we could support exclusive use and prevent loops.
But in practice because of the way tables get preloaded and moved
between devices this would be tricky to implement and we never did it.

Ack.

Alasdair
