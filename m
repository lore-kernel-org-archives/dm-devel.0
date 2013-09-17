From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: staging: Add dm-writeboost
Date: Tue, 17 Sep 2013 21:43:18 +0900
Message-ID: <52384E66.6050101@gmail.com>
References: <5223208D.4000008@gmail.com> <20130916215357.GA5015@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20130916215357.GA5015@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: snitzer@redhat.com
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com, joe@perches.com, akpm@linux-foundation.org, cesarb@cesarb.net, m.chehab@samsung.com
List-Id: dm-devel.ids

Hi, Mike

There are two designs in my mind
regarding the formatting cache.

You said
>   administer the writeboost devices.  There is no need for this.  Just
>   have a normal DM target whose .ctr takes care of validation and
>   determines whether a device needs formatting, etc.  
makes me wonder how I format the cache device.


There are two choices for formatting cache and create a writeboost device
standing on the point of removing writeboost-mgr existing in the current design.
I will explain them from how the interface will look like.

(1) dmsetup create myDevice ... "... $backing_path $cache_path"
which will returns error if the superblock of the given cache device
is invalid and needs formatting.
And then the user formats the cache device by some userland tool.

(2) dmsetup create myDevice ... "... $backing_path $cache_path $do_format"
which also returns error if the superblock of the given cache device
is invalid and needs formatting when $do_format is 0.
And then user formats the cache device by setting $do_format to 1 and try again.

There pros and cons about the design tradeoffs:
- (i)  (1) is simpler. do_format parameter in (2) doesn't seem to be sane.
       (1) is like the interfaces of filesystems where dmsetup create is like mounting a filesystem.
- (ii) (2) can implement everything in kernel. It can gather all the information
       about how the superblock in one place, kernel code.

Excuse for the current design:
- The reason I design writeboost-mgr is almost regarding (ii) above.
  writeboost-mgr has a message "format_cache_device" and
  writeboost-format-cache userland command kicks the message to format cache.

- writeboost-mgr has also a message "resume_cache"
  that validates and builds a in-memory structure according to the cache binding to given $cache_id
  and user later dmsetup create the writeboost device with the $cache_id.
  However, resuming the cache metadata should be done under .ctr like dm-cache does
  and should not relate LV to create and cache by external cache_id
  is what I realized by looking at the code of dm-cache which
  calls dm_cache_metadata_open() routines under .ctr .
  I don't know why I should not do this it is nicer to trust DM guys in RedHat on this point.

writeboost-mgr is something like smell of over-engineering but
is useful for simplifying the design for above reasons.


Which do you think better?

Akira
