From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for
 request-based device
Date: Wed, 19 May 2010 10:45:42 -0400
Message-ID: <20100519144542.GD24618@redhat.com>
References: <20100513035750.GA25523@redhat.com>
 <4BED049C.5040409@ct.jp.nec.com>
 <20100514140852.GA10373@redhat.com>
 <4BF10BF1.3040108@ct.jp.nec.com>
 <20100517172737.GA24591@redhat.com>
 <4BF25091.3000507@ct.jp.nec.com>
 <20100518134639.GA27582@redhat.com>
 <4BF37DD5.9050409@ct.jp.nec.com>
 <AANLkTinndXq8DkMBOUf5z8R_8lWRoRbDuOZ1LEmWeI21@mail.gmail.com>
 <20100519143900.GC24618@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100519143900.GC24618@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, May 19 2010 at 10:39am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> > On Wed, May 19, 2010 at 1:57 AM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> > > Hi Mike,
> > >
> > > dm_table_setup_md_queue() may allocate memory with blocking mode.
> > > Blocking allocation inside exclusive _hash_lock can cause deadlock;
> > > e.g. when it has to wait for other dm devices to resume to free some
> > > memory.

<snip>

> We discussed this and I understand the scope of the problem now.
> 
> Just reiterating what you covered when you first pointed this issue out:
> 
> It could be that a table load gets blocked (waiting on a memory
> allocation).  The table load can take as long as it needs.  But we can't
> have it block holding the exclusive _hash_lock while blocking.  Having
> _hash_lock prevents further DM ioctls.  The table load's allocation may
> be blocking waiting for writeback to a DM device that will be resumed by
> another thread.
> 
> Thanks again for pointing this out; I'll work to arrive at an
> alternative locking scheme.  Likely introduce a lock local to the
> multiple_device (effectively the 'queue_lock' I had before).  But

s/multiple_device/mapped_device/

Mike
