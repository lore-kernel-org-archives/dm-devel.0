From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH] Create: tell udev md device is not ready when first
 created.
Date: Tue, 2 May 2017 09:42:49 -0400
Message-ID: <01f50f57-c55e-e87f-b5a1-ded4647368b2@gmail.com>
References: <149265560315.31004.3851231165281498425.stgit@noble>
 <149265600601.31004.323865505557190368.stgit@noble>
 <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com>
 <87mvbasqx6.fsf@notabene.neil.brown.name>
 <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
 <87h919ruj5.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h919ruj5.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Peter Rajnoha <prajnoha@redhat.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 04/28/2017 01:05 AM, NeilBrown wrote:
>
> When an array is created the content is not initialized,
> so it could have remnants of an old filesystem or md array
> etc on it.
> udev will see this and might try to activate it, which is almost
> certainly not what is wanted.
>
> So create a mechanism for mdadm to communicate with udev to tell
> it that the device isn't ready.  This mechanism is the existance
> of a file /run/mdadm/created-mdXXX where mdXXX is the md device name.
>
> When creating an array, mdadm will create the file.
> A new udev rule file, 01-md-raid-creating.rules, will detect the
> precense of thst file and set ENV{SYSTEMD_READY}="0".
> This is fairly uniformly used to suppress actions based on the
> contents of the device.
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  Assemble.c                  |  2 +-
>  Build.c                     |  2 +-
>  Create.c                    |  9 +++++++-
>  Incremental.c               |  4 ++--
>  Makefile                    |  4 ++--
>  lib.c                       | 29 +++++++++++++++++++++++++
>  mdadm.h                     |  4 +++-
>  mdopen.c                    | 52 ++++++++++++++++++++++++++++-----------------
>  udev-md-raid-creating.rules |  7 ++++++
>  9 files changed, 86 insertions(+), 27 deletions(-)
>  create mode 100644 udev-md-raid-creating.rules

Applied!

I like this solution much better, even though I am not in love with the 
giant usleep() call. Would be nice to find a better way around that.

Sorry it took so long to get back to you on this, last week was a mess.

Thanks,
Jes


