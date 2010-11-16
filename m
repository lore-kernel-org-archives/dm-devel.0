From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: add find_multipaths feature.
Date: Wed, 17 Nov 2010 00:51:15 +0100
Message-ID: <1289951475.3861.6.camel@zezette>
References: <20101116232546.GU13763@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101116232546.GU13763@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On mar., 2010-11-16 at 17:25 -0600, Benjamin Marzinski wrote:
> This adds a new default feature, find_multipaths. When this is set to yes,
> multipath will no longer try to create multipath devices using every
> non-blacklisted device. Instead, it will only create a device when one of
> three conditions are met.
> 
> 1. Three are at least two non-blacklisted paths with the same wwid
> 2. The user manually forces the creation, by specifying a device with the
>    multipath command.
> 3. A path has the same wwid as a multipath device that was previously crreated
>    (even if that multipath device doesn't currently exist).

I'm confused. A blacklist/whitelist system may be hard to configure
properly but the rules are simple. I fear this new rule set will
increase confusion.

Could you elaborate on what problems this new rule set is trying to
address ?

Best regards,
-- 
Christophe Varoqui <christophe.varoqui@opensvc.com>
OpenSVC
