From: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH 1/9] I/O bandwidth controller and BIO tracking
Date: Mon, 14 Sep 2009 07:11:20 -0700
Message-ID: <1252937480.28368.221.camel@desktop>
References: <20090914.212805.193688121.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755568AbZINOKm@vger.kernel.org>
In-Reply-To: <20090914.212805.193688121.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, 2009-09-14 at 21:28 +0900, Ryo Tsuruta wrote:

> The list of the patches:
>   [PATCH 1/9] I/O bandwidth controller and BIO tracking
>   [PATCH 2/9] dm-ioband-1.13.0: All-in-one patch
>   [PATCH 3/9] blkio-cgroup-v12: The new page_cgroup framework
>   [PATCH 4/9] blkio-cgroup-v12: Refactoring io-context initialization
>   [PATCH 5/9] blkio-cgroup-v12: The body of blkio-cgroup
>   [PATCH 6/9] blkio-cgroup-v12: Page tracking hooks
>   [PATCH 7/9] blkio-cgroup-v12: The document of blkio-cgroup
>   [PATCH 8/9] blkio-cgroup-v12: Add a cgroup support to dm-ioband
>   [PATCH 9/9] blkio-cgroup-v12: The document of a cgroup support for dm-ioband


Patches 5, 8, and 9 all have checkpatch errors (2 does also but it
involves tracing, so Steven may not let you fix them). 

Could you correct those errors before this get included ?

Daniel
