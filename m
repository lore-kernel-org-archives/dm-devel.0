From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: dmsetup fails on latest kernel
Date: Fri, 20 Jan 2012 15:35:49 +0200
Message-ID: <CALLzPKapudkuBxsF49jMAOtVpeu=hpa9SgY=WewtU6GYEm6M_Q@mail.gmail.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com>
	<CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
	<4F188817.3090104@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F188817.3090104@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
List-Id: dm-devel.ids

On Thu, Jan 19, 2012 at 11:16 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Here is a patch which should fix this problem. =C2=A0I will run a few=
 more
> tests and then push it with the rest of the urgent queue to Linus.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0-hpa

Hi,

Yes. It solves the problem..
Do you still want straces?

- Dmitry

>
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel. =C2=A0I don't speak on their behalf.
>
