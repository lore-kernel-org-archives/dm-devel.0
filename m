From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Fri, 18 Jul 2014 07:57:43 +0200
Message-ID: <53C8B757.2000904@suse.de>
References: <1387353155-7271-1-git-send-email-hare@suse.de>	<20131218140858.GC17730@redhat.com>
	<52B1B046.3040301@suse.de>	<1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>	<20140718000411.GB337@redhat.com>	<8A51900D08212F40B3DE22453052F69839C46AF4@wdscexmb02>,
	<20140718021806.GA1143@redhat.com>
	<8A51900D08212F40B3DE22453052F69839C46B5B@wdscexmb02>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8A51900D08212F40B3DE22453052F69839C46B5B@wdscexmb02>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Utz <john.utz@wdc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 07/18/2014 05:31 AM, John Utz wrote:
> Thankyou very much for the exhaustive answer! I forwarded on to my
 > project peers because i don't think any of us where aware of the
 > existing infrastructure.
>
> Of course, said infrastructure would have to be taught about ZAC,
 > but it seems like it would be a nice place to start testing from....
>
ZAC is a different beast altogether; I've posted an initial set of =

patches a while back on linux-scsi.
But I don't think multipath needs to be changed for that.
Other areas of device-mapper most certainly do.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
