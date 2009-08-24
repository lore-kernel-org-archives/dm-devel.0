From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 13:24:57 -0700
Message-ID: <1251145497.24406.18.camel@chandra-ubuntu>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
	<20090824202915.27815959@pc-jsosic.srce.hr>
	<1251139716.24406.4.camel@chandra-ubuntu>
	<20090824205933.4b4c8456@pc-jsosic.srce.hr>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090824205933.4b4c8456@pc-jsosic.srce.hr>
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

Have you verified there is no physical issues with the path ?

On Mon, 2009-08-24 at 20:59 +0200, Jakov Sosic wrote:
> On Mon, 24 Aug 2009 11:48:36 -0700
> Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> 
> > This is the expected behavior, when IOs on the active path fails, the
> > hardware handler will activate the passive path and make it active and
> > start sending IOs thru that newly activated path.
> > 
> > Send MODE_SELECT is how the hardware handler makes the passive path
> > active. 
> 
> Yes, I am aware of the multipathing and switching in case of failure -
> but what is bugging me is why is it happening so often? Or can I be
> more precise - why is it happening CONSTANTLY? 
> 
> 
> 
