From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH v2] multipath: add find_multipaths feature.
Date: Thu, 01 Sep 2011 09:14:23 +0200
Message-ID: <1314861263.14056.89.camel@lapoo.opensvc.com>
References: <20110725185758.GA1368@ether.msp.redhat.com>
	<20110901025518.GD11793@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110901025518.GD11793@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mer., 2011-08-31 at 21:55 -0500, Benjamin Marzinski wrote:
> This adds a new default feature, find_multipaths. When this is set to yes,
> multipath will no longer try to create a multipath device for every
> non-blacklisted device. Instead, it will only create a device when one of
> three conditions are met.
> 
> 1. Three are at least two non-blacklisted paths with the same wwid
> 2. The user manually forces the creation, by specifying a device with the
>    multipath command.
> 3. A path has the same wwid as a multipath device that was previously crreated
>    (even if that multipath device doesn't currently exist).
> 
Hannes,

this patch implements complex semantics and mis-use /etc to store
variable data (/run was suggested as a replacement). Though I realize
the benefits, I'm not at ease merging it.

Mike Snitzer pushed for its inclusion, but I don't remember your
commenting. Would your care to ?

Regards,

-- 
Christophe Varoqui
OpenSVC - Tools to scale
http://www.opensvc.com/
