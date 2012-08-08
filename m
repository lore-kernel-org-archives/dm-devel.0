From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm: verity support data device offset (Linux
 3.4.7)
Date: Wed, 08 Aug 2012 22:31:21 +0200
Message-ID: <5022CC99.30103@redhat.com>
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com> <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, "msb@google.com" <msb@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?windows-1252?Q?Will_Drewry=99?= <w@google.com>, wmiaw@netflix.com
List-Id: dm-devel.ids

On 08/08/2012 08:46 PM, Mikulas Patocka wrote:

> The problem with the patch is that it changes interface to the userspace 
> tool. The userspace tool veritysetup already exists in recent cryptsetup 
> package, so we can't change the interface - you should change the patch so 
> that the starting data block is the last argument and the argument is 
> optional - so that it is compatible with the existing userspace too.

yes. Please never change interface without at least increasing target version.

I have to add userspace support as well to veritysetup and we need a way
how to detect that option is supported by running kernel.

Milan
