From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [2.6 patch] drivers/md/kcopyd.c: remove kcopyd_cancel()
Date: Tue, 8 Nov 2005 15:48:28 +0000
Message-ID: <20051108154828.GX26394@agk.surrey.redhat.com>
References: <20051108134419.GR3847@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030222AbVKHPtw@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051108134419.GR3847@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Nov 08, 2005 at 02:44:19PM +0100, Adrian Bunk wrote:
> A function that is
> - not used
> - empty
> - without a prototype in any header file
> should be removed.
 
I'd rather you submitted a patch to complete the function and invoke it
in the appropriate place:-)  But please don't remove comments indicating 
missing functionality: commenting it out till it's written would be better.

Alasdair
-- 
agk@redhat.com

> -/*
> - * Cancels a kcopyd job, eg. someone might be deactivating a
> - * mirror.
> - */
> -int kcopyd_cancel(struct kcopyd_job *job, int block)
> -{
> -	/* FIXME: finish */
> -	return -1;
> -}
