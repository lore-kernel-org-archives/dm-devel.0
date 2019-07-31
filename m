From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [RFC PATCH 0/3] md: export internal stats through debugfs
Date: Wed, 31 Jul 2019 14:07:43 -0700
Message-ID: <CAPhsuW5c96vQDiwbPhDvKOG8_XkPapW62bkthPAHFOum2N2VhQ@mail.gmail.com>
References: <20190702132918.114818-1-houtao1@huawei.com> <CAPhsuW6yH7np1=+e5Rgutp3m1VA0TPvtANeX=0ZdpJaRKEvBkQ@mail.gmail.com>
 <b047c187-e4a6-a82a-3177-3da7fef2f6b8@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b047c187-e4a6-a82a-3177-3da7fef2f6b8@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hou Tao <houtao1@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Song Liu <songliubraving@fb.com>, NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, open list <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Fri, Jul 26, 2019 at 10:48 PM Hou Tao <houtao1@huawei.com> wrote:
>
> Hi,
>
[...]
> >
> > Hi,
> >
> > Sorry for the late reply.
> >
> > I think these information are really debug information that we should not
> > show in /sys. Once we expose them in /sys, we need to support them
> > because some use space may start searching data from them.
> So debugfs is used to place these debug information instead of sysfs.

I don't think we should dump random information into debugfs. It is common
for the developers to carry some local patches that dumps information for
debug. We cannot get these patches upstream.

Thanks,
Song
