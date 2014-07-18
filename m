From: John Utz <John.Utz@wdc.com>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Fri, 18 Jul 2014 16:51:47 +0000
Message-ID: <8A51900D08212F40B3DE22453052F69839C46EA4@wdscexmb02>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
	<20131218140858.GC17730@redhat.com> <52B1B046.3040301@suse.de>
	<1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<20140718000411.GB337@redhat.com>
	<8A51900D08212F40B3DE22453052F69839C46AF4@wdscexmb02>,
	<20140718021806.GA1143@redhat.com>
	<8A51900D08212F40B3DE22453052F69839C46B5B@wdscexmb02>,
	<53C8B757.2000904@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53C8B757.2000904@suse.de>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Sorry Hannes;

My apologies.

I am guilty of hijacking the thread, tho i plead that it was inadvertent. :=
-P

indeed, ZAC/ZBC is orthagonal to multipath, no arguments there.

My response was directed to Mike's discourse on the available testing tools=
 for device mapper and contained my ruminations about how to leverage those=
 tools for the project that I am lucky enuf to be working on.
________________________________________
From: Hannes Reinecke [hare@suse.de]
Sent: Thursday, July 17, 2014 10:57 PM
To: John Utz
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] dm-multipath: Accept failed paths for multipath maps

On 07/18/2014 05:31 AM, John Utz wrote:
> Thankyou very much for the exhaustive answer! I forwarded on to my
 > project peers because i don't think any of us where aware of the
 > existing infrastructure.
>
> Of course, said infrastructure would have to be taught about ZAC,
 > but it seems like it would be a nice place to start testing from....
>
ZAC is a different beast altogether; I've posted an initial set of
patches a while back on linux-scsi.
But I don't think multipath needs to be changed for that.
Other areas of device-mapper most certainly do.

Cheers,

Hannes
--
Dr. Hannes Reinecke                   zSeries & Storage
hare@suse.de                          +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
