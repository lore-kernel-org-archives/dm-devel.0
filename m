From: Eric Sandeen <sandeen@sgi.com>
Subject: Re: [PATCH] dm.c
Date: Fri, 05 May 2006 09:09:40 -0500
Message-ID: <445B5CA4.8050403@sgi.com>
References: <20060504160048.CA34173C68@hormel.redhat.com>
	<20060505072857.M41283@cn.ee.ccu.edu.tw>
	<200605050845.30546.kevcorry@us.ibm.com>
	<200605050856.44400.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200605050856.44400.kevcorry@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kevin Corry <kevcorry@us.ibm.com>
Cc: dm-devel@redhat.com, m9230 <m9230@cn.ee.ccu.edu.tw>
List-Id: dm-devel.ids

Kevin Corry wrote:
> On Fri May 5 2006 8:45 am, Kevin Corry wrote:
> 
>>I haven't seen an actual patch yet for this bug, so here's one with the
>>suggested fix (against 2.4.31 + device-mapper-1.02.05).
> 
> 
> And just in case it's easier for the DM guys, here's the same fix as a patch 
> against linux-2.4.28-pre4-devmapper-ioctl.patch from device-mapper-1.02.05.
> 


Kevin, looks right to me.

There's maybe a bit of extra casting left in the BLKGETSIZE64: case, but harmless.

And thanks for the attribution, I hope I didn't come across as -too- surly on
that topic. ;-)

And now xfs+evms users should be happy!

-Eric
