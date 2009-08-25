From: Jakov Sosic <jakov.sosic@srce.hr>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Tue, 25 Aug 2009 23:09:40 +0200
Message-ID: <20090825230940.4bf67ba0@nb-jsosic>
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
	<1251223635.2166.7.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0908251421010.21130@e-smith.charlieb.ott.istop.com>
	<1251230131.2166.13.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0908251634110.21130@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0908251634110.21130@e-smith.charlieb.ott.istop.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 25 Aug 2009 16:51:34 -0400 (EDT)
Charlie Brady <charlieb-dm-devel@budge.apana.org.au> wrote:

> I did look at the RHEL 5.4 beta, and there are other updates
> mentioned in changelog there:
> 
> * Wed May 20 2009 Don Zickus <dzickus@redhat.com> [2.6.18-150.el5]
> ...
> - [scsi] Retry mode select in rdac device handler (Jesse Larrew )
> [489582] ...
> * Fri May 01 2009 Don Zickus <dzickus@redhat.com> [2.6.18-143.el5]
> ...
> - [scsi] add md3000 and md3000i entries to rdac_dev_list (John
> Feeney ) [487293]
> ...
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=487293
> 
> Jacov, you might want to look at the above bugzilla. There is some 
> discussion of failover behaviour which might be useful to you.

Thank you, I'll take a look...


OK, I've noticed the following:

Feb 25 11:29:55 rhel5r300 multipathd: 8:16: reinstated
Feb 25 11:29:55 rhel5r300 multipathd: 8:32: reinstated
Feb 25 11:29:55 rhel5r300 multipathd: 8:48: reinstated
Feb 25 11:29:55 rhel5r300 multipathd: 8:64: reinstated


How often are these messages supposed to repeat? Because I've succeded
with one combination of HostType in StorageTek 2530 configuration for
initiators, and RDAC on the Linux side. But I had messages like these
every few minutes in /var/log/messages.


-- 
|    Jakov Sosic    |    ICQ: 28410271    |   PGP: 0x965CAE2D   |
=================================================================
| start fighting cancer -> http://www.worldcommunitygrid.org/   |
