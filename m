From: Drew <drew.kay@gmail.com>
Subject: Re: Linux RAID subsystem future
Date: Thu, 12 Jul 2012 13:28:24 -0700
Message-ID: <CACJz6Qsx-xNxDRw5kUqUpf9ogVp23jokHOdGL9xO=kqFXmiNZg@mail.gmail.com>
References: <jtn1c5$q0u$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <jtn1c5$q0u$1@dough.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

> Hello lists,
>
> I noticed recent patches added MD RAID compatibility into the DM
> subsystem. Is there a valid reason to duplicate efforts ?
>
> Hopefully its not silent preparation step for DM takeover. Can someone
> shed more light on this topic ?
>
> TIA, Z.

I'm not a developer by any stretch of the word so take what I say with
a grain of salt.

I think it's more just a case of dm using md's RAID algorithms, which
IMHO are better tested, to support fakeraid controllers like Intel's
Matrix RAID. Besides, we're all one big happy linux family so why not
borrow your brother's socks? :-)


-- 
Drew
