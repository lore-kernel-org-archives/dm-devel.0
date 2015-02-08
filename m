From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH 3/3] dm ioctl: Delete an unnecessary check before the
 function call "dm_table_destroy"
Date: Sun, 08 Feb 2015 10:55:40 +0100
Message-ID: <54D7329C.206@users.sourceforge.net>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54CF93BB.40206@users.sourceforge.net> <54CF9666.5060407@users.sourceforge.net> <20150206211234.GA14803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150206211234.GA14803@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

> Your proposed patch (while technically correct) hurts code clarity.

How many source code readability and understanding challenges does each
additional condition check cause?

Can the affected place become also a bit more efficient?

Regards,
Markus
