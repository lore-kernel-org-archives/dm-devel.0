From: Enric Balletbo Serra <eballetbo@gmail.com>
Subject: Re: [dm-devel] [PATCH v6 0/3] dm: boot a mapped device without an initramfs
Date: Thu, 4 May 2017 13:18:41 +0200
Message-ID: <CAFqH_51YLoYrNcw+Fb99LbSY63wVWg+MW7nBYQqWjV6qfOAmNQ@mail.gmail.com>
References: <20170418164240.18079-1-enric.balletbo@collabora.com> <CAGXu5jLD+0POz1sopyZNNqDAiq2MZ5ZYdjs43jX5OnWxkZt1Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLD+0POz1sopyZNNqDAiq2MZ5ZYdjs43jX5OnWxkZt1Lg@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>, Will Drewry <wad@chromium.org>, Guenter Roeck <groeck@google.com>, Mike Snitzer <snitzer@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, David Zeuthen <zeuthen@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mike,

2017-04-18 19:37 GMT+02:00 Kees Cook <keescook@chromium.org>:
> On Tue, Apr 18, 2017 at 9:42 AM, Enric Balletbo i Serra
> <enric.balletbo@collabora.com> wrote:
>> Hello,
>>
>> Some of these patches were send few years back, I saw that first
>> version was send to this list in 2010, and after version 4 did not
>> land [1]. Some days ago I resend the patches [2] and few hours later I
>> noticed that one year ago was send a v5 version [3] and I was not aware.
>>
>> There was some discussion about v5 and during the discussion Mike Snitzer
>> proposed that at least a change of the syntax is required, we're really
>> interested on see this upstream as is extensively used in ChromeOS based
>> devices so I'm wondering if we can restart the discussion and hopefully
>> we will be able to do the modifications needed.
>>
>> So my first question is, apart of the change of the syntax, what more
>> should be changed?
>
> AFAIK, this was the main change needed. Change the syntax and plumb
> into the ioctl interface. The discussion ended with Mike being open to
> the idea, and for me to go work on it. I haven't had time to work on
> it, though, so it has continued to be a locally carried patch:
> https://www.redhat.com/archives/dm-devel/2016-February/msg00199.html
>

From your email:

> >> > 2) If you are able to adequately justify the need for dm=:
> >> > I'd much rather the dm= kernel commandline be a simple series of
> >> > comma-delimited dmsetup-like commands.
> >> >
> >> > You'd handle each command with extremely basic parsing:
> >> >  <dm_ioctl_cmd> <args> [, <dm_ioctl_cmd> <args>]
> >> > (inventing a special token to denote <newline>, to support tables with
> >> > multiple entries, rather than relying on commas and counts, etc)
> >>

I'm wondering if a command line like this would be acceptable.

Format is:
  dm="<dev_name> <uuid> <mode>,  <table>[, <table>][; <dev_name>
<uuid> <mode>,  <table>[, <table>]][; ... ]"

where:
  <dev_name> ::=  The device name
  <uuid>          ::=  xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | "none"
  <mode>        ::= "ro" | "rw"
  <table>         ::= <start sector> <end sector> <target name>
<target parmaters>

An example of booting to a linear array:

 dm="lroot none rw, 0 2097152 linear /dev/sda2 0, 2097152 2097152
linear /dev/sda3 0, 4194304 2097152 linear /dev/sda4 0"

Equivalent dmsetup command:

echo -e "0 2097152 linear /dev/sda2 0"\\n"2097152 2097152 linear
/dev/sda3 0"\\n"4194304 2097152 linear /dev/sda4 0" | sudo dmsetup
create lroot

An example of multiple device-mappers, with the dm="..." contents shown
here split on multiple lines for readability:

    vroot none ro,
      0 2097152 verity 1 /dev/sdb2 /dev/sdb3 4096 4096 262144 1 sha256 \
      289b52edac1ac4f4c32c8f765795615a85d4daa454677d21a6d8767c4627dc48 \
      632d7fe427a23a8e88493c553298a779997478a143d86da5d56a65db8a1f2a38;
    vram none rw,
      0 32768 linear 1:0 0,
      32768 32768 linear 1:1 0

Thanks,
 Enric

> More recently David Zeuthen has been poking at this code, so I've
> included him on CC here, in case there are new developments.
>
> -Kees
>
>>
>> Thanks for your help,
>>  Enric
>>
>> [1] Patchwork links:
>>     https://patchwork.kernel.org/patch/104857/
>>     https://patchwork.kernel.org/patch/104856/
>>     https://patchwork.kernel.org/patch/104858/
>>
>> [2] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1375276.html
>>
>> [3] https://www.redhat.com/archives/dm-devel/2016-February/msg00112.html
>>
>>
>> Brian Norris (1):
>>   dm: make some mapped_device functions available
>>
>> Will Drewry (2):
>>   dm: export a table+mapped device to the ioctl interface
>>   init: add support to directly boot to a mapped device
>>
>>  Documentation/admin-guide/kernel-parameters.rst |   1 +
>>  Documentation/admin-guide/kernel-parameters.txt |   3 +
>>  Documentation/device-mapper/boot.txt            |  65 ++++
>>  drivers/md/dm-ioctl.c                           |  36 ++
>>  drivers/md/dm.h                                 |   8 -
>>  include/linux/device-mapper.h                   |  19 +
>>  init/Makefile                                   |   1 +
>>  init/do_mounts.c                                |   1 +
>>  init/do_mounts.h                                |  10 +
>>  init/do_mounts_dm.c                             | 448 ++++++++++++++++++++++++
>>  10 files changed, 584 insertions(+), 8 deletions(-)
>>  create mode 100644 Documentation/device-mapper/boot.txt
>>  create mode 100644 init/do_mounts_dm.c
>>
>> --
>> 2.9.3
>>
>
>
>
> --
> Kees Cook
> Pixel Security
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
