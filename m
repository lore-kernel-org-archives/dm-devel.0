From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [dm-devel] LVM snapshot broke between 4.14 and 4.16
Date: Sat, 4 Aug 2018 10:36:50 +0200
Message-ID: <102c2d75-f768-a649-52c3-bac6f0ca738d@redhat.com>
References: <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
 <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
 <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
 <b2bbd8ec-ac5b-fa8a-d3f7-8615d87f73c3@redhat.com>
 <CA+55aFwWZX=CXmWDTkDGb36kf12XmTehmQjbiMPCqCRG2hi9kw@mail.gmail.com>
 <20180803185431.GB3258@redhat.com>
 <CA+55aFwDEY7B6OMh5xL2wc8BRj1KkzBHggNowAjbsWfma6H5Zg@mail.gmail.com>
 <20180803193037.GA4581@redhat.com> <20180804052033.GA4461@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180804052033.GA4461@thunk.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru
List-Id: dm-devel.ids

Dne 4.8.2018 v 07:20 Theodore Y. Ts'o napsal(a):
> On Fri, Aug 03, 2018 at 03:30:37PM -0400, Mike Snitzer wrote:
>>
>> I was trying to give context for the "best to update lvm2 anyway"
>> disclaimer that was used.  Yeah, it was specious.
> 
> Well, it seemed to indicate a certain attitude that both Linus and I
> are concerned about.  I tried to use more of a "pursuading" style to
> impress why that attitude was not ideal/correct.  Linus used a much
> more assertive style (e.g., "Hell, no!").

My whole point was - when someone has 'enough time' to compile fresh new 
kernel, spending couple seconds to build also recent lvm2 should have be no 
issue. Bugs are continually fixed, new feature from newer kernel are being
used, known problems are being addressed - that's  all what it means.
Bug are fixed not just in kernel, but also in user-space.

> 
>> And yeah, that isn't a good excuse to ignore it but: dm-snapshot is a
>> steaming pile as compared to dm thin-provisioning...
> 
> On a side note, this is the first that I've heard the assertion that
> dm-thin was better than dm-snapshot.  My impression was that
> dm-snapshot was a proven code base, that only did one thing and (as
> far as I could tell) did it well.  In contrast, dm-thin is much newer
> code, **far** more complex, with functionality and corner cases
> approaching that of a file system --- and just to be even more
> exciting, it doesn't have an fsck/repair tool to deal with corrupted
> metadata.
> 
> In your opinion, is it because you disagree with the assumption that
> dm-thin is scary?  Or is the argument that dm-snapshot is even
> scarier?


dm-snapshost has really outdated design - it's been useful in the old age 
where megabyte was hell lot of space.

Nowadays, when users do need to handle snapshots in multi gigabyte sizes and 
moreover have number of snapshots from the same volume taken over the time, 
want to take snapshot of snapshot of snapshot, the old snapshot simple kills 
all the performance, uses tons of resources and becomes serious bottleneck of 
your system and has lots of usability limitation.

That's where  thin provisioning will shine....

However if you still need to take short-living smallish snapshot and you want 
to use non-provisioned origin device, there the snapshot will still work as 
proven technology -  just no one can expect it will scale for the recent 
device size explosion...

Regards

Zdenek
