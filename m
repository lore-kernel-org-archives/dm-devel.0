From: Hannes Reinecke <hare@suse.de>
Subject: ZAC target (Was: Re: dm-multipath: Accept failed paths for multipath
 maps)
Date: Mon, 21 Jul 2014 16:23:41 +0200
Message-ID: <53CD226D.1070309@suse.de>
References: <1387353155-7271-1-git-send-email-hare@suse.de> <20131218140858.GC17730@redhat.com> <52B1B046.3040301@suse.de> <1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com> <20140718000411.GB337@redhat.com> <8A51900D08212F40B3DE22453052F69839C46AF4@wdscexmb02> <20140718021806.GA1143@redhat.com> <8A51900D08212F40B3DE22453052F69839C46B5B@wdscexmb02> <53C8B757.2000904@suse.de>,<20140718143855.GA4762@redhat.com> <8A51900D08212F40B3DE22453052F69839C46EC0@wdscexmb02>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8A51900D08212F40B3DE22453052F69839C46EC0@wdscexmb02>
Sender: linux-kernel-owner@vger.kernel.org
To: John Utz <John.Utz@wdc.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>
List-Id: dm-devel.ids

On 07/18/2014 07:04 PM, John Utz wrote:
>> On 07/18/2014 05:31 AM, John Utz wrote:
>>> Thankyou very much for the exhaustive answer! I forwarded on to my
>>> project peers because i don't think any of us where aware of the
>>> existing infrastructure.
>>>
>>> Of course, said infrastructure would have to be taught about ZAC,
>>> but it seems like it would be a nice place to start testing from...=
=2E
>>>
>> ZAC is a different beast altogether; I've posted an initial set of
>> patches a while back on linux-scsi.
>> But I don't think multipath needs to be changed for that.
>> Other areas of device-mapper most certainly do.
>
> Pretty sure John is working on a new ZAC-oriented DM target.
>
> YUP.
>
> Per Ted T'so's suggestion several months ago, the goal is to create
 > a new DM target that implements the ZAC/ZBC command set and the SMR
 > write pointer architecture so that FSfolksen can try their hand at
 > porting their stuff to it.
>
> It's in the very early stages so there is nothing to show yet, but
 > development is ongoing. There are a few unknowns about how to surfac=
e
 > some specific behaviors (new verbs and errors, particularly errors
 > with sense codes that return a write pointer) but i have not gotten
 > far enuf along in development to be able to construct succint and
 > specific questions on the topic so that will have to wait for a bit.
>
I was pondering the 'best' ZAC implementation, too, and found the
'report zones' command _very_ cumbersome to use.
Especially the fact that in theory each zone could have a different=20
size _and_ plenty of zones could be present will be making zone=20
lookup hellish.

However: it seems to me that we might benefit from a generic
'block boundaries' implementation.
Reasoning here is that several subsystems (RAID, ZAC/ZBC, and things=20
like referrals) impose I/O scheduling boundaries which must not be=20
crossed when assembling requests.

Seeing that we already have some block limitations I was wondering=20
if we couldn't have some set of 'I/O scheduling boundaries' as part
of the request_queue structure.

Kent, Jens; comments here?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
