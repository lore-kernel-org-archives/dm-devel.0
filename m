From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [dm-devel] LVM snapshot broke between 4.14 and 4.16
Date: Sat, 4 Aug 2018 12:22:05 -0400
Message-ID: <20180804162205.GB4461@thunk.org>
References: <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
 <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
 <b2bbd8ec-ac5b-fa8a-d3f7-8615d87f73c3@redhat.com>
 <CA+55aFwWZX=CXmWDTkDGb36kf12XmTehmQjbiMPCqCRG2hi9kw@mail.gmail.com>
 <20180803185431.GB3258@redhat.com>
 <CA+55aFwDEY7B6OMh5xL2wc8BRj1KkzBHggNowAjbsWfma6H5Zg@mail.gmail.com>
 <20180803193037.GA4581@redhat.com>
 <20180804052033.GA4461@thunk.org>
 <102c2d75-f768-a649-52c3-bac6f0ca738d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <102c2d75-f768-a649-52c3-bac6f0ca738d@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru
List-Id: dm-devel.ids

On Sat, Aug 04, 2018 at 10:36:50AM +0200, Zdenek Kabelac wrote:
> dm-snapshost has really outdated design - it's been useful in the old age
> where megabyte was hell lot of space.
> 
> Nowadays, when users do need to handle snapshots in multi gigabyte sizes and
> moreover have number of snapshots from the same volume taken over the time,
> want to take snapshot of snapshot of snapshot, the old snapshot simple kills
> all the performance, uses tons of resources and becomes serious bottleneck
> of your system and has lots of usability limitation.

Fair enough.  I don't think I would consider that makes dm-snapshot a
"steaming pile".  For me, protection against data loss is Job One.

> That's where  thin provisioning will shine....

The dm-thin development might want to take a look at what's currently
in Documentation/device-mapper/thin-privisioning.txt:

   Status
   ======

   These targets are very much still in the EXPERIMENTAL state.  Please
   do not yet rely on them in production.  But do experiment and offer us
   feedback.  Different use cases will have different performance
   characteristics, for example due to fragmentation of the data volume.

   If you find this software is not performing as expected please mail
   dm-devel@redhat.com with details and we'll try our best to improve
   things for you.

   Userspace tools for checking and repairing the metadata are under
   development.

Saying that dm-snapshot is a steaming pile and dm-thin is what
everyone should use doesn't seem to be consistent with the above.

Cheers,

					- Ted
