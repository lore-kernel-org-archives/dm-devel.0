From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm: verity support data device offset (Linux
 3.4.7)
Date: Wed, 08 Aug 2012 22:56:59 +0200
Message-ID: <5022D29B.9000402@redhat.com>
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com> <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com> <5022CC99.30103@redhat.com> <AD722D70-2E9C-4B2D-BE48-B94E2268C3DD@netflix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AD722D70-2E9C-4B2D-BE48-B94E2268C3DD@netflix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wesley Miaw <wmiaw@netflix.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, "msb@google.com" <msb@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?windows-1252?Q?Will_Drewry=99?= <w@google.com>
List-Id: dm-devel.ids

On 08/08/2012 10:46 PM, Wesley Miaw wrote:
> On Aug 8, 2012, at 1:31 PM, Milan Broz wrote:

> I did modify veritysetup on my own so the format and verify commands will work with regular files on disk instead of having to mount through loop devices.

Which veritysetup? In upstream (cryptsetup repository) it allocates loop automatically.
(And for userspace verification it doesn't need loop at all.)

Anyway, please send a patch for userspace as well then ;-)

Milan
