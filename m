From: Matthias Dahl <ml_linux-kernel@binary-island.eu>
Subject: Re: Page Allocation Failures/OOM with dm-crypt on software RAID10
 (Intel Rapid Storage)
Date: Tue, 12 Jul 2016 14:42:12 +0200
Message-ID: <e6c2087730e530e77c2b12d50495bdc9@mail.ud19.udmedia.de>
References: <02580b0a303da26b669b4a9892624b13@mail.ud19.udmedia.de>
 <20160712095013.GA14591@dhcp22.suse.cz>
 <d9dbe0328e938eb7544fdb2aa8b5a9c7@mail.ud19.udmedia.de>
 <20160712114920.GF14586@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160712114920.GF14586@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hello Michal...

On 2016-07-12 13:49, Michal Hocko wrote:

> I am not a storage expert (not even mention dm-crypt). But what those
> counters say is that the IO completion doesn't trigger so the
> PageWriteback flag is still set. Such a page is not reclaimable
> obviously. So I would check the IO delivery path and focus on the
> potential dm-crypt involvement if you suspect this is a contributing
> factor.

Sounds reasonable... except that I have no clue how to trace that with
the limited means I have at my disposal right now and with the limited
knowledge I have of the kernel internals. ;-)

> Who is consuming those objects? Where is the rest 70% of memory hiding?

Is there any way to get a more detailed listing of where the memory is
spent while dd is running? Something I could pipe every 500ms or so for
later analysis or so?

> Writer will get throttled but the concurrent memory consumer will not
> normally. So you can end up in this situation.

Hm, okay. I am still confused though: If I, for example, let dd do the
exact same thing on a raw partition on the RAID10, nothing like that
happens. Wouldn't we have the same race and problem then too...? It is
only with dm-crypt in-between that all of this shows itself. But I do
somehow suspect the RAID10 Intel Rapid Storage to be the cause or at
least partially.

Like I said, if you have any pointers how I could further trace this
or figure out who is exactly consuming what memory, that would be very
helpful... Thanks.

So long,
Matthias

-- 
Dipl.-Inf. (FH) Matthias Dahl | Software Engineer | binary-island.eu
  services: custom software [desktop, mobile, web], server administration

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
