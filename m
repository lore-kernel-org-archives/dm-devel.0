From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] dm ioctl: Delete an unnecessary check before the
 function call "dm_table_destroy"
Date: Sun, 8 Feb 2015 09:02:53 -0500
Message-ID: <CAMM=eLfpAiTeqvX17C3agsLXP03UD_Q7DnmhGnO5GjEC0pZa8Q@mail.gmail.com>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <54CF93BB.40206@users.sourceforge.net>
 <54CF9666.5060407@users.sourceforge.net> <20150206211234.GA14803@redhat.com> <54D7329C.206@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54D7329C.206@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, device-mapper development <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Sun, Feb 8, 2015 at 4:55 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>> Your proposed patch (while technically correct) hurts code clarity.
>
> How many source code readability and understanding challenges does each
> additional condition check cause?

Please don't make a mountain out of a mole hill in an attempt to
defend your robotic patch (I'm quite tired of some of these static
analyzer patch submissions).

FYI, I did stage your other patch for 3.20, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20&id=d0ce7e911c97c7c6df1081dcedfefced82a0c6bf

> Can the affected place become also a bit more efficient?

Efficiency isn't a concern in this instance (it isn't a hot IO path).
And even if it were, a branch (with current code) is more efficient vs
a a jump + branch (your proposed patch) -- in the case that no active
table exists.  Now if it likely that old_map does exist then yes your
patch is always a very slight win.

But given the duality of the calling function (deals with loading a
new map and destroying the old map if it exists) I prefer to keep the
code as is.  Sorry.
