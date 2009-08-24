From: Jakov Sosic <jakov.sosic@srce.hr>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 17:48:34 +0200
Message-ID: <20090824174834.35a7038f@pc-jsosic.srce.hr>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
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

On Mon, 24 Aug 2009 11:41:34 -0400 (EDT)
Charlie Brady <charlieb-dm-devel@budge.apana.org.au> wrote:

> I know that other people here will know more detail, but I think you
> have another alternative which might be superior.
> 
> Instead of changing the initiator configuration to use AVT, you
> should tune the device mapper to use RDAC.
> 
> To do that, I think you will need to adjust both the multipathd 
> configuration and recompile the scsi_dh_rdac kernel module after
> adding support for "SUN"/"LCSM100_S".
> 
> Here's the RDAC multipath.conf I am using with a StorageTek 2510:
> 
> http://www.linux-archive.org/device-mapper-development/323661-multipathd-configuration-sun-storagetek-2510-a.html

Thank you!

The problem is I use XEN kernel from CentOS and I really don't want to
mess up with manual compilation of every new kernel that comes out...

Do you know if RedHat incorporated this patch already?

If not, I'll keep up with AVT - it seems that works OK. Some paths fail
every now and then but are back online in just a couple of seconds, and
that is currently OK.



-- 
|    Jakov Sosic    |    ICQ: 28410271    |   PGP: 0x965CAE2D   |
=================================================================
| start fighting cancer -> http://www.worldcommunitygrid.org/   |
