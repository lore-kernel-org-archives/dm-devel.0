From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: pidfile doesn't stop multiple multipathd processes
	from running.
Date: Wed, 20 Apr 2005 01:03:42 +0200
Message-ID: <1113951822.24817.86.camel@zezette>
References: <20050419223754.GG8789@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050419223754.GG8789@phlogiston.msp.redhat.com>
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

Not close to a one-liner, but so obviously more refined ...
Applied, with thanks.

Regards,

On mar, 2005-04-19 at 17:37 -0500, Benjamin Marzinski wrote:
> The current pidfile implementation doesn't stop multiple multipathd processes
> from running. Running
> # while true; do multipthd; done
> happily makes tons of them.
> 
> The attached patch, against multipath-tools-0.4.4-pre15, fixes this.
> 

-- 
christophe varoqui <christophe.varoqui@free.fr>
