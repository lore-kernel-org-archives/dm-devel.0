From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: Status of SCSI referrals support in dm-multipath
Date: Mon, 28 Jul 2014 00:18:23 +0200
Message-ID: <20140728001823.000051be@localhost>
References: <20140601224650.000043de@localhost>
	<538C1B0A.6080808@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <538C1B0A.6080808@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

Hannes Reinecke wrote:
> On 06/01/2014 10:46 PM, Sebastian Herbszt wrote:
> > Hello,
> >
> > I am trying to find out the status of SCSI referrals support in dm-multipath.
> > SCSI referrals support was a topic at LSF [1] but I wasn't able to find any
> > information. Back in 2010 Hannes suggested the use of multiple entries in a
> > multipath table [2] but this doesn't seem to work (anymore):
> >
> > [ 7750.354190] device-mapper: table: Request-based dm doesn't support multiple targets yet
> >
> > Is there any SCSI referrals support yet?
> >
> > [1] http://marc.info/?l=linux-scsi&m=129553880112460&w=2
> > [2] http://www.redhat.com/archives/dm-devel/2010-June/msg00155.html
> >
> Not as of now. I've managed to push referrals support into 
> target_core, so you now can set up a backend which supports referrals.

I gathered the following information from a storage with referral support.

> And for the multiple entries I've though to use a linear target on 
> top of the multipath target.
> The linear target would just split up the device in chunks, 
> according to the referrals layout.

I created a new thin provisioned volume which reported

Referrals VPD page (SBC):
  User data segment size: 0
  User data segment multiplier: 0

and didn't return any user data segment referral descriptors.
Since the chunk size is not known, splitting the device is not possible.
The storage reported 4 equal target port groups (sd[b-e]). I guess the
initial setup would consist of a linear target with just a single mapping.

As soon as I started to fill the volume the storage returned the
descriptors

Report referrals:
  descriptor 0:
    target port descriptors: 4
    user data segment: first lba 0, last lba 2752511
      target port descriptor 0:
        port group 8080 state (active/non optimized)
      target port descriptor 1:
        port group 8081 state (active/non optimized)
      target port descriptor 2:
        port group 8090 state (active/optimized)
      target port descriptor 3:
        port group 8091 state (active/optimized)
  descriptor 1:
    target port descriptors: 4
    user data segment: first lba 2752512, last lba 8257535
      target port descriptor 0:
        port group 8080 state (active/optimized)
      target port descriptor 1:
        port group 8081 state (active/optimized)
      target port descriptor 2:
        port group 8090 state (active/non optimized)
      target port descriptor 3:
        port group 8091 state (active/non optimized)
  descriptor 2:
    target port descriptors: 4
    user data segment: first lba 8257536, last lba 11010047
      target port descriptor 0:
        port group 8080 state (active/non optimized)
      target port descriptor 1:
        port group 8081 state (active/non optimized)
      target port descriptor 2:
        port group 8090 state (active/optimized)
      target port descriptor 3:
        port group 8091 state (active/optimized)
...

The first descriptor covers 1344 MB; the second twice as much.
On a full volume the smallest size was 1344MB and few descriptors
covered multiple of it.
After running a rebalance operation on the storage the layout partially
changed

Report referrals:
  descriptor 0:
    target port descriptors: 4
    user data segment: first lba 0, last lba 2752511
      target port descriptor 0:
        port group 8080 state (active/optimized)
      target port descriptor 1:
        port group 8081 state (active/optimized)
      target port descriptor 2:
        port group 8090 state (active/non optimized)
      target port descriptor 3:
        port group 8091 state (active/non optimized)
  descriptor 1:
    target port descriptors: 4
    user data segment: first lba 2752512, last lba 5505023
      target port descriptor 0:
        port group 8080 state (active/non optimized)
      target port descriptor 1:
        port group 8081 state (active/non optimized)
      target port descriptor 2:
        port group 8090 state (active/optimized)
      target port descriptor 3:
        port group 8091 state (active/optimized)
  descriptor 2:
    target port descriptors: 4
    user data segment: first lba 5505024, last lba 8257535
      target port descriptor 0:
        port group 8080 state (active/optimized)
      target port descriptor 1:
        port group 8081 state (active/optimized)
      target port descriptor 2:
        port group 8090 state (active/non optimized)
      target port descriptor 3:
        port group 8091 state (active/non optimized)
  descriptor 3:
    target port descriptors: 4
    user data segment: first lba 8257536, last lba 11010047
      target port descriptor 0:
        port group 8080 state (active/non optimized)
      target port descriptor 1:
        port group 8081 state (active/non optimized)
      target port descriptor 2:
        port group 8090 state (active/optimized)
      target port descriptor 3:
        port group 8091 state (active/optimized)
...

Is there currently a way to get notified on such changes? If we start with
a single mapping we need a way to trigger a (re-)discovery/modification. 

> And then you would have several multipath devices (all referring to 
> the same disk), one for each supported referrals ALUA configuration.
> The linear target would then map each chunk to the correct multipath 
> device.

I assume the above configuration would require two multipath devices;
one for

      target port descriptor 0:
        port group 8080 state (active/optimized)
      target port descriptor 1:
        port group 8081 state (active/optimized)
      target port descriptor 2:
        port group 8090 state (active/non optimized)
      target port descriptor 3:
        port group 8091 state (active/non optimized)

and a second for

      target port descriptor 0:
        port group 8080 state (active/non optimized)
      target port descriptor 1:
        port group 8081 state (active/non optimized)
      target port descriptor 2:
        port group 8090 state (active/optimized)
      target port descriptor 3:
        port group 8091 state (active/optimized)

> It'll be a beast for failover, but should be possible.
> And maybe it's better to use dm-switch here; the number or referrals 
> might overflow dm-linear ...

Does dm-switch work with different chunk sizes? Is there a theoretical or
practical limit for dm-linear? My 100 GB device consists of 62 descriptors.
 
> Cheers,
> 
> Hannes

Sebastian
