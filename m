From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: waiteventloop loops once more than it needs to
Date: Wed, 20 Apr 2005 00:55:47 +0200
Message-ID: <1113951347.24817.82.camel@zezette>
References: <20050419222452.GF8789@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050419222452.GF8789@phlogiston.msp.redhat.com>
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

Right, applied.

On mar, 2005-04-19 at 17:24 -0500, Benjamin Marzinski wrote:
> In waitevntloop(), you get the current event_nr, and then wait for an
> event. After the event, the event_nr will always be at least one greater.
> This means that waiteventloop will always run mark_failed_path() once more
> than needed. This patch, against multipath-tools-0.4.4-pre15, fixes that.
> 
> -Ben
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
