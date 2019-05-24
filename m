From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: fstrim discarding too many or wrong blocks on Linux 5.1, leading
 to data loss
Date: Fri, 24 May 2019 17:10:51 +0200
Message-ID: <20190524151051.GA28270@kroah.com>
References: <8C31D41C-9608-4A65-B543-8ABCC0B907A0@bi-co.net>
 <CAJCQCtTZWXUgUDh8vn0BFeEbAdKToDSVYYw4Q0bt0rECQr9nxQ@mail.gmail.com>
 <AD966642-1043-468D-BABF-8FC9AF514D36@bi-co.net>
 <158a3491-e4d2-d905-7f58-11a15bddcd70@gmx.com>
 <C1CD4646-E75D-4AAF-9CD6-B3AC32495FD3@bi-co.net>
 <3142764D-5944-4004-BC57-C89C89AC9ED9@bi-co.net>
 <F170BB63-D9D7-4D08-9097-3C18815BE869@bi-co.net>
 <20190521190023.GA68070@glet>
 <20190521201226.GA23332@lobo>
 <CAK-xaQZ9PCLgzFw0-YJ=Yvou=t0k=Vv-9JY4n3=VD2s=NaYL4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK-xaQZ9PCLgzFw0-YJ=Yvou=t0k=Vv-9JY4n3=VD2s=NaYL4w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@linux.it>
Cc: Mike Snitzer <snitzer@redhat.com>, Michael =?iso-8859-1?B?TGHf?= <bevan@bi-co.net>, dm-devel@redhat.com, Chris Murphy <lists@colorremedies.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
List-Id: dm-devel.ids

On Fri, May 24, 2019 at 05:00:51PM +0200, Andrea Gelmini wrote:
> Hi Mike,
>    I'm doing setup to replicate and test the condition. I see your
> patch is already in the 5.2 dev kernel.
>    I'm going to try with latest git, and see what happens. Anyway,
> don't you this it would be good
>    to have this patch ( 51b86f9a8d1c4bb4e3862ee4b4c5f46072f7520d )
> anyway in the 5.1 stable branch?

It's already in the 5.1 stable queue and will be in the next 5.1 release
in a day or so.

thanks,

greg k-h
