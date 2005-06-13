From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: further testing w/ multipath ... and bugs
Date: Mon, 13 Jun 2005 23:37:33 +0200
Message-ID: <1118698654.1515.10.camel@zezette>
References: <20050613081154.GA28251@averon.dyndns.org>
	<42ADE021.6050902@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42ADE021.6050902@cs.wisc.edu>
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
List-Id: dm-devel.ids

On lun, 2005-06-13 at 14:36 -0500, Mike Christie wrote:
> Christophe Varoqui wrote:
> > 
> >  rport-0:0-0: blocked FC remote port time out: removing target
> >  rport-0:0-1: blocked FC remote port time out: removing target
> 
> I think if we end up doing this to all the devices paths we are going to 
> be screwed. If all the paths suddenly fail and then those devices are 
> freed when trying to readd/create devices when the ports come back is 
> going to take a lot of GFP_KERNELs.

Right.

One thing I don't understand in the current scheme is why io are not
rerouted by the DM multipath target between the LOOP_DOWN and the rport
target removal ...

If io could get rerouted within a few seconds, we could set a target
removal multi-minutes timer, which should cover most reasonable SAN
failure scenarii.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
