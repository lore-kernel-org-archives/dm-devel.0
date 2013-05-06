From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 11/16] Fix max path checker timing
Date: Mon, 06 May 2013 07:42:11 +0200
Message-ID: <518742B3.3010308@suse.de>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
	<1367531197-8987-12-git-send-email-bmarzins@redhat.com>
	<5183603F.5000003@suse.de>
	<20130503154457.GN6253@ether.msp.redhat.com>
	<20130503175948.GO6253@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130503175948.GO6253@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/03/2013 07:59 PM, Benjamin Marzinski wrote:
> Due to some code being placed inside the wrong block, the number of
> seconds to wait between path checks (pp->tick), was only getting set to
> the path's individual check interval if that wasn't equal to the max
> check interval.  Otherwise it was using the default for a failed path.
> This patch makes sure that pp->ticks always always gets set correctly
> for active paths.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
