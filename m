From: Tore Anderson <tore@linpro.no>
Subject: Re: rdac mode on SLES10SP1
Date: Tue, 11 Sep 2007 10:12:14 +0200
Message-ID: <46E64DDE.7040705@linpro.no>
References: <OF7370E75F.A98D07BF-ONC1257353.002B4C4D-C1257353.002B6A87@amadeus.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF7370E75F.A98D07BF-ONC1257353.002B4C4D-C1257353.002B6A87@amadeus.com>
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

* Kirill Cherkashin

> Could you advise me on next matter.
> We have DS4800 connected to SLES10&9. At the moment we're using 'native'
> IBM  rdac driver but we're going to soon jump to Linux mpio.
> According to Novell's support site in SP1(with kernel 2.6.16)  MPIO
> would be supported by in rdac mode.
> 
> 
> However, here I found  that it should happened only with 2.6.23 kernel.

  The RDAC hardware handler is included (in a usable form) in the
 kernel.org kernels starting from 2.6.23-rc4, if I recall correctly.

  I assume SuSE has simply backported it to their 2.6.16 kernel.  I know
 Red Hat has done the same for RHEL5.1, at least.

-- 
Tore Anderson
