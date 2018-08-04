From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [dm-devel] LVM snapshot broke between 4.14 and 4.16
Date: Sat, 4 Aug 2018 01:20:33 -0400
Message-ID: <20180804052033.GA4461@thunk.org>
References: <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
 <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
 <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
 <b2bbd8ec-ac5b-fa8a-d3f7-8615d87f73c3@redhat.com>
 <CA+55aFwWZX=CXmWDTkDGb36kf12XmTehmQjbiMPCqCRG2hi9kw@mail.gmail.com>
 <20180803185431.GB3258@redhat.com>
 <CA+55aFwDEY7B6OMh5xL2wc8BRj1KkzBHggNowAjbsWfma6H5Zg@mail.gmail.com>
 <20180803193037.GA4581@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180803193037.GA4581@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru
List-Id: dm-devel.ids

On Fri, Aug 03, 2018 at 03:30:37PM -0400, Mike Snitzer wrote:
> 
> I was trying to give context for the "best to update lvm2 anyway"
> disclaimer that was used.  Yeah, it was specious.

Well, it seemed to indicate a certain attitude that both Linus and I
are concerned about.  I tried to use more of a "pursuading" style to
impress why that attitude was not ideal/correct.  Linus used a much
more assertive style (e.g., "Hell, no!").

> And yeah, that isn't a good excuse to ignore it but: dm-snapshot is a
> steaming pile as compared to dm thin-provisioning...

On a side note, this is the first that I've heard the assertion that
dm-thin was better than dm-snapshot.  My impression was that
dm-snapshot was a proven code base, that only did one thing and (as
far as I could tell) did it well.  In contrast, dm-thin is much newer
code, **far** more complex, with functionality and corner cases
approaching that of a file system --- and just to be even more
exciting, it doesn't have an fsck/repair tool to deal with corrupted
metadata.

In your opinion, is it because you disagree with the assumption that
dm-thin is scary?  Or is the argument that dm-snapshot is even
scarier?

						- Ted

P.S.  It could be that my impression is wrong/out-dated, but the
kernel documentation still says that userspace tools for checking and
repairing the metadata are "under development".  As a file system
developer, the reaction this inspires is best summed up as:

     https://imgflip.com/memetemplate/50971393/Scared-Face
