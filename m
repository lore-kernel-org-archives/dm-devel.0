From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device	read-write
 for read-only mappings
Date: Tue, 15 Feb 2011 13:17:56 +0100
Message-ID: <4D5A6EF4.3030905@redhat.com>
References: <4D57E67E.1030707@redhat.com> <4D57F357.6060708@tao.ma> <4D580A8B.5050508@redhat.com> <20110214103026.GA18742@htj.dyndns.org> <4D591664.6090203@redhat.com> <4D592AD1.6020500@redhat.com> <20110214140940.GM18742@htj.dyndns.org> <4D593AD8.7070901@redhat.com> <20110214154430.GR18742@htj.dyndns.org> <20110215101506.43d41ca8@notabene.brown> <20110215020351.GD5825@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110215020351.GD5825@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 02/15/2011 03:03 AM, Alasdair G Kergon wrote:
> On Tue, Feb 15, 2011 at 10:15:06AM +1100, Neil Brown wrote:
>> Sounds sensible ... though it is not all that easy to assemble an
>> array as 'read-only'....  it is possible though.
>  
> For dm, it is looking like this change will *require* an upgrade to
> userspace LVM tools: some people who just update their kernels without
> updating their LVM tools too may find booting their machine fails.  We
> are still evaluating exactly which parts of LVM and which classes of
> users are affected and how best to deal with this, but I know from
> experience that changes where a kernel update requires an associated
> userspace update are never well-received and we would normally try to
> give plenty of lead time by updating the userspace tools and starting to
> get them into the distributions before imposing the kernel change.

This little change is really problematic.

Not only lvm userspace has problems here, also cryptsetup is broken
for read-only mappings.

Of course this it can be easily fixed, but it take some time until
the new userspace is propagated to distros.

Seems it changed userspace API here. For example, this is no longer
working now:

        fd = open(device, O_RDWR | flags);
        if (fd == -1 && errno == EROFS) {
                *readonly = 1;
                fd = open(device, O_RDONLY | flags);
        }


Milan
