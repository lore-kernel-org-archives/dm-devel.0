From: Will Drewry <redpig@dataspill.org>
Subject: Re: dm-bufio
Date: Sat, 24 Mar 2012 13:51:54 -0500
Message-ID: <CABmXcB-FVWfdgA5mxN66YN_iX37+a3ME3nHyDOo28AbwGe4eLw@mail.gmail.com>
References: <CALLzPKZyOc+_Pjht8uR6AJOBsMFXQN=y5QWvD0_OZFaYJpvRig@mail.gmail.com>
	<4F6C5A1F.1000103@redhat.com>
	<CALLzPKb+xrQQ-+sOTY0-MHbfVDkgvY2TYqmpP0Mqi7XwD4iEDg@mail.gmail.com>
	<CALLzPKYkLXz0iZPwSbw268w1dkQtvjgoX19aVTK6cEAgt5L50g@mail.gmail.com>
	<Pine.LNX.4.64.1203231213320.17386@file.rdu.redhat.com>
	<CALLzPKZ8b5Pd_GVRDzxNcBLzE=D9yAZ+fbhGiWKvi=E1oXcOMg@mail.gmail.com>
	<Pine.LNX.4.64.1203232046220.3024@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1203232046220.3024@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: mpatocka@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 23, 2012 at 8:07 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Sat, 24 Mar 2012, Kasatkin, Dmitry wrote:
>
>> Hi,
>>
>> Thanks for clarification.
>> Indeed everything works just with dm_bufio_write_dirty_buffers().
>> Reboot notifier is to issue the flush only..
>> As I understand, dm-bufio will do the flush but currently once per 10 seconds.
>>
>> if data on the block device and metadata on other block device get out
>> of sync, what you can do then?
>> how journal helps then?
>>
>> - Dmitry
>
> It depends what you're trying to do.
>
> If you're trying to do something like "dm-verity", but with a possibility
> to write to the device, there are several possibilities:
>
> * keep two checksums per 512-byte sector, the old checksum and the new
> checksum. If you update the block, you update the new checksum, sync the
> metadata device and then write to the data device (obviously you need to
> batch this update-sync-write for many blocks write concurrently to get
> decent performance). When you verify block, you allow either checksum to
> match. When you sync caches on the data device, you must forget all the
> old checksums.
>
> * use journaling, write data block and its checksum to a journal. If the
> computer crashes, you just replay the journal (so you don't care what data
> was present at that place, you overwrite it with data from the journal).
> The downside is that this doubles required i/o throughput, you should have
> journal and data on different devices.
>
> * do nothing and rebuild the checksums in case of crash. It is simplest,
> but it doesn't protect from data damages that happen due to the crash (for
> example, some SSDs corrupt its metadata on power failure and you can't
> detect this if you rebuild checksums after a power failure).
>
>> Yes.. I am aware of dm-verity target.
>> It suites well for read-only cases.
>> It is questionable how tree-based approach will work with read-write.
>> Each single update will cause whole tree recalculation.
>
> A write would recalculate hashes only in the branch from tree bottom to
> tree top. The obvious downside is that there is no protection from crash.

It also depends on how you plan to assure the integrity of the data:
Device-based symmetric key, asymmetric key, etc and the costs
associated.  Local updates make integrity tricky -- will the device
update itself or will signed updates be supplied, do they need to be
online, does only a subsection need to be online, etc.

It's likely that the tree updates won't be too expensive compared to
the crypto and you could attempt to optimize tree updates along a hot
path if needed (by breaking out hot subdirs to a separate targets) and
explore other tricks for getting transaction oriented behavior (two
swapping metadata devices for atomic tree updates, etc).  dm-verity
was never locked into being a read-only target, but the lack of need
to support online updates means the code and required changes don't
exist.

I'm sure any of us involved in dm-verity would be happy to discuss how
it might be used for your purposes (or if it is really a bad fit),
etc.

cheers!
will
