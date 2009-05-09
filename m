From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] block: add alt_size
Date: Sat, 9 May 2009 15:45:36 +0200
Message-ID: <ac3eb2510905090645u5e482ffcu4b3ddc26e81247e6@mail.gmail.com>
References: <1241828002-12742-1-git-send-email-tj@kernel.org>
	<1241828002-12742-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1241828002-12742-2-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Mauelshagen@redhat.com, dm-devel@redhat.com, dan.j.williams@gmail.com
List-Id: dm-devel.ids

On Sat, May 9, 2009 at 02:13, Tejun Heo <tj@kernel.org> wrote:
> This patch adds alt_size to genhd and exports it via sysfs. =C2=A0alt=
_size
> is always smaller than the regular size. =C2=A0Being a hint, alt_size=
 can
> also be set from userland by writing to the sysfs node mostly for
> debugging and testing.

What does "alt_" stand for? I think that should be more descriptive in
an exported interface.

And can we please keep the "size_*" in front of the name, so that they
group together?

Also, values with magic block counts, while there is no way to get the
blocksize with the same interface, are pretty weird. I think the
current "size" attribute is just a bug.
Not sure, how that should be solved, by adding a "blocksize" attribute
that is always in the same context as the current "size*" values, or
by just using bytes for new attributes here.

Almost all tools I've seen using these attributes, have hardcoded *
512 in there, which may cause trouble pretty soon. And this is mostly
a failure of the interface and not of the users, I think.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
