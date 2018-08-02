From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [RFC] [PATCH 0/1] Introduce emergency raid0 stop for
 mounted arrays
Date: Thu, 2 Aug 2018 10:30:57 -0300
Message-ID: <7cfa220e-c04d-b69e-fe39-5b9277f0538d@canonical.com>
References: <20180801145608.19880-1-gpiccoli@canonical.com>
	<87tvodpmc8.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87tvodpmc8.fsf@notabene.neil.brown.name>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, shli@kernel.org
Cc: linux-block@vger.kernel.org, jay.vosburgh@canonical.com, dm-devel@redhat.com, kernel@gpiccoli.net, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

On 01/08/2018 22:51, NeilBrown wrote:
>> [...] 
> If you have hard drive and some sectors or track stop working, I think
> you would still expect IO to the other sectors or tracks to keep
> working.
> 
> For this reason, the behaviour of md/raid0 is to continue to serve IO to
> working devices, and only fail IO to failed/missing devices.
> 

Hi Neil, thanks for your quick response. I agree with you about the
potential sector failure, it shouldn't automatically fail the entire
array for a single failed write.

The check I'm using in the patch is against device request queue - if a
raid0 member queue is dying/dead, then we consider the device as dead,
and as a consequence, the array is marked dead.

In my understanding of raid0/stripping, data is split among N devices,
called raid members. If one member is failed, for sure the data written
to the array will be corrupted, since that "portion" of data going to
the failed device won't be stored.

Regarding the current behavior, one test I made was to remove 1 device
of a 2-disk raid0 array and after that, write a file. Write completed
normally (no errors from the userspace perspective), and I hashed the
file using md5. I then rebooted the machine, raid0 was back with the 2
devices, and guess what?
The written file was there, but corrupted (with a different hash). I
don't think this is something fine, user could have written important
data and don't realize it was getting corrupted while writing.


> It seems reasonable that you might want a different behaviour, but I
> think that should be optional.  i.e. you would need to explicitly set a
> "one-out-all-out" flag on the array.  I'm not sure if this should cause
> reads to fail, but it seems quite reasonable that it would cause all
> writes to fail.
> 
> I would only change the kernel to recognise the flag and refuse any
> writes after any error has been seen.
> I would use udev/mdadm to detect a device removal and to mark the
> relevant component device as missing.
>

Using the udev/mdadm to notice a member has failed and the array must be
stopped might work, it was my first approach. The main issue here is
timing: it takes "some time" until userspace is aware of the failure, so
we have a window in which writes were sent between

(A) the array member failed/got removed and
(B) mdadm notices and instruct driver to refuse new writes;

between (A) and (B), those writes are seen as completed, since they are
indeed complete (at least, they are fine from the page cache point of
view). Then, writeback will try to write those, which will cause
problems or they will complete in a corrupted form (the file will
be present in the array's filesystem after array is restored, but
corrupted).

So, the in-kernel mechanism avoided most part of window (A)-(B),
although it seems we still have some problems when nesting arrays,
due to this same window, even with the in-kernel mechanism (given the
fact it takes some time to remove the top array when a pretty "far"
bottom-member is failed).

More suggestions on how to deal with this in a definitive manner are
highly appreciated.
Thanks,


Guilherme
