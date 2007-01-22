From: "roland" <devzero@web.de>
Subject: Re: bug in dm-loop? - was:Re: Re: device mapper
	integrated loops - and one more year !
Date: Mon, 22 Jan 2007 23:42:25 +0100
Message-ID: <087b01c73e76$9ccf68d0$eeeea8c0@aldipc>
References: <1574903375@web.de> <45B48B50.8070009@redhat.com>
	<083901c73e70$ccd85f60$eeeea8c0@aldipc>
	<45B53655.1040209@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="ISO-8859-15";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <breeves@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> The current development version allocates these structures piecemeal, so
> there isn't a single large allocation, rather many small allocations -
> this will make problems like this go away (unless you really are out of
> memory!).
ok, i`ll wait for this.

> You're particularly likely to see these problems with large images such
> as DVD ISOs, as the number of entries in the lookup table is
> proportional to the size of the image and the degree of fragmentation of
> the filesystem on which it is stored.
uuuhhhhh - mhhhh - this sounds bad, since the testfiles i created were all 
sized 100k each.
i think i need to attach a big disk and create some more big files to test 
with....

> Thanks again for testing!
you`re welcome!

thanks for making dm-loop!
:)

roland
