From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Thu, 19 Nov 2015 08:53:26 +0100
Message-ID: <564D7FF6.50408@nod.at>
References: <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk> <564B79B1.3040207@gmail.com>
 <20151117191606.GC108807@ubuntu-hedt> <564B941A.2070601@gmail.com>
 <20151117213255.GE108807@ubuntu-hedt> <564C6DD4.6090308@gmail.com>
 <20151118142238.GB134139@ubuntu-hedt>
 <20151118145818.GC22011@ZenIV.linux.org.uk>
 <20151118150512.GE134139@ubuntu-hedt>
 <20151118151335.GD22011@ZenIV.linux.org.uk>
 <CAFLxGvwwhXqVM71m1kEDTZk_YTKGtbJ3gWoXw3wRgcwDiC38Bg@mail.gmail.com>
 <alpine.LRH.2.20.1511191845510.10804@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.20.1511191845510.10804@namei.org>
Sender: linux-bcache-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Seth Forshee <seth.forshee@canonical.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

Am 19.11.2015 um 08:47 schrieb James Morris:
> On Wed, 18 Nov 2015, Richard Weinberger wrote:
> 
>> On Wed, Nov 18, 2015 at 4:13 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>> On Wed, Nov 18, 2015 at 09:05:12AM -0600, Seth Forshee wrote:
>>>
>>>> Yes, the host admin. I'm not talking about trusting the admin inside the
>>>> container at all.
>>>
>>> Then why not have the same host admin just plain mount it when setting the
>>> container up and be done with that?  From the host namespace, before spawning
>>> the docker instance or whatever framework you are using.  IDGI...
>>
>> Because hosting companies sell containers as "full virtual machines"
>> and customers expect to be able mount stuff like disk images they upload.
> 
> I don't think this is a valid reason for merging functionality into the 
> kernel.

Erm, I don't want this in the kernel. That's why I've proposed the lklfuse approach.

Thanks,
//richard
