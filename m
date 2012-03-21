From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm: remake of the verity target
Date: Tue, 20 Mar 2012 23:44:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1203202340160.15617@file.rdu.redhat.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com> <20120306215947.GB27051@google.com>
 <Pine.LNX.4.64.1203131742230.24876@file.rdu.redhat.com> <20120320154159.GD27051@google.com>
 <Pine.LNX.4.64.1203202045150.23255@file.rdu.redhat.com>
 <Pine.LNX.4.64.1203202233250.6371@file.rdu.redhat.com>
 <CACBanvrjZbDY+aUUyp9-YuG8KoEd9k-cn50kn8N=3DQxKf7QFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACBanvrjZbDY+aUUyp9-YuG8KoEd9k-cn50kn8N=3DQxKf7QFA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mandeep Singh Baines <msb@chromium.org>
Cc: device-mapper development <dm-devel@redhat.com>, Steffen Klassert <steffen.klassert@secunet.com>, Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, Elly Jones <ellyjones@chromium.org>, Olof Johansson <olofj@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Tue, 20 Mar 2012, Mandeep Singh Baines wrote:

> But we are hashing fixed-sized blocks so there is no possibility of extension.

If the first part of some block contains some security-sensitive data and 
the last part of the same block can be attacker-controlled, he can use the 
collision attack to change the security-sensitive data.

> However, better safe than sorry. I guess we'll just have to deal with
> backward incompatibility. So feel free to add my sign off to the new
> patch also.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> 
> Regards,
> Mandeep
> 
> > Mikulas

I can introduce a switch to make it accept the old format. Do you want to?

Mikulas
