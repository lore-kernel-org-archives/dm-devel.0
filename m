From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH 3/3] dm ioctl: Delete an unnecessary check before the
 function call "dm_table_destroy"
Date: Sun, 08 Feb 2015 16:52:20 +0100
Message-ID: <54D78634.5020705@users.sourceforge.net>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54CF93BB.40206@users.sourceforge.net> <54CF9666.5060407@users.sourceforge.net> <20150206211234.GA14803@redhat.com> <54D7329C.206@users.sourceforge.net> <CAMM=eLfpAiTeqvX17C3agsLXP03UD_Q7DnmhGnO5GjEC0pZa8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMM=eLfpAiTeqvX17C3agsLXP03UD_Q7DnmhGnO5GjEC0pZa8Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, device-mapper development <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

> FYI, I did stage your other patch for 3.20, see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20&id=d0ce7e911c97c7c6df1081dcedfefced82a0c6bf

Thanks for your acceptance of the suggested clean-up around
vfree() function calls at least.
Additional source code places can also be reconsidered at other times,
can't they?

Regards,
Markus
