From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 3/4] multipath-tools: Add rbd checker.
Date: Tue, 5 Jul 2016 17:02:47 +0200
Message-ID: <b839f2c2-4563-efa1-9a55-a46aab0cd4cd@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <mchristi@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Mike Christie wrote:

> This checker currently only handles the case where a path is failed
> due to it being blacklisted by the ceph cluster. The specific use
> case for me is when LIO exports rbd images through multiple LIO
> instances.

This new path checker must be documented at multipath/multipath.conf.5

Thank you.

> ---
>  libmultipath/checkers/Makefile |   6 +-
>  libmultipath/checkers/rbd.c    | 612 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 617 insertions(+), 1 deletion(-)
>  create mode 100644 libmultipath/checkers/rbd.c
