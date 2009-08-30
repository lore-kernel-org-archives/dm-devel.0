From: malahal@us.ibm.com
Subject: Re: [RFC][PATCH] dm-mirror: fix data corruption
Date: Sun, 30 Aug 2009 12:24:41 -0700
Message-ID: <20090830192441.GA641@us.ibm.com>
References: <4A568333.6090901@redhat.com>
	<Pine.LNX.4.64.0907100939060.568@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0907100947320.2450@hs20-bc2-1.build.redhat.com>
	<4A5790C5.90508@redhat.com>
	<Pine.LNX.4.64.0907130547530.27968@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907130547530.27968@hs20-bc2-1.build.redhat.com>
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
Cc: mpatocka@redhat.com
List-Id: dm-devel.ids

Mikulas Patocka [mpatocka@redhat.com] wrote:
> 
> > How do bios queued in ms->failures are processed later? It seems that
> > the bios stay in ms->failures forever, and the upper layer can not
> > receive "success" for those bios. Don't we need a mechanism to block/unblock
> > write bios to fix this issue?
> 
> They are resubmitted with DM_ENDIO_REQUEUE on noflush suspend. My patch 
> has a bug that they aren't --- but I will provide a better patch, also 
> without this periodic polling of ms->failures queue.

Trying to verify this patch. Mikulas, did you provide a better patch
yet? Does this patch work at all?

I would like to verify if this patch works with devices that fail
temporarily. I will plan on using dm-flakey devices for testing purposes.

Thanks, Malahal.
