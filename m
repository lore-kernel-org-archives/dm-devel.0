From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: I/O Reordering: Cache -> Backing Device
Date: Sat, 6 Jul 2019 01:07:15 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1907060102450.12361@mx.ewheeler.net>
References: <BYAPR14MB27766E20D92C2A07217C2DF9FCFC0@BYAPR14MB2776.namprd14.prod.outlook.com>
	<d06e4a83-c314-46b7-72ea-97e455acd69f@suse.de>
	<BYAPR14MB277641CB1C17C53346C8FDD5FCF90@BYAPR14MB2776.namprd14.prod.outlook.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1690155773-992976465-1562375051=:12361"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BYAPR14MB277641CB1C17C53346C8FDD5FCF90@BYAPR14MB2776.namprd14.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Don Doerner <Don.Doerner@Quantum.Com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, dm-devel@redhat.com, Coly Li <colyli@suse.de>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1690155773-992976465-1562375051=:12361
Content-Type: TEXT/PLAIN; CHARSET=ISO-2022-JP

[+cc dm-devel]

> -----Original Message-----
> From: linux-bcache-owner@vger.kernel.org <linux-bcache-owner@vger.kernel.org> On Behalf Of Coly Li
> Sent: Sunday, 30 June, 2019 19:24
> To: Don Doerner <Don.Doerner@Quantum.Com>
> Cc: linux-bcache@vger.kernel.org
> Subject: Re: I/O Reordering: Cache -> Backing Device
> 
> On 2019/6/29 5:56 上午, Don Doerner wrote:
> > Hello, I'm also interested in using bcache to facilitate stripe 
> > re-ass'y for the backing device.  I've done some experiments that 
> > dovetail with some of the traffic on this mailing list.  
> > Specifically, in this message 
> > (https://nam05.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.spinics.net%2Flists%2Flinux-bcache%2Fmsg07590.html&amp;data=02%7C01%7CDon.Doerner%40quantum.com%7Cafa50dd04a914f76bb7808d6fdcb338b%7C322a135f14fb4d72aede122272134ae0%7C1%7C0%7C636975446529502069&amp;sdata=nC3JhPL%2FC6B57uw4xjEkGnV48jd9DqHLf0MQL7AAErs%3D&amp;reserved=0), 
> > Eric suggested "...turning up 
> > /sys/block/bcache0/bcache/writeback_percent..." to increase the 
> > contiguous data in the cache.
> > My RAID-6 has a stripe size of 2.5MiB, and its bcache'ed with a few 
> > hundred GB of NVMe storage.  Here's my experiment:
> > * I made the cache a write back cache: echo writeback >
> > /sys/block/bcache0/bcache/cache_mode
> > * I plugged the cache: echo 0 >
> > /sys/block/bcache0/bcache/writeback_running
> > * I use a pathological I/O pattern, generated with 'fio': fio 
> >   --bs=128K --direct=1 --rw=randwrite --ioengine=libaio --iodepth=1 
> >   --numjobs=1 --size=40G --name=/dev/bcache0.  I let it run to 
> >   completion, at which point I believe I should have 40 GiB of 
> >   sequential dirty data in cache, but not put there sequentially.  In 
> >   essence, I should have ~16K complete stripes sitting in the cache, 
> >   waiting to be written.
> > * I set stuff up to go like a bat: echo 0 >
> > /sys/block/bcache0/bcache/writeback_percent; echo 0 >
> > /sys/block/bcache0/bcache/writeback_delay; echo 2097152 >
> > /sys/block/bcache0/bcache/writeback_rate
> > * And I unplugged the cache: echo 1 >
> > /sys/block/bcache0/bcache/writeback_running
> > I then watched 'iostat', and saw that there were lots of read operations (statistically, after merging, about 1 read for every 7 writes) - more than I had expected... that's enough that I concluded it wasn't building full stripes.  It kinda looks like it's playing back a journal sorted in time then LBA, or something like that...
> > Any suggestions for improving (reducing) the ratio of reads to writes will be gratefully accepted!
> 
> Hi Don,
> 
> If the backing device has expensive stripe cost, the upper layer should 
> issue I/Os with stripe size alignment, otherwise bcache cannot to too 
> much to make the I/O to be stripe optimized.
> 
> And you are right that bcache does not writeback in restrict LBA order, 
> this is because the internal btree is trend to be appended only. The LBA 
> ordering writeback happens in a reasonable small range, not in whole 
> cached data, see commit 6e6ccc67b9c7 ("bcache: writeback: properly order 
> backing device IO").
> 
> And I agree with you again that "improving (reducing) the ratio of reads 
> to writes will be gratefully accepted". Indeed not only reducing reads 
> to writes ratio, but also increase the reads to writes throughput. This 
> is something I want to improve, after I understand why the problem 
> exists in bcache writeback code ...


dm-devel list:

Does dm-writecache do any attempt to merge IOs into the io_opt size?

If so, bcache might get some ideas by looking at that codebase for its 
writeback thread.

--
Eric Wheeler


> 
> Thanks.
> 
> --
> 
> Coly Li
> The information contained in this transmission may be confidential. Any disclosure, copying, or further distribution of confidential information is not permitted unless such privilege is explicitly granted in writing by Quantum. Quantum reserves the right to have electronic communications, including email and attachments, sent across its networks filtered through security software programs and retain such messages in order to comply with applicable data security and retention requirements. Quantum is not responsible for the proper and complete transmission of the substance of this communication or for any delay in its receipt.
> 
---1690155773-992976465-1562375051=:12361
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


---1690155773-992976465-1562375051=:12361--
