From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 2/2] dm: verity support data device offset
 (Linux 3.4.7)
Date: Thu, 09 Aug 2012 08:35:17 +0200
Message-ID: <50235A25.6010705@redhat.com>
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com> <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com> <5022CC99.30103@redhat.com> <AD722D70-2E9C-4B2D-BE48-B94E2268C3DD@netflix.com> <5022D29B.9000402@redhat.com> <C8AA8C7B-505E-49E8-AE47-C24843E74543@netflix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <C8AA8C7B-505E-49E8-AE47-C24843E74543@netflix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wesley Miaw <wmiaw@netflix.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, "msb@google.com" <msb@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?windows-1252?Q?Will_Drewry=99?= <w@google.com>
List-Id: dm-devel.ids

On 08/09/2012 02:40 AM, Wesley Miaw wrote:
> On Aug 8, 2012, at 1:56 PM, Milan Broz wrote:
> 
>> On 08/08/2012 10:46 PM, Wesley Miaw wrote:
>> 
>>> I did modify veritysetup on my own so the format and verify
>>> commands will work with regular files on disk instead of having
>>> to mount through loop devices.
>> 
>> Which veritysetup? In upstream (cryptsetup repository) it allocates
>> loop automatically. (And for userspace verification it doesn't need
>> loop at all.)
>> 
>> Anyway, please send a patch for userspace as well then ;-)
> 
> This isn't as polished because I pretty much just added support to do
> what I needed. I'm not sure if the LKML is the right place to post,
> so let me know if I should send this somewhere else.

This is libcryptsetup userspace so better list for this is dmcrypt
mailing list (and/or cc me, I will handle these changes anyway).

The allocated crypto "file" context cannot be later used for some kind
of operations. I do not like this approach musch... 
You cannot use file argument for dm-target directly, so your patch
is useful only for your use case but not for anything else.

Anyway, I am sure there is better way how to solve it I just need
to understand what the problem is. What's wrong if code allocates
loop devices (if argument is file)?
Performance? Loop not available? Need root access?

Please explain what's the problem first.
(btw that patch is mangled by a mailer but not a problem now).

> Your previous email implied that veritysetup would need a way to
> determine if the data offset option is supported; I did not modify
> veritysetup to support this idea as I didn't need it.

Once kernel get this option (if you convince upstream:) then I will
the option to userspace. We have to handle many dm-crypt extensions
so not a big problem for dm-verity as well.

Milan
