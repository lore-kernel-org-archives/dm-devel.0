From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 0/2] multipathd: Add 'sysfs' prioritizer
Date: Fri, 3 Jun 2016 13:03:24 -0500
Message-ID: <20160603180324.GS26117@octiron.msp.redhat.com>
References: <1464942862-4469-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1464942862-4469-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Fri, Jun 03, 2016 at 10:34:20AM +0200, Hannes Reinecke wrote:
> Hi all,
> 
> hardly necessary to send an entire patchset, but there you go.
> I've now modified the sysfs prioritizer to generate the same
> priority the alua one would do, including the 'exclusive_pref_bit'
> setting.
> So this should address the issues Ben raised.

Thanks

ACK

-Ben

> 
> Hannes Reinecke (2):
>   alua prioritizer: Fix typo 'perf'
>   multipathd: Add 'sysfs' prioritizer
> 
>  libmultipath/discovery.c           | 33 +++++++++++++++++++++
>  libmultipath/discovery.h           |  2 ++
>  libmultipath/prio.h                |  1 +
>  libmultipath/prioritizers/Makefile |  3 +-
>  libmultipath/prioritizers/alua.c   |  8 ++---
>  libmultipath/prioritizers/sysfs.c  | 61 ++++++++++++++++++++++++++++++++++++++
>  libmultipath/propsel.c             |  6 +++-
>  multipath/multipath.conf.5         | 17 +++++++++--
>  8 files changed, 123 insertions(+), 8 deletions(-)
>  create mode 100644 libmultipath/prioritizers/sysfs.c
> 
> -- 
> 2.6.6
