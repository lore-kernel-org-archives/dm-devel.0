From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: About the thin provision function @ kernel 3.2 or
	later.
Date: Mon, 16 Jan 2012 09:14:56 -0500
Message-ID: <20120116141446.GA19122@redhat.com>
References: <CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yukihito HARA <yukihito.hara623@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Jan 15 2012 at  8:27pm -0500,
Yukihito HARA <yukihito.hara623@gmail.com> wrote:

> Hi, I'm Yukihito, and interested in Linux system.
> 
> Recently days, I became happy to hear that Linux kernel start to support
> thin-provisioning function.
> And not trying to how it work on latest kernel.
> 
> According to the word "thin provisioning", I'm imaging that, I can get
> larger space than actual disk size. This image is born from
> thin-provisioning system working on VMWare series.
> And can write the files until reach to the physical maximum. Once reach to
> the physical maximum, I can't write any more files to that volume, but I
> can write more files after add additional physical disks to thin-pool.
> 
> I could create the pool according to the documents included in the kernel
> source(Documentation/device-mapper/thin-provisioning.txt).
> But I'm not sure, it works as I expecting like above.
> 
> So can you provide more detailed documentation about the thin-provisioning,
> if you have?
> There're no documentation written in Japanese, so I'll also output this
> communication to wiki or my twitter in Japanese. It helpful to make your
> work more major among Japanese IT engineers. And you can get more feedback
> if the challengers in Japan will be increased.
> The worst point of the current documentation is, it's not instruct about
> how to use like above. Can't get image how to use this like VMware system
> from that document.
> 
> Sorry, this is my private testing, not for work. So I can't get much time
> to this, but very interested in.

Please see this reply that was recently sent to the list:
http://www.redhat.com/archives/dm-devel/2012-January/msg00035.html
