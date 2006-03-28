From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: Re: [PATCH] dm-striped device sizes must be multiple
	of chunk-size
Date: Tue, 28 Mar 2006 14:15:54 +0200
Message-ID: <20060328121554.GC3218@redhat.com>
References: <e3538fbd0603222128o525b4608h84b4004fc4ca0a61@mail.gmail.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e3538fbd0603222128o525b4608h84b4004fc4ca0a61@mail.gmail.com>
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


Joseph,

can you send me the tar-archive of your metadata

	dmraid -rD
	tar jcvf isw-Joseph_Yasi-raid0.tar.bz2 *.{dat,size,offset)

for reference, please.

Heinz


On Wed, Mar 22, 2006 at 11:28:22PM -0600, Joseph Yasi wrote:
> Hello,
> 
>     I am using the dmraid utility to detect and configure my Intel
> Software Raid RAID0 array.  When upgrading to 2.6.16 from 2.6.15, the
> system failed to boot because the device-mapper array was not built. 
> I have traced the problem to this patch that limits dm-stripe to
> targets that are multiples of the chunk size.  I don't know whether to
> consider this a problem with device-mapper or with the Intel Software
> Raid BIOS that built the array.  Dmraid is giving me a target of
> 980460038 blocks with a chunk size of 256 blocks.  Is this a problem
> with device-mapper, the dmraid utility or the raid bios?  Should
> device-mapper handle striped targets that are not multiples of the
> chunk size?
> 
> Thank You,
> Joe Yasi
> 
> dmesg gives these pertinent lines:
> device-mapper: dm-stripe: Target length not divisible by chunk size.
> device-mapper: error adding target to table.
> 
> dmsetup status
> isw_caejhbcidd_Volume03: 0 976173660 linear
> isw_caejhbcidd_Volume02: 0 4209030 linear
> isw_caejhbcidd_Volume01: 0 64197 linear
> isw_caejhbcidd_Volume0: 0 980460038 striped
> 
> dmraid -s
> *** Group superset isw_caejhbcidd
> --> Active Subset
> name   : isw_caejhbcidd_Volume0
> size   : 980460038
> stride : 256
> type   : stripe
> status : ok
> subsets: 0
> devs   : 2
> spares : 0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Storage Development                               56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            PHONE +49  171 7803392
                                                  FAX   +49 2626 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
