From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Tue, 25 Aug 2009 11:07:15 -0700
Message-ID: <1251223635.2166.7.camel@chandra-ubuntu>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
	<20090824202915.27815959@pc-jsosic.srce.hr>
	<1251139716.24406.4.camel@chandra-ubuntu>
	<20090824205933.4b4c8456@pc-jsosic.srce.hr>
	<1251145497.24406.18.camel@chandra-ubuntu>
	<20090824223627.6e1a918c@pc-jsosic.srce.hr>
	<1251147451.24406.28.camel@chandra-ubuntu>
	<20090824231416.598ecc11@pc-jsosic.srce.hr>
	<1251150116.24406.37.camel@chandra-ubuntu>
	<20090824235347.4b8cbd8a@pc-jsosic.srce.hr>
	<1251155242.24406.57.camel@chandra-ubuntu>
	<20090825011340.423e3cf6@pc-jsosic.srce.hr>
	<1251159536.2166.3.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0908242335310.1267@e-smith.charlieb.ott.istop.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0908242335310.1267@e-smith.charlieb.ott.istop.com>
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

Hopefully not :)... it has been fixed for a while.

Jacov, Can you send me the scsi_dh_rdac.c file. I want to make sure you
are running the latest code.

On Mon, 2009-08-24 at 23:36 -0400, Charlie Brady wrote:
> On Mon, 24 Aug 2009, Chandra Seetharaman wrote:
> 
> > On Tue, 2009-08-25 at 01:13 +0200, Jakov Sosic wrote:
> >> On Mon, 24 Aug 2009 16:07:22 -0700
> >> Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> >>
> >>> scsi_dh_rdac modules is insmodded by multipath when multipathd is
> >>> started (by virtue of you having hardware_handler "1 rdac" in
> >>> your /etc/muliutpath.conf file.
> >>>
> >>> So, it is effective when multipath starts.
> >>
> >> If it is effective, I don't need to patch it... Thank you very much.
> >>
> >> You were saying that you could provide some debugging code if I'm
> >> interested? Well it seems that I don't have a choice... So please do
> >> so :)
> >>
> > Basically I want to find out if we are getting and sense codes that we
> > are not handling. To that effect, andd the following line at the top of
> > the function rdac_check_sense()
> > --------
> > sdev_printk(KERN_ERR, sdev, "I/O returned with sense %02x/%02x/%02x",
> >                      sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
> > ---------
> >
> > compile the module, run your tests and get me /var/log/messages.
> 
> Might this be the same issue as you worked through with Babu last October?
> 
> http://kerneltrap.org/mailarchive/linux-scsi/2008/10/24/3803244
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
