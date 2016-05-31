From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: multipathd: Add 'sysfs' prioritizer
Date: Tue, 31 May 2016 22:34:14 +0200
Message-ID: <20160531223414.00004376@localhost>
References: <1463998828-28133-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1463998828-28133-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Sebastian Herbszt <herbszt@gmx.de>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Hannes Reinecke wrote:
> Recent kernels have an 'access_state' attribute which allows
> us to read the asymmetric access state directly from sysfs.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/discovery.c           | 33 +++++++++++++++++++++++++++++
>  libmultipath/discovery.h           |  2 ++
>  libmultipath/prio.h                |  1 +
>  libmultipath/prioritizers/Makefile |  3 ++-
>  libmultipath/prioritizers/sysfs.c  | 43 ++++++++++++++++++++++++++++++++++++++
>  libmultipath/propsel.c             |  6 +++++-
>  multipath/multipath.conf.5         | 14 ++++++++++++-
>  7 files changed, 99 insertions(+), 3 deletions(-)
>  create mode 100644 libmultipath/prioritizers/sysfs.c

How about just adding this to the alua prioritizer?
This new feature could then depend on a "sysfs" argument.

Sebastian
