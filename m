From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: multipathing Sun 6140
Date: Fri, 13 Jun 2008 10:32:59 -0700
Message-ID: <1213378379.7031.138.camel@chandra-ubuntu>
References: <484705D1.6080200@provectis.cl>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <484705D1.6080200@provectis.cl>
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
Cc: julio.pacheco@provectis.cl
List-Id: dm-devel.ids


On Wed, 2008-06-04 at 17:14 -0400, Gustavo Riveros wrote:
> Hi dm-developers,
> 
> I'm having problem with multipathing device-mapper with my linux server, 
> but this was resolved by Thread "multipathing flip flopping on Sun 6140" 
> very well 
> (http://www.redhat.com/archives/dm-devel/2007-August/msg00066.html)
> 
> The configuration is the same:
> 
> X4600 Server
> 2 HBA's Emulex
> SAN STK6140
> 
> but in dmesg i have the following error message:
> 
> Buffer I/0 error on device sdf, logical block 0
> end_request: I/0 error, dev sdf, sector 0
> 
> Did you know the error message?

This is the error message that is printed when the lun is accesses thru
the passive paths. These are _not_ a problem.

They will not appear if all the access to the luns are thru the dm
devices (in which case you will see these only during device probing
time.

I am pushing a set of patches (currently in -mm, and hopefully will get
into 2.6.27) that will get rid of these messages.

> 
> Thanks,
> Gustavo Riveros
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
