From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache failure semantics in write-back mode
Date: Tue, 3 Mar 2015 16:19:36 +0000
Message-ID: <20150303161935.GA23166@debian>
References: <CAM2wQBtW2Bit2rx-1+hngUyh1gObtt+vjWQkDVWcTfm=axCyDw@mail.gmail.com>
	<CAM2wQBsGay5cnTR+CO_BpSL8SiYiaQm-MnWFDQC_hG1AH3PcQw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAM2wQBsGay5cnTR+CO_BpSL8SiYiaQm-MnWFDQC_hG1AH3PcQw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thanos Makatos <thanos.makatos@onapp.com>
Cc: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 03, 2015 at 03:53:39PM +0000, Thanos Makatos wrote:
> On Tue, Feb 17, 2015 at 12:15 PM, Thanos Makatos <thanos.makatos@onapp.com>
> wrote:
> 
> > Hi,
> >
> > I'm trying to understand the failure semantics of dm-cache in write-back
> > mode. In Documentation/device-mapper/cache.txt it is stated:
> >
> > "On-disk metadata is committed every time a FLUSH or FUA bio is written.
> > If no such requests are made then commits will occur every second.  This
> > means the cache behaves like a physical disk that has a volatile write
> > cache.  If power is lost you may lose some recent writes.  The metadata
> > should always be consistent in spite of any crash."
> >
> > Which I admit confuses me. Assumie that no FLUSH/FUA requerst is issued
> > (e.g. the user of the cached device is a Windows VM) and a failure occurs
> > (e.g. there is a power failure but both the HDD and the SSD are fine)
> > immediatelly after a write I/O request, but before on-disk metadata get
> > commited (e.g. the failure occurs less than a second after the write I/O
> > request was completed). After the hosts reboots, is this completed write
> > I/O request going to be lost?
> >
> 
> I haven't gotten any reply to this so I'll try to rephrase: If the user of
> the cache doesn't issue FLUSH/FUA, is there a chance of (irreversible) data
> loss in the event of a kernel crash or power failure?

If the mappings change, ie. something is promoted to the cache, or
demoted from it.  Then the metadata update is committed and updated
before the triggering io is issued.

So power failure will not result in loss of a mapping, it may result
in loss of data if your physical device has a write cache.  But this
is also the case with the cache.

- Joe
