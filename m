From: Jakov Sosic <jakov.sosic@srce.hr>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Sun, 23 Aug 2009 21:34:48 +0200
Message-ID: <20090823213448.154d6cff@nb-jsosic>
References: <20090823210536.4730636d@nb-jsosic>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090823210536.4730636d@nb-jsosic>
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

On Sun, 23 Aug 2009 21:05:36 +0200
Jakov Sosic <jakov.sosic@srce.hr> wrote:

> Hi!
> 
> I have StorageTek 2530 storage, which has two controllers. On host
> side I have LSI LOGIC two SAS port cards. I've connected one cable
> from LSI port1 to StorageTek ControllerA, and second SAS cable from
> LSI port2 to StorageTek ControllerB.


OK. I've solved it - it seems that Linux host type in initiator
configuration is not turning on AVT on controllers. Instead, I had to
choose "Solaris (with Veritas DMP or other)", and now everything works!



Thank you, and hope this helps to others too.

-- 
|    Jakov Sosic    |    ICQ: 28410271    |   PGP: 0x965CAE2D   |
=================================================================
| start fighting cancer -> http://www.worldcommunitygrid.org/   |
