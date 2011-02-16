From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: timestamp for shared snapshot
Date: Wed, 16 Feb 2011 09:36:41 -0500
Message-ID: <20110216143641.GA28595@redhat.com>
References: <AANLkTinLFoOQ-mbPMAHQ0RCObyrWH0jMP4qQ0wsC4uaU@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <AANLkTinLFoOQ-mbPMAHQ0RCObyrWH0jMP4qQ0wsC4uaU@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: devicemapper niko <devicemapper.niko@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 16 2011 at  4:42am -0500,
devicemapper niko <devicemapper.niko@gmail.com> wrote:

> Hi,guys.
> 
> I tried shared snapshot recently,I found there's no timestamp for snapshot.
> 
> Is it possible to add timestamp and comment for each snapshots ?

I assume you're using Mikulas' shared snapshot kernel patches? E.g.:
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r23/

And a patched lvm2 with shared snapshot support?  E.g.:
http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-2.02.73/

It should be noted that the above shared snapshot work is unlikely to
make it upstream (portions of it likely will, for instance the lvm2
userspace changes).  A new shared snapshot implementation is in
development.

In any case, the easiest thing to do is use descriptive names for each
snapshot (include your own timestamp, etc).

Mike
