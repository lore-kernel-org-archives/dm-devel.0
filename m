From: Michal Hocko <mhocko@kernel.org>
Subject: Re: Page Allocation Failures/OOM with dm-crypt on software RAID10
 (Intel Rapid Storage)
Date: Wed, 13 Jul 2016 13:21:26 +0200
Message-ID: <20160713112126.GH28723@dhcp22.suse.cz>
References: <02580b0a303da26b669b4a9892624b13@mail.ud19.udmedia.de>
 <20160712095013.GA14591@dhcp22.suse.cz>
 <d9dbe0328e938eb7544fdb2aa8b5a9c7@mail.ud19.udmedia.de>
 <20160712114920.GF14586@dhcp22.suse.cz>
 <e6c2087730e530e77c2b12d50495bdc9@mail.ud19.udmedia.de>
 <20160712140715.GL14586@dhcp22.suse.cz>
 <459d501038de4d25db6d140ac5ea5f8d@mail.ud19.udmedia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <459d501038de4d25db6d140ac5ea5f8d@mail.ud19.udmedia.de>
Sender: owner-linux-mm@kvack.org
To: Matthias Dahl <ml_linux-kernel@binary-island.eu>
Cc: linux-raid@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue 12-07-16 16:56:32, Matthias Dahl wrote:
> Hello Michal...
> 
> On 2016-07-12 16:07, Michal Hocko wrote:
> 
> > /proc/slabinfo could at least point on who is eating that memory.
> 
> Thanks. I have made another test (and thus again put the RAID10 out of
> sync for the 100th time, sigh) and made regular snapshots of slabinfo
> which I have attached to this mail.
> 
> > Direct IO doesn't get throttled like buffered IO.
> 
> Is buffered i/o not used in both cases if I don't explicitly request
> direct i/o?
> 
>     dd if=/dev/zero /dev/md126p5 bs=512K
> and dd if=/dev/zero /dev/mapper/test-device bs=512K

OK, I misunderstood your question though. You were mentioning the direct
IO earlier so I thought you were referring to it here as well.
 
> Given that the test-device is dm-crypt on md125p5. Aren't both using
> buffered i/o?

Yes they are.

> > the number of pages under writeback was more or less same throughout
> > the time but there are some local fluctuations when some pages do get
> > completed.
> 
> The pages under writeback are those directly destined for the disk, so
> after dm-crypt had done its encryption?

Those are submitted for the IO. dm-crypt will allocate a "shadow" page
for each of them to perform the encryption and only then submit the IO
to the storage underneath see
http://lkml.kernel.org/r/alpine.LRH.2.02.1607121907160.24806@file01.intranet.prod.int.rdu2.redhat.com

> > If not you can enable allocator trace point for a particular object
> > size (or range of sizes) and see who is requesting them.
> 
> If that support is baked into the Fedora provided kernel that is. If
> you could give me a few hints or pointers, how to properly do a allocator
> trace point and get some decent data out of it, that would be nice.

You need to have a kernel with CONFIG_TRACEPOINTS and then enable them
via debugfs. You are interested in kmalloc tracepoint and specify a size
as a filter to only see those that are really interesting. I haven't
checked your slabinfo yet - hope to get to it later today.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
