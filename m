From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC][PATCH] dm-mirror: fix data corruption
Date: Mon, 31 Aug 2009 17:39:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908311737090.16318@hs20-bc2-1.build.redhat.com>
References: <4A568333.6090901@redhat.com>
	<Pine.LNX.4.64.0907100939060.568@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0907100947320.2450@hs20-bc2-1.build.redhat.com>
	<4A5790C5.90508@redhat.com>
	<Pine.LNX.4.64.0907130547530.27968@hs20-bc2-1.build.redhat.com>
	<20090830192441.GA641@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090830192441.GA641@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: malahal@us.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On Sun, 30 Aug 2009, malahal@us.ibm.com wrote:

> Mikulas Patocka [mpatocka@redhat.com] wrote:
> > 
> > > How do bios queued in ms->failures are processed later? It seems that
> > > the bios stay in ms->failures forever, and the upper layer can not
> > > receive "success" for those bios. Don't we need a mechanism to block/unblock
> > > write bios to fix this issue?
> > 
> > They are resubmitted with DM_ENDIO_REQUEUE on noflush suspend. My patch 
> > has a bug that they aren't --- but I will provide a better patch, also 
> > without this periodic polling of ms->failures queue.
> 
> Trying to verify this patch. Mikulas, did you provide a better patch
> yet? Does this patch work at all?
> 
> I would like to verify if this patch works with devices that fail
> temporarily. I will plan on using dm-flakey devices for testing purposes.
> 
> Thanks, Malahal.

Hi

I uploaded patches for this bug at: 
http://people.redhat.com/mpatocka/patches/kernel/mirror-race/

But note! They were never tried. When I wanted to try them, I found out 
that dmeventd is totally nonworking in upstream code (it doesn't pass 
"handle_errors" argument and has some crashes and signal errors), so I 
didn't test them with dmeventd. Dmeventd must be fixed first, then we can 
work on this bug.

Mikulas
