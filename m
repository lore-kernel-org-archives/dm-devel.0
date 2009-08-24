From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 14:06:01 -0700
Message-ID: <1251147961.24406.34.camel@chandra-ubuntu>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
	<20090824174834.35a7038f@pc-jsosic.srce.hr>
	<20090824180058.7cc4edcb@pc-jsosic.srce.hr>
	<1251139098.24406.1.camel@chandra-ubuntu>
	<20090824205529.6b78aa3a@pc-jsosic.srce.hr>
	<1251145456.24406.16.camel@chandra-ubuntu>
	<20090824223745.33425c32@pc-jsosic.srce.hr>
	<1251146674.24406.20.camel@chandra-ubuntu>
	<20090824225324.1ee86d9f@pc-jsosic.srce.hr>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090824225324.1ee86d9f@pc-jsosic.srce.hr>
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


On Mon, 2009-08-24 at 22:53 +0200, Jakov Sosic wrote:
> On Mon, 24 Aug 2009 13:44:34 -0700
> Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> 
> > ok.. simple words; That patch won't help you.
> 
> hm :( so defining "SUN" "LCMS100_S" won't help? Although in
> scsi_dh_rdac only "SUN" "LCMS100_F" is defined. And that stands for
> Fiber, while mine is SAS cabling...

Adding this to scsi_dh_rdac makes sure that the module recognizes your
device at boot time itself (provided you have it in your initrd image).
> 
> I've recompiled RPM with added patch, then extracted single module
> (scsi_dh_rdac.ko), and put it in place of the original module...
> 
> FATAL: Error inserting scsi_dh_rdac
> (/lib/modules/2.6.18-128.4.1.el5xen/kernel/drivers/scsi/device_handler/scsi_dh_rdac.ko):
> Invalid module format

Hmm, just that change should cause this. BTW, can you provide the patch
you are trying to add.


Can you also provide the (current) o/p of "multipath -ll" and
current /etc/multipath.conf.

> 
> I guess I'll have to build the whole kernel just because of this :(
> 
> 
> 
> > This is uncalled for!!
> 
> Sorry, I'm easily flammable...

but doesn't help the cause :).. lets stay objective here :)
> 
> 
> 
> 
