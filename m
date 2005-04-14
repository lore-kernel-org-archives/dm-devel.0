From: Bjorn Andersson <bjorn.andersson@silversmedjan.se>
Subject: Re: dm-crypt userland key patch
Date: Thu, 14 Apr 2005 14:14:59 +0200
Message-ID: <20050414141459.6d521f67@emotpin>
References: <ac71172a05041310417117dd09@mail.gmail.com>
	<20050413235852.45bd2500@emotpin>
	<62b0912f05041400135426a80e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <62b0912f05041400135426a80e@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Molle Bestefich <molle.bestefich@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> Bjorn Andersson wrote:
> > Patch to the dm-crypt module so that it hides the crypto-key from
> > userland. (dmsetup table)
> 
> Does it also overwrite the key in memory when unloading dm-crypt, make
> sure that the memory is pinned so the key doesn't leak to swap, unload
> the key before a 'hibernate', and that sort of stuff?
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

No, this does only report a key of zeros when the status is requested.

The unloading thing is no problem to fix, but how should the
'hibernate' thing work? When you resume after a 'hibernate' you probably
expect that the device is there, especially if it's on the root
partition. But I clearly see your point.

// Bjorn
