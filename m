From: Jakov Sosic <jakov.sosic@srce.hr>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Tue, 25 Aug 2009 02:06:19 +0200
Message-ID: <20090825020619.654f7fce@pc-jsosic.srce.hr>
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
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090825011340.423e3cf6@pc-jsosic.srce.hr>
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

On Tue, 25 Aug 2009 01:13:40 +0200
Jakov Sosic <jakov.sosic@srce.hr> wrote:

> You were saying that you could provide some debugging code if I'm
> interested? Well it seems that I don't have a choice... So please do
> so :)

Also, I've found that Sun provides RDAC driver for 2.6 kernels... I
brings whole framework, with config files and additional commands...

I don't like the idea, but because neither the AVT neither the RDAC on
dm-multipath are working correctly, I'll try the Sun RDAC solution
tommorow and post the results.

Here is the explanation (and link to source is within the document):
http://dlc.sun.com/pdf/820-4738-12/820-4738-12.pdf




-- 
|    Jakov Sosic    |    ICQ: 28410271    |   PGP: 0x965CAE2D   |
=================================================================
| start fighting cancer -> http://www.worldcommunitygrid.org/   |
