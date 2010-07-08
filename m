From: Bart Coninckx <bart.coninckx@telenet.be>
Subject: Re: understanding of multipathing and speed
Date: Thu, 8 Jul 2010 08:35:39 +0200
Message-ID: <201007080835.39825.bart.coninckx@telenet.be>
References: <201007052037.39362.bart.coninckx@telenet.be>
	<201007072301.48042.bart.coninckx@telenet.be>
	<1278540399.3454.18.camel@newgen.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1278540399.3454.18.camel@newgen.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Brem Belguebli <brem.belguebli@gmail.com>
List-Id: dm-devel.ids

On Thursday 08 July 2010 00:06:39 Brem Belguebli wrote:

> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://www.redhat.com/mailman/listinfo/dm-devel
> >
> > Maybe adding this one while doing a test with both paths active during
> > "off hours", so no other intrusive factors:
> >
> > Version 1.03e       ------Sequential Output------ --Sequential Input- --
> > Random-
> >                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --
> > Seeks--
> > Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
> > /sec %CP
> > xen3             8G 66510  93 80841  21 26821   1 45368  58 72095   2
> > 361.2 0
> >                     ------Sequential Create------ --------Random
> > Create--------
> >                     -Create-- --Read--- -Delete-- -Create-- --Read--- -
> > Delete--
> >               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
> > /sec %CP
> >                  16  5295  98 +++++ +++ +++++ +++  5318  98 +++++ +++
> > 17089 100
> > xen3,8G,66510,93,80841,21,26821,1,45368,58,72095,2,361.2,0,16,5295,98,+++
> >++, +++,+++++,+++,5318,98,+++++,+++,17089,100
> >
> >
> > it show that the speed is exactly 70% of the speed when doing tests
> > locally. So this might be the iSCSI TCP overhead.
> >
> > Should the speed of two round robin paths not compensate for this loss?
> > Or is my local storage just to slow to have multipath having any benefit
> > speed wise?
> 
> To calculate your theoretical TCP throughput, a simple formula can be
> applied : TP= TCP Window size / RTT
> 
> In addition to this generally, you can take advantage of path
> load-balancing IO's to capable to multiplex IO's devices , such as SAN
> arrays with cache frontend.
> Trying to load-balance on a single physical device, won't be, IMHO, of
> any help except for pure failover purposes.
> 
> > thx!
> >
> > B.
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

Hi Brem,

are you talking about storage with a sort of built-in active/active storage 
cluster? Do you think I don't have added speed because if the fact that both 
iSCSI targets point to the same storage device?


thx!!
Bart
