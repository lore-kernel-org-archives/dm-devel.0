From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: patch for log_enqueue in multipath-tools-0.4.4-pre11
Date: Mon, 11 Apr 2005 23:36:58 +0200
Message-ID: <1113255418.8158.6.camel@zezette>
References: <20050411205950.GA4999@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050411205950.GA4999@phlogiston.msp.redhat.com>
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

Merged, thanks.
Good to see new eyeballs in there.

Have you spoted design flaws in the async logger ?

Regards,
cvaroqui

On lun, 2005-04-11 at 15:59 -0500, Benjamin Marzinski wrote:
> It looks to me like log_enqueue can accidentally mess up its la->tail ptr,
> if it runs out of space for the new message.
> 
> If the la->head is just past la->start, and la->tail is just before la->end,
> la->tail will get updated to be la->start, because there is no room at the
> end of the buffer for the message.  Then when it realizes that there is no
> room at the start of the buffer, la->tail will be updated to la->start - fwd
> And the next message will be written before the buffer.
> 
> This patch fixes that.
> 
