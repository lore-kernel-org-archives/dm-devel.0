From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Tue, 25 Aug 2009 16:51:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908251634110.21130@e-smith.charlieb.ott.istop.com>
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
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1251230131.2166.13.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Tue, 25 Aug 2009, Chandra Seetharaman wrote:

> I try to keep the latest releases of RHEL and SLES by porting and test
> them.
>
> These changes are ported to RHEL 5.4, and will be available.

They appear not to be in RHEL5.3. The only mention of rdac I see in the 
changelog of 2.6.18-128.4.1.el5 is this one:

* Fri Sep 12 2008 Don Zickus <dzickus@redhat.com> [2.6.18-112.el5]
...
- [scsi] scsi_dh: add rdac handler (mchristi@redhat.com ) [438761]
...

https://bugzilla.redhat.com/show_bug.cgi?id=438761

I did look at the RHEL 5.4 beta, and there are other updates mentioned in 
changelog there:

* Wed May 20 2009 Don Zickus <dzickus@redhat.com> [2.6.18-150.el5]
...
- [scsi] Retry mode select in rdac device handler (Jesse Larrew ) [489582]
...
* Fri May 01 2009 Don Zickus <dzickus@redhat.com> [2.6.18-143.el5]
...
- [scsi] add md3000 and md3000i entries to rdac_dev_list (John Feeney ) 
[487293]
...

https://bugzilla.redhat.com/show_bug.cgi?id=487293

Jacov, you might want to look at the above bugzilla. There is some 
discussion of failover behaviour which might be useful to you.

> Do you still want to know which of these you might need (for your 
> system)

Yes I would. Or better, if you see any required patches which are not 
included in RHEL5.4, please let RedHat know (via Bugzilla). I will ask 
them to add support for the StorageTek 2510 and 2530 arrays.

---
Charlie
