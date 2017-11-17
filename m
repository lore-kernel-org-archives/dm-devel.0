From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
Date: Thu, 16 Nov 2017 18:54:06 -0700
Message-ID: <CAJCQCtRKWA-tOaS5K-JOvxj4OYD==-Vrap4MbHZTfwYxc_FEKQ@mail.gmail.com>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com> <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com> <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com> <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
 <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com> <CAJCQCtRUGEdu13RCKFb6uZQ3UCzoAByhu97FdwQoFPxvsOua0Q@mail.gmail.com>
 <4baeb223-85d3-4c0c-e6d3-d0b495c2d950@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <4baeb223-85d3-4c0c-e6d3-d0b495c2d950@gmx.com>
Sender: linux-block-owner@vger.kernel.org
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>, Zdenek Kabelac <zkabelac@redhat.com>, Nikolay Borisov <nborisov@suse.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Nov 16, 2017 at 6:22 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017=E5=B9=B411=E6=9C=8817=E6=97=A5 06:32, Chris Murphy wrote:
>
>> It's good the file system can stay alive, but data is the much
>> bigger target in terms of percent space on the physical media,
>
> It's also true.
> (Although working on btrfs sometimes makes me care more about safe metada=
ta)

It seems like a good idea if it's lightweight enough, because we get
Btrfs-like metadata error detection and recovery from a copy, for
free. The user doesn't have to setup dm-verity to get this.
Additionally, if the work happens in the md driver, then both mdadm
and LVM based arrays get the feature (strictly speaking I think
dm-raid is deprecated, everything I'm aware of these days uses the md
code (including Intel's IMSM firmware based RAID).

The gotcha of course is that anytime there's a file system format
change, now this layer has to become aware of it and support all
versions of that file system's metadata for the purpose of error
detection. That might be a bitter pill to swallow in the long term.


--=20
Chris Murphy
