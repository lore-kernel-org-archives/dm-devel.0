From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-bufio
Date: Fri, 23 Mar 2012 21:07:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1203232046220.3024@file.rdu.redhat.com>
References: <CALLzPKZyOc+_Pjht8uR6AJOBsMFXQN=y5QWvD0_OZFaYJpvRig@mail.gmail.com>
	<4F6C5A1F.1000103@redhat.com>
	<CALLzPKb+xrQQ-+sOTY0-MHbfVDkgvY2TYqmpP0Mqi7XwD4iEDg@mail.gmail.com>
	<CALLzPKYkLXz0iZPwSbw268w1dkQtvjgoX19aVTK6cEAgt5L50g@mail.gmail.com>
	<Pine.LNX.4.64.1203231213320.17386@file.rdu.redhat.com>
	<CALLzPKZ8b5Pd_GVRDzxNcBLzE=D9yAZ+fbhGiWKvi=E1oXcOMg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CALLzPKZ8b5Pd_GVRDzxNcBLzE=D9yAZ+fbhGiWKvi=E1oXcOMg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Sat, 24 Mar 2012, Kasatkin, Dmitry wrote:

> Hi,
> 
> Thanks for clarification.
> Indeed everything works just with dm_bufio_write_dirty_buffers().
> Reboot notifier is to issue the flush only..
> As I understand, dm-bufio will do the flush but currently once per 10 seconds.
> 
> if data on the block device and metadata on other block device get out
> of sync, what you can do then?
> how journal helps then?
> 
> - Dmitry

It depends what you're trying to do.

If you're trying to do something like "dm-verity", but with a possibility 
to write to the device, there are several possibilities:

* keep two checksums per 512-byte sector, the old checksum and the new 
checksum. If you update the block, you update the new checksum, sync the 
metadata device and then write to the data device (obviously you need to 
batch this update-sync-write for many blocks write concurrently to get 
decent performance). When you verify block, you allow either checksum to 
match. When you sync caches on the data device, you must forget all the 
old checksums.

* use journaling, write data block and its checksum to a journal. If the 
computer crashes, you just replay the journal (so you don't care what data 
was present at that place, you overwrite it with data from the journal). 
The downside is that this doubles required i/o throughput, you should have 
journal and data on different devices.

* do nothing and rebuild the checksums in case of crash. It is simplest, 
but it doesn't protect from data damages that happen due to the crash (for 
example, some SSDs corrupt its metadata on power failure and you can't 
detect this if you rebuild checksums after a power failure).

> Yes.. I am aware of dm-verity target.
> It suites well for read-only cases.
> It is questionable how tree-based approach will work with read-write.
> Each single update will cause whole tree recalculation.

A write would recalculate hashes only in the branch from tree bottom to 
tree top. The obvious downside is that there is no protection from crash.


BTW. regarding that reboot notifier with 
"dm_bufio_write_dirty_buffers(d->bufio)" ... there could be another 
problem ... what if other reboot notifier (maybe for a completely 
different driver) writes to the device after 
"dm_bufio_write_dirty_buffers(d->bufio)" was performed?

- would it be possible to install your notifier again?

- or turn into a synchronous updates? --- i.e. set a flag in your reboot 
notifier and if the flag is on, call 
"dm_bufio_write_dirty_buffers(d->bufio)" after every write.

Mikulas
