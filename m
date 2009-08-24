From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 18:58:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908241852270.21130@e-smith.charlieb.ott.istop.com>
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
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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


On Mon, 24 Aug 2009, Jakov Sosic wrote:

> On Mon, 24 Aug 2009 13:44:34 -0700
> Chandra Seetharaman <sekharan@us.ibm.com> wrote:
>
>> ok.. simple words; That patch won't help you.
>
> hm :( so defining "SUN" "LCMS100_S" won't help? Although in
> scsi_dh_rdac only "SUN" "LCMS100_F" is defined. And that stands for
> Fiber, while mine is SAS cabling...

Chandra says that the patch won't help you. Perhaps he can clarify. My 
understanding is that if you configure multipath to use RDAC that the 
driver does have to be patched so that the RDAC handler will be used. I 
did find that to be the case with the StorageTek 2510 "LCMS100_I").

My understanding also is that RDAC is superior, so RDAC hander support is 
desirable.

> I've recompiled RPM with added patch, then extracted single module
> (scsi_dh_rdac.ko), and put it in place of the original module...
>
> FATAL: Error inserting scsi_dh_rdac
> (/lib/modules/2.6.18-128.4.1.el5xen/kernel/drivers/scsi/device_handler/scsi_dh_rdac.ko):
> Invalid module format
>
> I guess I'll have to build the whole kernel just because of this :(

No, it is certainly possible to build an RPM which contains just the 
module that you need. But you do need to build correctly.

I did make the suggestion earlier that it would be useful if the module 
could take load-time parameters to add support for additional devices. I 
think it was Chandra who agreed that was a good idea and he would add it 
to the TODO list, but neither he nor I has done that yet.

>> This is uncalled for!!
>
> Sorry, I'm easily flammable...

You would be wise to control your urges, if you wish people to help you.
