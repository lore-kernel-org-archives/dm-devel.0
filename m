From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: log_enqueue frequently overruns log_area
Date: Wed, 20 Apr 2005 23:07:32 +0200
Message-ID: <1114031252.24817.147.camel@zezette>
References: <20050420205905.GI8789@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050420205905.GI8789@phlogiston.msp.redhat.com>
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

Yes, sure, it was set low for testing purpose and can now be bumped up.

Merged, with thanks.

Regards,

On mer, 2005-04-20 at 15:59 -0500, Benjamin Marzinski wrote:
> After seeing multipathd not logging what I was expecting it to, I checked to
> see if it was ever dropping messages, and it was. In fact, I get dropped
> messages on start up most of the time. The attached patch, against
> multipath-tools-0.4.4-pre16, doubles the default logarea size. At that size,
> I haven't seen any dropped messages. I'm not sure that this is the right
> size, but it definitely works better for me.
> 
> -Ben
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
