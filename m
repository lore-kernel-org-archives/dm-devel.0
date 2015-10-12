From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Next-20151009 - crash during boot
Date: Mon, 12 Oct 2015 18:14:35 -0400
Message-ID: <20151012221435.GA9456@redhat.com>
References: <7951.1444686608@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7951.1444686608@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Oct 12 2015 at  5:50pm -0400,
Valdis Kletnieks <Valdis.Kletnieks@vt.edu> wrote:

> Next-20151009 crashes early in boot (right after I feed cryptsetup
> the passphrase for my root filesystem).
> 
> (Yes, the kernel is 10 commits past linux-next - they're all cleanup patches for
> drivers/staging that shouldn't enter into it)
> 
> It appears to possibly be the same one reported by the "Linux Test Robot",
> which called this out:
> 
> commit e817ef9b89e5bbfdb2a67ca9896909f414b2af91 ("dm ioctl: use kvfree() in free_params()")

Yes, that commit was dropped last week.  Today's linux-next won't have
this problem.  Feel free to revert e817ef9b89e5bbfdb2a67ca9896909 from
your local tree to work-around this.
